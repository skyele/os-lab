
obj/user/testkbd.debug:     file format elf32-i386


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
  80002c:	e8 29 02 00 00       	call   80025a <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 04             	sub    $0x4,%esp
  80003a:	bb 0a 00 00 00       	mov    $0xa,%ebx
	int i, r;

	// Spin for a bit to let the console quiet
	for (i = 0; i < 10; ++i)
		sys_yield();
  80003f:	e8 ea 0f 00 00       	call   80102e <sys_yield>
	for (i = 0; i < 10; ++i)
  800044:	83 eb 01             	sub    $0x1,%ebx
  800047:	75 f6                	jne    80003f <umain+0xc>

	close(0);
  800049:	83 ec 0c             	sub    $0xc,%esp
  80004c:	6a 00                	push   $0x0
  80004e:	e8 7a 14 00 00       	call   8014cd <close>
	if ((r = opencons()) < 0)
  800053:	e8 b0 01 00 00       	call   800208 <opencons>
  800058:	83 c4 10             	add    $0x10,%esp
  80005b:	85 c0                	test   %eax,%eax
  80005d:	78 14                	js     800073 <umain+0x40>
		panic("opencons: %e", r);
	if (r != 0)
  80005f:	74 24                	je     800085 <umain+0x52>
		panic("first opencons used fd %d", r);
  800061:	50                   	push   %eax
  800062:	68 bc 27 80 00       	push   $0x8027bc
  800067:	6a 11                	push   $0x11
  800069:	68 ad 27 80 00       	push   $0x8027ad
  80006e:	e8 a3 02 00 00       	call   800316 <_panic>
		panic("opencons: %e", r);
  800073:	50                   	push   %eax
  800074:	68 a0 27 80 00       	push   $0x8027a0
  800079:	6a 0f                	push   $0xf
  80007b:	68 ad 27 80 00       	push   $0x8027ad
  800080:	e8 91 02 00 00       	call   800316 <_panic>
	if ((r = dup(0, 1)) < 0)
  800085:	83 ec 08             	sub    $0x8,%esp
  800088:	6a 01                	push   $0x1
  80008a:	6a 00                	push   $0x0
  80008c:	e8 8e 14 00 00       	call   80151f <dup>
  800091:	83 c4 10             	add    $0x10,%esp
  800094:	85 c0                	test   %eax,%eax
  800096:	79 24                	jns    8000bc <umain+0x89>
		panic("dup: %e", r);
  800098:	50                   	push   %eax
  800099:	68 d6 27 80 00       	push   $0x8027d6
  80009e:	6a 13                	push   $0x13
  8000a0:	68 ad 27 80 00       	push   $0x8027ad
  8000a5:	e8 6c 02 00 00       	call   800316 <_panic>

		buf = readline("Type a line: ");
		if (buf != NULL)
			fprintf(1, "%s\n", buf);
		else
			fprintf(1, "(end of file received)\n");
  8000aa:	83 ec 08             	sub    $0x8,%esp
  8000ad:	68 ec 27 80 00       	push   $0x8027ec
  8000b2:	6a 01                	push   $0x1
  8000b4:	e8 7c 1b 00 00       	call   801c35 <fprintf>
  8000b9:	83 c4 10             	add    $0x10,%esp
		buf = readline("Type a line: ");
  8000bc:	83 ec 0c             	sub    $0xc,%esp
  8000bf:	68 de 27 80 00       	push   $0x8027de
  8000c4:	e8 69 0a 00 00       	call   800b32 <readline>
		if (buf != NULL)
  8000c9:	83 c4 10             	add    $0x10,%esp
  8000cc:	85 c0                	test   %eax,%eax
  8000ce:	74 da                	je     8000aa <umain+0x77>
			fprintf(1, "%s\n", buf);
  8000d0:	83 ec 04             	sub    $0x4,%esp
  8000d3:	50                   	push   %eax
  8000d4:	68 3b 28 80 00       	push   $0x80283b
  8000d9:	6a 01                	push   $0x1
  8000db:	e8 55 1b 00 00       	call   801c35 <fprintf>
  8000e0:	83 c4 10             	add    $0x10,%esp
  8000e3:	eb d7                	jmp    8000bc <umain+0x89>

008000e5 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8000e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ea:	c3                   	ret    

008000eb <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8000eb:	55                   	push   %ebp
  8000ec:	89 e5                	mov    %esp,%ebp
  8000ee:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8000f1:	68 04 28 80 00       	push   $0x802804
  8000f6:	ff 75 0c             	pushl  0xc(%ebp)
  8000f9:	e8 5d 0b 00 00       	call   800c5b <strcpy>
	return 0;
}
  8000fe:	b8 00 00 00 00       	mov    $0x0,%eax
  800103:	c9                   	leave  
  800104:	c3                   	ret    

00800105 <devcons_write>:
{
  800105:	55                   	push   %ebp
  800106:	89 e5                	mov    %esp,%ebp
  800108:	57                   	push   %edi
  800109:	56                   	push   %esi
  80010a:	53                   	push   %ebx
  80010b:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800111:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800116:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80011c:	3b 75 10             	cmp    0x10(%ebp),%esi
  80011f:	73 31                	jae    800152 <devcons_write+0x4d>
		m = n - tot;
  800121:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800124:	29 f3                	sub    %esi,%ebx
  800126:	83 fb 7f             	cmp    $0x7f,%ebx
  800129:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80012e:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  800131:	83 ec 04             	sub    $0x4,%esp
  800134:	53                   	push   %ebx
  800135:	89 f0                	mov    %esi,%eax
  800137:	03 45 0c             	add    0xc(%ebp),%eax
  80013a:	50                   	push   %eax
  80013b:	57                   	push   %edi
  80013c:	e8 a8 0c 00 00       	call   800de9 <memmove>
		sys_cputs(buf, m);
  800141:	83 c4 08             	add    $0x8,%esp
  800144:	53                   	push   %ebx
  800145:	57                   	push   %edi
  800146:	e8 46 0e 00 00       	call   800f91 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80014b:	01 de                	add    %ebx,%esi
  80014d:	83 c4 10             	add    $0x10,%esp
  800150:	eb ca                	jmp    80011c <devcons_write+0x17>
}
  800152:	89 f0                	mov    %esi,%eax
  800154:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800157:	5b                   	pop    %ebx
  800158:	5e                   	pop    %esi
  800159:	5f                   	pop    %edi
  80015a:	5d                   	pop    %ebp
  80015b:	c3                   	ret    

0080015c <devcons_read>:
{
  80015c:	55                   	push   %ebp
  80015d:	89 e5                	mov    %esp,%ebp
  80015f:	83 ec 08             	sub    $0x8,%esp
  800162:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  800167:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80016b:	74 21                	je     80018e <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80016d:	e8 3d 0e 00 00       	call   800faf <sys_cgetc>
  800172:	85 c0                	test   %eax,%eax
  800174:	75 07                	jne    80017d <devcons_read+0x21>
		sys_yield();
  800176:	e8 b3 0e 00 00       	call   80102e <sys_yield>
  80017b:	eb f0                	jmp    80016d <devcons_read+0x11>
	if (c < 0)
  80017d:	78 0f                	js     80018e <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80017f:	83 f8 04             	cmp    $0x4,%eax
  800182:	74 0c                	je     800190 <devcons_read+0x34>
	*(char*)vbuf = c;
  800184:	8b 55 0c             	mov    0xc(%ebp),%edx
  800187:	88 02                	mov    %al,(%edx)
	return 1;
  800189:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80018e:	c9                   	leave  
  80018f:	c3                   	ret    
		return 0;
  800190:	b8 00 00 00 00       	mov    $0x0,%eax
  800195:	eb f7                	jmp    80018e <devcons_read+0x32>

00800197 <cputchar>:
{
  800197:	55                   	push   %ebp
  800198:	89 e5                	mov    %esp,%ebp
  80019a:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80019d:	8b 45 08             	mov    0x8(%ebp),%eax
  8001a0:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8001a3:	6a 01                	push   $0x1
  8001a5:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8001a8:	50                   	push   %eax
  8001a9:	e8 e3 0d 00 00       	call   800f91 <sys_cputs>
}
  8001ae:	83 c4 10             	add    $0x10,%esp
  8001b1:	c9                   	leave  
  8001b2:	c3                   	ret    

008001b3 <getchar>:
{
  8001b3:	55                   	push   %ebp
  8001b4:	89 e5                	mov    %esp,%ebp
  8001b6:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8001b9:	6a 01                	push   $0x1
  8001bb:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8001be:	50                   	push   %eax
  8001bf:	6a 00                	push   $0x0
  8001c1:	e8 45 14 00 00       	call   80160b <read>
	if (r < 0)
  8001c6:	83 c4 10             	add    $0x10,%esp
  8001c9:	85 c0                	test   %eax,%eax
  8001cb:	78 06                	js     8001d3 <getchar+0x20>
	if (r < 1)
  8001cd:	74 06                	je     8001d5 <getchar+0x22>
	return c;
  8001cf:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8001d3:	c9                   	leave  
  8001d4:	c3                   	ret    
		return -E_EOF;
  8001d5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8001da:	eb f7                	jmp    8001d3 <getchar+0x20>

008001dc <iscons>:
{
  8001dc:	55                   	push   %ebp
  8001dd:	89 e5                	mov    %esp,%ebp
  8001df:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8001e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8001e5:	50                   	push   %eax
  8001e6:	ff 75 08             	pushl  0x8(%ebp)
  8001e9:	e8 ad 11 00 00       	call   80139b <fd_lookup>
  8001ee:	83 c4 10             	add    $0x10,%esp
  8001f1:	85 c0                	test   %eax,%eax
  8001f3:	78 11                	js     800206 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8001f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001f8:	8b 15 00 30 80 00    	mov    0x803000,%edx
  8001fe:	39 10                	cmp    %edx,(%eax)
  800200:	0f 94 c0             	sete   %al
  800203:	0f b6 c0             	movzbl %al,%eax
}
  800206:	c9                   	leave  
  800207:	c3                   	ret    

00800208 <opencons>:
{
  800208:	55                   	push   %ebp
  800209:	89 e5                	mov    %esp,%ebp
  80020b:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80020e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800211:	50                   	push   %eax
  800212:	e8 32 11 00 00       	call   801349 <fd_alloc>
  800217:	83 c4 10             	add    $0x10,%esp
  80021a:	85 c0                	test   %eax,%eax
  80021c:	78 3a                	js     800258 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80021e:	83 ec 04             	sub    $0x4,%esp
  800221:	68 07 04 00 00       	push   $0x407
  800226:	ff 75 f4             	pushl  -0xc(%ebp)
  800229:	6a 00                	push   $0x0
  80022b:	e8 1d 0e 00 00       	call   80104d <sys_page_alloc>
  800230:	83 c4 10             	add    $0x10,%esp
  800233:	85 c0                	test   %eax,%eax
  800235:	78 21                	js     800258 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  800237:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80023a:	8b 15 00 30 80 00    	mov    0x803000,%edx
  800240:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800242:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800245:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80024c:	83 ec 0c             	sub    $0xc,%esp
  80024f:	50                   	push   %eax
  800250:	e8 cd 10 00 00       	call   801322 <fd2num>
  800255:	83 c4 10             	add    $0x10,%esp
}
  800258:	c9                   	leave  
  800259:	c3                   	ret    

0080025a <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  80025a:	55                   	push   %ebp
  80025b:	89 e5                	mov    %esp,%ebp
  80025d:	57                   	push   %edi
  80025e:	56                   	push   %esi
  80025f:	53                   	push   %ebx
  800260:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  800263:	c7 05 08 44 80 00 00 	movl   $0x0,0x804408
  80026a:	00 00 00 
	envid_t find = sys_getenvid();
  80026d:	e8 9d 0d 00 00       	call   80100f <sys_getenvid>
  800272:	8b 1d 08 44 80 00    	mov    0x804408,%ebx
  800278:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  80027d:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  800282:	bf 01 00 00 00       	mov    $0x1,%edi
  800287:	eb 0b                	jmp    800294 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  800289:	83 c2 01             	add    $0x1,%edx
  80028c:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800292:	74 21                	je     8002b5 <libmain+0x5b>
		if(envs[i].env_id == find)
  800294:	89 d1                	mov    %edx,%ecx
  800296:	c1 e1 07             	shl    $0x7,%ecx
  800299:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  80029f:	8b 49 48             	mov    0x48(%ecx),%ecx
  8002a2:	39 c1                	cmp    %eax,%ecx
  8002a4:	75 e3                	jne    800289 <libmain+0x2f>
  8002a6:	89 d3                	mov    %edx,%ebx
  8002a8:	c1 e3 07             	shl    $0x7,%ebx
  8002ab:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8002b1:	89 fe                	mov    %edi,%esi
  8002b3:	eb d4                	jmp    800289 <libmain+0x2f>
  8002b5:	89 f0                	mov    %esi,%eax
  8002b7:	84 c0                	test   %al,%al
  8002b9:	74 06                	je     8002c1 <libmain+0x67>
  8002bb:	89 1d 08 44 80 00    	mov    %ebx,0x804408
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002c5:	7e 0a                	jle    8002d1 <libmain+0x77>
		binaryname = argv[0];
  8002c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ca:	8b 00                	mov    (%eax),%eax
  8002cc:	a3 1c 30 80 00       	mov    %eax,0x80301c

	cprintf("in libmain.c call umain!\n");
  8002d1:	83 ec 0c             	sub    $0xc,%esp
  8002d4:	68 10 28 80 00       	push   $0x802810
  8002d9:	e8 2e 01 00 00       	call   80040c <cprintf>
	// call user main routine
	umain(argc, argv);
  8002de:	83 c4 08             	add    $0x8,%esp
  8002e1:	ff 75 0c             	pushl  0xc(%ebp)
  8002e4:	ff 75 08             	pushl  0x8(%ebp)
  8002e7:	e8 47 fd ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8002ec:	e8 0b 00 00 00       	call   8002fc <exit>
}
  8002f1:	83 c4 10             	add    $0x10,%esp
  8002f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002f7:	5b                   	pop    %ebx
  8002f8:	5e                   	pop    %esi
  8002f9:	5f                   	pop    %edi
  8002fa:	5d                   	pop    %ebp
  8002fb:	c3                   	ret    

008002fc <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8002fc:	55                   	push   %ebp
  8002fd:	89 e5                	mov    %esp,%ebp
  8002ff:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800302:	e8 f3 11 00 00       	call   8014fa <close_all>
	sys_env_destroy(0);
  800307:	83 ec 0c             	sub    $0xc,%esp
  80030a:	6a 00                	push   $0x0
  80030c:	e8 bd 0c 00 00       	call   800fce <sys_env_destroy>
}
  800311:	83 c4 10             	add    $0x10,%esp
  800314:	c9                   	leave  
  800315:	c3                   	ret    

00800316 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800316:	55                   	push   %ebp
  800317:	89 e5                	mov    %esp,%ebp
  800319:	56                   	push   %esi
  80031a:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80031b:	a1 08 44 80 00       	mov    0x804408,%eax
  800320:	8b 40 48             	mov    0x48(%eax),%eax
  800323:	83 ec 04             	sub    $0x4,%esp
  800326:	68 64 28 80 00       	push   $0x802864
  80032b:	50                   	push   %eax
  80032c:	68 34 28 80 00       	push   $0x802834
  800331:	e8 d6 00 00 00       	call   80040c <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800336:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800339:	8b 35 1c 30 80 00    	mov    0x80301c,%esi
  80033f:	e8 cb 0c 00 00       	call   80100f <sys_getenvid>
  800344:	83 c4 04             	add    $0x4,%esp
  800347:	ff 75 0c             	pushl  0xc(%ebp)
  80034a:	ff 75 08             	pushl  0x8(%ebp)
  80034d:	56                   	push   %esi
  80034e:	50                   	push   %eax
  80034f:	68 40 28 80 00       	push   $0x802840
  800354:	e8 b3 00 00 00       	call   80040c <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800359:	83 c4 18             	add    $0x18,%esp
  80035c:	53                   	push   %ebx
  80035d:	ff 75 10             	pushl  0x10(%ebp)
  800360:	e8 56 00 00 00       	call   8003bb <vcprintf>
	cprintf("\n");
  800365:	c7 04 24 28 28 80 00 	movl   $0x802828,(%esp)
  80036c:	e8 9b 00 00 00       	call   80040c <cprintf>
  800371:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800374:	cc                   	int3   
  800375:	eb fd                	jmp    800374 <_panic+0x5e>

00800377 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800377:	55                   	push   %ebp
  800378:	89 e5                	mov    %esp,%ebp
  80037a:	53                   	push   %ebx
  80037b:	83 ec 04             	sub    $0x4,%esp
  80037e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800381:	8b 13                	mov    (%ebx),%edx
  800383:	8d 42 01             	lea    0x1(%edx),%eax
  800386:	89 03                	mov    %eax,(%ebx)
  800388:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80038b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80038f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800394:	74 09                	je     80039f <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800396:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80039a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80039d:	c9                   	leave  
  80039e:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80039f:	83 ec 08             	sub    $0x8,%esp
  8003a2:	68 ff 00 00 00       	push   $0xff
  8003a7:	8d 43 08             	lea    0x8(%ebx),%eax
  8003aa:	50                   	push   %eax
  8003ab:	e8 e1 0b 00 00       	call   800f91 <sys_cputs>
		b->idx = 0;
  8003b0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003b6:	83 c4 10             	add    $0x10,%esp
  8003b9:	eb db                	jmp    800396 <putch+0x1f>

008003bb <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003bb:	55                   	push   %ebp
  8003bc:	89 e5                	mov    %esp,%ebp
  8003be:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003c4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003cb:	00 00 00 
	b.cnt = 0;
  8003ce:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003d5:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003d8:	ff 75 0c             	pushl  0xc(%ebp)
  8003db:	ff 75 08             	pushl  0x8(%ebp)
  8003de:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003e4:	50                   	push   %eax
  8003e5:	68 77 03 80 00       	push   $0x800377
  8003ea:	e8 4a 01 00 00       	call   800539 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003ef:	83 c4 08             	add    $0x8,%esp
  8003f2:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8003f8:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003fe:	50                   	push   %eax
  8003ff:	e8 8d 0b 00 00       	call   800f91 <sys_cputs>

	return b.cnt;
}
  800404:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80040a:	c9                   	leave  
  80040b:	c3                   	ret    

0080040c <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80040c:	55                   	push   %ebp
  80040d:	89 e5                	mov    %esp,%ebp
  80040f:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800412:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800415:	50                   	push   %eax
  800416:	ff 75 08             	pushl  0x8(%ebp)
  800419:	e8 9d ff ff ff       	call   8003bb <vcprintf>
	va_end(ap);

	return cnt;
}
  80041e:	c9                   	leave  
  80041f:	c3                   	ret    

00800420 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800420:	55                   	push   %ebp
  800421:	89 e5                	mov    %esp,%ebp
  800423:	57                   	push   %edi
  800424:	56                   	push   %esi
  800425:	53                   	push   %ebx
  800426:	83 ec 1c             	sub    $0x1c,%esp
  800429:	89 c6                	mov    %eax,%esi
  80042b:	89 d7                	mov    %edx,%edi
  80042d:	8b 45 08             	mov    0x8(%ebp),%eax
  800430:	8b 55 0c             	mov    0xc(%ebp),%edx
  800433:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800436:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800439:	8b 45 10             	mov    0x10(%ebp),%eax
  80043c:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80043f:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800443:	74 2c                	je     800471 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800445:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800448:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80044f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800452:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800455:	39 c2                	cmp    %eax,%edx
  800457:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80045a:	73 43                	jae    80049f <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  80045c:	83 eb 01             	sub    $0x1,%ebx
  80045f:	85 db                	test   %ebx,%ebx
  800461:	7e 6c                	jle    8004cf <printnum+0xaf>
				putch(padc, putdat);
  800463:	83 ec 08             	sub    $0x8,%esp
  800466:	57                   	push   %edi
  800467:	ff 75 18             	pushl  0x18(%ebp)
  80046a:	ff d6                	call   *%esi
  80046c:	83 c4 10             	add    $0x10,%esp
  80046f:	eb eb                	jmp    80045c <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800471:	83 ec 0c             	sub    $0xc,%esp
  800474:	6a 20                	push   $0x20
  800476:	6a 00                	push   $0x0
  800478:	50                   	push   %eax
  800479:	ff 75 e4             	pushl  -0x1c(%ebp)
  80047c:	ff 75 e0             	pushl  -0x20(%ebp)
  80047f:	89 fa                	mov    %edi,%edx
  800481:	89 f0                	mov    %esi,%eax
  800483:	e8 98 ff ff ff       	call   800420 <printnum>
		while (--width > 0)
  800488:	83 c4 20             	add    $0x20,%esp
  80048b:	83 eb 01             	sub    $0x1,%ebx
  80048e:	85 db                	test   %ebx,%ebx
  800490:	7e 65                	jle    8004f7 <printnum+0xd7>
			putch(padc, putdat);
  800492:	83 ec 08             	sub    $0x8,%esp
  800495:	57                   	push   %edi
  800496:	6a 20                	push   $0x20
  800498:	ff d6                	call   *%esi
  80049a:	83 c4 10             	add    $0x10,%esp
  80049d:	eb ec                	jmp    80048b <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80049f:	83 ec 0c             	sub    $0xc,%esp
  8004a2:	ff 75 18             	pushl  0x18(%ebp)
  8004a5:	83 eb 01             	sub    $0x1,%ebx
  8004a8:	53                   	push   %ebx
  8004a9:	50                   	push   %eax
  8004aa:	83 ec 08             	sub    $0x8,%esp
  8004ad:	ff 75 dc             	pushl  -0x24(%ebp)
  8004b0:	ff 75 d8             	pushl  -0x28(%ebp)
  8004b3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004b6:	ff 75 e0             	pushl  -0x20(%ebp)
  8004b9:	e8 92 20 00 00       	call   802550 <__udivdi3>
  8004be:	83 c4 18             	add    $0x18,%esp
  8004c1:	52                   	push   %edx
  8004c2:	50                   	push   %eax
  8004c3:	89 fa                	mov    %edi,%edx
  8004c5:	89 f0                	mov    %esi,%eax
  8004c7:	e8 54 ff ff ff       	call   800420 <printnum>
  8004cc:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8004cf:	83 ec 08             	sub    $0x8,%esp
  8004d2:	57                   	push   %edi
  8004d3:	83 ec 04             	sub    $0x4,%esp
  8004d6:	ff 75 dc             	pushl  -0x24(%ebp)
  8004d9:	ff 75 d8             	pushl  -0x28(%ebp)
  8004dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004df:	ff 75 e0             	pushl  -0x20(%ebp)
  8004e2:	e8 79 21 00 00       	call   802660 <__umoddi3>
  8004e7:	83 c4 14             	add    $0x14,%esp
  8004ea:	0f be 80 6b 28 80 00 	movsbl 0x80286b(%eax),%eax
  8004f1:	50                   	push   %eax
  8004f2:	ff d6                	call   *%esi
  8004f4:	83 c4 10             	add    $0x10,%esp
	}
}
  8004f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004fa:	5b                   	pop    %ebx
  8004fb:	5e                   	pop    %esi
  8004fc:	5f                   	pop    %edi
  8004fd:	5d                   	pop    %ebp
  8004fe:	c3                   	ret    

008004ff <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004ff:	55                   	push   %ebp
  800500:	89 e5                	mov    %esp,%ebp
  800502:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800505:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800509:	8b 10                	mov    (%eax),%edx
  80050b:	3b 50 04             	cmp    0x4(%eax),%edx
  80050e:	73 0a                	jae    80051a <sprintputch+0x1b>
		*b->buf++ = ch;
  800510:	8d 4a 01             	lea    0x1(%edx),%ecx
  800513:	89 08                	mov    %ecx,(%eax)
  800515:	8b 45 08             	mov    0x8(%ebp),%eax
  800518:	88 02                	mov    %al,(%edx)
}
  80051a:	5d                   	pop    %ebp
  80051b:	c3                   	ret    

0080051c <printfmt>:
{
  80051c:	55                   	push   %ebp
  80051d:	89 e5                	mov    %esp,%ebp
  80051f:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800522:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800525:	50                   	push   %eax
  800526:	ff 75 10             	pushl  0x10(%ebp)
  800529:	ff 75 0c             	pushl  0xc(%ebp)
  80052c:	ff 75 08             	pushl  0x8(%ebp)
  80052f:	e8 05 00 00 00       	call   800539 <vprintfmt>
}
  800534:	83 c4 10             	add    $0x10,%esp
  800537:	c9                   	leave  
  800538:	c3                   	ret    

00800539 <vprintfmt>:
{
  800539:	55                   	push   %ebp
  80053a:	89 e5                	mov    %esp,%ebp
  80053c:	57                   	push   %edi
  80053d:	56                   	push   %esi
  80053e:	53                   	push   %ebx
  80053f:	83 ec 3c             	sub    $0x3c,%esp
  800542:	8b 75 08             	mov    0x8(%ebp),%esi
  800545:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800548:	8b 7d 10             	mov    0x10(%ebp),%edi
  80054b:	e9 32 04 00 00       	jmp    800982 <vprintfmt+0x449>
		padc = ' ';
  800550:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800554:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  80055b:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800562:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800569:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800570:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800577:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80057c:	8d 47 01             	lea    0x1(%edi),%eax
  80057f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800582:	0f b6 17             	movzbl (%edi),%edx
  800585:	8d 42 dd             	lea    -0x23(%edx),%eax
  800588:	3c 55                	cmp    $0x55,%al
  80058a:	0f 87 12 05 00 00    	ja     800aa2 <vprintfmt+0x569>
  800590:	0f b6 c0             	movzbl %al,%eax
  800593:	ff 24 85 40 2a 80 00 	jmp    *0x802a40(,%eax,4)
  80059a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80059d:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8005a1:	eb d9                	jmp    80057c <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8005a3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8005a6:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8005aa:	eb d0                	jmp    80057c <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8005ac:	0f b6 d2             	movzbl %dl,%edx
  8005af:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8005b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8005b7:	89 75 08             	mov    %esi,0x8(%ebp)
  8005ba:	eb 03                	jmp    8005bf <vprintfmt+0x86>
  8005bc:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8005bf:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8005c2:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8005c6:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8005c9:	8d 72 d0             	lea    -0x30(%edx),%esi
  8005cc:	83 fe 09             	cmp    $0x9,%esi
  8005cf:	76 eb                	jbe    8005bc <vprintfmt+0x83>
  8005d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d4:	8b 75 08             	mov    0x8(%ebp),%esi
  8005d7:	eb 14                	jmp    8005ed <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8005d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005dc:	8b 00                	mov    (%eax),%eax
  8005de:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e4:	8d 40 04             	lea    0x4(%eax),%eax
  8005e7:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005ea:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8005ed:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005f1:	79 89                	jns    80057c <vprintfmt+0x43>
				width = precision, precision = -1;
  8005f3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005f9:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800600:	e9 77 ff ff ff       	jmp    80057c <vprintfmt+0x43>
  800605:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800608:	85 c0                	test   %eax,%eax
  80060a:	0f 48 c1             	cmovs  %ecx,%eax
  80060d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800610:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800613:	e9 64 ff ff ff       	jmp    80057c <vprintfmt+0x43>
  800618:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80061b:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800622:	e9 55 ff ff ff       	jmp    80057c <vprintfmt+0x43>
			lflag++;
  800627:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80062b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80062e:	e9 49 ff ff ff       	jmp    80057c <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800633:	8b 45 14             	mov    0x14(%ebp),%eax
  800636:	8d 78 04             	lea    0x4(%eax),%edi
  800639:	83 ec 08             	sub    $0x8,%esp
  80063c:	53                   	push   %ebx
  80063d:	ff 30                	pushl  (%eax)
  80063f:	ff d6                	call   *%esi
			break;
  800641:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800644:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800647:	e9 33 03 00 00       	jmp    80097f <vprintfmt+0x446>
			err = va_arg(ap, int);
  80064c:	8b 45 14             	mov    0x14(%ebp),%eax
  80064f:	8d 78 04             	lea    0x4(%eax),%edi
  800652:	8b 00                	mov    (%eax),%eax
  800654:	99                   	cltd   
  800655:	31 d0                	xor    %edx,%eax
  800657:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800659:	83 f8 10             	cmp    $0x10,%eax
  80065c:	7f 23                	jg     800681 <vprintfmt+0x148>
  80065e:	8b 14 85 a0 2b 80 00 	mov    0x802ba0(,%eax,4),%edx
  800665:	85 d2                	test   %edx,%edx
  800667:	74 18                	je     800681 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800669:	52                   	push   %edx
  80066a:	68 cd 2c 80 00       	push   $0x802ccd
  80066f:	53                   	push   %ebx
  800670:	56                   	push   %esi
  800671:	e8 a6 fe ff ff       	call   80051c <printfmt>
  800676:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800679:	89 7d 14             	mov    %edi,0x14(%ebp)
  80067c:	e9 fe 02 00 00       	jmp    80097f <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800681:	50                   	push   %eax
  800682:	68 83 28 80 00       	push   $0x802883
  800687:	53                   	push   %ebx
  800688:	56                   	push   %esi
  800689:	e8 8e fe ff ff       	call   80051c <printfmt>
  80068e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800691:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800694:	e9 e6 02 00 00       	jmp    80097f <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800699:	8b 45 14             	mov    0x14(%ebp),%eax
  80069c:	83 c0 04             	add    $0x4,%eax
  80069f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8006a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a5:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8006a7:	85 c9                	test   %ecx,%ecx
  8006a9:	b8 7c 28 80 00       	mov    $0x80287c,%eax
  8006ae:	0f 45 c1             	cmovne %ecx,%eax
  8006b1:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8006b4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006b8:	7e 06                	jle    8006c0 <vprintfmt+0x187>
  8006ba:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8006be:	75 0d                	jne    8006cd <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006c0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8006c3:	89 c7                	mov    %eax,%edi
  8006c5:	03 45 e0             	add    -0x20(%ebp),%eax
  8006c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006cb:	eb 53                	jmp    800720 <vprintfmt+0x1e7>
  8006cd:	83 ec 08             	sub    $0x8,%esp
  8006d0:	ff 75 d8             	pushl  -0x28(%ebp)
  8006d3:	50                   	push   %eax
  8006d4:	e8 61 05 00 00       	call   800c3a <strnlen>
  8006d9:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006dc:	29 c1                	sub    %eax,%ecx
  8006de:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8006e1:	83 c4 10             	add    $0x10,%esp
  8006e4:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8006e6:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8006ea:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8006ed:	eb 0f                	jmp    8006fe <vprintfmt+0x1c5>
					putch(padc, putdat);
  8006ef:	83 ec 08             	sub    $0x8,%esp
  8006f2:	53                   	push   %ebx
  8006f3:	ff 75 e0             	pushl  -0x20(%ebp)
  8006f6:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006f8:	83 ef 01             	sub    $0x1,%edi
  8006fb:	83 c4 10             	add    $0x10,%esp
  8006fe:	85 ff                	test   %edi,%edi
  800700:	7f ed                	jg     8006ef <vprintfmt+0x1b6>
  800702:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800705:	85 c9                	test   %ecx,%ecx
  800707:	b8 00 00 00 00       	mov    $0x0,%eax
  80070c:	0f 49 c1             	cmovns %ecx,%eax
  80070f:	29 c1                	sub    %eax,%ecx
  800711:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800714:	eb aa                	jmp    8006c0 <vprintfmt+0x187>
					putch(ch, putdat);
  800716:	83 ec 08             	sub    $0x8,%esp
  800719:	53                   	push   %ebx
  80071a:	52                   	push   %edx
  80071b:	ff d6                	call   *%esi
  80071d:	83 c4 10             	add    $0x10,%esp
  800720:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800723:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800725:	83 c7 01             	add    $0x1,%edi
  800728:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80072c:	0f be d0             	movsbl %al,%edx
  80072f:	85 d2                	test   %edx,%edx
  800731:	74 4b                	je     80077e <vprintfmt+0x245>
  800733:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800737:	78 06                	js     80073f <vprintfmt+0x206>
  800739:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80073d:	78 1e                	js     80075d <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  80073f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800743:	74 d1                	je     800716 <vprintfmt+0x1dd>
  800745:	0f be c0             	movsbl %al,%eax
  800748:	83 e8 20             	sub    $0x20,%eax
  80074b:	83 f8 5e             	cmp    $0x5e,%eax
  80074e:	76 c6                	jbe    800716 <vprintfmt+0x1dd>
					putch('?', putdat);
  800750:	83 ec 08             	sub    $0x8,%esp
  800753:	53                   	push   %ebx
  800754:	6a 3f                	push   $0x3f
  800756:	ff d6                	call   *%esi
  800758:	83 c4 10             	add    $0x10,%esp
  80075b:	eb c3                	jmp    800720 <vprintfmt+0x1e7>
  80075d:	89 cf                	mov    %ecx,%edi
  80075f:	eb 0e                	jmp    80076f <vprintfmt+0x236>
				putch(' ', putdat);
  800761:	83 ec 08             	sub    $0x8,%esp
  800764:	53                   	push   %ebx
  800765:	6a 20                	push   $0x20
  800767:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800769:	83 ef 01             	sub    $0x1,%edi
  80076c:	83 c4 10             	add    $0x10,%esp
  80076f:	85 ff                	test   %edi,%edi
  800771:	7f ee                	jg     800761 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800773:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800776:	89 45 14             	mov    %eax,0x14(%ebp)
  800779:	e9 01 02 00 00       	jmp    80097f <vprintfmt+0x446>
  80077e:	89 cf                	mov    %ecx,%edi
  800780:	eb ed                	jmp    80076f <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800782:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800785:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  80078c:	e9 eb fd ff ff       	jmp    80057c <vprintfmt+0x43>
	if (lflag >= 2)
  800791:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800795:	7f 21                	jg     8007b8 <vprintfmt+0x27f>
	else if (lflag)
  800797:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80079b:	74 68                	je     800805 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80079d:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a0:	8b 00                	mov    (%eax),%eax
  8007a2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8007a5:	89 c1                	mov    %eax,%ecx
  8007a7:	c1 f9 1f             	sar    $0x1f,%ecx
  8007aa:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8007ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b0:	8d 40 04             	lea    0x4(%eax),%eax
  8007b3:	89 45 14             	mov    %eax,0x14(%ebp)
  8007b6:	eb 17                	jmp    8007cf <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8007b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bb:	8b 50 04             	mov    0x4(%eax),%edx
  8007be:	8b 00                	mov    (%eax),%eax
  8007c0:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8007c3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8007c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c9:	8d 40 08             	lea    0x8(%eax),%eax
  8007cc:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8007cf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007d2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8007d5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d8:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8007db:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8007df:	78 3f                	js     800820 <vprintfmt+0x2e7>
			base = 10;
  8007e1:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8007e6:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8007ea:	0f 84 71 01 00 00    	je     800961 <vprintfmt+0x428>
				putch('+', putdat);
  8007f0:	83 ec 08             	sub    $0x8,%esp
  8007f3:	53                   	push   %ebx
  8007f4:	6a 2b                	push   $0x2b
  8007f6:	ff d6                	call   *%esi
  8007f8:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007fb:	b8 0a 00 00 00       	mov    $0xa,%eax
  800800:	e9 5c 01 00 00       	jmp    800961 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800805:	8b 45 14             	mov    0x14(%ebp),%eax
  800808:	8b 00                	mov    (%eax),%eax
  80080a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80080d:	89 c1                	mov    %eax,%ecx
  80080f:	c1 f9 1f             	sar    $0x1f,%ecx
  800812:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800815:	8b 45 14             	mov    0x14(%ebp),%eax
  800818:	8d 40 04             	lea    0x4(%eax),%eax
  80081b:	89 45 14             	mov    %eax,0x14(%ebp)
  80081e:	eb af                	jmp    8007cf <vprintfmt+0x296>
				putch('-', putdat);
  800820:	83 ec 08             	sub    $0x8,%esp
  800823:	53                   	push   %ebx
  800824:	6a 2d                	push   $0x2d
  800826:	ff d6                	call   *%esi
				num = -(long long) num;
  800828:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80082b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80082e:	f7 d8                	neg    %eax
  800830:	83 d2 00             	adc    $0x0,%edx
  800833:	f7 da                	neg    %edx
  800835:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800838:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80083b:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80083e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800843:	e9 19 01 00 00       	jmp    800961 <vprintfmt+0x428>
	if (lflag >= 2)
  800848:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80084c:	7f 29                	jg     800877 <vprintfmt+0x33e>
	else if (lflag)
  80084e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800852:	74 44                	je     800898 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800854:	8b 45 14             	mov    0x14(%ebp),%eax
  800857:	8b 00                	mov    (%eax),%eax
  800859:	ba 00 00 00 00       	mov    $0x0,%edx
  80085e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800861:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800864:	8b 45 14             	mov    0x14(%ebp),%eax
  800867:	8d 40 04             	lea    0x4(%eax),%eax
  80086a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80086d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800872:	e9 ea 00 00 00       	jmp    800961 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800877:	8b 45 14             	mov    0x14(%ebp),%eax
  80087a:	8b 50 04             	mov    0x4(%eax),%edx
  80087d:	8b 00                	mov    (%eax),%eax
  80087f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800882:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800885:	8b 45 14             	mov    0x14(%ebp),%eax
  800888:	8d 40 08             	lea    0x8(%eax),%eax
  80088b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80088e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800893:	e9 c9 00 00 00       	jmp    800961 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800898:	8b 45 14             	mov    0x14(%ebp),%eax
  80089b:	8b 00                	mov    (%eax),%eax
  80089d:	ba 00 00 00 00       	mov    $0x0,%edx
  8008a2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008a5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ab:	8d 40 04             	lea    0x4(%eax),%eax
  8008ae:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008b1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008b6:	e9 a6 00 00 00       	jmp    800961 <vprintfmt+0x428>
			putch('0', putdat);
  8008bb:	83 ec 08             	sub    $0x8,%esp
  8008be:	53                   	push   %ebx
  8008bf:	6a 30                	push   $0x30
  8008c1:	ff d6                	call   *%esi
	if (lflag >= 2)
  8008c3:	83 c4 10             	add    $0x10,%esp
  8008c6:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8008ca:	7f 26                	jg     8008f2 <vprintfmt+0x3b9>
	else if (lflag)
  8008cc:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8008d0:	74 3e                	je     800910 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8008d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d5:	8b 00                	mov    (%eax),%eax
  8008d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8008dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008df:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e5:	8d 40 04             	lea    0x4(%eax),%eax
  8008e8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008eb:	b8 08 00 00 00       	mov    $0x8,%eax
  8008f0:	eb 6f                	jmp    800961 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8008f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f5:	8b 50 04             	mov    0x4(%eax),%edx
  8008f8:	8b 00                	mov    (%eax),%eax
  8008fa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008fd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800900:	8b 45 14             	mov    0x14(%ebp),%eax
  800903:	8d 40 08             	lea    0x8(%eax),%eax
  800906:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800909:	b8 08 00 00 00       	mov    $0x8,%eax
  80090e:	eb 51                	jmp    800961 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800910:	8b 45 14             	mov    0x14(%ebp),%eax
  800913:	8b 00                	mov    (%eax),%eax
  800915:	ba 00 00 00 00       	mov    $0x0,%edx
  80091a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80091d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800920:	8b 45 14             	mov    0x14(%ebp),%eax
  800923:	8d 40 04             	lea    0x4(%eax),%eax
  800926:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800929:	b8 08 00 00 00       	mov    $0x8,%eax
  80092e:	eb 31                	jmp    800961 <vprintfmt+0x428>
			putch('0', putdat);
  800930:	83 ec 08             	sub    $0x8,%esp
  800933:	53                   	push   %ebx
  800934:	6a 30                	push   $0x30
  800936:	ff d6                	call   *%esi
			putch('x', putdat);
  800938:	83 c4 08             	add    $0x8,%esp
  80093b:	53                   	push   %ebx
  80093c:	6a 78                	push   $0x78
  80093e:	ff d6                	call   *%esi
			num = (unsigned long long)
  800940:	8b 45 14             	mov    0x14(%ebp),%eax
  800943:	8b 00                	mov    (%eax),%eax
  800945:	ba 00 00 00 00       	mov    $0x0,%edx
  80094a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80094d:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800950:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800953:	8b 45 14             	mov    0x14(%ebp),%eax
  800956:	8d 40 04             	lea    0x4(%eax),%eax
  800959:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80095c:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800961:	83 ec 0c             	sub    $0xc,%esp
  800964:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800968:	52                   	push   %edx
  800969:	ff 75 e0             	pushl  -0x20(%ebp)
  80096c:	50                   	push   %eax
  80096d:	ff 75 dc             	pushl  -0x24(%ebp)
  800970:	ff 75 d8             	pushl  -0x28(%ebp)
  800973:	89 da                	mov    %ebx,%edx
  800975:	89 f0                	mov    %esi,%eax
  800977:	e8 a4 fa ff ff       	call   800420 <printnum>
			break;
  80097c:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80097f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800982:	83 c7 01             	add    $0x1,%edi
  800985:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800989:	83 f8 25             	cmp    $0x25,%eax
  80098c:	0f 84 be fb ff ff    	je     800550 <vprintfmt+0x17>
			if (ch == '\0')
  800992:	85 c0                	test   %eax,%eax
  800994:	0f 84 28 01 00 00    	je     800ac2 <vprintfmt+0x589>
			putch(ch, putdat);
  80099a:	83 ec 08             	sub    $0x8,%esp
  80099d:	53                   	push   %ebx
  80099e:	50                   	push   %eax
  80099f:	ff d6                	call   *%esi
  8009a1:	83 c4 10             	add    $0x10,%esp
  8009a4:	eb dc                	jmp    800982 <vprintfmt+0x449>
	if (lflag >= 2)
  8009a6:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8009aa:	7f 26                	jg     8009d2 <vprintfmt+0x499>
	else if (lflag)
  8009ac:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8009b0:	74 41                	je     8009f3 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8009b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b5:	8b 00                	mov    (%eax),%eax
  8009b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8009bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009bf:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c5:	8d 40 04             	lea    0x4(%eax),%eax
  8009c8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009cb:	b8 10 00 00 00       	mov    $0x10,%eax
  8009d0:	eb 8f                	jmp    800961 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8009d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d5:	8b 50 04             	mov    0x4(%eax),%edx
  8009d8:	8b 00                	mov    (%eax),%eax
  8009da:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009dd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e3:	8d 40 08             	lea    0x8(%eax),%eax
  8009e6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009e9:	b8 10 00 00 00       	mov    $0x10,%eax
  8009ee:	e9 6e ff ff ff       	jmp    800961 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8009f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f6:	8b 00                	mov    (%eax),%eax
  8009f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8009fd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a00:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a03:	8b 45 14             	mov    0x14(%ebp),%eax
  800a06:	8d 40 04             	lea    0x4(%eax),%eax
  800a09:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a0c:	b8 10 00 00 00       	mov    $0x10,%eax
  800a11:	e9 4b ff ff ff       	jmp    800961 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800a16:	8b 45 14             	mov    0x14(%ebp),%eax
  800a19:	83 c0 04             	add    $0x4,%eax
  800a1c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a22:	8b 00                	mov    (%eax),%eax
  800a24:	85 c0                	test   %eax,%eax
  800a26:	74 14                	je     800a3c <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800a28:	8b 13                	mov    (%ebx),%edx
  800a2a:	83 fa 7f             	cmp    $0x7f,%edx
  800a2d:	7f 37                	jg     800a66 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800a2f:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800a31:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a34:	89 45 14             	mov    %eax,0x14(%ebp)
  800a37:	e9 43 ff ff ff       	jmp    80097f <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800a3c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a41:	bf a1 29 80 00       	mov    $0x8029a1,%edi
							putch(ch, putdat);
  800a46:	83 ec 08             	sub    $0x8,%esp
  800a49:	53                   	push   %ebx
  800a4a:	50                   	push   %eax
  800a4b:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800a4d:	83 c7 01             	add    $0x1,%edi
  800a50:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800a54:	83 c4 10             	add    $0x10,%esp
  800a57:	85 c0                	test   %eax,%eax
  800a59:	75 eb                	jne    800a46 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800a5b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a5e:	89 45 14             	mov    %eax,0x14(%ebp)
  800a61:	e9 19 ff ff ff       	jmp    80097f <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800a66:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800a68:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a6d:	bf d9 29 80 00       	mov    $0x8029d9,%edi
							putch(ch, putdat);
  800a72:	83 ec 08             	sub    $0x8,%esp
  800a75:	53                   	push   %ebx
  800a76:	50                   	push   %eax
  800a77:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800a79:	83 c7 01             	add    $0x1,%edi
  800a7c:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800a80:	83 c4 10             	add    $0x10,%esp
  800a83:	85 c0                	test   %eax,%eax
  800a85:	75 eb                	jne    800a72 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800a87:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a8a:	89 45 14             	mov    %eax,0x14(%ebp)
  800a8d:	e9 ed fe ff ff       	jmp    80097f <vprintfmt+0x446>
			putch(ch, putdat);
  800a92:	83 ec 08             	sub    $0x8,%esp
  800a95:	53                   	push   %ebx
  800a96:	6a 25                	push   $0x25
  800a98:	ff d6                	call   *%esi
			break;
  800a9a:	83 c4 10             	add    $0x10,%esp
  800a9d:	e9 dd fe ff ff       	jmp    80097f <vprintfmt+0x446>
			putch('%', putdat);
  800aa2:	83 ec 08             	sub    $0x8,%esp
  800aa5:	53                   	push   %ebx
  800aa6:	6a 25                	push   $0x25
  800aa8:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800aaa:	83 c4 10             	add    $0x10,%esp
  800aad:	89 f8                	mov    %edi,%eax
  800aaf:	eb 03                	jmp    800ab4 <vprintfmt+0x57b>
  800ab1:	83 e8 01             	sub    $0x1,%eax
  800ab4:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800ab8:	75 f7                	jne    800ab1 <vprintfmt+0x578>
  800aba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800abd:	e9 bd fe ff ff       	jmp    80097f <vprintfmt+0x446>
}
  800ac2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ac5:	5b                   	pop    %ebx
  800ac6:	5e                   	pop    %esi
  800ac7:	5f                   	pop    %edi
  800ac8:	5d                   	pop    %ebp
  800ac9:	c3                   	ret    

00800aca <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800aca:	55                   	push   %ebp
  800acb:	89 e5                	mov    %esp,%ebp
  800acd:	83 ec 18             	sub    $0x18,%esp
  800ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad3:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ad6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ad9:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800add:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800ae0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ae7:	85 c0                	test   %eax,%eax
  800ae9:	74 26                	je     800b11 <vsnprintf+0x47>
  800aeb:	85 d2                	test   %edx,%edx
  800aed:	7e 22                	jle    800b11 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800aef:	ff 75 14             	pushl  0x14(%ebp)
  800af2:	ff 75 10             	pushl  0x10(%ebp)
  800af5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800af8:	50                   	push   %eax
  800af9:	68 ff 04 80 00       	push   $0x8004ff
  800afe:	e8 36 fa ff ff       	call   800539 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b06:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b0c:	83 c4 10             	add    $0x10,%esp
}
  800b0f:	c9                   	leave  
  800b10:	c3                   	ret    
		return -E_INVAL;
  800b11:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b16:	eb f7                	jmp    800b0f <vsnprintf+0x45>

00800b18 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b18:	55                   	push   %ebp
  800b19:	89 e5                	mov    %esp,%ebp
  800b1b:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b1e:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800b21:	50                   	push   %eax
  800b22:	ff 75 10             	pushl  0x10(%ebp)
  800b25:	ff 75 0c             	pushl  0xc(%ebp)
  800b28:	ff 75 08             	pushl  0x8(%ebp)
  800b2b:	e8 9a ff ff ff       	call   800aca <vsnprintf>
	va_end(ap);

	return rc;
}
  800b30:	c9                   	leave  
  800b31:	c3                   	ret    

00800b32 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  800b32:	55                   	push   %ebp
  800b33:	89 e5                	mov    %esp,%ebp
  800b35:	57                   	push   %edi
  800b36:	56                   	push   %esi
  800b37:	53                   	push   %ebx
  800b38:	83 ec 0c             	sub    $0xc,%esp
  800b3b:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  800b3e:	85 c0                	test   %eax,%eax
  800b40:	74 13                	je     800b55 <readline+0x23>
		fprintf(1, "%s", prompt);
  800b42:	83 ec 04             	sub    $0x4,%esp
  800b45:	50                   	push   %eax
  800b46:	68 cd 2c 80 00       	push   $0x802ccd
  800b4b:	6a 01                	push   $0x1
  800b4d:	e8 e3 10 00 00       	call   801c35 <fprintf>
  800b52:	83 c4 10             	add    $0x10,%esp
#endif

	i = 0;
	echoing = iscons(0);
  800b55:	83 ec 0c             	sub    $0xc,%esp
  800b58:	6a 00                	push   $0x0
  800b5a:	e8 7d f6 ff ff       	call   8001dc <iscons>
  800b5f:	89 c7                	mov    %eax,%edi
  800b61:	83 c4 10             	add    $0x10,%esp
	i = 0;
  800b64:	be 00 00 00 00       	mov    $0x0,%esi
  800b69:	eb 57                	jmp    800bc2 <readline+0x90>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
  800b6b:	b8 00 00 00 00       	mov    $0x0,%eax
			if (c != -E_EOF)
  800b70:	83 fb f8             	cmp    $0xfffffff8,%ebx
  800b73:	75 08                	jne    800b7d <readline+0x4b>
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
  800b75:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b78:	5b                   	pop    %ebx
  800b79:	5e                   	pop    %esi
  800b7a:	5f                   	pop    %edi
  800b7b:	5d                   	pop    %ebp
  800b7c:	c3                   	ret    
				cprintf("read error: %e\n", c);
  800b7d:	83 ec 08             	sub    $0x8,%esp
  800b80:	53                   	push   %ebx
  800b81:	68 e4 2b 80 00       	push   $0x802be4
  800b86:	e8 81 f8 ff ff       	call   80040c <cprintf>
  800b8b:	83 c4 10             	add    $0x10,%esp
			return NULL;
  800b8e:	b8 00 00 00 00       	mov    $0x0,%eax
  800b93:	eb e0                	jmp    800b75 <readline+0x43>
			if (echoing)
  800b95:	85 ff                	test   %edi,%edi
  800b97:	75 05                	jne    800b9e <readline+0x6c>
			i--;
  800b99:	83 ee 01             	sub    $0x1,%esi
  800b9c:	eb 24                	jmp    800bc2 <readline+0x90>
				cputchar('\b');
  800b9e:	83 ec 0c             	sub    $0xc,%esp
  800ba1:	6a 08                	push   $0x8
  800ba3:	e8 ef f5 ff ff       	call   800197 <cputchar>
  800ba8:	83 c4 10             	add    $0x10,%esp
  800bab:	eb ec                	jmp    800b99 <readline+0x67>
				cputchar(c);
  800bad:	83 ec 0c             	sub    $0xc,%esp
  800bb0:	53                   	push   %ebx
  800bb1:	e8 e1 f5 ff ff       	call   800197 <cputchar>
  800bb6:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800bb9:	88 9e 00 40 80 00    	mov    %bl,0x804000(%esi)
  800bbf:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
  800bc2:	e8 ec f5 ff ff       	call   8001b3 <getchar>
  800bc7:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  800bc9:	85 c0                	test   %eax,%eax
  800bcb:	78 9e                	js     800b6b <readline+0x39>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  800bcd:	83 f8 08             	cmp    $0x8,%eax
  800bd0:	0f 94 c2             	sete   %dl
  800bd3:	83 f8 7f             	cmp    $0x7f,%eax
  800bd6:	0f 94 c0             	sete   %al
  800bd9:	08 c2                	or     %al,%dl
  800bdb:	74 04                	je     800be1 <readline+0xaf>
  800bdd:	85 f6                	test   %esi,%esi
  800bdf:	7f b4                	jg     800b95 <readline+0x63>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800be1:	83 fb 1f             	cmp    $0x1f,%ebx
  800be4:	7e 0e                	jle    800bf4 <readline+0xc2>
  800be6:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  800bec:	7f 06                	jg     800bf4 <readline+0xc2>
			if (echoing)
  800bee:	85 ff                	test   %edi,%edi
  800bf0:	74 c7                	je     800bb9 <readline+0x87>
  800bf2:	eb b9                	jmp    800bad <readline+0x7b>
		} else if (c == '\n' || c == '\r') {
  800bf4:	83 fb 0a             	cmp    $0xa,%ebx
  800bf7:	74 05                	je     800bfe <readline+0xcc>
  800bf9:	83 fb 0d             	cmp    $0xd,%ebx
  800bfc:	75 c4                	jne    800bc2 <readline+0x90>
			if (echoing)
  800bfe:	85 ff                	test   %edi,%edi
  800c00:	75 11                	jne    800c13 <readline+0xe1>
			buf[i] = 0;
  800c02:	c6 86 00 40 80 00 00 	movb   $0x0,0x804000(%esi)
			return buf;
  800c09:	b8 00 40 80 00       	mov    $0x804000,%eax
  800c0e:	e9 62 ff ff ff       	jmp    800b75 <readline+0x43>
				cputchar('\n');
  800c13:	83 ec 0c             	sub    $0xc,%esp
  800c16:	6a 0a                	push   $0xa
  800c18:	e8 7a f5 ff ff       	call   800197 <cputchar>
  800c1d:	83 c4 10             	add    $0x10,%esp
  800c20:	eb e0                	jmp    800c02 <readline+0xd0>

00800c22 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800c22:	55                   	push   %ebp
  800c23:	89 e5                	mov    %esp,%ebp
  800c25:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800c28:	b8 00 00 00 00       	mov    $0x0,%eax
  800c2d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800c31:	74 05                	je     800c38 <strlen+0x16>
		n++;
  800c33:	83 c0 01             	add    $0x1,%eax
  800c36:	eb f5                	jmp    800c2d <strlen+0xb>
	return n;
}
  800c38:	5d                   	pop    %ebp
  800c39:	c3                   	ret    

00800c3a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800c3a:	55                   	push   %ebp
  800c3b:	89 e5                	mov    %esp,%ebp
  800c3d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c40:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c43:	ba 00 00 00 00       	mov    $0x0,%edx
  800c48:	39 c2                	cmp    %eax,%edx
  800c4a:	74 0d                	je     800c59 <strnlen+0x1f>
  800c4c:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800c50:	74 05                	je     800c57 <strnlen+0x1d>
		n++;
  800c52:	83 c2 01             	add    $0x1,%edx
  800c55:	eb f1                	jmp    800c48 <strnlen+0xe>
  800c57:	89 d0                	mov    %edx,%eax
	return n;
}
  800c59:	5d                   	pop    %ebp
  800c5a:	c3                   	ret    

00800c5b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c5b:	55                   	push   %ebp
  800c5c:	89 e5                	mov    %esp,%ebp
  800c5e:	53                   	push   %ebx
  800c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c62:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800c65:	ba 00 00 00 00       	mov    $0x0,%edx
  800c6a:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800c6e:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800c71:	83 c2 01             	add    $0x1,%edx
  800c74:	84 c9                	test   %cl,%cl
  800c76:	75 f2                	jne    800c6a <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800c78:	5b                   	pop    %ebx
  800c79:	5d                   	pop    %ebp
  800c7a:	c3                   	ret    

00800c7b <strcat>:

char *
strcat(char *dst, const char *src)
{
  800c7b:	55                   	push   %ebp
  800c7c:	89 e5                	mov    %esp,%ebp
  800c7e:	53                   	push   %ebx
  800c7f:	83 ec 10             	sub    $0x10,%esp
  800c82:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800c85:	53                   	push   %ebx
  800c86:	e8 97 ff ff ff       	call   800c22 <strlen>
  800c8b:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800c8e:	ff 75 0c             	pushl  0xc(%ebp)
  800c91:	01 d8                	add    %ebx,%eax
  800c93:	50                   	push   %eax
  800c94:	e8 c2 ff ff ff       	call   800c5b <strcpy>
	return dst;
}
  800c99:	89 d8                	mov    %ebx,%eax
  800c9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c9e:	c9                   	leave  
  800c9f:	c3                   	ret    

00800ca0 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800ca0:	55                   	push   %ebp
  800ca1:	89 e5                	mov    %esp,%ebp
  800ca3:	56                   	push   %esi
  800ca4:	53                   	push   %ebx
  800ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cab:	89 c6                	mov    %eax,%esi
  800cad:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cb0:	89 c2                	mov    %eax,%edx
  800cb2:	39 f2                	cmp    %esi,%edx
  800cb4:	74 11                	je     800cc7 <strncpy+0x27>
		*dst++ = *src;
  800cb6:	83 c2 01             	add    $0x1,%edx
  800cb9:	0f b6 19             	movzbl (%ecx),%ebx
  800cbc:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800cbf:	80 fb 01             	cmp    $0x1,%bl
  800cc2:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800cc5:	eb eb                	jmp    800cb2 <strncpy+0x12>
	}
	return ret;
}
  800cc7:	5b                   	pop    %ebx
  800cc8:	5e                   	pop    %esi
  800cc9:	5d                   	pop    %ebp
  800cca:	c3                   	ret    

00800ccb <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ccb:	55                   	push   %ebp
  800ccc:	89 e5                	mov    %esp,%ebp
  800cce:	56                   	push   %esi
  800ccf:	53                   	push   %ebx
  800cd0:	8b 75 08             	mov    0x8(%ebp),%esi
  800cd3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd6:	8b 55 10             	mov    0x10(%ebp),%edx
  800cd9:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800cdb:	85 d2                	test   %edx,%edx
  800cdd:	74 21                	je     800d00 <strlcpy+0x35>
  800cdf:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800ce3:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800ce5:	39 c2                	cmp    %eax,%edx
  800ce7:	74 14                	je     800cfd <strlcpy+0x32>
  800ce9:	0f b6 19             	movzbl (%ecx),%ebx
  800cec:	84 db                	test   %bl,%bl
  800cee:	74 0b                	je     800cfb <strlcpy+0x30>
			*dst++ = *src++;
  800cf0:	83 c1 01             	add    $0x1,%ecx
  800cf3:	83 c2 01             	add    $0x1,%edx
  800cf6:	88 5a ff             	mov    %bl,-0x1(%edx)
  800cf9:	eb ea                	jmp    800ce5 <strlcpy+0x1a>
  800cfb:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800cfd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d00:	29 f0                	sub    %esi,%eax
}
  800d02:	5b                   	pop    %ebx
  800d03:	5e                   	pop    %esi
  800d04:	5d                   	pop    %ebp
  800d05:	c3                   	ret    

00800d06 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d06:	55                   	push   %ebp
  800d07:	89 e5                	mov    %esp,%ebp
  800d09:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d0c:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800d0f:	0f b6 01             	movzbl (%ecx),%eax
  800d12:	84 c0                	test   %al,%al
  800d14:	74 0c                	je     800d22 <strcmp+0x1c>
  800d16:	3a 02                	cmp    (%edx),%al
  800d18:	75 08                	jne    800d22 <strcmp+0x1c>
		p++, q++;
  800d1a:	83 c1 01             	add    $0x1,%ecx
  800d1d:	83 c2 01             	add    $0x1,%edx
  800d20:	eb ed                	jmp    800d0f <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d22:	0f b6 c0             	movzbl %al,%eax
  800d25:	0f b6 12             	movzbl (%edx),%edx
  800d28:	29 d0                	sub    %edx,%eax
}
  800d2a:	5d                   	pop    %ebp
  800d2b:	c3                   	ret    

00800d2c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800d2c:	55                   	push   %ebp
  800d2d:	89 e5                	mov    %esp,%ebp
  800d2f:	53                   	push   %ebx
  800d30:	8b 45 08             	mov    0x8(%ebp),%eax
  800d33:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d36:	89 c3                	mov    %eax,%ebx
  800d38:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800d3b:	eb 06                	jmp    800d43 <strncmp+0x17>
		n--, p++, q++;
  800d3d:	83 c0 01             	add    $0x1,%eax
  800d40:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800d43:	39 d8                	cmp    %ebx,%eax
  800d45:	74 16                	je     800d5d <strncmp+0x31>
  800d47:	0f b6 08             	movzbl (%eax),%ecx
  800d4a:	84 c9                	test   %cl,%cl
  800d4c:	74 04                	je     800d52 <strncmp+0x26>
  800d4e:	3a 0a                	cmp    (%edx),%cl
  800d50:	74 eb                	je     800d3d <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d52:	0f b6 00             	movzbl (%eax),%eax
  800d55:	0f b6 12             	movzbl (%edx),%edx
  800d58:	29 d0                	sub    %edx,%eax
}
  800d5a:	5b                   	pop    %ebx
  800d5b:	5d                   	pop    %ebp
  800d5c:	c3                   	ret    
		return 0;
  800d5d:	b8 00 00 00 00       	mov    $0x0,%eax
  800d62:	eb f6                	jmp    800d5a <strncmp+0x2e>

00800d64 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d64:	55                   	push   %ebp
  800d65:	89 e5                	mov    %esp,%ebp
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d6e:	0f b6 10             	movzbl (%eax),%edx
  800d71:	84 d2                	test   %dl,%dl
  800d73:	74 09                	je     800d7e <strchr+0x1a>
		if (*s == c)
  800d75:	38 ca                	cmp    %cl,%dl
  800d77:	74 0a                	je     800d83 <strchr+0x1f>
	for (; *s; s++)
  800d79:	83 c0 01             	add    $0x1,%eax
  800d7c:	eb f0                	jmp    800d6e <strchr+0xa>
			return (char *) s;
	return 0;
  800d7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d83:	5d                   	pop    %ebp
  800d84:	c3                   	ret    

00800d85 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d85:	55                   	push   %ebp
  800d86:	89 e5                	mov    %esp,%ebp
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d8f:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800d92:	38 ca                	cmp    %cl,%dl
  800d94:	74 09                	je     800d9f <strfind+0x1a>
  800d96:	84 d2                	test   %dl,%dl
  800d98:	74 05                	je     800d9f <strfind+0x1a>
	for (; *s; s++)
  800d9a:	83 c0 01             	add    $0x1,%eax
  800d9d:	eb f0                	jmp    800d8f <strfind+0xa>
			break;
	return (char *) s;
}
  800d9f:	5d                   	pop    %ebp
  800da0:	c3                   	ret    

00800da1 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800da1:	55                   	push   %ebp
  800da2:	89 e5                	mov    %esp,%ebp
  800da4:	57                   	push   %edi
  800da5:	56                   	push   %esi
  800da6:	53                   	push   %ebx
  800da7:	8b 7d 08             	mov    0x8(%ebp),%edi
  800daa:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800dad:	85 c9                	test   %ecx,%ecx
  800daf:	74 31                	je     800de2 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800db1:	89 f8                	mov    %edi,%eax
  800db3:	09 c8                	or     %ecx,%eax
  800db5:	a8 03                	test   $0x3,%al
  800db7:	75 23                	jne    800ddc <memset+0x3b>
		c &= 0xFF;
  800db9:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800dbd:	89 d3                	mov    %edx,%ebx
  800dbf:	c1 e3 08             	shl    $0x8,%ebx
  800dc2:	89 d0                	mov    %edx,%eax
  800dc4:	c1 e0 18             	shl    $0x18,%eax
  800dc7:	89 d6                	mov    %edx,%esi
  800dc9:	c1 e6 10             	shl    $0x10,%esi
  800dcc:	09 f0                	or     %esi,%eax
  800dce:	09 c2                	or     %eax,%edx
  800dd0:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800dd2:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800dd5:	89 d0                	mov    %edx,%eax
  800dd7:	fc                   	cld    
  800dd8:	f3 ab                	rep stos %eax,%es:(%edi)
  800dda:	eb 06                	jmp    800de2 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ddc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddf:	fc                   	cld    
  800de0:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800de2:	89 f8                	mov    %edi,%eax
  800de4:	5b                   	pop    %ebx
  800de5:	5e                   	pop    %esi
  800de6:	5f                   	pop    %edi
  800de7:	5d                   	pop    %ebp
  800de8:	c3                   	ret    

00800de9 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800de9:	55                   	push   %ebp
  800dea:	89 e5                	mov    %esp,%ebp
  800dec:	57                   	push   %edi
  800ded:	56                   	push   %esi
  800dee:	8b 45 08             	mov    0x8(%ebp),%eax
  800df1:	8b 75 0c             	mov    0xc(%ebp),%esi
  800df4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800df7:	39 c6                	cmp    %eax,%esi
  800df9:	73 32                	jae    800e2d <memmove+0x44>
  800dfb:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800dfe:	39 c2                	cmp    %eax,%edx
  800e00:	76 2b                	jbe    800e2d <memmove+0x44>
		s += n;
		d += n;
  800e02:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e05:	89 fe                	mov    %edi,%esi
  800e07:	09 ce                	or     %ecx,%esi
  800e09:	09 d6                	or     %edx,%esi
  800e0b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800e11:	75 0e                	jne    800e21 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800e13:	83 ef 04             	sub    $0x4,%edi
  800e16:	8d 72 fc             	lea    -0x4(%edx),%esi
  800e19:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800e1c:	fd                   	std    
  800e1d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e1f:	eb 09                	jmp    800e2a <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800e21:	83 ef 01             	sub    $0x1,%edi
  800e24:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800e27:	fd                   	std    
  800e28:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800e2a:	fc                   	cld    
  800e2b:	eb 1a                	jmp    800e47 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e2d:	89 c2                	mov    %eax,%edx
  800e2f:	09 ca                	or     %ecx,%edx
  800e31:	09 f2                	or     %esi,%edx
  800e33:	f6 c2 03             	test   $0x3,%dl
  800e36:	75 0a                	jne    800e42 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800e38:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800e3b:	89 c7                	mov    %eax,%edi
  800e3d:	fc                   	cld    
  800e3e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e40:	eb 05                	jmp    800e47 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800e42:	89 c7                	mov    %eax,%edi
  800e44:	fc                   	cld    
  800e45:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800e47:	5e                   	pop    %esi
  800e48:	5f                   	pop    %edi
  800e49:	5d                   	pop    %ebp
  800e4a:	c3                   	ret    

00800e4b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e4b:	55                   	push   %ebp
  800e4c:	89 e5                	mov    %esp,%ebp
  800e4e:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800e51:	ff 75 10             	pushl  0x10(%ebp)
  800e54:	ff 75 0c             	pushl  0xc(%ebp)
  800e57:	ff 75 08             	pushl  0x8(%ebp)
  800e5a:	e8 8a ff ff ff       	call   800de9 <memmove>
}
  800e5f:	c9                   	leave  
  800e60:	c3                   	ret    

00800e61 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e61:	55                   	push   %ebp
  800e62:	89 e5                	mov    %esp,%ebp
  800e64:	56                   	push   %esi
  800e65:	53                   	push   %ebx
  800e66:	8b 45 08             	mov    0x8(%ebp),%eax
  800e69:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e6c:	89 c6                	mov    %eax,%esi
  800e6e:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e71:	39 f0                	cmp    %esi,%eax
  800e73:	74 1c                	je     800e91 <memcmp+0x30>
		if (*s1 != *s2)
  800e75:	0f b6 08             	movzbl (%eax),%ecx
  800e78:	0f b6 1a             	movzbl (%edx),%ebx
  800e7b:	38 d9                	cmp    %bl,%cl
  800e7d:	75 08                	jne    800e87 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800e7f:	83 c0 01             	add    $0x1,%eax
  800e82:	83 c2 01             	add    $0x1,%edx
  800e85:	eb ea                	jmp    800e71 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800e87:	0f b6 c1             	movzbl %cl,%eax
  800e8a:	0f b6 db             	movzbl %bl,%ebx
  800e8d:	29 d8                	sub    %ebx,%eax
  800e8f:	eb 05                	jmp    800e96 <memcmp+0x35>
	}

	return 0;
  800e91:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e96:	5b                   	pop    %ebx
  800e97:	5e                   	pop    %esi
  800e98:	5d                   	pop    %ebp
  800e99:	c3                   	ret    

00800e9a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e9a:	55                   	push   %ebp
  800e9b:	89 e5                	mov    %esp,%ebp
  800e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ea3:	89 c2                	mov    %eax,%edx
  800ea5:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ea8:	39 d0                	cmp    %edx,%eax
  800eaa:	73 09                	jae    800eb5 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800eac:	38 08                	cmp    %cl,(%eax)
  800eae:	74 05                	je     800eb5 <memfind+0x1b>
	for (; s < ends; s++)
  800eb0:	83 c0 01             	add    $0x1,%eax
  800eb3:	eb f3                	jmp    800ea8 <memfind+0xe>
			break;
	return (void *) s;
}
  800eb5:	5d                   	pop    %ebp
  800eb6:	c3                   	ret    

00800eb7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800eb7:	55                   	push   %ebp
  800eb8:	89 e5                	mov    %esp,%ebp
  800eba:	57                   	push   %edi
  800ebb:	56                   	push   %esi
  800ebc:	53                   	push   %ebx
  800ebd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ec0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ec3:	eb 03                	jmp    800ec8 <strtol+0x11>
		s++;
  800ec5:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ec8:	0f b6 01             	movzbl (%ecx),%eax
  800ecb:	3c 20                	cmp    $0x20,%al
  800ecd:	74 f6                	je     800ec5 <strtol+0xe>
  800ecf:	3c 09                	cmp    $0x9,%al
  800ed1:	74 f2                	je     800ec5 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ed3:	3c 2b                	cmp    $0x2b,%al
  800ed5:	74 2a                	je     800f01 <strtol+0x4a>
	int neg = 0;
  800ed7:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800edc:	3c 2d                	cmp    $0x2d,%al
  800ede:	74 2b                	je     800f0b <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ee0:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ee6:	75 0f                	jne    800ef7 <strtol+0x40>
  800ee8:	80 39 30             	cmpb   $0x30,(%ecx)
  800eeb:	74 28                	je     800f15 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800eed:	85 db                	test   %ebx,%ebx
  800eef:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ef4:	0f 44 d8             	cmove  %eax,%ebx
  800ef7:	b8 00 00 00 00       	mov    $0x0,%eax
  800efc:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800eff:	eb 50                	jmp    800f51 <strtol+0x9a>
		s++;
  800f01:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800f04:	bf 00 00 00 00       	mov    $0x0,%edi
  800f09:	eb d5                	jmp    800ee0 <strtol+0x29>
		s++, neg = 1;
  800f0b:	83 c1 01             	add    $0x1,%ecx
  800f0e:	bf 01 00 00 00       	mov    $0x1,%edi
  800f13:	eb cb                	jmp    800ee0 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f15:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800f19:	74 0e                	je     800f29 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800f1b:	85 db                	test   %ebx,%ebx
  800f1d:	75 d8                	jne    800ef7 <strtol+0x40>
		s++, base = 8;
  800f1f:	83 c1 01             	add    $0x1,%ecx
  800f22:	bb 08 00 00 00       	mov    $0x8,%ebx
  800f27:	eb ce                	jmp    800ef7 <strtol+0x40>
		s += 2, base = 16;
  800f29:	83 c1 02             	add    $0x2,%ecx
  800f2c:	bb 10 00 00 00       	mov    $0x10,%ebx
  800f31:	eb c4                	jmp    800ef7 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800f33:	8d 72 9f             	lea    -0x61(%edx),%esi
  800f36:	89 f3                	mov    %esi,%ebx
  800f38:	80 fb 19             	cmp    $0x19,%bl
  800f3b:	77 29                	ja     800f66 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800f3d:	0f be d2             	movsbl %dl,%edx
  800f40:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800f43:	3b 55 10             	cmp    0x10(%ebp),%edx
  800f46:	7d 30                	jge    800f78 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800f48:	83 c1 01             	add    $0x1,%ecx
  800f4b:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f4f:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800f51:	0f b6 11             	movzbl (%ecx),%edx
  800f54:	8d 72 d0             	lea    -0x30(%edx),%esi
  800f57:	89 f3                	mov    %esi,%ebx
  800f59:	80 fb 09             	cmp    $0x9,%bl
  800f5c:	77 d5                	ja     800f33 <strtol+0x7c>
			dig = *s - '0';
  800f5e:	0f be d2             	movsbl %dl,%edx
  800f61:	83 ea 30             	sub    $0x30,%edx
  800f64:	eb dd                	jmp    800f43 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800f66:	8d 72 bf             	lea    -0x41(%edx),%esi
  800f69:	89 f3                	mov    %esi,%ebx
  800f6b:	80 fb 19             	cmp    $0x19,%bl
  800f6e:	77 08                	ja     800f78 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800f70:	0f be d2             	movsbl %dl,%edx
  800f73:	83 ea 37             	sub    $0x37,%edx
  800f76:	eb cb                	jmp    800f43 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800f78:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f7c:	74 05                	je     800f83 <strtol+0xcc>
		*endptr = (char *) s;
  800f7e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f81:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800f83:	89 c2                	mov    %eax,%edx
  800f85:	f7 da                	neg    %edx
  800f87:	85 ff                	test   %edi,%edi
  800f89:	0f 45 c2             	cmovne %edx,%eax
}
  800f8c:	5b                   	pop    %ebx
  800f8d:	5e                   	pop    %esi
  800f8e:	5f                   	pop    %edi
  800f8f:	5d                   	pop    %ebp
  800f90:	c3                   	ret    

00800f91 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800f91:	55                   	push   %ebp
  800f92:	89 e5                	mov    %esp,%ebp
  800f94:	57                   	push   %edi
  800f95:	56                   	push   %esi
  800f96:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f97:	b8 00 00 00 00       	mov    $0x0,%eax
  800f9c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa2:	89 c3                	mov    %eax,%ebx
  800fa4:	89 c7                	mov    %eax,%edi
  800fa6:	89 c6                	mov    %eax,%esi
  800fa8:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800faa:	5b                   	pop    %ebx
  800fab:	5e                   	pop    %esi
  800fac:	5f                   	pop    %edi
  800fad:	5d                   	pop    %ebp
  800fae:	c3                   	ret    

00800faf <sys_cgetc>:

int
sys_cgetc(void)
{
  800faf:	55                   	push   %ebp
  800fb0:	89 e5                	mov    %esp,%ebp
  800fb2:	57                   	push   %edi
  800fb3:	56                   	push   %esi
  800fb4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fb5:	ba 00 00 00 00       	mov    $0x0,%edx
  800fba:	b8 01 00 00 00       	mov    $0x1,%eax
  800fbf:	89 d1                	mov    %edx,%ecx
  800fc1:	89 d3                	mov    %edx,%ebx
  800fc3:	89 d7                	mov    %edx,%edi
  800fc5:	89 d6                	mov    %edx,%esi
  800fc7:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800fc9:	5b                   	pop    %ebx
  800fca:	5e                   	pop    %esi
  800fcb:	5f                   	pop    %edi
  800fcc:	5d                   	pop    %ebp
  800fcd:	c3                   	ret    

00800fce <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800fce:	55                   	push   %ebp
  800fcf:	89 e5                	mov    %esp,%ebp
  800fd1:	57                   	push   %edi
  800fd2:	56                   	push   %esi
  800fd3:	53                   	push   %ebx
  800fd4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fd7:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fdc:	8b 55 08             	mov    0x8(%ebp),%edx
  800fdf:	b8 03 00 00 00       	mov    $0x3,%eax
  800fe4:	89 cb                	mov    %ecx,%ebx
  800fe6:	89 cf                	mov    %ecx,%edi
  800fe8:	89 ce                	mov    %ecx,%esi
  800fea:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fec:	85 c0                	test   %eax,%eax
  800fee:	7f 08                	jg     800ff8 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
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
  800ffc:	6a 03                	push   $0x3
  800ffe:	68 f4 2b 80 00       	push   $0x802bf4
  801003:	6a 43                	push   $0x43
  801005:	68 11 2c 80 00       	push   $0x802c11
  80100a:	e8 07 f3 ff ff       	call   800316 <_panic>

0080100f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80100f:	55                   	push   %ebp
  801010:	89 e5                	mov    %esp,%ebp
  801012:	57                   	push   %edi
  801013:	56                   	push   %esi
  801014:	53                   	push   %ebx
	asm volatile("int %1\n"
  801015:	ba 00 00 00 00       	mov    $0x0,%edx
  80101a:	b8 02 00 00 00       	mov    $0x2,%eax
  80101f:	89 d1                	mov    %edx,%ecx
  801021:	89 d3                	mov    %edx,%ebx
  801023:	89 d7                	mov    %edx,%edi
  801025:	89 d6                	mov    %edx,%esi
  801027:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801029:	5b                   	pop    %ebx
  80102a:	5e                   	pop    %esi
  80102b:	5f                   	pop    %edi
  80102c:	5d                   	pop    %ebp
  80102d:	c3                   	ret    

0080102e <sys_yield>:

void
sys_yield(void)
{
  80102e:	55                   	push   %ebp
  80102f:	89 e5                	mov    %esp,%ebp
  801031:	57                   	push   %edi
  801032:	56                   	push   %esi
  801033:	53                   	push   %ebx
	asm volatile("int %1\n"
  801034:	ba 00 00 00 00       	mov    $0x0,%edx
  801039:	b8 0b 00 00 00       	mov    $0xb,%eax
  80103e:	89 d1                	mov    %edx,%ecx
  801040:	89 d3                	mov    %edx,%ebx
  801042:	89 d7                	mov    %edx,%edi
  801044:	89 d6                	mov    %edx,%esi
  801046:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801048:	5b                   	pop    %ebx
  801049:	5e                   	pop    %esi
  80104a:	5f                   	pop    %edi
  80104b:	5d                   	pop    %ebp
  80104c:	c3                   	ret    

0080104d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80104d:	55                   	push   %ebp
  80104e:	89 e5                	mov    %esp,%ebp
  801050:	57                   	push   %edi
  801051:	56                   	push   %esi
  801052:	53                   	push   %ebx
  801053:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801056:	be 00 00 00 00       	mov    $0x0,%esi
  80105b:	8b 55 08             	mov    0x8(%ebp),%edx
  80105e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801061:	b8 04 00 00 00       	mov    $0x4,%eax
  801066:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801069:	89 f7                	mov    %esi,%edi
  80106b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80106d:	85 c0                	test   %eax,%eax
  80106f:	7f 08                	jg     801079 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
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
  80107d:	6a 04                	push   $0x4
  80107f:	68 f4 2b 80 00       	push   $0x802bf4
  801084:	6a 43                	push   $0x43
  801086:	68 11 2c 80 00       	push   $0x802c11
  80108b:	e8 86 f2 ff ff       	call   800316 <_panic>

00801090 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801090:	55                   	push   %ebp
  801091:	89 e5                	mov    %esp,%ebp
  801093:	57                   	push   %edi
  801094:	56                   	push   %esi
  801095:	53                   	push   %ebx
  801096:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801099:	8b 55 08             	mov    0x8(%ebp),%edx
  80109c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80109f:	b8 05 00 00 00       	mov    $0x5,%eax
  8010a4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010a7:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010aa:	8b 75 18             	mov    0x18(%ebp),%esi
  8010ad:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010af:	85 c0                	test   %eax,%eax
  8010b1:	7f 08                	jg     8010bb <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
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
  8010bf:	6a 05                	push   $0x5
  8010c1:	68 f4 2b 80 00       	push   $0x802bf4
  8010c6:	6a 43                	push   $0x43
  8010c8:	68 11 2c 80 00       	push   $0x802c11
  8010cd:	e8 44 f2 ff ff       	call   800316 <_panic>

008010d2 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
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
  8010e6:	b8 06 00 00 00       	mov    $0x6,%eax
  8010eb:	89 df                	mov    %ebx,%edi
  8010ed:	89 de                	mov    %ebx,%esi
  8010ef:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010f1:	85 c0                	test   %eax,%eax
  8010f3:	7f 08                	jg     8010fd <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
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
  801101:	6a 06                	push   $0x6
  801103:	68 f4 2b 80 00       	push   $0x802bf4
  801108:	6a 43                	push   $0x43
  80110a:	68 11 2c 80 00       	push   $0x802c11
  80110f:	e8 02 f2 ff ff       	call   800316 <_panic>

00801114 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
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
  801128:	b8 08 00 00 00       	mov    $0x8,%eax
  80112d:	89 df                	mov    %ebx,%edi
  80112f:	89 de                	mov    %ebx,%esi
  801131:	cd 30                	int    $0x30
	if(check && ret > 0)
  801133:	85 c0                	test   %eax,%eax
  801135:	7f 08                	jg     80113f <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
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
  801143:	6a 08                	push   $0x8
  801145:	68 f4 2b 80 00       	push   $0x802bf4
  80114a:	6a 43                	push   $0x43
  80114c:	68 11 2c 80 00       	push   $0x802c11
  801151:	e8 c0 f1 ff ff       	call   800316 <_panic>

00801156 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801156:	55                   	push   %ebp
  801157:	89 e5                	mov    %esp,%ebp
  801159:	57                   	push   %edi
  80115a:	56                   	push   %esi
  80115b:	53                   	push   %ebx
  80115c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80115f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801164:	8b 55 08             	mov    0x8(%ebp),%edx
  801167:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80116a:	b8 09 00 00 00       	mov    $0x9,%eax
  80116f:	89 df                	mov    %ebx,%edi
  801171:	89 de                	mov    %ebx,%esi
  801173:	cd 30                	int    $0x30
	if(check && ret > 0)
  801175:	85 c0                	test   %eax,%eax
  801177:	7f 08                	jg     801181 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801179:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80117c:	5b                   	pop    %ebx
  80117d:	5e                   	pop    %esi
  80117e:	5f                   	pop    %edi
  80117f:	5d                   	pop    %ebp
  801180:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801181:	83 ec 0c             	sub    $0xc,%esp
  801184:	50                   	push   %eax
  801185:	6a 09                	push   $0x9
  801187:	68 f4 2b 80 00       	push   $0x802bf4
  80118c:	6a 43                	push   $0x43
  80118e:	68 11 2c 80 00       	push   $0x802c11
  801193:	e8 7e f1 ff ff       	call   800316 <_panic>

00801198 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801198:	55                   	push   %ebp
  801199:	89 e5                	mov    %esp,%ebp
  80119b:	57                   	push   %edi
  80119c:	56                   	push   %esi
  80119d:	53                   	push   %ebx
  80119e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011a1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011ac:	b8 0a 00 00 00       	mov    $0xa,%eax
  8011b1:	89 df                	mov    %ebx,%edi
  8011b3:	89 de                	mov    %ebx,%esi
  8011b5:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011b7:	85 c0                	test   %eax,%eax
  8011b9:	7f 08                	jg     8011c3 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8011bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011be:	5b                   	pop    %ebx
  8011bf:	5e                   	pop    %esi
  8011c0:	5f                   	pop    %edi
  8011c1:	5d                   	pop    %ebp
  8011c2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011c3:	83 ec 0c             	sub    $0xc,%esp
  8011c6:	50                   	push   %eax
  8011c7:	6a 0a                	push   $0xa
  8011c9:	68 f4 2b 80 00       	push   $0x802bf4
  8011ce:	6a 43                	push   $0x43
  8011d0:	68 11 2c 80 00       	push   $0x802c11
  8011d5:	e8 3c f1 ff ff       	call   800316 <_panic>

008011da <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8011da:	55                   	push   %ebp
  8011db:	89 e5                	mov    %esp,%ebp
  8011dd:	57                   	push   %edi
  8011de:	56                   	push   %esi
  8011df:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8011e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011e6:	b8 0c 00 00 00       	mov    $0xc,%eax
  8011eb:	be 00 00 00 00       	mov    $0x0,%esi
  8011f0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011f3:	8b 7d 14             	mov    0x14(%ebp),%edi
  8011f6:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8011f8:	5b                   	pop    %ebx
  8011f9:	5e                   	pop    %esi
  8011fa:	5f                   	pop    %edi
  8011fb:	5d                   	pop    %ebp
  8011fc:	c3                   	ret    

008011fd <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8011fd:	55                   	push   %ebp
  8011fe:	89 e5                	mov    %esp,%ebp
  801200:	57                   	push   %edi
  801201:	56                   	push   %esi
  801202:	53                   	push   %ebx
  801203:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801206:	b9 00 00 00 00       	mov    $0x0,%ecx
  80120b:	8b 55 08             	mov    0x8(%ebp),%edx
  80120e:	b8 0d 00 00 00       	mov    $0xd,%eax
  801213:	89 cb                	mov    %ecx,%ebx
  801215:	89 cf                	mov    %ecx,%edi
  801217:	89 ce                	mov    %ecx,%esi
  801219:	cd 30                	int    $0x30
	if(check && ret > 0)
  80121b:	85 c0                	test   %eax,%eax
  80121d:	7f 08                	jg     801227 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80121f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801222:	5b                   	pop    %ebx
  801223:	5e                   	pop    %esi
  801224:	5f                   	pop    %edi
  801225:	5d                   	pop    %ebp
  801226:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801227:	83 ec 0c             	sub    $0xc,%esp
  80122a:	50                   	push   %eax
  80122b:	6a 0d                	push   $0xd
  80122d:	68 f4 2b 80 00       	push   $0x802bf4
  801232:	6a 43                	push   $0x43
  801234:	68 11 2c 80 00       	push   $0x802c11
  801239:	e8 d8 f0 ff ff       	call   800316 <_panic>

0080123e <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  80123e:	55                   	push   %ebp
  80123f:	89 e5                	mov    %esp,%ebp
  801241:	57                   	push   %edi
  801242:	56                   	push   %esi
  801243:	53                   	push   %ebx
	asm volatile("int %1\n"
  801244:	bb 00 00 00 00       	mov    $0x0,%ebx
  801249:	8b 55 08             	mov    0x8(%ebp),%edx
  80124c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80124f:	b8 0e 00 00 00       	mov    $0xe,%eax
  801254:	89 df                	mov    %ebx,%edi
  801256:	89 de                	mov    %ebx,%esi
  801258:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  80125a:	5b                   	pop    %ebx
  80125b:	5e                   	pop    %esi
  80125c:	5f                   	pop    %edi
  80125d:	5d                   	pop    %ebp
  80125e:	c3                   	ret    

0080125f <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  80125f:	55                   	push   %ebp
  801260:	89 e5                	mov    %esp,%ebp
  801262:	57                   	push   %edi
  801263:	56                   	push   %esi
  801264:	53                   	push   %ebx
	asm volatile("int %1\n"
  801265:	b9 00 00 00 00       	mov    $0x0,%ecx
  80126a:	8b 55 08             	mov    0x8(%ebp),%edx
  80126d:	b8 0f 00 00 00       	mov    $0xf,%eax
  801272:	89 cb                	mov    %ecx,%ebx
  801274:	89 cf                	mov    %ecx,%edi
  801276:	89 ce                	mov    %ecx,%esi
  801278:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  80127a:	5b                   	pop    %ebx
  80127b:	5e                   	pop    %esi
  80127c:	5f                   	pop    %edi
  80127d:	5d                   	pop    %ebp
  80127e:	c3                   	ret    

0080127f <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80127f:	55                   	push   %ebp
  801280:	89 e5                	mov    %esp,%ebp
  801282:	57                   	push   %edi
  801283:	56                   	push   %esi
  801284:	53                   	push   %ebx
	asm volatile("int %1\n"
  801285:	ba 00 00 00 00       	mov    $0x0,%edx
  80128a:	b8 10 00 00 00       	mov    $0x10,%eax
  80128f:	89 d1                	mov    %edx,%ecx
  801291:	89 d3                	mov    %edx,%ebx
  801293:	89 d7                	mov    %edx,%edi
  801295:	89 d6                	mov    %edx,%esi
  801297:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801299:	5b                   	pop    %ebx
  80129a:	5e                   	pop    %esi
  80129b:	5f                   	pop    %edi
  80129c:	5d                   	pop    %ebp
  80129d:	c3                   	ret    

0080129e <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  80129e:	55                   	push   %ebp
  80129f:	89 e5                	mov    %esp,%ebp
  8012a1:	57                   	push   %edi
  8012a2:	56                   	push   %esi
  8012a3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8012a4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8012ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012af:	b8 11 00 00 00       	mov    $0x11,%eax
  8012b4:	89 df                	mov    %ebx,%edi
  8012b6:	89 de                	mov    %ebx,%esi
  8012b8:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8012ba:	5b                   	pop    %ebx
  8012bb:	5e                   	pop    %esi
  8012bc:	5f                   	pop    %edi
  8012bd:	5d                   	pop    %ebp
  8012be:	c3                   	ret    

008012bf <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  8012bf:	55                   	push   %ebp
  8012c0:	89 e5                	mov    %esp,%ebp
  8012c2:	57                   	push   %edi
  8012c3:	56                   	push   %esi
  8012c4:	53                   	push   %ebx
	asm volatile("int %1\n"
  8012c5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8012cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012d0:	b8 12 00 00 00       	mov    $0x12,%eax
  8012d5:	89 df                	mov    %ebx,%edi
  8012d7:	89 de                	mov    %ebx,%esi
  8012d9:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8012db:	5b                   	pop    %ebx
  8012dc:	5e                   	pop    %esi
  8012dd:	5f                   	pop    %edi
  8012de:	5d                   	pop    %ebp
  8012df:	c3                   	ret    

008012e0 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  8012e0:	55                   	push   %ebp
  8012e1:	89 e5                	mov    %esp,%ebp
  8012e3:	57                   	push   %edi
  8012e4:	56                   	push   %esi
  8012e5:	53                   	push   %ebx
  8012e6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012e9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8012f1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012f4:	b8 13 00 00 00       	mov    $0x13,%eax
  8012f9:	89 df                	mov    %ebx,%edi
  8012fb:	89 de                	mov    %ebx,%esi
  8012fd:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012ff:	85 c0                	test   %eax,%eax
  801301:	7f 08                	jg     80130b <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801303:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801306:	5b                   	pop    %ebx
  801307:	5e                   	pop    %esi
  801308:	5f                   	pop    %edi
  801309:	5d                   	pop    %ebp
  80130a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80130b:	83 ec 0c             	sub    $0xc,%esp
  80130e:	50                   	push   %eax
  80130f:	6a 13                	push   $0x13
  801311:	68 f4 2b 80 00       	push   $0x802bf4
  801316:	6a 43                	push   $0x43
  801318:	68 11 2c 80 00       	push   $0x802c11
  80131d:	e8 f4 ef ff ff       	call   800316 <_panic>

00801322 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801322:	55                   	push   %ebp
  801323:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801325:	8b 45 08             	mov    0x8(%ebp),%eax
  801328:	05 00 00 00 30       	add    $0x30000000,%eax
  80132d:	c1 e8 0c             	shr    $0xc,%eax
}
  801330:	5d                   	pop    %ebp
  801331:	c3                   	ret    

00801332 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801332:	55                   	push   %ebp
  801333:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801335:	8b 45 08             	mov    0x8(%ebp),%eax
  801338:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80133d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801342:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801347:	5d                   	pop    %ebp
  801348:	c3                   	ret    

00801349 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801349:	55                   	push   %ebp
  80134a:	89 e5                	mov    %esp,%ebp
  80134c:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801351:	89 c2                	mov    %eax,%edx
  801353:	c1 ea 16             	shr    $0x16,%edx
  801356:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80135d:	f6 c2 01             	test   $0x1,%dl
  801360:	74 2d                	je     80138f <fd_alloc+0x46>
  801362:	89 c2                	mov    %eax,%edx
  801364:	c1 ea 0c             	shr    $0xc,%edx
  801367:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80136e:	f6 c2 01             	test   $0x1,%dl
  801371:	74 1c                	je     80138f <fd_alloc+0x46>
  801373:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801378:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80137d:	75 d2                	jne    801351 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80137f:	8b 45 08             	mov    0x8(%ebp),%eax
  801382:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801388:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80138d:	eb 0a                	jmp    801399 <fd_alloc+0x50>
			*fd_store = fd;
  80138f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801392:	89 01                	mov    %eax,(%ecx)
			return 0;
  801394:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801399:	5d                   	pop    %ebp
  80139a:	c3                   	ret    

0080139b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80139b:	55                   	push   %ebp
  80139c:	89 e5                	mov    %esp,%ebp
  80139e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8013a1:	83 f8 1f             	cmp    $0x1f,%eax
  8013a4:	77 30                	ja     8013d6 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8013a6:	c1 e0 0c             	shl    $0xc,%eax
  8013a9:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8013ae:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8013b4:	f6 c2 01             	test   $0x1,%dl
  8013b7:	74 24                	je     8013dd <fd_lookup+0x42>
  8013b9:	89 c2                	mov    %eax,%edx
  8013bb:	c1 ea 0c             	shr    $0xc,%edx
  8013be:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013c5:	f6 c2 01             	test   $0x1,%dl
  8013c8:	74 1a                	je     8013e4 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8013ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013cd:	89 02                	mov    %eax,(%edx)
	return 0;
  8013cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013d4:	5d                   	pop    %ebp
  8013d5:	c3                   	ret    
		return -E_INVAL;
  8013d6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013db:	eb f7                	jmp    8013d4 <fd_lookup+0x39>
		return -E_INVAL;
  8013dd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013e2:	eb f0                	jmp    8013d4 <fd_lookup+0x39>
  8013e4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013e9:	eb e9                	jmp    8013d4 <fd_lookup+0x39>

008013eb <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8013eb:	55                   	push   %ebp
  8013ec:	89 e5                	mov    %esp,%ebp
  8013ee:	83 ec 08             	sub    $0x8,%esp
  8013f1:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8013f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8013f9:	b8 20 30 80 00       	mov    $0x803020,%eax
		if (devtab[i]->dev_id == dev_id) {
  8013fe:	39 08                	cmp    %ecx,(%eax)
  801400:	74 38                	je     80143a <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801402:	83 c2 01             	add    $0x1,%edx
  801405:	8b 04 95 a0 2c 80 00 	mov    0x802ca0(,%edx,4),%eax
  80140c:	85 c0                	test   %eax,%eax
  80140e:	75 ee                	jne    8013fe <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801410:	a1 08 44 80 00       	mov    0x804408,%eax
  801415:	8b 40 48             	mov    0x48(%eax),%eax
  801418:	83 ec 04             	sub    $0x4,%esp
  80141b:	51                   	push   %ecx
  80141c:	50                   	push   %eax
  80141d:	68 20 2c 80 00       	push   $0x802c20
  801422:	e8 e5 ef ff ff       	call   80040c <cprintf>
	*dev = 0;
  801427:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801430:	83 c4 10             	add    $0x10,%esp
  801433:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801438:	c9                   	leave  
  801439:	c3                   	ret    
			*dev = devtab[i];
  80143a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80143d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80143f:	b8 00 00 00 00       	mov    $0x0,%eax
  801444:	eb f2                	jmp    801438 <dev_lookup+0x4d>

00801446 <fd_close>:
{
  801446:	55                   	push   %ebp
  801447:	89 e5                	mov    %esp,%ebp
  801449:	57                   	push   %edi
  80144a:	56                   	push   %esi
  80144b:	53                   	push   %ebx
  80144c:	83 ec 24             	sub    $0x24,%esp
  80144f:	8b 75 08             	mov    0x8(%ebp),%esi
  801452:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801455:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801458:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801459:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80145f:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801462:	50                   	push   %eax
  801463:	e8 33 ff ff ff       	call   80139b <fd_lookup>
  801468:	89 c3                	mov    %eax,%ebx
  80146a:	83 c4 10             	add    $0x10,%esp
  80146d:	85 c0                	test   %eax,%eax
  80146f:	78 05                	js     801476 <fd_close+0x30>
	    || fd != fd2)
  801471:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801474:	74 16                	je     80148c <fd_close+0x46>
		return (must_exist ? r : 0);
  801476:	89 f8                	mov    %edi,%eax
  801478:	84 c0                	test   %al,%al
  80147a:	b8 00 00 00 00       	mov    $0x0,%eax
  80147f:	0f 44 d8             	cmove  %eax,%ebx
}
  801482:	89 d8                	mov    %ebx,%eax
  801484:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801487:	5b                   	pop    %ebx
  801488:	5e                   	pop    %esi
  801489:	5f                   	pop    %edi
  80148a:	5d                   	pop    %ebp
  80148b:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80148c:	83 ec 08             	sub    $0x8,%esp
  80148f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801492:	50                   	push   %eax
  801493:	ff 36                	pushl  (%esi)
  801495:	e8 51 ff ff ff       	call   8013eb <dev_lookup>
  80149a:	89 c3                	mov    %eax,%ebx
  80149c:	83 c4 10             	add    $0x10,%esp
  80149f:	85 c0                	test   %eax,%eax
  8014a1:	78 1a                	js     8014bd <fd_close+0x77>
		if (dev->dev_close)
  8014a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014a6:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8014a9:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8014ae:	85 c0                	test   %eax,%eax
  8014b0:	74 0b                	je     8014bd <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8014b2:	83 ec 0c             	sub    $0xc,%esp
  8014b5:	56                   	push   %esi
  8014b6:	ff d0                	call   *%eax
  8014b8:	89 c3                	mov    %eax,%ebx
  8014ba:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8014bd:	83 ec 08             	sub    $0x8,%esp
  8014c0:	56                   	push   %esi
  8014c1:	6a 00                	push   $0x0
  8014c3:	e8 0a fc ff ff       	call   8010d2 <sys_page_unmap>
	return r;
  8014c8:	83 c4 10             	add    $0x10,%esp
  8014cb:	eb b5                	jmp    801482 <fd_close+0x3c>

008014cd <close>:

int
close(int fdnum)
{
  8014cd:	55                   	push   %ebp
  8014ce:	89 e5                	mov    %esp,%ebp
  8014d0:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014d3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014d6:	50                   	push   %eax
  8014d7:	ff 75 08             	pushl  0x8(%ebp)
  8014da:	e8 bc fe ff ff       	call   80139b <fd_lookup>
  8014df:	83 c4 10             	add    $0x10,%esp
  8014e2:	85 c0                	test   %eax,%eax
  8014e4:	79 02                	jns    8014e8 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8014e6:	c9                   	leave  
  8014e7:	c3                   	ret    
		return fd_close(fd, 1);
  8014e8:	83 ec 08             	sub    $0x8,%esp
  8014eb:	6a 01                	push   $0x1
  8014ed:	ff 75 f4             	pushl  -0xc(%ebp)
  8014f0:	e8 51 ff ff ff       	call   801446 <fd_close>
  8014f5:	83 c4 10             	add    $0x10,%esp
  8014f8:	eb ec                	jmp    8014e6 <close+0x19>

008014fa <close_all>:

void
close_all(void)
{
  8014fa:	55                   	push   %ebp
  8014fb:	89 e5                	mov    %esp,%ebp
  8014fd:	53                   	push   %ebx
  8014fe:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801501:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801506:	83 ec 0c             	sub    $0xc,%esp
  801509:	53                   	push   %ebx
  80150a:	e8 be ff ff ff       	call   8014cd <close>
	for (i = 0; i < MAXFD; i++)
  80150f:	83 c3 01             	add    $0x1,%ebx
  801512:	83 c4 10             	add    $0x10,%esp
  801515:	83 fb 20             	cmp    $0x20,%ebx
  801518:	75 ec                	jne    801506 <close_all+0xc>
}
  80151a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80151d:	c9                   	leave  
  80151e:	c3                   	ret    

0080151f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80151f:	55                   	push   %ebp
  801520:	89 e5                	mov    %esp,%ebp
  801522:	57                   	push   %edi
  801523:	56                   	push   %esi
  801524:	53                   	push   %ebx
  801525:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801528:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80152b:	50                   	push   %eax
  80152c:	ff 75 08             	pushl  0x8(%ebp)
  80152f:	e8 67 fe ff ff       	call   80139b <fd_lookup>
  801534:	89 c3                	mov    %eax,%ebx
  801536:	83 c4 10             	add    $0x10,%esp
  801539:	85 c0                	test   %eax,%eax
  80153b:	0f 88 81 00 00 00    	js     8015c2 <dup+0xa3>
		return r;
	close(newfdnum);
  801541:	83 ec 0c             	sub    $0xc,%esp
  801544:	ff 75 0c             	pushl  0xc(%ebp)
  801547:	e8 81 ff ff ff       	call   8014cd <close>

	newfd = INDEX2FD(newfdnum);
  80154c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80154f:	c1 e6 0c             	shl    $0xc,%esi
  801552:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801558:	83 c4 04             	add    $0x4,%esp
  80155b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80155e:	e8 cf fd ff ff       	call   801332 <fd2data>
  801563:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801565:	89 34 24             	mov    %esi,(%esp)
  801568:	e8 c5 fd ff ff       	call   801332 <fd2data>
  80156d:	83 c4 10             	add    $0x10,%esp
  801570:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801572:	89 d8                	mov    %ebx,%eax
  801574:	c1 e8 16             	shr    $0x16,%eax
  801577:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80157e:	a8 01                	test   $0x1,%al
  801580:	74 11                	je     801593 <dup+0x74>
  801582:	89 d8                	mov    %ebx,%eax
  801584:	c1 e8 0c             	shr    $0xc,%eax
  801587:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80158e:	f6 c2 01             	test   $0x1,%dl
  801591:	75 39                	jne    8015cc <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801593:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801596:	89 d0                	mov    %edx,%eax
  801598:	c1 e8 0c             	shr    $0xc,%eax
  80159b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015a2:	83 ec 0c             	sub    $0xc,%esp
  8015a5:	25 07 0e 00 00       	and    $0xe07,%eax
  8015aa:	50                   	push   %eax
  8015ab:	56                   	push   %esi
  8015ac:	6a 00                	push   $0x0
  8015ae:	52                   	push   %edx
  8015af:	6a 00                	push   $0x0
  8015b1:	e8 da fa ff ff       	call   801090 <sys_page_map>
  8015b6:	89 c3                	mov    %eax,%ebx
  8015b8:	83 c4 20             	add    $0x20,%esp
  8015bb:	85 c0                	test   %eax,%eax
  8015bd:	78 31                	js     8015f0 <dup+0xd1>
		goto err;

	return newfdnum;
  8015bf:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8015c2:	89 d8                	mov    %ebx,%eax
  8015c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015c7:	5b                   	pop    %ebx
  8015c8:	5e                   	pop    %esi
  8015c9:	5f                   	pop    %edi
  8015ca:	5d                   	pop    %ebp
  8015cb:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8015cc:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015d3:	83 ec 0c             	sub    $0xc,%esp
  8015d6:	25 07 0e 00 00       	and    $0xe07,%eax
  8015db:	50                   	push   %eax
  8015dc:	57                   	push   %edi
  8015dd:	6a 00                	push   $0x0
  8015df:	53                   	push   %ebx
  8015e0:	6a 00                	push   $0x0
  8015e2:	e8 a9 fa ff ff       	call   801090 <sys_page_map>
  8015e7:	89 c3                	mov    %eax,%ebx
  8015e9:	83 c4 20             	add    $0x20,%esp
  8015ec:	85 c0                	test   %eax,%eax
  8015ee:	79 a3                	jns    801593 <dup+0x74>
	sys_page_unmap(0, newfd);
  8015f0:	83 ec 08             	sub    $0x8,%esp
  8015f3:	56                   	push   %esi
  8015f4:	6a 00                	push   $0x0
  8015f6:	e8 d7 fa ff ff       	call   8010d2 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8015fb:	83 c4 08             	add    $0x8,%esp
  8015fe:	57                   	push   %edi
  8015ff:	6a 00                	push   $0x0
  801601:	e8 cc fa ff ff       	call   8010d2 <sys_page_unmap>
	return r;
  801606:	83 c4 10             	add    $0x10,%esp
  801609:	eb b7                	jmp    8015c2 <dup+0xa3>

0080160b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80160b:	55                   	push   %ebp
  80160c:	89 e5                	mov    %esp,%ebp
  80160e:	53                   	push   %ebx
  80160f:	83 ec 1c             	sub    $0x1c,%esp
  801612:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801615:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801618:	50                   	push   %eax
  801619:	53                   	push   %ebx
  80161a:	e8 7c fd ff ff       	call   80139b <fd_lookup>
  80161f:	83 c4 10             	add    $0x10,%esp
  801622:	85 c0                	test   %eax,%eax
  801624:	78 3f                	js     801665 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801626:	83 ec 08             	sub    $0x8,%esp
  801629:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80162c:	50                   	push   %eax
  80162d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801630:	ff 30                	pushl  (%eax)
  801632:	e8 b4 fd ff ff       	call   8013eb <dev_lookup>
  801637:	83 c4 10             	add    $0x10,%esp
  80163a:	85 c0                	test   %eax,%eax
  80163c:	78 27                	js     801665 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80163e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801641:	8b 42 08             	mov    0x8(%edx),%eax
  801644:	83 e0 03             	and    $0x3,%eax
  801647:	83 f8 01             	cmp    $0x1,%eax
  80164a:	74 1e                	je     80166a <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80164c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80164f:	8b 40 08             	mov    0x8(%eax),%eax
  801652:	85 c0                	test   %eax,%eax
  801654:	74 35                	je     80168b <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801656:	83 ec 04             	sub    $0x4,%esp
  801659:	ff 75 10             	pushl  0x10(%ebp)
  80165c:	ff 75 0c             	pushl  0xc(%ebp)
  80165f:	52                   	push   %edx
  801660:	ff d0                	call   *%eax
  801662:	83 c4 10             	add    $0x10,%esp
}
  801665:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801668:	c9                   	leave  
  801669:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80166a:	a1 08 44 80 00       	mov    0x804408,%eax
  80166f:	8b 40 48             	mov    0x48(%eax),%eax
  801672:	83 ec 04             	sub    $0x4,%esp
  801675:	53                   	push   %ebx
  801676:	50                   	push   %eax
  801677:	68 64 2c 80 00       	push   $0x802c64
  80167c:	e8 8b ed ff ff       	call   80040c <cprintf>
		return -E_INVAL;
  801681:	83 c4 10             	add    $0x10,%esp
  801684:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801689:	eb da                	jmp    801665 <read+0x5a>
		return -E_NOT_SUPP;
  80168b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801690:	eb d3                	jmp    801665 <read+0x5a>

00801692 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801692:	55                   	push   %ebp
  801693:	89 e5                	mov    %esp,%ebp
  801695:	57                   	push   %edi
  801696:	56                   	push   %esi
  801697:	53                   	push   %ebx
  801698:	83 ec 0c             	sub    $0xc,%esp
  80169b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80169e:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8016a1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016a6:	39 f3                	cmp    %esi,%ebx
  8016a8:	73 23                	jae    8016cd <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016aa:	83 ec 04             	sub    $0x4,%esp
  8016ad:	89 f0                	mov    %esi,%eax
  8016af:	29 d8                	sub    %ebx,%eax
  8016b1:	50                   	push   %eax
  8016b2:	89 d8                	mov    %ebx,%eax
  8016b4:	03 45 0c             	add    0xc(%ebp),%eax
  8016b7:	50                   	push   %eax
  8016b8:	57                   	push   %edi
  8016b9:	e8 4d ff ff ff       	call   80160b <read>
		if (m < 0)
  8016be:	83 c4 10             	add    $0x10,%esp
  8016c1:	85 c0                	test   %eax,%eax
  8016c3:	78 06                	js     8016cb <readn+0x39>
			return m;
		if (m == 0)
  8016c5:	74 06                	je     8016cd <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8016c7:	01 c3                	add    %eax,%ebx
  8016c9:	eb db                	jmp    8016a6 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016cb:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8016cd:	89 d8                	mov    %ebx,%eax
  8016cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016d2:	5b                   	pop    %ebx
  8016d3:	5e                   	pop    %esi
  8016d4:	5f                   	pop    %edi
  8016d5:	5d                   	pop    %ebp
  8016d6:	c3                   	ret    

008016d7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8016d7:	55                   	push   %ebp
  8016d8:	89 e5                	mov    %esp,%ebp
  8016da:	53                   	push   %ebx
  8016db:	83 ec 1c             	sub    $0x1c,%esp
  8016de:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016e1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016e4:	50                   	push   %eax
  8016e5:	53                   	push   %ebx
  8016e6:	e8 b0 fc ff ff       	call   80139b <fd_lookup>
  8016eb:	83 c4 10             	add    $0x10,%esp
  8016ee:	85 c0                	test   %eax,%eax
  8016f0:	78 3a                	js     80172c <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016f2:	83 ec 08             	sub    $0x8,%esp
  8016f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016f8:	50                   	push   %eax
  8016f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016fc:	ff 30                	pushl  (%eax)
  8016fe:	e8 e8 fc ff ff       	call   8013eb <dev_lookup>
  801703:	83 c4 10             	add    $0x10,%esp
  801706:	85 c0                	test   %eax,%eax
  801708:	78 22                	js     80172c <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80170a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80170d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801711:	74 1e                	je     801731 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801713:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801716:	8b 52 0c             	mov    0xc(%edx),%edx
  801719:	85 d2                	test   %edx,%edx
  80171b:	74 35                	je     801752 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80171d:	83 ec 04             	sub    $0x4,%esp
  801720:	ff 75 10             	pushl  0x10(%ebp)
  801723:	ff 75 0c             	pushl  0xc(%ebp)
  801726:	50                   	push   %eax
  801727:	ff d2                	call   *%edx
  801729:	83 c4 10             	add    $0x10,%esp
}
  80172c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80172f:	c9                   	leave  
  801730:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801731:	a1 08 44 80 00       	mov    0x804408,%eax
  801736:	8b 40 48             	mov    0x48(%eax),%eax
  801739:	83 ec 04             	sub    $0x4,%esp
  80173c:	53                   	push   %ebx
  80173d:	50                   	push   %eax
  80173e:	68 80 2c 80 00       	push   $0x802c80
  801743:	e8 c4 ec ff ff       	call   80040c <cprintf>
		return -E_INVAL;
  801748:	83 c4 10             	add    $0x10,%esp
  80174b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801750:	eb da                	jmp    80172c <write+0x55>
		return -E_NOT_SUPP;
  801752:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801757:	eb d3                	jmp    80172c <write+0x55>

00801759 <seek>:

int
seek(int fdnum, off_t offset)
{
  801759:	55                   	push   %ebp
  80175a:	89 e5                	mov    %esp,%ebp
  80175c:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80175f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801762:	50                   	push   %eax
  801763:	ff 75 08             	pushl  0x8(%ebp)
  801766:	e8 30 fc ff ff       	call   80139b <fd_lookup>
  80176b:	83 c4 10             	add    $0x10,%esp
  80176e:	85 c0                	test   %eax,%eax
  801770:	78 0e                	js     801780 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801772:	8b 55 0c             	mov    0xc(%ebp),%edx
  801775:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801778:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80177b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801780:	c9                   	leave  
  801781:	c3                   	ret    

00801782 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801782:	55                   	push   %ebp
  801783:	89 e5                	mov    %esp,%ebp
  801785:	53                   	push   %ebx
  801786:	83 ec 1c             	sub    $0x1c,%esp
  801789:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80178c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80178f:	50                   	push   %eax
  801790:	53                   	push   %ebx
  801791:	e8 05 fc ff ff       	call   80139b <fd_lookup>
  801796:	83 c4 10             	add    $0x10,%esp
  801799:	85 c0                	test   %eax,%eax
  80179b:	78 37                	js     8017d4 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80179d:	83 ec 08             	sub    $0x8,%esp
  8017a0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017a3:	50                   	push   %eax
  8017a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017a7:	ff 30                	pushl  (%eax)
  8017a9:	e8 3d fc ff ff       	call   8013eb <dev_lookup>
  8017ae:	83 c4 10             	add    $0x10,%esp
  8017b1:	85 c0                	test   %eax,%eax
  8017b3:	78 1f                	js     8017d4 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b8:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017bc:	74 1b                	je     8017d9 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8017be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017c1:	8b 52 18             	mov    0x18(%edx),%edx
  8017c4:	85 d2                	test   %edx,%edx
  8017c6:	74 32                	je     8017fa <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8017c8:	83 ec 08             	sub    $0x8,%esp
  8017cb:	ff 75 0c             	pushl  0xc(%ebp)
  8017ce:	50                   	push   %eax
  8017cf:	ff d2                	call   *%edx
  8017d1:	83 c4 10             	add    $0x10,%esp
}
  8017d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017d7:	c9                   	leave  
  8017d8:	c3                   	ret    
			thisenv->env_id, fdnum);
  8017d9:	a1 08 44 80 00       	mov    0x804408,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8017de:	8b 40 48             	mov    0x48(%eax),%eax
  8017e1:	83 ec 04             	sub    $0x4,%esp
  8017e4:	53                   	push   %ebx
  8017e5:	50                   	push   %eax
  8017e6:	68 40 2c 80 00       	push   $0x802c40
  8017eb:	e8 1c ec ff ff       	call   80040c <cprintf>
		return -E_INVAL;
  8017f0:	83 c4 10             	add    $0x10,%esp
  8017f3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017f8:	eb da                	jmp    8017d4 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8017fa:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017ff:	eb d3                	jmp    8017d4 <ftruncate+0x52>

00801801 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801801:	55                   	push   %ebp
  801802:	89 e5                	mov    %esp,%ebp
  801804:	53                   	push   %ebx
  801805:	83 ec 1c             	sub    $0x1c,%esp
  801808:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80180b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80180e:	50                   	push   %eax
  80180f:	ff 75 08             	pushl  0x8(%ebp)
  801812:	e8 84 fb ff ff       	call   80139b <fd_lookup>
  801817:	83 c4 10             	add    $0x10,%esp
  80181a:	85 c0                	test   %eax,%eax
  80181c:	78 4b                	js     801869 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80181e:	83 ec 08             	sub    $0x8,%esp
  801821:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801824:	50                   	push   %eax
  801825:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801828:	ff 30                	pushl  (%eax)
  80182a:	e8 bc fb ff ff       	call   8013eb <dev_lookup>
  80182f:	83 c4 10             	add    $0x10,%esp
  801832:	85 c0                	test   %eax,%eax
  801834:	78 33                	js     801869 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801836:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801839:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80183d:	74 2f                	je     80186e <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80183f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801842:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801849:	00 00 00 
	stat->st_isdir = 0;
  80184c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801853:	00 00 00 
	stat->st_dev = dev;
  801856:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80185c:	83 ec 08             	sub    $0x8,%esp
  80185f:	53                   	push   %ebx
  801860:	ff 75 f0             	pushl  -0x10(%ebp)
  801863:	ff 50 14             	call   *0x14(%eax)
  801866:	83 c4 10             	add    $0x10,%esp
}
  801869:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80186c:	c9                   	leave  
  80186d:	c3                   	ret    
		return -E_NOT_SUPP;
  80186e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801873:	eb f4                	jmp    801869 <fstat+0x68>

00801875 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801875:	55                   	push   %ebp
  801876:	89 e5                	mov    %esp,%ebp
  801878:	56                   	push   %esi
  801879:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80187a:	83 ec 08             	sub    $0x8,%esp
  80187d:	6a 00                	push   $0x0
  80187f:	ff 75 08             	pushl  0x8(%ebp)
  801882:	e8 22 02 00 00       	call   801aa9 <open>
  801887:	89 c3                	mov    %eax,%ebx
  801889:	83 c4 10             	add    $0x10,%esp
  80188c:	85 c0                	test   %eax,%eax
  80188e:	78 1b                	js     8018ab <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801890:	83 ec 08             	sub    $0x8,%esp
  801893:	ff 75 0c             	pushl  0xc(%ebp)
  801896:	50                   	push   %eax
  801897:	e8 65 ff ff ff       	call   801801 <fstat>
  80189c:	89 c6                	mov    %eax,%esi
	close(fd);
  80189e:	89 1c 24             	mov    %ebx,(%esp)
  8018a1:	e8 27 fc ff ff       	call   8014cd <close>
	return r;
  8018a6:	83 c4 10             	add    $0x10,%esp
  8018a9:	89 f3                	mov    %esi,%ebx
}
  8018ab:	89 d8                	mov    %ebx,%eax
  8018ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018b0:	5b                   	pop    %ebx
  8018b1:	5e                   	pop    %esi
  8018b2:	5d                   	pop    %ebp
  8018b3:	c3                   	ret    

008018b4 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8018b4:	55                   	push   %ebp
  8018b5:	89 e5                	mov    %esp,%ebp
  8018b7:	56                   	push   %esi
  8018b8:	53                   	push   %ebx
  8018b9:	89 c6                	mov    %eax,%esi
  8018bb:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8018bd:	83 3d 00 44 80 00 00 	cmpl   $0x0,0x804400
  8018c4:	74 27                	je     8018ed <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8018c6:	6a 07                	push   $0x7
  8018c8:	68 00 50 80 00       	push   $0x805000
  8018cd:	56                   	push   %esi
  8018ce:	ff 35 00 44 80 00    	pushl  0x804400
  8018d4:	e8 a7 0b 00 00       	call   802480 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8018d9:	83 c4 0c             	add    $0xc,%esp
  8018dc:	6a 00                	push   $0x0
  8018de:	53                   	push   %ebx
  8018df:	6a 00                	push   $0x0
  8018e1:	e8 31 0b 00 00       	call   802417 <ipc_recv>
}
  8018e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018e9:	5b                   	pop    %ebx
  8018ea:	5e                   	pop    %esi
  8018eb:	5d                   	pop    %ebp
  8018ec:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8018ed:	83 ec 0c             	sub    $0xc,%esp
  8018f0:	6a 01                	push   $0x1
  8018f2:	e8 e1 0b 00 00       	call   8024d8 <ipc_find_env>
  8018f7:	a3 00 44 80 00       	mov    %eax,0x804400
  8018fc:	83 c4 10             	add    $0x10,%esp
  8018ff:	eb c5                	jmp    8018c6 <fsipc+0x12>

00801901 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801901:	55                   	push   %ebp
  801902:	89 e5                	mov    %esp,%ebp
  801904:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801907:	8b 45 08             	mov    0x8(%ebp),%eax
  80190a:	8b 40 0c             	mov    0xc(%eax),%eax
  80190d:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801912:	8b 45 0c             	mov    0xc(%ebp),%eax
  801915:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80191a:	ba 00 00 00 00       	mov    $0x0,%edx
  80191f:	b8 02 00 00 00       	mov    $0x2,%eax
  801924:	e8 8b ff ff ff       	call   8018b4 <fsipc>
}
  801929:	c9                   	leave  
  80192a:	c3                   	ret    

0080192b <devfile_flush>:
{
  80192b:	55                   	push   %ebp
  80192c:	89 e5                	mov    %esp,%ebp
  80192e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801931:	8b 45 08             	mov    0x8(%ebp),%eax
  801934:	8b 40 0c             	mov    0xc(%eax),%eax
  801937:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80193c:	ba 00 00 00 00       	mov    $0x0,%edx
  801941:	b8 06 00 00 00       	mov    $0x6,%eax
  801946:	e8 69 ff ff ff       	call   8018b4 <fsipc>
}
  80194b:	c9                   	leave  
  80194c:	c3                   	ret    

0080194d <devfile_stat>:
{
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
  801950:	53                   	push   %ebx
  801951:	83 ec 04             	sub    $0x4,%esp
  801954:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801957:	8b 45 08             	mov    0x8(%ebp),%eax
  80195a:	8b 40 0c             	mov    0xc(%eax),%eax
  80195d:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801962:	ba 00 00 00 00       	mov    $0x0,%edx
  801967:	b8 05 00 00 00       	mov    $0x5,%eax
  80196c:	e8 43 ff ff ff       	call   8018b4 <fsipc>
  801971:	85 c0                	test   %eax,%eax
  801973:	78 2c                	js     8019a1 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801975:	83 ec 08             	sub    $0x8,%esp
  801978:	68 00 50 80 00       	push   $0x805000
  80197d:	53                   	push   %ebx
  80197e:	e8 d8 f2 ff ff       	call   800c5b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801983:	a1 80 50 80 00       	mov    0x805080,%eax
  801988:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80198e:	a1 84 50 80 00       	mov    0x805084,%eax
  801993:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801999:	83 c4 10             	add    $0x10,%esp
  80199c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019a4:	c9                   	leave  
  8019a5:	c3                   	ret    

008019a6 <devfile_write>:
{
  8019a6:	55                   	push   %ebp
  8019a7:	89 e5                	mov    %esp,%ebp
  8019a9:	53                   	push   %ebx
  8019aa:	83 ec 08             	sub    $0x8,%esp
  8019ad:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8019b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8019b6:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8019bb:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8019c1:	53                   	push   %ebx
  8019c2:	ff 75 0c             	pushl  0xc(%ebp)
  8019c5:	68 08 50 80 00       	push   $0x805008
  8019ca:	e8 7c f4 ff ff       	call   800e4b <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8019cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d4:	b8 04 00 00 00       	mov    $0x4,%eax
  8019d9:	e8 d6 fe ff ff       	call   8018b4 <fsipc>
  8019de:	83 c4 10             	add    $0x10,%esp
  8019e1:	85 c0                	test   %eax,%eax
  8019e3:	78 0b                	js     8019f0 <devfile_write+0x4a>
	assert(r <= n);
  8019e5:	39 d8                	cmp    %ebx,%eax
  8019e7:	77 0c                	ja     8019f5 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8019e9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8019ee:	7f 1e                	jg     801a0e <devfile_write+0x68>
}
  8019f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019f3:	c9                   	leave  
  8019f4:	c3                   	ret    
	assert(r <= n);
  8019f5:	68 b4 2c 80 00       	push   $0x802cb4
  8019fa:	68 bb 2c 80 00       	push   $0x802cbb
  8019ff:	68 98 00 00 00       	push   $0x98
  801a04:	68 d0 2c 80 00       	push   $0x802cd0
  801a09:	e8 08 e9 ff ff       	call   800316 <_panic>
	assert(r <= PGSIZE);
  801a0e:	68 db 2c 80 00       	push   $0x802cdb
  801a13:	68 bb 2c 80 00       	push   $0x802cbb
  801a18:	68 99 00 00 00       	push   $0x99
  801a1d:	68 d0 2c 80 00       	push   $0x802cd0
  801a22:	e8 ef e8 ff ff       	call   800316 <_panic>

00801a27 <devfile_read>:
{
  801a27:	55                   	push   %ebp
  801a28:	89 e5                	mov    %esp,%ebp
  801a2a:	56                   	push   %esi
  801a2b:	53                   	push   %ebx
  801a2c:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a32:	8b 40 0c             	mov    0xc(%eax),%eax
  801a35:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801a3a:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a40:	ba 00 00 00 00       	mov    $0x0,%edx
  801a45:	b8 03 00 00 00       	mov    $0x3,%eax
  801a4a:	e8 65 fe ff ff       	call   8018b4 <fsipc>
  801a4f:	89 c3                	mov    %eax,%ebx
  801a51:	85 c0                	test   %eax,%eax
  801a53:	78 1f                	js     801a74 <devfile_read+0x4d>
	assert(r <= n);
  801a55:	39 f0                	cmp    %esi,%eax
  801a57:	77 24                	ja     801a7d <devfile_read+0x56>
	assert(r <= PGSIZE);
  801a59:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a5e:	7f 33                	jg     801a93 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801a60:	83 ec 04             	sub    $0x4,%esp
  801a63:	50                   	push   %eax
  801a64:	68 00 50 80 00       	push   $0x805000
  801a69:	ff 75 0c             	pushl  0xc(%ebp)
  801a6c:	e8 78 f3 ff ff       	call   800de9 <memmove>
	return r;
  801a71:	83 c4 10             	add    $0x10,%esp
}
  801a74:	89 d8                	mov    %ebx,%eax
  801a76:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a79:	5b                   	pop    %ebx
  801a7a:	5e                   	pop    %esi
  801a7b:	5d                   	pop    %ebp
  801a7c:	c3                   	ret    
	assert(r <= n);
  801a7d:	68 b4 2c 80 00       	push   $0x802cb4
  801a82:	68 bb 2c 80 00       	push   $0x802cbb
  801a87:	6a 7c                	push   $0x7c
  801a89:	68 d0 2c 80 00       	push   $0x802cd0
  801a8e:	e8 83 e8 ff ff       	call   800316 <_panic>
	assert(r <= PGSIZE);
  801a93:	68 db 2c 80 00       	push   $0x802cdb
  801a98:	68 bb 2c 80 00       	push   $0x802cbb
  801a9d:	6a 7d                	push   $0x7d
  801a9f:	68 d0 2c 80 00       	push   $0x802cd0
  801aa4:	e8 6d e8 ff ff       	call   800316 <_panic>

00801aa9 <open>:
{
  801aa9:	55                   	push   %ebp
  801aaa:	89 e5                	mov    %esp,%ebp
  801aac:	56                   	push   %esi
  801aad:	53                   	push   %ebx
  801aae:	83 ec 1c             	sub    $0x1c,%esp
  801ab1:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801ab4:	56                   	push   %esi
  801ab5:	e8 68 f1 ff ff       	call   800c22 <strlen>
  801aba:	83 c4 10             	add    $0x10,%esp
  801abd:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ac2:	7f 6c                	jg     801b30 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801ac4:	83 ec 0c             	sub    $0xc,%esp
  801ac7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aca:	50                   	push   %eax
  801acb:	e8 79 f8 ff ff       	call   801349 <fd_alloc>
  801ad0:	89 c3                	mov    %eax,%ebx
  801ad2:	83 c4 10             	add    $0x10,%esp
  801ad5:	85 c0                	test   %eax,%eax
  801ad7:	78 3c                	js     801b15 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801ad9:	83 ec 08             	sub    $0x8,%esp
  801adc:	56                   	push   %esi
  801add:	68 00 50 80 00       	push   $0x805000
  801ae2:	e8 74 f1 ff ff       	call   800c5b <strcpy>
	fsipcbuf.open.req_omode = mode;
  801ae7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aea:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801aef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801af2:	b8 01 00 00 00       	mov    $0x1,%eax
  801af7:	e8 b8 fd ff ff       	call   8018b4 <fsipc>
  801afc:	89 c3                	mov    %eax,%ebx
  801afe:	83 c4 10             	add    $0x10,%esp
  801b01:	85 c0                	test   %eax,%eax
  801b03:	78 19                	js     801b1e <open+0x75>
	return fd2num(fd);
  801b05:	83 ec 0c             	sub    $0xc,%esp
  801b08:	ff 75 f4             	pushl  -0xc(%ebp)
  801b0b:	e8 12 f8 ff ff       	call   801322 <fd2num>
  801b10:	89 c3                	mov    %eax,%ebx
  801b12:	83 c4 10             	add    $0x10,%esp
}
  801b15:	89 d8                	mov    %ebx,%eax
  801b17:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b1a:	5b                   	pop    %ebx
  801b1b:	5e                   	pop    %esi
  801b1c:	5d                   	pop    %ebp
  801b1d:	c3                   	ret    
		fd_close(fd, 0);
  801b1e:	83 ec 08             	sub    $0x8,%esp
  801b21:	6a 00                	push   $0x0
  801b23:	ff 75 f4             	pushl  -0xc(%ebp)
  801b26:	e8 1b f9 ff ff       	call   801446 <fd_close>
		return r;
  801b2b:	83 c4 10             	add    $0x10,%esp
  801b2e:	eb e5                	jmp    801b15 <open+0x6c>
		return -E_BAD_PATH;
  801b30:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801b35:	eb de                	jmp    801b15 <open+0x6c>

00801b37 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
  801b3a:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b3d:	ba 00 00 00 00       	mov    $0x0,%edx
  801b42:	b8 08 00 00 00       	mov    $0x8,%eax
  801b47:	e8 68 fd ff ff       	call   8018b4 <fsipc>
}
  801b4c:	c9                   	leave  
  801b4d:	c3                   	ret    

00801b4e <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  801b4e:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801b52:	7f 01                	jg     801b55 <writebuf+0x7>
  801b54:	c3                   	ret    
{
  801b55:	55                   	push   %ebp
  801b56:	89 e5                	mov    %esp,%ebp
  801b58:	53                   	push   %ebx
  801b59:	83 ec 08             	sub    $0x8,%esp
  801b5c:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  801b5e:	ff 70 04             	pushl  0x4(%eax)
  801b61:	8d 40 10             	lea    0x10(%eax),%eax
  801b64:	50                   	push   %eax
  801b65:	ff 33                	pushl  (%ebx)
  801b67:	e8 6b fb ff ff       	call   8016d7 <write>
		if (result > 0)
  801b6c:	83 c4 10             	add    $0x10,%esp
  801b6f:	85 c0                	test   %eax,%eax
  801b71:	7e 03                	jle    801b76 <writebuf+0x28>
			b->result += result;
  801b73:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801b76:	39 43 04             	cmp    %eax,0x4(%ebx)
  801b79:	74 0d                	je     801b88 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  801b7b:	85 c0                	test   %eax,%eax
  801b7d:	ba 00 00 00 00       	mov    $0x0,%edx
  801b82:	0f 4f c2             	cmovg  %edx,%eax
  801b85:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801b88:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b8b:	c9                   	leave  
  801b8c:	c3                   	ret    

00801b8d <putch>:

static void
putch(int ch, void *thunk)
{
  801b8d:	55                   	push   %ebp
  801b8e:	89 e5                	mov    %esp,%ebp
  801b90:	53                   	push   %ebx
  801b91:	83 ec 04             	sub    $0x4,%esp
  801b94:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801b97:	8b 53 04             	mov    0x4(%ebx),%edx
  801b9a:	8d 42 01             	lea    0x1(%edx),%eax
  801b9d:	89 43 04             	mov    %eax,0x4(%ebx)
  801ba0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ba3:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801ba7:	3d 00 01 00 00       	cmp    $0x100,%eax
  801bac:	74 06                	je     801bb4 <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  801bae:	83 c4 04             	add    $0x4,%esp
  801bb1:	5b                   	pop    %ebx
  801bb2:	5d                   	pop    %ebp
  801bb3:	c3                   	ret    
		writebuf(b);
  801bb4:	89 d8                	mov    %ebx,%eax
  801bb6:	e8 93 ff ff ff       	call   801b4e <writebuf>
		b->idx = 0;
  801bbb:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  801bc2:	eb ea                	jmp    801bae <putch+0x21>

00801bc4 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801bc4:	55                   	push   %ebp
  801bc5:	89 e5                	mov    %esp,%ebp
  801bc7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd0:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801bd6:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801bdd:	00 00 00 
	b.result = 0;
  801be0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801be7:	00 00 00 
	b.error = 1;
  801bea:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801bf1:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801bf4:	ff 75 10             	pushl  0x10(%ebp)
  801bf7:	ff 75 0c             	pushl  0xc(%ebp)
  801bfa:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801c00:	50                   	push   %eax
  801c01:	68 8d 1b 80 00       	push   $0x801b8d
  801c06:	e8 2e e9 ff ff       	call   800539 <vprintfmt>
	if (b.idx > 0)
  801c0b:	83 c4 10             	add    $0x10,%esp
  801c0e:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801c15:	7f 11                	jg     801c28 <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  801c17:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801c1d:	85 c0                	test   %eax,%eax
  801c1f:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801c26:	c9                   	leave  
  801c27:	c3                   	ret    
		writebuf(&b);
  801c28:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801c2e:	e8 1b ff ff ff       	call   801b4e <writebuf>
  801c33:	eb e2                	jmp    801c17 <vfprintf+0x53>

00801c35 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801c35:	55                   	push   %ebp
  801c36:	89 e5                	mov    %esp,%ebp
  801c38:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801c3b:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801c3e:	50                   	push   %eax
  801c3f:	ff 75 0c             	pushl  0xc(%ebp)
  801c42:	ff 75 08             	pushl  0x8(%ebp)
  801c45:	e8 7a ff ff ff       	call   801bc4 <vfprintf>
	va_end(ap);

	return cnt;
}
  801c4a:	c9                   	leave  
  801c4b:	c3                   	ret    

00801c4c <printf>:

int
printf(const char *fmt, ...)
{
  801c4c:	55                   	push   %ebp
  801c4d:	89 e5                	mov    %esp,%ebp
  801c4f:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801c52:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801c55:	50                   	push   %eax
  801c56:	ff 75 08             	pushl  0x8(%ebp)
  801c59:	6a 01                	push   $0x1
  801c5b:	e8 64 ff ff ff       	call   801bc4 <vfprintf>
	va_end(ap);

	return cnt;
}
  801c60:	c9                   	leave  
  801c61:	c3                   	ret    

00801c62 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801c62:	55                   	push   %ebp
  801c63:	89 e5                	mov    %esp,%ebp
  801c65:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801c68:	68 e7 2c 80 00       	push   $0x802ce7
  801c6d:	ff 75 0c             	pushl  0xc(%ebp)
  801c70:	e8 e6 ef ff ff       	call   800c5b <strcpy>
	return 0;
}
  801c75:	b8 00 00 00 00       	mov    $0x0,%eax
  801c7a:	c9                   	leave  
  801c7b:	c3                   	ret    

00801c7c <devsock_close>:
{
  801c7c:	55                   	push   %ebp
  801c7d:	89 e5                	mov    %esp,%ebp
  801c7f:	53                   	push   %ebx
  801c80:	83 ec 10             	sub    $0x10,%esp
  801c83:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801c86:	53                   	push   %ebx
  801c87:	e8 87 08 00 00       	call   802513 <pageref>
  801c8c:	83 c4 10             	add    $0x10,%esp
		return 0;
  801c8f:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801c94:	83 f8 01             	cmp    $0x1,%eax
  801c97:	74 07                	je     801ca0 <devsock_close+0x24>
}
  801c99:	89 d0                	mov    %edx,%eax
  801c9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c9e:	c9                   	leave  
  801c9f:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801ca0:	83 ec 0c             	sub    $0xc,%esp
  801ca3:	ff 73 0c             	pushl  0xc(%ebx)
  801ca6:	e8 b9 02 00 00       	call   801f64 <nsipc_close>
  801cab:	89 c2                	mov    %eax,%edx
  801cad:	83 c4 10             	add    $0x10,%esp
  801cb0:	eb e7                	jmp    801c99 <devsock_close+0x1d>

00801cb2 <devsock_write>:
{
  801cb2:	55                   	push   %ebp
  801cb3:	89 e5                	mov    %esp,%ebp
  801cb5:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801cb8:	6a 00                	push   $0x0
  801cba:	ff 75 10             	pushl  0x10(%ebp)
  801cbd:	ff 75 0c             	pushl  0xc(%ebp)
  801cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc3:	ff 70 0c             	pushl  0xc(%eax)
  801cc6:	e8 76 03 00 00       	call   802041 <nsipc_send>
}
  801ccb:	c9                   	leave  
  801ccc:	c3                   	ret    

00801ccd <devsock_read>:
{
  801ccd:	55                   	push   %ebp
  801cce:	89 e5                	mov    %esp,%ebp
  801cd0:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801cd3:	6a 00                	push   $0x0
  801cd5:	ff 75 10             	pushl  0x10(%ebp)
  801cd8:	ff 75 0c             	pushl  0xc(%ebp)
  801cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cde:	ff 70 0c             	pushl  0xc(%eax)
  801ce1:	e8 ef 02 00 00       	call   801fd5 <nsipc_recv>
}
  801ce6:	c9                   	leave  
  801ce7:	c3                   	ret    

00801ce8 <fd2sockid>:
{
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
  801ceb:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801cee:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801cf1:	52                   	push   %edx
  801cf2:	50                   	push   %eax
  801cf3:	e8 a3 f6 ff ff       	call   80139b <fd_lookup>
  801cf8:	83 c4 10             	add    $0x10,%esp
  801cfb:	85 c0                	test   %eax,%eax
  801cfd:	78 10                	js     801d0f <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801cff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d02:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801d08:	39 08                	cmp    %ecx,(%eax)
  801d0a:	75 05                	jne    801d11 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801d0c:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801d0f:	c9                   	leave  
  801d10:	c3                   	ret    
		return -E_NOT_SUPP;
  801d11:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d16:	eb f7                	jmp    801d0f <fd2sockid+0x27>

00801d18 <alloc_sockfd>:
{
  801d18:	55                   	push   %ebp
  801d19:	89 e5                	mov    %esp,%ebp
  801d1b:	56                   	push   %esi
  801d1c:	53                   	push   %ebx
  801d1d:	83 ec 1c             	sub    $0x1c,%esp
  801d20:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801d22:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d25:	50                   	push   %eax
  801d26:	e8 1e f6 ff ff       	call   801349 <fd_alloc>
  801d2b:	89 c3                	mov    %eax,%ebx
  801d2d:	83 c4 10             	add    $0x10,%esp
  801d30:	85 c0                	test   %eax,%eax
  801d32:	78 43                	js     801d77 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801d34:	83 ec 04             	sub    $0x4,%esp
  801d37:	68 07 04 00 00       	push   $0x407
  801d3c:	ff 75 f4             	pushl  -0xc(%ebp)
  801d3f:	6a 00                	push   $0x0
  801d41:	e8 07 f3 ff ff       	call   80104d <sys_page_alloc>
  801d46:	89 c3                	mov    %eax,%ebx
  801d48:	83 c4 10             	add    $0x10,%esp
  801d4b:	85 c0                	test   %eax,%eax
  801d4d:	78 28                	js     801d77 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801d4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d52:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801d58:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801d5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d5d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801d64:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801d67:	83 ec 0c             	sub    $0xc,%esp
  801d6a:	50                   	push   %eax
  801d6b:	e8 b2 f5 ff ff       	call   801322 <fd2num>
  801d70:	89 c3                	mov    %eax,%ebx
  801d72:	83 c4 10             	add    $0x10,%esp
  801d75:	eb 0c                	jmp    801d83 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801d77:	83 ec 0c             	sub    $0xc,%esp
  801d7a:	56                   	push   %esi
  801d7b:	e8 e4 01 00 00       	call   801f64 <nsipc_close>
		return r;
  801d80:	83 c4 10             	add    $0x10,%esp
}
  801d83:	89 d8                	mov    %ebx,%eax
  801d85:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d88:	5b                   	pop    %ebx
  801d89:	5e                   	pop    %esi
  801d8a:	5d                   	pop    %ebp
  801d8b:	c3                   	ret    

00801d8c <accept>:
{
  801d8c:	55                   	push   %ebp
  801d8d:	89 e5                	mov    %esp,%ebp
  801d8f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d92:	8b 45 08             	mov    0x8(%ebp),%eax
  801d95:	e8 4e ff ff ff       	call   801ce8 <fd2sockid>
  801d9a:	85 c0                	test   %eax,%eax
  801d9c:	78 1b                	js     801db9 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801d9e:	83 ec 04             	sub    $0x4,%esp
  801da1:	ff 75 10             	pushl  0x10(%ebp)
  801da4:	ff 75 0c             	pushl  0xc(%ebp)
  801da7:	50                   	push   %eax
  801da8:	e8 0e 01 00 00       	call   801ebb <nsipc_accept>
  801dad:	83 c4 10             	add    $0x10,%esp
  801db0:	85 c0                	test   %eax,%eax
  801db2:	78 05                	js     801db9 <accept+0x2d>
	return alloc_sockfd(r);
  801db4:	e8 5f ff ff ff       	call   801d18 <alloc_sockfd>
}
  801db9:	c9                   	leave  
  801dba:	c3                   	ret    

00801dbb <bind>:
{
  801dbb:	55                   	push   %ebp
  801dbc:	89 e5                	mov    %esp,%ebp
  801dbe:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc4:	e8 1f ff ff ff       	call   801ce8 <fd2sockid>
  801dc9:	85 c0                	test   %eax,%eax
  801dcb:	78 12                	js     801ddf <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801dcd:	83 ec 04             	sub    $0x4,%esp
  801dd0:	ff 75 10             	pushl  0x10(%ebp)
  801dd3:	ff 75 0c             	pushl  0xc(%ebp)
  801dd6:	50                   	push   %eax
  801dd7:	e8 31 01 00 00       	call   801f0d <nsipc_bind>
  801ddc:	83 c4 10             	add    $0x10,%esp
}
  801ddf:	c9                   	leave  
  801de0:	c3                   	ret    

00801de1 <shutdown>:
{
  801de1:	55                   	push   %ebp
  801de2:	89 e5                	mov    %esp,%ebp
  801de4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801de7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dea:	e8 f9 fe ff ff       	call   801ce8 <fd2sockid>
  801def:	85 c0                	test   %eax,%eax
  801df1:	78 0f                	js     801e02 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801df3:	83 ec 08             	sub    $0x8,%esp
  801df6:	ff 75 0c             	pushl  0xc(%ebp)
  801df9:	50                   	push   %eax
  801dfa:	e8 43 01 00 00       	call   801f42 <nsipc_shutdown>
  801dff:	83 c4 10             	add    $0x10,%esp
}
  801e02:	c9                   	leave  
  801e03:	c3                   	ret    

00801e04 <connect>:
{
  801e04:	55                   	push   %ebp
  801e05:	89 e5                	mov    %esp,%ebp
  801e07:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0d:	e8 d6 fe ff ff       	call   801ce8 <fd2sockid>
  801e12:	85 c0                	test   %eax,%eax
  801e14:	78 12                	js     801e28 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801e16:	83 ec 04             	sub    $0x4,%esp
  801e19:	ff 75 10             	pushl  0x10(%ebp)
  801e1c:	ff 75 0c             	pushl  0xc(%ebp)
  801e1f:	50                   	push   %eax
  801e20:	e8 59 01 00 00       	call   801f7e <nsipc_connect>
  801e25:	83 c4 10             	add    $0x10,%esp
}
  801e28:	c9                   	leave  
  801e29:	c3                   	ret    

00801e2a <listen>:
{
  801e2a:	55                   	push   %ebp
  801e2b:	89 e5                	mov    %esp,%ebp
  801e2d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e30:	8b 45 08             	mov    0x8(%ebp),%eax
  801e33:	e8 b0 fe ff ff       	call   801ce8 <fd2sockid>
  801e38:	85 c0                	test   %eax,%eax
  801e3a:	78 0f                	js     801e4b <listen+0x21>
	return nsipc_listen(r, backlog);
  801e3c:	83 ec 08             	sub    $0x8,%esp
  801e3f:	ff 75 0c             	pushl  0xc(%ebp)
  801e42:	50                   	push   %eax
  801e43:	e8 6b 01 00 00       	call   801fb3 <nsipc_listen>
  801e48:	83 c4 10             	add    $0x10,%esp
}
  801e4b:	c9                   	leave  
  801e4c:	c3                   	ret    

00801e4d <socket>:

int
socket(int domain, int type, int protocol)
{
  801e4d:	55                   	push   %ebp
  801e4e:	89 e5                	mov    %esp,%ebp
  801e50:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801e53:	ff 75 10             	pushl  0x10(%ebp)
  801e56:	ff 75 0c             	pushl  0xc(%ebp)
  801e59:	ff 75 08             	pushl  0x8(%ebp)
  801e5c:	e8 3e 02 00 00       	call   80209f <nsipc_socket>
  801e61:	83 c4 10             	add    $0x10,%esp
  801e64:	85 c0                	test   %eax,%eax
  801e66:	78 05                	js     801e6d <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801e68:	e8 ab fe ff ff       	call   801d18 <alloc_sockfd>
}
  801e6d:	c9                   	leave  
  801e6e:	c3                   	ret    

00801e6f <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801e6f:	55                   	push   %ebp
  801e70:	89 e5                	mov    %esp,%ebp
  801e72:	53                   	push   %ebx
  801e73:	83 ec 04             	sub    $0x4,%esp
  801e76:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801e78:	83 3d 04 44 80 00 00 	cmpl   $0x0,0x804404
  801e7f:	74 26                	je     801ea7 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801e81:	6a 07                	push   $0x7
  801e83:	68 00 60 80 00       	push   $0x806000
  801e88:	53                   	push   %ebx
  801e89:	ff 35 04 44 80 00    	pushl  0x804404
  801e8f:	e8 ec 05 00 00       	call   802480 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801e94:	83 c4 0c             	add    $0xc,%esp
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	e8 75 05 00 00       	call   802417 <ipc_recv>
}
  801ea2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ea5:	c9                   	leave  
  801ea6:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801ea7:	83 ec 0c             	sub    $0xc,%esp
  801eaa:	6a 02                	push   $0x2
  801eac:	e8 27 06 00 00       	call   8024d8 <ipc_find_env>
  801eb1:	a3 04 44 80 00       	mov    %eax,0x804404
  801eb6:	83 c4 10             	add    $0x10,%esp
  801eb9:	eb c6                	jmp    801e81 <nsipc+0x12>

00801ebb <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801ebb:	55                   	push   %ebp
  801ebc:	89 e5                	mov    %esp,%ebp
  801ebe:	56                   	push   %esi
  801ebf:	53                   	push   %ebx
  801ec0:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec6:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801ecb:	8b 06                	mov    (%esi),%eax
  801ecd:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801ed2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ed7:	e8 93 ff ff ff       	call   801e6f <nsipc>
  801edc:	89 c3                	mov    %eax,%ebx
  801ede:	85 c0                	test   %eax,%eax
  801ee0:	79 09                	jns    801eeb <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801ee2:	89 d8                	mov    %ebx,%eax
  801ee4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ee7:	5b                   	pop    %ebx
  801ee8:	5e                   	pop    %esi
  801ee9:	5d                   	pop    %ebp
  801eea:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801eeb:	83 ec 04             	sub    $0x4,%esp
  801eee:	ff 35 10 60 80 00    	pushl  0x806010
  801ef4:	68 00 60 80 00       	push   $0x806000
  801ef9:	ff 75 0c             	pushl  0xc(%ebp)
  801efc:	e8 e8 ee ff ff       	call   800de9 <memmove>
		*addrlen = ret->ret_addrlen;
  801f01:	a1 10 60 80 00       	mov    0x806010,%eax
  801f06:	89 06                	mov    %eax,(%esi)
  801f08:	83 c4 10             	add    $0x10,%esp
	return r;
  801f0b:	eb d5                	jmp    801ee2 <nsipc_accept+0x27>

00801f0d <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801f0d:	55                   	push   %ebp
  801f0e:	89 e5                	mov    %esp,%ebp
  801f10:	53                   	push   %ebx
  801f11:	83 ec 08             	sub    $0x8,%esp
  801f14:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801f17:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1a:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801f1f:	53                   	push   %ebx
  801f20:	ff 75 0c             	pushl  0xc(%ebp)
  801f23:	68 04 60 80 00       	push   $0x806004
  801f28:	e8 bc ee ff ff       	call   800de9 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801f2d:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801f33:	b8 02 00 00 00       	mov    $0x2,%eax
  801f38:	e8 32 ff ff ff       	call   801e6f <nsipc>
}
  801f3d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f40:	c9                   	leave  
  801f41:	c3                   	ret    

00801f42 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801f42:	55                   	push   %ebp
  801f43:	89 e5                	mov    %esp,%ebp
  801f45:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801f48:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801f50:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f53:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801f58:	b8 03 00 00 00       	mov    $0x3,%eax
  801f5d:	e8 0d ff ff ff       	call   801e6f <nsipc>
}
  801f62:	c9                   	leave  
  801f63:	c3                   	ret    

00801f64 <nsipc_close>:

int
nsipc_close(int s)
{
  801f64:	55                   	push   %ebp
  801f65:	89 e5                	mov    %esp,%ebp
  801f67:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6d:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801f72:	b8 04 00 00 00       	mov    $0x4,%eax
  801f77:	e8 f3 fe ff ff       	call   801e6f <nsipc>
}
  801f7c:	c9                   	leave  
  801f7d:	c3                   	ret    

00801f7e <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801f7e:	55                   	push   %ebp
  801f7f:	89 e5                	mov    %esp,%ebp
  801f81:	53                   	push   %ebx
  801f82:	83 ec 08             	sub    $0x8,%esp
  801f85:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801f88:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8b:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801f90:	53                   	push   %ebx
  801f91:	ff 75 0c             	pushl  0xc(%ebp)
  801f94:	68 04 60 80 00       	push   $0x806004
  801f99:	e8 4b ee ff ff       	call   800de9 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801f9e:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801fa4:	b8 05 00 00 00       	mov    $0x5,%eax
  801fa9:	e8 c1 fe ff ff       	call   801e6f <nsipc>
}
  801fae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fb1:	c9                   	leave  
  801fb2:	c3                   	ret    

00801fb3 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801fb3:	55                   	push   %ebp
  801fb4:	89 e5                	mov    %esp,%ebp
  801fb6:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbc:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801fc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fc4:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801fc9:	b8 06 00 00 00       	mov    $0x6,%eax
  801fce:	e8 9c fe ff ff       	call   801e6f <nsipc>
}
  801fd3:	c9                   	leave  
  801fd4:	c3                   	ret    

00801fd5 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801fd5:	55                   	push   %ebp
  801fd6:	89 e5                	mov    %esp,%ebp
  801fd8:	56                   	push   %esi
  801fd9:	53                   	push   %ebx
  801fda:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe0:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801fe5:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801feb:	8b 45 14             	mov    0x14(%ebp),%eax
  801fee:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801ff3:	b8 07 00 00 00       	mov    $0x7,%eax
  801ff8:	e8 72 fe ff ff       	call   801e6f <nsipc>
  801ffd:	89 c3                	mov    %eax,%ebx
  801fff:	85 c0                	test   %eax,%eax
  802001:	78 1f                	js     802022 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802003:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802008:	7f 21                	jg     80202b <nsipc_recv+0x56>
  80200a:	39 c6                	cmp    %eax,%esi
  80200c:	7c 1d                	jl     80202b <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80200e:	83 ec 04             	sub    $0x4,%esp
  802011:	50                   	push   %eax
  802012:	68 00 60 80 00       	push   $0x806000
  802017:	ff 75 0c             	pushl  0xc(%ebp)
  80201a:	e8 ca ed ff ff       	call   800de9 <memmove>
  80201f:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802022:	89 d8                	mov    %ebx,%eax
  802024:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802027:	5b                   	pop    %ebx
  802028:	5e                   	pop    %esi
  802029:	5d                   	pop    %ebp
  80202a:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80202b:	68 f3 2c 80 00       	push   $0x802cf3
  802030:	68 bb 2c 80 00       	push   $0x802cbb
  802035:	6a 62                	push   $0x62
  802037:	68 08 2d 80 00       	push   $0x802d08
  80203c:	e8 d5 e2 ff ff       	call   800316 <_panic>

00802041 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802041:	55                   	push   %ebp
  802042:	89 e5                	mov    %esp,%ebp
  802044:	53                   	push   %ebx
  802045:	83 ec 04             	sub    $0x4,%esp
  802048:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80204b:	8b 45 08             	mov    0x8(%ebp),%eax
  80204e:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  802053:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802059:	7f 2e                	jg     802089 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80205b:	83 ec 04             	sub    $0x4,%esp
  80205e:	53                   	push   %ebx
  80205f:	ff 75 0c             	pushl  0xc(%ebp)
  802062:	68 0c 60 80 00       	push   $0x80600c
  802067:	e8 7d ed ff ff       	call   800de9 <memmove>
	nsipcbuf.send.req_size = size;
  80206c:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  802072:	8b 45 14             	mov    0x14(%ebp),%eax
  802075:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  80207a:	b8 08 00 00 00       	mov    $0x8,%eax
  80207f:	e8 eb fd ff ff       	call   801e6f <nsipc>
}
  802084:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802087:	c9                   	leave  
  802088:	c3                   	ret    
	assert(size < 1600);
  802089:	68 14 2d 80 00       	push   $0x802d14
  80208e:	68 bb 2c 80 00       	push   $0x802cbb
  802093:	6a 6d                	push   $0x6d
  802095:	68 08 2d 80 00       	push   $0x802d08
  80209a:	e8 77 e2 ff ff       	call   800316 <_panic>

0080209f <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80209f:	55                   	push   %ebp
  8020a0:	89 e5                	mov    %esp,%ebp
  8020a2:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8020a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a8:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  8020ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b0:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  8020b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8020b8:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  8020bd:	b8 09 00 00 00       	mov    $0x9,%eax
  8020c2:	e8 a8 fd ff ff       	call   801e6f <nsipc>
}
  8020c7:	c9                   	leave  
  8020c8:	c3                   	ret    

008020c9 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8020c9:	55                   	push   %ebp
  8020ca:	89 e5                	mov    %esp,%ebp
  8020cc:	56                   	push   %esi
  8020cd:	53                   	push   %ebx
  8020ce:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8020d1:	83 ec 0c             	sub    $0xc,%esp
  8020d4:	ff 75 08             	pushl  0x8(%ebp)
  8020d7:	e8 56 f2 ff ff       	call   801332 <fd2data>
  8020dc:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8020de:	83 c4 08             	add    $0x8,%esp
  8020e1:	68 20 2d 80 00       	push   $0x802d20
  8020e6:	53                   	push   %ebx
  8020e7:	e8 6f eb ff ff       	call   800c5b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8020ec:	8b 46 04             	mov    0x4(%esi),%eax
  8020ef:	2b 06                	sub    (%esi),%eax
  8020f1:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8020f7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8020fe:	00 00 00 
	stat->st_dev = &devpipe;
  802101:	c7 83 88 00 00 00 58 	movl   $0x803058,0x88(%ebx)
  802108:	30 80 00 
	return 0;
}
  80210b:	b8 00 00 00 00       	mov    $0x0,%eax
  802110:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802113:	5b                   	pop    %ebx
  802114:	5e                   	pop    %esi
  802115:	5d                   	pop    %ebp
  802116:	c3                   	ret    

00802117 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802117:	55                   	push   %ebp
  802118:	89 e5                	mov    %esp,%ebp
  80211a:	53                   	push   %ebx
  80211b:	83 ec 0c             	sub    $0xc,%esp
  80211e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802121:	53                   	push   %ebx
  802122:	6a 00                	push   $0x0
  802124:	e8 a9 ef ff ff       	call   8010d2 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802129:	89 1c 24             	mov    %ebx,(%esp)
  80212c:	e8 01 f2 ff ff       	call   801332 <fd2data>
  802131:	83 c4 08             	add    $0x8,%esp
  802134:	50                   	push   %eax
  802135:	6a 00                	push   $0x0
  802137:	e8 96 ef ff ff       	call   8010d2 <sys_page_unmap>
}
  80213c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80213f:	c9                   	leave  
  802140:	c3                   	ret    

00802141 <_pipeisclosed>:
{
  802141:	55                   	push   %ebp
  802142:	89 e5                	mov    %esp,%ebp
  802144:	57                   	push   %edi
  802145:	56                   	push   %esi
  802146:	53                   	push   %ebx
  802147:	83 ec 1c             	sub    $0x1c,%esp
  80214a:	89 c7                	mov    %eax,%edi
  80214c:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80214e:	a1 08 44 80 00       	mov    0x804408,%eax
  802153:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802156:	83 ec 0c             	sub    $0xc,%esp
  802159:	57                   	push   %edi
  80215a:	e8 b4 03 00 00       	call   802513 <pageref>
  80215f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802162:	89 34 24             	mov    %esi,(%esp)
  802165:	e8 a9 03 00 00       	call   802513 <pageref>
		nn = thisenv->env_runs;
  80216a:	8b 15 08 44 80 00    	mov    0x804408,%edx
  802170:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802173:	83 c4 10             	add    $0x10,%esp
  802176:	39 cb                	cmp    %ecx,%ebx
  802178:	74 1b                	je     802195 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80217a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80217d:	75 cf                	jne    80214e <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80217f:	8b 42 58             	mov    0x58(%edx),%eax
  802182:	6a 01                	push   $0x1
  802184:	50                   	push   %eax
  802185:	53                   	push   %ebx
  802186:	68 27 2d 80 00       	push   $0x802d27
  80218b:	e8 7c e2 ff ff       	call   80040c <cprintf>
  802190:	83 c4 10             	add    $0x10,%esp
  802193:	eb b9                	jmp    80214e <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802195:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802198:	0f 94 c0             	sete   %al
  80219b:	0f b6 c0             	movzbl %al,%eax
}
  80219e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021a1:	5b                   	pop    %ebx
  8021a2:	5e                   	pop    %esi
  8021a3:	5f                   	pop    %edi
  8021a4:	5d                   	pop    %ebp
  8021a5:	c3                   	ret    

008021a6 <devpipe_write>:
{
  8021a6:	55                   	push   %ebp
  8021a7:	89 e5                	mov    %esp,%ebp
  8021a9:	57                   	push   %edi
  8021aa:	56                   	push   %esi
  8021ab:	53                   	push   %ebx
  8021ac:	83 ec 28             	sub    $0x28,%esp
  8021af:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8021b2:	56                   	push   %esi
  8021b3:	e8 7a f1 ff ff       	call   801332 <fd2data>
  8021b8:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8021ba:	83 c4 10             	add    $0x10,%esp
  8021bd:	bf 00 00 00 00       	mov    $0x0,%edi
  8021c2:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8021c5:	74 4f                	je     802216 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8021c7:	8b 43 04             	mov    0x4(%ebx),%eax
  8021ca:	8b 0b                	mov    (%ebx),%ecx
  8021cc:	8d 51 20             	lea    0x20(%ecx),%edx
  8021cf:	39 d0                	cmp    %edx,%eax
  8021d1:	72 14                	jb     8021e7 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8021d3:	89 da                	mov    %ebx,%edx
  8021d5:	89 f0                	mov    %esi,%eax
  8021d7:	e8 65 ff ff ff       	call   802141 <_pipeisclosed>
  8021dc:	85 c0                	test   %eax,%eax
  8021de:	75 3b                	jne    80221b <devpipe_write+0x75>
			sys_yield();
  8021e0:	e8 49 ee ff ff       	call   80102e <sys_yield>
  8021e5:	eb e0                	jmp    8021c7 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8021e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8021ea:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8021ee:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8021f1:	89 c2                	mov    %eax,%edx
  8021f3:	c1 fa 1f             	sar    $0x1f,%edx
  8021f6:	89 d1                	mov    %edx,%ecx
  8021f8:	c1 e9 1b             	shr    $0x1b,%ecx
  8021fb:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8021fe:	83 e2 1f             	and    $0x1f,%edx
  802201:	29 ca                	sub    %ecx,%edx
  802203:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802207:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80220b:	83 c0 01             	add    $0x1,%eax
  80220e:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802211:	83 c7 01             	add    $0x1,%edi
  802214:	eb ac                	jmp    8021c2 <devpipe_write+0x1c>
	return i;
  802216:	8b 45 10             	mov    0x10(%ebp),%eax
  802219:	eb 05                	jmp    802220 <devpipe_write+0x7a>
				return 0;
  80221b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802220:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802223:	5b                   	pop    %ebx
  802224:	5e                   	pop    %esi
  802225:	5f                   	pop    %edi
  802226:	5d                   	pop    %ebp
  802227:	c3                   	ret    

00802228 <devpipe_read>:
{
  802228:	55                   	push   %ebp
  802229:	89 e5                	mov    %esp,%ebp
  80222b:	57                   	push   %edi
  80222c:	56                   	push   %esi
  80222d:	53                   	push   %ebx
  80222e:	83 ec 18             	sub    $0x18,%esp
  802231:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802234:	57                   	push   %edi
  802235:	e8 f8 f0 ff ff       	call   801332 <fd2data>
  80223a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80223c:	83 c4 10             	add    $0x10,%esp
  80223f:	be 00 00 00 00       	mov    $0x0,%esi
  802244:	3b 75 10             	cmp    0x10(%ebp),%esi
  802247:	75 14                	jne    80225d <devpipe_read+0x35>
	return i;
  802249:	8b 45 10             	mov    0x10(%ebp),%eax
  80224c:	eb 02                	jmp    802250 <devpipe_read+0x28>
				return i;
  80224e:	89 f0                	mov    %esi,%eax
}
  802250:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802253:	5b                   	pop    %ebx
  802254:	5e                   	pop    %esi
  802255:	5f                   	pop    %edi
  802256:	5d                   	pop    %ebp
  802257:	c3                   	ret    
			sys_yield();
  802258:	e8 d1 ed ff ff       	call   80102e <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80225d:	8b 03                	mov    (%ebx),%eax
  80225f:	3b 43 04             	cmp    0x4(%ebx),%eax
  802262:	75 18                	jne    80227c <devpipe_read+0x54>
			if (i > 0)
  802264:	85 f6                	test   %esi,%esi
  802266:	75 e6                	jne    80224e <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802268:	89 da                	mov    %ebx,%edx
  80226a:	89 f8                	mov    %edi,%eax
  80226c:	e8 d0 fe ff ff       	call   802141 <_pipeisclosed>
  802271:	85 c0                	test   %eax,%eax
  802273:	74 e3                	je     802258 <devpipe_read+0x30>
				return 0;
  802275:	b8 00 00 00 00       	mov    $0x0,%eax
  80227a:	eb d4                	jmp    802250 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80227c:	99                   	cltd   
  80227d:	c1 ea 1b             	shr    $0x1b,%edx
  802280:	01 d0                	add    %edx,%eax
  802282:	83 e0 1f             	and    $0x1f,%eax
  802285:	29 d0                	sub    %edx,%eax
  802287:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80228c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80228f:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802292:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802295:	83 c6 01             	add    $0x1,%esi
  802298:	eb aa                	jmp    802244 <devpipe_read+0x1c>

0080229a <pipe>:
{
  80229a:	55                   	push   %ebp
  80229b:	89 e5                	mov    %esp,%ebp
  80229d:	56                   	push   %esi
  80229e:	53                   	push   %ebx
  80229f:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8022a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022a5:	50                   	push   %eax
  8022a6:	e8 9e f0 ff ff       	call   801349 <fd_alloc>
  8022ab:	89 c3                	mov    %eax,%ebx
  8022ad:	83 c4 10             	add    $0x10,%esp
  8022b0:	85 c0                	test   %eax,%eax
  8022b2:	0f 88 23 01 00 00    	js     8023db <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022b8:	83 ec 04             	sub    $0x4,%esp
  8022bb:	68 07 04 00 00       	push   $0x407
  8022c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8022c3:	6a 00                	push   $0x0
  8022c5:	e8 83 ed ff ff       	call   80104d <sys_page_alloc>
  8022ca:	89 c3                	mov    %eax,%ebx
  8022cc:	83 c4 10             	add    $0x10,%esp
  8022cf:	85 c0                	test   %eax,%eax
  8022d1:	0f 88 04 01 00 00    	js     8023db <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8022d7:	83 ec 0c             	sub    $0xc,%esp
  8022da:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8022dd:	50                   	push   %eax
  8022de:	e8 66 f0 ff ff       	call   801349 <fd_alloc>
  8022e3:	89 c3                	mov    %eax,%ebx
  8022e5:	83 c4 10             	add    $0x10,%esp
  8022e8:	85 c0                	test   %eax,%eax
  8022ea:	0f 88 db 00 00 00    	js     8023cb <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022f0:	83 ec 04             	sub    $0x4,%esp
  8022f3:	68 07 04 00 00       	push   $0x407
  8022f8:	ff 75 f0             	pushl  -0x10(%ebp)
  8022fb:	6a 00                	push   $0x0
  8022fd:	e8 4b ed ff ff       	call   80104d <sys_page_alloc>
  802302:	89 c3                	mov    %eax,%ebx
  802304:	83 c4 10             	add    $0x10,%esp
  802307:	85 c0                	test   %eax,%eax
  802309:	0f 88 bc 00 00 00    	js     8023cb <pipe+0x131>
	va = fd2data(fd0);
  80230f:	83 ec 0c             	sub    $0xc,%esp
  802312:	ff 75 f4             	pushl  -0xc(%ebp)
  802315:	e8 18 f0 ff ff       	call   801332 <fd2data>
  80231a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80231c:	83 c4 0c             	add    $0xc,%esp
  80231f:	68 07 04 00 00       	push   $0x407
  802324:	50                   	push   %eax
  802325:	6a 00                	push   $0x0
  802327:	e8 21 ed ff ff       	call   80104d <sys_page_alloc>
  80232c:	89 c3                	mov    %eax,%ebx
  80232e:	83 c4 10             	add    $0x10,%esp
  802331:	85 c0                	test   %eax,%eax
  802333:	0f 88 82 00 00 00    	js     8023bb <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802339:	83 ec 0c             	sub    $0xc,%esp
  80233c:	ff 75 f0             	pushl  -0x10(%ebp)
  80233f:	e8 ee ef ff ff       	call   801332 <fd2data>
  802344:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80234b:	50                   	push   %eax
  80234c:	6a 00                	push   $0x0
  80234e:	56                   	push   %esi
  80234f:	6a 00                	push   $0x0
  802351:	e8 3a ed ff ff       	call   801090 <sys_page_map>
  802356:	89 c3                	mov    %eax,%ebx
  802358:	83 c4 20             	add    $0x20,%esp
  80235b:	85 c0                	test   %eax,%eax
  80235d:	78 4e                	js     8023ad <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  80235f:	a1 58 30 80 00       	mov    0x803058,%eax
  802364:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802367:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802369:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80236c:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802373:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802376:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802378:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80237b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802382:	83 ec 0c             	sub    $0xc,%esp
  802385:	ff 75 f4             	pushl  -0xc(%ebp)
  802388:	e8 95 ef ff ff       	call   801322 <fd2num>
  80238d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802390:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802392:	83 c4 04             	add    $0x4,%esp
  802395:	ff 75 f0             	pushl  -0x10(%ebp)
  802398:	e8 85 ef ff ff       	call   801322 <fd2num>
  80239d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023a0:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8023a3:	83 c4 10             	add    $0x10,%esp
  8023a6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8023ab:	eb 2e                	jmp    8023db <pipe+0x141>
	sys_page_unmap(0, va);
  8023ad:	83 ec 08             	sub    $0x8,%esp
  8023b0:	56                   	push   %esi
  8023b1:	6a 00                	push   $0x0
  8023b3:	e8 1a ed ff ff       	call   8010d2 <sys_page_unmap>
  8023b8:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8023bb:	83 ec 08             	sub    $0x8,%esp
  8023be:	ff 75 f0             	pushl  -0x10(%ebp)
  8023c1:	6a 00                	push   $0x0
  8023c3:	e8 0a ed ff ff       	call   8010d2 <sys_page_unmap>
  8023c8:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8023cb:	83 ec 08             	sub    $0x8,%esp
  8023ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8023d1:	6a 00                	push   $0x0
  8023d3:	e8 fa ec ff ff       	call   8010d2 <sys_page_unmap>
  8023d8:	83 c4 10             	add    $0x10,%esp
}
  8023db:	89 d8                	mov    %ebx,%eax
  8023dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023e0:	5b                   	pop    %ebx
  8023e1:	5e                   	pop    %esi
  8023e2:	5d                   	pop    %ebp
  8023e3:	c3                   	ret    

008023e4 <pipeisclosed>:
{
  8023e4:	55                   	push   %ebp
  8023e5:	89 e5                	mov    %esp,%ebp
  8023e7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023ed:	50                   	push   %eax
  8023ee:	ff 75 08             	pushl  0x8(%ebp)
  8023f1:	e8 a5 ef ff ff       	call   80139b <fd_lookup>
  8023f6:	83 c4 10             	add    $0x10,%esp
  8023f9:	85 c0                	test   %eax,%eax
  8023fb:	78 18                	js     802415 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8023fd:	83 ec 0c             	sub    $0xc,%esp
  802400:	ff 75 f4             	pushl  -0xc(%ebp)
  802403:	e8 2a ef ff ff       	call   801332 <fd2data>
	return _pipeisclosed(fd, p);
  802408:	89 c2                	mov    %eax,%edx
  80240a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240d:	e8 2f fd ff ff       	call   802141 <_pipeisclosed>
  802412:	83 c4 10             	add    $0x10,%esp
}
  802415:	c9                   	leave  
  802416:	c3                   	ret    

00802417 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802417:	55                   	push   %ebp
  802418:	89 e5                	mov    %esp,%ebp
  80241a:	56                   	push   %esi
  80241b:	53                   	push   %ebx
  80241c:	8b 75 08             	mov    0x8(%ebp),%esi
  80241f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802422:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802425:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802427:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80242c:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80242f:	83 ec 0c             	sub    $0xc,%esp
  802432:	50                   	push   %eax
  802433:	e8 c5 ed ff ff       	call   8011fd <sys_ipc_recv>
	if(ret < 0){
  802438:	83 c4 10             	add    $0x10,%esp
  80243b:	85 c0                	test   %eax,%eax
  80243d:	78 2b                	js     80246a <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80243f:	85 f6                	test   %esi,%esi
  802441:	74 0a                	je     80244d <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  802443:	a1 08 44 80 00       	mov    0x804408,%eax
  802448:	8b 40 74             	mov    0x74(%eax),%eax
  80244b:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80244d:	85 db                	test   %ebx,%ebx
  80244f:	74 0a                	je     80245b <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  802451:	a1 08 44 80 00       	mov    0x804408,%eax
  802456:	8b 40 78             	mov    0x78(%eax),%eax
  802459:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  80245b:	a1 08 44 80 00       	mov    0x804408,%eax
  802460:	8b 40 70             	mov    0x70(%eax),%eax
}
  802463:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802466:	5b                   	pop    %ebx
  802467:	5e                   	pop    %esi
  802468:	5d                   	pop    %ebp
  802469:	c3                   	ret    
		if(from_env_store)
  80246a:	85 f6                	test   %esi,%esi
  80246c:	74 06                	je     802474 <ipc_recv+0x5d>
			*from_env_store = 0;
  80246e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802474:	85 db                	test   %ebx,%ebx
  802476:	74 eb                	je     802463 <ipc_recv+0x4c>
			*perm_store = 0;
  802478:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80247e:	eb e3                	jmp    802463 <ipc_recv+0x4c>

00802480 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802480:	55                   	push   %ebp
  802481:	89 e5                	mov    %esp,%ebp
  802483:	57                   	push   %edi
  802484:	56                   	push   %esi
  802485:	53                   	push   %ebx
  802486:	83 ec 0c             	sub    $0xc,%esp
  802489:	8b 7d 08             	mov    0x8(%ebp),%edi
  80248c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80248f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802492:	85 db                	test   %ebx,%ebx
  802494:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802499:	0f 44 d8             	cmove  %eax,%ebx
  80249c:	eb 05                	jmp    8024a3 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80249e:	e8 8b eb ff ff       	call   80102e <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8024a3:	ff 75 14             	pushl  0x14(%ebp)
  8024a6:	53                   	push   %ebx
  8024a7:	56                   	push   %esi
  8024a8:	57                   	push   %edi
  8024a9:	e8 2c ed ff ff       	call   8011da <sys_ipc_try_send>
  8024ae:	83 c4 10             	add    $0x10,%esp
  8024b1:	85 c0                	test   %eax,%eax
  8024b3:	74 1b                	je     8024d0 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8024b5:	79 e7                	jns    80249e <ipc_send+0x1e>
  8024b7:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8024ba:	74 e2                	je     80249e <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8024bc:	83 ec 04             	sub    $0x4,%esp
  8024bf:	68 3f 2d 80 00       	push   $0x802d3f
  8024c4:	6a 48                	push   $0x48
  8024c6:	68 54 2d 80 00       	push   $0x802d54
  8024cb:	e8 46 de ff ff       	call   800316 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8024d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024d3:	5b                   	pop    %ebx
  8024d4:	5e                   	pop    %esi
  8024d5:	5f                   	pop    %edi
  8024d6:	5d                   	pop    %ebp
  8024d7:	c3                   	ret    

008024d8 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8024d8:	55                   	push   %ebp
  8024d9:	89 e5                	mov    %esp,%ebp
  8024db:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8024de:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8024e3:	89 c2                	mov    %eax,%edx
  8024e5:	c1 e2 07             	shl    $0x7,%edx
  8024e8:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8024ee:	8b 52 50             	mov    0x50(%edx),%edx
  8024f1:	39 ca                	cmp    %ecx,%edx
  8024f3:	74 11                	je     802506 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8024f5:	83 c0 01             	add    $0x1,%eax
  8024f8:	3d 00 04 00 00       	cmp    $0x400,%eax
  8024fd:	75 e4                	jne    8024e3 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8024ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802504:	eb 0b                	jmp    802511 <ipc_find_env+0x39>
			return envs[i].env_id;
  802506:	c1 e0 07             	shl    $0x7,%eax
  802509:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80250e:	8b 40 48             	mov    0x48(%eax),%eax
}
  802511:	5d                   	pop    %ebp
  802512:	c3                   	ret    

00802513 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802513:	55                   	push   %ebp
  802514:	89 e5                	mov    %esp,%ebp
  802516:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802519:	89 d0                	mov    %edx,%eax
  80251b:	c1 e8 16             	shr    $0x16,%eax
  80251e:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802525:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80252a:	f6 c1 01             	test   $0x1,%cl
  80252d:	74 1d                	je     80254c <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80252f:	c1 ea 0c             	shr    $0xc,%edx
  802532:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802539:	f6 c2 01             	test   $0x1,%dl
  80253c:	74 0e                	je     80254c <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80253e:	c1 ea 0c             	shr    $0xc,%edx
  802541:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802548:	ef 
  802549:	0f b7 c0             	movzwl %ax,%eax
}
  80254c:	5d                   	pop    %ebp
  80254d:	c3                   	ret    
  80254e:	66 90                	xchg   %ax,%ax

00802550 <__udivdi3>:
  802550:	55                   	push   %ebp
  802551:	57                   	push   %edi
  802552:	56                   	push   %esi
  802553:	53                   	push   %ebx
  802554:	83 ec 1c             	sub    $0x1c,%esp
  802557:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80255b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80255f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802563:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802567:	85 d2                	test   %edx,%edx
  802569:	75 4d                	jne    8025b8 <__udivdi3+0x68>
  80256b:	39 f3                	cmp    %esi,%ebx
  80256d:	76 19                	jbe    802588 <__udivdi3+0x38>
  80256f:	31 ff                	xor    %edi,%edi
  802571:	89 e8                	mov    %ebp,%eax
  802573:	89 f2                	mov    %esi,%edx
  802575:	f7 f3                	div    %ebx
  802577:	89 fa                	mov    %edi,%edx
  802579:	83 c4 1c             	add    $0x1c,%esp
  80257c:	5b                   	pop    %ebx
  80257d:	5e                   	pop    %esi
  80257e:	5f                   	pop    %edi
  80257f:	5d                   	pop    %ebp
  802580:	c3                   	ret    
  802581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802588:	89 d9                	mov    %ebx,%ecx
  80258a:	85 db                	test   %ebx,%ebx
  80258c:	75 0b                	jne    802599 <__udivdi3+0x49>
  80258e:	b8 01 00 00 00       	mov    $0x1,%eax
  802593:	31 d2                	xor    %edx,%edx
  802595:	f7 f3                	div    %ebx
  802597:	89 c1                	mov    %eax,%ecx
  802599:	31 d2                	xor    %edx,%edx
  80259b:	89 f0                	mov    %esi,%eax
  80259d:	f7 f1                	div    %ecx
  80259f:	89 c6                	mov    %eax,%esi
  8025a1:	89 e8                	mov    %ebp,%eax
  8025a3:	89 f7                	mov    %esi,%edi
  8025a5:	f7 f1                	div    %ecx
  8025a7:	89 fa                	mov    %edi,%edx
  8025a9:	83 c4 1c             	add    $0x1c,%esp
  8025ac:	5b                   	pop    %ebx
  8025ad:	5e                   	pop    %esi
  8025ae:	5f                   	pop    %edi
  8025af:	5d                   	pop    %ebp
  8025b0:	c3                   	ret    
  8025b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025b8:	39 f2                	cmp    %esi,%edx
  8025ba:	77 1c                	ja     8025d8 <__udivdi3+0x88>
  8025bc:	0f bd fa             	bsr    %edx,%edi
  8025bf:	83 f7 1f             	xor    $0x1f,%edi
  8025c2:	75 2c                	jne    8025f0 <__udivdi3+0xa0>
  8025c4:	39 f2                	cmp    %esi,%edx
  8025c6:	72 06                	jb     8025ce <__udivdi3+0x7e>
  8025c8:	31 c0                	xor    %eax,%eax
  8025ca:	39 eb                	cmp    %ebp,%ebx
  8025cc:	77 a9                	ja     802577 <__udivdi3+0x27>
  8025ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8025d3:	eb a2                	jmp    802577 <__udivdi3+0x27>
  8025d5:	8d 76 00             	lea    0x0(%esi),%esi
  8025d8:	31 ff                	xor    %edi,%edi
  8025da:	31 c0                	xor    %eax,%eax
  8025dc:	89 fa                	mov    %edi,%edx
  8025de:	83 c4 1c             	add    $0x1c,%esp
  8025e1:	5b                   	pop    %ebx
  8025e2:	5e                   	pop    %esi
  8025e3:	5f                   	pop    %edi
  8025e4:	5d                   	pop    %ebp
  8025e5:	c3                   	ret    
  8025e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025ed:	8d 76 00             	lea    0x0(%esi),%esi
  8025f0:	89 f9                	mov    %edi,%ecx
  8025f2:	b8 20 00 00 00       	mov    $0x20,%eax
  8025f7:	29 f8                	sub    %edi,%eax
  8025f9:	d3 e2                	shl    %cl,%edx
  8025fb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8025ff:	89 c1                	mov    %eax,%ecx
  802601:	89 da                	mov    %ebx,%edx
  802603:	d3 ea                	shr    %cl,%edx
  802605:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802609:	09 d1                	or     %edx,%ecx
  80260b:	89 f2                	mov    %esi,%edx
  80260d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802611:	89 f9                	mov    %edi,%ecx
  802613:	d3 e3                	shl    %cl,%ebx
  802615:	89 c1                	mov    %eax,%ecx
  802617:	d3 ea                	shr    %cl,%edx
  802619:	89 f9                	mov    %edi,%ecx
  80261b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80261f:	89 eb                	mov    %ebp,%ebx
  802621:	d3 e6                	shl    %cl,%esi
  802623:	89 c1                	mov    %eax,%ecx
  802625:	d3 eb                	shr    %cl,%ebx
  802627:	09 de                	or     %ebx,%esi
  802629:	89 f0                	mov    %esi,%eax
  80262b:	f7 74 24 08          	divl   0x8(%esp)
  80262f:	89 d6                	mov    %edx,%esi
  802631:	89 c3                	mov    %eax,%ebx
  802633:	f7 64 24 0c          	mull   0xc(%esp)
  802637:	39 d6                	cmp    %edx,%esi
  802639:	72 15                	jb     802650 <__udivdi3+0x100>
  80263b:	89 f9                	mov    %edi,%ecx
  80263d:	d3 e5                	shl    %cl,%ebp
  80263f:	39 c5                	cmp    %eax,%ebp
  802641:	73 04                	jae    802647 <__udivdi3+0xf7>
  802643:	39 d6                	cmp    %edx,%esi
  802645:	74 09                	je     802650 <__udivdi3+0x100>
  802647:	89 d8                	mov    %ebx,%eax
  802649:	31 ff                	xor    %edi,%edi
  80264b:	e9 27 ff ff ff       	jmp    802577 <__udivdi3+0x27>
  802650:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802653:	31 ff                	xor    %edi,%edi
  802655:	e9 1d ff ff ff       	jmp    802577 <__udivdi3+0x27>
  80265a:	66 90                	xchg   %ax,%ax
  80265c:	66 90                	xchg   %ax,%ax
  80265e:	66 90                	xchg   %ax,%ax

00802660 <__umoddi3>:
  802660:	55                   	push   %ebp
  802661:	57                   	push   %edi
  802662:	56                   	push   %esi
  802663:	53                   	push   %ebx
  802664:	83 ec 1c             	sub    $0x1c,%esp
  802667:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80266b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80266f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802673:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802677:	89 da                	mov    %ebx,%edx
  802679:	85 c0                	test   %eax,%eax
  80267b:	75 43                	jne    8026c0 <__umoddi3+0x60>
  80267d:	39 df                	cmp    %ebx,%edi
  80267f:	76 17                	jbe    802698 <__umoddi3+0x38>
  802681:	89 f0                	mov    %esi,%eax
  802683:	f7 f7                	div    %edi
  802685:	89 d0                	mov    %edx,%eax
  802687:	31 d2                	xor    %edx,%edx
  802689:	83 c4 1c             	add    $0x1c,%esp
  80268c:	5b                   	pop    %ebx
  80268d:	5e                   	pop    %esi
  80268e:	5f                   	pop    %edi
  80268f:	5d                   	pop    %ebp
  802690:	c3                   	ret    
  802691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802698:	89 fd                	mov    %edi,%ebp
  80269a:	85 ff                	test   %edi,%edi
  80269c:	75 0b                	jne    8026a9 <__umoddi3+0x49>
  80269e:	b8 01 00 00 00       	mov    $0x1,%eax
  8026a3:	31 d2                	xor    %edx,%edx
  8026a5:	f7 f7                	div    %edi
  8026a7:	89 c5                	mov    %eax,%ebp
  8026a9:	89 d8                	mov    %ebx,%eax
  8026ab:	31 d2                	xor    %edx,%edx
  8026ad:	f7 f5                	div    %ebp
  8026af:	89 f0                	mov    %esi,%eax
  8026b1:	f7 f5                	div    %ebp
  8026b3:	89 d0                	mov    %edx,%eax
  8026b5:	eb d0                	jmp    802687 <__umoddi3+0x27>
  8026b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026be:	66 90                	xchg   %ax,%ax
  8026c0:	89 f1                	mov    %esi,%ecx
  8026c2:	39 d8                	cmp    %ebx,%eax
  8026c4:	76 0a                	jbe    8026d0 <__umoddi3+0x70>
  8026c6:	89 f0                	mov    %esi,%eax
  8026c8:	83 c4 1c             	add    $0x1c,%esp
  8026cb:	5b                   	pop    %ebx
  8026cc:	5e                   	pop    %esi
  8026cd:	5f                   	pop    %edi
  8026ce:	5d                   	pop    %ebp
  8026cf:	c3                   	ret    
  8026d0:	0f bd e8             	bsr    %eax,%ebp
  8026d3:	83 f5 1f             	xor    $0x1f,%ebp
  8026d6:	75 20                	jne    8026f8 <__umoddi3+0x98>
  8026d8:	39 d8                	cmp    %ebx,%eax
  8026da:	0f 82 b0 00 00 00    	jb     802790 <__umoddi3+0x130>
  8026e0:	39 f7                	cmp    %esi,%edi
  8026e2:	0f 86 a8 00 00 00    	jbe    802790 <__umoddi3+0x130>
  8026e8:	89 c8                	mov    %ecx,%eax
  8026ea:	83 c4 1c             	add    $0x1c,%esp
  8026ed:	5b                   	pop    %ebx
  8026ee:	5e                   	pop    %esi
  8026ef:	5f                   	pop    %edi
  8026f0:	5d                   	pop    %ebp
  8026f1:	c3                   	ret    
  8026f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8026f8:	89 e9                	mov    %ebp,%ecx
  8026fa:	ba 20 00 00 00       	mov    $0x20,%edx
  8026ff:	29 ea                	sub    %ebp,%edx
  802701:	d3 e0                	shl    %cl,%eax
  802703:	89 44 24 08          	mov    %eax,0x8(%esp)
  802707:	89 d1                	mov    %edx,%ecx
  802709:	89 f8                	mov    %edi,%eax
  80270b:	d3 e8                	shr    %cl,%eax
  80270d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802711:	89 54 24 04          	mov    %edx,0x4(%esp)
  802715:	8b 54 24 04          	mov    0x4(%esp),%edx
  802719:	09 c1                	or     %eax,%ecx
  80271b:	89 d8                	mov    %ebx,%eax
  80271d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802721:	89 e9                	mov    %ebp,%ecx
  802723:	d3 e7                	shl    %cl,%edi
  802725:	89 d1                	mov    %edx,%ecx
  802727:	d3 e8                	shr    %cl,%eax
  802729:	89 e9                	mov    %ebp,%ecx
  80272b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80272f:	d3 e3                	shl    %cl,%ebx
  802731:	89 c7                	mov    %eax,%edi
  802733:	89 d1                	mov    %edx,%ecx
  802735:	89 f0                	mov    %esi,%eax
  802737:	d3 e8                	shr    %cl,%eax
  802739:	89 e9                	mov    %ebp,%ecx
  80273b:	89 fa                	mov    %edi,%edx
  80273d:	d3 e6                	shl    %cl,%esi
  80273f:	09 d8                	or     %ebx,%eax
  802741:	f7 74 24 08          	divl   0x8(%esp)
  802745:	89 d1                	mov    %edx,%ecx
  802747:	89 f3                	mov    %esi,%ebx
  802749:	f7 64 24 0c          	mull   0xc(%esp)
  80274d:	89 c6                	mov    %eax,%esi
  80274f:	89 d7                	mov    %edx,%edi
  802751:	39 d1                	cmp    %edx,%ecx
  802753:	72 06                	jb     80275b <__umoddi3+0xfb>
  802755:	75 10                	jne    802767 <__umoddi3+0x107>
  802757:	39 c3                	cmp    %eax,%ebx
  802759:	73 0c                	jae    802767 <__umoddi3+0x107>
  80275b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80275f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802763:	89 d7                	mov    %edx,%edi
  802765:	89 c6                	mov    %eax,%esi
  802767:	89 ca                	mov    %ecx,%edx
  802769:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80276e:	29 f3                	sub    %esi,%ebx
  802770:	19 fa                	sbb    %edi,%edx
  802772:	89 d0                	mov    %edx,%eax
  802774:	d3 e0                	shl    %cl,%eax
  802776:	89 e9                	mov    %ebp,%ecx
  802778:	d3 eb                	shr    %cl,%ebx
  80277a:	d3 ea                	shr    %cl,%edx
  80277c:	09 d8                	or     %ebx,%eax
  80277e:	83 c4 1c             	add    $0x1c,%esp
  802781:	5b                   	pop    %ebx
  802782:	5e                   	pop    %esi
  802783:	5f                   	pop    %edi
  802784:	5d                   	pop    %ebp
  802785:	c3                   	ret    
  802786:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80278d:	8d 76 00             	lea    0x0(%esi),%esi
  802790:	89 da                	mov    %ebx,%edx
  802792:	29 fe                	sub    %edi,%esi
  802794:	19 c2                	sbb    %eax,%edx
  802796:	89 f1                	mov    %esi,%ecx
  802798:	89 c8                	mov    %ecx,%eax
  80279a:	e9 4b ff ff ff       	jmp    8026ea <__umoddi3+0x8a>
