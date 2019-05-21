
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
  80005a:	68 62 24 80 00       	push   $0x802462
  80005f:	e8 8d 1b 00 00       	call   801bf1 <printf>
  800064:	83 c4 10             	add    $0x10,%esp
	if(prefix) {
  800067:	85 db                	test   %ebx,%ebx
  800069:	74 1c                	je     800087 <ls1+0x54>
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
			sep = "/";
		else
			sep = "";
  80006b:	b8 ec 29 80 00       	mov    $0x8029ec,%eax
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  800070:	80 3b 00             	cmpb   $0x0,(%ebx)
  800073:	75 4b                	jne    8000c0 <ls1+0x8d>
		printf("%s%s", prefix, sep);
  800075:	83 ec 04             	sub    $0x4,%esp
  800078:	50                   	push   %eax
  800079:	53                   	push   %ebx
  80007a:	68 6b 24 80 00       	push   $0x80246b
  80007f:	e8 6d 1b 00 00       	call   801bf1 <printf>
  800084:	83 c4 10             	add    $0x10,%esp
	}
	printf("%s", name);
  800087:	83 ec 08             	sub    $0x8,%esp
  80008a:	ff 75 14             	pushl  0x14(%ebp)
  80008d:	68 9e 29 80 00       	push   $0x80299e
  800092:	e8 5a 1b 00 00       	call   801bf1 <printf>
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
  8000ac:	68 eb 29 80 00       	push   $0x8029eb
  8000b1:	e8 3b 1b 00 00       	call   801bf1 <printf>
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
  8000c4:	e8 c0 0a 00 00       	call   800b89 <strlen>
  8000c9:	83 c4 10             	add    $0x10,%esp
			sep = "";
  8000cc:	80 7c 03 ff 2f       	cmpb   $0x2f,-0x1(%ebx,%eax,1)
  8000d1:	b8 60 24 80 00       	mov    $0x802460,%eax
  8000d6:	ba ec 29 80 00       	mov    $0x8029ec,%edx
  8000db:	0f 44 c2             	cmove  %edx,%eax
  8000de:	eb 95                	jmp    800075 <ls1+0x42>
		printf("/");
  8000e0:	83 ec 0c             	sub    $0xc,%esp
  8000e3:	68 60 24 80 00       	push   $0x802460
  8000e8:	e8 04 1b 00 00       	call   801bf1 <printf>
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
  800104:	e8 45 19 00 00       	call   801a4e <open>
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
  800122:	e8 77 15 00 00       	call   80169e <readn>
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
  800161:	68 70 24 80 00       	push   $0x802470
  800166:	6a 1d                	push   $0x1d
  800168:	68 7c 24 80 00       	push   $0x80247c
  80016d:	e8 fb 01 00 00       	call   80036d <_panic>
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
  800181:	68 86 24 80 00       	push   $0x802486
  800186:	6a 22                	push   $0x22
  800188:	68 7c 24 80 00       	push   $0x80247c
  80018d:	e8 db 01 00 00       	call   80036d <_panic>
		panic("error reading directory %s: %e", path, n);
  800192:	83 ec 0c             	sub    $0xc,%esp
  800195:	50                   	push   %eax
  800196:	57                   	push   %edi
  800197:	68 cc 24 80 00       	push   $0x8024cc
  80019c:	6a 24                	push   $0x24
  80019e:	68 7c 24 80 00       	push   $0x80247c
  8001a3:	e8 c5 01 00 00       	call   80036d <_panic>

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
  8001bd:	e8 bf 16 00 00       	call   801881 <stat>
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
  8001fa:	68 a1 24 80 00       	push   $0x8024a1
  8001ff:	6a 0f                	push   $0xf
  800201:	68 7c 24 80 00       	push   $0x80247c
  800206:	e8 62 01 00 00       	call   80036d <_panic>
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
  800222:	68 ad 24 80 00       	push   $0x8024ad
  800227:	e8 c5 19 00 00       	call   801bf1 <printf>
	exit();
  80022c:	e8 2a 01 00 00       	call   80035b <exit>
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
  80024a:	e8 97 0f 00 00       	call   8011e6 <argstart>
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
  800263:	e8 ae 0f 00 00       	call   801216 <argnext>
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
  800293:	68 ec 29 80 00       	push   $0x8029ec
  800298:	68 60 24 80 00       	push   $0x802460
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
  8002d9:	e8 98 0c 00 00       	call   800f76 <sys_getenvid>
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

	// call user main routine
	umain(argc, argv);
  80033d:	83 ec 08             	sub    $0x8,%esp
  800340:	ff 75 0c             	pushl  0xc(%ebp)
  800343:	ff 75 08             	pushl  0x8(%ebp)
  800346:	e8 eb fe ff ff       	call   800236 <umain>

	// exit gracefully
	exit();
  80034b:	e8 0b 00 00 00       	call   80035b <exit>
}
  800350:	83 c4 10             	add    $0x10,%esp
  800353:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800356:	5b                   	pop    %ebx
  800357:	5e                   	pop    %esi
  800358:	5f                   	pop    %edi
  800359:	5d                   	pop    %ebp
  80035a:	c3                   	ret    

0080035b <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80035b:	55                   	push   %ebp
  80035c:	89 e5                	mov    %esp,%ebp
  80035e:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800361:	6a 00                	push   $0x0
  800363:	e8 cd 0b 00 00       	call   800f35 <sys_env_destroy>
}
  800368:	83 c4 10             	add    $0x10,%esp
  80036b:	c9                   	leave  
  80036c:	c3                   	ret    

0080036d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80036d:	55                   	push   %ebp
  80036e:	89 e5                	mov    %esp,%ebp
  800370:	56                   	push   %esi
  800371:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800372:	a1 20 44 80 00       	mov    0x804420,%eax
  800377:	8b 40 48             	mov    0x48(%eax),%eax
  80037a:	83 ec 04             	sub    $0x4,%esp
  80037d:	68 24 25 80 00       	push   $0x802524
  800382:	50                   	push   %eax
  800383:	68 f5 24 80 00       	push   $0x8024f5
  800388:	e8 d6 00 00 00       	call   800463 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80038d:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800390:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800396:	e8 db 0b 00 00       	call   800f76 <sys_getenvid>
  80039b:	83 c4 04             	add    $0x4,%esp
  80039e:	ff 75 0c             	pushl  0xc(%ebp)
  8003a1:	ff 75 08             	pushl  0x8(%ebp)
  8003a4:	56                   	push   %esi
  8003a5:	50                   	push   %eax
  8003a6:	68 00 25 80 00       	push   $0x802500
  8003ab:	e8 b3 00 00 00       	call   800463 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003b0:	83 c4 18             	add    $0x18,%esp
  8003b3:	53                   	push   %ebx
  8003b4:	ff 75 10             	pushl  0x10(%ebp)
  8003b7:	e8 56 00 00 00       	call   800412 <vcprintf>
	cprintf("\n");
  8003bc:	c7 04 24 eb 29 80 00 	movl   $0x8029eb,(%esp)
  8003c3:	e8 9b 00 00 00       	call   800463 <cprintf>
  8003c8:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003cb:	cc                   	int3   
  8003cc:	eb fd                	jmp    8003cb <_panic+0x5e>

008003ce <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8003ce:	55                   	push   %ebp
  8003cf:	89 e5                	mov    %esp,%ebp
  8003d1:	53                   	push   %ebx
  8003d2:	83 ec 04             	sub    $0x4,%esp
  8003d5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8003d8:	8b 13                	mov    (%ebx),%edx
  8003da:	8d 42 01             	lea    0x1(%edx),%eax
  8003dd:	89 03                	mov    %eax,(%ebx)
  8003df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003e2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003e6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003eb:	74 09                	je     8003f6 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8003ed:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003f4:	c9                   	leave  
  8003f5:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8003f6:	83 ec 08             	sub    $0x8,%esp
  8003f9:	68 ff 00 00 00       	push   $0xff
  8003fe:	8d 43 08             	lea    0x8(%ebx),%eax
  800401:	50                   	push   %eax
  800402:	e8 f1 0a 00 00       	call   800ef8 <sys_cputs>
		b->idx = 0;
  800407:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80040d:	83 c4 10             	add    $0x10,%esp
  800410:	eb db                	jmp    8003ed <putch+0x1f>

00800412 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800412:	55                   	push   %ebp
  800413:	89 e5                	mov    %esp,%ebp
  800415:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80041b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800422:	00 00 00 
	b.cnt = 0;
  800425:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80042c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80042f:	ff 75 0c             	pushl  0xc(%ebp)
  800432:	ff 75 08             	pushl  0x8(%ebp)
  800435:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80043b:	50                   	push   %eax
  80043c:	68 ce 03 80 00       	push   $0x8003ce
  800441:	e8 4a 01 00 00       	call   800590 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800446:	83 c4 08             	add    $0x8,%esp
  800449:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80044f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800455:	50                   	push   %eax
  800456:	e8 9d 0a 00 00       	call   800ef8 <sys_cputs>

	return b.cnt;
}
  80045b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800461:	c9                   	leave  
  800462:	c3                   	ret    

00800463 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800463:	55                   	push   %ebp
  800464:	89 e5                	mov    %esp,%ebp
  800466:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800469:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80046c:	50                   	push   %eax
  80046d:	ff 75 08             	pushl  0x8(%ebp)
  800470:	e8 9d ff ff ff       	call   800412 <vcprintf>
	va_end(ap);

	return cnt;
}
  800475:	c9                   	leave  
  800476:	c3                   	ret    

00800477 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800477:	55                   	push   %ebp
  800478:	89 e5                	mov    %esp,%ebp
  80047a:	57                   	push   %edi
  80047b:	56                   	push   %esi
  80047c:	53                   	push   %ebx
  80047d:	83 ec 1c             	sub    $0x1c,%esp
  800480:	89 c6                	mov    %eax,%esi
  800482:	89 d7                	mov    %edx,%edi
  800484:	8b 45 08             	mov    0x8(%ebp),%eax
  800487:	8b 55 0c             	mov    0xc(%ebp),%edx
  80048a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80048d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800490:	8b 45 10             	mov    0x10(%ebp),%eax
  800493:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800496:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80049a:	74 2c                	je     8004c8 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80049c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80049f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8004a6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004a9:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004ac:	39 c2                	cmp    %eax,%edx
  8004ae:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8004b1:	73 43                	jae    8004f6 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8004b3:	83 eb 01             	sub    $0x1,%ebx
  8004b6:	85 db                	test   %ebx,%ebx
  8004b8:	7e 6c                	jle    800526 <printnum+0xaf>
				putch(padc, putdat);
  8004ba:	83 ec 08             	sub    $0x8,%esp
  8004bd:	57                   	push   %edi
  8004be:	ff 75 18             	pushl  0x18(%ebp)
  8004c1:	ff d6                	call   *%esi
  8004c3:	83 c4 10             	add    $0x10,%esp
  8004c6:	eb eb                	jmp    8004b3 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8004c8:	83 ec 0c             	sub    $0xc,%esp
  8004cb:	6a 20                	push   $0x20
  8004cd:	6a 00                	push   $0x0
  8004cf:	50                   	push   %eax
  8004d0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004d3:	ff 75 e0             	pushl  -0x20(%ebp)
  8004d6:	89 fa                	mov    %edi,%edx
  8004d8:	89 f0                	mov    %esi,%eax
  8004da:	e8 98 ff ff ff       	call   800477 <printnum>
		while (--width > 0)
  8004df:	83 c4 20             	add    $0x20,%esp
  8004e2:	83 eb 01             	sub    $0x1,%ebx
  8004e5:	85 db                	test   %ebx,%ebx
  8004e7:	7e 65                	jle    80054e <printnum+0xd7>
			putch(padc, putdat);
  8004e9:	83 ec 08             	sub    $0x8,%esp
  8004ec:	57                   	push   %edi
  8004ed:	6a 20                	push   $0x20
  8004ef:	ff d6                	call   *%esi
  8004f1:	83 c4 10             	add    $0x10,%esp
  8004f4:	eb ec                	jmp    8004e2 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8004f6:	83 ec 0c             	sub    $0xc,%esp
  8004f9:	ff 75 18             	pushl  0x18(%ebp)
  8004fc:	83 eb 01             	sub    $0x1,%ebx
  8004ff:	53                   	push   %ebx
  800500:	50                   	push   %eax
  800501:	83 ec 08             	sub    $0x8,%esp
  800504:	ff 75 dc             	pushl  -0x24(%ebp)
  800507:	ff 75 d8             	pushl  -0x28(%ebp)
  80050a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80050d:	ff 75 e0             	pushl  -0x20(%ebp)
  800510:	e8 fb 1c 00 00       	call   802210 <__udivdi3>
  800515:	83 c4 18             	add    $0x18,%esp
  800518:	52                   	push   %edx
  800519:	50                   	push   %eax
  80051a:	89 fa                	mov    %edi,%edx
  80051c:	89 f0                	mov    %esi,%eax
  80051e:	e8 54 ff ff ff       	call   800477 <printnum>
  800523:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800526:	83 ec 08             	sub    $0x8,%esp
  800529:	57                   	push   %edi
  80052a:	83 ec 04             	sub    $0x4,%esp
  80052d:	ff 75 dc             	pushl  -0x24(%ebp)
  800530:	ff 75 d8             	pushl  -0x28(%ebp)
  800533:	ff 75 e4             	pushl  -0x1c(%ebp)
  800536:	ff 75 e0             	pushl  -0x20(%ebp)
  800539:	e8 e2 1d 00 00       	call   802320 <__umoddi3>
  80053e:	83 c4 14             	add    $0x14,%esp
  800541:	0f be 80 2b 25 80 00 	movsbl 0x80252b(%eax),%eax
  800548:	50                   	push   %eax
  800549:	ff d6                	call   *%esi
  80054b:	83 c4 10             	add    $0x10,%esp
	}
}
  80054e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800551:	5b                   	pop    %ebx
  800552:	5e                   	pop    %esi
  800553:	5f                   	pop    %edi
  800554:	5d                   	pop    %ebp
  800555:	c3                   	ret    

00800556 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800556:	55                   	push   %ebp
  800557:	89 e5                	mov    %esp,%ebp
  800559:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80055c:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800560:	8b 10                	mov    (%eax),%edx
  800562:	3b 50 04             	cmp    0x4(%eax),%edx
  800565:	73 0a                	jae    800571 <sprintputch+0x1b>
		*b->buf++ = ch;
  800567:	8d 4a 01             	lea    0x1(%edx),%ecx
  80056a:	89 08                	mov    %ecx,(%eax)
  80056c:	8b 45 08             	mov    0x8(%ebp),%eax
  80056f:	88 02                	mov    %al,(%edx)
}
  800571:	5d                   	pop    %ebp
  800572:	c3                   	ret    

00800573 <printfmt>:
{
  800573:	55                   	push   %ebp
  800574:	89 e5                	mov    %esp,%ebp
  800576:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800579:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80057c:	50                   	push   %eax
  80057d:	ff 75 10             	pushl  0x10(%ebp)
  800580:	ff 75 0c             	pushl  0xc(%ebp)
  800583:	ff 75 08             	pushl  0x8(%ebp)
  800586:	e8 05 00 00 00       	call   800590 <vprintfmt>
}
  80058b:	83 c4 10             	add    $0x10,%esp
  80058e:	c9                   	leave  
  80058f:	c3                   	ret    

00800590 <vprintfmt>:
{
  800590:	55                   	push   %ebp
  800591:	89 e5                	mov    %esp,%ebp
  800593:	57                   	push   %edi
  800594:	56                   	push   %esi
  800595:	53                   	push   %ebx
  800596:	83 ec 3c             	sub    $0x3c,%esp
  800599:	8b 75 08             	mov    0x8(%ebp),%esi
  80059c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80059f:	8b 7d 10             	mov    0x10(%ebp),%edi
  8005a2:	e9 32 04 00 00       	jmp    8009d9 <vprintfmt+0x449>
		padc = ' ';
  8005a7:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8005ab:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8005b2:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8005b9:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8005c0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005c7:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8005ce:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8005d3:	8d 47 01             	lea    0x1(%edi),%eax
  8005d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005d9:	0f b6 17             	movzbl (%edi),%edx
  8005dc:	8d 42 dd             	lea    -0x23(%edx),%eax
  8005df:	3c 55                	cmp    $0x55,%al
  8005e1:	0f 87 12 05 00 00    	ja     800af9 <vprintfmt+0x569>
  8005e7:	0f b6 c0             	movzbl %al,%eax
  8005ea:	ff 24 85 00 27 80 00 	jmp    *0x802700(,%eax,4)
  8005f1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8005f4:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8005f8:	eb d9                	jmp    8005d3 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8005fa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8005fd:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800601:	eb d0                	jmp    8005d3 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800603:	0f b6 d2             	movzbl %dl,%edx
  800606:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800609:	b8 00 00 00 00       	mov    $0x0,%eax
  80060e:	89 75 08             	mov    %esi,0x8(%ebp)
  800611:	eb 03                	jmp    800616 <vprintfmt+0x86>
  800613:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800616:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800619:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80061d:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800620:	8d 72 d0             	lea    -0x30(%edx),%esi
  800623:	83 fe 09             	cmp    $0x9,%esi
  800626:	76 eb                	jbe    800613 <vprintfmt+0x83>
  800628:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80062b:	8b 75 08             	mov    0x8(%ebp),%esi
  80062e:	eb 14                	jmp    800644 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800630:	8b 45 14             	mov    0x14(%ebp),%eax
  800633:	8b 00                	mov    (%eax),%eax
  800635:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800638:	8b 45 14             	mov    0x14(%ebp),%eax
  80063b:	8d 40 04             	lea    0x4(%eax),%eax
  80063e:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800641:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800644:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800648:	79 89                	jns    8005d3 <vprintfmt+0x43>
				width = precision, precision = -1;
  80064a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80064d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800650:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800657:	e9 77 ff ff ff       	jmp    8005d3 <vprintfmt+0x43>
  80065c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80065f:	85 c0                	test   %eax,%eax
  800661:	0f 48 c1             	cmovs  %ecx,%eax
  800664:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800667:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80066a:	e9 64 ff ff ff       	jmp    8005d3 <vprintfmt+0x43>
  80066f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800672:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800679:	e9 55 ff ff ff       	jmp    8005d3 <vprintfmt+0x43>
			lflag++;
  80067e:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800682:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800685:	e9 49 ff ff ff       	jmp    8005d3 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80068a:	8b 45 14             	mov    0x14(%ebp),%eax
  80068d:	8d 78 04             	lea    0x4(%eax),%edi
  800690:	83 ec 08             	sub    $0x8,%esp
  800693:	53                   	push   %ebx
  800694:	ff 30                	pushl  (%eax)
  800696:	ff d6                	call   *%esi
			break;
  800698:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80069b:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80069e:	e9 33 03 00 00       	jmp    8009d6 <vprintfmt+0x446>
			err = va_arg(ap, int);
  8006a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a6:	8d 78 04             	lea    0x4(%eax),%edi
  8006a9:	8b 00                	mov    (%eax),%eax
  8006ab:	99                   	cltd   
  8006ac:	31 d0                	xor    %edx,%eax
  8006ae:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8006b0:	83 f8 0f             	cmp    $0xf,%eax
  8006b3:	7f 23                	jg     8006d8 <vprintfmt+0x148>
  8006b5:	8b 14 85 60 28 80 00 	mov    0x802860(,%eax,4),%edx
  8006bc:	85 d2                	test   %edx,%edx
  8006be:	74 18                	je     8006d8 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8006c0:	52                   	push   %edx
  8006c1:	68 9e 29 80 00       	push   $0x80299e
  8006c6:	53                   	push   %ebx
  8006c7:	56                   	push   %esi
  8006c8:	e8 a6 fe ff ff       	call   800573 <printfmt>
  8006cd:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8006d0:	89 7d 14             	mov    %edi,0x14(%ebp)
  8006d3:	e9 fe 02 00 00       	jmp    8009d6 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8006d8:	50                   	push   %eax
  8006d9:	68 43 25 80 00       	push   $0x802543
  8006de:	53                   	push   %ebx
  8006df:	56                   	push   %esi
  8006e0:	e8 8e fe ff ff       	call   800573 <printfmt>
  8006e5:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8006e8:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8006eb:	e9 e6 02 00 00       	jmp    8009d6 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8006f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f3:	83 c0 04             	add    $0x4,%eax
  8006f6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8006f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fc:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8006fe:	85 c9                	test   %ecx,%ecx
  800700:	b8 3c 25 80 00       	mov    $0x80253c,%eax
  800705:	0f 45 c1             	cmovne %ecx,%eax
  800708:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80070b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80070f:	7e 06                	jle    800717 <vprintfmt+0x187>
  800711:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800715:	75 0d                	jne    800724 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800717:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80071a:	89 c7                	mov    %eax,%edi
  80071c:	03 45 e0             	add    -0x20(%ebp),%eax
  80071f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800722:	eb 53                	jmp    800777 <vprintfmt+0x1e7>
  800724:	83 ec 08             	sub    $0x8,%esp
  800727:	ff 75 d8             	pushl  -0x28(%ebp)
  80072a:	50                   	push   %eax
  80072b:	e8 71 04 00 00       	call   800ba1 <strnlen>
  800730:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800733:	29 c1                	sub    %eax,%ecx
  800735:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800738:	83 c4 10             	add    $0x10,%esp
  80073b:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80073d:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800741:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800744:	eb 0f                	jmp    800755 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800746:	83 ec 08             	sub    $0x8,%esp
  800749:	53                   	push   %ebx
  80074a:	ff 75 e0             	pushl  -0x20(%ebp)
  80074d:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80074f:	83 ef 01             	sub    $0x1,%edi
  800752:	83 c4 10             	add    $0x10,%esp
  800755:	85 ff                	test   %edi,%edi
  800757:	7f ed                	jg     800746 <vprintfmt+0x1b6>
  800759:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  80075c:	85 c9                	test   %ecx,%ecx
  80075e:	b8 00 00 00 00       	mov    $0x0,%eax
  800763:	0f 49 c1             	cmovns %ecx,%eax
  800766:	29 c1                	sub    %eax,%ecx
  800768:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80076b:	eb aa                	jmp    800717 <vprintfmt+0x187>
					putch(ch, putdat);
  80076d:	83 ec 08             	sub    $0x8,%esp
  800770:	53                   	push   %ebx
  800771:	52                   	push   %edx
  800772:	ff d6                	call   *%esi
  800774:	83 c4 10             	add    $0x10,%esp
  800777:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80077a:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80077c:	83 c7 01             	add    $0x1,%edi
  80077f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800783:	0f be d0             	movsbl %al,%edx
  800786:	85 d2                	test   %edx,%edx
  800788:	74 4b                	je     8007d5 <vprintfmt+0x245>
  80078a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80078e:	78 06                	js     800796 <vprintfmt+0x206>
  800790:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800794:	78 1e                	js     8007b4 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800796:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80079a:	74 d1                	je     80076d <vprintfmt+0x1dd>
  80079c:	0f be c0             	movsbl %al,%eax
  80079f:	83 e8 20             	sub    $0x20,%eax
  8007a2:	83 f8 5e             	cmp    $0x5e,%eax
  8007a5:	76 c6                	jbe    80076d <vprintfmt+0x1dd>
					putch('?', putdat);
  8007a7:	83 ec 08             	sub    $0x8,%esp
  8007aa:	53                   	push   %ebx
  8007ab:	6a 3f                	push   $0x3f
  8007ad:	ff d6                	call   *%esi
  8007af:	83 c4 10             	add    $0x10,%esp
  8007b2:	eb c3                	jmp    800777 <vprintfmt+0x1e7>
  8007b4:	89 cf                	mov    %ecx,%edi
  8007b6:	eb 0e                	jmp    8007c6 <vprintfmt+0x236>
				putch(' ', putdat);
  8007b8:	83 ec 08             	sub    $0x8,%esp
  8007bb:	53                   	push   %ebx
  8007bc:	6a 20                	push   $0x20
  8007be:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8007c0:	83 ef 01             	sub    $0x1,%edi
  8007c3:	83 c4 10             	add    $0x10,%esp
  8007c6:	85 ff                	test   %edi,%edi
  8007c8:	7f ee                	jg     8007b8 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8007ca:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8007cd:	89 45 14             	mov    %eax,0x14(%ebp)
  8007d0:	e9 01 02 00 00       	jmp    8009d6 <vprintfmt+0x446>
  8007d5:	89 cf                	mov    %ecx,%edi
  8007d7:	eb ed                	jmp    8007c6 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8007d9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8007dc:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8007e3:	e9 eb fd ff ff       	jmp    8005d3 <vprintfmt+0x43>
	if (lflag >= 2)
  8007e8:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007ec:	7f 21                	jg     80080f <vprintfmt+0x27f>
	else if (lflag)
  8007ee:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007f2:	74 68                	je     80085c <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8007f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f7:	8b 00                	mov    (%eax),%eax
  8007f9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8007fc:	89 c1                	mov    %eax,%ecx
  8007fe:	c1 f9 1f             	sar    $0x1f,%ecx
  800801:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800804:	8b 45 14             	mov    0x14(%ebp),%eax
  800807:	8d 40 04             	lea    0x4(%eax),%eax
  80080a:	89 45 14             	mov    %eax,0x14(%ebp)
  80080d:	eb 17                	jmp    800826 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  80080f:	8b 45 14             	mov    0x14(%ebp),%eax
  800812:	8b 50 04             	mov    0x4(%eax),%edx
  800815:	8b 00                	mov    (%eax),%eax
  800817:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80081a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80081d:	8b 45 14             	mov    0x14(%ebp),%eax
  800820:	8d 40 08             	lea    0x8(%eax),%eax
  800823:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800826:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800829:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80082c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80082f:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800832:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800836:	78 3f                	js     800877 <vprintfmt+0x2e7>
			base = 10;
  800838:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  80083d:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800841:	0f 84 71 01 00 00    	je     8009b8 <vprintfmt+0x428>
				putch('+', putdat);
  800847:	83 ec 08             	sub    $0x8,%esp
  80084a:	53                   	push   %ebx
  80084b:	6a 2b                	push   $0x2b
  80084d:	ff d6                	call   *%esi
  80084f:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800852:	b8 0a 00 00 00       	mov    $0xa,%eax
  800857:	e9 5c 01 00 00       	jmp    8009b8 <vprintfmt+0x428>
		return va_arg(*ap, int);
  80085c:	8b 45 14             	mov    0x14(%ebp),%eax
  80085f:	8b 00                	mov    (%eax),%eax
  800861:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800864:	89 c1                	mov    %eax,%ecx
  800866:	c1 f9 1f             	sar    $0x1f,%ecx
  800869:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80086c:	8b 45 14             	mov    0x14(%ebp),%eax
  80086f:	8d 40 04             	lea    0x4(%eax),%eax
  800872:	89 45 14             	mov    %eax,0x14(%ebp)
  800875:	eb af                	jmp    800826 <vprintfmt+0x296>
				putch('-', putdat);
  800877:	83 ec 08             	sub    $0x8,%esp
  80087a:	53                   	push   %ebx
  80087b:	6a 2d                	push   $0x2d
  80087d:	ff d6                	call   *%esi
				num = -(long long) num;
  80087f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800882:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800885:	f7 d8                	neg    %eax
  800887:	83 d2 00             	adc    $0x0,%edx
  80088a:	f7 da                	neg    %edx
  80088c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80088f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800892:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800895:	b8 0a 00 00 00       	mov    $0xa,%eax
  80089a:	e9 19 01 00 00       	jmp    8009b8 <vprintfmt+0x428>
	if (lflag >= 2)
  80089f:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8008a3:	7f 29                	jg     8008ce <vprintfmt+0x33e>
	else if (lflag)
  8008a5:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8008a9:	74 44                	je     8008ef <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8008ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ae:	8b 00                	mov    (%eax),%eax
  8008b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8008b5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008b8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008be:	8d 40 04             	lea    0x4(%eax),%eax
  8008c1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008c4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008c9:	e9 ea 00 00 00       	jmp    8009b8 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8008ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d1:	8b 50 04             	mov    0x4(%eax),%edx
  8008d4:	8b 00                	mov    (%eax),%eax
  8008d6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008d9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008df:	8d 40 08             	lea    0x8(%eax),%eax
  8008e2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008e5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008ea:	e9 c9 00 00 00       	jmp    8009b8 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8008ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f2:	8b 00                	mov    (%eax),%eax
  8008f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008fc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800902:	8d 40 04             	lea    0x4(%eax),%eax
  800905:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800908:	b8 0a 00 00 00       	mov    $0xa,%eax
  80090d:	e9 a6 00 00 00       	jmp    8009b8 <vprintfmt+0x428>
			putch('0', putdat);
  800912:	83 ec 08             	sub    $0x8,%esp
  800915:	53                   	push   %ebx
  800916:	6a 30                	push   $0x30
  800918:	ff d6                	call   *%esi
	if (lflag >= 2)
  80091a:	83 c4 10             	add    $0x10,%esp
  80091d:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800921:	7f 26                	jg     800949 <vprintfmt+0x3b9>
	else if (lflag)
  800923:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800927:	74 3e                	je     800967 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800929:	8b 45 14             	mov    0x14(%ebp),%eax
  80092c:	8b 00                	mov    (%eax),%eax
  80092e:	ba 00 00 00 00       	mov    $0x0,%edx
  800933:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800936:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800939:	8b 45 14             	mov    0x14(%ebp),%eax
  80093c:	8d 40 04             	lea    0x4(%eax),%eax
  80093f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800942:	b8 08 00 00 00       	mov    $0x8,%eax
  800947:	eb 6f                	jmp    8009b8 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800949:	8b 45 14             	mov    0x14(%ebp),%eax
  80094c:	8b 50 04             	mov    0x4(%eax),%edx
  80094f:	8b 00                	mov    (%eax),%eax
  800951:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800954:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800957:	8b 45 14             	mov    0x14(%ebp),%eax
  80095a:	8d 40 08             	lea    0x8(%eax),%eax
  80095d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800960:	b8 08 00 00 00       	mov    $0x8,%eax
  800965:	eb 51                	jmp    8009b8 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800967:	8b 45 14             	mov    0x14(%ebp),%eax
  80096a:	8b 00                	mov    (%eax),%eax
  80096c:	ba 00 00 00 00       	mov    $0x0,%edx
  800971:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800974:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800977:	8b 45 14             	mov    0x14(%ebp),%eax
  80097a:	8d 40 04             	lea    0x4(%eax),%eax
  80097d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800980:	b8 08 00 00 00       	mov    $0x8,%eax
  800985:	eb 31                	jmp    8009b8 <vprintfmt+0x428>
			putch('0', putdat);
  800987:	83 ec 08             	sub    $0x8,%esp
  80098a:	53                   	push   %ebx
  80098b:	6a 30                	push   $0x30
  80098d:	ff d6                	call   *%esi
			putch('x', putdat);
  80098f:	83 c4 08             	add    $0x8,%esp
  800992:	53                   	push   %ebx
  800993:	6a 78                	push   $0x78
  800995:	ff d6                	call   *%esi
			num = (unsigned long long)
  800997:	8b 45 14             	mov    0x14(%ebp),%eax
  80099a:	8b 00                	mov    (%eax),%eax
  80099c:	ba 00 00 00 00       	mov    $0x0,%edx
  8009a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009a4:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8009a7:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8009aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ad:	8d 40 04             	lea    0x4(%eax),%eax
  8009b0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009b3:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8009b8:	83 ec 0c             	sub    $0xc,%esp
  8009bb:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8009bf:	52                   	push   %edx
  8009c0:	ff 75 e0             	pushl  -0x20(%ebp)
  8009c3:	50                   	push   %eax
  8009c4:	ff 75 dc             	pushl  -0x24(%ebp)
  8009c7:	ff 75 d8             	pushl  -0x28(%ebp)
  8009ca:	89 da                	mov    %ebx,%edx
  8009cc:	89 f0                	mov    %esi,%eax
  8009ce:	e8 a4 fa ff ff       	call   800477 <printnum>
			break;
  8009d3:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8009d6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009d9:	83 c7 01             	add    $0x1,%edi
  8009dc:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8009e0:	83 f8 25             	cmp    $0x25,%eax
  8009e3:	0f 84 be fb ff ff    	je     8005a7 <vprintfmt+0x17>
			if (ch == '\0')
  8009e9:	85 c0                	test   %eax,%eax
  8009eb:	0f 84 28 01 00 00    	je     800b19 <vprintfmt+0x589>
			putch(ch, putdat);
  8009f1:	83 ec 08             	sub    $0x8,%esp
  8009f4:	53                   	push   %ebx
  8009f5:	50                   	push   %eax
  8009f6:	ff d6                	call   *%esi
  8009f8:	83 c4 10             	add    $0x10,%esp
  8009fb:	eb dc                	jmp    8009d9 <vprintfmt+0x449>
	if (lflag >= 2)
  8009fd:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800a01:	7f 26                	jg     800a29 <vprintfmt+0x499>
	else if (lflag)
  800a03:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800a07:	74 41                	je     800a4a <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800a09:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0c:	8b 00                	mov    (%eax),%eax
  800a0e:	ba 00 00 00 00       	mov    $0x0,%edx
  800a13:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a16:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a19:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1c:	8d 40 04             	lea    0x4(%eax),%eax
  800a1f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a22:	b8 10 00 00 00       	mov    $0x10,%eax
  800a27:	eb 8f                	jmp    8009b8 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800a29:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2c:	8b 50 04             	mov    0x4(%eax),%edx
  800a2f:	8b 00                	mov    (%eax),%eax
  800a31:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a34:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a37:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3a:	8d 40 08             	lea    0x8(%eax),%eax
  800a3d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a40:	b8 10 00 00 00       	mov    $0x10,%eax
  800a45:	e9 6e ff ff ff       	jmp    8009b8 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800a4a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4d:	8b 00                	mov    (%eax),%eax
  800a4f:	ba 00 00 00 00       	mov    $0x0,%edx
  800a54:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a57:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a5a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5d:	8d 40 04             	lea    0x4(%eax),%eax
  800a60:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a63:	b8 10 00 00 00       	mov    $0x10,%eax
  800a68:	e9 4b ff ff ff       	jmp    8009b8 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800a6d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a70:	83 c0 04             	add    $0x4,%eax
  800a73:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a76:	8b 45 14             	mov    0x14(%ebp),%eax
  800a79:	8b 00                	mov    (%eax),%eax
  800a7b:	85 c0                	test   %eax,%eax
  800a7d:	74 14                	je     800a93 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800a7f:	8b 13                	mov    (%ebx),%edx
  800a81:	83 fa 7f             	cmp    $0x7f,%edx
  800a84:	7f 37                	jg     800abd <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800a86:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800a88:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a8b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a8e:	e9 43 ff ff ff       	jmp    8009d6 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800a93:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a98:	bf 61 26 80 00       	mov    $0x802661,%edi
							putch(ch, putdat);
  800a9d:	83 ec 08             	sub    $0x8,%esp
  800aa0:	53                   	push   %ebx
  800aa1:	50                   	push   %eax
  800aa2:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800aa4:	83 c7 01             	add    $0x1,%edi
  800aa7:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800aab:	83 c4 10             	add    $0x10,%esp
  800aae:	85 c0                	test   %eax,%eax
  800ab0:	75 eb                	jne    800a9d <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800ab2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800ab5:	89 45 14             	mov    %eax,0x14(%ebp)
  800ab8:	e9 19 ff ff ff       	jmp    8009d6 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800abd:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800abf:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ac4:	bf 99 26 80 00       	mov    $0x802699,%edi
							putch(ch, putdat);
  800ac9:	83 ec 08             	sub    $0x8,%esp
  800acc:	53                   	push   %ebx
  800acd:	50                   	push   %eax
  800ace:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800ad0:	83 c7 01             	add    $0x1,%edi
  800ad3:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800ad7:	83 c4 10             	add    $0x10,%esp
  800ada:	85 c0                	test   %eax,%eax
  800adc:	75 eb                	jne    800ac9 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800ade:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800ae1:	89 45 14             	mov    %eax,0x14(%ebp)
  800ae4:	e9 ed fe ff ff       	jmp    8009d6 <vprintfmt+0x446>
			putch(ch, putdat);
  800ae9:	83 ec 08             	sub    $0x8,%esp
  800aec:	53                   	push   %ebx
  800aed:	6a 25                	push   $0x25
  800aef:	ff d6                	call   *%esi
			break;
  800af1:	83 c4 10             	add    $0x10,%esp
  800af4:	e9 dd fe ff ff       	jmp    8009d6 <vprintfmt+0x446>
			putch('%', putdat);
  800af9:	83 ec 08             	sub    $0x8,%esp
  800afc:	53                   	push   %ebx
  800afd:	6a 25                	push   $0x25
  800aff:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b01:	83 c4 10             	add    $0x10,%esp
  800b04:	89 f8                	mov    %edi,%eax
  800b06:	eb 03                	jmp    800b0b <vprintfmt+0x57b>
  800b08:	83 e8 01             	sub    $0x1,%eax
  800b0b:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800b0f:	75 f7                	jne    800b08 <vprintfmt+0x578>
  800b11:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b14:	e9 bd fe ff ff       	jmp    8009d6 <vprintfmt+0x446>
}
  800b19:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b1c:	5b                   	pop    %ebx
  800b1d:	5e                   	pop    %esi
  800b1e:	5f                   	pop    %edi
  800b1f:	5d                   	pop    %ebp
  800b20:	c3                   	ret    

00800b21 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b21:	55                   	push   %ebp
  800b22:	89 e5                	mov    %esp,%ebp
  800b24:	83 ec 18             	sub    $0x18,%esp
  800b27:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2a:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b2d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b30:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b34:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b37:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b3e:	85 c0                	test   %eax,%eax
  800b40:	74 26                	je     800b68 <vsnprintf+0x47>
  800b42:	85 d2                	test   %edx,%edx
  800b44:	7e 22                	jle    800b68 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b46:	ff 75 14             	pushl  0x14(%ebp)
  800b49:	ff 75 10             	pushl  0x10(%ebp)
  800b4c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b4f:	50                   	push   %eax
  800b50:	68 56 05 80 00       	push   $0x800556
  800b55:	e8 36 fa ff ff       	call   800590 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b5d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b63:	83 c4 10             	add    $0x10,%esp
}
  800b66:	c9                   	leave  
  800b67:	c3                   	ret    
		return -E_INVAL;
  800b68:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b6d:	eb f7                	jmp    800b66 <vsnprintf+0x45>

00800b6f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b6f:	55                   	push   %ebp
  800b70:	89 e5                	mov    %esp,%ebp
  800b72:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b75:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800b78:	50                   	push   %eax
  800b79:	ff 75 10             	pushl  0x10(%ebp)
  800b7c:	ff 75 0c             	pushl  0xc(%ebp)
  800b7f:	ff 75 08             	pushl  0x8(%ebp)
  800b82:	e8 9a ff ff ff       	call   800b21 <vsnprintf>
	va_end(ap);

	return rc;
}
  800b87:	c9                   	leave  
  800b88:	c3                   	ret    

00800b89 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b89:	55                   	push   %ebp
  800b8a:	89 e5                	mov    %esp,%ebp
  800b8c:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b8f:	b8 00 00 00 00       	mov    $0x0,%eax
  800b94:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b98:	74 05                	je     800b9f <strlen+0x16>
		n++;
  800b9a:	83 c0 01             	add    $0x1,%eax
  800b9d:	eb f5                	jmp    800b94 <strlen+0xb>
	return n;
}
  800b9f:	5d                   	pop    %ebp
  800ba0:	c3                   	ret    

00800ba1 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ba1:	55                   	push   %ebp
  800ba2:	89 e5                	mov    %esp,%ebp
  800ba4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ba7:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800baa:	ba 00 00 00 00       	mov    $0x0,%edx
  800baf:	39 c2                	cmp    %eax,%edx
  800bb1:	74 0d                	je     800bc0 <strnlen+0x1f>
  800bb3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800bb7:	74 05                	je     800bbe <strnlen+0x1d>
		n++;
  800bb9:	83 c2 01             	add    $0x1,%edx
  800bbc:	eb f1                	jmp    800baf <strnlen+0xe>
  800bbe:	89 d0                	mov    %edx,%eax
	return n;
}
  800bc0:	5d                   	pop    %ebp
  800bc1:	c3                   	ret    

00800bc2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bc2:	55                   	push   %ebp
  800bc3:	89 e5                	mov    %esp,%ebp
  800bc5:	53                   	push   %ebx
  800bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800bcc:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd1:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800bd5:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800bd8:	83 c2 01             	add    $0x1,%edx
  800bdb:	84 c9                	test   %cl,%cl
  800bdd:	75 f2                	jne    800bd1 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800bdf:	5b                   	pop    %ebx
  800be0:	5d                   	pop    %ebp
  800be1:	c3                   	ret    

00800be2 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800be2:	55                   	push   %ebp
  800be3:	89 e5                	mov    %esp,%ebp
  800be5:	53                   	push   %ebx
  800be6:	83 ec 10             	sub    $0x10,%esp
  800be9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800bec:	53                   	push   %ebx
  800bed:	e8 97 ff ff ff       	call   800b89 <strlen>
  800bf2:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800bf5:	ff 75 0c             	pushl  0xc(%ebp)
  800bf8:	01 d8                	add    %ebx,%eax
  800bfa:	50                   	push   %eax
  800bfb:	e8 c2 ff ff ff       	call   800bc2 <strcpy>
	return dst;
}
  800c00:	89 d8                	mov    %ebx,%eax
  800c02:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c05:	c9                   	leave  
  800c06:	c3                   	ret    

00800c07 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c07:	55                   	push   %ebp
  800c08:	89 e5                	mov    %esp,%ebp
  800c0a:	56                   	push   %esi
  800c0b:	53                   	push   %ebx
  800c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c12:	89 c6                	mov    %eax,%esi
  800c14:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c17:	89 c2                	mov    %eax,%edx
  800c19:	39 f2                	cmp    %esi,%edx
  800c1b:	74 11                	je     800c2e <strncpy+0x27>
		*dst++ = *src;
  800c1d:	83 c2 01             	add    $0x1,%edx
  800c20:	0f b6 19             	movzbl (%ecx),%ebx
  800c23:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c26:	80 fb 01             	cmp    $0x1,%bl
  800c29:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800c2c:	eb eb                	jmp    800c19 <strncpy+0x12>
	}
	return ret;
}
  800c2e:	5b                   	pop    %ebx
  800c2f:	5e                   	pop    %esi
  800c30:	5d                   	pop    %ebp
  800c31:	c3                   	ret    

00800c32 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c32:	55                   	push   %ebp
  800c33:	89 e5                	mov    %esp,%ebp
  800c35:	56                   	push   %esi
  800c36:	53                   	push   %ebx
  800c37:	8b 75 08             	mov    0x8(%ebp),%esi
  800c3a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c3d:	8b 55 10             	mov    0x10(%ebp),%edx
  800c40:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c42:	85 d2                	test   %edx,%edx
  800c44:	74 21                	je     800c67 <strlcpy+0x35>
  800c46:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800c4a:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800c4c:	39 c2                	cmp    %eax,%edx
  800c4e:	74 14                	je     800c64 <strlcpy+0x32>
  800c50:	0f b6 19             	movzbl (%ecx),%ebx
  800c53:	84 db                	test   %bl,%bl
  800c55:	74 0b                	je     800c62 <strlcpy+0x30>
			*dst++ = *src++;
  800c57:	83 c1 01             	add    $0x1,%ecx
  800c5a:	83 c2 01             	add    $0x1,%edx
  800c5d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800c60:	eb ea                	jmp    800c4c <strlcpy+0x1a>
  800c62:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800c64:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c67:	29 f0                	sub    %esi,%eax
}
  800c69:	5b                   	pop    %ebx
  800c6a:	5e                   	pop    %esi
  800c6b:	5d                   	pop    %ebp
  800c6c:	c3                   	ret    

00800c6d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c6d:	55                   	push   %ebp
  800c6e:	89 e5                	mov    %esp,%ebp
  800c70:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c73:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c76:	0f b6 01             	movzbl (%ecx),%eax
  800c79:	84 c0                	test   %al,%al
  800c7b:	74 0c                	je     800c89 <strcmp+0x1c>
  800c7d:	3a 02                	cmp    (%edx),%al
  800c7f:	75 08                	jne    800c89 <strcmp+0x1c>
		p++, q++;
  800c81:	83 c1 01             	add    $0x1,%ecx
  800c84:	83 c2 01             	add    $0x1,%edx
  800c87:	eb ed                	jmp    800c76 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c89:	0f b6 c0             	movzbl %al,%eax
  800c8c:	0f b6 12             	movzbl (%edx),%edx
  800c8f:	29 d0                	sub    %edx,%eax
}
  800c91:	5d                   	pop    %ebp
  800c92:	c3                   	ret    

00800c93 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c93:	55                   	push   %ebp
  800c94:	89 e5                	mov    %esp,%ebp
  800c96:	53                   	push   %ebx
  800c97:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c9d:	89 c3                	mov    %eax,%ebx
  800c9f:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800ca2:	eb 06                	jmp    800caa <strncmp+0x17>
		n--, p++, q++;
  800ca4:	83 c0 01             	add    $0x1,%eax
  800ca7:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800caa:	39 d8                	cmp    %ebx,%eax
  800cac:	74 16                	je     800cc4 <strncmp+0x31>
  800cae:	0f b6 08             	movzbl (%eax),%ecx
  800cb1:	84 c9                	test   %cl,%cl
  800cb3:	74 04                	je     800cb9 <strncmp+0x26>
  800cb5:	3a 0a                	cmp    (%edx),%cl
  800cb7:	74 eb                	je     800ca4 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800cb9:	0f b6 00             	movzbl (%eax),%eax
  800cbc:	0f b6 12             	movzbl (%edx),%edx
  800cbf:	29 d0                	sub    %edx,%eax
}
  800cc1:	5b                   	pop    %ebx
  800cc2:	5d                   	pop    %ebp
  800cc3:	c3                   	ret    
		return 0;
  800cc4:	b8 00 00 00 00       	mov    $0x0,%eax
  800cc9:	eb f6                	jmp    800cc1 <strncmp+0x2e>

00800ccb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ccb:	55                   	push   %ebp
  800ccc:	89 e5                	mov    %esp,%ebp
  800cce:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cd5:	0f b6 10             	movzbl (%eax),%edx
  800cd8:	84 d2                	test   %dl,%dl
  800cda:	74 09                	je     800ce5 <strchr+0x1a>
		if (*s == c)
  800cdc:	38 ca                	cmp    %cl,%dl
  800cde:	74 0a                	je     800cea <strchr+0x1f>
	for (; *s; s++)
  800ce0:	83 c0 01             	add    $0x1,%eax
  800ce3:	eb f0                	jmp    800cd5 <strchr+0xa>
			return (char *) s;
	return 0;
  800ce5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cea:	5d                   	pop    %ebp
  800ceb:	c3                   	ret    

00800cec <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cec:	55                   	push   %ebp
  800ced:	89 e5                	mov    %esp,%ebp
  800cef:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf2:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cf6:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800cf9:	38 ca                	cmp    %cl,%dl
  800cfb:	74 09                	je     800d06 <strfind+0x1a>
  800cfd:	84 d2                	test   %dl,%dl
  800cff:	74 05                	je     800d06 <strfind+0x1a>
	for (; *s; s++)
  800d01:	83 c0 01             	add    $0x1,%eax
  800d04:	eb f0                	jmp    800cf6 <strfind+0xa>
			break;
	return (char *) s;
}
  800d06:	5d                   	pop    %ebp
  800d07:	c3                   	ret    

00800d08 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d08:	55                   	push   %ebp
  800d09:	89 e5                	mov    %esp,%ebp
  800d0b:	57                   	push   %edi
  800d0c:	56                   	push   %esi
  800d0d:	53                   	push   %ebx
  800d0e:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d11:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d14:	85 c9                	test   %ecx,%ecx
  800d16:	74 31                	je     800d49 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d18:	89 f8                	mov    %edi,%eax
  800d1a:	09 c8                	or     %ecx,%eax
  800d1c:	a8 03                	test   $0x3,%al
  800d1e:	75 23                	jne    800d43 <memset+0x3b>
		c &= 0xFF;
  800d20:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d24:	89 d3                	mov    %edx,%ebx
  800d26:	c1 e3 08             	shl    $0x8,%ebx
  800d29:	89 d0                	mov    %edx,%eax
  800d2b:	c1 e0 18             	shl    $0x18,%eax
  800d2e:	89 d6                	mov    %edx,%esi
  800d30:	c1 e6 10             	shl    $0x10,%esi
  800d33:	09 f0                	or     %esi,%eax
  800d35:	09 c2                	or     %eax,%edx
  800d37:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d39:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800d3c:	89 d0                	mov    %edx,%eax
  800d3e:	fc                   	cld    
  800d3f:	f3 ab                	rep stos %eax,%es:(%edi)
  800d41:	eb 06                	jmp    800d49 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d46:	fc                   	cld    
  800d47:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d49:	89 f8                	mov    %edi,%eax
  800d4b:	5b                   	pop    %ebx
  800d4c:	5e                   	pop    %esi
  800d4d:	5f                   	pop    %edi
  800d4e:	5d                   	pop    %ebp
  800d4f:	c3                   	ret    

00800d50 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d50:	55                   	push   %ebp
  800d51:	89 e5                	mov    %esp,%ebp
  800d53:	57                   	push   %edi
  800d54:	56                   	push   %esi
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d5b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d5e:	39 c6                	cmp    %eax,%esi
  800d60:	73 32                	jae    800d94 <memmove+0x44>
  800d62:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d65:	39 c2                	cmp    %eax,%edx
  800d67:	76 2b                	jbe    800d94 <memmove+0x44>
		s += n;
		d += n;
  800d69:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d6c:	89 fe                	mov    %edi,%esi
  800d6e:	09 ce                	or     %ecx,%esi
  800d70:	09 d6                	or     %edx,%esi
  800d72:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d78:	75 0e                	jne    800d88 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d7a:	83 ef 04             	sub    $0x4,%edi
  800d7d:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d80:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800d83:	fd                   	std    
  800d84:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d86:	eb 09                	jmp    800d91 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d88:	83 ef 01             	sub    $0x1,%edi
  800d8b:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800d8e:	fd                   	std    
  800d8f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d91:	fc                   	cld    
  800d92:	eb 1a                	jmp    800dae <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d94:	89 c2                	mov    %eax,%edx
  800d96:	09 ca                	or     %ecx,%edx
  800d98:	09 f2                	or     %esi,%edx
  800d9a:	f6 c2 03             	test   $0x3,%dl
  800d9d:	75 0a                	jne    800da9 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d9f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800da2:	89 c7                	mov    %eax,%edi
  800da4:	fc                   	cld    
  800da5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800da7:	eb 05                	jmp    800dae <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800da9:	89 c7                	mov    %eax,%edi
  800dab:	fc                   	cld    
  800dac:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800dae:	5e                   	pop    %esi
  800daf:	5f                   	pop    %edi
  800db0:	5d                   	pop    %ebp
  800db1:	c3                   	ret    

00800db2 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800db2:	55                   	push   %ebp
  800db3:	89 e5                	mov    %esp,%ebp
  800db5:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800db8:	ff 75 10             	pushl  0x10(%ebp)
  800dbb:	ff 75 0c             	pushl  0xc(%ebp)
  800dbe:	ff 75 08             	pushl  0x8(%ebp)
  800dc1:	e8 8a ff ff ff       	call   800d50 <memmove>
}
  800dc6:	c9                   	leave  
  800dc7:	c3                   	ret    

00800dc8 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800dc8:	55                   	push   %ebp
  800dc9:	89 e5                	mov    %esp,%ebp
  800dcb:	56                   	push   %esi
  800dcc:	53                   	push   %ebx
  800dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dd3:	89 c6                	mov    %eax,%esi
  800dd5:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800dd8:	39 f0                	cmp    %esi,%eax
  800dda:	74 1c                	je     800df8 <memcmp+0x30>
		if (*s1 != *s2)
  800ddc:	0f b6 08             	movzbl (%eax),%ecx
  800ddf:	0f b6 1a             	movzbl (%edx),%ebx
  800de2:	38 d9                	cmp    %bl,%cl
  800de4:	75 08                	jne    800dee <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800de6:	83 c0 01             	add    $0x1,%eax
  800de9:	83 c2 01             	add    $0x1,%edx
  800dec:	eb ea                	jmp    800dd8 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800dee:	0f b6 c1             	movzbl %cl,%eax
  800df1:	0f b6 db             	movzbl %bl,%ebx
  800df4:	29 d8                	sub    %ebx,%eax
  800df6:	eb 05                	jmp    800dfd <memcmp+0x35>
	}

	return 0;
  800df8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dfd:	5b                   	pop    %ebx
  800dfe:	5e                   	pop    %esi
  800dff:	5d                   	pop    %ebp
  800e00:	c3                   	ret    

00800e01 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e01:	55                   	push   %ebp
  800e02:	89 e5                	mov    %esp,%ebp
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
  800e07:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800e0a:	89 c2                	mov    %eax,%edx
  800e0c:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e0f:	39 d0                	cmp    %edx,%eax
  800e11:	73 09                	jae    800e1c <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e13:	38 08                	cmp    %cl,(%eax)
  800e15:	74 05                	je     800e1c <memfind+0x1b>
	for (; s < ends; s++)
  800e17:	83 c0 01             	add    $0x1,%eax
  800e1a:	eb f3                	jmp    800e0f <memfind+0xe>
			break;
	return (void *) s;
}
  800e1c:	5d                   	pop    %ebp
  800e1d:	c3                   	ret    

00800e1e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e1e:	55                   	push   %ebp
  800e1f:	89 e5                	mov    %esp,%ebp
  800e21:	57                   	push   %edi
  800e22:	56                   	push   %esi
  800e23:	53                   	push   %ebx
  800e24:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e27:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e2a:	eb 03                	jmp    800e2f <strtol+0x11>
		s++;
  800e2c:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800e2f:	0f b6 01             	movzbl (%ecx),%eax
  800e32:	3c 20                	cmp    $0x20,%al
  800e34:	74 f6                	je     800e2c <strtol+0xe>
  800e36:	3c 09                	cmp    $0x9,%al
  800e38:	74 f2                	je     800e2c <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800e3a:	3c 2b                	cmp    $0x2b,%al
  800e3c:	74 2a                	je     800e68 <strtol+0x4a>
	int neg = 0;
  800e3e:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800e43:	3c 2d                	cmp    $0x2d,%al
  800e45:	74 2b                	je     800e72 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e47:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800e4d:	75 0f                	jne    800e5e <strtol+0x40>
  800e4f:	80 39 30             	cmpb   $0x30,(%ecx)
  800e52:	74 28                	je     800e7c <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e54:	85 db                	test   %ebx,%ebx
  800e56:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e5b:	0f 44 d8             	cmove  %eax,%ebx
  800e5e:	b8 00 00 00 00       	mov    $0x0,%eax
  800e63:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800e66:	eb 50                	jmp    800eb8 <strtol+0x9a>
		s++;
  800e68:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800e6b:	bf 00 00 00 00       	mov    $0x0,%edi
  800e70:	eb d5                	jmp    800e47 <strtol+0x29>
		s++, neg = 1;
  800e72:	83 c1 01             	add    $0x1,%ecx
  800e75:	bf 01 00 00 00       	mov    $0x1,%edi
  800e7a:	eb cb                	jmp    800e47 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e7c:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800e80:	74 0e                	je     800e90 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800e82:	85 db                	test   %ebx,%ebx
  800e84:	75 d8                	jne    800e5e <strtol+0x40>
		s++, base = 8;
  800e86:	83 c1 01             	add    $0x1,%ecx
  800e89:	bb 08 00 00 00       	mov    $0x8,%ebx
  800e8e:	eb ce                	jmp    800e5e <strtol+0x40>
		s += 2, base = 16;
  800e90:	83 c1 02             	add    $0x2,%ecx
  800e93:	bb 10 00 00 00       	mov    $0x10,%ebx
  800e98:	eb c4                	jmp    800e5e <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800e9a:	8d 72 9f             	lea    -0x61(%edx),%esi
  800e9d:	89 f3                	mov    %esi,%ebx
  800e9f:	80 fb 19             	cmp    $0x19,%bl
  800ea2:	77 29                	ja     800ecd <strtol+0xaf>
			dig = *s - 'a' + 10;
  800ea4:	0f be d2             	movsbl %dl,%edx
  800ea7:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800eaa:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ead:	7d 30                	jge    800edf <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800eaf:	83 c1 01             	add    $0x1,%ecx
  800eb2:	0f af 45 10          	imul   0x10(%ebp),%eax
  800eb6:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800eb8:	0f b6 11             	movzbl (%ecx),%edx
  800ebb:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ebe:	89 f3                	mov    %esi,%ebx
  800ec0:	80 fb 09             	cmp    $0x9,%bl
  800ec3:	77 d5                	ja     800e9a <strtol+0x7c>
			dig = *s - '0';
  800ec5:	0f be d2             	movsbl %dl,%edx
  800ec8:	83 ea 30             	sub    $0x30,%edx
  800ecb:	eb dd                	jmp    800eaa <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800ecd:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ed0:	89 f3                	mov    %esi,%ebx
  800ed2:	80 fb 19             	cmp    $0x19,%bl
  800ed5:	77 08                	ja     800edf <strtol+0xc1>
			dig = *s - 'A' + 10;
  800ed7:	0f be d2             	movsbl %dl,%edx
  800eda:	83 ea 37             	sub    $0x37,%edx
  800edd:	eb cb                	jmp    800eaa <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800edf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ee3:	74 05                	je     800eea <strtol+0xcc>
		*endptr = (char *) s;
  800ee5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ee8:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800eea:	89 c2                	mov    %eax,%edx
  800eec:	f7 da                	neg    %edx
  800eee:	85 ff                	test   %edi,%edi
  800ef0:	0f 45 c2             	cmovne %edx,%eax
}
  800ef3:	5b                   	pop    %ebx
  800ef4:	5e                   	pop    %esi
  800ef5:	5f                   	pop    %edi
  800ef6:	5d                   	pop    %ebp
  800ef7:	c3                   	ret    

00800ef8 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ef8:	55                   	push   %ebp
  800ef9:	89 e5                	mov    %esp,%ebp
  800efb:	57                   	push   %edi
  800efc:	56                   	push   %esi
  800efd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800efe:	b8 00 00 00 00       	mov    $0x0,%eax
  800f03:	8b 55 08             	mov    0x8(%ebp),%edx
  800f06:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f09:	89 c3                	mov    %eax,%ebx
  800f0b:	89 c7                	mov    %eax,%edi
  800f0d:	89 c6                	mov    %eax,%esi
  800f0f:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800f11:	5b                   	pop    %ebx
  800f12:	5e                   	pop    %esi
  800f13:	5f                   	pop    %edi
  800f14:	5d                   	pop    %ebp
  800f15:	c3                   	ret    

00800f16 <sys_cgetc>:

int
sys_cgetc(void)
{
  800f16:	55                   	push   %ebp
  800f17:	89 e5                	mov    %esp,%ebp
  800f19:	57                   	push   %edi
  800f1a:	56                   	push   %esi
  800f1b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f1c:	ba 00 00 00 00       	mov    $0x0,%edx
  800f21:	b8 01 00 00 00       	mov    $0x1,%eax
  800f26:	89 d1                	mov    %edx,%ecx
  800f28:	89 d3                	mov    %edx,%ebx
  800f2a:	89 d7                	mov    %edx,%edi
  800f2c:	89 d6                	mov    %edx,%esi
  800f2e:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800f30:	5b                   	pop    %ebx
  800f31:	5e                   	pop    %esi
  800f32:	5f                   	pop    %edi
  800f33:	5d                   	pop    %ebp
  800f34:	c3                   	ret    

00800f35 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800f35:	55                   	push   %ebp
  800f36:	89 e5                	mov    %esp,%ebp
  800f38:	57                   	push   %edi
  800f39:	56                   	push   %esi
  800f3a:	53                   	push   %ebx
  800f3b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f3e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f43:	8b 55 08             	mov    0x8(%ebp),%edx
  800f46:	b8 03 00 00 00       	mov    $0x3,%eax
  800f4b:	89 cb                	mov    %ecx,%ebx
  800f4d:	89 cf                	mov    %ecx,%edi
  800f4f:	89 ce                	mov    %ecx,%esi
  800f51:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f53:	85 c0                	test   %eax,%eax
  800f55:	7f 08                	jg     800f5f <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800f57:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f5a:	5b                   	pop    %ebx
  800f5b:	5e                   	pop    %esi
  800f5c:	5f                   	pop    %edi
  800f5d:	5d                   	pop    %ebp
  800f5e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f5f:	83 ec 0c             	sub    $0xc,%esp
  800f62:	50                   	push   %eax
  800f63:	6a 03                	push   $0x3
  800f65:	68 a0 28 80 00       	push   $0x8028a0
  800f6a:	6a 43                	push   $0x43
  800f6c:	68 bd 28 80 00       	push   $0x8028bd
  800f71:	e8 f7 f3 ff ff       	call   80036d <_panic>

00800f76 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800f76:	55                   	push   %ebp
  800f77:	89 e5                	mov    %esp,%ebp
  800f79:	57                   	push   %edi
  800f7a:	56                   	push   %esi
  800f7b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f7c:	ba 00 00 00 00       	mov    $0x0,%edx
  800f81:	b8 02 00 00 00       	mov    $0x2,%eax
  800f86:	89 d1                	mov    %edx,%ecx
  800f88:	89 d3                	mov    %edx,%ebx
  800f8a:	89 d7                	mov    %edx,%edi
  800f8c:	89 d6                	mov    %edx,%esi
  800f8e:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800f90:	5b                   	pop    %ebx
  800f91:	5e                   	pop    %esi
  800f92:	5f                   	pop    %edi
  800f93:	5d                   	pop    %ebp
  800f94:	c3                   	ret    

00800f95 <sys_yield>:

void
sys_yield(void)
{
  800f95:	55                   	push   %ebp
  800f96:	89 e5                	mov    %esp,%ebp
  800f98:	57                   	push   %edi
  800f99:	56                   	push   %esi
  800f9a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f9b:	ba 00 00 00 00       	mov    $0x0,%edx
  800fa0:	b8 0b 00 00 00       	mov    $0xb,%eax
  800fa5:	89 d1                	mov    %edx,%ecx
  800fa7:	89 d3                	mov    %edx,%ebx
  800fa9:	89 d7                	mov    %edx,%edi
  800fab:	89 d6                	mov    %edx,%esi
  800fad:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800faf:	5b                   	pop    %ebx
  800fb0:	5e                   	pop    %esi
  800fb1:	5f                   	pop    %edi
  800fb2:	5d                   	pop    %ebp
  800fb3:	c3                   	ret    

00800fb4 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800fb4:	55                   	push   %ebp
  800fb5:	89 e5                	mov    %esp,%ebp
  800fb7:	57                   	push   %edi
  800fb8:	56                   	push   %esi
  800fb9:	53                   	push   %ebx
  800fba:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fbd:	be 00 00 00 00       	mov    $0x0,%esi
  800fc2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc8:	b8 04 00 00 00       	mov    $0x4,%eax
  800fcd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fd0:	89 f7                	mov    %esi,%edi
  800fd2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fd4:	85 c0                	test   %eax,%eax
  800fd6:	7f 08                	jg     800fe0 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800fd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fdb:	5b                   	pop    %ebx
  800fdc:	5e                   	pop    %esi
  800fdd:	5f                   	pop    %edi
  800fde:	5d                   	pop    %ebp
  800fdf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fe0:	83 ec 0c             	sub    $0xc,%esp
  800fe3:	50                   	push   %eax
  800fe4:	6a 04                	push   $0x4
  800fe6:	68 a0 28 80 00       	push   $0x8028a0
  800feb:	6a 43                	push   $0x43
  800fed:	68 bd 28 80 00       	push   $0x8028bd
  800ff2:	e8 76 f3 ff ff       	call   80036d <_panic>

00800ff7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ff7:	55                   	push   %ebp
  800ff8:	89 e5                	mov    %esp,%ebp
  800ffa:	57                   	push   %edi
  800ffb:	56                   	push   %esi
  800ffc:	53                   	push   %ebx
  800ffd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801000:	8b 55 08             	mov    0x8(%ebp),%edx
  801003:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801006:	b8 05 00 00 00       	mov    $0x5,%eax
  80100b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80100e:	8b 7d 14             	mov    0x14(%ebp),%edi
  801011:	8b 75 18             	mov    0x18(%ebp),%esi
  801014:	cd 30                	int    $0x30
	if(check && ret > 0)
  801016:	85 c0                	test   %eax,%eax
  801018:	7f 08                	jg     801022 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80101a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80101d:	5b                   	pop    %ebx
  80101e:	5e                   	pop    %esi
  80101f:	5f                   	pop    %edi
  801020:	5d                   	pop    %ebp
  801021:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801022:	83 ec 0c             	sub    $0xc,%esp
  801025:	50                   	push   %eax
  801026:	6a 05                	push   $0x5
  801028:	68 a0 28 80 00       	push   $0x8028a0
  80102d:	6a 43                	push   $0x43
  80102f:	68 bd 28 80 00       	push   $0x8028bd
  801034:	e8 34 f3 ff ff       	call   80036d <_panic>

00801039 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801039:	55                   	push   %ebp
  80103a:	89 e5                	mov    %esp,%ebp
  80103c:	57                   	push   %edi
  80103d:	56                   	push   %esi
  80103e:	53                   	push   %ebx
  80103f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801042:	bb 00 00 00 00       	mov    $0x0,%ebx
  801047:	8b 55 08             	mov    0x8(%ebp),%edx
  80104a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80104d:	b8 06 00 00 00       	mov    $0x6,%eax
  801052:	89 df                	mov    %ebx,%edi
  801054:	89 de                	mov    %ebx,%esi
  801056:	cd 30                	int    $0x30
	if(check && ret > 0)
  801058:	85 c0                	test   %eax,%eax
  80105a:	7f 08                	jg     801064 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80105c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80105f:	5b                   	pop    %ebx
  801060:	5e                   	pop    %esi
  801061:	5f                   	pop    %edi
  801062:	5d                   	pop    %ebp
  801063:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801064:	83 ec 0c             	sub    $0xc,%esp
  801067:	50                   	push   %eax
  801068:	6a 06                	push   $0x6
  80106a:	68 a0 28 80 00       	push   $0x8028a0
  80106f:	6a 43                	push   $0x43
  801071:	68 bd 28 80 00       	push   $0x8028bd
  801076:	e8 f2 f2 ff ff       	call   80036d <_panic>

0080107b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80107b:	55                   	push   %ebp
  80107c:	89 e5                	mov    %esp,%ebp
  80107e:	57                   	push   %edi
  80107f:	56                   	push   %esi
  801080:	53                   	push   %ebx
  801081:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801084:	bb 00 00 00 00       	mov    $0x0,%ebx
  801089:	8b 55 08             	mov    0x8(%ebp),%edx
  80108c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80108f:	b8 08 00 00 00       	mov    $0x8,%eax
  801094:	89 df                	mov    %ebx,%edi
  801096:	89 de                	mov    %ebx,%esi
  801098:	cd 30                	int    $0x30
	if(check && ret > 0)
  80109a:	85 c0                	test   %eax,%eax
  80109c:	7f 08                	jg     8010a6 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80109e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010a1:	5b                   	pop    %ebx
  8010a2:	5e                   	pop    %esi
  8010a3:	5f                   	pop    %edi
  8010a4:	5d                   	pop    %ebp
  8010a5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010a6:	83 ec 0c             	sub    $0xc,%esp
  8010a9:	50                   	push   %eax
  8010aa:	6a 08                	push   $0x8
  8010ac:	68 a0 28 80 00       	push   $0x8028a0
  8010b1:	6a 43                	push   $0x43
  8010b3:	68 bd 28 80 00       	push   $0x8028bd
  8010b8:	e8 b0 f2 ff ff       	call   80036d <_panic>

008010bd <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8010bd:	55                   	push   %ebp
  8010be:	89 e5                	mov    %esp,%ebp
  8010c0:	57                   	push   %edi
  8010c1:	56                   	push   %esi
  8010c2:	53                   	push   %ebx
  8010c3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010c6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010d1:	b8 09 00 00 00       	mov    $0x9,%eax
  8010d6:	89 df                	mov    %ebx,%edi
  8010d8:	89 de                	mov    %ebx,%esi
  8010da:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010dc:	85 c0                	test   %eax,%eax
  8010de:	7f 08                	jg     8010e8 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8010e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010e3:	5b                   	pop    %ebx
  8010e4:	5e                   	pop    %esi
  8010e5:	5f                   	pop    %edi
  8010e6:	5d                   	pop    %ebp
  8010e7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010e8:	83 ec 0c             	sub    $0xc,%esp
  8010eb:	50                   	push   %eax
  8010ec:	6a 09                	push   $0x9
  8010ee:	68 a0 28 80 00       	push   $0x8028a0
  8010f3:	6a 43                	push   $0x43
  8010f5:	68 bd 28 80 00       	push   $0x8028bd
  8010fa:	e8 6e f2 ff ff       	call   80036d <_panic>

008010ff <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8010ff:	55                   	push   %ebp
  801100:	89 e5                	mov    %esp,%ebp
  801102:	57                   	push   %edi
  801103:	56                   	push   %esi
  801104:	53                   	push   %ebx
  801105:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801108:	bb 00 00 00 00       	mov    $0x0,%ebx
  80110d:	8b 55 08             	mov    0x8(%ebp),%edx
  801110:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801113:	b8 0a 00 00 00       	mov    $0xa,%eax
  801118:	89 df                	mov    %ebx,%edi
  80111a:	89 de                	mov    %ebx,%esi
  80111c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80111e:	85 c0                	test   %eax,%eax
  801120:	7f 08                	jg     80112a <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801122:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801125:	5b                   	pop    %ebx
  801126:	5e                   	pop    %esi
  801127:	5f                   	pop    %edi
  801128:	5d                   	pop    %ebp
  801129:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80112a:	83 ec 0c             	sub    $0xc,%esp
  80112d:	50                   	push   %eax
  80112e:	6a 0a                	push   $0xa
  801130:	68 a0 28 80 00       	push   $0x8028a0
  801135:	6a 43                	push   $0x43
  801137:	68 bd 28 80 00       	push   $0x8028bd
  80113c:	e8 2c f2 ff ff       	call   80036d <_panic>

00801141 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801141:	55                   	push   %ebp
  801142:	89 e5                	mov    %esp,%ebp
  801144:	57                   	push   %edi
  801145:	56                   	push   %esi
  801146:	53                   	push   %ebx
	asm volatile("int %1\n"
  801147:	8b 55 08             	mov    0x8(%ebp),%edx
  80114a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80114d:	b8 0c 00 00 00       	mov    $0xc,%eax
  801152:	be 00 00 00 00       	mov    $0x0,%esi
  801157:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80115a:	8b 7d 14             	mov    0x14(%ebp),%edi
  80115d:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80115f:	5b                   	pop    %ebx
  801160:	5e                   	pop    %esi
  801161:	5f                   	pop    %edi
  801162:	5d                   	pop    %ebp
  801163:	c3                   	ret    

00801164 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801164:	55                   	push   %ebp
  801165:	89 e5                	mov    %esp,%ebp
  801167:	57                   	push   %edi
  801168:	56                   	push   %esi
  801169:	53                   	push   %ebx
  80116a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80116d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801172:	8b 55 08             	mov    0x8(%ebp),%edx
  801175:	b8 0d 00 00 00       	mov    $0xd,%eax
  80117a:	89 cb                	mov    %ecx,%ebx
  80117c:	89 cf                	mov    %ecx,%edi
  80117e:	89 ce                	mov    %ecx,%esi
  801180:	cd 30                	int    $0x30
	if(check && ret > 0)
  801182:	85 c0                	test   %eax,%eax
  801184:	7f 08                	jg     80118e <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801186:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801189:	5b                   	pop    %ebx
  80118a:	5e                   	pop    %esi
  80118b:	5f                   	pop    %edi
  80118c:	5d                   	pop    %ebp
  80118d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80118e:	83 ec 0c             	sub    $0xc,%esp
  801191:	50                   	push   %eax
  801192:	6a 0d                	push   $0xd
  801194:	68 a0 28 80 00       	push   $0x8028a0
  801199:	6a 43                	push   $0x43
  80119b:	68 bd 28 80 00       	push   $0x8028bd
  8011a0:	e8 c8 f1 ff ff       	call   80036d <_panic>

008011a5 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  8011a5:	55                   	push   %ebp
  8011a6:	89 e5                	mov    %esp,%ebp
  8011a8:	57                   	push   %edi
  8011a9:	56                   	push   %esi
  8011aa:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011ab:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011b6:	b8 0e 00 00 00       	mov    $0xe,%eax
  8011bb:	89 df                	mov    %ebx,%edi
  8011bd:	89 de                	mov    %ebx,%esi
  8011bf:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8011c1:	5b                   	pop    %ebx
  8011c2:	5e                   	pop    %esi
  8011c3:	5f                   	pop    %edi
  8011c4:	5d                   	pop    %ebp
  8011c5:	c3                   	ret    

008011c6 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8011c6:	55                   	push   %ebp
  8011c7:	89 e5                	mov    %esp,%ebp
  8011c9:	57                   	push   %edi
  8011ca:	56                   	push   %esi
  8011cb:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011cc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8011d4:	b8 0f 00 00 00       	mov    $0xf,%eax
  8011d9:	89 cb                	mov    %ecx,%ebx
  8011db:	89 cf                	mov    %ecx,%edi
  8011dd:	89 ce                	mov    %ecx,%esi
  8011df:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8011e1:	5b                   	pop    %ebx
  8011e2:	5e                   	pop    %esi
  8011e3:	5f                   	pop    %edi
  8011e4:	5d                   	pop    %ebp
  8011e5:	c3                   	ret    

008011e6 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  8011e6:	55                   	push   %ebp
  8011e7:	89 e5                	mov    %esp,%ebp
  8011e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011ef:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  8011f2:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  8011f4:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  8011f7:	83 3a 01             	cmpl   $0x1,(%edx)
  8011fa:	7e 09                	jle    801205 <argstart+0x1f>
  8011fc:	ba ec 29 80 00       	mov    $0x8029ec,%edx
  801201:	85 c9                	test   %ecx,%ecx
  801203:	75 05                	jne    80120a <argstart+0x24>
  801205:	ba 00 00 00 00       	mov    $0x0,%edx
  80120a:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  80120d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  801214:	5d                   	pop    %ebp
  801215:	c3                   	ret    

00801216 <argnext>:

int
argnext(struct Argstate *args)
{
  801216:	55                   	push   %ebp
  801217:	89 e5                	mov    %esp,%ebp
  801219:	53                   	push   %ebx
  80121a:	83 ec 04             	sub    $0x4,%esp
  80121d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  801220:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801227:	8b 43 08             	mov    0x8(%ebx),%eax
  80122a:	85 c0                	test   %eax,%eax
  80122c:	74 72                	je     8012a0 <argnext+0x8a>
		return -1;

	if (!*args->curarg) {
  80122e:	80 38 00             	cmpb   $0x0,(%eax)
  801231:	75 48                	jne    80127b <argnext+0x65>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801233:	8b 0b                	mov    (%ebx),%ecx
  801235:	83 39 01             	cmpl   $0x1,(%ecx)
  801238:	74 58                	je     801292 <argnext+0x7c>
		    || args->argv[1][0] != '-'
  80123a:	8b 53 04             	mov    0x4(%ebx),%edx
  80123d:	8b 42 04             	mov    0x4(%edx),%eax
  801240:	80 38 2d             	cmpb   $0x2d,(%eax)
  801243:	75 4d                	jne    801292 <argnext+0x7c>
		    || args->argv[1][1] == '\0')
  801245:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801249:	74 47                	je     801292 <argnext+0x7c>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  80124b:	83 c0 01             	add    $0x1,%eax
  80124e:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801251:	83 ec 04             	sub    $0x4,%esp
  801254:	8b 01                	mov    (%ecx),%eax
  801256:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  80125d:	50                   	push   %eax
  80125e:	8d 42 08             	lea    0x8(%edx),%eax
  801261:	50                   	push   %eax
  801262:	83 c2 04             	add    $0x4,%edx
  801265:	52                   	push   %edx
  801266:	e8 e5 fa ff ff       	call   800d50 <memmove>
		(*args->argc)--;
  80126b:	8b 03                	mov    (%ebx),%eax
  80126d:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801270:	8b 43 08             	mov    0x8(%ebx),%eax
  801273:	83 c4 10             	add    $0x10,%esp
  801276:	80 38 2d             	cmpb   $0x2d,(%eax)
  801279:	74 11                	je     80128c <argnext+0x76>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  80127b:	8b 53 08             	mov    0x8(%ebx),%edx
  80127e:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  801281:	83 c2 01             	add    $0x1,%edx
  801284:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  801287:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80128a:	c9                   	leave  
  80128b:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  80128c:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801290:	75 e9                	jne    80127b <argnext+0x65>
	args->curarg = 0;
  801292:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  801299:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80129e:	eb e7                	jmp    801287 <argnext+0x71>
		return -1;
  8012a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8012a5:	eb e0                	jmp    801287 <argnext+0x71>

008012a7 <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  8012a7:	55                   	push   %ebp
  8012a8:	89 e5                	mov    %esp,%ebp
  8012aa:	53                   	push   %ebx
  8012ab:	83 ec 04             	sub    $0x4,%esp
  8012ae:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  8012b1:	8b 43 08             	mov    0x8(%ebx),%eax
  8012b4:	85 c0                	test   %eax,%eax
  8012b6:	74 12                	je     8012ca <argnextvalue+0x23>
		return 0;
	if (*args->curarg) {
  8012b8:	80 38 00             	cmpb   $0x0,(%eax)
  8012bb:	74 12                	je     8012cf <argnextvalue+0x28>
		args->argvalue = args->curarg;
  8012bd:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  8012c0:	c7 43 08 ec 29 80 00 	movl   $0x8029ec,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  8012c7:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  8012ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012cd:	c9                   	leave  
  8012ce:	c3                   	ret    
	} else if (*args->argc > 1) {
  8012cf:	8b 13                	mov    (%ebx),%edx
  8012d1:	83 3a 01             	cmpl   $0x1,(%edx)
  8012d4:	7f 10                	jg     8012e6 <argnextvalue+0x3f>
		args->argvalue = 0;
  8012d6:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  8012dd:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  8012e4:	eb e1                	jmp    8012c7 <argnextvalue+0x20>
		args->argvalue = args->argv[1];
  8012e6:	8b 43 04             	mov    0x4(%ebx),%eax
  8012e9:	8b 48 04             	mov    0x4(%eax),%ecx
  8012ec:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8012ef:	83 ec 04             	sub    $0x4,%esp
  8012f2:	8b 12                	mov    (%edx),%edx
  8012f4:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  8012fb:	52                   	push   %edx
  8012fc:	8d 50 08             	lea    0x8(%eax),%edx
  8012ff:	52                   	push   %edx
  801300:	83 c0 04             	add    $0x4,%eax
  801303:	50                   	push   %eax
  801304:	e8 47 fa ff ff       	call   800d50 <memmove>
		(*args->argc)--;
  801309:	8b 03                	mov    (%ebx),%eax
  80130b:	83 28 01             	subl   $0x1,(%eax)
  80130e:	83 c4 10             	add    $0x10,%esp
  801311:	eb b4                	jmp    8012c7 <argnextvalue+0x20>

00801313 <argvalue>:
{
  801313:	55                   	push   %ebp
  801314:	89 e5                	mov    %esp,%ebp
  801316:	83 ec 08             	sub    $0x8,%esp
  801319:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  80131c:	8b 42 0c             	mov    0xc(%edx),%eax
  80131f:	85 c0                	test   %eax,%eax
  801321:	74 02                	je     801325 <argvalue+0x12>
}
  801323:	c9                   	leave  
  801324:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801325:	83 ec 0c             	sub    $0xc,%esp
  801328:	52                   	push   %edx
  801329:	e8 79 ff ff ff       	call   8012a7 <argnextvalue>
  80132e:	83 c4 10             	add    $0x10,%esp
  801331:	eb f0                	jmp    801323 <argvalue+0x10>

00801333 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801333:	55                   	push   %ebp
  801334:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801336:	8b 45 08             	mov    0x8(%ebp),%eax
  801339:	05 00 00 00 30       	add    $0x30000000,%eax
  80133e:	c1 e8 0c             	shr    $0xc,%eax
}
  801341:	5d                   	pop    %ebp
  801342:	c3                   	ret    

00801343 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801343:	55                   	push   %ebp
  801344:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801346:	8b 45 08             	mov    0x8(%ebp),%eax
  801349:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80134e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801353:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801358:	5d                   	pop    %ebp
  801359:	c3                   	ret    

0080135a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80135a:	55                   	push   %ebp
  80135b:	89 e5                	mov    %esp,%ebp
  80135d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801362:	89 c2                	mov    %eax,%edx
  801364:	c1 ea 16             	shr    $0x16,%edx
  801367:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80136e:	f6 c2 01             	test   $0x1,%dl
  801371:	74 2d                	je     8013a0 <fd_alloc+0x46>
  801373:	89 c2                	mov    %eax,%edx
  801375:	c1 ea 0c             	shr    $0xc,%edx
  801378:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80137f:	f6 c2 01             	test   $0x1,%dl
  801382:	74 1c                	je     8013a0 <fd_alloc+0x46>
  801384:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801389:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80138e:	75 d2                	jne    801362 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801390:	8b 45 08             	mov    0x8(%ebp),%eax
  801393:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801399:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80139e:	eb 0a                	jmp    8013aa <fd_alloc+0x50>
			*fd_store = fd;
  8013a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013a3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013aa:	5d                   	pop    %ebp
  8013ab:	c3                   	ret    

008013ac <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8013ac:	55                   	push   %ebp
  8013ad:	89 e5                	mov    %esp,%ebp
  8013af:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8013b2:	83 f8 1f             	cmp    $0x1f,%eax
  8013b5:	77 30                	ja     8013e7 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8013b7:	c1 e0 0c             	shl    $0xc,%eax
  8013ba:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8013bf:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8013c5:	f6 c2 01             	test   $0x1,%dl
  8013c8:	74 24                	je     8013ee <fd_lookup+0x42>
  8013ca:	89 c2                	mov    %eax,%edx
  8013cc:	c1 ea 0c             	shr    $0xc,%edx
  8013cf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013d6:	f6 c2 01             	test   $0x1,%dl
  8013d9:	74 1a                	je     8013f5 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8013db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013de:	89 02                	mov    %eax,(%edx)
	return 0;
  8013e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013e5:	5d                   	pop    %ebp
  8013e6:	c3                   	ret    
		return -E_INVAL;
  8013e7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013ec:	eb f7                	jmp    8013e5 <fd_lookup+0x39>
		return -E_INVAL;
  8013ee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013f3:	eb f0                	jmp    8013e5 <fd_lookup+0x39>
  8013f5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013fa:	eb e9                	jmp    8013e5 <fd_lookup+0x39>

008013fc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8013fc:	55                   	push   %ebp
  8013fd:	89 e5                	mov    %esp,%ebp
  8013ff:	83 ec 08             	sub    $0x8,%esp
  801402:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801405:	ba 4c 29 80 00       	mov    $0x80294c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80140a:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80140f:	39 08                	cmp    %ecx,(%eax)
  801411:	74 33                	je     801446 <dev_lookup+0x4a>
  801413:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801416:	8b 02                	mov    (%edx),%eax
  801418:	85 c0                	test   %eax,%eax
  80141a:	75 f3                	jne    80140f <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80141c:	a1 20 44 80 00       	mov    0x804420,%eax
  801421:	8b 40 48             	mov    0x48(%eax),%eax
  801424:	83 ec 04             	sub    $0x4,%esp
  801427:	51                   	push   %ecx
  801428:	50                   	push   %eax
  801429:	68 cc 28 80 00       	push   $0x8028cc
  80142e:	e8 30 f0 ff ff       	call   800463 <cprintf>
	*dev = 0;
  801433:	8b 45 0c             	mov    0xc(%ebp),%eax
  801436:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80143c:	83 c4 10             	add    $0x10,%esp
  80143f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801444:	c9                   	leave  
  801445:	c3                   	ret    
			*dev = devtab[i];
  801446:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801449:	89 01                	mov    %eax,(%ecx)
			return 0;
  80144b:	b8 00 00 00 00       	mov    $0x0,%eax
  801450:	eb f2                	jmp    801444 <dev_lookup+0x48>

00801452 <fd_close>:
{
  801452:	55                   	push   %ebp
  801453:	89 e5                	mov    %esp,%ebp
  801455:	57                   	push   %edi
  801456:	56                   	push   %esi
  801457:	53                   	push   %ebx
  801458:	83 ec 24             	sub    $0x24,%esp
  80145b:	8b 75 08             	mov    0x8(%ebp),%esi
  80145e:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801461:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801464:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801465:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80146b:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80146e:	50                   	push   %eax
  80146f:	e8 38 ff ff ff       	call   8013ac <fd_lookup>
  801474:	89 c3                	mov    %eax,%ebx
  801476:	83 c4 10             	add    $0x10,%esp
  801479:	85 c0                	test   %eax,%eax
  80147b:	78 05                	js     801482 <fd_close+0x30>
	    || fd != fd2)
  80147d:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801480:	74 16                	je     801498 <fd_close+0x46>
		return (must_exist ? r : 0);
  801482:	89 f8                	mov    %edi,%eax
  801484:	84 c0                	test   %al,%al
  801486:	b8 00 00 00 00       	mov    $0x0,%eax
  80148b:	0f 44 d8             	cmove  %eax,%ebx
}
  80148e:	89 d8                	mov    %ebx,%eax
  801490:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801493:	5b                   	pop    %ebx
  801494:	5e                   	pop    %esi
  801495:	5f                   	pop    %edi
  801496:	5d                   	pop    %ebp
  801497:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801498:	83 ec 08             	sub    $0x8,%esp
  80149b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80149e:	50                   	push   %eax
  80149f:	ff 36                	pushl  (%esi)
  8014a1:	e8 56 ff ff ff       	call   8013fc <dev_lookup>
  8014a6:	89 c3                	mov    %eax,%ebx
  8014a8:	83 c4 10             	add    $0x10,%esp
  8014ab:	85 c0                	test   %eax,%eax
  8014ad:	78 1a                	js     8014c9 <fd_close+0x77>
		if (dev->dev_close)
  8014af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014b2:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8014b5:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8014ba:	85 c0                	test   %eax,%eax
  8014bc:	74 0b                	je     8014c9 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8014be:	83 ec 0c             	sub    $0xc,%esp
  8014c1:	56                   	push   %esi
  8014c2:	ff d0                	call   *%eax
  8014c4:	89 c3                	mov    %eax,%ebx
  8014c6:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8014c9:	83 ec 08             	sub    $0x8,%esp
  8014cc:	56                   	push   %esi
  8014cd:	6a 00                	push   $0x0
  8014cf:	e8 65 fb ff ff       	call   801039 <sys_page_unmap>
	return r;
  8014d4:	83 c4 10             	add    $0x10,%esp
  8014d7:	eb b5                	jmp    80148e <fd_close+0x3c>

008014d9 <close>:

int
close(int fdnum)
{
  8014d9:	55                   	push   %ebp
  8014da:	89 e5                	mov    %esp,%ebp
  8014dc:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014df:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014e2:	50                   	push   %eax
  8014e3:	ff 75 08             	pushl  0x8(%ebp)
  8014e6:	e8 c1 fe ff ff       	call   8013ac <fd_lookup>
  8014eb:	83 c4 10             	add    $0x10,%esp
  8014ee:	85 c0                	test   %eax,%eax
  8014f0:	79 02                	jns    8014f4 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8014f2:	c9                   	leave  
  8014f3:	c3                   	ret    
		return fd_close(fd, 1);
  8014f4:	83 ec 08             	sub    $0x8,%esp
  8014f7:	6a 01                	push   $0x1
  8014f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8014fc:	e8 51 ff ff ff       	call   801452 <fd_close>
  801501:	83 c4 10             	add    $0x10,%esp
  801504:	eb ec                	jmp    8014f2 <close+0x19>

00801506 <close_all>:

void
close_all(void)
{
  801506:	55                   	push   %ebp
  801507:	89 e5                	mov    %esp,%ebp
  801509:	53                   	push   %ebx
  80150a:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80150d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801512:	83 ec 0c             	sub    $0xc,%esp
  801515:	53                   	push   %ebx
  801516:	e8 be ff ff ff       	call   8014d9 <close>
	for (i = 0; i < MAXFD; i++)
  80151b:	83 c3 01             	add    $0x1,%ebx
  80151e:	83 c4 10             	add    $0x10,%esp
  801521:	83 fb 20             	cmp    $0x20,%ebx
  801524:	75 ec                	jne    801512 <close_all+0xc>
}
  801526:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801529:	c9                   	leave  
  80152a:	c3                   	ret    

0080152b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80152b:	55                   	push   %ebp
  80152c:	89 e5                	mov    %esp,%ebp
  80152e:	57                   	push   %edi
  80152f:	56                   	push   %esi
  801530:	53                   	push   %ebx
  801531:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801534:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801537:	50                   	push   %eax
  801538:	ff 75 08             	pushl  0x8(%ebp)
  80153b:	e8 6c fe ff ff       	call   8013ac <fd_lookup>
  801540:	89 c3                	mov    %eax,%ebx
  801542:	83 c4 10             	add    $0x10,%esp
  801545:	85 c0                	test   %eax,%eax
  801547:	0f 88 81 00 00 00    	js     8015ce <dup+0xa3>
		return r;
	close(newfdnum);
  80154d:	83 ec 0c             	sub    $0xc,%esp
  801550:	ff 75 0c             	pushl  0xc(%ebp)
  801553:	e8 81 ff ff ff       	call   8014d9 <close>

	newfd = INDEX2FD(newfdnum);
  801558:	8b 75 0c             	mov    0xc(%ebp),%esi
  80155b:	c1 e6 0c             	shl    $0xc,%esi
  80155e:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801564:	83 c4 04             	add    $0x4,%esp
  801567:	ff 75 e4             	pushl  -0x1c(%ebp)
  80156a:	e8 d4 fd ff ff       	call   801343 <fd2data>
  80156f:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801571:	89 34 24             	mov    %esi,(%esp)
  801574:	e8 ca fd ff ff       	call   801343 <fd2data>
  801579:	83 c4 10             	add    $0x10,%esp
  80157c:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80157e:	89 d8                	mov    %ebx,%eax
  801580:	c1 e8 16             	shr    $0x16,%eax
  801583:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80158a:	a8 01                	test   $0x1,%al
  80158c:	74 11                	je     80159f <dup+0x74>
  80158e:	89 d8                	mov    %ebx,%eax
  801590:	c1 e8 0c             	shr    $0xc,%eax
  801593:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80159a:	f6 c2 01             	test   $0x1,%dl
  80159d:	75 39                	jne    8015d8 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80159f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8015a2:	89 d0                	mov    %edx,%eax
  8015a4:	c1 e8 0c             	shr    $0xc,%eax
  8015a7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015ae:	83 ec 0c             	sub    $0xc,%esp
  8015b1:	25 07 0e 00 00       	and    $0xe07,%eax
  8015b6:	50                   	push   %eax
  8015b7:	56                   	push   %esi
  8015b8:	6a 00                	push   $0x0
  8015ba:	52                   	push   %edx
  8015bb:	6a 00                	push   $0x0
  8015bd:	e8 35 fa ff ff       	call   800ff7 <sys_page_map>
  8015c2:	89 c3                	mov    %eax,%ebx
  8015c4:	83 c4 20             	add    $0x20,%esp
  8015c7:	85 c0                	test   %eax,%eax
  8015c9:	78 31                	js     8015fc <dup+0xd1>
		goto err;

	return newfdnum;
  8015cb:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8015ce:	89 d8                	mov    %ebx,%eax
  8015d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015d3:	5b                   	pop    %ebx
  8015d4:	5e                   	pop    %esi
  8015d5:	5f                   	pop    %edi
  8015d6:	5d                   	pop    %ebp
  8015d7:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8015d8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015df:	83 ec 0c             	sub    $0xc,%esp
  8015e2:	25 07 0e 00 00       	and    $0xe07,%eax
  8015e7:	50                   	push   %eax
  8015e8:	57                   	push   %edi
  8015e9:	6a 00                	push   $0x0
  8015eb:	53                   	push   %ebx
  8015ec:	6a 00                	push   $0x0
  8015ee:	e8 04 fa ff ff       	call   800ff7 <sys_page_map>
  8015f3:	89 c3                	mov    %eax,%ebx
  8015f5:	83 c4 20             	add    $0x20,%esp
  8015f8:	85 c0                	test   %eax,%eax
  8015fa:	79 a3                	jns    80159f <dup+0x74>
	sys_page_unmap(0, newfd);
  8015fc:	83 ec 08             	sub    $0x8,%esp
  8015ff:	56                   	push   %esi
  801600:	6a 00                	push   $0x0
  801602:	e8 32 fa ff ff       	call   801039 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801607:	83 c4 08             	add    $0x8,%esp
  80160a:	57                   	push   %edi
  80160b:	6a 00                	push   $0x0
  80160d:	e8 27 fa ff ff       	call   801039 <sys_page_unmap>
	return r;
  801612:	83 c4 10             	add    $0x10,%esp
  801615:	eb b7                	jmp    8015ce <dup+0xa3>

00801617 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801617:	55                   	push   %ebp
  801618:	89 e5                	mov    %esp,%ebp
  80161a:	53                   	push   %ebx
  80161b:	83 ec 1c             	sub    $0x1c,%esp
  80161e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801621:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801624:	50                   	push   %eax
  801625:	53                   	push   %ebx
  801626:	e8 81 fd ff ff       	call   8013ac <fd_lookup>
  80162b:	83 c4 10             	add    $0x10,%esp
  80162e:	85 c0                	test   %eax,%eax
  801630:	78 3f                	js     801671 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801632:	83 ec 08             	sub    $0x8,%esp
  801635:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801638:	50                   	push   %eax
  801639:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80163c:	ff 30                	pushl  (%eax)
  80163e:	e8 b9 fd ff ff       	call   8013fc <dev_lookup>
  801643:	83 c4 10             	add    $0x10,%esp
  801646:	85 c0                	test   %eax,%eax
  801648:	78 27                	js     801671 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80164a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80164d:	8b 42 08             	mov    0x8(%edx),%eax
  801650:	83 e0 03             	and    $0x3,%eax
  801653:	83 f8 01             	cmp    $0x1,%eax
  801656:	74 1e                	je     801676 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801658:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80165b:	8b 40 08             	mov    0x8(%eax),%eax
  80165e:	85 c0                	test   %eax,%eax
  801660:	74 35                	je     801697 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801662:	83 ec 04             	sub    $0x4,%esp
  801665:	ff 75 10             	pushl  0x10(%ebp)
  801668:	ff 75 0c             	pushl  0xc(%ebp)
  80166b:	52                   	push   %edx
  80166c:	ff d0                	call   *%eax
  80166e:	83 c4 10             	add    $0x10,%esp
}
  801671:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801674:	c9                   	leave  
  801675:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801676:	a1 20 44 80 00       	mov    0x804420,%eax
  80167b:	8b 40 48             	mov    0x48(%eax),%eax
  80167e:	83 ec 04             	sub    $0x4,%esp
  801681:	53                   	push   %ebx
  801682:	50                   	push   %eax
  801683:	68 10 29 80 00       	push   $0x802910
  801688:	e8 d6 ed ff ff       	call   800463 <cprintf>
		return -E_INVAL;
  80168d:	83 c4 10             	add    $0x10,%esp
  801690:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801695:	eb da                	jmp    801671 <read+0x5a>
		return -E_NOT_SUPP;
  801697:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80169c:	eb d3                	jmp    801671 <read+0x5a>

0080169e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80169e:	55                   	push   %ebp
  80169f:	89 e5                	mov    %esp,%ebp
  8016a1:	57                   	push   %edi
  8016a2:	56                   	push   %esi
  8016a3:	53                   	push   %ebx
  8016a4:	83 ec 0c             	sub    $0xc,%esp
  8016a7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8016aa:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8016ad:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016b2:	39 f3                	cmp    %esi,%ebx
  8016b4:	73 23                	jae    8016d9 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016b6:	83 ec 04             	sub    $0x4,%esp
  8016b9:	89 f0                	mov    %esi,%eax
  8016bb:	29 d8                	sub    %ebx,%eax
  8016bd:	50                   	push   %eax
  8016be:	89 d8                	mov    %ebx,%eax
  8016c0:	03 45 0c             	add    0xc(%ebp),%eax
  8016c3:	50                   	push   %eax
  8016c4:	57                   	push   %edi
  8016c5:	e8 4d ff ff ff       	call   801617 <read>
		if (m < 0)
  8016ca:	83 c4 10             	add    $0x10,%esp
  8016cd:	85 c0                	test   %eax,%eax
  8016cf:	78 06                	js     8016d7 <readn+0x39>
			return m;
		if (m == 0)
  8016d1:	74 06                	je     8016d9 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8016d3:	01 c3                	add    %eax,%ebx
  8016d5:	eb db                	jmp    8016b2 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016d7:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8016d9:	89 d8                	mov    %ebx,%eax
  8016db:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016de:	5b                   	pop    %ebx
  8016df:	5e                   	pop    %esi
  8016e0:	5f                   	pop    %edi
  8016e1:	5d                   	pop    %ebp
  8016e2:	c3                   	ret    

008016e3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8016e3:	55                   	push   %ebp
  8016e4:	89 e5                	mov    %esp,%ebp
  8016e6:	53                   	push   %ebx
  8016e7:	83 ec 1c             	sub    $0x1c,%esp
  8016ea:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016ed:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016f0:	50                   	push   %eax
  8016f1:	53                   	push   %ebx
  8016f2:	e8 b5 fc ff ff       	call   8013ac <fd_lookup>
  8016f7:	83 c4 10             	add    $0x10,%esp
  8016fa:	85 c0                	test   %eax,%eax
  8016fc:	78 3a                	js     801738 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016fe:	83 ec 08             	sub    $0x8,%esp
  801701:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801704:	50                   	push   %eax
  801705:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801708:	ff 30                	pushl  (%eax)
  80170a:	e8 ed fc ff ff       	call   8013fc <dev_lookup>
  80170f:	83 c4 10             	add    $0x10,%esp
  801712:	85 c0                	test   %eax,%eax
  801714:	78 22                	js     801738 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801716:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801719:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80171d:	74 1e                	je     80173d <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80171f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801722:	8b 52 0c             	mov    0xc(%edx),%edx
  801725:	85 d2                	test   %edx,%edx
  801727:	74 35                	je     80175e <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801729:	83 ec 04             	sub    $0x4,%esp
  80172c:	ff 75 10             	pushl  0x10(%ebp)
  80172f:	ff 75 0c             	pushl  0xc(%ebp)
  801732:	50                   	push   %eax
  801733:	ff d2                	call   *%edx
  801735:	83 c4 10             	add    $0x10,%esp
}
  801738:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80173b:	c9                   	leave  
  80173c:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80173d:	a1 20 44 80 00       	mov    0x804420,%eax
  801742:	8b 40 48             	mov    0x48(%eax),%eax
  801745:	83 ec 04             	sub    $0x4,%esp
  801748:	53                   	push   %ebx
  801749:	50                   	push   %eax
  80174a:	68 2c 29 80 00       	push   $0x80292c
  80174f:	e8 0f ed ff ff       	call   800463 <cprintf>
		return -E_INVAL;
  801754:	83 c4 10             	add    $0x10,%esp
  801757:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80175c:	eb da                	jmp    801738 <write+0x55>
		return -E_NOT_SUPP;
  80175e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801763:	eb d3                	jmp    801738 <write+0x55>

00801765 <seek>:

int
seek(int fdnum, off_t offset)
{
  801765:	55                   	push   %ebp
  801766:	89 e5                	mov    %esp,%ebp
  801768:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80176b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80176e:	50                   	push   %eax
  80176f:	ff 75 08             	pushl  0x8(%ebp)
  801772:	e8 35 fc ff ff       	call   8013ac <fd_lookup>
  801777:	83 c4 10             	add    $0x10,%esp
  80177a:	85 c0                	test   %eax,%eax
  80177c:	78 0e                	js     80178c <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80177e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801781:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801784:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801787:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80178c:	c9                   	leave  
  80178d:	c3                   	ret    

0080178e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80178e:	55                   	push   %ebp
  80178f:	89 e5                	mov    %esp,%ebp
  801791:	53                   	push   %ebx
  801792:	83 ec 1c             	sub    $0x1c,%esp
  801795:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801798:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80179b:	50                   	push   %eax
  80179c:	53                   	push   %ebx
  80179d:	e8 0a fc ff ff       	call   8013ac <fd_lookup>
  8017a2:	83 c4 10             	add    $0x10,%esp
  8017a5:	85 c0                	test   %eax,%eax
  8017a7:	78 37                	js     8017e0 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017a9:	83 ec 08             	sub    $0x8,%esp
  8017ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017af:	50                   	push   %eax
  8017b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b3:	ff 30                	pushl  (%eax)
  8017b5:	e8 42 fc ff ff       	call   8013fc <dev_lookup>
  8017ba:	83 c4 10             	add    $0x10,%esp
  8017bd:	85 c0                	test   %eax,%eax
  8017bf:	78 1f                	js     8017e0 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c4:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017c8:	74 1b                	je     8017e5 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8017ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017cd:	8b 52 18             	mov    0x18(%edx),%edx
  8017d0:	85 d2                	test   %edx,%edx
  8017d2:	74 32                	je     801806 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8017d4:	83 ec 08             	sub    $0x8,%esp
  8017d7:	ff 75 0c             	pushl  0xc(%ebp)
  8017da:	50                   	push   %eax
  8017db:	ff d2                	call   *%edx
  8017dd:	83 c4 10             	add    $0x10,%esp
}
  8017e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017e3:	c9                   	leave  
  8017e4:	c3                   	ret    
			thisenv->env_id, fdnum);
  8017e5:	a1 20 44 80 00       	mov    0x804420,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8017ea:	8b 40 48             	mov    0x48(%eax),%eax
  8017ed:	83 ec 04             	sub    $0x4,%esp
  8017f0:	53                   	push   %ebx
  8017f1:	50                   	push   %eax
  8017f2:	68 ec 28 80 00       	push   $0x8028ec
  8017f7:	e8 67 ec ff ff       	call   800463 <cprintf>
		return -E_INVAL;
  8017fc:	83 c4 10             	add    $0x10,%esp
  8017ff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801804:	eb da                	jmp    8017e0 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801806:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80180b:	eb d3                	jmp    8017e0 <ftruncate+0x52>

0080180d <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80180d:	55                   	push   %ebp
  80180e:	89 e5                	mov    %esp,%ebp
  801810:	53                   	push   %ebx
  801811:	83 ec 1c             	sub    $0x1c,%esp
  801814:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801817:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80181a:	50                   	push   %eax
  80181b:	ff 75 08             	pushl  0x8(%ebp)
  80181e:	e8 89 fb ff ff       	call   8013ac <fd_lookup>
  801823:	83 c4 10             	add    $0x10,%esp
  801826:	85 c0                	test   %eax,%eax
  801828:	78 4b                	js     801875 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80182a:	83 ec 08             	sub    $0x8,%esp
  80182d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801830:	50                   	push   %eax
  801831:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801834:	ff 30                	pushl  (%eax)
  801836:	e8 c1 fb ff ff       	call   8013fc <dev_lookup>
  80183b:	83 c4 10             	add    $0x10,%esp
  80183e:	85 c0                	test   %eax,%eax
  801840:	78 33                	js     801875 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801842:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801845:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801849:	74 2f                	je     80187a <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80184b:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80184e:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801855:	00 00 00 
	stat->st_isdir = 0;
  801858:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80185f:	00 00 00 
	stat->st_dev = dev;
  801862:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801868:	83 ec 08             	sub    $0x8,%esp
  80186b:	53                   	push   %ebx
  80186c:	ff 75 f0             	pushl  -0x10(%ebp)
  80186f:	ff 50 14             	call   *0x14(%eax)
  801872:	83 c4 10             	add    $0x10,%esp
}
  801875:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801878:	c9                   	leave  
  801879:	c3                   	ret    
		return -E_NOT_SUPP;
  80187a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80187f:	eb f4                	jmp    801875 <fstat+0x68>

00801881 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801881:	55                   	push   %ebp
  801882:	89 e5                	mov    %esp,%ebp
  801884:	56                   	push   %esi
  801885:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801886:	83 ec 08             	sub    $0x8,%esp
  801889:	6a 00                	push   $0x0
  80188b:	ff 75 08             	pushl  0x8(%ebp)
  80188e:	e8 bb 01 00 00       	call   801a4e <open>
  801893:	89 c3                	mov    %eax,%ebx
  801895:	83 c4 10             	add    $0x10,%esp
  801898:	85 c0                	test   %eax,%eax
  80189a:	78 1b                	js     8018b7 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80189c:	83 ec 08             	sub    $0x8,%esp
  80189f:	ff 75 0c             	pushl  0xc(%ebp)
  8018a2:	50                   	push   %eax
  8018a3:	e8 65 ff ff ff       	call   80180d <fstat>
  8018a8:	89 c6                	mov    %eax,%esi
	close(fd);
  8018aa:	89 1c 24             	mov    %ebx,(%esp)
  8018ad:	e8 27 fc ff ff       	call   8014d9 <close>
	return r;
  8018b2:	83 c4 10             	add    $0x10,%esp
  8018b5:	89 f3                	mov    %esi,%ebx
}
  8018b7:	89 d8                	mov    %ebx,%eax
  8018b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018bc:	5b                   	pop    %ebx
  8018bd:	5e                   	pop    %esi
  8018be:	5d                   	pop    %ebp
  8018bf:	c3                   	ret    

008018c0 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
  8018c3:	56                   	push   %esi
  8018c4:	53                   	push   %ebx
  8018c5:	89 c6                	mov    %eax,%esi
  8018c7:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8018c9:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8018d0:	74 27                	je     8018f9 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8018d2:	6a 07                	push   $0x7
  8018d4:	68 00 50 80 00       	push   $0x805000
  8018d9:	56                   	push   %esi
  8018da:	ff 35 00 40 80 00    	pushl  0x804000
  8018e0:	e8 4e 08 00 00       	call   802133 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8018e5:	83 c4 0c             	add    $0xc,%esp
  8018e8:	6a 00                	push   $0x0
  8018ea:	53                   	push   %ebx
  8018eb:	6a 00                	push   $0x0
  8018ed:	e8 d8 07 00 00       	call   8020ca <ipc_recv>
}
  8018f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018f5:	5b                   	pop    %ebx
  8018f6:	5e                   	pop    %esi
  8018f7:	5d                   	pop    %ebp
  8018f8:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8018f9:	83 ec 0c             	sub    $0xc,%esp
  8018fc:	6a 01                	push   $0x1
  8018fe:	e8 88 08 00 00       	call   80218b <ipc_find_env>
  801903:	a3 00 40 80 00       	mov    %eax,0x804000
  801908:	83 c4 10             	add    $0x10,%esp
  80190b:	eb c5                	jmp    8018d2 <fsipc+0x12>

0080190d <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80190d:	55                   	push   %ebp
  80190e:	89 e5                	mov    %esp,%ebp
  801910:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801913:	8b 45 08             	mov    0x8(%ebp),%eax
  801916:	8b 40 0c             	mov    0xc(%eax),%eax
  801919:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80191e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801921:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801926:	ba 00 00 00 00       	mov    $0x0,%edx
  80192b:	b8 02 00 00 00       	mov    $0x2,%eax
  801930:	e8 8b ff ff ff       	call   8018c0 <fsipc>
}
  801935:	c9                   	leave  
  801936:	c3                   	ret    

00801937 <devfile_flush>:
{
  801937:	55                   	push   %ebp
  801938:	89 e5                	mov    %esp,%ebp
  80193a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80193d:	8b 45 08             	mov    0x8(%ebp),%eax
  801940:	8b 40 0c             	mov    0xc(%eax),%eax
  801943:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801948:	ba 00 00 00 00       	mov    $0x0,%edx
  80194d:	b8 06 00 00 00       	mov    $0x6,%eax
  801952:	e8 69 ff ff ff       	call   8018c0 <fsipc>
}
  801957:	c9                   	leave  
  801958:	c3                   	ret    

00801959 <devfile_stat>:
{
  801959:	55                   	push   %ebp
  80195a:	89 e5                	mov    %esp,%ebp
  80195c:	53                   	push   %ebx
  80195d:	83 ec 04             	sub    $0x4,%esp
  801960:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801963:	8b 45 08             	mov    0x8(%ebp),%eax
  801966:	8b 40 0c             	mov    0xc(%eax),%eax
  801969:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80196e:	ba 00 00 00 00       	mov    $0x0,%edx
  801973:	b8 05 00 00 00       	mov    $0x5,%eax
  801978:	e8 43 ff ff ff       	call   8018c0 <fsipc>
  80197d:	85 c0                	test   %eax,%eax
  80197f:	78 2c                	js     8019ad <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801981:	83 ec 08             	sub    $0x8,%esp
  801984:	68 00 50 80 00       	push   $0x805000
  801989:	53                   	push   %ebx
  80198a:	e8 33 f2 ff ff       	call   800bc2 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80198f:	a1 80 50 80 00       	mov    0x805080,%eax
  801994:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80199a:	a1 84 50 80 00       	mov    0x805084,%eax
  80199f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8019a5:	83 c4 10             	add    $0x10,%esp
  8019a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019b0:	c9                   	leave  
  8019b1:	c3                   	ret    

008019b2 <devfile_write>:
{
  8019b2:	55                   	push   %ebp
  8019b3:	89 e5                	mov    %esp,%ebp
  8019b5:	83 ec 0c             	sub    $0xc,%esp
	panic("devfile_write not implemented");
  8019b8:	68 5c 29 80 00       	push   $0x80295c
  8019bd:	68 90 00 00 00       	push   $0x90
  8019c2:	68 7a 29 80 00       	push   $0x80297a
  8019c7:	e8 a1 e9 ff ff       	call   80036d <_panic>

008019cc <devfile_read>:
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
  8019cf:	56                   	push   %esi
  8019d0:	53                   	push   %ebx
  8019d1:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8019d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8019da:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8019df:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8019e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8019ea:	b8 03 00 00 00       	mov    $0x3,%eax
  8019ef:	e8 cc fe ff ff       	call   8018c0 <fsipc>
  8019f4:	89 c3                	mov    %eax,%ebx
  8019f6:	85 c0                	test   %eax,%eax
  8019f8:	78 1f                	js     801a19 <devfile_read+0x4d>
	assert(r <= n);
  8019fa:	39 f0                	cmp    %esi,%eax
  8019fc:	77 24                	ja     801a22 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8019fe:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a03:	7f 33                	jg     801a38 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801a05:	83 ec 04             	sub    $0x4,%esp
  801a08:	50                   	push   %eax
  801a09:	68 00 50 80 00       	push   $0x805000
  801a0e:	ff 75 0c             	pushl  0xc(%ebp)
  801a11:	e8 3a f3 ff ff       	call   800d50 <memmove>
	return r;
  801a16:	83 c4 10             	add    $0x10,%esp
}
  801a19:	89 d8                	mov    %ebx,%eax
  801a1b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a1e:	5b                   	pop    %ebx
  801a1f:	5e                   	pop    %esi
  801a20:	5d                   	pop    %ebp
  801a21:	c3                   	ret    
	assert(r <= n);
  801a22:	68 85 29 80 00       	push   $0x802985
  801a27:	68 8c 29 80 00       	push   $0x80298c
  801a2c:	6a 7c                	push   $0x7c
  801a2e:	68 7a 29 80 00       	push   $0x80297a
  801a33:	e8 35 e9 ff ff       	call   80036d <_panic>
	assert(r <= PGSIZE);
  801a38:	68 a1 29 80 00       	push   $0x8029a1
  801a3d:	68 8c 29 80 00       	push   $0x80298c
  801a42:	6a 7d                	push   $0x7d
  801a44:	68 7a 29 80 00       	push   $0x80297a
  801a49:	e8 1f e9 ff ff       	call   80036d <_panic>

00801a4e <open>:
{
  801a4e:	55                   	push   %ebp
  801a4f:	89 e5                	mov    %esp,%ebp
  801a51:	56                   	push   %esi
  801a52:	53                   	push   %ebx
  801a53:	83 ec 1c             	sub    $0x1c,%esp
  801a56:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801a59:	56                   	push   %esi
  801a5a:	e8 2a f1 ff ff       	call   800b89 <strlen>
  801a5f:	83 c4 10             	add    $0x10,%esp
  801a62:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a67:	7f 6c                	jg     801ad5 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801a69:	83 ec 0c             	sub    $0xc,%esp
  801a6c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a6f:	50                   	push   %eax
  801a70:	e8 e5 f8 ff ff       	call   80135a <fd_alloc>
  801a75:	89 c3                	mov    %eax,%ebx
  801a77:	83 c4 10             	add    $0x10,%esp
  801a7a:	85 c0                	test   %eax,%eax
  801a7c:	78 3c                	js     801aba <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801a7e:	83 ec 08             	sub    $0x8,%esp
  801a81:	56                   	push   %esi
  801a82:	68 00 50 80 00       	push   $0x805000
  801a87:	e8 36 f1 ff ff       	call   800bc2 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a8f:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a97:	b8 01 00 00 00       	mov    $0x1,%eax
  801a9c:	e8 1f fe ff ff       	call   8018c0 <fsipc>
  801aa1:	89 c3                	mov    %eax,%ebx
  801aa3:	83 c4 10             	add    $0x10,%esp
  801aa6:	85 c0                	test   %eax,%eax
  801aa8:	78 19                	js     801ac3 <open+0x75>
	return fd2num(fd);
  801aaa:	83 ec 0c             	sub    $0xc,%esp
  801aad:	ff 75 f4             	pushl  -0xc(%ebp)
  801ab0:	e8 7e f8 ff ff       	call   801333 <fd2num>
  801ab5:	89 c3                	mov    %eax,%ebx
  801ab7:	83 c4 10             	add    $0x10,%esp
}
  801aba:	89 d8                	mov    %ebx,%eax
  801abc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801abf:	5b                   	pop    %ebx
  801ac0:	5e                   	pop    %esi
  801ac1:	5d                   	pop    %ebp
  801ac2:	c3                   	ret    
		fd_close(fd, 0);
  801ac3:	83 ec 08             	sub    $0x8,%esp
  801ac6:	6a 00                	push   $0x0
  801ac8:	ff 75 f4             	pushl  -0xc(%ebp)
  801acb:	e8 82 f9 ff ff       	call   801452 <fd_close>
		return r;
  801ad0:	83 c4 10             	add    $0x10,%esp
  801ad3:	eb e5                	jmp    801aba <open+0x6c>
		return -E_BAD_PATH;
  801ad5:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801ada:	eb de                	jmp    801aba <open+0x6c>

00801adc <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801adc:	55                   	push   %ebp
  801add:	89 e5                	mov    %esp,%ebp
  801adf:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ae2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ae7:	b8 08 00 00 00       	mov    $0x8,%eax
  801aec:	e8 cf fd ff ff       	call   8018c0 <fsipc>
}
  801af1:	c9                   	leave  
  801af2:	c3                   	ret    

00801af3 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  801af3:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801af7:	7f 01                	jg     801afa <writebuf+0x7>
  801af9:	c3                   	ret    
{
  801afa:	55                   	push   %ebp
  801afb:	89 e5                	mov    %esp,%ebp
  801afd:	53                   	push   %ebx
  801afe:	83 ec 08             	sub    $0x8,%esp
  801b01:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  801b03:	ff 70 04             	pushl  0x4(%eax)
  801b06:	8d 40 10             	lea    0x10(%eax),%eax
  801b09:	50                   	push   %eax
  801b0a:	ff 33                	pushl  (%ebx)
  801b0c:	e8 d2 fb ff ff       	call   8016e3 <write>
		if (result > 0)
  801b11:	83 c4 10             	add    $0x10,%esp
  801b14:	85 c0                	test   %eax,%eax
  801b16:	7e 03                	jle    801b1b <writebuf+0x28>
			b->result += result;
  801b18:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801b1b:	39 43 04             	cmp    %eax,0x4(%ebx)
  801b1e:	74 0d                	je     801b2d <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  801b20:	85 c0                	test   %eax,%eax
  801b22:	ba 00 00 00 00       	mov    $0x0,%edx
  801b27:	0f 4f c2             	cmovg  %edx,%eax
  801b2a:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801b2d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b30:	c9                   	leave  
  801b31:	c3                   	ret    

00801b32 <putch>:

static void
putch(int ch, void *thunk)
{
  801b32:	55                   	push   %ebp
  801b33:	89 e5                	mov    %esp,%ebp
  801b35:	53                   	push   %ebx
  801b36:	83 ec 04             	sub    $0x4,%esp
  801b39:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801b3c:	8b 53 04             	mov    0x4(%ebx),%edx
  801b3f:	8d 42 01             	lea    0x1(%edx),%eax
  801b42:	89 43 04             	mov    %eax,0x4(%ebx)
  801b45:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b48:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801b4c:	3d 00 01 00 00       	cmp    $0x100,%eax
  801b51:	74 06                	je     801b59 <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  801b53:	83 c4 04             	add    $0x4,%esp
  801b56:	5b                   	pop    %ebx
  801b57:	5d                   	pop    %ebp
  801b58:	c3                   	ret    
		writebuf(b);
  801b59:	89 d8                	mov    %ebx,%eax
  801b5b:	e8 93 ff ff ff       	call   801af3 <writebuf>
		b->idx = 0;
  801b60:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  801b67:	eb ea                	jmp    801b53 <putch+0x21>

00801b69 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801b69:	55                   	push   %ebp
  801b6a:	89 e5                	mov    %esp,%ebp
  801b6c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801b72:	8b 45 08             	mov    0x8(%ebp),%eax
  801b75:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801b7b:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801b82:	00 00 00 
	b.result = 0;
  801b85:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801b8c:	00 00 00 
	b.error = 1;
  801b8f:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801b96:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801b99:	ff 75 10             	pushl  0x10(%ebp)
  801b9c:	ff 75 0c             	pushl  0xc(%ebp)
  801b9f:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801ba5:	50                   	push   %eax
  801ba6:	68 32 1b 80 00       	push   $0x801b32
  801bab:	e8 e0 e9 ff ff       	call   800590 <vprintfmt>
	if (b.idx > 0)
  801bb0:	83 c4 10             	add    $0x10,%esp
  801bb3:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801bba:	7f 11                	jg     801bcd <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  801bbc:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801bc2:	85 c0                	test   %eax,%eax
  801bc4:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801bcb:	c9                   	leave  
  801bcc:	c3                   	ret    
		writebuf(&b);
  801bcd:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801bd3:	e8 1b ff ff ff       	call   801af3 <writebuf>
  801bd8:	eb e2                	jmp    801bbc <vfprintf+0x53>

00801bda <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801bda:	55                   	push   %ebp
  801bdb:	89 e5                	mov    %esp,%ebp
  801bdd:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801be0:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801be3:	50                   	push   %eax
  801be4:	ff 75 0c             	pushl  0xc(%ebp)
  801be7:	ff 75 08             	pushl  0x8(%ebp)
  801bea:	e8 7a ff ff ff       	call   801b69 <vfprintf>
	va_end(ap);

	return cnt;
}
  801bef:	c9                   	leave  
  801bf0:	c3                   	ret    

00801bf1 <printf>:

int
printf(const char *fmt, ...)
{
  801bf1:	55                   	push   %ebp
  801bf2:	89 e5                	mov    %esp,%ebp
  801bf4:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801bf7:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801bfa:	50                   	push   %eax
  801bfb:	ff 75 08             	pushl  0x8(%ebp)
  801bfe:	6a 01                	push   $0x1
  801c00:	e8 64 ff ff ff       	call   801b69 <vfprintf>
	va_end(ap);

	return cnt;
}
  801c05:	c9                   	leave  
  801c06:	c3                   	ret    

00801c07 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c07:	55                   	push   %ebp
  801c08:	89 e5                	mov    %esp,%ebp
  801c0a:	56                   	push   %esi
  801c0b:	53                   	push   %ebx
  801c0c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c0f:	83 ec 0c             	sub    $0xc,%esp
  801c12:	ff 75 08             	pushl  0x8(%ebp)
  801c15:	e8 29 f7 ff ff       	call   801343 <fd2data>
  801c1a:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c1c:	83 c4 08             	add    $0x8,%esp
  801c1f:	68 ad 29 80 00       	push   $0x8029ad
  801c24:	53                   	push   %ebx
  801c25:	e8 98 ef ff ff       	call   800bc2 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c2a:	8b 46 04             	mov    0x4(%esi),%eax
  801c2d:	2b 06                	sub    (%esi),%eax
  801c2f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801c35:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c3c:	00 00 00 
	stat->st_dev = &devpipe;
  801c3f:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801c46:	30 80 00 
	return 0;
}
  801c49:	b8 00 00 00 00       	mov    $0x0,%eax
  801c4e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c51:	5b                   	pop    %ebx
  801c52:	5e                   	pop    %esi
  801c53:	5d                   	pop    %ebp
  801c54:	c3                   	ret    

00801c55 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c55:	55                   	push   %ebp
  801c56:	89 e5                	mov    %esp,%ebp
  801c58:	53                   	push   %ebx
  801c59:	83 ec 0c             	sub    $0xc,%esp
  801c5c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801c5f:	53                   	push   %ebx
  801c60:	6a 00                	push   $0x0
  801c62:	e8 d2 f3 ff ff       	call   801039 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801c67:	89 1c 24             	mov    %ebx,(%esp)
  801c6a:	e8 d4 f6 ff ff       	call   801343 <fd2data>
  801c6f:	83 c4 08             	add    $0x8,%esp
  801c72:	50                   	push   %eax
  801c73:	6a 00                	push   $0x0
  801c75:	e8 bf f3 ff ff       	call   801039 <sys_page_unmap>
}
  801c7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c7d:	c9                   	leave  
  801c7e:	c3                   	ret    

00801c7f <_pipeisclosed>:
{
  801c7f:	55                   	push   %ebp
  801c80:	89 e5                	mov    %esp,%ebp
  801c82:	57                   	push   %edi
  801c83:	56                   	push   %esi
  801c84:	53                   	push   %ebx
  801c85:	83 ec 1c             	sub    $0x1c,%esp
  801c88:	89 c7                	mov    %eax,%edi
  801c8a:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801c8c:	a1 20 44 80 00       	mov    0x804420,%eax
  801c91:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801c94:	83 ec 0c             	sub    $0xc,%esp
  801c97:	57                   	push   %edi
  801c98:	e8 29 05 00 00       	call   8021c6 <pageref>
  801c9d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ca0:	89 34 24             	mov    %esi,(%esp)
  801ca3:	e8 1e 05 00 00       	call   8021c6 <pageref>
		nn = thisenv->env_runs;
  801ca8:	8b 15 20 44 80 00    	mov    0x804420,%edx
  801cae:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801cb1:	83 c4 10             	add    $0x10,%esp
  801cb4:	39 cb                	cmp    %ecx,%ebx
  801cb6:	74 1b                	je     801cd3 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801cb8:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801cbb:	75 cf                	jne    801c8c <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801cbd:	8b 42 58             	mov    0x58(%edx),%eax
  801cc0:	6a 01                	push   $0x1
  801cc2:	50                   	push   %eax
  801cc3:	53                   	push   %ebx
  801cc4:	68 b4 29 80 00       	push   $0x8029b4
  801cc9:	e8 95 e7 ff ff       	call   800463 <cprintf>
  801cce:	83 c4 10             	add    $0x10,%esp
  801cd1:	eb b9                	jmp    801c8c <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801cd3:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801cd6:	0f 94 c0             	sete   %al
  801cd9:	0f b6 c0             	movzbl %al,%eax
}
  801cdc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cdf:	5b                   	pop    %ebx
  801ce0:	5e                   	pop    %esi
  801ce1:	5f                   	pop    %edi
  801ce2:	5d                   	pop    %ebp
  801ce3:	c3                   	ret    

00801ce4 <devpipe_write>:
{
  801ce4:	55                   	push   %ebp
  801ce5:	89 e5                	mov    %esp,%ebp
  801ce7:	57                   	push   %edi
  801ce8:	56                   	push   %esi
  801ce9:	53                   	push   %ebx
  801cea:	83 ec 28             	sub    $0x28,%esp
  801ced:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801cf0:	56                   	push   %esi
  801cf1:	e8 4d f6 ff ff       	call   801343 <fd2data>
  801cf6:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801cf8:	83 c4 10             	add    $0x10,%esp
  801cfb:	bf 00 00 00 00       	mov    $0x0,%edi
  801d00:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d03:	74 4f                	je     801d54 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d05:	8b 43 04             	mov    0x4(%ebx),%eax
  801d08:	8b 0b                	mov    (%ebx),%ecx
  801d0a:	8d 51 20             	lea    0x20(%ecx),%edx
  801d0d:	39 d0                	cmp    %edx,%eax
  801d0f:	72 14                	jb     801d25 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801d11:	89 da                	mov    %ebx,%edx
  801d13:	89 f0                	mov    %esi,%eax
  801d15:	e8 65 ff ff ff       	call   801c7f <_pipeisclosed>
  801d1a:	85 c0                	test   %eax,%eax
  801d1c:	75 3b                	jne    801d59 <devpipe_write+0x75>
			sys_yield();
  801d1e:	e8 72 f2 ff ff       	call   800f95 <sys_yield>
  801d23:	eb e0                	jmp    801d05 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d28:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801d2c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801d2f:	89 c2                	mov    %eax,%edx
  801d31:	c1 fa 1f             	sar    $0x1f,%edx
  801d34:	89 d1                	mov    %edx,%ecx
  801d36:	c1 e9 1b             	shr    $0x1b,%ecx
  801d39:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801d3c:	83 e2 1f             	and    $0x1f,%edx
  801d3f:	29 ca                	sub    %ecx,%edx
  801d41:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801d45:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801d49:	83 c0 01             	add    $0x1,%eax
  801d4c:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801d4f:	83 c7 01             	add    $0x1,%edi
  801d52:	eb ac                	jmp    801d00 <devpipe_write+0x1c>
	return i;
  801d54:	8b 45 10             	mov    0x10(%ebp),%eax
  801d57:	eb 05                	jmp    801d5e <devpipe_write+0x7a>
				return 0;
  801d59:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d61:	5b                   	pop    %ebx
  801d62:	5e                   	pop    %esi
  801d63:	5f                   	pop    %edi
  801d64:	5d                   	pop    %ebp
  801d65:	c3                   	ret    

00801d66 <devpipe_read>:
{
  801d66:	55                   	push   %ebp
  801d67:	89 e5                	mov    %esp,%ebp
  801d69:	57                   	push   %edi
  801d6a:	56                   	push   %esi
  801d6b:	53                   	push   %ebx
  801d6c:	83 ec 18             	sub    $0x18,%esp
  801d6f:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801d72:	57                   	push   %edi
  801d73:	e8 cb f5 ff ff       	call   801343 <fd2data>
  801d78:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d7a:	83 c4 10             	add    $0x10,%esp
  801d7d:	be 00 00 00 00       	mov    $0x0,%esi
  801d82:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d85:	75 14                	jne    801d9b <devpipe_read+0x35>
	return i;
  801d87:	8b 45 10             	mov    0x10(%ebp),%eax
  801d8a:	eb 02                	jmp    801d8e <devpipe_read+0x28>
				return i;
  801d8c:	89 f0                	mov    %esi,%eax
}
  801d8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d91:	5b                   	pop    %ebx
  801d92:	5e                   	pop    %esi
  801d93:	5f                   	pop    %edi
  801d94:	5d                   	pop    %ebp
  801d95:	c3                   	ret    
			sys_yield();
  801d96:	e8 fa f1 ff ff       	call   800f95 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801d9b:	8b 03                	mov    (%ebx),%eax
  801d9d:	3b 43 04             	cmp    0x4(%ebx),%eax
  801da0:	75 18                	jne    801dba <devpipe_read+0x54>
			if (i > 0)
  801da2:	85 f6                	test   %esi,%esi
  801da4:	75 e6                	jne    801d8c <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801da6:	89 da                	mov    %ebx,%edx
  801da8:	89 f8                	mov    %edi,%eax
  801daa:	e8 d0 fe ff ff       	call   801c7f <_pipeisclosed>
  801daf:	85 c0                	test   %eax,%eax
  801db1:	74 e3                	je     801d96 <devpipe_read+0x30>
				return 0;
  801db3:	b8 00 00 00 00       	mov    $0x0,%eax
  801db8:	eb d4                	jmp    801d8e <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801dba:	99                   	cltd   
  801dbb:	c1 ea 1b             	shr    $0x1b,%edx
  801dbe:	01 d0                	add    %edx,%eax
  801dc0:	83 e0 1f             	and    $0x1f,%eax
  801dc3:	29 d0                	sub    %edx,%eax
  801dc5:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801dca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801dcd:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801dd0:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801dd3:	83 c6 01             	add    $0x1,%esi
  801dd6:	eb aa                	jmp    801d82 <devpipe_read+0x1c>

00801dd8 <pipe>:
{
  801dd8:	55                   	push   %ebp
  801dd9:	89 e5                	mov    %esp,%ebp
  801ddb:	56                   	push   %esi
  801ddc:	53                   	push   %ebx
  801ddd:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801de0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801de3:	50                   	push   %eax
  801de4:	e8 71 f5 ff ff       	call   80135a <fd_alloc>
  801de9:	89 c3                	mov    %eax,%ebx
  801deb:	83 c4 10             	add    $0x10,%esp
  801dee:	85 c0                	test   %eax,%eax
  801df0:	0f 88 23 01 00 00    	js     801f19 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801df6:	83 ec 04             	sub    $0x4,%esp
  801df9:	68 07 04 00 00       	push   $0x407
  801dfe:	ff 75 f4             	pushl  -0xc(%ebp)
  801e01:	6a 00                	push   $0x0
  801e03:	e8 ac f1 ff ff       	call   800fb4 <sys_page_alloc>
  801e08:	89 c3                	mov    %eax,%ebx
  801e0a:	83 c4 10             	add    $0x10,%esp
  801e0d:	85 c0                	test   %eax,%eax
  801e0f:	0f 88 04 01 00 00    	js     801f19 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801e15:	83 ec 0c             	sub    $0xc,%esp
  801e18:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e1b:	50                   	push   %eax
  801e1c:	e8 39 f5 ff ff       	call   80135a <fd_alloc>
  801e21:	89 c3                	mov    %eax,%ebx
  801e23:	83 c4 10             	add    $0x10,%esp
  801e26:	85 c0                	test   %eax,%eax
  801e28:	0f 88 db 00 00 00    	js     801f09 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e2e:	83 ec 04             	sub    $0x4,%esp
  801e31:	68 07 04 00 00       	push   $0x407
  801e36:	ff 75 f0             	pushl  -0x10(%ebp)
  801e39:	6a 00                	push   $0x0
  801e3b:	e8 74 f1 ff ff       	call   800fb4 <sys_page_alloc>
  801e40:	89 c3                	mov    %eax,%ebx
  801e42:	83 c4 10             	add    $0x10,%esp
  801e45:	85 c0                	test   %eax,%eax
  801e47:	0f 88 bc 00 00 00    	js     801f09 <pipe+0x131>
	va = fd2data(fd0);
  801e4d:	83 ec 0c             	sub    $0xc,%esp
  801e50:	ff 75 f4             	pushl  -0xc(%ebp)
  801e53:	e8 eb f4 ff ff       	call   801343 <fd2data>
  801e58:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e5a:	83 c4 0c             	add    $0xc,%esp
  801e5d:	68 07 04 00 00       	push   $0x407
  801e62:	50                   	push   %eax
  801e63:	6a 00                	push   $0x0
  801e65:	e8 4a f1 ff ff       	call   800fb4 <sys_page_alloc>
  801e6a:	89 c3                	mov    %eax,%ebx
  801e6c:	83 c4 10             	add    $0x10,%esp
  801e6f:	85 c0                	test   %eax,%eax
  801e71:	0f 88 82 00 00 00    	js     801ef9 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e77:	83 ec 0c             	sub    $0xc,%esp
  801e7a:	ff 75 f0             	pushl  -0x10(%ebp)
  801e7d:	e8 c1 f4 ff ff       	call   801343 <fd2data>
  801e82:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801e89:	50                   	push   %eax
  801e8a:	6a 00                	push   $0x0
  801e8c:	56                   	push   %esi
  801e8d:	6a 00                	push   $0x0
  801e8f:	e8 63 f1 ff ff       	call   800ff7 <sys_page_map>
  801e94:	89 c3                	mov    %eax,%ebx
  801e96:	83 c4 20             	add    $0x20,%esp
  801e99:	85 c0                	test   %eax,%eax
  801e9b:	78 4e                	js     801eeb <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801e9d:	a1 20 30 80 00       	mov    0x803020,%eax
  801ea2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ea5:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801ea7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eaa:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801eb1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801eb4:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801eb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eb9:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801ec0:	83 ec 0c             	sub    $0xc,%esp
  801ec3:	ff 75 f4             	pushl  -0xc(%ebp)
  801ec6:	e8 68 f4 ff ff       	call   801333 <fd2num>
  801ecb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ece:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801ed0:	83 c4 04             	add    $0x4,%esp
  801ed3:	ff 75 f0             	pushl  -0x10(%ebp)
  801ed6:	e8 58 f4 ff ff       	call   801333 <fd2num>
  801edb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ede:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801ee1:	83 c4 10             	add    $0x10,%esp
  801ee4:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ee9:	eb 2e                	jmp    801f19 <pipe+0x141>
	sys_page_unmap(0, va);
  801eeb:	83 ec 08             	sub    $0x8,%esp
  801eee:	56                   	push   %esi
  801eef:	6a 00                	push   $0x0
  801ef1:	e8 43 f1 ff ff       	call   801039 <sys_page_unmap>
  801ef6:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801ef9:	83 ec 08             	sub    $0x8,%esp
  801efc:	ff 75 f0             	pushl  -0x10(%ebp)
  801eff:	6a 00                	push   $0x0
  801f01:	e8 33 f1 ff ff       	call   801039 <sys_page_unmap>
  801f06:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801f09:	83 ec 08             	sub    $0x8,%esp
  801f0c:	ff 75 f4             	pushl  -0xc(%ebp)
  801f0f:	6a 00                	push   $0x0
  801f11:	e8 23 f1 ff ff       	call   801039 <sys_page_unmap>
  801f16:	83 c4 10             	add    $0x10,%esp
}
  801f19:	89 d8                	mov    %ebx,%eax
  801f1b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f1e:	5b                   	pop    %ebx
  801f1f:	5e                   	pop    %esi
  801f20:	5d                   	pop    %ebp
  801f21:	c3                   	ret    

00801f22 <pipeisclosed>:
{
  801f22:	55                   	push   %ebp
  801f23:	89 e5                	mov    %esp,%ebp
  801f25:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f28:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f2b:	50                   	push   %eax
  801f2c:	ff 75 08             	pushl  0x8(%ebp)
  801f2f:	e8 78 f4 ff ff       	call   8013ac <fd_lookup>
  801f34:	83 c4 10             	add    $0x10,%esp
  801f37:	85 c0                	test   %eax,%eax
  801f39:	78 18                	js     801f53 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801f3b:	83 ec 0c             	sub    $0xc,%esp
  801f3e:	ff 75 f4             	pushl  -0xc(%ebp)
  801f41:	e8 fd f3 ff ff       	call   801343 <fd2data>
	return _pipeisclosed(fd, p);
  801f46:	89 c2                	mov    %eax,%edx
  801f48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4b:	e8 2f fd ff ff       	call   801c7f <_pipeisclosed>
  801f50:	83 c4 10             	add    $0x10,%esp
}
  801f53:	c9                   	leave  
  801f54:	c3                   	ret    

00801f55 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801f55:	b8 00 00 00 00       	mov    $0x0,%eax
  801f5a:	c3                   	ret    

00801f5b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801f5b:	55                   	push   %ebp
  801f5c:	89 e5                	mov    %esp,%ebp
  801f5e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801f61:	68 cc 29 80 00       	push   $0x8029cc
  801f66:	ff 75 0c             	pushl  0xc(%ebp)
  801f69:	e8 54 ec ff ff       	call   800bc2 <strcpy>
	return 0;
}
  801f6e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f73:	c9                   	leave  
  801f74:	c3                   	ret    

00801f75 <devcons_write>:
{
  801f75:	55                   	push   %ebp
  801f76:	89 e5                	mov    %esp,%ebp
  801f78:	57                   	push   %edi
  801f79:	56                   	push   %esi
  801f7a:	53                   	push   %ebx
  801f7b:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801f81:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801f86:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801f8c:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f8f:	73 31                	jae    801fc2 <devcons_write+0x4d>
		m = n - tot;
  801f91:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801f94:	29 f3                	sub    %esi,%ebx
  801f96:	83 fb 7f             	cmp    $0x7f,%ebx
  801f99:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801f9e:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801fa1:	83 ec 04             	sub    $0x4,%esp
  801fa4:	53                   	push   %ebx
  801fa5:	89 f0                	mov    %esi,%eax
  801fa7:	03 45 0c             	add    0xc(%ebp),%eax
  801faa:	50                   	push   %eax
  801fab:	57                   	push   %edi
  801fac:	e8 9f ed ff ff       	call   800d50 <memmove>
		sys_cputs(buf, m);
  801fb1:	83 c4 08             	add    $0x8,%esp
  801fb4:	53                   	push   %ebx
  801fb5:	57                   	push   %edi
  801fb6:	e8 3d ef ff ff       	call   800ef8 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801fbb:	01 de                	add    %ebx,%esi
  801fbd:	83 c4 10             	add    $0x10,%esp
  801fc0:	eb ca                	jmp    801f8c <devcons_write+0x17>
}
  801fc2:	89 f0                	mov    %esi,%eax
  801fc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fc7:	5b                   	pop    %ebx
  801fc8:	5e                   	pop    %esi
  801fc9:	5f                   	pop    %edi
  801fca:	5d                   	pop    %ebp
  801fcb:	c3                   	ret    

00801fcc <devcons_read>:
{
  801fcc:	55                   	push   %ebp
  801fcd:	89 e5                	mov    %esp,%ebp
  801fcf:	83 ec 08             	sub    $0x8,%esp
  801fd2:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801fd7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fdb:	74 21                	je     801ffe <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  801fdd:	e8 34 ef ff ff       	call   800f16 <sys_cgetc>
  801fe2:	85 c0                	test   %eax,%eax
  801fe4:	75 07                	jne    801fed <devcons_read+0x21>
		sys_yield();
  801fe6:	e8 aa ef ff ff       	call   800f95 <sys_yield>
  801feb:	eb f0                	jmp    801fdd <devcons_read+0x11>
	if (c < 0)
  801fed:	78 0f                	js     801ffe <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  801fef:	83 f8 04             	cmp    $0x4,%eax
  801ff2:	74 0c                	je     802000 <devcons_read+0x34>
	*(char*)vbuf = c;
  801ff4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ff7:	88 02                	mov    %al,(%edx)
	return 1;
  801ff9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801ffe:	c9                   	leave  
  801fff:	c3                   	ret    
		return 0;
  802000:	b8 00 00 00 00       	mov    $0x0,%eax
  802005:	eb f7                	jmp    801ffe <devcons_read+0x32>

00802007 <cputchar>:
{
  802007:	55                   	push   %ebp
  802008:	89 e5                	mov    %esp,%ebp
  80200a:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80200d:	8b 45 08             	mov    0x8(%ebp),%eax
  802010:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802013:	6a 01                	push   $0x1
  802015:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802018:	50                   	push   %eax
  802019:	e8 da ee ff ff       	call   800ef8 <sys_cputs>
}
  80201e:	83 c4 10             	add    $0x10,%esp
  802021:	c9                   	leave  
  802022:	c3                   	ret    

00802023 <getchar>:
{
  802023:	55                   	push   %ebp
  802024:	89 e5                	mov    %esp,%ebp
  802026:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802029:	6a 01                	push   $0x1
  80202b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80202e:	50                   	push   %eax
  80202f:	6a 00                	push   $0x0
  802031:	e8 e1 f5 ff ff       	call   801617 <read>
	if (r < 0)
  802036:	83 c4 10             	add    $0x10,%esp
  802039:	85 c0                	test   %eax,%eax
  80203b:	78 06                	js     802043 <getchar+0x20>
	if (r < 1)
  80203d:	74 06                	je     802045 <getchar+0x22>
	return c;
  80203f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802043:	c9                   	leave  
  802044:	c3                   	ret    
		return -E_EOF;
  802045:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80204a:	eb f7                	jmp    802043 <getchar+0x20>

0080204c <iscons>:
{
  80204c:	55                   	push   %ebp
  80204d:	89 e5                	mov    %esp,%ebp
  80204f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802052:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802055:	50                   	push   %eax
  802056:	ff 75 08             	pushl  0x8(%ebp)
  802059:	e8 4e f3 ff ff       	call   8013ac <fd_lookup>
  80205e:	83 c4 10             	add    $0x10,%esp
  802061:	85 c0                	test   %eax,%eax
  802063:	78 11                	js     802076 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802065:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802068:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80206e:	39 10                	cmp    %edx,(%eax)
  802070:	0f 94 c0             	sete   %al
  802073:	0f b6 c0             	movzbl %al,%eax
}
  802076:	c9                   	leave  
  802077:	c3                   	ret    

00802078 <opencons>:
{
  802078:	55                   	push   %ebp
  802079:	89 e5                	mov    %esp,%ebp
  80207b:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80207e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802081:	50                   	push   %eax
  802082:	e8 d3 f2 ff ff       	call   80135a <fd_alloc>
  802087:	83 c4 10             	add    $0x10,%esp
  80208a:	85 c0                	test   %eax,%eax
  80208c:	78 3a                	js     8020c8 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80208e:	83 ec 04             	sub    $0x4,%esp
  802091:	68 07 04 00 00       	push   $0x407
  802096:	ff 75 f4             	pushl  -0xc(%ebp)
  802099:	6a 00                	push   $0x0
  80209b:	e8 14 ef ff ff       	call   800fb4 <sys_page_alloc>
  8020a0:	83 c4 10             	add    $0x10,%esp
  8020a3:	85 c0                	test   %eax,%eax
  8020a5:	78 21                	js     8020c8 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8020a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020aa:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8020b0:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8020b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b5:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8020bc:	83 ec 0c             	sub    $0xc,%esp
  8020bf:	50                   	push   %eax
  8020c0:	e8 6e f2 ff ff       	call   801333 <fd2num>
  8020c5:	83 c4 10             	add    $0x10,%esp
}
  8020c8:	c9                   	leave  
  8020c9:	c3                   	ret    

008020ca <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8020ca:	55                   	push   %ebp
  8020cb:	89 e5                	mov    %esp,%ebp
  8020cd:	56                   	push   %esi
  8020ce:	53                   	push   %ebx
  8020cf:	8b 75 08             	mov    0x8(%ebp),%esi
  8020d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// cprintf("in %s\n", __FUNCTION__);
	int ret;
	if(!pg)
  8020d8:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8020da:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8020df:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8020e2:	83 ec 0c             	sub    $0xc,%esp
  8020e5:	50                   	push   %eax
  8020e6:	e8 79 f0 ff ff       	call   801164 <sys_ipc_recv>
	if(ret < 0){
  8020eb:	83 c4 10             	add    $0x10,%esp
  8020ee:	85 c0                	test   %eax,%eax
  8020f0:	78 2b                	js     80211d <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8020f2:	85 f6                	test   %esi,%esi
  8020f4:	74 0a                	je     802100 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  8020f6:	a1 20 44 80 00       	mov    0x804420,%eax
  8020fb:	8b 40 74             	mov    0x74(%eax),%eax
  8020fe:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802100:	85 db                	test   %ebx,%ebx
  802102:	74 0a                	je     80210e <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  802104:	a1 20 44 80 00       	mov    0x804420,%eax
  802109:	8b 40 78             	mov    0x78(%eax),%eax
  80210c:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  80210e:	a1 20 44 80 00       	mov    0x804420,%eax
  802113:	8b 40 70             	mov    0x70(%eax),%eax
}
  802116:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802119:	5b                   	pop    %ebx
  80211a:	5e                   	pop    %esi
  80211b:	5d                   	pop    %ebp
  80211c:	c3                   	ret    
		if(from_env_store)
  80211d:	85 f6                	test   %esi,%esi
  80211f:	74 06                	je     802127 <ipc_recv+0x5d>
			*from_env_store = 0;
  802121:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802127:	85 db                	test   %ebx,%ebx
  802129:	74 eb                	je     802116 <ipc_recv+0x4c>
			*perm_store = 0;
  80212b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802131:	eb e3                	jmp    802116 <ipc_recv+0x4c>

00802133 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802133:	55                   	push   %ebp
  802134:	89 e5                	mov    %esp,%ebp
  802136:	57                   	push   %edi
  802137:	56                   	push   %esi
  802138:	53                   	push   %ebx
  802139:	83 ec 0c             	sub    $0xc,%esp
  80213c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80213f:	8b 75 0c             	mov    0xc(%ebp),%esi
  802142:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802145:	85 db                	test   %ebx,%ebx
  802147:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80214c:	0f 44 d8             	cmove  %eax,%ebx
  80214f:	eb 05                	jmp    802156 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802151:	e8 3f ee ff ff       	call   800f95 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802156:	ff 75 14             	pushl  0x14(%ebp)
  802159:	53                   	push   %ebx
  80215a:	56                   	push   %esi
  80215b:	57                   	push   %edi
  80215c:	e8 e0 ef ff ff       	call   801141 <sys_ipc_try_send>
  802161:	83 c4 10             	add    $0x10,%esp
  802164:	85 c0                	test   %eax,%eax
  802166:	74 1b                	je     802183 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802168:	79 e7                	jns    802151 <ipc_send+0x1e>
  80216a:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80216d:	74 e2                	je     802151 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80216f:	83 ec 04             	sub    $0x4,%esp
  802172:	68 d8 29 80 00       	push   $0x8029d8
  802177:	6a 49                	push   $0x49
  802179:	68 ed 29 80 00       	push   $0x8029ed
  80217e:	e8 ea e1 ff ff       	call   80036d <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802183:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802186:	5b                   	pop    %ebx
  802187:	5e                   	pop    %esi
  802188:	5f                   	pop    %edi
  802189:	5d                   	pop    %ebp
  80218a:	c3                   	ret    

0080218b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80218b:	55                   	push   %ebp
  80218c:	89 e5                	mov    %esp,%ebp
  80218e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802191:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802196:	89 c2                	mov    %eax,%edx
  802198:	c1 e2 07             	shl    $0x7,%edx
  80219b:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8021a1:	8b 52 50             	mov    0x50(%edx),%edx
  8021a4:	39 ca                	cmp    %ecx,%edx
  8021a6:	74 11                	je     8021b9 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8021a8:	83 c0 01             	add    $0x1,%eax
  8021ab:	3d 00 04 00 00       	cmp    $0x400,%eax
  8021b0:	75 e4                	jne    802196 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8021b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b7:	eb 0b                	jmp    8021c4 <ipc_find_env+0x39>
			return envs[i].env_id;
  8021b9:	c1 e0 07             	shl    $0x7,%eax
  8021bc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8021c1:	8b 40 48             	mov    0x48(%eax),%eax
}
  8021c4:	5d                   	pop    %ebp
  8021c5:	c3                   	ret    

008021c6 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8021c6:	55                   	push   %ebp
  8021c7:	89 e5                	mov    %esp,%ebp
  8021c9:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8021cc:	89 d0                	mov    %edx,%eax
  8021ce:	c1 e8 16             	shr    $0x16,%eax
  8021d1:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8021d8:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8021dd:	f6 c1 01             	test   $0x1,%cl
  8021e0:	74 1d                	je     8021ff <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8021e2:	c1 ea 0c             	shr    $0xc,%edx
  8021e5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8021ec:	f6 c2 01             	test   $0x1,%dl
  8021ef:	74 0e                	je     8021ff <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8021f1:	c1 ea 0c             	shr    $0xc,%edx
  8021f4:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8021fb:	ef 
  8021fc:	0f b7 c0             	movzwl %ax,%eax
}
  8021ff:	5d                   	pop    %ebp
  802200:	c3                   	ret    
  802201:	66 90                	xchg   %ax,%ax
  802203:	66 90                	xchg   %ax,%ax
  802205:	66 90                	xchg   %ax,%ax
  802207:	66 90                	xchg   %ax,%ax
  802209:	66 90                	xchg   %ax,%ax
  80220b:	66 90                	xchg   %ax,%ax
  80220d:	66 90                	xchg   %ax,%ax
  80220f:	90                   	nop

00802210 <__udivdi3>:
  802210:	55                   	push   %ebp
  802211:	57                   	push   %edi
  802212:	56                   	push   %esi
  802213:	53                   	push   %ebx
  802214:	83 ec 1c             	sub    $0x1c,%esp
  802217:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80221b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80221f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802223:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802227:	85 d2                	test   %edx,%edx
  802229:	75 4d                	jne    802278 <__udivdi3+0x68>
  80222b:	39 f3                	cmp    %esi,%ebx
  80222d:	76 19                	jbe    802248 <__udivdi3+0x38>
  80222f:	31 ff                	xor    %edi,%edi
  802231:	89 e8                	mov    %ebp,%eax
  802233:	89 f2                	mov    %esi,%edx
  802235:	f7 f3                	div    %ebx
  802237:	89 fa                	mov    %edi,%edx
  802239:	83 c4 1c             	add    $0x1c,%esp
  80223c:	5b                   	pop    %ebx
  80223d:	5e                   	pop    %esi
  80223e:	5f                   	pop    %edi
  80223f:	5d                   	pop    %ebp
  802240:	c3                   	ret    
  802241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802248:	89 d9                	mov    %ebx,%ecx
  80224a:	85 db                	test   %ebx,%ebx
  80224c:	75 0b                	jne    802259 <__udivdi3+0x49>
  80224e:	b8 01 00 00 00       	mov    $0x1,%eax
  802253:	31 d2                	xor    %edx,%edx
  802255:	f7 f3                	div    %ebx
  802257:	89 c1                	mov    %eax,%ecx
  802259:	31 d2                	xor    %edx,%edx
  80225b:	89 f0                	mov    %esi,%eax
  80225d:	f7 f1                	div    %ecx
  80225f:	89 c6                	mov    %eax,%esi
  802261:	89 e8                	mov    %ebp,%eax
  802263:	89 f7                	mov    %esi,%edi
  802265:	f7 f1                	div    %ecx
  802267:	89 fa                	mov    %edi,%edx
  802269:	83 c4 1c             	add    $0x1c,%esp
  80226c:	5b                   	pop    %ebx
  80226d:	5e                   	pop    %esi
  80226e:	5f                   	pop    %edi
  80226f:	5d                   	pop    %ebp
  802270:	c3                   	ret    
  802271:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802278:	39 f2                	cmp    %esi,%edx
  80227a:	77 1c                	ja     802298 <__udivdi3+0x88>
  80227c:	0f bd fa             	bsr    %edx,%edi
  80227f:	83 f7 1f             	xor    $0x1f,%edi
  802282:	75 2c                	jne    8022b0 <__udivdi3+0xa0>
  802284:	39 f2                	cmp    %esi,%edx
  802286:	72 06                	jb     80228e <__udivdi3+0x7e>
  802288:	31 c0                	xor    %eax,%eax
  80228a:	39 eb                	cmp    %ebp,%ebx
  80228c:	77 a9                	ja     802237 <__udivdi3+0x27>
  80228e:	b8 01 00 00 00       	mov    $0x1,%eax
  802293:	eb a2                	jmp    802237 <__udivdi3+0x27>
  802295:	8d 76 00             	lea    0x0(%esi),%esi
  802298:	31 ff                	xor    %edi,%edi
  80229a:	31 c0                	xor    %eax,%eax
  80229c:	89 fa                	mov    %edi,%edx
  80229e:	83 c4 1c             	add    $0x1c,%esp
  8022a1:	5b                   	pop    %ebx
  8022a2:	5e                   	pop    %esi
  8022a3:	5f                   	pop    %edi
  8022a4:	5d                   	pop    %ebp
  8022a5:	c3                   	ret    
  8022a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022ad:	8d 76 00             	lea    0x0(%esi),%esi
  8022b0:	89 f9                	mov    %edi,%ecx
  8022b2:	b8 20 00 00 00       	mov    $0x20,%eax
  8022b7:	29 f8                	sub    %edi,%eax
  8022b9:	d3 e2                	shl    %cl,%edx
  8022bb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8022bf:	89 c1                	mov    %eax,%ecx
  8022c1:	89 da                	mov    %ebx,%edx
  8022c3:	d3 ea                	shr    %cl,%edx
  8022c5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8022c9:	09 d1                	or     %edx,%ecx
  8022cb:	89 f2                	mov    %esi,%edx
  8022cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022d1:	89 f9                	mov    %edi,%ecx
  8022d3:	d3 e3                	shl    %cl,%ebx
  8022d5:	89 c1                	mov    %eax,%ecx
  8022d7:	d3 ea                	shr    %cl,%edx
  8022d9:	89 f9                	mov    %edi,%ecx
  8022db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8022df:	89 eb                	mov    %ebp,%ebx
  8022e1:	d3 e6                	shl    %cl,%esi
  8022e3:	89 c1                	mov    %eax,%ecx
  8022e5:	d3 eb                	shr    %cl,%ebx
  8022e7:	09 de                	or     %ebx,%esi
  8022e9:	89 f0                	mov    %esi,%eax
  8022eb:	f7 74 24 08          	divl   0x8(%esp)
  8022ef:	89 d6                	mov    %edx,%esi
  8022f1:	89 c3                	mov    %eax,%ebx
  8022f3:	f7 64 24 0c          	mull   0xc(%esp)
  8022f7:	39 d6                	cmp    %edx,%esi
  8022f9:	72 15                	jb     802310 <__udivdi3+0x100>
  8022fb:	89 f9                	mov    %edi,%ecx
  8022fd:	d3 e5                	shl    %cl,%ebp
  8022ff:	39 c5                	cmp    %eax,%ebp
  802301:	73 04                	jae    802307 <__udivdi3+0xf7>
  802303:	39 d6                	cmp    %edx,%esi
  802305:	74 09                	je     802310 <__udivdi3+0x100>
  802307:	89 d8                	mov    %ebx,%eax
  802309:	31 ff                	xor    %edi,%edi
  80230b:	e9 27 ff ff ff       	jmp    802237 <__udivdi3+0x27>
  802310:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802313:	31 ff                	xor    %edi,%edi
  802315:	e9 1d ff ff ff       	jmp    802237 <__udivdi3+0x27>
  80231a:	66 90                	xchg   %ax,%ax
  80231c:	66 90                	xchg   %ax,%ax
  80231e:	66 90                	xchg   %ax,%ax

00802320 <__umoddi3>:
  802320:	55                   	push   %ebp
  802321:	57                   	push   %edi
  802322:	56                   	push   %esi
  802323:	53                   	push   %ebx
  802324:	83 ec 1c             	sub    $0x1c,%esp
  802327:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80232b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80232f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802333:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802337:	89 da                	mov    %ebx,%edx
  802339:	85 c0                	test   %eax,%eax
  80233b:	75 43                	jne    802380 <__umoddi3+0x60>
  80233d:	39 df                	cmp    %ebx,%edi
  80233f:	76 17                	jbe    802358 <__umoddi3+0x38>
  802341:	89 f0                	mov    %esi,%eax
  802343:	f7 f7                	div    %edi
  802345:	89 d0                	mov    %edx,%eax
  802347:	31 d2                	xor    %edx,%edx
  802349:	83 c4 1c             	add    $0x1c,%esp
  80234c:	5b                   	pop    %ebx
  80234d:	5e                   	pop    %esi
  80234e:	5f                   	pop    %edi
  80234f:	5d                   	pop    %ebp
  802350:	c3                   	ret    
  802351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802358:	89 fd                	mov    %edi,%ebp
  80235a:	85 ff                	test   %edi,%edi
  80235c:	75 0b                	jne    802369 <__umoddi3+0x49>
  80235e:	b8 01 00 00 00       	mov    $0x1,%eax
  802363:	31 d2                	xor    %edx,%edx
  802365:	f7 f7                	div    %edi
  802367:	89 c5                	mov    %eax,%ebp
  802369:	89 d8                	mov    %ebx,%eax
  80236b:	31 d2                	xor    %edx,%edx
  80236d:	f7 f5                	div    %ebp
  80236f:	89 f0                	mov    %esi,%eax
  802371:	f7 f5                	div    %ebp
  802373:	89 d0                	mov    %edx,%eax
  802375:	eb d0                	jmp    802347 <__umoddi3+0x27>
  802377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80237e:	66 90                	xchg   %ax,%ax
  802380:	89 f1                	mov    %esi,%ecx
  802382:	39 d8                	cmp    %ebx,%eax
  802384:	76 0a                	jbe    802390 <__umoddi3+0x70>
  802386:	89 f0                	mov    %esi,%eax
  802388:	83 c4 1c             	add    $0x1c,%esp
  80238b:	5b                   	pop    %ebx
  80238c:	5e                   	pop    %esi
  80238d:	5f                   	pop    %edi
  80238e:	5d                   	pop    %ebp
  80238f:	c3                   	ret    
  802390:	0f bd e8             	bsr    %eax,%ebp
  802393:	83 f5 1f             	xor    $0x1f,%ebp
  802396:	75 20                	jne    8023b8 <__umoddi3+0x98>
  802398:	39 d8                	cmp    %ebx,%eax
  80239a:	0f 82 b0 00 00 00    	jb     802450 <__umoddi3+0x130>
  8023a0:	39 f7                	cmp    %esi,%edi
  8023a2:	0f 86 a8 00 00 00    	jbe    802450 <__umoddi3+0x130>
  8023a8:	89 c8                	mov    %ecx,%eax
  8023aa:	83 c4 1c             	add    $0x1c,%esp
  8023ad:	5b                   	pop    %ebx
  8023ae:	5e                   	pop    %esi
  8023af:	5f                   	pop    %edi
  8023b0:	5d                   	pop    %ebp
  8023b1:	c3                   	ret    
  8023b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8023b8:	89 e9                	mov    %ebp,%ecx
  8023ba:	ba 20 00 00 00       	mov    $0x20,%edx
  8023bf:	29 ea                	sub    %ebp,%edx
  8023c1:	d3 e0                	shl    %cl,%eax
  8023c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023c7:	89 d1                	mov    %edx,%ecx
  8023c9:	89 f8                	mov    %edi,%eax
  8023cb:	d3 e8                	shr    %cl,%eax
  8023cd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023d1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8023d5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8023d9:	09 c1                	or     %eax,%ecx
  8023db:	89 d8                	mov    %ebx,%eax
  8023dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023e1:	89 e9                	mov    %ebp,%ecx
  8023e3:	d3 e7                	shl    %cl,%edi
  8023e5:	89 d1                	mov    %edx,%ecx
  8023e7:	d3 e8                	shr    %cl,%eax
  8023e9:	89 e9                	mov    %ebp,%ecx
  8023eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8023ef:	d3 e3                	shl    %cl,%ebx
  8023f1:	89 c7                	mov    %eax,%edi
  8023f3:	89 d1                	mov    %edx,%ecx
  8023f5:	89 f0                	mov    %esi,%eax
  8023f7:	d3 e8                	shr    %cl,%eax
  8023f9:	89 e9                	mov    %ebp,%ecx
  8023fb:	89 fa                	mov    %edi,%edx
  8023fd:	d3 e6                	shl    %cl,%esi
  8023ff:	09 d8                	or     %ebx,%eax
  802401:	f7 74 24 08          	divl   0x8(%esp)
  802405:	89 d1                	mov    %edx,%ecx
  802407:	89 f3                	mov    %esi,%ebx
  802409:	f7 64 24 0c          	mull   0xc(%esp)
  80240d:	89 c6                	mov    %eax,%esi
  80240f:	89 d7                	mov    %edx,%edi
  802411:	39 d1                	cmp    %edx,%ecx
  802413:	72 06                	jb     80241b <__umoddi3+0xfb>
  802415:	75 10                	jne    802427 <__umoddi3+0x107>
  802417:	39 c3                	cmp    %eax,%ebx
  802419:	73 0c                	jae    802427 <__umoddi3+0x107>
  80241b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80241f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802423:	89 d7                	mov    %edx,%edi
  802425:	89 c6                	mov    %eax,%esi
  802427:	89 ca                	mov    %ecx,%edx
  802429:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80242e:	29 f3                	sub    %esi,%ebx
  802430:	19 fa                	sbb    %edi,%edx
  802432:	89 d0                	mov    %edx,%eax
  802434:	d3 e0                	shl    %cl,%eax
  802436:	89 e9                	mov    %ebp,%ecx
  802438:	d3 eb                	shr    %cl,%ebx
  80243a:	d3 ea                	shr    %cl,%edx
  80243c:	09 d8                	or     %ebx,%eax
  80243e:	83 c4 1c             	add    $0x1c,%esp
  802441:	5b                   	pop    %ebx
  802442:	5e                   	pop    %esi
  802443:	5f                   	pop    %edi
  802444:	5d                   	pop    %ebp
  802445:	c3                   	ret    
  802446:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80244d:	8d 76 00             	lea    0x0(%esi),%esi
  802450:	89 da                	mov    %ebx,%edx
  802452:	29 fe                	sub    %edi,%esi
  802454:	19 c2                	sbb    %eax,%edx
  802456:	89 f1                	mov    %esi,%ecx
  802458:	89 c8                	mov    %ecx,%eax
  80245a:	e9 4b ff ff ff       	jmp    8023aa <__umoddi3+0x8a>
