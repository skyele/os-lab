
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
  80005f:	e8 92 1c 00 00       	call   801cf6 <printf>
  800064:	83 c4 10             	add    $0x10,%esp
	if(prefix) {
  800067:	85 db                	test   %ebx,%ebx
  800069:	74 1c                	je     800087 <ls1+0x54>
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
			sep = "/";
		else
			sep = "";
  80006b:	b8 b3 2f 80 00       	mov    $0x802fb3,%eax
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  800070:	80 3b 00             	cmpb   $0x0,(%ebx)
  800073:	75 4b                	jne    8000c0 <ls1+0x8d>
		printf("%s%s", prefix, sep);
  800075:	83 ec 04             	sub    $0x4,%esp
  800078:	50                   	push   %eax
  800079:	53                   	push   %ebx
  80007a:	68 eb 29 80 00       	push   $0x8029eb
  80007f:	e8 72 1c 00 00       	call   801cf6 <printf>
  800084:	83 c4 10             	add    $0x10,%esp
	}
	printf("%s", name);
  800087:	83 ec 08             	sub    $0x8,%esp
  80008a:	ff 75 14             	pushl  0x14(%ebp)
  80008d:	68 21 2f 80 00       	push   $0x802f21
  800092:	e8 5f 1c 00 00       	call   801cf6 <printf>
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
  8000ac:	68 b2 2f 80 00       	push   $0x802fb2
  8000b1:	e8 40 1c 00 00       	call   801cf6 <printf>
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
  8000c4:	e8 96 0a 00 00       	call   800b5f <strlen>
  8000c9:	83 c4 10             	add    $0x10,%esp
			sep = "";
  8000cc:	80 7c 03 ff 2f       	cmpb   $0x2f,-0x1(%ebx,%eax,1)
  8000d1:	b8 e0 29 80 00       	mov    $0x8029e0,%eax
  8000d6:	ba b3 2f 80 00       	mov    $0x802fb3,%edx
  8000db:	0f 44 c2             	cmove  %edx,%eax
  8000de:	eb 95                	jmp    800075 <ls1+0x42>
		printf("/");
  8000e0:	83 ec 0c             	sub    $0xc,%esp
  8000e3:	68 e0 29 80 00       	push   $0x8029e0
  8000e8:	e8 09 1c 00 00       	call   801cf6 <printf>
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
  800104:	e8 4a 1a 00 00       	call   801b53 <open>
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
  800122:	e8 15 16 00 00       	call   80173c <readn>
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
  80016d:	e8 d1 01 00 00       	call   800343 <_panic>
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
  80018d:	e8 b1 01 00 00       	call   800343 <_panic>
		panic("error reading directory %s: %e", path, n);
  800192:	83 ec 0c             	sub    $0xc,%esp
  800195:	50                   	push   %eax
  800196:	57                   	push   %edi
  800197:	68 4c 2a 80 00       	push   $0x802a4c
  80019c:	6a 24                	push   $0x24
  80019e:	68 fc 29 80 00       	push   $0x8029fc
  8001a3:	e8 9b 01 00 00       	call   800343 <_panic>

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
  8001bd:	e8 5d 17 00 00       	call   80191f <stat>
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
  800206:	e8 38 01 00 00       	call   800343 <_panic>
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
  800227:	e8 ca 1a 00 00       	call   801cf6 <printf>
	exit();
  80022c:	e8 de 00 00 00       	call   80030f <exit>
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
  80024a:	e8 30 10 00 00       	call   80127f <argstart>
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
  800263:	e8 47 10 00 00       	call   8012af <argnext>
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
  800293:	68 b3 2f 80 00       	push   $0x802fb3
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
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002c6:	55                   	push   %ebp
  8002c7:	89 e5                	mov    %esp,%ebp
  8002c9:	56                   	push   %esi
  8002ca:	53                   	push   %ebx
  8002cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8002ce:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	envid_t curenv = sys_getenvid();
  8002d1:	e8 76 0c 00 00       	call   800f4c <sys_getenvid>
	thisenv = envs + ENVX(curenv);
  8002d6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002db:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8002e1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002e6:	a3 20 44 80 00       	mov    %eax,0x804420

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002eb:	85 db                	test   %ebx,%ebx
  8002ed:	7e 07                	jle    8002f6 <libmain+0x30>
		binaryname = argv[0];
  8002ef:	8b 06                	mov    (%esi),%eax
  8002f1:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8002f6:	83 ec 08             	sub    $0x8,%esp
  8002f9:	56                   	push   %esi
  8002fa:	53                   	push   %ebx
  8002fb:	e8 36 ff ff ff       	call   800236 <umain>

	// exit gracefully
	exit();
  800300:	e8 0a 00 00 00       	call   80030f <exit>
}
  800305:	83 c4 10             	add    $0x10,%esp
  800308:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80030b:	5b                   	pop    %ebx
  80030c:	5e                   	pop    %esi
  80030d:	5d                   	pop    %ebp
  80030e:	c3                   	ret    

0080030f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80030f:	55                   	push   %ebp
  800310:	89 e5                	mov    %esp,%ebp
  800312:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800315:	a1 20 44 80 00       	mov    0x804420,%eax
  80031a:	8b 40 48             	mov    0x48(%eax),%eax
  80031d:	68 80 2a 80 00       	push   $0x802a80
  800322:	50                   	push   %eax
  800323:	68 75 2a 80 00       	push   $0x802a75
  800328:	e8 0c 01 00 00       	call   800439 <cprintf>
	close_all();
  80032d:	e8 72 12 00 00       	call   8015a4 <close_all>
	sys_env_destroy(0);
  800332:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800339:	e8 cd 0b 00 00       	call   800f0b <sys_env_destroy>
}
  80033e:	83 c4 10             	add    $0x10,%esp
  800341:	c9                   	leave  
  800342:	c3                   	ret    

00800343 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800343:	55                   	push   %ebp
  800344:	89 e5                	mov    %esp,%ebp
  800346:	56                   	push   %esi
  800347:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800348:	a1 20 44 80 00       	mov    0x804420,%eax
  80034d:	8b 40 48             	mov    0x48(%eax),%eax
  800350:	83 ec 04             	sub    $0x4,%esp
  800353:	68 ac 2a 80 00       	push   $0x802aac
  800358:	50                   	push   %eax
  800359:	68 75 2a 80 00       	push   $0x802a75
  80035e:	e8 d6 00 00 00       	call   800439 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800363:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800366:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80036c:	e8 db 0b 00 00       	call   800f4c <sys_getenvid>
  800371:	83 c4 04             	add    $0x4,%esp
  800374:	ff 75 0c             	pushl  0xc(%ebp)
  800377:	ff 75 08             	pushl  0x8(%ebp)
  80037a:	56                   	push   %esi
  80037b:	50                   	push   %eax
  80037c:	68 88 2a 80 00       	push   $0x802a88
  800381:	e8 b3 00 00 00       	call   800439 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800386:	83 c4 18             	add    $0x18,%esp
  800389:	53                   	push   %ebx
  80038a:	ff 75 10             	pushl  0x10(%ebp)
  80038d:	e8 56 00 00 00       	call   8003e8 <vcprintf>
	cprintf("\n");
  800392:	c7 04 24 b2 2f 80 00 	movl   $0x802fb2,(%esp)
  800399:	e8 9b 00 00 00       	call   800439 <cprintf>
  80039e:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003a1:	cc                   	int3   
  8003a2:	eb fd                	jmp    8003a1 <_panic+0x5e>

008003a4 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8003a4:	55                   	push   %ebp
  8003a5:	89 e5                	mov    %esp,%ebp
  8003a7:	53                   	push   %ebx
  8003a8:	83 ec 04             	sub    $0x4,%esp
  8003ab:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8003ae:	8b 13                	mov    (%ebx),%edx
  8003b0:	8d 42 01             	lea    0x1(%edx),%eax
  8003b3:	89 03                	mov    %eax,(%ebx)
  8003b5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003b8:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003bc:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003c1:	74 09                	je     8003cc <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8003c3:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003ca:	c9                   	leave  
  8003cb:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8003cc:	83 ec 08             	sub    $0x8,%esp
  8003cf:	68 ff 00 00 00       	push   $0xff
  8003d4:	8d 43 08             	lea    0x8(%ebx),%eax
  8003d7:	50                   	push   %eax
  8003d8:	e8 f1 0a 00 00       	call   800ece <sys_cputs>
		b->idx = 0;
  8003dd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003e3:	83 c4 10             	add    $0x10,%esp
  8003e6:	eb db                	jmp    8003c3 <putch+0x1f>

008003e8 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003e8:	55                   	push   %ebp
  8003e9:	89 e5                	mov    %esp,%ebp
  8003eb:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003f1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003f8:	00 00 00 
	b.cnt = 0;
  8003fb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800402:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800405:	ff 75 0c             	pushl  0xc(%ebp)
  800408:	ff 75 08             	pushl  0x8(%ebp)
  80040b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800411:	50                   	push   %eax
  800412:	68 a4 03 80 00       	push   $0x8003a4
  800417:	e8 4a 01 00 00       	call   800566 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80041c:	83 c4 08             	add    $0x8,%esp
  80041f:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800425:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80042b:	50                   	push   %eax
  80042c:	e8 9d 0a 00 00       	call   800ece <sys_cputs>

	return b.cnt;
}
  800431:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800437:	c9                   	leave  
  800438:	c3                   	ret    

00800439 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800439:	55                   	push   %ebp
  80043a:	89 e5                	mov    %esp,%ebp
  80043c:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80043f:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800442:	50                   	push   %eax
  800443:	ff 75 08             	pushl  0x8(%ebp)
  800446:	e8 9d ff ff ff       	call   8003e8 <vcprintf>
	va_end(ap);

	return cnt;
}
  80044b:	c9                   	leave  
  80044c:	c3                   	ret    

0080044d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80044d:	55                   	push   %ebp
  80044e:	89 e5                	mov    %esp,%ebp
  800450:	57                   	push   %edi
  800451:	56                   	push   %esi
  800452:	53                   	push   %ebx
  800453:	83 ec 1c             	sub    $0x1c,%esp
  800456:	89 c6                	mov    %eax,%esi
  800458:	89 d7                	mov    %edx,%edi
  80045a:	8b 45 08             	mov    0x8(%ebp),%eax
  80045d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800460:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800463:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800466:	8b 45 10             	mov    0x10(%ebp),%eax
  800469:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80046c:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800470:	74 2c                	je     80049e <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800472:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800475:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80047c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80047f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800482:	39 c2                	cmp    %eax,%edx
  800484:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800487:	73 43                	jae    8004cc <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800489:	83 eb 01             	sub    $0x1,%ebx
  80048c:	85 db                	test   %ebx,%ebx
  80048e:	7e 6c                	jle    8004fc <printnum+0xaf>
				putch(padc, putdat);
  800490:	83 ec 08             	sub    $0x8,%esp
  800493:	57                   	push   %edi
  800494:	ff 75 18             	pushl  0x18(%ebp)
  800497:	ff d6                	call   *%esi
  800499:	83 c4 10             	add    $0x10,%esp
  80049c:	eb eb                	jmp    800489 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80049e:	83 ec 0c             	sub    $0xc,%esp
  8004a1:	6a 20                	push   $0x20
  8004a3:	6a 00                	push   $0x0
  8004a5:	50                   	push   %eax
  8004a6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004a9:	ff 75 e0             	pushl  -0x20(%ebp)
  8004ac:	89 fa                	mov    %edi,%edx
  8004ae:	89 f0                	mov    %esi,%eax
  8004b0:	e8 98 ff ff ff       	call   80044d <printnum>
		while (--width > 0)
  8004b5:	83 c4 20             	add    $0x20,%esp
  8004b8:	83 eb 01             	sub    $0x1,%ebx
  8004bb:	85 db                	test   %ebx,%ebx
  8004bd:	7e 65                	jle    800524 <printnum+0xd7>
			putch(padc, putdat);
  8004bf:	83 ec 08             	sub    $0x8,%esp
  8004c2:	57                   	push   %edi
  8004c3:	6a 20                	push   $0x20
  8004c5:	ff d6                	call   *%esi
  8004c7:	83 c4 10             	add    $0x10,%esp
  8004ca:	eb ec                	jmp    8004b8 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8004cc:	83 ec 0c             	sub    $0xc,%esp
  8004cf:	ff 75 18             	pushl  0x18(%ebp)
  8004d2:	83 eb 01             	sub    $0x1,%ebx
  8004d5:	53                   	push   %ebx
  8004d6:	50                   	push   %eax
  8004d7:	83 ec 08             	sub    $0x8,%esp
  8004da:	ff 75 dc             	pushl  -0x24(%ebp)
  8004dd:	ff 75 d8             	pushl  -0x28(%ebp)
  8004e0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004e3:	ff 75 e0             	pushl  -0x20(%ebp)
  8004e6:	e8 95 22 00 00       	call   802780 <__udivdi3>
  8004eb:	83 c4 18             	add    $0x18,%esp
  8004ee:	52                   	push   %edx
  8004ef:	50                   	push   %eax
  8004f0:	89 fa                	mov    %edi,%edx
  8004f2:	89 f0                	mov    %esi,%eax
  8004f4:	e8 54 ff ff ff       	call   80044d <printnum>
  8004f9:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8004fc:	83 ec 08             	sub    $0x8,%esp
  8004ff:	57                   	push   %edi
  800500:	83 ec 04             	sub    $0x4,%esp
  800503:	ff 75 dc             	pushl  -0x24(%ebp)
  800506:	ff 75 d8             	pushl  -0x28(%ebp)
  800509:	ff 75 e4             	pushl  -0x1c(%ebp)
  80050c:	ff 75 e0             	pushl  -0x20(%ebp)
  80050f:	e8 7c 23 00 00       	call   802890 <__umoddi3>
  800514:	83 c4 14             	add    $0x14,%esp
  800517:	0f be 80 b3 2a 80 00 	movsbl 0x802ab3(%eax),%eax
  80051e:	50                   	push   %eax
  80051f:	ff d6                	call   *%esi
  800521:	83 c4 10             	add    $0x10,%esp
	}
}
  800524:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800527:	5b                   	pop    %ebx
  800528:	5e                   	pop    %esi
  800529:	5f                   	pop    %edi
  80052a:	5d                   	pop    %ebp
  80052b:	c3                   	ret    

0080052c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80052c:	55                   	push   %ebp
  80052d:	89 e5                	mov    %esp,%ebp
  80052f:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800532:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800536:	8b 10                	mov    (%eax),%edx
  800538:	3b 50 04             	cmp    0x4(%eax),%edx
  80053b:	73 0a                	jae    800547 <sprintputch+0x1b>
		*b->buf++ = ch;
  80053d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800540:	89 08                	mov    %ecx,(%eax)
  800542:	8b 45 08             	mov    0x8(%ebp),%eax
  800545:	88 02                	mov    %al,(%edx)
}
  800547:	5d                   	pop    %ebp
  800548:	c3                   	ret    

00800549 <printfmt>:
{
  800549:	55                   	push   %ebp
  80054a:	89 e5                	mov    %esp,%ebp
  80054c:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80054f:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800552:	50                   	push   %eax
  800553:	ff 75 10             	pushl  0x10(%ebp)
  800556:	ff 75 0c             	pushl  0xc(%ebp)
  800559:	ff 75 08             	pushl  0x8(%ebp)
  80055c:	e8 05 00 00 00       	call   800566 <vprintfmt>
}
  800561:	83 c4 10             	add    $0x10,%esp
  800564:	c9                   	leave  
  800565:	c3                   	ret    

00800566 <vprintfmt>:
{
  800566:	55                   	push   %ebp
  800567:	89 e5                	mov    %esp,%ebp
  800569:	57                   	push   %edi
  80056a:	56                   	push   %esi
  80056b:	53                   	push   %ebx
  80056c:	83 ec 3c             	sub    $0x3c,%esp
  80056f:	8b 75 08             	mov    0x8(%ebp),%esi
  800572:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800575:	8b 7d 10             	mov    0x10(%ebp),%edi
  800578:	e9 32 04 00 00       	jmp    8009af <vprintfmt+0x449>
		padc = ' ';
  80057d:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800581:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800588:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80058f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800596:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80059d:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8005a4:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8005a9:	8d 47 01             	lea    0x1(%edi),%eax
  8005ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005af:	0f b6 17             	movzbl (%edi),%edx
  8005b2:	8d 42 dd             	lea    -0x23(%edx),%eax
  8005b5:	3c 55                	cmp    $0x55,%al
  8005b7:	0f 87 12 05 00 00    	ja     800acf <vprintfmt+0x569>
  8005bd:	0f b6 c0             	movzbl %al,%eax
  8005c0:	ff 24 85 a0 2c 80 00 	jmp    *0x802ca0(,%eax,4)
  8005c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8005ca:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8005ce:	eb d9                	jmp    8005a9 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8005d0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8005d3:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8005d7:	eb d0                	jmp    8005a9 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8005d9:	0f b6 d2             	movzbl %dl,%edx
  8005dc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8005df:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e4:	89 75 08             	mov    %esi,0x8(%ebp)
  8005e7:	eb 03                	jmp    8005ec <vprintfmt+0x86>
  8005e9:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8005ec:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8005ef:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8005f3:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8005f6:	8d 72 d0             	lea    -0x30(%edx),%esi
  8005f9:	83 fe 09             	cmp    $0x9,%esi
  8005fc:	76 eb                	jbe    8005e9 <vprintfmt+0x83>
  8005fe:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800601:	8b 75 08             	mov    0x8(%ebp),%esi
  800604:	eb 14                	jmp    80061a <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800606:	8b 45 14             	mov    0x14(%ebp),%eax
  800609:	8b 00                	mov    (%eax),%eax
  80060b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80060e:	8b 45 14             	mov    0x14(%ebp),%eax
  800611:	8d 40 04             	lea    0x4(%eax),%eax
  800614:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800617:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80061a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80061e:	79 89                	jns    8005a9 <vprintfmt+0x43>
				width = precision, precision = -1;
  800620:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800623:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800626:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80062d:	e9 77 ff ff ff       	jmp    8005a9 <vprintfmt+0x43>
  800632:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800635:	85 c0                	test   %eax,%eax
  800637:	0f 48 c1             	cmovs  %ecx,%eax
  80063a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80063d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800640:	e9 64 ff ff ff       	jmp    8005a9 <vprintfmt+0x43>
  800645:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800648:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80064f:	e9 55 ff ff ff       	jmp    8005a9 <vprintfmt+0x43>
			lflag++;
  800654:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800658:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80065b:	e9 49 ff ff ff       	jmp    8005a9 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800660:	8b 45 14             	mov    0x14(%ebp),%eax
  800663:	8d 78 04             	lea    0x4(%eax),%edi
  800666:	83 ec 08             	sub    $0x8,%esp
  800669:	53                   	push   %ebx
  80066a:	ff 30                	pushl  (%eax)
  80066c:	ff d6                	call   *%esi
			break;
  80066e:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800671:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800674:	e9 33 03 00 00       	jmp    8009ac <vprintfmt+0x446>
			err = va_arg(ap, int);
  800679:	8b 45 14             	mov    0x14(%ebp),%eax
  80067c:	8d 78 04             	lea    0x4(%eax),%edi
  80067f:	8b 00                	mov    (%eax),%eax
  800681:	99                   	cltd   
  800682:	31 d0                	xor    %edx,%eax
  800684:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800686:	83 f8 11             	cmp    $0x11,%eax
  800689:	7f 23                	jg     8006ae <vprintfmt+0x148>
  80068b:	8b 14 85 00 2e 80 00 	mov    0x802e00(,%eax,4),%edx
  800692:	85 d2                	test   %edx,%edx
  800694:	74 18                	je     8006ae <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800696:	52                   	push   %edx
  800697:	68 21 2f 80 00       	push   $0x802f21
  80069c:	53                   	push   %ebx
  80069d:	56                   	push   %esi
  80069e:	e8 a6 fe ff ff       	call   800549 <printfmt>
  8006a3:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8006a6:	89 7d 14             	mov    %edi,0x14(%ebp)
  8006a9:	e9 fe 02 00 00       	jmp    8009ac <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8006ae:	50                   	push   %eax
  8006af:	68 cb 2a 80 00       	push   $0x802acb
  8006b4:	53                   	push   %ebx
  8006b5:	56                   	push   %esi
  8006b6:	e8 8e fe ff ff       	call   800549 <printfmt>
  8006bb:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8006be:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8006c1:	e9 e6 02 00 00       	jmp    8009ac <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8006c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c9:	83 c0 04             	add    $0x4,%eax
  8006cc:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8006cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d2:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8006d4:	85 c9                	test   %ecx,%ecx
  8006d6:	b8 c4 2a 80 00       	mov    $0x802ac4,%eax
  8006db:	0f 45 c1             	cmovne %ecx,%eax
  8006de:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8006e1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006e5:	7e 06                	jle    8006ed <vprintfmt+0x187>
  8006e7:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8006eb:	75 0d                	jne    8006fa <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006ed:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8006f0:	89 c7                	mov    %eax,%edi
  8006f2:	03 45 e0             	add    -0x20(%ebp),%eax
  8006f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006f8:	eb 53                	jmp    80074d <vprintfmt+0x1e7>
  8006fa:	83 ec 08             	sub    $0x8,%esp
  8006fd:	ff 75 d8             	pushl  -0x28(%ebp)
  800700:	50                   	push   %eax
  800701:	e8 71 04 00 00       	call   800b77 <strnlen>
  800706:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800709:	29 c1                	sub    %eax,%ecx
  80070b:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80070e:	83 c4 10             	add    $0x10,%esp
  800711:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800713:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800717:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80071a:	eb 0f                	jmp    80072b <vprintfmt+0x1c5>
					putch(padc, putdat);
  80071c:	83 ec 08             	sub    $0x8,%esp
  80071f:	53                   	push   %ebx
  800720:	ff 75 e0             	pushl  -0x20(%ebp)
  800723:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800725:	83 ef 01             	sub    $0x1,%edi
  800728:	83 c4 10             	add    $0x10,%esp
  80072b:	85 ff                	test   %edi,%edi
  80072d:	7f ed                	jg     80071c <vprintfmt+0x1b6>
  80072f:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800732:	85 c9                	test   %ecx,%ecx
  800734:	b8 00 00 00 00       	mov    $0x0,%eax
  800739:	0f 49 c1             	cmovns %ecx,%eax
  80073c:	29 c1                	sub    %eax,%ecx
  80073e:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800741:	eb aa                	jmp    8006ed <vprintfmt+0x187>
					putch(ch, putdat);
  800743:	83 ec 08             	sub    $0x8,%esp
  800746:	53                   	push   %ebx
  800747:	52                   	push   %edx
  800748:	ff d6                	call   *%esi
  80074a:	83 c4 10             	add    $0x10,%esp
  80074d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800750:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800752:	83 c7 01             	add    $0x1,%edi
  800755:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800759:	0f be d0             	movsbl %al,%edx
  80075c:	85 d2                	test   %edx,%edx
  80075e:	74 4b                	je     8007ab <vprintfmt+0x245>
  800760:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800764:	78 06                	js     80076c <vprintfmt+0x206>
  800766:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80076a:	78 1e                	js     80078a <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  80076c:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800770:	74 d1                	je     800743 <vprintfmt+0x1dd>
  800772:	0f be c0             	movsbl %al,%eax
  800775:	83 e8 20             	sub    $0x20,%eax
  800778:	83 f8 5e             	cmp    $0x5e,%eax
  80077b:	76 c6                	jbe    800743 <vprintfmt+0x1dd>
					putch('?', putdat);
  80077d:	83 ec 08             	sub    $0x8,%esp
  800780:	53                   	push   %ebx
  800781:	6a 3f                	push   $0x3f
  800783:	ff d6                	call   *%esi
  800785:	83 c4 10             	add    $0x10,%esp
  800788:	eb c3                	jmp    80074d <vprintfmt+0x1e7>
  80078a:	89 cf                	mov    %ecx,%edi
  80078c:	eb 0e                	jmp    80079c <vprintfmt+0x236>
				putch(' ', putdat);
  80078e:	83 ec 08             	sub    $0x8,%esp
  800791:	53                   	push   %ebx
  800792:	6a 20                	push   $0x20
  800794:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800796:	83 ef 01             	sub    $0x1,%edi
  800799:	83 c4 10             	add    $0x10,%esp
  80079c:	85 ff                	test   %edi,%edi
  80079e:	7f ee                	jg     80078e <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8007a0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8007a3:	89 45 14             	mov    %eax,0x14(%ebp)
  8007a6:	e9 01 02 00 00       	jmp    8009ac <vprintfmt+0x446>
  8007ab:	89 cf                	mov    %ecx,%edi
  8007ad:	eb ed                	jmp    80079c <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8007af:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8007b2:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8007b9:	e9 eb fd ff ff       	jmp    8005a9 <vprintfmt+0x43>
	if (lflag >= 2)
  8007be:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007c2:	7f 21                	jg     8007e5 <vprintfmt+0x27f>
	else if (lflag)
  8007c4:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007c8:	74 68                	je     800832 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8007ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cd:	8b 00                	mov    (%eax),%eax
  8007cf:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8007d2:	89 c1                	mov    %eax,%ecx
  8007d4:	c1 f9 1f             	sar    $0x1f,%ecx
  8007d7:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8007da:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dd:	8d 40 04             	lea    0x4(%eax),%eax
  8007e0:	89 45 14             	mov    %eax,0x14(%ebp)
  8007e3:	eb 17                	jmp    8007fc <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8007e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e8:	8b 50 04             	mov    0x4(%eax),%edx
  8007eb:	8b 00                	mov    (%eax),%eax
  8007ed:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8007f0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8007f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f6:	8d 40 08             	lea    0x8(%eax),%eax
  8007f9:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8007fc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007ff:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800802:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800805:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800808:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80080c:	78 3f                	js     80084d <vprintfmt+0x2e7>
			base = 10;
  80080e:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800813:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800817:	0f 84 71 01 00 00    	je     80098e <vprintfmt+0x428>
				putch('+', putdat);
  80081d:	83 ec 08             	sub    $0x8,%esp
  800820:	53                   	push   %ebx
  800821:	6a 2b                	push   $0x2b
  800823:	ff d6                	call   *%esi
  800825:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800828:	b8 0a 00 00 00       	mov    $0xa,%eax
  80082d:	e9 5c 01 00 00       	jmp    80098e <vprintfmt+0x428>
		return va_arg(*ap, int);
  800832:	8b 45 14             	mov    0x14(%ebp),%eax
  800835:	8b 00                	mov    (%eax),%eax
  800837:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80083a:	89 c1                	mov    %eax,%ecx
  80083c:	c1 f9 1f             	sar    $0x1f,%ecx
  80083f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800842:	8b 45 14             	mov    0x14(%ebp),%eax
  800845:	8d 40 04             	lea    0x4(%eax),%eax
  800848:	89 45 14             	mov    %eax,0x14(%ebp)
  80084b:	eb af                	jmp    8007fc <vprintfmt+0x296>
				putch('-', putdat);
  80084d:	83 ec 08             	sub    $0x8,%esp
  800850:	53                   	push   %ebx
  800851:	6a 2d                	push   $0x2d
  800853:	ff d6                	call   *%esi
				num = -(long long) num;
  800855:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800858:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80085b:	f7 d8                	neg    %eax
  80085d:	83 d2 00             	adc    $0x0,%edx
  800860:	f7 da                	neg    %edx
  800862:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800865:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800868:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80086b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800870:	e9 19 01 00 00       	jmp    80098e <vprintfmt+0x428>
	if (lflag >= 2)
  800875:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800879:	7f 29                	jg     8008a4 <vprintfmt+0x33e>
	else if (lflag)
  80087b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80087f:	74 44                	je     8008c5 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800881:	8b 45 14             	mov    0x14(%ebp),%eax
  800884:	8b 00                	mov    (%eax),%eax
  800886:	ba 00 00 00 00       	mov    $0x0,%edx
  80088b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80088e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800891:	8b 45 14             	mov    0x14(%ebp),%eax
  800894:	8d 40 04             	lea    0x4(%eax),%eax
  800897:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80089a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80089f:	e9 ea 00 00 00       	jmp    80098e <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8008a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a7:	8b 50 04             	mov    0x4(%eax),%edx
  8008aa:	8b 00                	mov    (%eax),%eax
  8008ac:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008af:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b5:	8d 40 08             	lea    0x8(%eax),%eax
  8008b8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008bb:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008c0:	e9 c9 00 00 00       	jmp    80098e <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8008c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c8:	8b 00                	mov    (%eax),%eax
  8008ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8008cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008d2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d8:	8d 40 04             	lea    0x4(%eax),%eax
  8008db:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008de:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008e3:	e9 a6 00 00 00       	jmp    80098e <vprintfmt+0x428>
			putch('0', putdat);
  8008e8:	83 ec 08             	sub    $0x8,%esp
  8008eb:	53                   	push   %ebx
  8008ec:	6a 30                	push   $0x30
  8008ee:	ff d6                	call   *%esi
	if (lflag >= 2)
  8008f0:	83 c4 10             	add    $0x10,%esp
  8008f3:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8008f7:	7f 26                	jg     80091f <vprintfmt+0x3b9>
	else if (lflag)
  8008f9:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8008fd:	74 3e                	je     80093d <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8008ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800902:	8b 00                	mov    (%eax),%eax
  800904:	ba 00 00 00 00       	mov    $0x0,%edx
  800909:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80090c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80090f:	8b 45 14             	mov    0x14(%ebp),%eax
  800912:	8d 40 04             	lea    0x4(%eax),%eax
  800915:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800918:	b8 08 00 00 00       	mov    $0x8,%eax
  80091d:	eb 6f                	jmp    80098e <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80091f:	8b 45 14             	mov    0x14(%ebp),%eax
  800922:	8b 50 04             	mov    0x4(%eax),%edx
  800925:	8b 00                	mov    (%eax),%eax
  800927:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80092a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80092d:	8b 45 14             	mov    0x14(%ebp),%eax
  800930:	8d 40 08             	lea    0x8(%eax),%eax
  800933:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800936:	b8 08 00 00 00       	mov    $0x8,%eax
  80093b:	eb 51                	jmp    80098e <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80093d:	8b 45 14             	mov    0x14(%ebp),%eax
  800940:	8b 00                	mov    (%eax),%eax
  800942:	ba 00 00 00 00       	mov    $0x0,%edx
  800947:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80094a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80094d:	8b 45 14             	mov    0x14(%ebp),%eax
  800950:	8d 40 04             	lea    0x4(%eax),%eax
  800953:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800956:	b8 08 00 00 00       	mov    $0x8,%eax
  80095b:	eb 31                	jmp    80098e <vprintfmt+0x428>
			putch('0', putdat);
  80095d:	83 ec 08             	sub    $0x8,%esp
  800960:	53                   	push   %ebx
  800961:	6a 30                	push   $0x30
  800963:	ff d6                	call   *%esi
			putch('x', putdat);
  800965:	83 c4 08             	add    $0x8,%esp
  800968:	53                   	push   %ebx
  800969:	6a 78                	push   $0x78
  80096b:	ff d6                	call   *%esi
			num = (unsigned long long)
  80096d:	8b 45 14             	mov    0x14(%ebp),%eax
  800970:	8b 00                	mov    (%eax),%eax
  800972:	ba 00 00 00 00       	mov    $0x0,%edx
  800977:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80097a:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80097d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800980:	8b 45 14             	mov    0x14(%ebp),%eax
  800983:	8d 40 04             	lea    0x4(%eax),%eax
  800986:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800989:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80098e:	83 ec 0c             	sub    $0xc,%esp
  800991:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800995:	52                   	push   %edx
  800996:	ff 75 e0             	pushl  -0x20(%ebp)
  800999:	50                   	push   %eax
  80099a:	ff 75 dc             	pushl  -0x24(%ebp)
  80099d:	ff 75 d8             	pushl  -0x28(%ebp)
  8009a0:	89 da                	mov    %ebx,%edx
  8009a2:	89 f0                	mov    %esi,%eax
  8009a4:	e8 a4 fa ff ff       	call   80044d <printnum>
			break;
  8009a9:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8009ac:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009af:	83 c7 01             	add    $0x1,%edi
  8009b2:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8009b6:	83 f8 25             	cmp    $0x25,%eax
  8009b9:	0f 84 be fb ff ff    	je     80057d <vprintfmt+0x17>
			if (ch == '\0')
  8009bf:	85 c0                	test   %eax,%eax
  8009c1:	0f 84 28 01 00 00    	je     800aef <vprintfmt+0x589>
			putch(ch, putdat);
  8009c7:	83 ec 08             	sub    $0x8,%esp
  8009ca:	53                   	push   %ebx
  8009cb:	50                   	push   %eax
  8009cc:	ff d6                	call   *%esi
  8009ce:	83 c4 10             	add    $0x10,%esp
  8009d1:	eb dc                	jmp    8009af <vprintfmt+0x449>
	if (lflag >= 2)
  8009d3:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8009d7:	7f 26                	jg     8009ff <vprintfmt+0x499>
	else if (lflag)
  8009d9:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8009dd:	74 41                	je     800a20 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8009df:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e2:	8b 00                	mov    (%eax),%eax
  8009e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8009e9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009ec:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f2:	8d 40 04             	lea    0x4(%eax),%eax
  8009f5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009f8:	b8 10 00 00 00       	mov    $0x10,%eax
  8009fd:	eb 8f                	jmp    80098e <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8009ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800a02:	8b 50 04             	mov    0x4(%eax),%edx
  800a05:	8b 00                	mov    (%eax),%eax
  800a07:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a0a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a0d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a10:	8d 40 08             	lea    0x8(%eax),%eax
  800a13:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a16:	b8 10 00 00 00       	mov    $0x10,%eax
  800a1b:	e9 6e ff ff ff       	jmp    80098e <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800a20:	8b 45 14             	mov    0x14(%ebp),%eax
  800a23:	8b 00                	mov    (%eax),%eax
  800a25:	ba 00 00 00 00       	mov    $0x0,%edx
  800a2a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a2d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a30:	8b 45 14             	mov    0x14(%ebp),%eax
  800a33:	8d 40 04             	lea    0x4(%eax),%eax
  800a36:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a39:	b8 10 00 00 00       	mov    $0x10,%eax
  800a3e:	e9 4b ff ff ff       	jmp    80098e <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800a43:	8b 45 14             	mov    0x14(%ebp),%eax
  800a46:	83 c0 04             	add    $0x4,%eax
  800a49:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a4c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4f:	8b 00                	mov    (%eax),%eax
  800a51:	85 c0                	test   %eax,%eax
  800a53:	74 14                	je     800a69 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800a55:	8b 13                	mov    (%ebx),%edx
  800a57:	83 fa 7f             	cmp    $0x7f,%edx
  800a5a:	7f 37                	jg     800a93 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800a5c:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800a5e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a61:	89 45 14             	mov    %eax,0x14(%ebp)
  800a64:	e9 43 ff ff ff       	jmp    8009ac <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800a69:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a6e:	bf e9 2b 80 00       	mov    $0x802be9,%edi
							putch(ch, putdat);
  800a73:	83 ec 08             	sub    $0x8,%esp
  800a76:	53                   	push   %ebx
  800a77:	50                   	push   %eax
  800a78:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800a7a:	83 c7 01             	add    $0x1,%edi
  800a7d:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800a81:	83 c4 10             	add    $0x10,%esp
  800a84:	85 c0                	test   %eax,%eax
  800a86:	75 eb                	jne    800a73 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800a88:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a8b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a8e:	e9 19 ff ff ff       	jmp    8009ac <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800a93:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800a95:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a9a:	bf 21 2c 80 00       	mov    $0x802c21,%edi
							putch(ch, putdat);
  800a9f:	83 ec 08             	sub    $0x8,%esp
  800aa2:	53                   	push   %ebx
  800aa3:	50                   	push   %eax
  800aa4:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800aa6:	83 c7 01             	add    $0x1,%edi
  800aa9:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800aad:	83 c4 10             	add    $0x10,%esp
  800ab0:	85 c0                	test   %eax,%eax
  800ab2:	75 eb                	jne    800a9f <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800ab4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800ab7:	89 45 14             	mov    %eax,0x14(%ebp)
  800aba:	e9 ed fe ff ff       	jmp    8009ac <vprintfmt+0x446>
			putch(ch, putdat);
  800abf:	83 ec 08             	sub    $0x8,%esp
  800ac2:	53                   	push   %ebx
  800ac3:	6a 25                	push   $0x25
  800ac5:	ff d6                	call   *%esi
			break;
  800ac7:	83 c4 10             	add    $0x10,%esp
  800aca:	e9 dd fe ff ff       	jmp    8009ac <vprintfmt+0x446>
			putch('%', putdat);
  800acf:	83 ec 08             	sub    $0x8,%esp
  800ad2:	53                   	push   %ebx
  800ad3:	6a 25                	push   $0x25
  800ad5:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ad7:	83 c4 10             	add    $0x10,%esp
  800ada:	89 f8                	mov    %edi,%eax
  800adc:	eb 03                	jmp    800ae1 <vprintfmt+0x57b>
  800ade:	83 e8 01             	sub    $0x1,%eax
  800ae1:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800ae5:	75 f7                	jne    800ade <vprintfmt+0x578>
  800ae7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800aea:	e9 bd fe ff ff       	jmp    8009ac <vprintfmt+0x446>
}
  800aef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800af2:	5b                   	pop    %ebx
  800af3:	5e                   	pop    %esi
  800af4:	5f                   	pop    %edi
  800af5:	5d                   	pop    %ebp
  800af6:	c3                   	ret    

00800af7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800af7:	55                   	push   %ebp
  800af8:	89 e5                	mov    %esp,%ebp
  800afa:	83 ec 18             	sub    $0x18,%esp
  800afd:	8b 45 08             	mov    0x8(%ebp),%eax
  800b00:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b03:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b06:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b0a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b0d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b14:	85 c0                	test   %eax,%eax
  800b16:	74 26                	je     800b3e <vsnprintf+0x47>
  800b18:	85 d2                	test   %edx,%edx
  800b1a:	7e 22                	jle    800b3e <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b1c:	ff 75 14             	pushl  0x14(%ebp)
  800b1f:	ff 75 10             	pushl  0x10(%ebp)
  800b22:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b25:	50                   	push   %eax
  800b26:	68 2c 05 80 00       	push   $0x80052c
  800b2b:	e8 36 fa ff ff       	call   800566 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b33:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b39:	83 c4 10             	add    $0x10,%esp
}
  800b3c:	c9                   	leave  
  800b3d:	c3                   	ret    
		return -E_INVAL;
  800b3e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b43:	eb f7                	jmp    800b3c <vsnprintf+0x45>

00800b45 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b45:	55                   	push   %ebp
  800b46:	89 e5                	mov    %esp,%ebp
  800b48:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b4b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800b4e:	50                   	push   %eax
  800b4f:	ff 75 10             	pushl  0x10(%ebp)
  800b52:	ff 75 0c             	pushl  0xc(%ebp)
  800b55:	ff 75 08             	pushl  0x8(%ebp)
  800b58:	e8 9a ff ff ff       	call   800af7 <vsnprintf>
	va_end(ap);

	return rc;
}
  800b5d:	c9                   	leave  
  800b5e:	c3                   	ret    

00800b5f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b5f:	55                   	push   %ebp
  800b60:	89 e5                	mov    %esp,%ebp
  800b62:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b65:	b8 00 00 00 00       	mov    $0x0,%eax
  800b6a:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b6e:	74 05                	je     800b75 <strlen+0x16>
		n++;
  800b70:	83 c0 01             	add    $0x1,%eax
  800b73:	eb f5                	jmp    800b6a <strlen+0xb>
	return n;
}
  800b75:	5d                   	pop    %ebp
  800b76:	c3                   	ret    

00800b77 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b77:	55                   	push   %ebp
  800b78:	89 e5                	mov    %esp,%ebp
  800b7a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b7d:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b80:	ba 00 00 00 00       	mov    $0x0,%edx
  800b85:	39 c2                	cmp    %eax,%edx
  800b87:	74 0d                	je     800b96 <strnlen+0x1f>
  800b89:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800b8d:	74 05                	je     800b94 <strnlen+0x1d>
		n++;
  800b8f:	83 c2 01             	add    $0x1,%edx
  800b92:	eb f1                	jmp    800b85 <strnlen+0xe>
  800b94:	89 d0                	mov    %edx,%eax
	return n;
}
  800b96:	5d                   	pop    %ebp
  800b97:	c3                   	ret    

00800b98 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b98:	55                   	push   %ebp
  800b99:	89 e5                	mov    %esp,%ebp
  800b9b:	53                   	push   %ebx
  800b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800ba2:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba7:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800bab:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800bae:	83 c2 01             	add    $0x1,%edx
  800bb1:	84 c9                	test   %cl,%cl
  800bb3:	75 f2                	jne    800ba7 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800bb5:	5b                   	pop    %ebx
  800bb6:	5d                   	pop    %ebp
  800bb7:	c3                   	ret    

00800bb8 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800bb8:	55                   	push   %ebp
  800bb9:	89 e5                	mov    %esp,%ebp
  800bbb:	53                   	push   %ebx
  800bbc:	83 ec 10             	sub    $0x10,%esp
  800bbf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800bc2:	53                   	push   %ebx
  800bc3:	e8 97 ff ff ff       	call   800b5f <strlen>
  800bc8:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800bcb:	ff 75 0c             	pushl  0xc(%ebp)
  800bce:	01 d8                	add    %ebx,%eax
  800bd0:	50                   	push   %eax
  800bd1:	e8 c2 ff ff ff       	call   800b98 <strcpy>
	return dst;
}
  800bd6:	89 d8                	mov    %ebx,%eax
  800bd8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bdb:	c9                   	leave  
  800bdc:	c3                   	ret    

00800bdd <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800bdd:	55                   	push   %ebp
  800bde:	89 e5                	mov    %esp,%ebp
  800be0:	56                   	push   %esi
  800be1:	53                   	push   %ebx
  800be2:	8b 45 08             	mov    0x8(%ebp),%eax
  800be5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800be8:	89 c6                	mov    %eax,%esi
  800bea:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bed:	89 c2                	mov    %eax,%edx
  800bef:	39 f2                	cmp    %esi,%edx
  800bf1:	74 11                	je     800c04 <strncpy+0x27>
		*dst++ = *src;
  800bf3:	83 c2 01             	add    $0x1,%edx
  800bf6:	0f b6 19             	movzbl (%ecx),%ebx
  800bf9:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800bfc:	80 fb 01             	cmp    $0x1,%bl
  800bff:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800c02:	eb eb                	jmp    800bef <strncpy+0x12>
	}
	return ret;
}
  800c04:	5b                   	pop    %ebx
  800c05:	5e                   	pop    %esi
  800c06:	5d                   	pop    %ebp
  800c07:	c3                   	ret    

00800c08 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c08:	55                   	push   %ebp
  800c09:	89 e5                	mov    %esp,%ebp
  800c0b:	56                   	push   %esi
  800c0c:	53                   	push   %ebx
  800c0d:	8b 75 08             	mov    0x8(%ebp),%esi
  800c10:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c13:	8b 55 10             	mov    0x10(%ebp),%edx
  800c16:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c18:	85 d2                	test   %edx,%edx
  800c1a:	74 21                	je     800c3d <strlcpy+0x35>
  800c1c:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800c20:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800c22:	39 c2                	cmp    %eax,%edx
  800c24:	74 14                	je     800c3a <strlcpy+0x32>
  800c26:	0f b6 19             	movzbl (%ecx),%ebx
  800c29:	84 db                	test   %bl,%bl
  800c2b:	74 0b                	je     800c38 <strlcpy+0x30>
			*dst++ = *src++;
  800c2d:	83 c1 01             	add    $0x1,%ecx
  800c30:	83 c2 01             	add    $0x1,%edx
  800c33:	88 5a ff             	mov    %bl,-0x1(%edx)
  800c36:	eb ea                	jmp    800c22 <strlcpy+0x1a>
  800c38:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800c3a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c3d:	29 f0                	sub    %esi,%eax
}
  800c3f:	5b                   	pop    %ebx
  800c40:	5e                   	pop    %esi
  800c41:	5d                   	pop    %ebp
  800c42:	c3                   	ret    

00800c43 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c43:	55                   	push   %ebp
  800c44:	89 e5                	mov    %esp,%ebp
  800c46:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c49:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c4c:	0f b6 01             	movzbl (%ecx),%eax
  800c4f:	84 c0                	test   %al,%al
  800c51:	74 0c                	je     800c5f <strcmp+0x1c>
  800c53:	3a 02                	cmp    (%edx),%al
  800c55:	75 08                	jne    800c5f <strcmp+0x1c>
		p++, q++;
  800c57:	83 c1 01             	add    $0x1,%ecx
  800c5a:	83 c2 01             	add    $0x1,%edx
  800c5d:	eb ed                	jmp    800c4c <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c5f:	0f b6 c0             	movzbl %al,%eax
  800c62:	0f b6 12             	movzbl (%edx),%edx
  800c65:	29 d0                	sub    %edx,%eax
}
  800c67:	5d                   	pop    %ebp
  800c68:	c3                   	ret    

00800c69 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c69:	55                   	push   %ebp
  800c6a:	89 e5                	mov    %esp,%ebp
  800c6c:	53                   	push   %ebx
  800c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c70:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c73:	89 c3                	mov    %eax,%ebx
  800c75:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800c78:	eb 06                	jmp    800c80 <strncmp+0x17>
		n--, p++, q++;
  800c7a:	83 c0 01             	add    $0x1,%eax
  800c7d:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800c80:	39 d8                	cmp    %ebx,%eax
  800c82:	74 16                	je     800c9a <strncmp+0x31>
  800c84:	0f b6 08             	movzbl (%eax),%ecx
  800c87:	84 c9                	test   %cl,%cl
  800c89:	74 04                	je     800c8f <strncmp+0x26>
  800c8b:	3a 0a                	cmp    (%edx),%cl
  800c8d:	74 eb                	je     800c7a <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c8f:	0f b6 00             	movzbl (%eax),%eax
  800c92:	0f b6 12             	movzbl (%edx),%edx
  800c95:	29 d0                	sub    %edx,%eax
}
  800c97:	5b                   	pop    %ebx
  800c98:	5d                   	pop    %ebp
  800c99:	c3                   	ret    
		return 0;
  800c9a:	b8 00 00 00 00       	mov    $0x0,%eax
  800c9f:	eb f6                	jmp    800c97 <strncmp+0x2e>

00800ca1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ca1:	55                   	push   %ebp
  800ca2:	89 e5                	mov    %esp,%ebp
  800ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca7:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cab:	0f b6 10             	movzbl (%eax),%edx
  800cae:	84 d2                	test   %dl,%dl
  800cb0:	74 09                	je     800cbb <strchr+0x1a>
		if (*s == c)
  800cb2:	38 ca                	cmp    %cl,%dl
  800cb4:	74 0a                	je     800cc0 <strchr+0x1f>
	for (; *s; s++)
  800cb6:	83 c0 01             	add    $0x1,%eax
  800cb9:	eb f0                	jmp    800cab <strchr+0xa>
			return (char *) s;
	return 0;
  800cbb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cc0:	5d                   	pop    %ebp
  800cc1:	c3                   	ret    

00800cc2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cc2:	55                   	push   %ebp
  800cc3:	89 e5                	mov    %esp,%ebp
  800cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc8:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ccc:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800ccf:	38 ca                	cmp    %cl,%dl
  800cd1:	74 09                	je     800cdc <strfind+0x1a>
  800cd3:	84 d2                	test   %dl,%dl
  800cd5:	74 05                	je     800cdc <strfind+0x1a>
	for (; *s; s++)
  800cd7:	83 c0 01             	add    $0x1,%eax
  800cda:	eb f0                	jmp    800ccc <strfind+0xa>
			break;
	return (char *) s;
}
  800cdc:	5d                   	pop    %ebp
  800cdd:	c3                   	ret    

00800cde <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800cde:	55                   	push   %ebp
  800cdf:	89 e5                	mov    %esp,%ebp
  800ce1:	57                   	push   %edi
  800ce2:	56                   	push   %esi
  800ce3:	53                   	push   %ebx
  800ce4:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ce7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800cea:	85 c9                	test   %ecx,%ecx
  800cec:	74 31                	je     800d1f <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800cee:	89 f8                	mov    %edi,%eax
  800cf0:	09 c8                	or     %ecx,%eax
  800cf2:	a8 03                	test   $0x3,%al
  800cf4:	75 23                	jne    800d19 <memset+0x3b>
		c &= 0xFF;
  800cf6:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800cfa:	89 d3                	mov    %edx,%ebx
  800cfc:	c1 e3 08             	shl    $0x8,%ebx
  800cff:	89 d0                	mov    %edx,%eax
  800d01:	c1 e0 18             	shl    $0x18,%eax
  800d04:	89 d6                	mov    %edx,%esi
  800d06:	c1 e6 10             	shl    $0x10,%esi
  800d09:	09 f0                	or     %esi,%eax
  800d0b:	09 c2                	or     %eax,%edx
  800d0d:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d0f:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800d12:	89 d0                	mov    %edx,%eax
  800d14:	fc                   	cld    
  800d15:	f3 ab                	rep stos %eax,%es:(%edi)
  800d17:	eb 06                	jmp    800d1f <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1c:	fc                   	cld    
  800d1d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d1f:	89 f8                	mov    %edi,%eax
  800d21:	5b                   	pop    %ebx
  800d22:	5e                   	pop    %esi
  800d23:	5f                   	pop    %edi
  800d24:	5d                   	pop    %ebp
  800d25:	c3                   	ret    

00800d26 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d26:	55                   	push   %ebp
  800d27:	89 e5                	mov    %esp,%ebp
  800d29:	57                   	push   %edi
  800d2a:	56                   	push   %esi
  800d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d31:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d34:	39 c6                	cmp    %eax,%esi
  800d36:	73 32                	jae    800d6a <memmove+0x44>
  800d38:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d3b:	39 c2                	cmp    %eax,%edx
  800d3d:	76 2b                	jbe    800d6a <memmove+0x44>
		s += n;
		d += n;
  800d3f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d42:	89 fe                	mov    %edi,%esi
  800d44:	09 ce                	or     %ecx,%esi
  800d46:	09 d6                	or     %edx,%esi
  800d48:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d4e:	75 0e                	jne    800d5e <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d50:	83 ef 04             	sub    $0x4,%edi
  800d53:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d56:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800d59:	fd                   	std    
  800d5a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d5c:	eb 09                	jmp    800d67 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d5e:	83 ef 01             	sub    $0x1,%edi
  800d61:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800d64:	fd                   	std    
  800d65:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d67:	fc                   	cld    
  800d68:	eb 1a                	jmp    800d84 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d6a:	89 c2                	mov    %eax,%edx
  800d6c:	09 ca                	or     %ecx,%edx
  800d6e:	09 f2                	or     %esi,%edx
  800d70:	f6 c2 03             	test   $0x3,%dl
  800d73:	75 0a                	jne    800d7f <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d75:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800d78:	89 c7                	mov    %eax,%edi
  800d7a:	fc                   	cld    
  800d7b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d7d:	eb 05                	jmp    800d84 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800d7f:	89 c7                	mov    %eax,%edi
  800d81:	fc                   	cld    
  800d82:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d84:	5e                   	pop    %esi
  800d85:	5f                   	pop    %edi
  800d86:	5d                   	pop    %ebp
  800d87:	c3                   	ret    

00800d88 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d88:	55                   	push   %ebp
  800d89:	89 e5                	mov    %esp,%ebp
  800d8b:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d8e:	ff 75 10             	pushl  0x10(%ebp)
  800d91:	ff 75 0c             	pushl  0xc(%ebp)
  800d94:	ff 75 08             	pushl  0x8(%ebp)
  800d97:	e8 8a ff ff ff       	call   800d26 <memmove>
}
  800d9c:	c9                   	leave  
  800d9d:	c3                   	ret    

00800d9e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d9e:	55                   	push   %ebp
  800d9f:	89 e5                	mov    %esp,%ebp
  800da1:	56                   	push   %esi
  800da2:	53                   	push   %ebx
  800da3:	8b 45 08             	mov    0x8(%ebp),%eax
  800da6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da9:	89 c6                	mov    %eax,%esi
  800dab:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800dae:	39 f0                	cmp    %esi,%eax
  800db0:	74 1c                	je     800dce <memcmp+0x30>
		if (*s1 != *s2)
  800db2:	0f b6 08             	movzbl (%eax),%ecx
  800db5:	0f b6 1a             	movzbl (%edx),%ebx
  800db8:	38 d9                	cmp    %bl,%cl
  800dba:	75 08                	jne    800dc4 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800dbc:	83 c0 01             	add    $0x1,%eax
  800dbf:	83 c2 01             	add    $0x1,%edx
  800dc2:	eb ea                	jmp    800dae <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800dc4:	0f b6 c1             	movzbl %cl,%eax
  800dc7:	0f b6 db             	movzbl %bl,%ebx
  800dca:	29 d8                	sub    %ebx,%eax
  800dcc:	eb 05                	jmp    800dd3 <memcmp+0x35>
	}

	return 0;
  800dce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dd3:	5b                   	pop    %ebx
  800dd4:	5e                   	pop    %esi
  800dd5:	5d                   	pop    %ebp
  800dd6:	c3                   	ret    

00800dd7 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800dd7:	55                   	push   %ebp
  800dd8:	89 e5                	mov    %esp,%ebp
  800dda:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800de0:	89 c2                	mov    %eax,%edx
  800de2:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800de5:	39 d0                	cmp    %edx,%eax
  800de7:	73 09                	jae    800df2 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800de9:	38 08                	cmp    %cl,(%eax)
  800deb:	74 05                	je     800df2 <memfind+0x1b>
	for (; s < ends; s++)
  800ded:	83 c0 01             	add    $0x1,%eax
  800df0:	eb f3                	jmp    800de5 <memfind+0xe>
			break;
	return (void *) s;
}
  800df2:	5d                   	pop    %ebp
  800df3:	c3                   	ret    

00800df4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800df4:	55                   	push   %ebp
  800df5:	89 e5                	mov    %esp,%ebp
  800df7:	57                   	push   %edi
  800df8:	56                   	push   %esi
  800df9:	53                   	push   %ebx
  800dfa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dfd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e00:	eb 03                	jmp    800e05 <strtol+0x11>
		s++;
  800e02:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800e05:	0f b6 01             	movzbl (%ecx),%eax
  800e08:	3c 20                	cmp    $0x20,%al
  800e0a:	74 f6                	je     800e02 <strtol+0xe>
  800e0c:	3c 09                	cmp    $0x9,%al
  800e0e:	74 f2                	je     800e02 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800e10:	3c 2b                	cmp    $0x2b,%al
  800e12:	74 2a                	je     800e3e <strtol+0x4a>
	int neg = 0;
  800e14:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800e19:	3c 2d                	cmp    $0x2d,%al
  800e1b:	74 2b                	je     800e48 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e1d:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800e23:	75 0f                	jne    800e34 <strtol+0x40>
  800e25:	80 39 30             	cmpb   $0x30,(%ecx)
  800e28:	74 28                	je     800e52 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e2a:	85 db                	test   %ebx,%ebx
  800e2c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e31:	0f 44 d8             	cmove  %eax,%ebx
  800e34:	b8 00 00 00 00       	mov    $0x0,%eax
  800e39:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800e3c:	eb 50                	jmp    800e8e <strtol+0x9a>
		s++;
  800e3e:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800e41:	bf 00 00 00 00       	mov    $0x0,%edi
  800e46:	eb d5                	jmp    800e1d <strtol+0x29>
		s++, neg = 1;
  800e48:	83 c1 01             	add    $0x1,%ecx
  800e4b:	bf 01 00 00 00       	mov    $0x1,%edi
  800e50:	eb cb                	jmp    800e1d <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e52:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800e56:	74 0e                	je     800e66 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800e58:	85 db                	test   %ebx,%ebx
  800e5a:	75 d8                	jne    800e34 <strtol+0x40>
		s++, base = 8;
  800e5c:	83 c1 01             	add    $0x1,%ecx
  800e5f:	bb 08 00 00 00       	mov    $0x8,%ebx
  800e64:	eb ce                	jmp    800e34 <strtol+0x40>
		s += 2, base = 16;
  800e66:	83 c1 02             	add    $0x2,%ecx
  800e69:	bb 10 00 00 00       	mov    $0x10,%ebx
  800e6e:	eb c4                	jmp    800e34 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800e70:	8d 72 9f             	lea    -0x61(%edx),%esi
  800e73:	89 f3                	mov    %esi,%ebx
  800e75:	80 fb 19             	cmp    $0x19,%bl
  800e78:	77 29                	ja     800ea3 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800e7a:	0f be d2             	movsbl %dl,%edx
  800e7d:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800e80:	3b 55 10             	cmp    0x10(%ebp),%edx
  800e83:	7d 30                	jge    800eb5 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800e85:	83 c1 01             	add    $0x1,%ecx
  800e88:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e8c:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800e8e:	0f b6 11             	movzbl (%ecx),%edx
  800e91:	8d 72 d0             	lea    -0x30(%edx),%esi
  800e94:	89 f3                	mov    %esi,%ebx
  800e96:	80 fb 09             	cmp    $0x9,%bl
  800e99:	77 d5                	ja     800e70 <strtol+0x7c>
			dig = *s - '0';
  800e9b:	0f be d2             	movsbl %dl,%edx
  800e9e:	83 ea 30             	sub    $0x30,%edx
  800ea1:	eb dd                	jmp    800e80 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800ea3:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ea6:	89 f3                	mov    %esi,%ebx
  800ea8:	80 fb 19             	cmp    $0x19,%bl
  800eab:	77 08                	ja     800eb5 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800ead:	0f be d2             	movsbl %dl,%edx
  800eb0:	83 ea 37             	sub    $0x37,%edx
  800eb3:	eb cb                	jmp    800e80 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800eb5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800eb9:	74 05                	je     800ec0 <strtol+0xcc>
		*endptr = (char *) s;
  800ebb:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ebe:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ec0:	89 c2                	mov    %eax,%edx
  800ec2:	f7 da                	neg    %edx
  800ec4:	85 ff                	test   %edi,%edi
  800ec6:	0f 45 c2             	cmovne %edx,%eax
}
  800ec9:	5b                   	pop    %ebx
  800eca:	5e                   	pop    %esi
  800ecb:	5f                   	pop    %edi
  800ecc:	5d                   	pop    %ebp
  800ecd:	c3                   	ret    

00800ece <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ece:	55                   	push   %ebp
  800ecf:	89 e5                	mov    %esp,%ebp
  800ed1:	57                   	push   %edi
  800ed2:	56                   	push   %esi
  800ed3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ed4:	b8 00 00 00 00       	mov    $0x0,%eax
  800ed9:	8b 55 08             	mov    0x8(%ebp),%edx
  800edc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800edf:	89 c3                	mov    %eax,%ebx
  800ee1:	89 c7                	mov    %eax,%edi
  800ee3:	89 c6                	mov    %eax,%esi
  800ee5:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ee7:	5b                   	pop    %ebx
  800ee8:	5e                   	pop    %esi
  800ee9:	5f                   	pop    %edi
  800eea:	5d                   	pop    %ebp
  800eeb:	c3                   	ret    

00800eec <sys_cgetc>:

int
sys_cgetc(void)
{
  800eec:	55                   	push   %ebp
  800eed:	89 e5                	mov    %esp,%ebp
  800eef:	57                   	push   %edi
  800ef0:	56                   	push   %esi
  800ef1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ef2:	ba 00 00 00 00       	mov    $0x0,%edx
  800ef7:	b8 01 00 00 00       	mov    $0x1,%eax
  800efc:	89 d1                	mov    %edx,%ecx
  800efe:	89 d3                	mov    %edx,%ebx
  800f00:	89 d7                	mov    %edx,%edi
  800f02:	89 d6                	mov    %edx,%esi
  800f04:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800f06:	5b                   	pop    %ebx
  800f07:	5e                   	pop    %esi
  800f08:	5f                   	pop    %edi
  800f09:	5d                   	pop    %ebp
  800f0a:	c3                   	ret    

00800f0b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800f0b:	55                   	push   %ebp
  800f0c:	89 e5                	mov    %esp,%ebp
  800f0e:	57                   	push   %edi
  800f0f:	56                   	push   %esi
  800f10:	53                   	push   %ebx
  800f11:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f14:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f19:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1c:	b8 03 00 00 00       	mov    $0x3,%eax
  800f21:	89 cb                	mov    %ecx,%ebx
  800f23:	89 cf                	mov    %ecx,%edi
  800f25:	89 ce                	mov    %ecx,%esi
  800f27:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f29:	85 c0                	test   %eax,%eax
  800f2b:	7f 08                	jg     800f35 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800f2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f30:	5b                   	pop    %ebx
  800f31:	5e                   	pop    %esi
  800f32:	5f                   	pop    %edi
  800f33:	5d                   	pop    %ebp
  800f34:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f35:	83 ec 0c             	sub    $0xc,%esp
  800f38:	50                   	push   %eax
  800f39:	6a 03                	push   $0x3
  800f3b:	68 48 2e 80 00       	push   $0x802e48
  800f40:	6a 43                	push   $0x43
  800f42:	68 65 2e 80 00       	push   $0x802e65
  800f47:	e8 f7 f3 ff ff       	call   800343 <_panic>

00800f4c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800f4c:	55                   	push   %ebp
  800f4d:	89 e5                	mov    %esp,%ebp
  800f4f:	57                   	push   %edi
  800f50:	56                   	push   %esi
  800f51:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f52:	ba 00 00 00 00       	mov    $0x0,%edx
  800f57:	b8 02 00 00 00       	mov    $0x2,%eax
  800f5c:	89 d1                	mov    %edx,%ecx
  800f5e:	89 d3                	mov    %edx,%ebx
  800f60:	89 d7                	mov    %edx,%edi
  800f62:	89 d6                	mov    %edx,%esi
  800f64:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800f66:	5b                   	pop    %ebx
  800f67:	5e                   	pop    %esi
  800f68:	5f                   	pop    %edi
  800f69:	5d                   	pop    %ebp
  800f6a:	c3                   	ret    

00800f6b <sys_yield>:

void
sys_yield(void)
{
  800f6b:	55                   	push   %ebp
  800f6c:	89 e5                	mov    %esp,%ebp
  800f6e:	57                   	push   %edi
  800f6f:	56                   	push   %esi
  800f70:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f71:	ba 00 00 00 00       	mov    $0x0,%edx
  800f76:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f7b:	89 d1                	mov    %edx,%ecx
  800f7d:	89 d3                	mov    %edx,%ebx
  800f7f:	89 d7                	mov    %edx,%edi
  800f81:	89 d6                	mov    %edx,%esi
  800f83:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800f85:	5b                   	pop    %ebx
  800f86:	5e                   	pop    %esi
  800f87:	5f                   	pop    %edi
  800f88:	5d                   	pop    %ebp
  800f89:	c3                   	ret    

00800f8a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800f8a:	55                   	push   %ebp
  800f8b:	89 e5                	mov    %esp,%ebp
  800f8d:	57                   	push   %edi
  800f8e:	56                   	push   %esi
  800f8f:	53                   	push   %ebx
  800f90:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f93:	be 00 00 00 00       	mov    $0x0,%esi
  800f98:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f9e:	b8 04 00 00 00       	mov    $0x4,%eax
  800fa3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fa6:	89 f7                	mov    %esi,%edi
  800fa8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800faa:	85 c0                	test   %eax,%eax
  800fac:	7f 08                	jg     800fb6 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800fae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fb1:	5b                   	pop    %ebx
  800fb2:	5e                   	pop    %esi
  800fb3:	5f                   	pop    %edi
  800fb4:	5d                   	pop    %ebp
  800fb5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fb6:	83 ec 0c             	sub    $0xc,%esp
  800fb9:	50                   	push   %eax
  800fba:	6a 04                	push   $0x4
  800fbc:	68 48 2e 80 00       	push   $0x802e48
  800fc1:	6a 43                	push   $0x43
  800fc3:	68 65 2e 80 00       	push   $0x802e65
  800fc8:	e8 76 f3 ff ff       	call   800343 <_panic>

00800fcd <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800fcd:	55                   	push   %ebp
  800fce:	89 e5                	mov    %esp,%ebp
  800fd0:	57                   	push   %edi
  800fd1:	56                   	push   %esi
  800fd2:	53                   	push   %ebx
  800fd3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fd6:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fdc:	b8 05 00 00 00       	mov    $0x5,%eax
  800fe1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fe4:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fe7:	8b 75 18             	mov    0x18(%ebp),%esi
  800fea:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fec:	85 c0                	test   %eax,%eax
  800fee:	7f 08                	jg     800ff8 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ff0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ff3:	5b                   	pop    %ebx
  800ff4:	5e                   	pop    %esi
  800ff5:	5f                   	pop    %edi
  800ff6:	5d                   	pop    %ebp
  800ff7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ff8:	83 ec 0c             	sub    $0xc,%esp
  800ffb:	50                   	push   %eax
  800ffc:	6a 05                	push   $0x5
  800ffe:	68 48 2e 80 00       	push   $0x802e48
  801003:	6a 43                	push   $0x43
  801005:	68 65 2e 80 00       	push   $0x802e65
  80100a:	e8 34 f3 ff ff       	call   800343 <_panic>

0080100f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80100f:	55                   	push   %ebp
  801010:	89 e5                	mov    %esp,%ebp
  801012:	57                   	push   %edi
  801013:	56                   	push   %esi
  801014:	53                   	push   %ebx
  801015:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801018:	bb 00 00 00 00       	mov    $0x0,%ebx
  80101d:	8b 55 08             	mov    0x8(%ebp),%edx
  801020:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801023:	b8 06 00 00 00       	mov    $0x6,%eax
  801028:	89 df                	mov    %ebx,%edi
  80102a:	89 de                	mov    %ebx,%esi
  80102c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80102e:	85 c0                	test   %eax,%eax
  801030:	7f 08                	jg     80103a <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801032:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801035:	5b                   	pop    %ebx
  801036:	5e                   	pop    %esi
  801037:	5f                   	pop    %edi
  801038:	5d                   	pop    %ebp
  801039:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80103a:	83 ec 0c             	sub    $0xc,%esp
  80103d:	50                   	push   %eax
  80103e:	6a 06                	push   $0x6
  801040:	68 48 2e 80 00       	push   $0x802e48
  801045:	6a 43                	push   $0x43
  801047:	68 65 2e 80 00       	push   $0x802e65
  80104c:	e8 f2 f2 ff ff       	call   800343 <_panic>

00801051 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801051:	55                   	push   %ebp
  801052:	89 e5                	mov    %esp,%ebp
  801054:	57                   	push   %edi
  801055:	56                   	push   %esi
  801056:	53                   	push   %ebx
  801057:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80105a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80105f:	8b 55 08             	mov    0x8(%ebp),%edx
  801062:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801065:	b8 08 00 00 00       	mov    $0x8,%eax
  80106a:	89 df                	mov    %ebx,%edi
  80106c:	89 de                	mov    %ebx,%esi
  80106e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801070:	85 c0                	test   %eax,%eax
  801072:	7f 08                	jg     80107c <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801074:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801077:	5b                   	pop    %ebx
  801078:	5e                   	pop    %esi
  801079:	5f                   	pop    %edi
  80107a:	5d                   	pop    %ebp
  80107b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80107c:	83 ec 0c             	sub    $0xc,%esp
  80107f:	50                   	push   %eax
  801080:	6a 08                	push   $0x8
  801082:	68 48 2e 80 00       	push   $0x802e48
  801087:	6a 43                	push   $0x43
  801089:	68 65 2e 80 00       	push   $0x802e65
  80108e:	e8 b0 f2 ff ff       	call   800343 <_panic>

00801093 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801093:	55                   	push   %ebp
  801094:	89 e5                	mov    %esp,%ebp
  801096:	57                   	push   %edi
  801097:	56                   	push   %esi
  801098:	53                   	push   %ebx
  801099:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80109c:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010a7:	b8 09 00 00 00       	mov    $0x9,%eax
  8010ac:	89 df                	mov    %ebx,%edi
  8010ae:	89 de                	mov    %ebx,%esi
  8010b0:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010b2:	85 c0                	test   %eax,%eax
  8010b4:	7f 08                	jg     8010be <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8010b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010b9:	5b                   	pop    %ebx
  8010ba:	5e                   	pop    %esi
  8010bb:	5f                   	pop    %edi
  8010bc:	5d                   	pop    %ebp
  8010bd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010be:	83 ec 0c             	sub    $0xc,%esp
  8010c1:	50                   	push   %eax
  8010c2:	6a 09                	push   $0x9
  8010c4:	68 48 2e 80 00       	push   $0x802e48
  8010c9:	6a 43                	push   $0x43
  8010cb:	68 65 2e 80 00       	push   $0x802e65
  8010d0:	e8 6e f2 ff ff       	call   800343 <_panic>

008010d5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8010d5:	55                   	push   %ebp
  8010d6:	89 e5                	mov    %esp,%ebp
  8010d8:	57                   	push   %edi
  8010d9:	56                   	push   %esi
  8010da:	53                   	push   %ebx
  8010db:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010de:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010e9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8010ee:	89 df                	mov    %ebx,%edi
  8010f0:	89 de                	mov    %ebx,%esi
  8010f2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010f4:	85 c0                	test   %eax,%eax
  8010f6:	7f 08                	jg     801100 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8010f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010fb:	5b                   	pop    %ebx
  8010fc:	5e                   	pop    %esi
  8010fd:	5f                   	pop    %edi
  8010fe:	5d                   	pop    %ebp
  8010ff:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801100:	83 ec 0c             	sub    $0xc,%esp
  801103:	50                   	push   %eax
  801104:	6a 0a                	push   $0xa
  801106:	68 48 2e 80 00       	push   $0x802e48
  80110b:	6a 43                	push   $0x43
  80110d:	68 65 2e 80 00       	push   $0x802e65
  801112:	e8 2c f2 ff ff       	call   800343 <_panic>

00801117 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801117:	55                   	push   %ebp
  801118:	89 e5                	mov    %esp,%ebp
  80111a:	57                   	push   %edi
  80111b:	56                   	push   %esi
  80111c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80111d:	8b 55 08             	mov    0x8(%ebp),%edx
  801120:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801123:	b8 0c 00 00 00       	mov    $0xc,%eax
  801128:	be 00 00 00 00       	mov    $0x0,%esi
  80112d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801130:	8b 7d 14             	mov    0x14(%ebp),%edi
  801133:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801135:	5b                   	pop    %ebx
  801136:	5e                   	pop    %esi
  801137:	5f                   	pop    %edi
  801138:	5d                   	pop    %ebp
  801139:	c3                   	ret    

0080113a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80113a:	55                   	push   %ebp
  80113b:	89 e5                	mov    %esp,%ebp
  80113d:	57                   	push   %edi
  80113e:	56                   	push   %esi
  80113f:	53                   	push   %ebx
  801140:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801143:	b9 00 00 00 00       	mov    $0x0,%ecx
  801148:	8b 55 08             	mov    0x8(%ebp),%edx
  80114b:	b8 0d 00 00 00       	mov    $0xd,%eax
  801150:	89 cb                	mov    %ecx,%ebx
  801152:	89 cf                	mov    %ecx,%edi
  801154:	89 ce                	mov    %ecx,%esi
  801156:	cd 30                	int    $0x30
	if(check && ret > 0)
  801158:	85 c0                	test   %eax,%eax
  80115a:	7f 08                	jg     801164 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80115c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80115f:	5b                   	pop    %ebx
  801160:	5e                   	pop    %esi
  801161:	5f                   	pop    %edi
  801162:	5d                   	pop    %ebp
  801163:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801164:	83 ec 0c             	sub    $0xc,%esp
  801167:	50                   	push   %eax
  801168:	6a 0d                	push   $0xd
  80116a:	68 48 2e 80 00       	push   $0x802e48
  80116f:	6a 43                	push   $0x43
  801171:	68 65 2e 80 00       	push   $0x802e65
  801176:	e8 c8 f1 ff ff       	call   800343 <_panic>

0080117b <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  80117b:	55                   	push   %ebp
  80117c:	89 e5                	mov    %esp,%ebp
  80117e:	57                   	push   %edi
  80117f:	56                   	push   %esi
  801180:	53                   	push   %ebx
	asm volatile("int %1\n"
  801181:	bb 00 00 00 00       	mov    $0x0,%ebx
  801186:	8b 55 08             	mov    0x8(%ebp),%edx
  801189:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80118c:	b8 0e 00 00 00       	mov    $0xe,%eax
  801191:	89 df                	mov    %ebx,%edi
  801193:	89 de                	mov    %ebx,%esi
  801195:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801197:	5b                   	pop    %ebx
  801198:	5e                   	pop    %esi
  801199:	5f                   	pop    %edi
  80119a:	5d                   	pop    %ebp
  80119b:	c3                   	ret    

0080119c <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  80119c:	55                   	push   %ebp
  80119d:	89 e5                	mov    %esp,%ebp
  80119f:	57                   	push   %edi
  8011a0:	56                   	push   %esi
  8011a1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011a2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8011aa:	b8 0f 00 00 00       	mov    $0xf,%eax
  8011af:	89 cb                	mov    %ecx,%ebx
  8011b1:	89 cf                	mov    %ecx,%edi
  8011b3:	89 ce                	mov    %ecx,%esi
  8011b5:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8011b7:	5b                   	pop    %ebx
  8011b8:	5e                   	pop    %esi
  8011b9:	5f                   	pop    %edi
  8011ba:	5d                   	pop    %ebp
  8011bb:	c3                   	ret    

008011bc <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8011bc:	55                   	push   %ebp
  8011bd:	89 e5                	mov    %esp,%ebp
  8011bf:	57                   	push   %edi
  8011c0:	56                   	push   %esi
  8011c1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8011c7:	b8 10 00 00 00       	mov    $0x10,%eax
  8011cc:	89 d1                	mov    %edx,%ecx
  8011ce:	89 d3                	mov    %edx,%ebx
  8011d0:	89 d7                	mov    %edx,%edi
  8011d2:	89 d6                	mov    %edx,%esi
  8011d4:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8011d6:	5b                   	pop    %ebx
  8011d7:	5e                   	pop    %esi
  8011d8:	5f                   	pop    %edi
  8011d9:	5d                   	pop    %ebp
  8011da:	c3                   	ret    

008011db <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  8011db:	55                   	push   %ebp
  8011dc:	89 e5                	mov    %esp,%ebp
  8011de:	57                   	push   %edi
  8011df:	56                   	push   %esi
  8011e0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011e1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8011e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011ec:	b8 11 00 00 00       	mov    $0x11,%eax
  8011f1:	89 df                	mov    %ebx,%edi
  8011f3:	89 de                	mov    %ebx,%esi
  8011f5:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8011f7:	5b                   	pop    %ebx
  8011f8:	5e                   	pop    %esi
  8011f9:	5f                   	pop    %edi
  8011fa:	5d                   	pop    %ebp
  8011fb:	c3                   	ret    

008011fc <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  8011fc:	55                   	push   %ebp
  8011fd:	89 e5                	mov    %esp,%ebp
  8011ff:	57                   	push   %edi
  801200:	56                   	push   %esi
  801201:	53                   	push   %ebx
	asm volatile("int %1\n"
  801202:	bb 00 00 00 00       	mov    $0x0,%ebx
  801207:	8b 55 08             	mov    0x8(%ebp),%edx
  80120a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80120d:	b8 12 00 00 00       	mov    $0x12,%eax
  801212:	89 df                	mov    %ebx,%edi
  801214:	89 de                	mov    %ebx,%esi
  801216:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801218:	5b                   	pop    %ebx
  801219:	5e                   	pop    %esi
  80121a:	5f                   	pop    %edi
  80121b:	5d                   	pop    %ebp
  80121c:	c3                   	ret    

0080121d <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  80121d:	55                   	push   %ebp
  80121e:	89 e5                	mov    %esp,%ebp
  801220:	57                   	push   %edi
  801221:	56                   	push   %esi
  801222:	53                   	push   %ebx
  801223:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801226:	bb 00 00 00 00       	mov    $0x0,%ebx
  80122b:	8b 55 08             	mov    0x8(%ebp),%edx
  80122e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801231:	b8 13 00 00 00       	mov    $0x13,%eax
  801236:	89 df                	mov    %ebx,%edi
  801238:	89 de                	mov    %ebx,%esi
  80123a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80123c:	85 c0                	test   %eax,%eax
  80123e:	7f 08                	jg     801248 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801240:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801243:	5b                   	pop    %ebx
  801244:	5e                   	pop    %esi
  801245:	5f                   	pop    %edi
  801246:	5d                   	pop    %ebp
  801247:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801248:	83 ec 0c             	sub    $0xc,%esp
  80124b:	50                   	push   %eax
  80124c:	6a 13                	push   $0x13
  80124e:	68 48 2e 80 00       	push   $0x802e48
  801253:	6a 43                	push   $0x43
  801255:	68 65 2e 80 00       	push   $0x802e65
  80125a:	e8 e4 f0 ff ff       	call   800343 <_panic>

0080125f <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  80125f:	55                   	push   %ebp
  801260:	89 e5                	mov    %esp,%ebp
  801262:	57                   	push   %edi
  801263:	56                   	push   %esi
  801264:	53                   	push   %ebx
	asm volatile("int %1\n"
  801265:	b9 00 00 00 00       	mov    $0x0,%ecx
  80126a:	8b 55 08             	mov    0x8(%ebp),%edx
  80126d:	b8 14 00 00 00       	mov    $0x14,%eax
  801272:	89 cb                	mov    %ecx,%ebx
  801274:	89 cf                	mov    %ecx,%edi
  801276:	89 ce                	mov    %ecx,%esi
  801278:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  80127a:	5b                   	pop    %ebx
  80127b:	5e                   	pop    %esi
  80127c:	5f                   	pop    %edi
  80127d:	5d                   	pop    %ebp
  80127e:	c3                   	ret    

0080127f <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  80127f:	55                   	push   %ebp
  801280:	89 e5                	mov    %esp,%ebp
  801282:	8b 55 08             	mov    0x8(%ebp),%edx
  801285:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801288:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  80128b:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  80128d:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801290:	83 3a 01             	cmpl   $0x1,(%edx)
  801293:	7e 09                	jle    80129e <argstart+0x1f>
  801295:	ba b3 2f 80 00       	mov    $0x802fb3,%edx
  80129a:	85 c9                	test   %ecx,%ecx
  80129c:	75 05                	jne    8012a3 <argstart+0x24>
  80129e:	ba 00 00 00 00       	mov    $0x0,%edx
  8012a3:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  8012a6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  8012ad:	5d                   	pop    %ebp
  8012ae:	c3                   	ret    

008012af <argnext>:

int
argnext(struct Argstate *args)
{
  8012af:	55                   	push   %ebp
  8012b0:	89 e5                	mov    %esp,%ebp
  8012b2:	53                   	push   %ebx
  8012b3:	83 ec 04             	sub    $0x4,%esp
  8012b6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  8012b9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  8012c0:	8b 43 08             	mov    0x8(%ebx),%eax
  8012c3:	85 c0                	test   %eax,%eax
  8012c5:	74 72                	je     801339 <argnext+0x8a>
		return -1;

	if (!*args->curarg) {
  8012c7:	80 38 00             	cmpb   $0x0,(%eax)
  8012ca:	75 48                	jne    801314 <argnext+0x65>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  8012cc:	8b 0b                	mov    (%ebx),%ecx
  8012ce:	83 39 01             	cmpl   $0x1,(%ecx)
  8012d1:	74 58                	je     80132b <argnext+0x7c>
		    || args->argv[1][0] != '-'
  8012d3:	8b 53 04             	mov    0x4(%ebx),%edx
  8012d6:	8b 42 04             	mov    0x4(%edx),%eax
  8012d9:	80 38 2d             	cmpb   $0x2d,(%eax)
  8012dc:	75 4d                	jne    80132b <argnext+0x7c>
		    || args->argv[1][1] == '\0')
  8012de:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  8012e2:	74 47                	je     80132b <argnext+0x7c>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  8012e4:	83 c0 01             	add    $0x1,%eax
  8012e7:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8012ea:	83 ec 04             	sub    $0x4,%esp
  8012ed:	8b 01                	mov    (%ecx),%eax
  8012ef:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  8012f6:	50                   	push   %eax
  8012f7:	8d 42 08             	lea    0x8(%edx),%eax
  8012fa:	50                   	push   %eax
  8012fb:	83 c2 04             	add    $0x4,%edx
  8012fe:	52                   	push   %edx
  8012ff:	e8 22 fa ff ff       	call   800d26 <memmove>
		(*args->argc)--;
  801304:	8b 03                	mov    (%ebx),%eax
  801306:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801309:	8b 43 08             	mov    0x8(%ebx),%eax
  80130c:	83 c4 10             	add    $0x10,%esp
  80130f:	80 38 2d             	cmpb   $0x2d,(%eax)
  801312:	74 11                	je     801325 <argnext+0x76>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  801314:	8b 53 08             	mov    0x8(%ebx),%edx
  801317:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  80131a:	83 c2 01             	add    $0x1,%edx
  80131d:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  801320:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801323:	c9                   	leave  
  801324:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801325:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801329:	75 e9                	jne    801314 <argnext+0x65>
	args->curarg = 0;
  80132b:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  801332:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801337:	eb e7                	jmp    801320 <argnext+0x71>
		return -1;
  801339:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80133e:	eb e0                	jmp    801320 <argnext+0x71>

00801340 <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  801340:	55                   	push   %ebp
  801341:	89 e5                	mov    %esp,%ebp
  801343:	53                   	push   %ebx
  801344:	83 ec 04             	sub    $0x4,%esp
  801347:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  80134a:	8b 43 08             	mov    0x8(%ebx),%eax
  80134d:	85 c0                	test   %eax,%eax
  80134f:	74 12                	je     801363 <argnextvalue+0x23>
		return 0;
	if (*args->curarg) {
  801351:	80 38 00             	cmpb   $0x0,(%eax)
  801354:	74 12                	je     801368 <argnextvalue+0x28>
		args->argvalue = args->curarg;
  801356:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  801359:	c7 43 08 b3 2f 80 00 	movl   $0x802fb3,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  801360:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  801363:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801366:	c9                   	leave  
  801367:	c3                   	ret    
	} else if (*args->argc > 1) {
  801368:	8b 13                	mov    (%ebx),%edx
  80136a:	83 3a 01             	cmpl   $0x1,(%edx)
  80136d:	7f 10                	jg     80137f <argnextvalue+0x3f>
		args->argvalue = 0;
  80136f:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  801376:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  80137d:	eb e1                	jmp    801360 <argnextvalue+0x20>
		args->argvalue = args->argv[1];
  80137f:	8b 43 04             	mov    0x4(%ebx),%eax
  801382:	8b 48 04             	mov    0x4(%eax),%ecx
  801385:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801388:	83 ec 04             	sub    $0x4,%esp
  80138b:	8b 12                	mov    (%edx),%edx
  80138d:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  801394:	52                   	push   %edx
  801395:	8d 50 08             	lea    0x8(%eax),%edx
  801398:	52                   	push   %edx
  801399:	83 c0 04             	add    $0x4,%eax
  80139c:	50                   	push   %eax
  80139d:	e8 84 f9 ff ff       	call   800d26 <memmove>
		(*args->argc)--;
  8013a2:	8b 03                	mov    (%ebx),%eax
  8013a4:	83 28 01             	subl   $0x1,(%eax)
  8013a7:	83 c4 10             	add    $0x10,%esp
  8013aa:	eb b4                	jmp    801360 <argnextvalue+0x20>

008013ac <argvalue>:
{
  8013ac:	55                   	push   %ebp
  8013ad:	89 e5                	mov    %esp,%ebp
  8013af:	83 ec 08             	sub    $0x8,%esp
  8013b2:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  8013b5:	8b 42 0c             	mov    0xc(%edx),%eax
  8013b8:	85 c0                	test   %eax,%eax
  8013ba:	74 02                	je     8013be <argvalue+0x12>
}
  8013bc:	c9                   	leave  
  8013bd:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  8013be:	83 ec 0c             	sub    $0xc,%esp
  8013c1:	52                   	push   %edx
  8013c2:	e8 79 ff ff ff       	call   801340 <argnextvalue>
  8013c7:	83 c4 10             	add    $0x10,%esp
  8013ca:	eb f0                	jmp    8013bc <argvalue+0x10>

008013cc <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8013cc:	55                   	push   %ebp
  8013cd:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d2:	05 00 00 00 30       	add    $0x30000000,%eax
  8013d7:	c1 e8 0c             	shr    $0xc,%eax
}
  8013da:	5d                   	pop    %ebp
  8013db:	c3                   	ret    

008013dc <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8013dc:	55                   	push   %ebp
  8013dd:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013df:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e2:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8013e7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013ec:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8013f1:	5d                   	pop    %ebp
  8013f2:	c3                   	ret    

008013f3 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8013f3:	55                   	push   %ebp
  8013f4:	89 e5                	mov    %esp,%ebp
  8013f6:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8013fb:	89 c2                	mov    %eax,%edx
  8013fd:	c1 ea 16             	shr    $0x16,%edx
  801400:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801407:	f6 c2 01             	test   $0x1,%dl
  80140a:	74 2d                	je     801439 <fd_alloc+0x46>
  80140c:	89 c2                	mov    %eax,%edx
  80140e:	c1 ea 0c             	shr    $0xc,%edx
  801411:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801418:	f6 c2 01             	test   $0x1,%dl
  80141b:	74 1c                	je     801439 <fd_alloc+0x46>
  80141d:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801422:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801427:	75 d2                	jne    8013fb <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801429:	8b 45 08             	mov    0x8(%ebp),%eax
  80142c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801432:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801437:	eb 0a                	jmp    801443 <fd_alloc+0x50>
			*fd_store = fd;
  801439:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80143c:	89 01                	mov    %eax,(%ecx)
			return 0;
  80143e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801443:	5d                   	pop    %ebp
  801444:	c3                   	ret    

00801445 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801445:	55                   	push   %ebp
  801446:	89 e5                	mov    %esp,%ebp
  801448:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80144b:	83 f8 1f             	cmp    $0x1f,%eax
  80144e:	77 30                	ja     801480 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801450:	c1 e0 0c             	shl    $0xc,%eax
  801453:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801458:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80145e:	f6 c2 01             	test   $0x1,%dl
  801461:	74 24                	je     801487 <fd_lookup+0x42>
  801463:	89 c2                	mov    %eax,%edx
  801465:	c1 ea 0c             	shr    $0xc,%edx
  801468:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80146f:	f6 c2 01             	test   $0x1,%dl
  801472:	74 1a                	je     80148e <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801474:	8b 55 0c             	mov    0xc(%ebp),%edx
  801477:	89 02                	mov    %eax,(%edx)
	return 0;
  801479:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80147e:	5d                   	pop    %ebp
  80147f:	c3                   	ret    
		return -E_INVAL;
  801480:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801485:	eb f7                	jmp    80147e <fd_lookup+0x39>
		return -E_INVAL;
  801487:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80148c:	eb f0                	jmp    80147e <fd_lookup+0x39>
  80148e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801493:	eb e9                	jmp    80147e <fd_lookup+0x39>

00801495 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801495:	55                   	push   %ebp
  801496:	89 e5                	mov    %esp,%ebp
  801498:	83 ec 08             	sub    $0x8,%esp
  80149b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80149e:	ba 00 00 00 00       	mov    $0x0,%edx
  8014a3:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8014a8:	39 08                	cmp    %ecx,(%eax)
  8014aa:	74 38                	je     8014e4 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8014ac:	83 c2 01             	add    $0x1,%edx
  8014af:	8b 04 95 f4 2e 80 00 	mov    0x802ef4(,%edx,4),%eax
  8014b6:	85 c0                	test   %eax,%eax
  8014b8:	75 ee                	jne    8014a8 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8014ba:	a1 20 44 80 00       	mov    0x804420,%eax
  8014bf:	8b 40 48             	mov    0x48(%eax),%eax
  8014c2:	83 ec 04             	sub    $0x4,%esp
  8014c5:	51                   	push   %ecx
  8014c6:	50                   	push   %eax
  8014c7:	68 74 2e 80 00       	push   $0x802e74
  8014cc:	e8 68 ef ff ff       	call   800439 <cprintf>
	*dev = 0;
  8014d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8014da:	83 c4 10             	add    $0x10,%esp
  8014dd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8014e2:	c9                   	leave  
  8014e3:	c3                   	ret    
			*dev = devtab[i];
  8014e4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014e7:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ee:	eb f2                	jmp    8014e2 <dev_lookup+0x4d>

008014f0 <fd_close>:
{
  8014f0:	55                   	push   %ebp
  8014f1:	89 e5                	mov    %esp,%ebp
  8014f3:	57                   	push   %edi
  8014f4:	56                   	push   %esi
  8014f5:	53                   	push   %ebx
  8014f6:	83 ec 24             	sub    $0x24,%esp
  8014f9:	8b 75 08             	mov    0x8(%ebp),%esi
  8014fc:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014ff:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801502:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801503:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801509:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80150c:	50                   	push   %eax
  80150d:	e8 33 ff ff ff       	call   801445 <fd_lookup>
  801512:	89 c3                	mov    %eax,%ebx
  801514:	83 c4 10             	add    $0x10,%esp
  801517:	85 c0                	test   %eax,%eax
  801519:	78 05                	js     801520 <fd_close+0x30>
	    || fd != fd2)
  80151b:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80151e:	74 16                	je     801536 <fd_close+0x46>
		return (must_exist ? r : 0);
  801520:	89 f8                	mov    %edi,%eax
  801522:	84 c0                	test   %al,%al
  801524:	b8 00 00 00 00       	mov    $0x0,%eax
  801529:	0f 44 d8             	cmove  %eax,%ebx
}
  80152c:	89 d8                	mov    %ebx,%eax
  80152e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801531:	5b                   	pop    %ebx
  801532:	5e                   	pop    %esi
  801533:	5f                   	pop    %edi
  801534:	5d                   	pop    %ebp
  801535:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801536:	83 ec 08             	sub    $0x8,%esp
  801539:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80153c:	50                   	push   %eax
  80153d:	ff 36                	pushl  (%esi)
  80153f:	e8 51 ff ff ff       	call   801495 <dev_lookup>
  801544:	89 c3                	mov    %eax,%ebx
  801546:	83 c4 10             	add    $0x10,%esp
  801549:	85 c0                	test   %eax,%eax
  80154b:	78 1a                	js     801567 <fd_close+0x77>
		if (dev->dev_close)
  80154d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801550:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801553:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801558:	85 c0                	test   %eax,%eax
  80155a:	74 0b                	je     801567 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80155c:	83 ec 0c             	sub    $0xc,%esp
  80155f:	56                   	push   %esi
  801560:	ff d0                	call   *%eax
  801562:	89 c3                	mov    %eax,%ebx
  801564:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801567:	83 ec 08             	sub    $0x8,%esp
  80156a:	56                   	push   %esi
  80156b:	6a 00                	push   $0x0
  80156d:	e8 9d fa ff ff       	call   80100f <sys_page_unmap>
	return r;
  801572:	83 c4 10             	add    $0x10,%esp
  801575:	eb b5                	jmp    80152c <fd_close+0x3c>

00801577 <close>:

int
close(int fdnum)
{
  801577:	55                   	push   %ebp
  801578:	89 e5                	mov    %esp,%ebp
  80157a:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80157d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801580:	50                   	push   %eax
  801581:	ff 75 08             	pushl  0x8(%ebp)
  801584:	e8 bc fe ff ff       	call   801445 <fd_lookup>
  801589:	83 c4 10             	add    $0x10,%esp
  80158c:	85 c0                	test   %eax,%eax
  80158e:	79 02                	jns    801592 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801590:	c9                   	leave  
  801591:	c3                   	ret    
		return fd_close(fd, 1);
  801592:	83 ec 08             	sub    $0x8,%esp
  801595:	6a 01                	push   $0x1
  801597:	ff 75 f4             	pushl  -0xc(%ebp)
  80159a:	e8 51 ff ff ff       	call   8014f0 <fd_close>
  80159f:	83 c4 10             	add    $0x10,%esp
  8015a2:	eb ec                	jmp    801590 <close+0x19>

008015a4 <close_all>:

void
close_all(void)
{
  8015a4:	55                   	push   %ebp
  8015a5:	89 e5                	mov    %esp,%ebp
  8015a7:	53                   	push   %ebx
  8015a8:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8015ab:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8015b0:	83 ec 0c             	sub    $0xc,%esp
  8015b3:	53                   	push   %ebx
  8015b4:	e8 be ff ff ff       	call   801577 <close>
	for (i = 0; i < MAXFD; i++)
  8015b9:	83 c3 01             	add    $0x1,%ebx
  8015bc:	83 c4 10             	add    $0x10,%esp
  8015bf:	83 fb 20             	cmp    $0x20,%ebx
  8015c2:	75 ec                	jne    8015b0 <close_all+0xc>
}
  8015c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015c7:	c9                   	leave  
  8015c8:	c3                   	ret    

008015c9 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8015c9:	55                   	push   %ebp
  8015ca:	89 e5                	mov    %esp,%ebp
  8015cc:	57                   	push   %edi
  8015cd:	56                   	push   %esi
  8015ce:	53                   	push   %ebx
  8015cf:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8015d2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015d5:	50                   	push   %eax
  8015d6:	ff 75 08             	pushl  0x8(%ebp)
  8015d9:	e8 67 fe ff ff       	call   801445 <fd_lookup>
  8015de:	89 c3                	mov    %eax,%ebx
  8015e0:	83 c4 10             	add    $0x10,%esp
  8015e3:	85 c0                	test   %eax,%eax
  8015e5:	0f 88 81 00 00 00    	js     80166c <dup+0xa3>
		return r;
	close(newfdnum);
  8015eb:	83 ec 0c             	sub    $0xc,%esp
  8015ee:	ff 75 0c             	pushl  0xc(%ebp)
  8015f1:	e8 81 ff ff ff       	call   801577 <close>

	newfd = INDEX2FD(newfdnum);
  8015f6:	8b 75 0c             	mov    0xc(%ebp),%esi
  8015f9:	c1 e6 0c             	shl    $0xc,%esi
  8015fc:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801602:	83 c4 04             	add    $0x4,%esp
  801605:	ff 75 e4             	pushl  -0x1c(%ebp)
  801608:	e8 cf fd ff ff       	call   8013dc <fd2data>
  80160d:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80160f:	89 34 24             	mov    %esi,(%esp)
  801612:	e8 c5 fd ff ff       	call   8013dc <fd2data>
  801617:	83 c4 10             	add    $0x10,%esp
  80161a:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80161c:	89 d8                	mov    %ebx,%eax
  80161e:	c1 e8 16             	shr    $0x16,%eax
  801621:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801628:	a8 01                	test   $0x1,%al
  80162a:	74 11                	je     80163d <dup+0x74>
  80162c:	89 d8                	mov    %ebx,%eax
  80162e:	c1 e8 0c             	shr    $0xc,%eax
  801631:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801638:	f6 c2 01             	test   $0x1,%dl
  80163b:	75 39                	jne    801676 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80163d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801640:	89 d0                	mov    %edx,%eax
  801642:	c1 e8 0c             	shr    $0xc,%eax
  801645:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80164c:	83 ec 0c             	sub    $0xc,%esp
  80164f:	25 07 0e 00 00       	and    $0xe07,%eax
  801654:	50                   	push   %eax
  801655:	56                   	push   %esi
  801656:	6a 00                	push   $0x0
  801658:	52                   	push   %edx
  801659:	6a 00                	push   $0x0
  80165b:	e8 6d f9 ff ff       	call   800fcd <sys_page_map>
  801660:	89 c3                	mov    %eax,%ebx
  801662:	83 c4 20             	add    $0x20,%esp
  801665:	85 c0                	test   %eax,%eax
  801667:	78 31                	js     80169a <dup+0xd1>
		goto err;

	return newfdnum;
  801669:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80166c:	89 d8                	mov    %ebx,%eax
  80166e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801671:	5b                   	pop    %ebx
  801672:	5e                   	pop    %esi
  801673:	5f                   	pop    %edi
  801674:	5d                   	pop    %ebp
  801675:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801676:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80167d:	83 ec 0c             	sub    $0xc,%esp
  801680:	25 07 0e 00 00       	and    $0xe07,%eax
  801685:	50                   	push   %eax
  801686:	57                   	push   %edi
  801687:	6a 00                	push   $0x0
  801689:	53                   	push   %ebx
  80168a:	6a 00                	push   $0x0
  80168c:	e8 3c f9 ff ff       	call   800fcd <sys_page_map>
  801691:	89 c3                	mov    %eax,%ebx
  801693:	83 c4 20             	add    $0x20,%esp
  801696:	85 c0                	test   %eax,%eax
  801698:	79 a3                	jns    80163d <dup+0x74>
	sys_page_unmap(0, newfd);
  80169a:	83 ec 08             	sub    $0x8,%esp
  80169d:	56                   	push   %esi
  80169e:	6a 00                	push   $0x0
  8016a0:	e8 6a f9 ff ff       	call   80100f <sys_page_unmap>
	sys_page_unmap(0, nva);
  8016a5:	83 c4 08             	add    $0x8,%esp
  8016a8:	57                   	push   %edi
  8016a9:	6a 00                	push   $0x0
  8016ab:	e8 5f f9 ff ff       	call   80100f <sys_page_unmap>
	return r;
  8016b0:	83 c4 10             	add    $0x10,%esp
  8016b3:	eb b7                	jmp    80166c <dup+0xa3>

008016b5 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8016b5:	55                   	push   %ebp
  8016b6:	89 e5                	mov    %esp,%ebp
  8016b8:	53                   	push   %ebx
  8016b9:	83 ec 1c             	sub    $0x1c,%esp
  8016bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016bf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016c2:	50                   	push   %eax
  8016c3:	53                   	push   %ebx
  8016c4:	e8 7c fd ff ff       	call   801445 <fd_lookup>
  8016c9:	83 c4 10             	add    $0x10,%esp
  8016cc:	85 c0                	test   %eax,%eax
  8016ce:	78 3f                	js     80170f <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016d0:	83 ec 08             	sub    $0x8,%esp
  8016d3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016d6:	50                   	push   %eax
  8016d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016da:	ff 30                	pushl  (%eax)
  8016dc:	e8 b4 fd ff ff       	call   801495 <dev_lookup>
  8016e1:	83 c4 10             	add    $0x10,%esp
  8016e4:	85 c0                	test   %eax,%eax
  8016e6:	78 27                	js     80170f <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8016e8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016eb:	8b 42 08             	mov    0x8(%edx),%eax
  8016ee:	83 e0 03             	and    $0x3,%eax
  8016f1:	83 f8 01             	cmp    $0x1,%eax
  8016f4:	74 1e                	je     801714 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8016f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016f9:	8b 40 08             	mov    0x8(%eax),%eax
  8016fc:	85 c0                	test   %eax,%eax
  8016fe:	74 35                	je     801735 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801700:	83 ec 04             	sub    $0x4,%esp
  801703:	ff 75 10             	pushl  0x10(%ebp)
  801706:	ff 75 0c             	pushl  0xc(%ebp)
  801709:	52                   	push   %edx
  80170a:	ff d0                	call   *%eax
  80170c:	83 c4 10             	add    $0x10,%esp
}
  80170f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801712:	c9                   	leave  
  801713:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801714:	a1 20 44 80 00       	mov    0x804420,%eax
  801719:	8b 40 48             	mov    0x48(%eax),%eax
  80171c:	83 ec 04             	sub    $0x4,%esp
  80171f:	53                   	push   %ebx
  801720:	50                   	push   %eax
  801721:	68 b8 2e 80 00       	push   $0x802eb8
  801726:	e8 0e ed ff ff       	call   800439 <cprintf>
		return -E_INVAL;
  80172b:	83 c4 10             	add    $0x10,%esp
  80172e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801733:	eb da                	jmp    80170f <read+0x5a>
		return -E_NOT_SUPP;
  801735:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80173a:	eb d3                	jmp    80170f <read+0x5a>

0080173c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
  80173f:	57                   	push   %edi
  801740:	56                   	push   %esi
  801741:	53                   	push   %ebx
  801742:	83 ec 0c             	sub    $0xc,%esp
  801745:	8b 7d 08             	mov    0x8(%ebp),%edi
  801748:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80174b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801750:	39 f3                	cmp    %esi,%ebx
  801752:	73 23                	jae    801777 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801754:	83 ec 04             	sub    $0x4,%esp
  801757:	89 f0                	mov    %esi,%eax
  801759:	29 d8                	sub    %ebx,%eax
  80175b:	50                   	push   %eax
  80175c:	89 d8                	mov    %ebx,%eax
  80175e:	03 45 0c             	add    0xc(%ebp),%eax
  801761:	50                   	push   %eax
  801762:	57                   	push   %edi
  801763:	e8 4d ff ff ff       	call   8016b5 <read>
		if (m < 0)
  801768:	83 c4 10             	add    $0x10,%esp
  80176b:	85 c0                	test   %eax,%eax
  80176d:	78 06                	js     801775 <readn+0x39>
			return m;
		if (m == 0)
  80176f:	74 06                	je     801777 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801771:	01 c3                	add    %eax,%ebx
  801773:	eb db                	jmp    801750 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801775:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801777:	89 d8                	mov    %ebx,%eax
  801779:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80177c:	5b                   	pop    %ebx
  80177d:	5e                   	pop    %esi
  80177e:	5f                   	pop    %edi
  80177f:	5d                   	pop    %ebp
  801780:	c3                   	ret    

00801781 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801781:	55                   	push   %ebp
  801782:	89 e5                	mov    %esp,%ebp
  801784:	53                   	push   %ebx
  801785:	83 ec 1c             	sub    $0x1c,%esp
  801788:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80178b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80178e:	50                   	push   %eax
  80178f:	53                   	push   %ebx
  801790:	e8 b0 fc ff ff       	call   801445 <fd_lookup>
  801795:	83 c4 10             	add    $0x10,%esp
  801798:	85 c0                	test   %eax,%eax
  80179a:	78 3a                	js     8017d6 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80179c:	83 ec 08             	sub    $0x8,%esp
  80179f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017a2:	50                   	push   %eax
  8017a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017a6:	ff 30                	pushl  (%eax)
  8017a8:	e8 e8 fc ff ff       	call   801495 <dev_lookup>
  8017ad:	83 c4 10             	add    $0x10,%esp
  8017b0:	85 c0                	test   %eax,%eax
  8017b2:	78 22                	js     8017d6 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b7:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017bb:	74 1e                	je     8017db <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8017bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017c0:	8b 52 0c             	mov    0xc(%edx),%edx
  8017c3:	85 d2                	test   %edx,%edx
  8017c5:	74 35                	je     8017fc <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8017c7:	83 ec 04             	sub    $0x4,%esp
  8017ca:	ff 75 10             	pushl  0x10(%ebp)
  8017cd:	ff 75 0c             	pushl  0xc(%ebp)
  8017d0:	50                   	push   %eax
  8017d1:	ff d2                	call   *%edx
  8017d3:	83 c4 10             	add    $0x10,%esp
}
  8017d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017d9:	c9                   	leave  
  8017da:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8017db:	a1 20 44 80 00       	mov    0x804420,%eax
  8017e0:	8b 40 48             	mov    0x48(%eax),%eax
  8017e3:	83 ec 04             	sub    $0x4,%esp
  8017e6:	53                   	push   %ebx
  8017e7:	50                   	push   %eax
  8017e8:	68 d4 2e 80 00       	push   $0x802ed4
  8017ed:	e8 47 ec ff ff       	call   800439 <cprintf>
		return -E_INVAL;
  8017f2:	83 c4 10             	add    $0x10,%esp
  8017f5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017fa:	eb da                	jmp    8017d6 <write+0x55>
		return -E_NOT_SUPP;
  8017fc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801801:	eb d3                	jmp    8017d6 <write+0x55>

00801803 <seek>:

int
seek(int fdnum, off_t offset)
{
  801803:	55                   	push   %ebp
  801804:	89 e5                	mov    %esp,%ebp
  801806:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801809:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80180c:	50                   	push   %eax
  80180d:	ff 75 08             	pushl  0x8(%ebp)
  801810:	e8 30 fc ff ff       	call   801445 <fd_lookup>
  801815:	83 c4 10             	add    $0x10,%esp
  801818:	85 c0                	test   %eax,%eax
  80181a:	78 0e                	js     80182a <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80181c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80181f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801822:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801825:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80182a:	c9                   	leave  
  80182b:	c3                   	ret    

0080182c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80182c:	55                   	push   %ebp
  80182d:	89 e5                	mov    %esp,%ebp
  80182f:	53                   	push   %ebx
  801830:	83 ec 1c             	sub    $0x1c,%esp
  801833:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801836:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801839:	50                   	push   %eax
  80183a:	53                   	push   %ebx
  80183b:	e8 05 fc ff ff       	call   801445 <fd_lookup>
  801840:	83 c4 10             	add    $0x10,%esp
  801843:	85 c0                	test   %eax,%eax
  801845:	78 37                	js     80187e <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801847:	83 ec 08             	sub    $0x8,%esp
  80184a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80184d:	50                   	push   %eax
  80184e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801851:	ff 30                	pushl  (%eax)
  801853:	e8 3d fc ff ff       	call   801495 <dev_lookup>
  801858:	83 c4 10             	add    $0x10,%esp
  80185b:	85 c0                	test   %eax,%eax
  80185d:	78 1f                	js     80187e <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80185f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801862:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801866:	74 1b                	je     801883 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801868:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80186b:	8b 52 18             	mov    0x18(%edx),%edx
  80186e:	85 d2                	test   %edx,%edx
  801870:	74 32                	je     8018a4 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801872:	83 ec 08             	sub    $0x8,%esp
  801875:	ff 75 0c             	pushl  0xc(%ebp)
  801878:	50                   	push   %eax
  801879:	ff d2                	call   *%edx
  80187b:	83 c4 10             	add    $0x10,%esp
}
  80187e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801881:	c9                   	leave  
  801882:	c3                   	ret    
			thisenv->env_id, fdnum);
  801883:	a1 20 44 80 00       	mov    0x804420,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801888:	8b 40 48             	mov    0x48(%eax),%eax
  80188b:	83 ec 04             	sub    $0x4,%esp
  80188e:	53                   	push   %ebx
  80188f:	50                   	push   %eax
  801890:	68 94 2e 80 00       	push   $0x802e94
  801895:	e8 9f eb ff ff       	call   800439 <cprintf>
		return -E_INVAL;
  80189a:	83 c4 10             	add    $0x10,%esp
  80189d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018a2:	eb da                	jmp    80187e <ftruncate+0x52>
		return -E_NOT_SUPP;
  8018a4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018a9:	eb d3                	jmp    80187e <ftruncate+0x52>

008018ab <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8018ab:	55                   	push   %ebp
  8018ac:	89 e5                	mov    %esp,%ebp
  8018ae:	53                   	push   %ebx
  8018af:	83 ec 1c             	sub    $0x1c,%esp
  8018b2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018b5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018b8:	50                   	push   %eax
  8018b9:	ff 75 08             	pushl  0x8(%ebp)
  8018bc:	e8 84 fb ff ff       	call   801445 <fd_lookup>
  8018c1:	83 c4 10             	add    $0x10,%esp
  8018c4:	85 c0                	test   %eax,%eax
  8018c6:	78 4b                	js     801913 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018c8:	83 ec 08             	sub    $0x8,%esp
  8018cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018ce:	50                   	push   %eax
  8018cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018d2:	ff 30                	pushl  (%eax)
  8018d4:	e8 bc fb ff ff       	call   801495 <dev_lookup>
  8018d9:	83 c4 10             	add    $0x10,%esp
  8018dc:	85 c0                	test   %eax,%eax
  8018de:	78 33                	js     801913 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8018e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8018e7:	74 2f                	je     801918 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8018e9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8018ec:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8018f3:	00 00 00 
	stat->st_isdir = 0;
  8018f6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8018fd:	00 00 00 
	stat->st_dev = dev;
  801900:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801906:	83 ec 08             	sub    $0x8,%esp
  801909:	53                   	push   %ebx
  80190a:	ff 75 f0             	pushl  -0x10(%ebp)
  80190d:	ff 50 14             	call   *0x14(%eax)
  801910:	83 c4 10             	add    $0x10,%esp
}
  801913:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801916:	c9                   	leave  
  801917:	c3                   	ret    
		return -E_NOT_SUPP;
  801918:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80191d:	eb f4                	jmp    801913 <fstat+0x68>

0080191f <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80191f:	55                   	push   %ebp
  801920:	89 e5                	mov    %esp,%ebp
  801922:	56                   	push   %esi
  801923:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801924:	83 ec 08             	sub    $0x8,%esp
  801927:	6a 00                	push   $0x0
  801929:	ff 75 08             	pushl  0x8(%ebp)
  80192c:	e8 22 02 00 00       	call   801b53 <open>
  801931:	89 c3                	mov    %eax,%ebx
  801933:	83 c4 10             	add    $0x10,%esp
  801936:	85 c0                	test   %eax,%eax
  801938:	78 1b                	js     801955 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80193a:	83 ec 08             	sub    $0x8,%esp
  80193d:	ff 75 0c             	pushl  0xc(%ebp)
  801940:	50                   	push   %eax
  801941:	e8 65 ff ff ff       	call   8018ab <fstat>
  801946:	89 c6                	mov    %eax,%esi
	close(fd);
  801948:	89 1c 24             	mov    %ebx,(%esp)
  80194b:	e8 27 fc ff ff       	call   801577 <close>
	return r;
  801950:	83 c4 10             	add    $0x10,%esp
  801953:	89 f3                	mov    %esi,%ebx
}
  801955:	89 d8                	mov    %ebx,%eax
  801957:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80195a:	5b                   	pop    %ebx
  80195b:	5e                   	pop    %esi
  80195c:	5d                   	pop    %ebp
  80195d:	c3                   	ret    

0080195e <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80195e:	55                   	push   %ebp
  80195f:	89 e5                	mov    %esp,%ebp
  801961:	56                   	push   %esi
  801962:	53                   	push   %ebx
  801963:	89 c6                	mov    %eax,%esi
  801965:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801967:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80196e:	74 27                	je     801997 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801970:	6a 07                	push   $0x7
  801972:	68 00 50 80 00       	push   $0x805000
  801977:	56                   	push   %esi
  801978:	ff 35 00 40 80 00    	pushl  0x804000
  80197e:	e8 1c 0d 00 00       	call   80269f <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801983:	83 c4 0c             	add    $0xc,%esp
  801986:	6a 00                	push   $0x0
  801988:	53                   	push   %ebx
  801989:	6a 00                	push   $0x0
  80198b:	e8 a6 0c 00 00       	call   802636 <ipc_recv>
}
  801990:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801993:	5b                   	pop    %ebx
  801994:	5e                   	pop    %esi
  801995:	5d                   	pop    %ebp
  801996:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801997:	83 ec 0c             	sub    $0xc,%esp
  80199a:	6a 01                	push   $0x1
  80199c:	e8 56 0d 00 00       	call   8026f7 <ipc_find_env>
  8019a1:	a3 00 40 80 00       	mov    %eax,0x804000
  8019a6:	83 c4 10             	add    $0x10,%esp
  8019a9:	eb c5                	jmp    801970 <fsipc+0x12>

008019ab <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8019ab:	55                   	push   %ebp
  8019ac:	89 e5                	mov    %esp,%ebp
  8019ae:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8019b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8019b7:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8019bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019bf:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8019c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8019c9:	b8 02 00 00 00       	mov    $0x2,%eax
  8019ce:	e8 8b ff ff ff       	call   80195e <fsipc>
}
  8019d3:	c9                   	leave  
  8019d4:	c3                   	ret    

008019d5 <devfile_flush>:
{
  8019d5:	55                   	push   %ebp
  8019d6:	89 e5                	mov    %esp,%ebp
  8019d8:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8019db:	8b 45 08             	mov    0x8(%ebp),%eax
  8019de:	8b 40 0c             	mov    0xc(%eax),%eax
  8019e1:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8019e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8019eb:	b8 06 00 00 00       	mov    $0x6,%eax
  8019f0:	e8 69 ff ff ff       	call   80195e <fsipc>
}
  8019f5:	c9                   	leave  
  8019f6:	c3                   	ret    

008019f7 <devfile_stat>:
{
  8019f7:	55                   	push   %ebp
  8019f8:	89 e5                	mov    %esp,%ebp
  8019fa:	53                   	push   %ebx
  8019fb:	83 ec 04             	sub    $0x4,%esp
  8019fe:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a01:	8b 45 08             	mov    0x8(%ebp),%eax
  801a04:	8b 40 0c             	mov    0xc(%eax),%eax
  801a07:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a0c:	ba 00 00 00 00       	mov    $0x0,%edx
  801a11:	b8 05 00 00 00       	mov    $0x5,%eax
  801a16:	e8 43 ff ff ff       	call   80195e <fsipc>
  801a1b:	85 c0                	test   %eax,%eax
  801a1d:	78 2c                	js     801a4b <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a1f:	83 ec 08             	sub    $0x8,%esp
  801a22:	68 00 50 80 00       	push   $0x805000
  801a27:	53                   	push   %ebx
  801a28:	e8 6b f1 ff ff       	call   800b98 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a2d:	a1 80 50 80 00       	mov    0x805080,%eax
  801a32:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a38:	a1 84 50 80 00       	mov    0x805084,%eax
  801a3d:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a43:	83 c4 10             	add    $0x10,%esp
  801a46:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a4e:	c9                   	leave  
  801a4f:	c3                   	ret    

00801a50 <devfile_write>:
{
  801a50:	55                   	push   %ebp
  801a51:	89 e5                	mov    %esp,%ebp
  801a53:	53                   	push   %ebx
  801a54:	83 ec 08             	sub    $0x8,%esp
  801a57:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5d:	8b 40 0c             	mov    0xc(%eax),%eax
  801a60:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801a65:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801a6b:	53                   	push   %ebx
  801a6c:	ff 75 0c             	pushl  0xc(%ebp)
  801a6f:	68 08 50 80 00       	push   $0x805008
  801a74:	e8 0f f3 ff ff       	call   800d88 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801a79:	ba 00 00 00 00       	mov    $0x0,%edx
  801a7e:	b8 04 00 00 00       	mov    $0x4,%eax
  801a83:	e8 d6 fe ff ff       	call   80195e <fsipc>
  801a88:	83 c4 10             	add    $0x10,%esp
  801a8b:	85 c0                	test   %eax,%eax
  801a8d:	78 0b                	js     801a9a <devfile_write+0x4a>
	assert(r <= n);
  801a8f:	39 d8                	cmp    %ebx,%eax
  801a91:	77 0c                	ja     801a9f <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801a93:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a98:	7f 1e                	jg     801ab8 <devfile_write+0x68>
}
  801a9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a9d:	c9                   	leave  
  801a9e:	c3                   	ret    
	assert(r <= n);
  801a9f:	68 08 2f 80 00       	push   $0x802f08
  801aa4:	68 0f 2f 80 00       	push   $0x802f0f
  801aa9:	68 98 00 00 00       	push   $0x98
  801aae:	68 24 2f 80 00       	push   $0x802f24
  801ab3:	e8 8b e8 ff ff       	call   800343 <_panic>
	assert(r <= PGSIZE);
  801ab8:	68 2f 2f 80 00       	push   $0x802f2f
  801abd:	68 0f 2f 80 00       	push   $0x802f0f
  801ac2:	68 99 00 00 00       	push   $0x99
  801ac7:	68 24 2f 80 00       	push   $0x802f24
  801acc:	e8 72 e8 ff ff       	call   800343 <_panic>

00801ad1 <devfile_read>:
{
  801ad1:	55                   	push   %ebp
  801ad2:	89 e5                	mov    %esp,%ebp
  801ad4:	56                   	push   %esi
  801ad5:	53                   	push   %ebx
  801ad6:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  801adc:	8b 40 0c             	mov    0xc(%eax),%eax
  801adf:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801ae4:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801aea:	ba 00 00 00 00       	mov    $0x0,%edx
  801aef:	b8 03 00 00 00       	mov    $0x3,%eax
  801af4:	e8 65 fe ff ff       	call   80195e <fsipc>
  801af9:	89 c3                	mov    %eax,%ebx
  801afb:	85 c0                	test   %eax,%eax
  801afd:	78 1f                	js     801b1e <devfile_read+0x4d>
	assert(r <= n);
  801aff:	39 f0                	cmp    %esi,%eax
  801b01:	77 24                	ja     801b27 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801b03:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b08:	7f 33                	jg     801b3d <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801b0a:	83 ec 04             	sub    $0x4,%esp
  801b0d:	50                   	push   %eax
  801b0e:	68 00 50 80 00       	push   $0x805000
  801b13:	ff 75 0c             	pushl  0xc(%ebp)
  801b16:	e8 0b f2 ff ff       	call   800d26 <memmove>
	return r;
  801b1b:	83 c4 10             	add    $0x10,%esp
}
  801b1e:	89 d8                	mov    %ebx,%eax
  801b20:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b23:	5b                   	pop    %ebx
  801b24:	5e                   	pop    %esi
  801b25:	5d                   	pop    %ebp
  801b26:	c3                   	ret    
	assert(r <= n);
  801b27:	68 08 2f 80 00       	push   $0x802f08
  801b2c:	68 0f 2f 80 00       	push   $0x802f0f
  801b31:	6a 7c                	push   $0x7c
  801b33:	68 24 2f 80 00       	push   $0x802f24
  801b38:	e8 06 e8 ff ff       	call   800343 <_panic>
	assert(r <= PGSIZE);
  801b3d:	68 2f 2f 80 00       	push   $0x802f2f
  801b42:	68 0f 2f 80 00       	push   $0x802f0f
  801b47:	6a 7d                	push   $0x7d
  801b49:	68 24 2f 80 00       	push   $0x802f24
  801b4e:	e8 f0 e7 ff ff       	call   800343 <_panic>

00801b53 <open>:
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
  801b56:	56                   	push   %esi
  801b57:	53                   	push   %ebx
  801b58:	83 ec 1c             	sub    $0x1c,%esp
  801b5b:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801b5e:	56                   	push   %esi
  801b5f:	e8 fb ef ff ff       	call   800b5f <strlen>
  801b64:	83 c4 10             	add    $0x10,%esp
  801b67:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b6c:	7f 6c                	jg     801bda <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801b6e:	83 ec 0c             	sub    $0xc,%esp
  801b71:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b74:	50                   	push   %eax
  801b75:	e8 79 f8 ff ff       	call   8013f3 <fd_alloc>
  801b7a:	89 c3                	mov    %eax,%ebx
  801b7c:	83 c4 10             	add    $0x10,%esp
  801b7f:	85 c0                	test   %eax,%eax
  801b81:	78 3c                	js     801bbf <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801b83:	83 ec 08             	sub    $0x8,%esp
  801b86:	56                   	push   %esi
  801b87:	68 00 50 80 00       	push   $0x805000
  801b8c:	e8 07 f0 ff ff       	call   800b98 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b91:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b94:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b99:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b9c:	b8 01 00 00 00       	mov    $0x1,%eax
  801ba1:	e8 b8 fd ff ff       	call   80195e <fsipc>
  801ba6:	89 c3                	mov    %eax,%ebx
  801ba8:	83 c4 10             	add    $0x10,%esp
  801bab:	85 c0                	test   %eax,%eax
  801bad:	78 19                	js     801bc8 <open+0x75>
	return fd2num(fd);
  801baf:	83 ec 0c             	sub    $0xc,%esp
  801bb2:	ff 75 f4             	pushl  -0xc(%ebp)
  801bb5:	e8 12 f8 ff ff       	call   8013cc <fd2num>
  801bba:	89 c3                	mov    %eax,%ebx
  801bbc:	83 c4 10             	add    $0x10,%esp
}
  801bbf:	89 d8                	mov    %ebx,%eax
  801bc1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bc4:	5b                   	pop    %ebx
  801bc5:	5e                   	pop    %esi
  801bc6:	5d                   	pop    %ebp
  801bc7:	c3                   	ret    
		fd_close(fd, 0);
  801bc8:	83 ec 08             	sub    $0x8,%esp
  801bcb:	6a 00                	push   $0x0
  801bcd:	ff 75 f4             	pushl  -0xc(%ebp)
  801bd0:	e8 1b f9 ff ff       	call   8014f0 <fd_close>
		return r;
  801bd5:	83 c4 10             	add    $0x10,%esp
  801bd8:	eb e5                	jmp    801bbf <open+0x6c>
		return -E_BAD_PATH;
  801bda:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801bdf:	eb de                	jmp    801bbf <open+0x6c>

00801be1 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801be1:	55                   	push   %ebp
  801be2:	89 e5                	mov    %esp,%ebp
  801be4:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801be7:	ba 00 00 00 00       	mov    $0x0,%edx
  801bec:	b8 08 00 00 00       	mov    $0x8,%eax
  801bf1:	e8 68 fd ff ff       	call   80195e <fsipc>
}
  801bf6:	c9                   	leave  
  801bf7:	c3                   	ret    

00801bf8 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  801bf8:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801bfc:	7f 01                	jg     801bff <writebuf+0x7>
  801bfe:	c3                   	ret    
{
  801bff:	55                   	push   %ebp
  801c00:	89 e5                	mov    %esp,%ebp
  801c02:	53                   	push   %ebx
  801c03:	83 ec 08             	sub    $0x8,%esp
  801c06:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  801c08:	ff 70 04             	pushl  0x4(%eax)
  801c0b:	8d 40 10             	lea    0x10(%eax),%eax
  801c0e:	50                   	push   %eax
  801c0f:	ff 33                	pushl  (%ebx)
  801c11:	e8 6b fb ff ff       	call   801781 <write>
		if (result > 0)
  801c16:	83 c4 10             	add    $0x10,%esp
  801c19:	85 c0                	test   %eax,%eax
  801c1b:	7e 03                	jle    801c20 <writebuf+0x28>
			b->result += result;
  801c1d:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801c20:	39 43 04             	cmp    %eax,0x4(%ebx)
  801c23:	74 0d                	je     801c32 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  801c25:	85 c0                	test   %eax,%eax
  801c27:	ba 00 00 00 00       	mov    $0x0,%edx
  801c2c:	0f 4f c2             	cmovg  %edx,%eax
  801c2f:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801c32:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c35:	c9                   	leave  
  801c36:	c3                   	ret    

00801c37 <putch>:

static void
putch(int ch, void *thunk)
{
  801c37:	55                   	push   %ebp
  801c38:	89 e5                	mov    %esp,%ebp
  801c3a:	53                   	push   %ebx
  801c3b:	83 ec 04             	sub    $0x4,%esp
  801c3e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801c41:	8b 53 04             	mov    0x4(%ebx),%edx
  801c44:	8d 42 01             	lea    0x1(%edx),%eax
  801c47:	89 43 04             	mov    %eax,0x4(%ebx)
  801c4a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c4d:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801c51:	3d 00 01 00 00       	cmp    $0x100,%eax
  801c56:	74 06                	je     801c5e <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  801c58:	83 c4 04             	add    $0x4,%esp
  801c5b:	5b                   	pop    %ebx
  801c5c:	5d                   	pop    %ebp
  801c5d:	c3                   	ret    
		writebuf(b);
  801c5e:	89 d8                	mov    %ebx,%eax
  801c60:	e8 93 ff ff ff       	call   801bf8 <writebuf>
		b->idx = 0;
  801c65:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  801c6c:	eb ea                	jmp    801c58 <putch+0x21>

00801c6e <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801c6e:	55                   	push   %ebp
  801c6f:	89 e5                	mov    %esp,%ebp
  801c71:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801c77:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7a:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801c80:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801c87:	00 00 00 
	b.result = 0;
  801c8a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801c91:	00 00 00 
	b.error = 1;
  801c94:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801c9b:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801c9e:	ff 75 10             	pushl  0x10(%ebp)
  801ca1:	ff 75 0c             	pushl  0xc(%ebp)
  801ca4:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801caa:	50                   	push   %eax
  801cab:	68 37 1c 80 00       	push   $0x801c37
  801cb0:	e8 b1 e8 ff ff       	call   800566 <vprintfmt>
	if (b.idx > 0)
  801cb5:	83 c4 10             	add    $0x10,%esp
  801cb8:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801cbf:	7f 11                	jg     801cd2 <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  801cc1:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801cc7:	85 c0                	test   %eax,%eax
  801cc9:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801cd0:	c9                   	leave  
  801cd1:	c3                   	ret    
		writebuf(&b);
  801cd2:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801cd8:	e8 1b ff ff ff       	call   801bf8 <writebuf>
  801cdd:	eb e2                	jmp    801cc1 <vfprintf+0x53>

00801cdf <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801cdf:	55                   	push   %ebp
  801ce0:	89 e5                	mov    %esp,%ebp
  801ce2:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801ce5:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801ce8:	50                   	push   %eax
  801ce9:	ff 75 0c             	pushl  0xc(%ebp)
  801cec:	ff 75 08             	pushl  0x8(%ebp)
  801cef:	e8 7a ff ff ff       	call   801c6e <vfprintf>
	va_end(ap);

	return cnt;
}
  801cf4:	c9                   	leave  
  801cf5:	c3                   	ret    

00801cf6 <printf>:

int
printf(const char *fmt, ...)
{
  801cf6:	55                   	push   %ebp
  801cf7:	89 e5                	mov    %esp,%ebp
  801cf9:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801cfc:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801cff:	50                   	push   %eax
  801d00:	ff 75 08             	pushl  0x8(%ebp)
  801d03:	6a 01                	push   $0x1
  801d05:	e8 64 ff ff ff       	call   801c6e <vfprintf>
	va_end(ap);

	return cnt;
}
  801d0a:	c9                   	leave  
  801d0b:	c3                   	ret    

00801d0c <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801d0c:	55                   	push   %ebp
  801d0d:	89 e5                	mov    %esp,%ebp
  801d0f:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801d12:	68 3b 2f 80 00       	push   $0x802f3b
  801d17:	ff 75 0c             	pushl  0xc(%ebp)
  801d1a:	e8 79 ee ff ff       	call   800b98 <strcpy>
	return 0;
}
  801d1f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d24:	c9                   	leave  
  801d25:	c3                   	ret    

00801d26 <devsock_close>:
{
  801d26:	55                   	push   %ebp
  801d27:	89 e5                	mov    %esp,%ebp
  801d29:	53                   	push   %ebx
  801d2a:	83 ec 10             	sub    $0x10,%esp
  801d2d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801d30:	53                   	push   %ebx
  801d31:	e8 00 0a 00 00       	call   802736 <pageref>
  801d36:	83 c4 10             	add    $0x10,%esp
		return 0;
  801d39:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801d3e:	83 f8 01             	cmp    $0x1,%eax
  801d41:	74 07                	je     801d4a <devsock_close+0x24>
}
  801d43:	89 d0                	mov    %edx,%eax
  801d45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d48:	c9                   	leave  
  801d49:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801d4a:	83 ec 0c             	sub    $0xc,%esp
  801d4d:	ff 73 0c             	pushl  0xc(%ebx)
  801d50:	e8 b9 02 00 00       	call   80200e <nsipc_close>
  801d55:	89 c2                	mov    %eax,%edx
  801d57:	83 c4 10             	add    $0x10,%esp
  801d5a:	eb e7                	jmp    801d43 <devsock_close+0x1d>

00801d5c <devsock_write>:
{
  801d5c:	55                   	push   %ebp
  801d5d:	89 e5                	mov    %esp,%ebp
  801d5f:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801d62:	6a 00                	push   $0x0
  801d64:	ff 75 10             	pushl  0x10(%ebp)
  801d67:	ff 75 0c             	pushl  0xc(%ebp)
  801d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6d:	ff 70 0c             	pushl  0xc(%eax)
  801d70:	e8 76 03 00 00       	call   8020eb <nsipc_send>
}
  801d75:	c9                   	leave  
  801d76:	c3                   	ret    

00801d77 <devsock_read>:
{
  801d77:	55                   	push   %ebp
  801d78:	89 e5                	mov    %esp,%ebp
  801d7a:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801d7d:	6a 00                	push   $0x0
  801d7f:	ff 75 10             	pushl  0x10(%ebp)
  801d82:	ff 75 0c             	pushl  0xc(%ebp)
  801d85:	8b 45 08             	mov    0x8(%ebp),%eax
  801d88:	ff 70 0c             	pushl  0xc(%eax)
  801d8b:	e8 ef 02 00 00       	call   80207f <nsipc_recv>
}
  801d90:	c9                   	leave  
  801d91:	c3                   	ret    

00801d92 <fd2sockid>:
{
  801d92:	55                   	push   %ebp
  801d93:	89 e5                	mov    %esp,%ebp
  801d95:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801d98:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801d9b:	52                   	push   %edx
  801d9c:	50                   	push   %eax
  801d9d:	e8 a3 f6 ff ff       	call   801445 <fd_lookup>
  801da2:	83 c4 10             	add    $0x10,%esp
  801da5:	85 c0                	test   %eax,%eax
  801da7:	78 10                	js     801db9 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801da9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dac:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801db2:	39 08                	cmp    %ecx,(%eax)
  801db4:	75 05                	jne    801dbb <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801db6:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801db9:	c9                   	leave  
  801dba:	c3                   	ret    
		return -E_NOT_SUPP;
  801dbb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801dc0:	eb f7                	jmp    801db9 <fd2sockid+0x27>

00801dc2 <alloc_sockfd>:
{
  801dc2:	55                   	push   %ebp
  801dc3:	89 e5                	mov    %esp,%ebp
  801dc5:	56                   	push   %esi
  801dc6:	53                   	push   %ebx
  801dc7:	83 ec 1c             	sub    $0x1c,%esp
  801dca:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801dcc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dcf:	50                   	push   %eax
  801dd0:	e8 1e f6 ff ff       	call   8013f3 <fd_alloc>
  801dd5:	89 c3                	mov    %eax,%ebx
  801dd7:	83 c4 10             	add    $0x10,%esp
  801dda:	85 c0                	test   %eax,%eax
  801ddc:	78 43                	js     801e21 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801dde:	83 ec 04             	sub    $0x4,%esp
  801de1:	68 07 04 00 00       	push   $0x407
  801de6:	ff 75 f4             	pushl  -0xc(%ebp)
  801de9:	6a 00                	push   $0x0
  801deb:	e8 9a f1 ff ff       	call   800f8a <sys_page_alloc>
  801df0:	89 c3                	mov    %eax,%ebx
  801df2:	83 c4 10             	add    $0x10,%esp
  801df5:	85 c0                	test   %eax,%eax
  801df7:	78 28                	js     801e21 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801df9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dfc:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801e02:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801e04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e07:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801e0e:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801e11:	83 ec 0c             	sub    $0xc,%esp
  801e14:	50                   	push   %eax
  801e15:	e8 b2 f5 ff ff       	call   8013cc <fd2num>
  801e1a:	89 c3                	mov    %eax,%ebx
  801e1c:	83 c4 10             	add    $0x10,%esp
  801e1f:	eb 0c                	jmp    801e2d <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801e21:	83 ec 0c             	sub    $0xc,%esp
  801e24:	56                   	push   %esi
  801e25:	e8 e4 01 00 00       	call   80200e <nsipc_close>
		return r;
  801e2a:	83 c4 10             	add    $0x10,%esp
}
  801e2d:	89 d8                	mov    %ebx,%eax
  801e2f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e32:	5b                   	pop    %ebx
  801e33:	5e                   	pop    %esi
  801e34:	5d                   	pop    %ebp
  801e35:	c3                   	ret    

00801e36 <accept>:
{
  801e36:	55                   	push   %ebp
  801e37:	89 e5                	mov    %esp,%ebp
  801e39:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3f:	e8 4e ff ff ff       	call   801d92 <fd2sockid>
  801e44:	85 c0                	test   %eax,%eax
  801e46:	78 1b                	js     801e63 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801e48:	83 ec 04             	sub    $0x4,%esp
  801e4b:	ff 75 10             	pushl  0x10(%ebp)
  801e4e:	ff 75 0c             	pushl  0xc(%ebp)
  801e51:	50                   	push   %eax
  801e52:	e8 0e 01 00 00       	call   801f65 <nsipc_accept>
  801e57:	83 c4 10             	add    $0x10,%esp
  801e5a:	85 c0                	test   %eax,%eax
  801e5c:	78 05                	js     801e63 <accept+0x2d>
	return alloc_sockfd(r);
  801e5e:	e8 5f ff ff ff       	call   801dc2 <alloc_sockfd>
}
  801e63:	c9                   	leave  
  801e64:	c3                   	ret    

00801e65 <bind>:
{
  801e65:	55                   	push   %ebp
  801e66:	89 e5                	mov    %esp,%ebp
  801e68:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6e:	e8 1f ff ff ff       	call   801d92 <fd2sockid>
  801e73:	85 c0                	test   %eax,%eax
  801e75:	78 12                	js     801e89 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801e77:	83 ec 04             	sub    $0x4,%esp
  801e7a:	ff 75 10             	pushl  0x10(%ebp)
  801e7d:	ff 75 0c             	pushl  0xc(%ebp)
  801e80:	50                   	push   %eax
  801e81:	e8 31 01 00 00       	call   801fb7 <nsipc_bind>
  801e86:	83 c4 10             	add    $0x10,%esp
}
  801e89:	c9                   	leave  
  801e8a:	c3                   	ret    

00801e8b <shutdown>:
{
  801e8b:	55                   	push   %ebp
  801e8c:	89 e5                	mov    %esp,%ebp
  801e8e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e91:	8b 45 08             	mov    0x8(%ebp),%eax
  801e94:	e8 f9 fe ff ff       	call   801d92 <fd2sockid>
  801e99:	85 c0                	test   %eax,%eax
  801e9b:	78 0f                	js     801eac <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801e9d:	83 ec 08             	sub    $0x8,%esp
  801ea0:	ff 75 0c             	pushl  0xc(%ebp)
  801ea3:	50                   	push   %eax
  801ea4:	e8 43 01 00 00       	call   801fec <nsipc_shutdown>
  801ea9:	83 c4 10             	add    $0x10,%esp
}
  801eac:	c9                   	leave  
  801ead:	c3                   	ret    

00801eae <connect>:
{
  801eae:	55                   	push   %ebp
  801eaf:	89 e5                	mov    %esp,%ebp
  801eb1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb7:	e8 d6 fe ff ff       	call   801d92 <fd2sockid>
  801ebc:	85 c0                	test   %eax,%eax
  801ebe:	78 12                	js     801ed2 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801ec0:	83 ec 04             	sub    $0x4,%esp
  801ec3:	ff 75 10             	pushl  0x10(%ebp)
  801ec6:	ff 75 0c             	pushl  0xc(%ebp)
  801ec9:	50                   	push   %eax
  801eca:	e8 59 01 00 00       	call   802028 <nsipc_connect>
  801ecf:	83 c4 10             	add    $0x10,%esp
}
  801ed2:	c9                   	leave  
  801ed3:	c3                   	ret    

00801ed4 <listen>:
{
  801ed4:	55                   	push   %ebp
  801ed5:	89 e5                	mov    %esp,%ebp
  801ed7:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801eda:	8b 45 08             	mov    0x8(%ebp),%eax
  801edd:	e8 b0 fe ff ff       	call   801d92 <fd2sockid>
  801ee2:	85 c0                	test   %eax,%eax
  801ee4:	78 0f                	js     801ef5 <listen+0x21>
	return nsipc_listen(r, backlog);
  801ee6:	83 ec 08             	sub    $0x8,%esp
  801ee9:	ff 75 0c             	pushl  0xc(%ebp)
  801eec:	50                   	push   %eax
  801eed:	e8 6b 01 00 00       	call   80205d <nsipc_listen>
  801ef2:	83 c4 10             	add    $0x10,%esp
}
  801ef5:	c9                   	leave  
  801ef6:	c3                   	ret    

00801ef7 <socket>:

int
socket(int domain, int type, int protocol)
{
  801ef7:	55                   	push   %ebp
  801ef8:	89 e5                	mov    %esp,%ebp
  801efa:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801efd:	ff 75 10             	pushl  0x10(%ebp)
  801f00:	ff 75 0c             	pushl  0xc(%ebp)
  801f03:	ff 75 08             	pushl  0x8(%ebp)
  801f06:	e8 3e 02 00 00       	call   802149 <nsipc_socket>
  801f0b:	83 c4 10             	add    $0x10,%esp
  801f0e:	85 c0                	test   %eax,%eax
  801f10:	78 05                	js     801f17 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801f12:	e8 ab fe ff ff       	call   801dc2 <alloc_sockfd>
}
  801f17:	c9                   	leave  
  801f18:	c3                   	ret    

00801f19 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801f19:	55                   	push   %ebp
  801f1a:	89 e5                	mov    %esp,%ebp
  801f1c:	53                   	push   %ebx
  801f1d:	83 ec 04             	sub    $0x4,%esp
  801f20:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801f22:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801f29:	74 26                	je     801f51 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801f2b:	6a 07                	push   $0x7
  801f2d:	68 00 60 80 00       	push   $0x806000
  801f32:	53                   	push   %ebx
  801f33:	ff 35 04 40 80 00    	pushl  0x804004
  801f39:	e8 61 07 00 00       	call   80269f <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801f3e:	83 c4 0c             	add    $0xc,%esp
  801f41:	6a 00                	push   $0x0
  801f43:	6a 00                	push   $0x0
  801f45:	6a 00                	push   $0x0
  801f47:	e8 ea 06 00 00       	call   802636 <ipc_recv>
}
  801f4c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f4f:	c9                   	leave  
  801f50:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801f51:	83 ec 0c             	sub    $0xc,%esp
  801f54:	6a 02                	push   $0x2
  801f56:	e8 9c 07 00 00       	call   8026f7 <ipc_find_env>
  801f5b:	a3 04 40 80 00       	mov    %eax,0x804004
  801f60:	83 c4 10             	add    $0x10,%esp
  801f63:	eb c6                	jmp    801f2b <nsipc+0x12>

00801f65 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801f65:	55                   	push   %ebp
  801f66:	89 e5                	mov    %esp,%ebp
  801f68:	56                   	push   %esi
  801f69:	53                   	push   %ebx
  801f6a:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f70:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801f75:	8b 06                	mov    (%esi),%eax
  801f77:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801f7c:	b8 01 00 00 00       	mov    $0x1,%eax
  801f81:	e8 93 ff ff ff       	call   801f19 <nsipc>
  801f86:	89 c3                	mov    %eax,%ebx
  801f88:	85 c0                	test   %eax,%eax
  801f8a:	79 09                	jns    801f95 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801f8c:	89 d8                	mov    %ebx,%eax
  801f8e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f91:	5b                   	pop    %ebx
  801f92:	5e                   	pop    %esi
  801f93:	5d                   	pop    %ebp
  801f94:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801f95:	83 ec 04             	sub    $0x4,%esp
  801f98:	ff 35 10 60 80 00    	pushl  0x806010
  801f9e:	68 00 60 80 00       	push   $0x806000
  801fa3:	ff 75 0c             	pushl  0xc(%ebp)
  801fa6:	e8 7b ed ff ff       	call   800d26 <memmove>
		*addrlen = ret->ret_addrlen;
  801fab:	a1 10 60 80 00       	mov    0x806010,%eax
  801fb0:	89 06                	mov    %eax,(%esi)
  801fb2:	83 c4 10             	add    $0x10,%esp
	return r;
  801fb5:	eb d5                	jmp    801f8c <nsipc_accept+0x27>

00801fb7 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801fb7:	55                   	push   %ebp
  801fb8:	89 e5                	mov    %esp,%ebp
  801fba:	53                   	push   %ebx
  801fbb:	83 ec 08             	sub    $0x8,%esp
  801fbe:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc4:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801fc9:	53                   	push   %ebx
  801fca:	ff 75 0c             	pushl  0xc(%ebp)
  801fcd:	68 04 60 80 00       	push   $0x806004
  801fd2:	e8 4f ed ff ff       	call   800d26 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801fd7:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801fdd:	b8 02 00 00 00       	mov    $0x2,%eax
  801fe2:	e8 32 ff ff ff       	call   801f19 <nsipc>
}
  801fe7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fea:	c9                   	leave  
  801feb:	c3                   	ret    

00801fec <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801fec:	55                   	push   %ebp
  801fed:	89 e5                	mov    %esp,%ebp
  801fef:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff5:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801ffa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ffd:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  802002:	b8 03 00 00 00       	mov    $0x3,%eax
  802007:	e8 0d ff ff ff       	call   801f19 <nsipc>
}
  80200c:	c9                   	leave  
  80200d:	c3                   	ret    

0080200e <nsipc_close>:

int
nsipc_close(int s)
{
  80200e:	55                   	push   %ebp
  80200f:	89 e5                	mov    %esp,%ebp
  802011:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802014:	8b 45 08             	mov    0x8(%ebp),%eax
  802017:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  80201c:	b8 04 00 00 00       	mov    $0x4,%eax
  802021:	e8 f3 fe ff ff       	call   801f19 <nsipc>
}
  802026:	c9                   	leave  
  802027:	c3                   	ret    

00802028 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802028:	55                   	push   %ebp
  802029:	89 e5                	mov    %esp,%ebp
  80202b:	53                   	push   %ebx
  80202c:	83 ec 08             	sub    $0x8,%esp
  80202f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802032:	8b 45 08             	mov    0x8(%ebp),%eax
  802035:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80203a:	53                   	push   %ebx
  80203b:	ff 75 0c             	pushl  0xc(%ebp)
  80203e:	68 04 60 80 00       	push   $0x806004
  802043:	e8 de ec ff ff       	call   800d26 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802048:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  80204e:	b8 05 00 00 00       	mov    $0x5,%eax
  802053:	e8 c1 fe ff ff       	call   801f19 <nsipc>
}
  802058:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80205b:	c9                   	leave  
  80205c:	c3                   	ret    

0080205d <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80205d:	55                   	push   %ebp
  80205e:	89 e5                	mov    %esp,%ebp
  802060:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802063:	8b 45 08             	mov    0x8(%ebp),%eax
  802066:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  80206b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80206e:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  802073:	b8 06 00 00 00       	mov    $0x6,%eax
  802078:	e8 9c fe ff ff       	call   801f19 <nsipc>
}
  80207d:	c9                   	leave  
  80207e:	c3                   	ret    

0080207f <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80207f:	55                   	push   %ebp
  802080:	89 e5                	mov    %esp,%ebp
  802082:	56                   	push   %esi
  802083:	53                   	push   %ebx
  802084:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802087:	8b 45 08             	mov    0x8(%ebp),%eax
  80208a:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  80208f:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  802095:	8b 45 14             	mov    0x14(%ebp),%eax
  802098:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80209d:	b8 07 00 00 00       	mov    $0x7,%eax
  8020a2:	e8 72 fe ff ff       	call   801f19 <nsipc>
  8020a7:	89 c3                	mov    %eax,%ebx
  8020a9:	85 c0                	test   %eax,%eax
  8020ab:	78 1f                	js     8020cc <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8020ad:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8020b2:	7f 21                	jg     8020d5 <nsipc_recv+0x56>
  8020b4:	39 c6                	cmp    %eax,%esi
  8020b6:	7c 1d                	jl     8020d5 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8020b8:	83 ec 04             	sub    $0x4,%esp
  8020bb:	50                   	push   %eax
  8020bc:	68 00 60 80 00       	push   $0x806000
  8020c1:	ff 75 0c             	pushl  0xc(%ebp)
  8020c4:	e8 5d ec ff ff       	call   800d26 <memmove>
  8020c9:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8020cc:	89 d8                	mov    %ebx,%eax
  8020ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020d1:	5b                   	pop    %ebx
  8020d2:	5e                   	pop    %esi
  8020d3:	5d                   	pop    %ebp
  8020d4:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8020d5:	68 47 2f 80 00       	push   $0x802f47
  8020da:	68 0f 2f 80 00       	push   $0x802f0f
  8020df:	6a 62                	push   $0x62
  8020e1:	68 5c 2f 80 00       	push   $0x802f5c
  8020e6:	e8 58 e2 ff ff       	call   800343 <_panic>

008020eb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8020eb:	55                   	push   %ebp
  8020ec:	89 e5                	mov    %esp,%ebp
  8020ee:	53                   	push   %ebx
  8020ef:	83 ec 04             	sub    $0x4,%esp
  8020f2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8020f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f8:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8020fd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802103:	7f 2e                	jg     802133 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802105:	83 ec 04             	sub    $0x4,%esp
  802108:	53                   	push   %ebx
  802109:	ff 75 0c             	pushl  0xc(%ebp)
  80210c:	68 0c 60 80 00       	push   $0x80600c
  802111:	e8 10 ec ff ff       	call   800d26 <memmove>
	nsipcbuf.send.req_size = size;
  802116:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  80211c:	8b 45 14             	mov    0x14(%ebp),%eax
  80211f:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  802124:	b8 08 00 00 00       	mov    $0x8,%eax
  802129:	e8 eb fd ff ff       	call   801f19 <nsipc>
}
  80212e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802131:	c9                   	leave  
  802132:	c3                   	ret    
	assert(size < 1600);
  802133:	68 68 2f 80 00       	push   $0x802f68
  802138:	68 0f 2f 80 00       	push   $0x802f0f
  80213d:	6a 6d                	push   $0x6d
  80213f:	68 5c 2f 80 00       	push   $0x802f5c
  802144:	e8 fa e1 ff ff       	call   800343 <_panic>

00802149 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802149:	55                   	push   %ebp
  80214a:	89 e5                	mov    %esp,%ebp
  80214c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80214f:	8b 45 08             	mov    0x8(%ebp),%eax
  802152:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  802157:	8b 45 0c             	mov    0xc(%ebp),%eax
  80215a:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  80215f:	8b 45 10             	mov    0x10(%ebp),%eax
  802162:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  802167:	b8 09 00 00 00       	mov    $0x9,%eax
  80216c:	e8 a8 fd ff ff       	call   801f19 <nsipc>
}
  802171:	c9                   	leave  
  802172:	c3                   	ret    

00802173 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802173:	55                   	push   %ebp
  802174:	89 e5                	mov    %esp,%ebp
  802176:	56                   	push   %esi
  802177:	53                   	push   %ebx
  802178:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80217b:	83 ec 0c             	sub    $0xc,%esp
  80217e:	ff 75 08             	pushl  0x8(%ebp)
  802181:	e8 56 f2 ff ff       	call   8013dc <fd2data>
  802186:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802188:	83 c4 08             	add    $0x8,%esp
  80218b:	68 74 2f 80 00       	push   $0x802f74
  802190:	53                   	push   %ebx
  802191:	e8 02 ea ff ff       	call   800b98 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802196:	8b 46 04             	mov    0x4(%esi),%eax
  802199:	2b 06                	sub    (%esi),%eax
  80219b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8021a1:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8021a8:	00 00 00 
	stat->st_dev = &devpipe;
  8021ab:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  8021b2:	30 80 00 
	return 0;
}
  8021b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ba:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021bd:	5b                   	pop    %ebx
  8021be:	5e                   	pop    %esi
  8021bf:	5d                   	pop    %ebp
  8021c0:	c3                   	ret    

008021c1 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8021c1:	55                   	push   %ebp
  8021c2:	89 e5                	mov    %esp,%ebp
  8021c4:	53                   	push   %ebx
  8021c5:	83 ec 0c             	sub    $0xc,%esp
  8021c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8021cb:	53                   	push   %ebx
  8021cc:	6a 00                	push   $0x0
  8021ce:	e8 3c ee ff ff       	call   80100f <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8021d3:	89 1c 24             	mov    %ebx,(%esp)
  8021d6:	e8 01 f2 ff ff       	call   8013dc <fd2data>
  8021db:	83 c4 08             	add    $0x8,%esp
  8021de:	50                   	push   %eax
  8021df:	6a 00                	push   $0x0
  8021e1:	e8 29 ee ff ff       	call   80100f <sys_page_unmap>
}
  8021e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021e9:	c9                   	leave  
  8021ea:	c3                   	ret    

008021eb <_pipeisclosed>:
{
  8021eb:	55                   	push   %ebp
  8021ec:	89 e5                	mov    %esp,%ebp
  8021ee:	57                   	push   %edi
  8021ef:	56                   	push   %esi
  8021f0:	53                   	push   %ebx
  8021f1:	83 ec 1c             	sub    $0x1c,%esp
  8021f4:	89 c7                	mov    %eax,%edi
  8021f6:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8021f8:	a1 20 44 80 00       	mov    0x804420,%eax
  8021fd:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802200:	83 ec 0c             	sub    $0xc,%esp
  802203:	57                   	push   %edi
  802204:	e8 2d 05 00 00       	call   802736 <pageref>
  802209:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80220c:	89 34 24             	mov    %esi,(%esp)
  80220f:	e8 22 05 00 00       	call   802736 <pageref>
		nn = thisenv->env_runs;
  802214:	8b 15 20 44 80 00    	mov    0x804420,%edx
  80221a:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80221d:	83 c4 10             	add    $0x10,%esp
  802220:	39 cb                	cmp    %ecx,%ebx
  802222:	74 1b                	je     80223f <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802224:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802227:	75 cf                	jne    8021f8 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802229:	8b 42 58             	mov    0x58(%edx),%eax
  80222c:	6a 01                	push   $0x1
  80222e:	50                   	push   %eax
  80222f:	53                   	push   %ebx
  802230:	68 7b 2f 80 00       	push   $0x802f7b
  802235:	e8 ff e1 ff ff       	call   800439 <cprintf>
  80223a:	83 c4 10             	add    $0x10,%esp
  80223d:	eb b9                	jmp    8021f8 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80223f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802242:	0f 94 c0             	sete   %al
  802245:	0f b6 c0             	movzbl %al,%eax
}
  802248:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80224b:	5b                   	pop    %ebx
  80224c:	5e                   	pop    %esi
  80224d:	5f                   	pop    %edi
  80224e:	5d                   	pop    %ebp
  80224f:	c3                   	ret    

00802250 <devpipe_write>:
{
  802250:	55                   	push   %ebp
  802251:	89 e5                	mov    %esp,%ebp
  802253:	57                   	push   %edi
  802254:	56                   	push   %esi
  802255:	53                   	push   %ebx
  802256:	83 ec 28             	sub    $0x28,%esp
  802259:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80225c:	56                   	push   %esi
  80225d:	e8 7a f1 ff ff       	call   8013dc <fd2data>
  802262:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802264:	83 c4 10             	add    $0x10,%esp
  802267:	bf 00 00 00 00       	mov    $0x0,%edi
  80226c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80226f:	74 4f                	je     8022c0 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802271:	8b 43 04             	mov    0x4(%ebx),%eax
  802274:	8b 0b                	mov    (%ebx),%ecx
  802276:	8d 51 20             	lea    0x20(%ecx),%edx
  802279:	39 d0                	cmp    %edx,%eax
  80227b:	72 14                	jb     802291 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80227d:	89 da                	mov    %ebx,%edx
  80227f:	89 f0                	mov    %esi,%eax
  802281:	e8 65 ff ff ff       	call   8021eb <_pipeisclosed>
  802286:	85 c0                	test   %eax,%eax
  802288:	75 3b                	jne    8022c5 <devpipe_write+0x75>
			sys_yield();
  80228a:	e8 dc ec ff ff       	call   800f6b <sys_yield>
  80228f:	eb e0                	jmp    802271 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802291:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802294:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802298:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80229b:	89 c2                	mov    %eax,%edx
  80229d:	c1 fa 1f             	sar    $0x1f,%edx
  8022a0:	89 d1                	mov    %edx,%ecx
  8022a2:	c1 e9 1b             	shr    $0x1b,%ecx
  8022a5:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8022a8:	83 e2 1f             	and    $0x1f,%edx
  8022ab:	29 ca                	sub    %ecx,%edx
  8022ad:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8022b1:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8022b5:	83 c0 01             	add    $0x1,%eax
  8022b8:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8022bb:	83 c7 01             	add    $0x1,%edi
  8022be:	eb ac                	jmp    80226c <devpipe_write+0x1c>
	return i;
  8022c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8022c3:	eb 05                	jmp    8022ca <devpipe_write+0x7a>
				return 0;
  8022c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022cd:	5b                   	pop    %ebx
  8022ce:	5e                   	pop    %esi
  8022cf:	5f                   	pop    %edi
  8022d0:	5d                   	pop    %ebp
  8022d1:	c3                   	ret    

008022d2 <devpipe_read>:
{
  8022d2:	55                   	push   %ebp
  8022d3:	89 e5                	mov    %esp,%ebp
  8022d5:	57                   	push   %edi
  8022d6:	56                   	push   %esi
  8022d7:	53                   	push   %ebx
  8022d8:	83 ec 18             	sub    $0x18,%esp
  8022db:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8022de:	57                   	push   %edi
  8022df:	e8 f8 f0 ff ff       	call   8013dc <fd2data>
  8022e4:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8022e6:	83 c4 10             	add    $0x10,%esp
  8022e9:	be 00 00 00 00       	mov    $0x0,%esi
  8022ee:	3b 75 10             	cmp    0x10(%ebp),%esi
  8022f1:	75 14                	jne    802307 <devpipe_read+0x35>
	return i;
  8022f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8022f6:	eb 02                	jmp    8022fa <devpipe_read+0x28>
				return i;
  8022f8:	89 f0                	mov    %esi,%eax
}
  8022fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022fd:	5b                   	pop    %ebx
  8022fe:	5e                   	pop    %esi
  8022ff:	5f                   	pop    %edi
  802300:	5d                   	pop    %ebp
  802301:	c3                   	ret    
			sys_yield();
  802302:	e8 64 ec ff ff       	call   800f6b <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802307:	8b 03                	mov    (%ebx),%eax
  802309:	3b 43 04             	cmp    0x4(%ebx),%eax
  80230c:	75 18                	jne    802326 <devpipe_read+0x54>
			if (i > 0)
  80230e:	85 f6                	test   %esi,%esi
  802310:	75 e6                	jne    8022f8 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802312:	89 da                	mov    %ebx,%edx
  802314:	89 f8                	mov    %edi,%eax
  802316:	e8 d0 fe ff ff       	call   8021eb <_pipeisclosed>
  80231b:	85 c0                	test   %eax,%eax
  80231d:	74 e3                	je     802302 <devpipe_read+0x30>
				return 0;
  80231f:	b8 00 00 00 00       	mov    $0x0,%eax
  802324:	eb d4                	jmp    8022fa <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802326:	99                   	cltd   
  802327:	c1 ea 1b             	shr    $0x1b,%edx
  80232a:	01 d0                	add    %edx,%eax
  80232c:	83 e0 1f             	and    $0x1f,%eax
  80232f:	29 d0                	sub    %edx,%eax
  802331:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802336:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802339:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80233c:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80233f:	83 c6 01             	add    $0x1,%esi
  802342:	eb aa                	jmp    8022ee <devpipe_read+0x1c>

00802344 <pipe>:
{
  802344:	55                   	push   %ebp
  802345:	89 e5                	mov    %esp,%ebp
  802347:	56                   	push   %esi
  802348:	53                   	push   %ebx
  802349:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80234c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80234f:	50                   	push   %eax
  802350:	e8 9e f0 ff ff       	call   8013f3 <fd_alloc>
  802355:	89 c3                	mov    %eax,%ebx
  802357:	83 c4 10             	add    $0x10,%esp
  80235a:	85 c0                	test   %eax,%eax
  80235c:	0f 88 23 01 00 00    	js     802485 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802362:	83 ec 04             	sub    $0x4,%esp
  802365:	68 07 04 00 00       	push   $0x407
  80236a:	ff 75 f4             	pushl  -0xc(%ebp)
  80236d:	6a 00                	push   $0x0
  80236f:	e8 16 ec ff ff       	call   800f8a <sys_page_alloc>
  802374:	89 c3                	mov    %eax,%ebx
  802376:	83 c4 10             	add    $0x10,%esp
  802379:	85 c0                	test   %eax,%eax
  80237b:	0f 88 04 01 00 00    	js     802485 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802381:	83 ec 0c             	sub    $0xc,%esp
  802384:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802387:	50                   	push   %eax
  802388:	e8 66 f0 ff ff       	call   8013f3 <fd_alloc>
  80238d:	89 c3                	mov    %eax,%ebx
  80238f:	83 c4 10             	add    $0x10,%esp
  802392:	85 c0                	test   %eax,%eax
  802394:	0f 88 db 00 00 00    	js     802475 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80239a:	83 ec 04             	sub    $0x4,%esp
  80239d:	68 07 04 00 00       	push   $0x407
  8023a2:	ff 75 f0             	pushl  -0x10(%ebp)
  8023a5:	6a 00                	push   $0x0
  8023a7:	e8 de eb ff ff       	call   800f8a <sys_page_alloc>
  8023ac:	89 c3                	mov    %eax,%ebx
  8023ae:	83 c4 10             	add    $0x10,%esp
  8023b1:	85 c0                	test   %eax,%eax
  8023b3:	0f 88 bc 00 00 00    	js     802475 <pipe+0x131>
	va = fd2data(fd0);
  8023b9:	83 ec 0c             	sub    $0xc,%esp
  8023bc:	ff 75 f4             	pushl  -0xc(%ebp)
  8023bf:	e8 18 f0 ff ff       	call   8013dc <fd2data>
  8023c4:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023c6:	83 c4 0c             	add    $0xc,%esp
  8023c9:	68 07 04 00 00       	push   $0x407
  8023ce:	50                   	push   %eax
  8023cf:	6a 00                	push   $0x0
  8023d1:	e8 b4 eb ff ff       	call   800f8a <sys_page_alloc>
  8023d6:	89 c3                	mov    %eax,%ebx
  8023d8:	83 c4 10             	add    $0x10,%esp
  8023db:	85 c0                	test   %eax,%eax
  8023dd:	0f 88 82 00 00 00    	js     802465 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023e3:	83 ec 0c             	sub    $0xc,%esp
  8023e6:	ff 75 f0             	pushl  -0x10(%ebp)
  8023e9:	e8 ee ef ff ff       	call   8013dc <fd2data>
  8023ee:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8023f5:	50                   	push   %eax
  8023f6:	6a 00                	push   $0x0
  8023f8:	56                   	push   %esi
  8023f9:	6a 00                	push   $0x0
  8023fb:	e8 cd eb ff ff       	call   800fcd <sys_page_map>
  802400:	89 c3                	mov    %eax,%ebx
  802402:	83 c4 20             	add    $0x20,%esp
  802405:	85 c0                	test   %eax,%eax
  802407:	78 4e                	js     802457 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802409:	a1 3c 30 80 00       	mov    0x80303c,%eax
  80240e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802411:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802413:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802416:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80241d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802420:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802422:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802425:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80242c:	83 ec 0c             	sub    $0xc,%esp
  80242f:	ff 75 f4             	pushl  -0xc(%ebp)
  802432:	e8 95 ef ff ff       	call   8013cc <fd2num>
  802437:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80243a:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80243c:	83 c4 04             	add    $0x4,%esp
  80243f:	ff 75 f0             	pushl  -0x10(%ebp)
  802442:	e8 85 ef ff ff       	call   8013cc <fd2num>
  802447:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80244a:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80244d:	83 c4 10             	add    $0x10,%esp
  802450:	bb 00 00 00 00       	mov    $0x0,%ebx
  802455:	eb 2e                	jmp    802485 <pipe+0x141>
	sys_page_unmap(0, va);
  802457:	83 ec 08             	sub    $0x8,%esp
  80245a:	56                   	push   %esi
  80245b:	6a 00                	push   $0x0
  80245d:	e8 ad eb ff ff       	call   80100f <sys_page_unmap>
  802462:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802465:	83 ec 08             	sub    $0x8,%esp
  802468:	ff 75 f0             	pushl  -0x10(%ebp)
  80246b:	6a 00                	push   $0x0
  80246d:	e8 9d eb ff ff       	call   80100f <sys_page_unmap>
  802472:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802475:	83 ec 08             	sub    $0x8,%esp
  802478:	ff 75 f4             	pushl  -0xc(%ebp)
  80247b:	6a 00                	push   $0x0
  80247d:	e8 8d eb ff ff       	call   80100f <sys_page_unmap>
  802482:	83 c4 10             	add    $0x10,%esp
}
  802485:	89 d8                	mov    %ebx,%eax
  802487:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80248a:	5b                   	pop    %ebx
  80248b:	5e                   	pop    %esi
  80248c:	5d                   	pop    %ebp
  80248d:	c3                   	ret    

0080248e <pipeisclosed>:
{
  80248e:	55                   	push   %ebp
  80248f:	89 e5                	mov    %esp,%ebp
  802491:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802494:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802497:	50                   	push   %eax
  802498:	ff 75 08             	pushl  0x8(%ebp)
  80249b:	e8 a5 ef ff ff       	call   801445 <fd_lookup>
  8024a0:	83 c4 10             	add    $0x10,%esp
  8024a3:	85 c0                	test   %eax,%eax
  8024a5:	78 18                	js     8024bf <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8024a7:	83 ec 0c             	sub    $0xc,%esp
  8024aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8024ad:	e8 2a ef ff ff       	call   8013dc <fd2data>
	return _pipeisclosed(fd, p);
  8024b2:	89 c2                	mov    %eax,%edx
  8024b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b7:	e8 2f fd ff ff       	call   8021eb <_pipeisclosed>
  8024bc:	83 c4 10             	add    $0x10,%esp
}
  8024bf:	c9                   	leave  
  8024c0:	c3                   	ret    

008024c1 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8024c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8024c6:	c3                   	ret    

008024c7 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8024c7:	55                   	push   %ebp
  8024c8:	89 e5                	mov    %esp,%ebp
  8024ca:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8024cd:	68 93 2f 80 00       	push   $0x802f93
  8024d2:	ff 75 0c             	pushl  0xc(%ebp)
  8024d5:	e8 be e6 ff ff       	call   800b98 <strcpy>
	return 0;
}
  8024da:	b8 00 00 00 00       	mov    $0x0,%eax
  8024df:	c9                   	leave  
  8024e0:	c3                   	ret    

008024e1 <devcons_write>:
{
  8024e1:	55                   	push   %ebp
  8024e2:	89 e5                	mov    %esp,%ebp
  8024e4:	57                   	push   %edi
  8024e5:	56                   	push   %esi
  8024e6:	53                   	push   %ebx
  8024e7:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8024ed:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8024f2:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8024f8:	3b 75 10             	cmp    0x10(%ebp),%esi
  8024fb:	73 31                	jae    80252e <devcons_write+0x4d>
		m = n - tot;
  8024fd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802500:	29 f3                	sub    %esi,%ebx
  802502:	83 fb 7f             	cmp    $0x7f,%ebx
  802505:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80250a:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80250d:	83 ec 04             	sub    $0x4,%esp
  802510:	53                   	push   %ebx
  802511:	89 f0                	mov    %esi,%eax
  802513:	03 45 0c             	add    0xc(%ebp),%eax
  802516:	50                   	push   %eax
  802517:	57                   	push   %edi
  802518:	e8 09 e8 ff ff       	call   800d26 <memmove>
		sys_cputs(buf, m);
  80251d:	83 c4 08             	add    $0x8,%esp
  802520:	53                   	push   %ebx
  802521:	57                   	push   %edi
  802522:	e8 a7 e9 ff ff       	call   800ece <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802527:	01 de                	add    %ebx,%esi
  802529:	83 c4 10             	add    $0x10,%esp
  80252c:	eb ca                	jmp    8024f8 <devcons_write+0x17>
}
  80252e:	89 f0                	mov    %esi,%eax
  802530:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802533:	5b                   	pop    %ebx
  802534:	5e                   	pop    %esi
  802535:	5f                   	pop    %edi
  802536:	5d                   	pop    %ebp
  802537:	c3                   	ret    

00802538 <devcons_read>:
{
  802538:	55                   	push   %ebp
  802539:	89 e5                	mov    %esp,%ebp
  80253b:	83 ec 08             	sub    $0x8,%esp
  80253e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802543:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802547:	74 21                	je     80256a <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802549:	e8 9e e9 ff ff       	call   800eec <sys_cgetc>
  80254e:	85 c0                	test   %eax,%eax
  802550:	75 07                	jne    802559 <devcons_read+0x21>
		sys_yield();
  802552:	e8 14 ea ff ff       	call   800f6b <sys_yield>
  802557:	eb f0                	jmp    802549 <devcons_read+0x11>
	if (c < 0)
  802559:	78 0f                	js     80256a <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80255b:	83 f8 04             	cmp    $0x4,%eax
  80255e:	74 0c                	je     80256c <devcons_read+0x34>
	*(char*)vbuf = c;
  802560:	8b 55 0c             	mov    0xc(%ebp),%edx
  802563:	88 02                	mov    %al,(%edx)
	return 1;
  802565:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80256a:	c9                   	leave  
  80256b:	c3                   	ret    
		return 0;
  80256c:	b8 00 00 00 00       	mov    $0x0,%eax
  802571:	eb f7                	jmp    80256a <devcons_read+0x32>

00802573 <cputchar>:
{
  802573:	55                   	push   %ebp
  802574:	89 e5                	mov    %esp,%ebp
  802576:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802579:	8b 45 08             	mov    0x8(%ebp),%eax
  80257c:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80257f:	6a 01                	push   $0x1
  802581:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802584:	50                   	push   %eax
  802585:	e8 44 e9 ff ff       	call   800ece <sys_cputs>
}
  80258a:	83 c4 10             	add    $0x10,%esp
  80258d:	c9                   	leave  
  80258e:	c3                   	ret    

0080258f <getchar>:
{
  80258f:	55                   	push   %ebp
  802590:	89 e5                	mov    %esp,%ebp
  802592:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802595:	6a 01                	push   $0x1
  802597:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80259a:	50                   	push   %eax
  80259b:	6a 00                	push   $0x0
  80259d:	e8 13 f1 ff ff       	call   8016b5 <read>
	if (r < 0)
  8025a2:	83 c4 10             	add    $0x10,%esp
  8025a5:	85 c0                	test   %eax,%eax
  8025a7:	78 06                	js     8025af <getchar+0x20>
	if (r < 1)
  8025a9:	74 06                	je     8025b1 <getchar+0x22>
	return c;
  8025ab:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8025af:	c9                   	leave  
  8025b0:	c3                   	ret    
		return -E_EOF;
  8025b1:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8025b6:	eb f7                	jmp    8025af <getchar+0x20>

008025b8 <iscons>:
{
  8025b8:	55                   	push   %ebp
  8025b9:	89 e5                	mov    %esp,%ebp
  8025bb:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025be:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025c1:	50                   	push   %eax
  8025c2:	ff 75 08             	pushl  0x8(%ebp)
  8025c5:	e8 7b ee ff ff       	call   801445 <fd_lookup>
  8025ca:	83 c4 10             	add    $0x10,%esp
  8025cd:	85 c0                	test   %eax,%eax
  8025cf:	78 11                	js     8025e2 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8025d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d4:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8025da:	39 10                	cmp    %edx,(%eax)
  8025dc:	0f 94 c0             	sete   %al
  8025df:	0f b6 c0             	movzbl %al,%eax
}
  8025e2:	c9                   	leave  
  8025e3:	c3                   	ret    

008025e4 <opencons>:
{
  8025e4:	55                   	push   %ebp
  8025e5:	89 e5                	mov    %esp,%ebp
  8025e7:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8025ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025ed:	50                   	push   %eax
  8025ee:	e8 00 ee ff ff       	call   8013f3 <fd_alloc>
  8025f3:	83 c4 10             	add    $0x10,%esp
  8025f6:	85 c0                	test   %eax,%eax
  8025f8:	78 3a                	js     802634 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8025fa:	83 ec 04             	sub    $0x4,%esp
  8025fd:	68 07 04 00 00       	push   $0x407
  802602:	ff 75 f4             	pushl  -0xc(%ebp)
  802605:	6a 00                	push   $0x0
  802607:	e8 7e e9 ff ff       	call   800f8a <sys_page_alloc>
  80260c:	83 c4 10             	add    $0x10,%esp
  80260f:	85 c0                	test   %eax,%eax
  802611:	78 21                	js     802634 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802613:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802616:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80261c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80261e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802621:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802628:	83 ec 0c             	sub    $0xc,%esp
  80262b:	50                   	push   %eax
  80262c:	e8 9b ed ff ff       	call   8013cc <fd2num>
  802631:	83 c4 10             	add    $0x10,%esp
}
  802634:	c9                   	leave  
  802635:	c3                   	ret    

00802636 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802636:	55                   	push   %ebp
  802637:	89 e5                	mov    %esp,%ebp
  802639:	56                   	push   %esi
  80263a:	53                   	push   %ebx
  80263b:	8b 75 08             	mov    0x8(%ebp),%esi
  80263e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802641:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802644:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802646:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80264b:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80264e:	83 ec 0c             	sub    $0xc,%esp
  802651:	50                   	push   %eax
  802652:	e8 e3 ea ff ff       	call   80113a <sys_ipc_recv>
	if(ret < 0){
  802657:	83 c4 10             	add    $0x10,%esp
  80265a:	85 c0                	test   %eax,%eax
  80265c:	78 2b                	js     802689 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80265e:	85 f6                	test   %esi,%esi
  802660:	74 0a                	je     80266c <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802662:	a1 20 44 80 00       	mov    0x804420,%eax
  802667:	8b 40 78             	mov    0x78(%eax),%eax
  80266a:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80266c:	85 db                	test   %ebx,%ebx
  80266e:	74 0a                	je     80267a <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802670:	a1 20 44 80 00       	mov    0x804420,%eax
  802675:	8b 40 7c             	mov    0x7c(%eax),%eax
  802678:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  80267a:	a1 20 44 80 00       	mov    0x804420,%eax
  80267f:	8b 40 74             	mov    0x74(%eax),%eax
}
  802682:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802685:	5b                   	pop    %ebx
  802686:	5e                   	pop    %esi
  802687:	5d                   	pop    %ebp
  802688:	c3                   	ret    
		if(from_env_store)
  802689:	85 f6                	test   %esi,%esi
  80268b:	74 06                	je     802693 <ipc_recv+0x5d>
			*from_env_store = 0;
  80268d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802693:	85 db                	test   %ebx,%ebx
  802695:	74 eb                	je     802682 <ipc_recv+0x4c>
			*perm_store = 0;
  802697:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80269d:	eb e3                	jmp    802682 <ipc_recv+0x4c>

0080269f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80269f:	55                   	push   %ebp
  8026a0:	89 e5                	mov    %esp,%ebp
  8026a2:	57                   	push   %edi
  8026a3:	56                   	push   %esi
  8026a4:	53                   	push   %ebx
  8026a5:	83 ec 0c             	sub    $0xc,%esp
  8026a8:	8b 7d 08             	mov    0x8(%ebp),%edi
  8026ab:	8b 75 0c             	mov    0xc(%ebp),%esi
  8026ae:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8026b1:	85 db                	test   %ebx,%ebx
  8026b3:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8026b8:	0f 44 d8             	cmove  %eax,%ebx
  8026bb:	eb 05                	jmp    8026c2 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8026bd:	e8 a9 e8 ff ff       	call   800f6b <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8026c2:	ff 75 14             	pushl  0x14(%ebp)
  8026c5:	53                   	push   %ebx
  8026c6:	56                   	push   %esi
  8026c7:	57                   	push   %edi
  8026c8:	e8 4a ea ff ff       	call   801117 <sys_ipc_try_send>
  8026cd:	83 c4 10             	add    $0x10,%esp
  8026d0:	85 c0                	test   %eax,%eax
  8026d2:	74 1b                	je     8026ef <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8026d4:	79 e7                	jns    8026bd <ipc_send+0x1e>
  8026d6:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8026d9:	74 e2                	je     8026bd <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8026db:	83 ec 04             	sub    $0x4,%esp
  8026de:	68 9f 2f 80 00       	push   $0x802f9f
  8026e3:	6a 46                	push   $0x46
  8026e5:	68 b4 2f 80 00       	push   $0x802fb4
  8026ea:	e8 54 dc ff ff       	call   800343 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8026ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8026f2:	5b                   	pop    %ebx
  8026f3:	5e                   	pop    %esi
  8026f4:	5f                   	pop    %edi
  8026f5:	5d                   	pop    %ebp
  8026f6:	c3                   	ret    

008026f7 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8026f7:	55                   	push   %ebp
  8026f8:	89 e5                	mov    %esp,%ebp
  8026fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8026fd:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802702:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  802708:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80270e:	8b 52 50             	mov    0x50(%edx),%edx
  802711:	39 ca                	cmp    %ecx,%edx
  802713:	74 11                	je     802726 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  802715:	83 c0 01             	add    $0x1,%eax
  802718:	3d 00 04 00 00       	cmp    $0x400,%eax
  80271d:	75 e3                	jne    802702 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80271f:	b8 00 00 00 00       	mov    $0x0,%eax
  802724:	eb 0e                	jmp    802734 <ipc_find_env+0x3d>
			return envs[i].env_id;
  802726:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80272c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802731:	8b 40 48             	mov    0x48(%eax),%eax
}
  802734:	5d                   	pop    %ebp
  802735:	c3                   	ret    

00802736 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802736:	55                   	push   %ebp
  802737:	89 e5                	mov    %esp,%ebp
  802739:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80273c:	89 d0                	mov    %edx,%eax
  80273e:	c1 e8 16             	shr    $0x16,%eax
  802741:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802748:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80274d:	f6 c1 01             	test   $0x1,%cl
  802750:	74 1d                	je     80276f <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802752:	c1 ea 0c             	shr    $0xc,%edx
  802755:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80275c:	f6 c2 01             	test   $0x1,%dl
  80275f:	74 0e                	je     80276f <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802761:	c1 ea 0c             	shr    $0xc,%edx
  802764:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80276b:	ef 
  80276c:	0f b7 c0             	movzwl %ax,%eax
}
  80276f:	5d                   	pop    %ebp
  802770:	c3                   	ret    
  802771:	66 90                	xchg   %ax,%ax
  802773:	66 90                	xchg   %ax,%ax
  802775:	66 90                	xchg   %ax,%ax
  802777:	66 90                	xchg   %ax,%ax
  802779:	66 90                	xchg   %ax,%ax
  80277b:	66 90                	xchg   %ax,%ax
  80277d:	66 90                	xchg   %ax,%ax
  80277f:	90                   	nop

00802780 <__udivdi3>:
  802780:	55                   	push   %ebp
  802781:	57                   	push   %edi
  802782:	56                   	push   %esi
  802783:	53                   	push   %ebx
  802784:	83 ec 1c             	sub    $0x1c,%esp
  802787:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80278b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80278f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802793:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802797:	85 d2                	test   %edx,%edx
  802799:	75 4d                	jne    8027e8 <__udivdi3+0x68>
  80279b:	39 f3                	cmp    %esi,%ebx
  80279d:	76 19                	jbe    8027b8 <__udivdi3+0x38>
  80279f:	31 ff                	xor    %edi,%edi
  8027a1:	89 e8                	mov    %ebp,%eax
  8027a3:	89 f2                	mov    %esi,%edx
  8027a5:	f7 f3                	div    %ebx
  8027a7:	89 fa                	mov    %edi,%edx
  8027a9:	83 c4 1c             	add    $0x1c,%esp
  8027ac:	5b                   	pop    %ebx
  8027ad:	5e                   	pop    %esi
  8027ae:	5f                   	pop    %edi
  8027af:	5d                   	pop    %ebp
  8027b0:	c3                   	ret    
  8027b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027b8:	89 d9                	mov    %ebx,%ecx
  8027ba:	85 db                	test   %ebx,%ebx
  8027bc:	75 0b                	jne    8027c9 <__udivdi3+0x49>
  8027be:	b8 01 00 00 00       	mov    $0x1,%eax
  8027c3:	31 d2                	xor    %edx,%edx
  8027c5:	f7 f3                	div    %ebx
  8027c7:	89 c1                	mov    %eax,%ecx
  8027c9:	31 d2                	xor    %edx,%edx
  8027cb:	89 f0                	mov    %esi,%eax
  8027cd:	f7 f1                	div    %ecx
  8027cf:	89 c6                	mov    %eax,%esi
  8027d1:	89 e8                	mov    %ebp,%eax
  8027d3:	89 f7                	mov    %esi,%edi
  8027d5:	f7 f1                	div    %ecx
  8027d7:	89 fa                	mov    %edi,%edx
  8027d9:	83 c4 1c             	add    $0x1c,%esp
  8027dc:	5b                   	pop    %ebx
  8027dd:	5e                   	pop    %esi
  8027de:	5f                   	pop    %edi
  8027df:	5d                   	pop    %ebp
  8027e0:	c3                   	ret    
  8027e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027e8:	39 f2                	cmp    %esi,%edx
  8027ea:	77 1c                	ja     802808 <__udivdi3+0x88>
  8027ec:	0f bd fa             	bsr    %edx,%edi
  8027ef:	83 f7 1f             	xor    $0x1f,%edi
  8027f2:	75 2c                	jne    802820 <__udivdi3+0xa0>
  8027f4:	39 f2                	cmp    %esi,%edx
  8027f6:	72 06                	jb     8027fe <__udivdi3+0x7e>
  8027f8:	31 c0                	xor    %eax,%eax
  8027fa:	39 eb                	cmp    %ebp,%ebx
  8027fc:	77 a9                	ja     8027a7 <__udivdi3+0x27>
  8027fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802803:	eb a2                	jmp    8027a7 <__udivdi3+0x27>
  802805:	8d 76 00             	lea    0x0(%esi),%esi
  802808:	31 ff                	xor    %edi,%edi
  80280a:	31 c0                	xor    %eax,%eax
  80280c:	89 fa                	mov    %edi,%edx
  80280e:	83 c4 1c             	add    $0x1c,%esp
  802811:	5b                   	pop    %ebx
  802812:	5e                   	pop    %esi
  802813:	5f                   	pop    %edi
  802814:	5d                   	pop    %ebp
  802815:	c3                   	ret    
  802816:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80281d:	8d 76 00             	lea    0x0(%esi),%esi
  802820:	89 f9                	mov    %edi,%ecx
  802822:	b8 20 00 00 00       	mov    $0x20,%eax
  802827:	29 f8                	sub    %edi,%eax
  802829:	d3 e2                	shl    %cl,%edx
  80282b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80282f:	89 c1                	mov    %eax,%ecx
  802831:	89 da                	mov    %ebx,%edx
  802833:	d3 ea                	shr    %cl,%edx
  802835:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802839:	09 d1                	or     %edx,%ecx
  80283b:	89 f2                	mov    %esi,%edx
  80283d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802841:	89 f9                	mov    %edi,%ecx
  802843:	d3 e3                	shl    %cl,%ebx
  802845:	89 c1                	mov    %eax,%ecx
  802847:	d3 ea                	shr    %cl,%edx
  802849:	89 f9                	mov    %edi,%ecx
  80284b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80284f:	89 eb                	mov    %ebp,%ebx
  802851:	d3 e6                	shl    %cl,%esi
  802853:	89 c1                	mov    %eax,%ecx
  802855:	d3 eb                	shr    %cl,%ebx
  802857:	09 de                	or     %ebx,%esi
  802859:	89 f0                	mov    %esi,%eax
  80285b:	f7 74 24 08          	divl   0x8(%esp)
  80285f:	89 d6                	mov    %edx,%esi
  802861:	89 c3                	mov    %eax,%ebx
  802863:	f7 64 24 0c          	mull   0xc(%esp)
  802867:	39 d6                	cmp    %edx,%esi
  802869:	72 15                	jb     802880 <__udivdi3+0x100>
  80286b:	89 f9                	mov    %edi,%ecx
  80286d:	d3 e5                	shl    %cl,%ebp
  80286f:	39 c5                	cmp    %eax,%ebp
  802871:	73 04                	jae    802877 <__udivdi3+0xf7>
  802873:	39 d6                	cmp    %edx,%esi
  802875:	74 09                	je     802880 <__udivdi3+0x100>
  802877:	89 d8                	mov    %ebx,%eax
  802879:	31 ff                	xor    %edi,%edi
  80287b:	e9 27 ff ff ff       	jmp    8027a7 <__udivdi3+0x27>
  802880:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802883:	31 ff                	xor    %edi,%edi
  802885:	e9 1d ff ff ff       	jmp    8027a7 <__udivdi3+0x27>
  80288a:	66 90                	xchg   %ax,%ax
  80288c:	66 90                	xchg   %ax,%ax
  80288e:	66 90                	xchg   %ax,%ax

00802890 <__umoddi3>:
  802890:	55                   	push   %ebp
  802891:	57                   	push   %edi
  802892:	56                   	push   %esi
  802893:	53                   	push   %ebx
  802894:	83 ec 1c             	sub    $0x1c,%esp
  802897:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80289b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80289f:	8b 74 24 30          	mov    0x30(%esp),%esi
  8028a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8028a7:	89 da                	mov    %ebx,%edx
  8028a9:	85 c0                	test   %eax,%eax
  8028ab:	75 43                	jne    8028f0 <__umoddi3+0x60>
  8028ad:	39 df                	cmp    %ebx,%edi
  8028af:	76 17                	jbe    8028c8 <__umoddi3+0x38>
  8028b1:	89 f0                	mov    %esi,%eax
  8028b3:	f7 f7                	div    %edi
  8028b5:	89 d0                	mov    %edx,%eax
  8028b7:	31 d2                	xor    %edx,%edx
  8028b9:	83 c4 1c             	add    $0x1c,%esp
  8028bc:	5b                   	pop    %ebx
  8028bd:	5e                   	pop    %esi
  8028be:	5f                   	pop    %edi
  8028bf:	5d                   	pop    %ebp
  8028c0:	c3                   	ret    
  8028c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028c8:	89 fd                	mov    %edi,%ebp
  8028ca:	85 ff                	test   %edi,%edi
  8028cc:	75 0b                	jne    8028d9 <__umoddi3+0x49>
  8028ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8028d3:	31 d2                	xor    %edx,%edx
  8028d5:	f7 f7                	div    %edi
  8028d7:	89 c5                	mov    %eax,%ebp
  8028d9:	89 d8                	mov    %ebx,%eax
  8028db:	31 d2                	xor    %edx,%edx
  8028dd:	f7 f5                	div    %ebp
  8028df:	89 f0                	mov    %esi,%eax
  8028e1:	f7 f5                	div    %ebp
  8028e3:	89 d0                	mov    %edx,%eax
  8028e5:	eb d0                	jmp    8028b7 <__umoddi3+0x27>
  8028e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028ee:	66 90                	xchg   %ax,%ax
  8028f0:	89 f1                	mov    %esi,%ecx
  8028f2:	39 d8                	cmp    %ebx,%eax
  8028f4:	76 0a                	jbe    802900 <__umoddi3+0x70>
  8028f6:	89 f0                	mov    %esi,%eax
  8028f8:	83 c4 1c             	add    $0x1c,%esp
  8028fb:	5b                   	pop    %ebx
  8028fc:	5e                   	pop    %esi
  8028fd:	5f                   	pop    %edi
  8028fe:	5d                   	pop    %ebp
  8028ff:	c3                   	ret    
  802900:	0f bd e8             	bsr    %eax,%ebp
  802903:	83 f5 1f             	xor    $0x1f,%ebp
  802906:	75 20                	jne    802928 <__umoddi3+0x98>
  802908:	39 d8                	cmp    %ebx,%eax
  80290a:	0f 82 b0 00 00 00    	jb     8029c0 <__umoddi3+0x130>
  802910:	39 f7                	cmp    %esi,%edi
  802912:	0f 86 a8 00 00 00    	jbe    8029c0 <__umoddi3+0x130>
  802918:	89 c8                	mov    %ecx,%eax
  80291a:	83 c4 1c             	add    $0x1c,%esp
  80291d:	5b                   	pop    %ebx
  80291e:	5e                   	pop    %esi
  80291f:	5f                   	pop    %edi
  802920:	5d                   	pop    %ebp
  802921:	c3                   	ret    
  802922:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802928:	89 e9                	mov    %ebp,%ecx
  80292a:	ba 20 00 00 00       	mov    $0x20,%edx
  80292f:	29 ea                	sub    %ebp,%edx
  802931:	d3 e0                	shl    %cl,%eax
  802933:	89 44 24 08          	mov    %eax,0x8(%esp)
  802937:	89 d1                	mov    %edx,%ecx
  802939:	89 f8                	mov    %edi,%eax
  80293b:	d3 e8                	shr    %cl,%eax
  80293d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802941:	89 54 24 04          	mov    %edx,0x4(%esp)
  802945:	8b 54 24 04          	mov    0x4(%esp),%edx
  802949:	09 c1                	or     %eax,%ecx
  80294b:	89 d8                	mov    %ebx,%eax
  80294d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802951:	89 e9                	mov    %ebp,%ecx
  802953:	d3 e7                	shl    %cl,%edi
  802955:	89 d1                	mov    %edx,%ecx
  802957:	d3 e8                	shr    %cl,%eax
  802959:	89 e9                	mov    %ebp,%ecx
  80295b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80295f:	d3 e3                	shl    %cl,%ebx
  802961:	89 c7                	mov    %eax,%edi
  802963:	89 d1                	mov    %edx,%ecx
  802965:	89 f0                	mov    %esi,%eax
  802967:	d3 e8                	shr    %cl,%eax
  802969:	89 e9                	mov    %ebp,%ecx
  80296b:	89 fa                	mov    %edi,%edx
  80296d:	d3 e6                	shl    %cl,%esi
  80296f:	09 d8                	or     %ebx,%eax
  802971:	f7 74 24 08          	divl   0x8(%esp)
  802975:	89 d1                	mov    %edx,%ecx
  802977:	89 f3                	mov    %esi,%ebx
  802979:	f7 64 24 0c          	mull   0xc(%esp)
  80297d:	89 c6                	mov    %eax,%esi
  80297f:	89 d7                	mov    %edx,%edi
  802981:	39 d1                	cmp    %edx,%ecx
  802983:	72 06                	jb     80298b <__umoddi3+0xfb>
  802985:	75 10                	jne    802997 <__umoddi3+0x107>
  802987:	39 c3                	cmp    %eax,%ebx
  802989:	73 0c                	jae    802997 <__umoddi3+0x107>
  80298b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80298f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802993:	89 d7                	mov    %edx,%edi
  802995:	89 c6                	mov    %eax,%esi
  802997:	89 ca                	mov    %ecx,%edx
  802999:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80299e:	29 f3                	sub    %esi,%ebx
  8029a0:	19 fa                	sbb    %edi,%edx
  8029a2:	89 d0                	mov    %edx,%eax
  8029a4:	d3 e0                	shl    %cl,%eax
  8029a6:	89 e9                	mov    %ebp,%ecx
  8029a8:	d3 eb                	shr    %cl,%ebx
  8029aa:	d3 ea                	shr    %cl,%edx
  8029ac:	09 d8                	or     %ebx,%eax
  8029ae:	83 c4 1c             	add    $0x1c,%esp
  8029b1:	5b                   	pop    %ebx
  8029b2:	5e                   	pop    %esi
  8029b3:	5f                   	pop    %edi
  8029b4:	5d                   	pop    %ebp
  8029b5:	c3                   	ret    
  8029b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029bd:	8d 76 00             	lea    0x0(%esi),%esi
  8029c0:	89 da                	mov    %ebx,%edx
  8029c2:	29 fe                	sub    %edi,%esi
  8029c4:	19 c2                	sbb    %eax,%edx
  8029c6:	89 f1                	mov    %esi,%ecx
  8029c8:	89 c8                	mov    %ecx,%eax
  8029ca:	e9 4b ff ff ff       	jmp    80291a <__umoddi3+0x8a>
