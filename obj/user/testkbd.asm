
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
  80003f:	e8 3b 10 00 00       	call   80107f <sys_yield>
	for (i = 0; i < 10; ++i)
  800044:	83 eb 01             	sub    $0x1,%ebx
  800047:	75 f6                	jne    80003f <umain+0xc>

	close(0);
  800049:	83 ec 0c             	sub    $0xc,%esp
  80004c:	6a 00                	push   $0x0
  80004e:	e8 eb 14 00 00       	call   80153e <close>
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
  800062:	68 3c 28 80 00       	push   $0x80283c
  800067:	6a 11                	push   $0x11
  800069:	68 2d 28 80 00       	push   $0x80282d
  80006e:	e8 f4 02 00 00       	call   800367 <_panic>
		panic("opencons: %e", r);
  800073:	50                   	push   %eax
  800074:	68 20 28 80 00       	push   $0x802820
  800079:	6a 0f                	push   $0xf
  80007b:	68 2d 28 80 00       	push   $0x80282d
  800080:	e8 e2 02 00 00       	call   800367 <_panic>
	if ((r = dup(0, 1)) < 0)
  800085:	83 ec 08             	sub    $0x8,%esp
  800088:	6a 01                	push   $0x1
  80008a:	6a 00                	push   $0x0
  80008c:	e8 ff 14 00 00       	call   801590 <dup>
  800091:	83 c4 10             	add    $0x10,%esp
  800094:	85 c0                	test   %eax,%eax
  800096:	79 24                	jns    8000bc <umain+0x89>
		panic("dup: %e", r);
  800098:	50                   	push   %eax
  800099:	68 56 28 80 00       	push   $0x802856
  80009e:	6a 13                	push   $0x13
  8000a0:	68 2d 28 80 00       	push   $0x80282d
  8000a5:	e8 bd 02 00 00       	call   800367 <_panic>

		buf = readline("Type a line: ");
		if (buf != NULL)
			fprintf(1, "%s\n", buf);
		else
			fprintf(1, "(end of file received)\n");
  8000aa:	83 ec 08             	sub    $0x8,%esp
  8000ad:	68 6c 28 80 00       	push   $0x80286c
  8000b2:	6a 01                	push   $0x1
  8000b4:	e8 ed 1b 00 00       	call   801ca6 <fprintf>
  8000b9:	83 c4 10             	add    $0x10,%esp
		buf = readline("Type a line: ");
  8000bc:	83 ec 0c             	sub    $0xc,%esp
  8000bf:	68 5e 28 80 00       	push   $0x80285e
  8000c4:	e8 ba 0a 00 00       	call   800b83 <readline>
		if (buf != NULL)
  8000c9:	83 c4 10             	add    $0x10,%esp
  8000cc:	85 c0                	test   %eax,%eax
  8000ce:	74 da                	je     8000aa <umain+0x77>
			fprintf(1, "%s\n", buf);
  8000d0:	83 ec 04             	sub    $0x4,%esp
  8000d3:	50                   	push   %eax
  8000d4:	68 ef 28 80 00       	push   $0x8028ef
  8000d9:	6a 01                	push   $0x1
  8000db:	e8 c6 1b 00 00       	call   801ca6 <fprintf>
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
  8000f1:	68 84 28 80 00       	push   $0x802884
  8000f6:	ff 75 0c             	pushl  0xc(%ebp)
  8000f9:	e8 ae 0b 00 00       	call   800cac <strcpy>
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
  80013c:	e8 f9 0c 00 00       	call   800e3a <memmove>
		sys_cputs(buf, m);
  800141:	83 c4 08             	add    $0x8,%esp
  800144:	53                   	push   %ebx
  800145:	57                   	push   %edi
  800146:	e8 97 0e 00 00       	call   800fe2 <sys_cputs>
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
  80016d:	e8 8e 0e 00 00       	call   801000 <sys_cgetc>
  800172:	85 c0                	test   %eax,%eax
  800174:	75 07                	jne    80017d <devcons_read+0x21>
		sys_yield();
  800176:	e8 04 0f 00 00       	call   80107f <sys_yield>
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
  8001a9:	e8 34 0e 00 00       	call   800fe2 <sys_cputs>
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
  8001c1:	e8 b6 14 00 00       	call   80167c <read>
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
  8001e9:	e8 1e 12 00 00       	call   80140c <fd_lookup>
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
  800212:	e8 a3 11 00 00       	call   8013ba <fd_alloc>
  800217:	83 c4 10             	add    $0x10,%esp
  80021a:	85 c0                	test   %eax,%eax
  80021c:	78 3a                	js     800258 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80021e:	83 ec 04             	sub    $0x4,%esp
  800221:	68 07 04 00 00       	push   $0x407
  800226:	ff 75 f4             	pushl  -0xc(%ebp)
  800229:	6a 00                	push   $0x0
  80022b:	e8 6e 0e 00 00       	call   80109e <sys_page_alloc>
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
  800250:	e8 3e 11 00 00       	call   801393 <fd2num>
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
  80026d:	e8 ee 0d 00 00       	call   801060 <sys_getenvid>
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

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  8002d1:	a1 08 44 80 00       	mov    0x804408,%eax
  8002d6:	8b 40 48             	mov    0x48(%eax),%eax
  8002d9:	83 ec 08             	sub    $0x8,%esp
  8002dc:	50                   	push   %eax
  8002dd:	68 90 28 80 00       	push   $0x802890
  8002e2:	e8 76 01 00 00       	call   80045d <cprintf>
	cprintf("before umain\n");
  8002e7:	c7 04 24 ae 28 80 00 	movl   $0x8028ae,(%esp)
  8002ee:	e8 6a 01 00 00       	call   80045d <cprintf>
	// call user main routine
	umain(argc, argv);
  8002f3:	83 c4 08             	add    $0x8,%esp
  8002f6:	ff 75 0c             	pushl  0xc(%ebp)
  8002f9:	ff 75 08             	pushl  0x8(%ebp)
  8002fc:	e8 32 fd ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  800301:	c7 04 24 bc 28 80 00 	movl   $0x8028bc,(%esp)
  800308:	e8 50 01 00 00       	call   80045d <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  80030d:	a1 08 44 80 00       	mov    0x804408,%eax
  800312:	8b 40 48             	mov    0x48(%eax),%eax
  800315:	83 c4 08             	add    $0x8,%esp
  800318:	50                   	push   %eax
  800319:	68 c9 28 80 00       	push   $0x8028c9
  80031e:	e8 3a 01 00 00       	call   80045d <cprintf>
	// exit gracefully
	exit();
  800323:	e8 0b 00 00 00       	call   800333 <exit>
}
  800328:	83 c4 10             	add    $0x10,%esp
  80032b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80032e:	5b                   	pop    %ebx
  80032f:	5e                   	pop    %esi
  800330:	5f                   	pop    %edi
  800331:	5d                   	pop    %ebp
  800332:	c3                   	ret    

00800333 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800333:	55                   	push   %ebp
  800334:	89 e5                	mov    %esp,%ebp
  800336:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800339:	a1 08 44 80 00       	mov    0x804408,%eax
  80033e:	8b 40 48             	mov    0x48(%eax),%eax
  800341:	68 f4 28 80 00       	push   $0x8028f4
  800346:	50                   	push   %eax
  800347:	68 e8 28 80 00       	push   $0x8028e8
  80034c:	e8 0c 01 00 00       	call   80045d <cprintf>
	close_all();
  800351:	e8 15 12 00 00       	call   80156b <close_all>
	sys_env_destroy(0);
  800356:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80035d:	e8 bd 0c 00 00       	call   80101f <sys_env_destroy>
}
  800362:	83 c4 10             	add    $0x10,%esp
  800365:	c9                   	leave  
  800366:	c3                   	ret    

00800367 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800367:	55                   	push   %ebp
  800368:	89 e5                	mov    %esp,%ebp
  80036a:	56                   	push   %esi
  80036b:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80036c:	a1 08 44 80 00       	mov    0x804408,%eax
  800371:	8b 40 48             	mov    0x48(%eax),%eax
  800374:	83 ec 04             	sub    $0x4,%esp
  800377:	68 20 29 80 00       	push   $0x802920
  80037c:	50                   	push   %eax
  80037d:	68 e8 28 80 00       	push   $0x8028e8
  800382:	e8 d6 00 00 00       	call   80045d <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800387:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80038a:	8b 35 1c 30 80 00    	mov    0x80301c,%esi
  800390:	e8 cb 0c 00 00       	call   801060 <sys_getenvid>
  800395:	83 c4 04             	add    $0x4,%esp
  800398:	ff 75 0c             	pushl  0xc(%ebp)
  80039b:	ff 75 08             	pushl  0x8(%ebp)
  80039e:	56                   	push   %esi
  80039f:	50                   	push   %eax
  8003a0:	68 fc 28 80 00       	push   $0x8028fc
  8003a5:	e8 b3 00 00 00       	call   80045d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003aa:	83 c4 18             	add    $0x18,%esp
  8003ad:	53                   	push   %ebx
  8003ae:	ff 75 10             	pushl  0x10(%ebp)
  8003b1:	e8 56 00 00 00       	call   80040c <vcprintf>
	cprintf("\n");
  8003b6:	c7 04 24 ac 28 80 00 	movl   $0x8028ac,(%esp)
  8003bd:	e8 9b 00 00 00       	call   80045d <cprintf>
  8003c2:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003c5:	cc                   	int3   
  8003c6:	eb fd                	jmp    8003c5 <_panic+0x5e>

008003c8 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8003c8:	55                   	push   %ebp
  8003c9:	89 e5                	mov    %esp,%ebp
  8003cb:	53                   	push   %ebx
  8003cc:	83 ec 04             	sub    $0x4,%esp
  8003cf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8003d2:	8b 13                	mov    (%ebx),%edx
  8003d4:	8d 42 01             	lea    0x1(%edx),%eax
  8003d7:	89 03                	mov    %eax,(%ebx)
  8003d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003dc:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003e0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003e5:	74 09                	je     8003f0 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8003e7:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003ee:	c9                   	leave  
  8003ef:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8003f0:	83 ec 08             	sub    $0x8,%esp
  8003f3:	68 ff 00 00 00       	push   $0xff
  8003f8:	8d 43 08             	lea    0x8(%ebx),%eax
  8003fb:	50                   	push   %eax
  8003fc:	e8 e1 0b 00 00       	call   800fe2 <sys_cputs>
		b->idx = 0;
  800401:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800407:	83 c4 10             	add    $0x10,%esp
  80040a:	eb db                	jmp    8003e7 <putch+0x1f>

0080040c <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80040c:	55                   	push   %ebp
  80040d:	89 e5                	mov    %esp,%ebp
  80040f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800415:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80041c:	00 00 00 
	b.cnt = 0;
  80041f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800426:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800429:	ff 75 0c             	pushl  0xc(%ebp)
  80042c:	ff 75 08             	pushl  0x8(%ebp)
  80042f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800435:	50                   	push   %eax
  800436:	68 c8 03 80 00       	push   $0x8003c8
  80043b:	e8 4a 01 00 00       	call   80058a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800440:	83 c4 08             	add    $0x8,%esp
  800443:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800449:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80044f:	50                   	push   %eax
  800450:	e8 8d 0b 00 00       	call   800fe2 <sys_cputs>

	return b.cnt;
}
  800455:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80045b:	c9                   	leave  
  80045c:	c3                   	ret    

0080045d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80045d:	55                   	push   %ebp
  80045e:	89 e5                	mov    %esp,%ebp
  800460:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800463:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800466:	50                   	push   %eax
  800467:	ff 75 08             	pushl  0x8(%ebp)
  80046a:	e8 9d ff ff ff       	call   80040c <vcprintf>
	va_end(ap);

	return cnt;
}
  80046f:	c9                   	leave  
  800470:	c3                   	ret    

00800471 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800471:	55                   	push   %ebp
  800472:	89 e5                	mov    %esp,%ebp
  800474:	57                   	push   %edi
  800475:	56                   	push   %esi
  800476:	53                   	push   %ebx
  800477:	83 ec 1c             	sub    $0x1c,%esp
  80047a:	89 c6                	mov    %eax,%esi
  80047c:	89 d7                	mov    %edx,%edi
  80047e:	8b 45 08             	mov    0x8(%ebp),%eax
  800481:	8b 55 0c             	mov    0xc(%ebp),%edx
  800484:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800487:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80048a:	8b 45 10             	mov    0x10(%ebp),%eax
  80048d:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800490:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800494:	74 2c                	je     8004c2 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800496:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800499:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8004a0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004a3:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004a6:	39 c2                	cmp    %eax,%edx
  8004a8:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8004ab:	73 43                	jae    8004f0 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8004ad:	83 eb 01             	sub    $0x1,%ebx
  8004b0:	85 db                	test   %ebx,%ebx
  8004b2:	7e 6c                	jle    800520 <printnum+0xaf>
				putch(padc, putdat);
  8004b4:	83 ec 08             	sub    $0x8,%esp
  8004b7:	57                   	push   %edi
  8004b8:	ff 75 18             	pushl  0x18(%ebp)
  8004bb:	ff d6                	call   *%esi
  8004bd:	83 c4 10             	add    $0x10,%esp
  8004c0:	eb eb                	jmp    8004ad <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8004c2:	83 ec 0c             	sub    $0xc,%esp
  8004c5:	6a 20                	push   $0x20
  8004c7:	6a 00                	push   $0x0
  8004c9:	50                   	push   %eax
  8004ca:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004cd:	ff 75 e0             	pushl  -0x20(%ebp)
  8004d0:	89 fa                	mov    %edi,%edx
  8004d2:	89 f0                	mov    %esi,%eax
  8004d4:	e8 98 ff ff ff       	call   800471 <printnum>
		while (--width > 0)
  8004d9:	83 c4 20             	add    $0x20,%esp
  8004dc:	83 eb 01             	sub    $0x1,%ebx
  8004df:	85 db                	test   %ebx,%ebx
  8004e1:	7e 65                	jle    800548 <printnum+0xd7>
			putch(padc, putdat);
  8004e3:	83 ec 08             	sub    $0x8,%esp
  8004e6:	57                   	push   %edi
  8004e7:	6a 20                	push   $0x20
  8004e9:	ff d6                	call   *%esi
  8004eb:	83 c4 10             	add    $0x10,%esp
  8004ee:	eb ec                	jmp    8004dc <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8004f0:	83 ec 0c             	sub    $0xc,%esp
  8004f3:	ff 75 18             	pushl  0x18(%ebp)
  8004f6:	83 eb 01             	sub    $0x1,%ebx
  8004f9:	53                   	push   %ebx
  8004fa:	50                   	push   %eax
  8004fb:	83 ec 08             	sub    $0x8,%esp
  8004fe:	ff 75 dc             	pushl  -0x24(%ebp)
  800501:	ff 75 d8             	pushl  -0x28(%ebp)
  800504:	ff 75 e4             	pushl  -0x1c(%ebp)
  800507:	ff 75 e0             	pushl  -0x20(%ebp)
  80050a:	e8 b1 20 00 00       	call   8025c0 <__udivdi3>
  80050f:	83 c4 18             	add    $0x18,%esp
  800512:	52                   	push   %edx
  800513:	50                   	push   %eax
  800514:	89 fa                	mov    %edi,%edx
  800516:	89 f0                	mov    %esi,%eax
  800518:	e8 54 ff ff ff       	call   800471 <printnum>
  80051d:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800520:	83 ec 08             	sub    $0x8,%esp
  800523:	57                   	push   %edi
  800524:	83 ec 04             	sub    $0x4,%esp
  800527:	ff 75 dc             	pushl  -0x24(%ebp)
  80052a:	ff 75 d8             	pushl  -0x28(%ebp)
  80052d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800530:	ff 75 e0             	pushl  -0x20(%ebp)
  800533:	e8 98 21 00 00       	call   8026d0 <__umoddi3>
  800538:	83 c4 14             	add    $0x14,%esp
  80053b:	0f be 80 27 29 80 00 	movsbl 0x802927(%eax),%eax
  800542:	50                   	push   %eax
  800543:	ff d6                	call   *%esi
  800545:	83 c4 10             	add    $0x10,%esp
	}
}
  800548:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80054b:	5b                   	pop    %ebx
  80054c:	5e                   	pop    %esi
  80054d:	5f                   	pop    %edi
  80054e:	5d                   	pop    %ebp
  80054f:	c3                   	ret    

00800550 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800550:	55                   	push   %ebp
  800551:	89 e5                	mov    %esp,%ebp
  800553:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800556:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80055a:	8b 10                	mov    (%eax),%edx
  80055c:	3b 50 04             	cmp    0x4(%eax),%edx
  80055f:	73 0a                	jae    80056b <sprintputch+0x1b>
		*b->buf++ = ch;
  800561:	8d 4a 01             	lea    0x1(%edx),%ecx
  800564:	89 08                	mov    %ecx,(%eax)
  800566:	8b 45 08             	mov    0x8(%ebp),%eax
  800569:	88 02                	mov    %al,(%edx)
}
  80056b:	5d                   	pop    %ebp
  80056c:	c3                   	ret    

0080056d <printfmt>:
{
  80056d:	55                   	push   %ebp
  80056e:	89 e5                	mov    %esp,%ebp
  800570:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800573:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800576:	50                   	push   %eax
  800577:	ff 75 10             	pushl  0x10(%ebp)
  80057a:	ff 75 0c             	pushl  0xc(%ebp)
  80057d:	ff 75 08             	pushl  0x8(%ebp)
  800580:	e8 05 00 00 00       	call   80058a <vprintfmt>
}
  800585:	83 c4 10             	add    $0x10,%esp
  800588:	c9                   	leave  
  800589:	c3                   	ret    

0080058a <vprintfmt>:
{
  80058a:	55                   	push   %ebp
  80058b:	89 e5                	mov    %esp,%ebp
  80058d:	57                   	push   %edi
  80058e:	56                   	push   %esi
  80058f:	53                   	push   %ebx
  800590:	83 ec 3c             	sub    $0x3c,%esp
  800593:	8b 75 08             	mov    0x8(%ebp),%esi
  800596:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800599:	8b 7d 10             	mov    0x10(%ebp),%edi
  80059c:	e9 32 04 00 00       	jmp    8009d3 <vprintfmt+0x449>
		padc = ' ';
  8005a1:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8005a5:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8005ac:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8005b3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8005ba:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005c1:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8005c8:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8005cd:	8d 47 01             	lea    0x1(%edi),%eax
  8005d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005d3:	0f b6 17             	movzbl (%edi),%edx
  8005d6:	8d 42 dd             	lea    -0x23(%edx),%eax
  8005d9:	3c 55                	cmp    $0x55,%al
  8005db:	0f 87 12 05 00 00    	ja     800af3 <vprintfmt+0x569>
  8005e1:	0f b6 c0             	movzbl %al,%eax
  8005e4:	ff 24 85 00 2b 80 00 	jmp    *0x802b00(,%eax,4)
  8005eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8005ee:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8005f2:	eb d9                	jmp    8005cd <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8005f4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8005f7:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8005fb:	eb d0                	jmp    8005cd <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8005fd:	0f b6 d2             	movzbl %dl,%edx
  800600:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800603:	b8 00 00 00 00       	mov    $0x0,%eax
  800608:	89 75 08             	mov    %esi,0x8(%ebp)
  80060b:	eb 03                	jmp    800610 <vprintfmt+0x86>
  80060d:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800610:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800613:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800617:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80061a:	8d 72 d0             	lea    -0x30(%edx),%esi
  80061d:	83 fe 09             	cmp    $0x9,%esi
  800620:	76 eb                	jbe    80060d <vprintfmt+0x83>
  800622:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800625:	8b 75 08             	mov    0x8(%ebp),%esi
  800628:	eb 14                	jmp    80063e <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  80062a:	8b 45 14             	mov    0x14(%ebp),%eax
  80062d:	8b 00                	mov    (%eax),%eax
  80062f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800632:	8b 45 14             	mov    0x14(%ebp),%eax
  800635:	8d 40 04             	lea    0x4(%eax),%eax
  800638:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80063b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80063e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800642:	79 89                	jns    8005cd <vprintfmt+0x43>
				width = precision, precision = -1;
  800644:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800647:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80064a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800651:	e9 77 ff ff ff       	jmp    8005cd <vprintfmt+0x43>
  800656:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800659:	85 c0                	test   %eax,%eax
  80065b:	0f 48 c1             	cmovs  %ecx,%eax
  80065e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800661:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800664:	e9 64 ff ff ff       	jmp    8005cd <vprintfmt+0x43>
  800669:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80066c:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800673:	e9 55 ff ff ff       	jmp    8005cd <vprintfmt+0x43>
			lflag++;
  800678:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80067c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80067f:	e9 49 ff ff ff       	jmp    8005cd <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800684:	8b 45 14             	mov    0x14(%ebp),%eax
  800687:	8d 78 04             	lea    0x4(%eax),%edi
  80068a:	83 ec 08             	sub    $0x8,%esp
  80068d:	53                   	push   %ebx
  80068e:	ff 30                	pushl  (%eax)
  800690:	ff d6                	call   *%esi
			break;
  800692:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800695:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800698:	e9 33 03 00 00       	jmp    8009d0 <vprintfmt+0x446>
			err = va_arg(ap, int);
  80069d:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a0:	8d 78 04             	lea    0x4(%eax),%edi
  8006a3:	8b 00                	mov    (%eax),%eax
  8006a5:	99                   	cltd   
  8006a6:	31 d0                	xor    %edx,%eax
  8006a8:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8006aa:	83 f8 11             	cmp    $0x11,%eax
  8006ad:	7f 23                	jg     8006d2 <vprintfmt+0x148>
  8006af:	8b 14 85 60 2c 80 00 	mov    0x802c60(,%eax,4),%edx
  8006b6:	85 d2                	test   %edx,%edx
  8006b8:	74 18                	je     8006d2 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8006ba:	52                   	push   %edx
  8006bb:	68 91 2d 80 00       	push   $0x802d91
  8006c0:	53                   	push   %ebx
  8006c1:	56                   	push   %esi
  8006c2:	e8 a6 fe ff ff       	call   80056d <printfmt>
  8006c7:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8006ca:	89 7d 14             	mov    %edi,0x14(%ebp)
  8006cd:	e9 fe 02 00 00       	jmp    8009d0 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8006d2:	50                   	push   %eax
  8006d3:	68 3f 29 80 00       	push   $0x80293f
  8006d8:	53                   	push   %ebx
  8006d9:	56                   	push   %esi
  8006da:	e8 8e fe ff ff       	call   80056d <printfmt>
  8006df:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8006e2:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8006e5:	e9 e6 02 00 00       	jmp    8009d0 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8006ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ed:	83 c0 04             	add    $0x4,%eax
  8006f0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8006f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f6:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8006f8:	85 c9                	test   %ecx,%ecx
  8006fa:	b8 38 29 80 00       	mov    $0x802938,%eax
  8006ff:	0f 45 c1             	cmovne %ecx,%eax
  800702:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800705:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800709:	7e 06                	jle    800711 <vprintfmt+0x187>
  80070b:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80070f:	75 0d                	jne    80071e <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800711:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800714:	89 c7                	mov    %eax,%edi
  800716:	03 45 e0             	add    -0x20(%ebp),%eax
  800719:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80071c:	eb 53                	jmp    800771 <vprintfmt+0x1e7>
  80071e:	83 ec 08             	sub    $0x8,%esp
  800721:	ff 75 d8             	pushl  -0x28(%ebp)
  800724:	50                   	push   %eax
  800725:	e8 61 05 00 00       	call   800c8b <strnlen>
  80072a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80072d:	29 c1                	sub    %eax,%ecx
  80072f:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800732:	83 c4 10             	add    $0x10,%esp
  800735:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800737:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  80073b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80073e:	eb 0f                	jmp    80074f <vprintfmt+0x1c5>
					putch(padc, putdat);
  800740:	83 ec 08             	sub    $0x8,%esp
  800743:	53                   	push   %ebx
  800744:	ff 75 e0             	pushl  -0x20(%ebp)
  800747:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800749:	83 ef 01             	sub    $0x1,%edi
  80074c:	83 c4 10             	add    $0x10,%esp
  80074f:	85 ff                	test   %edi,%edi
  800751:	7f ed                	jg     800740 <vprintfmt+0x1b6>
  800753:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800756:	85 c9                	test   %ecx,%ecx
  800758:	b8 00 00 00 00       	mov    $0x0,%eax
  80075d:	0f 49 c1             	cmovns %ecx,%eax
  800760:	29 c1                	sub    %eax,%ecx
  800762:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800765:	eb aa                	jmp    800711 <vprintfmt+0x187>
					putch(ch, putdat);
  800767:	83 ec 08             	sub    $0x8,%esp
  80076a:	53                   	push   %ebx
  80076b:	52                   	push   %edx
  80076c:	ff d6                	call   *%esi
  80076e:	83 c4 10             	add    $0x10,%esp
  800771:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800774:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800776:	83 c7 01             	add    $0x1,%edi
  800779:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80077d:	0f be d0             	movsbl %al,%edx
  800780:	85 d2                	test   %edx,%edx
  800782:	74 4b                	je     8007cf <vprintfmt+0x245>
  800784:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800788:	78 06                	js     800790 <vprintfmt+0x206>
  80078a:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80078e:	78 1e                	js     8007ae <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800790:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800794:	74 d1                	je     800767 <vprintfmt+0x1dd>
  800796:	0f be c0             	movsbl %al,%eax
  800799:	83 e8 20             	sub    $0x20,%eax
  80079c:	83 f8 5e             	cmp    $0x5e,%eax
  80079f:	76 c6                	jbe    800767 <vprintfmt+0x1dd>
					putch('?', putdat);
  8007a1:	83 ec 08             	sub    $0x8,%esp
  8007a4:	53                   	push   %ebx
  8007a5:	6a 3f                	push   $0x3f
  8007a7:	ff d6                	call   *%esi
  8007a9:	83 c4 10             	add    $0x10,%esp
  8007ac:	eb c3                	jmp    800771 <vprintfmt+0x1e7>
  8007ae:	89 cf                	mov    %ecx,%edi
  8007b0:	eb 0e                	jmp    8007c0 <vprintfmt+0x236>
				putch(' ', putdat);
  8007b2:	83 ec 08             	sub    $0x8,%esp
  8007b5:	53                   	push   %ebx
  8007b6:	6a 20                	push   $0x20
  8007b8:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8007ba:	83 ef 01             	sub    $0x1,%edi
  8007bd:	83 c4 10             	add    $0x10,%esp
  8007c0:	85 ff                	test   %edi,%edi
  8007c2:	7f ee                	jg     8007b2 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8007c4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8007c7:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ca:	e9 01 02 00 00       	jmp    8009d0 <vprintfmt+0x446>
  8007cf:	89 cf                	mov    %ecx,%edi
  8007d1:	eb ed                	jmp    8007c0 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8007d3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8007d6:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8007dd:	e9 eb fd ff ff       	jmp    8005cd <vprintfmt+0x43>
	if (lflag >= 2)
  8007e2:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007e6:	7f 21                	jg     800809 <vprintfmt+0x27f>
	else if (lflag)
  8007e8:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007ec:	74 68                	je     800856 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8007ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f1:	8b 00                	mov    (%eax),%eax
  8007f3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8007f6:	89 c1                	mov    %eax,%ecx
  8007f8:	c1 f9 1f             	sar    $0x1f,%ecx
  8007fb:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8007fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800801:	8d 40 04             	lea    0x4(%eax),%eax
  800804:	89 45 14             	mov    %eax,0x14(%ebp)
  800807:	eb 17                	jmp    800820 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800809:	8b 45 14             	mov    0x14(%ebp),%eax
  80080c:	8b 50 04             	mov    0x4(%eax),%edx
  80080f:	8b 00                	mov    (%eax),%eax
  800811:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800814:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800817:	8b 45 14             	mov    0x14(%ebp),%eax
  80081a:	8d 40 08             	lea    0x8(%eax),%eax
  80081d:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800820:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800823:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800826:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800829:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80082c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800830:	78 3f                	js     800871 <vprintfmt+0x2e7>
			base = 10;
  800832:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800837:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80083b:	0f 84 71 01 00 00    	je     8009b2 <vprintfmt+0x428>
				putch('+', putdat);
  800841:	83 ec 08             	sub    $0x8,%esp
  800844:	53                   	push   %ebx
  800845:	6a 2b                	push   $0x2b
  800847:	ff d6                	call   *%esi
  800849:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80084c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800851:	e9 5c 01 00 00       	jmp    8009b2 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800856:	8b 45 14             	mov    0x14(%ebp),%eax
  800859:	8b 00                	mov    (%eax),%eax
  80085b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80085e:	89 c1                	mov    %eax,%ecx
  800860:	c1 f9 1f             	sar    $0x1f,%ecx
  800863:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800866:	8b 45 14             	mov    0x14(%ebp),%eax
  800869:	8d 40 04             	lea    0x4(%eax),%eax
  80086c:	89 45 14             	mov    %eax,0x14(%ebp)
  80086f:	eb af                	jmp    800820 <vprintfmt+0x296>
				putch('-', putdat);
  800871:	83 ec 08             	sub    $0x8,%esp
  800874:	53                   	push   %ebx
  800875:	6a 2d                	push   $0x2d
  800877:	ff d6                	call   *%esi
				num = -(long long) num;
  800879:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80087c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80087f:	f7 d8                	neg    %eax
  800881:	83 d2 00             	adc    $0x0,%edx
  800884:	f7 da                	neg    %edx
  800886:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800889:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80088c:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80088f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800894:	e9 19 01 00 00       	jmp    8009b2 <vprintfmt+0x428>
	if (lflag >= 2)
  800899:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80089d:	7f 29                	jg     8008c8 <vprintfmt+0x33e>
	else if (lflag)
  80089f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8008a3:	74 44                	je     8008e9 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8008a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a8:	8b 00                	mov    (%eax),%eax
  8008aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8008af:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008b2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b8:	8d 40 04             	lea    0x4(%eax),%eax
  8008bb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008be:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008c3:	e9 ea 00 00 00       	jmp    8009b2 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8008c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cb:	8b 50 04             	mov    0x4(%eax),%edx
  8008ce:	8b 00                	mov    (%eax),%eax
  8008d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008d3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d9:	8d 40 08             	lea    0x8(%eax),%eax
  8008dc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008df:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008e4:	e9 c9 00 00 00       	jmp    8009b2 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8008e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ec:	8b 00                	mov    (%eax),%eax
  8008ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008f6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fc:	8d 40 04             	lea    0x4(%eax),%eax
  8008ff:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800902:	b8 0a 00 00 00       	mov    $0xa,%eax
  800907:	e9 a6 00 00 00       	jmp    8009b2 <vprintfmt+0x428>
			putch('0', putdat);
  80090c:	83 ec 08             	sub    $0x8,%esp
  80090f:	53                   	push   %ebx
  800910:	6a 30                	push   $0x30
  800912:	ff d6                	call   *%esi
	if (lflag >= 2)
  800914:	83 c4 10             	add    $0x10,%esp
  800917:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80091b:	7f 26                	jg     800943 <vprintfmt+0x3b9>
	else if (lflag)
  80091d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800921:	74 3e                	je     800961 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800923:	8b 45 14             	mov    0x14(%ebp),%eax
  800926:	8b 00                	mov    (%eax),%eax
  800928:	ba 00 00 00 00       	mov    $0x0,%edx
  80092d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800930:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800933:	8b 45 14             	mov    0x14(%ebp),%eax
  800936:	8d 40 04             	lea    0x4(%eax),%eax
  800939:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80093c:	b8 08 00 00 00       	mov    $0x8,%eax
  800941:	eb 6f                	jmp    8009b2 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800943:	8b 45 14             	mov    0x14(%ebp),%eax
  800946:	8b 50 04             	mov    0x4(%eax),%edx
  800949:	8b 00                	mov    (%eax),%eax
  80094b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80094e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800951:	8b 45 14             	mov    0x14(%ebp),%eax
  800954:	8d 40 08             	lea    0x8(%eax),%eax
  800957:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80095a:	b8 08 00 00 00       	mov    $0x8,%eax
  80095f:	eb 51                	jmp    8009b2 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800961:	8b 45 14             	mov    0x14(%ebp),%eax
  800964:	8b 00                	mov    (%eax),%eax
  800966:	ba 00 00 00 00       	mov    $0x0,%edx
  80096b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80096e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800971:	8b 45 14             	mov    0x14(%ebp),%eax
  800974:	8d 40 04             	lea    0x4(%eax),%eax
  800977:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80097a:	b8 08 00 00 00       	mov    $0x8,%eax
  80097f:	eb 31                	jmp    8009b2 <vprintfmt+0x428>
			putch('0', putdat);
  800981:	83 ec 08             	sub    $0x8,%esp
  800984:	53                   	push   %ebx
  800985:	6a 30                	push   $0x30
  800987:	ff d6                	call   *%esi
			putch('x', putdat);
  800989:	83 c4 08             	add    $0x8,%esp
  80098c:	53                   	push   %ebx
  80098d:	6a 78                	push   $0x78
  80098f:	ff d6                	call   *%esi
			num = (unsigned long long)
  800991:	8b 45 14             	mov    0x14(%ebp),%eax
  800994:	8b 00                	mov    (%eax),%eax
  800996:	ba 00 00 00 00       	mov    $0x0,%edx
  80099b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80099e:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8009a1:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8009a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a7:	8d 40 04             	lea    0x4(%eax),%eax
  8009aa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009ad:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8009b2:	83 ec 0c             	sub    $0xc,%esp
  8009b5:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8009b9:	52                   	push   %edx
  8009ba:	ff 75 e0             	pushl  -0x20(%ebp)
  8009bd:	50                   	push   %eax
  8009be:	ff 75 dc             	pushl  -0x24(%ebp)
  8009c1:	ff 75 d8             	pushl  -0x28(%ebp)
  8009c4:	89 da                	mov    %ebx,%edx
  8009c6:	89 f0                	mov    %esi,%eax
  8009c8:	e8 a4 fa ff ff       	call   800471 <printnum>
			break;
  8009cd:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8009d0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009d3:	83 c7 01             	add    $0x1,%edi
  8009d6:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8009da:	83 f8 25             	cmp    $0x25,%eax
  8009dd:	0f 84 be fb ff ff    	je     8005a1 <vprintfmt+0x17>
			if (ch == '\0')
  8009e3:	85 c0                	test   %eax,%eax
  8009e5:	0f 84 28 01 00 00    	je     800b13 <vprintfmt+0x589>
			putch(ch, putdat);
  8009eb:	83 ec 08             	sub    $0x8,%esp
  8009ee:	53                   	push   %ebx
  8009ef:	50                   	push   %eax
  8009f0:	ff d6                	call   *%esi
  8009f2:	83 c4 10             	add    $0x10,%esp
  8009f5:	eb dc                	jmp    8009d3 <vprintfmt+0x449>
	if (lflag >= 2)
  8009f7:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8009fb:	7f 26                	jg     800a23 <vprintfmt+0x499>
	else if (lflag)
  8009fd:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800a01:	74 41                	je     800a44 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800a03:	8b 45 14             	mov    0x14(%ebp),%eax
  800a06:	8b 00                	mov    (%eax),%eax
  800a08:	ba 00 00 00 00       	mov    $0x0,%edx
  800a0d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a10:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a13:	8b 45 14             	mov    0x14(%ebp),%eax
  800a16:	8d 40 04             	lea    0x4(%eax),%eax
  800a19:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a1c:	b8 10 00 00 00       	mov    $0x10,%eax
  800a21:	eb 8f                	jmp    8009b2 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800a23:	8b 45 14             	mov    0x14(%ebp),%eax
  800a26:	8b 50 04             	mov    0x4(%eax),%edx
  800a29:	8b 00                	mov    (%eax),%eax
  800a2b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a2e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a31:	8b 45 14             	mov    0x14(%ebp),%eax
  800a34:	8d 40 08             	lea    0x8(%eax),%eax
  800a37:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a3a:	b8 10 00 00 00       	mov    $0x10,%eax
  800a3f:	e9 6e ff ff ff       	jmp    8009b2 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800a44:	8b 45 14             	mov    0x14(%ebp),%eax
  800a47:	8b 00                	mov    (%eax),%eax
  800a49:	ba 00 00 00 00       	mov    $0x0,%edx
  800a4e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a51:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a54:	8b 45 14             	mov    0x14(%ebp),%eax
  800a57:	8d 40 04             	lea    0x4(%eax),%eax
  800a5a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a5d:	b8 10 00 00 00       	mov    $0x10,%eax
  800a62:	e9 4b ff ff ff       	jmp    8009b2 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800a67:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6a:	83 c0 04             	add    $0x4,%eax
  800a6d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a70:	8b 45 14             	mov    0x14(%ebp),%eax
  800a73:	8b 00                	mov    (%eax),%eax
  800a75:	85 c0                	test   %eax,%eax
  800a77:	74 14                	je     800a8d <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800a79:	8b 13                	mov    (%ebx),%edx
  800a7b:	83 fa 7f             	cmp    $0x7f,%edx
  800a7e:	7f 37                	jg     800ab7 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800a80:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800a82:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a85:	89 45 14             	mov    %eax,0x14(%ebp)
  800a88:	e9 43 ff ff ff       	jmp    8009d0 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800a8d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a92:	bf 5d 2a 80 00       	mov    $0x802a5d,%edi
							putch(ch, putdat);
  800a97:	83 ec 08             	sub    $0x8,%esp
  800a9a:	53                   	push   %ebx
  800a9b:	50                   	push   %eax
  800a9c:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800a9e:	83 c7 01             	add    $0x1,%edi
  800aa1:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800aa5:	83 c4 10             	add    $0x10,%esp
  800aa8:	85 c0                	test   %eax,%eax
  800aaa:	75 eb                	jne    800a97 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800aac:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800aaf:	89 45 14             	mov    %eax,0x14(%ebp)
  800ab2:	e9 19 ff ff ff       	jmp    8009d0 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800ab7:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800ab9:	b8 0a 00 00 00       	mov    $0xa,%eax
  800abe:	bf 95 2a 80 00       	mov    $0x802a95,%edi
							putch(ch, putdat);
  800ac3:	83 ec 08             	sub    $0x8,%esp
  800ac6:	53                   	push   %ebx
  800ac7:	50                   	push   %eax
  800ac8:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800aca:	83 c7 01             	add    $0x1,%edi
  800acd:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800ad1:	83 c4 10             	add    $0x10,%esp
  800ad4:	85 c0                	test   %eax,%eax
  800ad6:	75 eb                	jne    800ac3 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800ad8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800adb:	89 45 14             	mov    %eax,0x14(%ebp)
  800ade:	e9 ed fe ff ff       	jmp    8009d0 <vprintfmt+0x446>
			putch(ch, putdat);
  800ae3:	83 ec 08             	sub    $0x8,%esp
  800ae6:	53                   	push   %ebx
  800ae7:	6a 25                	push   $0x25
  800ae9:	ff d6                	call   *%esi
			break;
  800aeb:	83 c4 10             	add    $0x10,%esp
  800aee:	e9 dd fe ff ff       	jmp    8009d0 <vprintfmt+0x446>
			putch('%', putdat);
  800af3:	83 ec 08             	sub    $0x8,%esp
  800af6:	53                   	push   %ebx
  800af7:	6a 25                	push   $0x25
  800af9:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800afb:	83 c4 10             	add    $0x10,%esp
  800afe:	89 f8                	mov    %edi,%eax
  800b00:	eb 03                	jmp    800b05 <vprintfmt+0x57b>
  800b02:	83 e8 01             	sub    $0x1,%eax
  800b05:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800b09:	75 f7                	jne    800b02 <vprintfmt+0x578>
  800b0b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b0e:	e9 bd fe ff ff       	jmp    8009d0 <vprintfmt+0x446>
}
  800b13:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b16:	5b                   	pop    %ebx
  800b17:	5e                   	pop    %esi
  800b18:	5f                   	pop    %edi
  800b19:	5d                   	pop    %ebp
  800b1a:	c3                   	ret    

00800b1b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b1b:	55                   	push   %ebp
  800b1c:	89 e5                	mov    %esp,%ebp
  800b1e:	83 ec 18             	sub    $0x18,%esp
  800b21:	8b 45 08             	mov    0x8(%ebp),%eax
  800b24:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b27:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b2a:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b2e:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b31:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b38:	85 c0                	test   %eax,%eax
  800b3a:	74 26                	je     800b62 <vsnprintf+0x47>
  800b3c:	85 d2                	test   %edx,%edx
  800b3e:	7e 22                	jle    800b62 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b40:	ff 75 14             	pushl  0x14(%ebp)
  800b43:	ff 75 10             	pushl  0x10(%ebp)
  800b46:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b49:	50                   	push   %eax
  800b4a:	68 50 05 80 00       	push   $0x800550
  800b4f:	e8 36 fa ff ff       	call   80058a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b57:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b5d:	83 c4 10             	add    $0x10,%esp
}
  800b60:	c9                   	leave  
  800b61:	c3                   	ret    
		return -E_INVAL;
  800b62:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b67:	eb f7                	jmp    800b60 <vsnprintf+0x45>

00800b69 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b69:	55                   	push   %ebp
  800b6a:	89 e5                	mov    %esp,%ebp
  800b6c:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b6f:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800b72:	50                   	push   %eax
  800b73:	ff 75 10             	pushl  0x10(%ebp)
  800b76:	ff 75 0c             	pushl  0xc(%ebp)
  800b79:	ff 75 08             	pushl  0x8(%ebp)
  800b7c:	e8 9a ff ff ff       	call   800b1b <vsnprintf>
	va_end(ap);

	return rc;
}
  800b81:	c9                   	leave  
  800b82:	c3                   	ret    

00800b83 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  800b83:	55                   	push   %ebp
  800b84:	89 e5                	mov    %esp,%ebp
  800b86:	57                   	push   %edi
  800b87:	56                   	push   %esi
  800b88:	53                   	push   %ebx
  800b89:	83 ec 0c             	sub    $0xc,%esp
  800b8c:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  800b8f:	85 c0                	test   %eax,%eax
  800b91:	74 13                	je     800ba6 <readline+0x23>
		fprintf(1, "%s", prompt);
  800b93:	83 ec 04             	sub    $0x4,%esp
  800b96:	50                   	push   %eax
  800b97:	68 91 2d 80 00       	push   $0x802d91
  800b9c:	6a 01                	push   $0x1
  800b9e:	e8 03 11 00 00       	call   801ca6 <fprintf>
  800ba3:	83 c4 10             	add    $0x10,%esp
#endif

	i = 0;
	echoing = iscons(0);
  800ba6:	83 ec 0c             	sub    $0xc,%esp
  800ba9:	6a 00                	push   $0x0
  800bab:	e8 2c f6 ff ff       	call   8001dc <iscons>
  800bb0:	89 c7                	mov    %eax,%edi
  800bb2:	83 c4 10             	add    $0x10,%esp
	i = 0;
  800bb5:	be 00 00 00 00       	mov    $0x0,%esi
  800bba:	eb 57                	jmp    800c13 <readline+0x90>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
  800bbc:	b8 00 00 00 00       	mov    $0x0,%eax
			if (c != -E_EOF)
  800bc1:	83 fb f8             	cmp    $0xfffffff8,%ebx
  800bc4:	75 08                	jne    800bce <readline+0x4b>
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
  800bc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bc9:	5b                   	pop    %ebx
  800bca:	5e                   	pop    %esi
  800bcb:	5f                   	pop    %edi
  800bcc:	5d                   	pop    %ebp
  800bcd:	c3                   	ret    
				cprintf("read error: %e\n", c);
  800bce:	83 ec 08             	sub    $0x8,%esp
  800bd1:	53                   	push   %ebx
  800bd2:	68 a8 2c 80 00       	push   $0x802ca8
  800bd7:	e8 81 f8 ff ff       	call   80045d <cprintf>
  800bdc:	83 c4 10             	add    $0x10,%esp
			return NULL;
  800bdf:	b8 00 00 00 00       	mov    $0x0,%eax
  800be4:	eb e0                	jmp    800bc6 <readline+0x43>
			if (echoing)
  800be6:	85 ff                	test   %edi,%edi
  800be8:	75 05                	jne    800bef <readline+0x6c>
			i--;
  800bea:	83 ee 01             	sub    $0x1,%esi
  800bed:	eb 24                	jmp    800c13 <readline+0x90>
				cputchar('\b');
  800bef:	83 ec 0c             	sub    $0xc,%esp
  800bf2:	6a 08                	push   $0x8
  800bf4:	e8 9e f5 ff ff       	call   800197 <cputchar>
  800bf9:	83 c4 10             	add    $0x10,%esp
  800bfc:	eb ec                	jmp    800bea <readline+0x67>
				cputchar(c);
  800bfe:	83 ec 0c             	sub    $0xc,%esp
  800c01:	53                   	push   %ebx
  800c02:	e8 90 f5 ff ff       	call   800197 <cputchar>
  800c07:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800c0a:	88 9e 00 40 80 00    	mov    %bl,0x804000(%esi)
  800c10:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
  800c13:	e8 9b f5 ff ff       	call   8001b3 <getchar>
  800c18:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  800c1a:	85 c0                	test   %eax,%eax
  800c1c:	78 9e                	js     800bbc <readline+0x39>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  800c1e:	83 f8 08             	cmp    $0x8,%eax
  800c21:	0f 94 c2             	sete   %dl
  800c24:	83 f8 7f             	cmp    $0x7f,%eax
  800c27:	0f 94 c0             	sete   %al
  800c2a:	08 c2                	or     %al,%dl
  800c2c:	74 04                	je     800c32 <readline+0xaf>
  800c2e:	85 f6                	test   %esi,%esi
  800c30:	7f b4                	jg     800be6 <readline+0x63>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800c32:	83 fb 1f             	cmp    $0x1f,%ebx
  800c35:	7e 0e                	jle    800c45 <readline+0xc2>
  800c37:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  800c3d:	7f 06                	jg     800c45 <readline+0xc2>
			if (echoing)
  800c3f:	85 ff                	test   %edi,%edi
  800c41:	74 c7                	je     800c0a <readline+0x87>
  800c43:	eb b9                	jmp    800bfe <readline+0x7b>
		} else if (c == '\n' || c == '\r') {
  800c45:	83 fb 0a             	cmp    $0xa,%ebx
  800c48:	74 05                	je     800c4f <readline+0xcc>
  800c4a:	83 fb 0d             	cmp    $0xd,%ebx
  800c4d:	75 c4                	jne    800c13 <readline+0x90>
			if (echoing)
  800c4f:	85 ff                	test   %edi,%edi
  800c51:	75 11                	jne    800c64 <readline+0xe1>
			buf[i] = 0;
  800c53:	c6 86 00 40 80 00 00 	movb   $0x0,0x804000(%esi)
			return buf;
  800c5a:	b8 00 40 80 00       	mov    $0x804000,%eax
  800c5f:	e9 62 ff ff ff       	jmp    800bc6 <readline+0x43>
				cputchar('\n');
  800c64:	83 ec 0c             	sub    $0xc,%esp
  800c67:	6a 0a                	push   $0xa
  800c69:	e8 29 f5 ff ff       	call   800197 <cputchar>
  800c6e:	83 c4 10             	add    $0x10,%esp
  800c71:	eb e0                	jmp    800c53 <readline+0xd0>

00800c73 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800c73:	55                   	push   %ebp
  800c74:	89 e5                	mov    %esp,%ebp
  800c76:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800c79:	b8 00 00 00 00       	mov    $0x0,%eax
  800c7e:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800c82:	74 05                	je     800c89 <strlen+0x16>
		n++;
  800c84:	83 c0 01             	add    $0x1,%eax
  800c87:	eb f5                	jmp    800c7e <strlen+0xb>
	return n;
}
  800c89:	5d                   	pop    %ebp
  800c8a:	c3                   	ret    

00800c8b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800c8b:	55                   	push   %ebp
  800c8c:	89 e5                	mov    %esp,%ebp
  800c8e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c91:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c94:	ba 00 00 00 00       	mov    $0x0,%edx
  800c99:	39 c2                	cmp    %eax,%edx
  800c9b:	74 0d                	je     800caa <strnlen+0x1f>
  800c9d:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800ca1:	74 05                	je     800ca8 <strnlen+0x1d>
		n++;
  800ca3:	83 c2 01             	add    $0x1,%edx
  800ca6:	eb f1                	jmp    800c99 <strnlen+0xe>
  800ca8:	89 d0                	mov    %edx,%eax
	return n;
}
  800caa:	5d                   	pop    %ebp
  800cab:	c3                   	ret    

00800cac <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cac:	55                   	push   %ebp
  800cad:	89 e5                	mov    %esp,%ebp
  800caf:	53                   	push   %ebx
  800cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800cb6:	ba 00 00 00 00       	mov    $0x0,%edx
  800cbb:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800cbf:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800cc2:	83 c2 01             	add    $0x1,%edx
  800cc5:	84 c9                	test   %cl,%cl
  800cc7:	75 f2                	jne    800cbb <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800cc9:	5b                   	pop    %ebx
  800cca:	5d                   	pop    %ebp
  800ccb:	c3                   	ret    

00800ccc <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ccc:	55                   	push   %ebp
  800ccd:	89 e5                	mov    %esp,%ebp
  800ccf:	53                   	push   %ebx
  800cd0:	83 ec 10             	sub    $0x10,%esp
  800cd3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800cd6:	53                   	push   %ebx
  800cd7:	e8 97 ff ff ff       	call   800c73 <strlen>
  800cdc:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800cdf:	ff 75 0c             	pushl  0xc(%ebp)
  800ce2:	01 d8                	add    %ebx,%eax
  800ce4:	50                   	push   %eax
  800ce5:	e8 c2 ff ff ff       	call   800cac <strcpy>
	return dst;
}
  800cea:	89 d8                	mov    %ebx,%eax
  800cec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cef:	c9                   	leave  
  800cf0:	c3                   	ret    

00800cf1 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800cf1:	55                   	push   %ebp
  800cf2:	89 e5                	mov    %esp,%ebp
  800cf4:	56                   	push   %esi
  800cf5:	53                   	push   %ebx
  800cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cfc:	89 c6                	mov    %eax,%esi
  800cfe:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d01:	89 c2                	mov    %eax,%edx
  800d03:	39 f2                	cmp    %esi,%edx
  800d05:	74 11                	je     800d18 <strncpy+0x27>
		*dst++ = *src;
  800d07:	83 c2 01             	add    $0x1,%edx
  800d0a:	0f b6 19             	movzbl (%ecx),%ebx
  800d0d:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800d10:	80 fb 01             	cmp    $0x1,%bl
  800d13:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800d16:	eb eb                	jmp    800d03 <strncpy+0x12>
	}
	return ret;
}
  800d18:	5b                   	pop    %ebx
  800d19:	5e                   	pop    %esi
  800d1a:	5d                   	pop    %ebp
  800d1b:	c3                   	ret    

00800d1c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800d1c:	55                   	push   %ebp
  800d1d:	89 e5                	mov    %esp,%ebp
  800d1f:	56                   	push   %esi
  800d20:	53                   	push   %ebx
  800d21:	8b 75 08             	mov    0x8(%ebp),%esi
  800d24:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d27:	8b 55 10             	mov    0x10(%ebp),%edx
  800d2a:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800d2c:	85 d2                	test   %edx,%edx
  800d2e:	74 21                	je     800d51 <strlcpy+0x35>
  800d30:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800d34:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800d36:	39 c2                	cmp    %eax,%edx
  800d38:	74 14                	je     800d4e <strlcpy+0x32>
  800d3a:	0f b6 19             	movzbl (%ecx),%ebx
  800d3d:	84 db                	test   %bl,%bl
  800d3f:	74 0b                	je     800d4c <strlcpy+0x30>
			*dst++ = *src++;
  800d41:	83 c1 01             	add    $0x1,%ecx
  800d44:	83 c2 01             	add    $0x1,%edx
  800d47:	88 5a ff             	mov    %bl,-0x1(%edx)
  800d4a:	eb ea                	jmp    800d36 <strlcpy+0x1a>
  800d4c:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800d4e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d51:	29 f0                	sub    %esi,%eax
}
  800d53:	5b                   	pop    %ebx
  800d54:	5e                   	pop    %esi
  800d55:	5d                   	pop    %ebp
  800d56:	c3                   	ret    

00800d57 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d57:	55                   	push   %ebp
  800d58:	89 e5                	mov    %esp,%ebp
  800d5a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d5d:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800d60:	0f b6 01             	movzbl (%ecx),%eax
  800d63:	84 c0                	test   %al,%al
  800d65:	74 0c                	je     800d73 <strcmp+0x1c>
  800d67:	3a 02                	cmp    (%edx),%al
  800d69:	75 08                	jne    800d73 <strcmp+0x1c>
		p++, q++;
  800d6b:	83 c1 01             	add    $0x1,%ecx
  800d6e:	83 c2 01             	add    $0x1,%edx
  800d71:	eb ed                	jmp    800d60 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d73:	0f b6 c0             	movzbl %al,%eax
  800d76:	0f b6 12             	movzbl (%edx),%edx
  800d79:	29 d0                	sub    %edx,%eax
}
  800d7b:	5d                   	pop    %ebp
  800d7c:	c3                   	ret    

00800d7d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800d7d:	55                   	push   %ebp
  800d7e:	89 e5                	mov    %esp,%ebp
  800d80:	53                   	push   %ebx
  800d81:	8b 45 08             	mov    0x8(%ebp),%eax
  800d84:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d87:	89 c3                	mov    %eax,%ebx
  800d89:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800d8c:	eb 06                	jmp    800d94 <strncmp+0x17>
		n--, p++, q++;
  800d8e:	83 c0 01             	add    $0x1,%eax
  800d91:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800d94:	39 d8                	cmp    %ebx,%eax
  800d96:	74 16                	je     800dae <strncmp+0x31>
  800d98:	0f b6 08             	movzbl (%eax),%ecx
  800d9b:	84 c9                	test   %cl,%cl
  800d9d:	74 04                	je     800da3 <strncmp+0x26>
  800d9f:	3a 0a                	cmp    (%edx),%cl
  800da1:	74 eb                	je     800d8e <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800da3:	0f b6 00             	movzbl (%eax),%eax
  800da6:	0f b6 12             	movzbl (%edx),%edx
  800da9:	29 d0                	sub    %edx,%eax
}
  800dab:	5b                   	pop    %ebx
  800dac:	5d                   	pop    %ebp
  800dad:	c3                   	ret    
		return 0;
  800dae:	b8 00 00 00 00       	mov    $0x0,%eax
  800db3:	eb f6                	jmp    800dab <strncmp+0x2e>

00800db5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800db5:	55                   	push   %ebp
  800db6:	89 e5                	mov    %esp,%ebp
  800db8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbb:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800dbf:	0f b6 10             	movzbl (%eax),%edx
  800dc2:	84 d2                	test   %dl,%dl
  800dc4:	74 09                	je     800dcf <strchr+0x1a>
		if (*s == c)
  800dc6:	38 ca                	cmp    %cl,%dl
  800dc8:	74 0a                	je     800dd4 <strchr+0x1f>
	for (; *s; s++)
  800dca:	83 c0 01             	add    $0x1,%eax
  800dcd:	eb f0                	jmp    800dbf <strchr+0xa>
			return (char *) s;
	return 0;
  800dcf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dd4:	5d                   	pop    %ebp
  800dd5:	c3                   	ret    

00800dd6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dd6:	55                   	push   %ebp
  800dd7:	89 e5                	mov    %esp,%ebp
  800dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddc:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800de0:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800de3:	38 ca                	cmp    %cl,%dl
  800de5:	74 09                	je     800df0 <strfind+0x1a>
  800de7:	84 d2                	test   %dl,%dl
  800de9:	74 05                	je     800df0 <strfind+0x1a>
	for (; *s; s++)
  800deb:	83 c0 01             	add    $0x1,%eax
  800dee:	eb f0                	jmp    800de0 <strfind+0xa>
			break;
	return (char *) s;
}
  800df0:	5d                   	pop    %ebp
  800df1:	c3                   	ret    

00800df2 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800df2:	55                   	push   %ebp
  800df3:	89 e5                	mov    %esp,%ebp
  800df5:	57                   	push   %edi
  800df6:	56                   	push   %esi
  800df7:	53                   	push   %ebx
  800df8:	8b 7d 08             	mov    0x8(%ebp),%edi
  800dfb:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800dfe:	85 c9                	test   %ecx,%ecx
  800e00:	74 31                	je     800e33 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800e02:	89 f8                	mov    %edi,%eax
  800e04:	09 c8                	or     %ecx,%eax
  800e06:	a8 03                	test   $0x3,%al
  800e08:	75 23                	jne    800e2d <memset+0x3b>
		c &= 0xFF;
  800e0a:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800e0e:	89 d3                	mov    %edx,%ebx
  800e10:	c1 e3 08             	shl    $0x8,%ebx
  800e13:	89 d0                	mov    %edx,%eax
  800e15:	c1 e0 18             	shl    $0x18,%eax
  800e18:	89 d6                	mov    %edx,%esi
  800e1a:	c1 e6 10             	shl    $0x10,%esi
  800e1d:	09 f0                	or     %esi,%eax
  800e1f:	09 c2                	or     %eax,%edx
  800e21:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800e23:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800e26:	89 d0                	mov    %edx,%eax
  800e28:	fc                   	cld    
  800e29:	f3 ab                	rep stos %eax,%es:(%edi)
  800e2b:	eb 06                	jmp    800e33 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800e2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e30:	fc                   	cld    
  800e31:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800e33:	89 f8                	mov    %edi,%eax
  800e35:	5b                   	pop    %ebx
  800e36:	5e                   	pop    %esi
  800e37:	5f                   	pop    %edi
  800e38:	5d                   	pop    %ebp
  800e39:	c3                   	ret    

00800e3a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800e3a:	55                   	push   %ebp
  800e3b:	89 e5                	mov    %esp,%ebp
  800e3d:	57                   	push   %edi
  800e3e:	56                   	push   %esi
  800e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e42:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e45:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e48:	39 c6                	cmp    %eax,%esi
  800e4a:	73 32                	jae    800e7e <memmove+0x44>
  800e4c:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800e4f:	39 c2                	cmp    %eax,%edx
  800e51:	76 2b                	jbe    800e7e <memmove+0x44>
		s += n;
		d += n;
  800e53:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e56:	89 fe                	mov    %edi,%esi
  800e58:	09 ce                	or     %ecx,%esi
  800e5a:	09 d6                	or     %edx,%esi
  800e5c:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800e62:	75 0e                	jne    800e72 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800e64:	83 ef 04             	sub    $0x4,%edi
  800e67:	8d 72 fc             	lea    -0x4(%edx),%esi
  800e6a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800e6d:	fd                   	std    
  800e6e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e70:	eb 09                	jmp    800e7b <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800e72:	83 ef 01             	sub    $0x1,%edi
  800e75:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800e78:	fd                   	std    
  800e79:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800e7b:	fc                   	cld    
  800e7c:	eb 1a                	jmp    800e98 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e7e:	89 c2                	mov    %eax,%edx
  800e80:	09 ca                	or     %ecx,%edx
  800e82:	09 f2                	or     %esi,%edx
  800e84:	f6 c2 03             	test   $0x3,%dl
  800e87:	75 0a                	jne    800e93 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800e89:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800e8c:	89 c7                	mov    %eax,%edi
  800e8e:	fc                   	cld    
  800e8f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e91:	eb 05                	jmp    800e98 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800e93:	89 c7                	mov    %eax,%edi
  800e95:	fc                   	cld    
  800e96:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800e98:	5e                   	pop    %esi
  800e99:	5f                   	pop    %edi
  800e9a:	5d                   	pop    %ebp
  800e9b:	c3                   	ret    

00800e9c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e9c:	55                   	push   %ebp
  800e9d:	89 e5                	mov    %esp,%ebp
  800e9f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ea2:	ff 75 10             	pushl  0x10(%ebp)
  800ea5:	ff 75 0c             	pushl  0xc(%ebp)
  800ea8:	ff 75 08             	pushl  0x8(%ebp)
  800eab:	e8 8a ff ff ff       	call   800e3a <memmove>
}
  800eb0:	c9                   	leave  
  800eb1:	c3                   	ret    

00800eb2 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800eb2:	55                   	push   %ebp
  800eb3:	89 e5                	mov    %esp,%ebp
  800eb5:	56                   	push   %esi
  800eb6:	53                   	push   %ebx
  800eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eba:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ebd:	89 c6                	mov    %eax,%esi
  800ebf:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ec2:	39 f0                	cmp    %esi,%eax
  800ec4:	74 1c                	je     800ee2 <memcmp+0x30>
		if (*s1 != *s2)
  800ec6:	0f b6 08             	movzbl (%eax),%ecx
  800ec9:	0f b6 1a             	movzbl (%edx),%ebx
  800ecc:	38 d9                	cmp    %bl,%cl
  800ece:	75 08                	jne    800ed8 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800ed0:	83 c0 01             	add    $0x1,%eax
  800ed3:	83 c2 01             	add    $0x1,%edx
  800ed6:	eb ea                	jmp    800ec2 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800ed8:	0f b6 c1             	movzbl %cl,%eax
  800edb:	0f b6 db             	movzbl %bl,%ebx
  800ede:	29 d8                	sub    %ebx,%eax
  800ee0:	eb 05                	jmp    800ee7 <memcmp+0x35>
	}

	return 0;
  800ee2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ee7:	5b                   	pop    %ebx
  800ee8:	5e                   	pop    %esi
  800ee9:	5d                   	pop    %ebp
  800eea:	c3                   	ret    

00800eeb <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800eeb:	55                   	push   %ebp
  800eec:	89 e5                	mov    %esp,%ebp
  800eee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ef4:	89 c2                	mov    %eax,%edx
  800ef6:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ef9:	39 d0                	cmp    %edx,%eax
  800efb:	73 09                	jae    800f06 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800efd:	38 08                	cmp    %cl,(%eax)
  800eff:	74 05                	je     800f06 <memfind+0x1b>
	for (; s < ends; s++)
  800f01:	83 c0 01             	add    $0x1,%eax
  800f04:	eb f3                	jmp    800ef9 <memfind+0xe>
			break;
	return (void *) s;
}
  800f06:	5d                   	pop    %ebp
  800f07:	c3                   	ret    

00800f08 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f08:	55                   	push   %ebp
  800f09:	89 e5                	mov    %esp,%ebp
  800f0b:	57                   	push   %edi
  800f0c:	56                   	push   %esi
  800f0d:	53                   	push   %ebx
  800f0e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f11:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f14:	eb 03                	jmp    800f19 <strtol+0x11>
		s++;
  800f16:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800f19:	0f b6 01             	movzbl (%ecx),%eax
  800f1c:	3c 20                	cmp    $0x20,%al
  800f1e:	74 f6                	je     800f16 <strtol+0xe>
  800f20:	3c 09                	cmp    $0x9,%al
  800f22:	74 f2                	je     800f16 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800f24:	3c 2b                	cmp    $0x2b,%al
  800f26:	74 2a                	je     800f52 <strtol+0x4a>
	int neg = 0;
  800f28:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800f2d:	3c 2d                	cmp    $0x2d,%al
  800f2f:	74 2b                	je     800f5c <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f31:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800f37:	75 0f                	jne    800f48 <strtol+0x40>
  800f39:	80 39 30             	cmpb   $0x30,(%ecx)
  800f3c:	74 28                	je     800f66 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800f3e:	85 db                	test   %ebx,%ebx
  800f40:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f45:	0f 44 d8             	cmove  %eax,%ebx
  800f48:	b8 00 00 00 00       	mov    $0x0,%eax
  800f4d:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800f50:	eb 50                	jmp    800fa2 <strtol+0x9a>
		s++;
  800f52:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800f55:	bf 00 00 00 00       	mov    $0x0,%edi
  800f5a:	eb d5                	jmp    800f31 <strtol+0x29>
		s++, neg = 1;
  800f5c:	83 c1 01             	add    $0x1,%ecx
  800f5f:	bf 01 00 00 00       	mov    $0x1,%edi
  800f64:	eb cb                	jmp    800f31 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f66:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800f6a:	74 0e                	je     800f7a <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800f6c:	85 db                	test   %ebx,%ebx
  800f6e:	75 d8                	jne    800f48 <strtol+0x40>
		s++, base = 8;
  800f70:	83 c1 01             	add    $0x1,%ecx
  800f73:	bb 08 00 00 00       	mov    $0x8,%ebx
  800f78:	eb ce                	jmp    800f48 <strtol+0x40>
		s += 2, base = 16;
  800f7a:	83 c1 02             	add    $0x2,%ecx
  800f7d:	bb 10 00 00 00       	mov    $0x10,%ebx
  800f82:	eb c4                	jmp    800f48 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800f84:	8d 72 9f             	lea    -0x61(%edx),%esi
  800f87:	89 f3                	mov    %esi,%ebx
  800f89:	80 fb 19             	cmp    $0x19,%bl
  800f8c:	77 29                	ja     800fb7 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800f8e:	0f be d2             	movsbl %dl,%edx
  800f91:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800f94:	3b 55 10             	cmp    0x10(%ebp),%edx
  800f97:	7d 30                	jge    800fc9 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800f99:	83 c1 01             	add    $0x1,%ecx
  800f9c:	0f af 45 10          	imul   0x10(%ebp),%eax
  800fa0:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800fa2:	0f b6 11             	movzbl (%ecx),%edx
  800fa5:	8d 72 d0             	lea    -0x30(%edx),%esi
  800fa8:	89 f3                	mov    %esi,%ebx
  800faa:	80 fb 09             	cmp    $0x9,%bl
  800fad:	77 d5                	ja     800f84 <strtol+0x7c>
			dig = *s - '0';
  800faf:	0f be d2             	movsbl %dl,%edx
  800fb2:	83 ea 30             	sub    $0x30,%edx
  800fb5:	eb dd                	jmp    800f94 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800fb7:	8d 72 bf             	lea    -0x41(%edx),%esi
  800fba:	89 f3                	mov    %esi,%ebx
  800fbc:	80 fb 19             	cmp    $0x19,%bl
  800fbf:	77 08                	ja     800fc9 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800fc1:	0f be d2             	movsbl %dl,%edx
  800fc4:	83 ea 37             	sub    $0x37,%edx
  800fc7:	eb cb                	jmp    800f94 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800fc9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fcd:	74 05                	je     800fd4 <strtol+0xcc>
		*endptr = (char *) s;
  800fcf:	8b 75 0c             	mov    0xc(%ebp),%esi
  800fd2:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800fd4:	89 c2                	mov    %eax,%edx
  800fd6:	f7 da                	neg    %edx
  800fd8:	85 ff                	test   %edi,%edi
  800fda:	0f 45 c2             	cmovne %edx,%eax
}
  800fdd:	5b                   	pop    %ebx
  800fde:	5e                   	pop    %esi
  800fdf:	5f                   	pop    %edi
  800fe0:	5d                   	pop    %ebp
  800fe1:	c3                   	ret    

00800fe2 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800fe2:	55                   	push   %ebp
  800fe3:	89 e5                	mov    %esp,%ebp
  800fe5:	57                   	push   %edi
  800fe6:	56                   	push   %esi
  800fe7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fe8:	b8 00 00 00 00       	mov    $0x0,%eax
  800fed:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff3:	89 c3                	mov    %eax,%ebx
  800ff5:	89 c7                	mov    %eax,%edi
  800ff7:	89 c6                	mov    %eax,%esi
  800ff9:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ffb:	5b                   	pop    %ebx
  800ffc:	5e                   	pop    %esi
  800ffd:	5f                   	pop    %edi
  800ffe:	5d                   	pop    %ebp
  800fff:	c3                   	ret    

00801000 <sys_cgetc>:

int
sys_cgetc(void)
{
  801000:	55                   	push   %ebp
  801001:	89 e5                	mov    %esp,%ebp
  801003:	57                   	push   %edi
  801004:	56                   	push   %esi
  801005:	53                   	push   %ebx
	asm volatile("int %1\n"
  801006:	ba 00 00 00 00       	mov    $0x0,%edx
  80100b:	b8 01 00 00 00       	mov    $0x1,%eax
  801010:	89 d1                	mov    %edx,%ecx
  801012:	89 d3                	mov    %edx,%ebx
  801014:	89 d7                	mov    %edx,%edi
  801016:	89 d6                	mov    %edx,%esi
  801018:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80101a:	5b                   	pop    %ebx
  80101b:	5e                   	pop    %esi
  80101c:	5f                   	pop    %edi
  80101d:	5d                   	pop    %ebp
  80101e:	c3                   	ret    

0080101f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80101f:	55                   	push   %ebp
  801020:	89 e5                	mov    %esp,%ebp
  801022:	57                   	push   %edi
  801023:	56                   	push   %esi
  801024:	53                   	push   %ebx
  801025:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801028:	b9 00 00 00 00       	mov    $0x0,%ecx
  80102d:	8b 55 08             	mov    0x8(%ebp),%edx
  801030:	b8 03 00 00 00       	mov    $0x3,%eax
  801035:	89 cb                	mov    %ecx,%ebx
  801037:	89 cf                	mov    %ecx,%edi
  801039:	89 ce                	mov    %ecx,%esi
  80103b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80103d:	85 c0                	test   %eax,%eax
  80103f:	7f 08                	jg     801049 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801041:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801044:	5b                   	pop    %ebx
  801045:	5e                   	pop    %esi
  801046:	5f                   	pop    %edi
  801047:	5d                   	pop    %ebp
  801048:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801049:	83 ec 0c             	sub    $0xc,%esp
  80104c:	50                   	push   %eax
  80104d:	6a 03                	push   $0x3
  80104f:	68 b8 2c 80 00       	push   $0x802cb8
  801054:	6a 43                	push   $0x43
  801056:	68 d5 2c 80 00       	push   $0x802cd5
  80105b:	e8 07 f3 ff ff       	call   800367 <_panic>

00801060 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801060:	55                   	push   %ebp
  801061:	89 e5                	mov    %esp,%ebp
  801063:	57                   	push   %edi
  801064:	56                   	push   %esi
  801065:	53                   	push   %ebx
	asm volatile("int %1\n"
  801066:	ba 00 00 00 00       	mov    $0x0,%edx
  80106b:	b8 02 00 00 00       	mov    $0x2,%eax
  801070:	89 d1                	mov    %edx,%ecx
  801072:	89 d3                	mov    %edx,%ebx
  801074:	89 d7                	mov    %edx,%edi
  801076:	89 d6                	mov    %edx,%esi
  801078:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80107a:	5b                   	pop    %ebx
  80107b:	5e                   	pop    %esi
  80107c:	5f                   	pop    %edi
  80107d:	5d                   	pop    %ebp
  80107e:	c3                   	ret    

0080107f <sys_yield>:

void
sys_yield(void)
{
  80107f:	55                   	push   %ebp
  801080:	89 e5                	mov    %esp,%ebp
  801082:	57                   	push   %edi
  801083:	56                   	push   %esi
  801084:	53                   	push   %ebx
	asm volatile("int %1\n"
  801085:	ba 00 00 00 00       	mov    $0x0,%edx
  80108a:	b8 0b 00 00 00       	mov    $0xb,%eax
  80108f:	89 d1                	mov    %edx,%ecx
  801091:	89 d3                	mov    %edx,%ebx
  801093:	89 d7                	mov    %edx,%edi
  801095:	89 d6                	mov    %edx,%esi
  801097:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801099:	5b                   	pop    %ebx
  80109a:	5e                   	pop    %esi
  80109b:	5f                   	pop    %edi
  80109c:	5d                   	pop    %ebp
  80109d:	c3                   	ret    

0080109e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80109e:	55                   	push   %ebp
  80109f:	89 e5                	mov    %esp,%ebp
  8010a1:	57                   	push   %edi
  8010a2:	56                   	push   %esi
  8010a3:	53                   	push   %ebx
  8010a4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010a7:	be 00 00 00 00       	mov    $0x0,%esi
  8010ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8010af:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010b2:	b8 04 00 00 00       	mov    $0x4,%eax
  8010b7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010ba:	89 f7                	mov    %esi,%edi
  8010bc:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010be:	85 c0                	test   %eax,%eax
  8010c0:	7f 08                	jg     8010ca <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
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
  8010ce:	6a 04                	push   $0x4
  8010d0:	68 b8 2c 80 00       	push   $0x802cb8
  8010d5:	6a 43                	push   $0x43
  8010d7:	68 d5 2c 80 00       	push   $0x802cd5
  8010dc:	e8 86 f2 ff ff       	call   800367 <_panic>

008010e1 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8010e1:	55                   	push   %ebp
  8010e2:	89 e5                	mov    %esp,%ebp
  8010e4:	57                   	push   %edi
  8010e5:	56                   	push   %esi
  8010e6:	53                   	push   %ebx
  8010e7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010f0:	b8 05 00 00 00       	mov    $0x5,%eax
  8010f5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010f8:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010fb:	8b 75 18             	mov    0x18(%ebp),%esi
  8010fe:	cd 30                	int    $0x30
	if(check && ret > 0)
  801100:	85 c0                	test   %eax,%eax
  801102:	7f 08                	jg     80110c <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
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
  801110:	6a 05                	push   $0x5
  801112:	68 b8 2c 80 00       	push   $0x802cb8
  801117:	6a 43                	push   $0x43
  801119:	68 d5 2c 80 00       	push   $0x802cd5
  80111e:	e8 44 f2 ff ff       	call   800367 <_panic>

00801123 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
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
  801137:	b8 06 00 00 00       	mov    $0x6,%eax
  80113c:	89 df                	mov    %ebx,%edi
  80113e:	89 de                	mov    %ebx,%esi
  801140:	cd 30                	int    $0x30
	if(check && ret > 0)
  801142:	85 c0                	test   %eax,%eax
  801144:	7f 08                	jg     80114e <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
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
  801152:	6a 06                	push   $0x6
  801154:	68 b8 2c 80 00       	push   $0x802cb8
  801159:	6a 43                	push   $0x43
  80115b:	68 d5 2c 80 00       	push   $0x802cd5
  801160:	e8 02 f2 ff ff       	call   800367 <_panic>

00801165 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
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
  801179:	b8 08 00 00 00       	mov    $0x8,%eax
  80117e:	89 df                	mov    %ebx,%edi
  801180:	89 de                	mov    %ebx,%esi
  801182:	cd 30                	int    $0x30
	if(check && ret > 0)
  801184:	85 c0                	test   %eax,%eax
  801186:	7f 08                	jg     801190 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
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
  801194:	6a 08                	push   $0x8
  801196:	68 b8 2c 80 00       	push   $0x802cb8
  80119b:	6a 43                	push   $0x43
  80119d:	68 d5 2c 80 00       	push   $0x802cd5
  8011a2:	e8 c0 f1 ff ff       	call   800367 <_panic>

008011a7 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8011a7:	55                   	push   %ebp
  8011a8:	89 e5                	mov    %esp,%ebp
  8011aa:	57                   	push   %edi
  8011ab:	56                   	push   %esi
  8011ac:	53                   	push   %ebx
  8011ad:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011b0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011bb:	b8 09 00 00 00       	mov    $0x9,%eax
  8011c0:	89 df                	mov    %ebx,%edi
  8011c2:	89 de                	mov    %ebx,%esi
  8011c4:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011c6:	85 c0                	test   %eax,%eax
  8011c8:	7f 08                	jg     8011d2 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8011ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011cd:	5b                   	pop    %ebx
  8011ce:	5e                   	pop    %esi
  8011cf:	5f                   	pop    %edi
  8011d0:	5d                   	pop    %ebp
  8011d1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011d2:	83 ec 0c             	sub    $0xc,%esp
  8011d5:	50                   	push   %eax
  8011d6:	6a 09                	push   $0x9
  8011d8:	68 b8 2c 80 00       	push   $0x802cb8
  8011dd:	6a 43                	push   $0x43
  8011df:	68 d5 2c 80 00       	push   $0x802cd5
  8011e4:	e8 7e f1 ff ff       	call   800367 <_panic>

008011e9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8011e9:	55                   	push   %ebp
  8011ea:	89 e5                	mov    %esp,%ebp
  8011ec:	57                   	push   %edi
  8011ed:	56                   	push   %esi
  8011ee:	53                   	push   %ebx
  8011ef:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011f2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8011fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011fd:	b8 0a 00 00 00       	mov    $0xa,%eax
  801202:	89 df                	mov    %ebx,%edi
  801204:	89 de                	mov    %ebx,%esi
  801206:	cd 30                	int    $0x30
	if(check && ret > 0)
  801208:	85 c0                	test   %eax,%eax
  80120a:	7f 08                	jg     801214 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80120c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80120f:	5b                   	pop    %ebx
  801210:	5e                   	pop    %esi
  801211:	5f                   	pop    %edi
  801212:	5d                   	pop    %ebp
  801213:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801214:	83 ec 0c             	sub    $0xc,%esp
  801217:	50                   	push   %eax
  801218:	6a 0a                	push   $0xa
  80121a:	68 b8 2c 80 00       	push   $0x802cb8
  80121f:	6a 43                	push   $0x43
  801221:	68 d5 2c 80 00       	push   $0x802cd5
  801226:	e8 3c f1 ff ff       	call   800367 <_panic>

0080122b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80122b:	55                   	push   %ebp
  80122c:	89 e5                	mov    %esp,%ebp
  80122e:	57                   	push   %edi
  80122f:	56                   	push   %esi
  801230:	53                   	push   %ebx
	asm volatile("int %1\n"
  801231:	8b 55 08             	mov    0x8(%ebp),%edx
  801234:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801237:	b8 0c 00 00 00       	mov    $0xc,%eax
  80123c:	be 00 00 00 00       	mov    $0x0,%esi
  801241:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801244:	8b 7d 14             	mov    0x14(%ebp),%edi
  801247:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801249:	5b                   	pop    %ebx
  80124a:	5e                   	pop    %esi
  80124b:	5f                   	pop    %edi
  80124c:	5d                   	pop    %ebp
  80124d:	c3                   	ret    

0080124e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80124e:	55                   	push   %ebp
  80124f:	89 e5                	mov    %esp,%ebp
  801251:	57                   	push   %edi
  801252:	56                   	push   %esi
  801253:	53                   	push   %ebx
  801254:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801257:	b9 00 00 00 00       	mov    $0x0,%ecx
  80125c:	8b 55 08             	mov    0x8(%ebp),%edx
  80125f:	b8 0d 00 00 00       	mov    $0xd,%eax
  801264:	89 cb                	mov    %ecx,%ebx
  801266:	89 cf                	mov    %ecx,%edi
  801268:	89 ce                	mov    %ecx,%esi
  80126a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80126c:	85 c0                	test   %eax,%eax
  80126e:	7f 08                	jg     801278 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801270:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801273:	5b                   	pop    %ebx
  801274:	5e                   	pop    %esi
  801275:	5f                   	pop    %edi
  801276:	5d                   	pop    %ebp
  801277:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801278:	83 ec 0c             	sub    $0xc,%esp
  80127b:	50                   	push   %eax
  80127c:	6a 0d                	push   $0xd
  80127e:	68 b8 2c 80 00       	push   $0x802cb8
  801283:	6a 43                	push   $0x43
  801285:	68 d5 2c 80 00       	push   $0x802cd5
  80128a:	e8 d8 f0 ff ff       	call   800367 <_panic>

0080128f <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  80128f:	55                   	push   %ebp
  801290:	89 e5                	mov    %esp,%ebp
  801292:	57                   	push   %edi
  801293:	56                   	push   %esi
  801294:	53                   	push   %ebx
	asm volatile("int %1\n"
  801295:	bb 00 00 00 00       	mov    $0x0,%ebx
  80129a:	8b 55 08             	mov    0x8(%ebp),%edx
  80129d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012a0:	b8 0e 00 00 00       	mov    $0xe,%eax
  8012a5:	89 df                	mov    %ebx,%edi
  8012a7:	89 de                	mov    %ebx,%esi
  8012a9:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8012ab:	5b                   	pop    %ebx
  8012ac:	5e                   	pop    %esi
  8012ad:	5f                   	pop    %edi
  8012ae:	5d                   	pop    %ebp
  8012af:	c3                   	ret    

008012b0 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8012b0:	55                   	push   %ebp
  8012b1:	89 e5                	mov    %esp,%ebp
  8012b3:	57                   	push   %edi
  8012b4:	56                   	push   %esi
  8012b5:	53                   	push   %ebx
	asm volatile("int %1\n"
  8012b6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8012be:	b8 0f 00 00 00       	mov    $0xf,%eax
  8012c3:	89 cb                	mov    %ecx,%ebx
  8012c5:	89 cf                	mov    %ecx,%edi
  8012c7:	89 ce                	mov    %ecx,%esi
  8012c9:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8012cb:	5b                   	pop    %ebx
  8012cc:	5e                   	pop    %esi
  8012cd:	5f                   	pop    %edi
  8012ce:	5d                   	pop    %ebp
  8012cf:	c3                   	ret    

008012d0 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8012d0:	55                   	push   %ebp
  8012d1:	89 e5                	mov    %esp,%ebp
  8012d3:	57                   	push   %edi
  8012d4:	56                   	push   %esi
  8012d5:	53                   	push   %ebx
	asm volatile("int %1\n"
  8012d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8012db:	b8 10 00 00 00       	mov    $0x10,%eax
  8012e0:	89 d1                	mov    %edx,%ecx
  8012e2:	89 d3                	mov    %edx,%ebx
  8012e4:	89 d7                	mov    %edx,%edi
  8012e6:	89 d6                	mov    %edx,%esi
  8012e8:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8012ea:	5b                   	pop    %ebx
  8012eb:	5e                   	pop    %esi
  8012ec:	5f                   	pop    %edi
  8012ed:	5d                   	pop    %ebp
  8012ee:	c3                   	ret    

008012ef <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  8012ef:	55                   	push   %ebp
  8012f0:	89 e5                	mov    %esp,%ebp
  8012f2:	57                   	push   %edi
  8012f3:	56                   	push   %esi
  8012f4:	53                   	push   %ebx
	asm volatile("int %1\n"
  8012f5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8012fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801300:	b8 11 00 00 00       	mov    $0x11,%eax
  801305:	89 df                	mov    %ebx,%edi
  801307:	89 de                	mov    %ebx,%esi
  801309:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80130b:	5b                   	pop    %ebx
  80130c:	5e                   	pop    %esi
  80130d:	5f                   	pop    %edi
  80130e:	5d                   	pop    %ebp
  80130f:	c3                   	ret    

00801310 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801310:	55                   	push   %ebp
  801311:	89 e5                	mov    %esp,%ebp
  801313:	57                   	push   %edi
  801314:	56                   	push   %esi
  801315:	53                   	push   %ebx
	asm volatile("int %1\n"
  801316:	bb 00 00 00 00       	mov    $0x0,%ebx
  80131b:	8b 55 08             	mov    0x8(%ebp),%edx
  80131e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801321:	b8 12 00 00 00       	mov    $0x12,%eax
  801326:	89 df                	mov    %ebx,%edi
  801328:	89 de                	mov    %ebx,%esi
  80132a:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80132c:	5b                   	pop    %ebx
  80132d:	5e                   	pop    %esi
  80132e:	5f                   	pop    %edi
  80132f:	5d                   	pop    %ebp
  801330:	c3                   	ret    

00801331 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801331:	55                   	push   %ebp
  801332:	89 e5                	mov    %esp,%ebp
  801334:	57                   	push   %edi
  801335:	56                   	push   %esi
  801336:	53                   	push   %ebx
  801337:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80133a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80133f:	8b 55 08             	mov    0x8(%ebp),%edx
  801342:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801345:	b8 13 00 00 00       	mov    $0x13,%eax
  80134a:	89 df                	mov    %ebx,%edi
  80134c:	89 de                	mov    %ebx,%esi
  80134e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801350:	85 c0                	test   %eax,%eax
  801352:	7f 08                	jg     80135c <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801354:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801357:	5b                   	pop    %ebx
  801358:	5e                   	pop    %esi
  801359:	5f                   	pop    %edi
  80135a:	5d                   	pop    %ebp
  80135b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80135c:	83 ec 0c             	sub    $0xc,%esp
  80135f:	50                   	push   %eax
  801360:	6a 13                	push   $0x13
  801362:	68 b8 2c 80 00       	push   $0x802cb8
  801367:	6a 43                	push   $0x43
  801369:	68 d5 2c 80 00       	push   $0x802cd5
  80136e:	e8 f4 ef ff ff       	call   800367 <_panic>

00801373 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  801373:	55                   	push   %ebp
  801374:	89 e5                	mov    %esp,%ebp
  801376:	57                   	push   %edi
  801377:	56                   	push   %esi
  801378:	53                   	push   %ebx
	asm volatile("int %1\n"
  801379:	b9 00 00 00 00       	mov    $0x0,%ecx
  80137e:	8b 55 08             	mov    0x8(%ebp),%edx
  801381:	b8 14 00 00 00       	mov    $0x14,%eax
  801386:	89 cb                	mov    %ecx,%ebx
  801388:	89 cf                	mov    %ecx,%edi
  80138a:	89 ce                	mov    %ecx,%esi
  80138c:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  80138e:	5b                   	pop    %ebx
  80138f:	5e                   	pop    %esi
  801390:	5f                   	pop    %edi
  801391:	5d                   	pop    %ebp
  801392:	c3                   	ret    

00801393 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801393:	55                   	push   %ebp
  801394:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801396:	8b 45 08             	mov    0x8(%ebp),%eax
  801399:	05 00 00 00 30       	add    $0x30000000,%eax
  80139e:	c1 e8 0c             	shr    $0xc,%eax
}
  8013a1:	5d                   	pop    %ebp
  8013a2:	c3                   	ret    

008013a3 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8013a3:	55                   	push   %ebp
  8013a4:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a9:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8013ae:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013b3:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8013b8:	5d                   	pop    %ebp
  8013b9:	c3                   	ret    

008013ba <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8013ba:	55                   	push   %ebp
  8013bb:	89 e5                	mov    %esp,%ebp
  8013bd:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8013c2:	89 c2                	mov    %eax,%edx
  8013c4:	c1 ea 16             	shr    $0x16,%edx
  8013c7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013ce:	f6 c2 01             	test   $0x1,%dl
  8013d1:	74 2d                	je     801400 <fd_alloc+0x46>
  8013d3:	89 c2                	mov    %eax,%edx
  8013d5:	c1 ea 0c             	shr    $0xc,%edx
  8013d8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013df:	f6 c2 01             	test   $0x1,%dl
  8013e2:	74 1c                	je     801400 <fd_alloc+0x46>
  8013e4:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8013e9:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8013ee:	75 d2                	jne    8013c2 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8013f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8013f9:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8013fe:	eb 0a                	jmp    80140a <fd_alloc+0x50>
			*fd_store = fd;
  801400:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801403:	89 01                	mov    %eax,(%ecx)
			return 0;
  801405:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80140a:	5d                   	pop    %ebp
  80140b:	c3                   	ret    

0080140c <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80140c:	55                   	push   %ebp
  80140d:	89 e5                	mov    %esp,%ebp
  80140f:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801412:	83 f8 1f             	cmp    $0x1f,%eax
  801415:	77 30                	ja     801447 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801417:	c1 e0 0c             	shl    $0xc,%eax
  80141a:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80141f:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801425:	f6 c2 01             	test   $0x1,%dl
  801428:	74 24                	je     80144e <fd_lookup+0x42>
  80142a:	89 c2                	mov    %eax,%edx
  80142c:	c1 ea 0c             	shr    $0xc,%edx
  80142f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801436:	f6 c2 01             	test   $0x1,%dl
  801439:	74 1a                	je     801455 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80143b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80143e:	89 02                	mov    %eax,(%edx)
	return 0;
  801440:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801445:	5d                   	pop    %ebp
  801446:	c3                   	ret    
		return -E_INVAL;
  801447:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80144c:	eb f7                	jmp    801445 <fd_lookup+0x39>
		return -E_INVAL;
  80144e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801453:	eb f0                	jmp    801445 <fd_lookup+0x39>
  801455:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80145a:	eb e9                	jmp    801445 <fd_lookup+0x39>

0080145c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80145c:	55                   	push   %ebp
  80145d:	89 e5                	mov    %esp,%ebp
  80145f:	83 ec 08             	sub    $0x8,%esp
  801462:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801465:	ba 00 00 00 00       	mov    $0x0,%edx
  80146a:	b8 20 30 80 00       	mov    $0x803020,%eax
		if (devtab[i]->dev_id == dev_id) {
  80146f:	39 08                	cmp    %ecx,(%eax)
  801471:	74 38                	je     8014ab <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801473:	83 c2 01             	add    $0x1,%edx
  801476:	8b 04 95 64 2d 80 00 	mov    0x802d64(,%edx,4),%eax
  80147d:	85 c0                	test   %eax,%eax
  80147f:	75 ee                	jne    80146f <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801481:	a1 08 44 80 00       	mov    0x804408,%eax
  801486:	8b 40 48             	mov    0x48(%eax),%eax
  801489:	83 ec 04             	sub    $0x4,%esp
  80148c:	51                   	push   %ecx
  80148d:	50                   	push   %eax
  80148e:	68 e4 2c 80 00       	push   $0x802ce4
  801493:	e8 c5 ef ff ff       	call   80045d <cprintf>
	*dev = 0;
  801498:	8b 45 0c             	mov    0xc(%ebp),%eax
  80149b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8014a1:	83 c4 10             	add    $0x10,%esp
  8014a4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8014a9:	c9                   	leave  
  8014aa:	c3                   	ret    
			*dev = devtab[i];
  8014ab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014ae:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8014b5:	eb f2                	jmp    8014a9 <dev_lookup+0x4d>

008014b7 <fd_close>:
{
  8014b7:	55                   	push   %ebp
  8014b8:	89 e5                	mov    %esp,%ebp
  8014ba:	57                   	push   %edi
  8014bb:	56                   	push   %esi
  8014bc:	53                   	push   %ebx
  8014bd:	83 ec 24             	sub    $0x24,%esp
  8014c0:	8b 75 08             	mov    0x8(%ebp),%esi
  8014c3:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014c6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014c9:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014ca:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8014d0:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014d3:	50                   	push   %eax
  8014d4:	e8 33 ff ff ff       	call   80140c <fd_lookup>
  8014d9:	89 c3                	mov    %eax,%ebx
  8014db:	83 c4 10             	add    $0x10,%esp
  8014de:	85 c0                	test   %eax,%eax
  8014e0:	78 05                	js     8014e7 <fd_close+0x30>
	    || fd != fd2)
  8014e2:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8014e5:	74 16                	je     8014fd <fd_close+0x46>
		return (must_exist ? r : 0);
  8014e7:	89 f8                	mov    %edi,%eax
  8014e9:	84 c0                	test   %al,%al
  8014eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8014f0:	0f 44 d8             	cmove  %eax,%ebx
}
  8014f3:	89 d8                	mov    %ebx,%eax
  8014f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014f8:	5b                   	pop    %ebx
  8014f9:	5e                   	pop    %esi
  8014fa:	5f                   	pop    %edi
  8014fb:	5d                   	pop    %ebp
  8014fc:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8014fd:	83 ec 08             	sub    $0x8,%esp
  801500:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801503:	50                   	push   %eax
  801504:	ff 36                	pushl  (%esi)
  801506:	e8 51 ff ff ff       	call   80145c <dev_lookup>
  80150b:	89 c3                	mov    %eax,%ebx
  80150d:	83 c4 10             	add    $0x10,%esp
  801510:	85 c0                	test   %eax,%eax
  801512:	78 1a                	js     80152e <fd_close+0x77>
		if (dev->dev_close)
  801514:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801517:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80151a:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80151f:	85 c0                	test   %eax,%eax
  801521:	74 0b                	je     80152e <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801523:	83 ec 0c             	sub    $0xc,%esp
  801526:	56                   	push   %esi
  801527:	ff d0                	call   *%eax
  801529:	89 c3                	mov    %eax,%ebx
  80152b:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80152e:	83 ec 08             	sub    $0x8,%esp
  801531:	56                   	push   %esi
  801532:	6a 00                	push   $0x0
  801534:	e8 ea fb ff ff       	call   801123 <sys_page_unmap>
	return r;
  801539:	83 c4 10             	add    $0x10,%esp
  80153c:	eb b5                	jmp    8014f3 <fd_close+0x3c>

0080153e <close>:

int
close(int fdnum)
{
  80153e:	55                   	push   %ebp
  80153f:	89 e5                	mov    %esp,%ebp
  801541:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801544:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801547:	50                   	push   %eax
  801548:	ff 75 08             	pushl  0x8(%ebp)
  80154b:	e8 bc fe ff ff       	call   80140c <fd_lookup>
  801550:	83 c4 10             	add    $0x10,%esp
  801553:	85 c0                	test   %eax,%eax
  801555:	79 02                	jns    801559 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801557:	c9                   	leave  
  801558:	c3                   	ret    
		return fd_close(fd, 1);
  801559:	83 ec 08             	sub    $0x8,%esp
  80155c:	6a 01                	push   $0x1
  80155e:	ff 75 f4             	pushl  -0xc(%ebp)
  801561:	e8 51 ff ff ff       	call   8014b7 <fd_close>
  801566:	83 c4 10             	add    $0x10,%esp
  801569:	eb ec                	jmp    801557 <close+0x19>

0080156b <close_all>:

void
close_all(void)
{
  80156b:	55                   	push   %ebp
  80156c:	89 e5                	mov    %esp,%ebp
  80156e:	53                   	push   %ebx
  80156f:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801572:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801577:	83 ec 0c             	sub    $0xc,%esp
  80157a:	53                   	push   %ebx
  80157b:	e8 be ff ff ff       	call   80153e <close>
	for (i = 0; i < MAXFD; i++)
  801580:	83 c3 01             	add    $0x1,%ebx
  801583:	83 c4 10             	add    $0x10,%esp
  801586:	83 fb 20             	cmp    $0x20,%ebx
  801589:	75 ec                	jne    801577 <close_all+0xc>
}
  80158b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80158e:	c9                   	leave  
  80158f:	c3                   	ret    

00801590 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801590:	55                   	push   %ebp
  801591:	89 e5                	mov    %esp,%ebp
  801593:	57                   	push   %edi
  801594:	56                   	push   %esi
  801595:	53                   	push   %ebx
  801596:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801599:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80159c:	50                   	push   %eax
  80159d:	ff 75 08             	pushl  0x8(%ebp)
  8015a0:	e8 67 fe ff ff       	call   80140c <fd_lookup>
  8015a5:	89 c3                	mov    %eax,%ebx
  8015a7:	83 c4 10             	add    $0x10,%esp
  8015aa:	85 c0                	test   %eax,%eax
  8015ac:	0f 88 81 00 00 00    	js     801633 <dup+0xa3>
		return r;
	close(newfdnum);
  8015b2:	83 ec 0c             	sub    $0xc,%esp
  8015b5:	ff 75 0c             	pushl  0xc(%ebp)
  8015b8:	e8 81 ff ff ff       	call   80153e <close>

	newfd = INDEX2FD(newfdnum);
  8015bd:	8b 75 0c             	mov    0xc(%ebp),%esi
  8015c0:	c1 e6 0c             	shl    $0xc,%esi
  8015c3:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8015c9:	83 c4 04             	add    $0x4,%esp
  8015cc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015cf:	e8 cf fd ff ff       	call   8013a3 <fd2data>
  8015d4:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8015d6:	89 34 24             	mov    %esi,(%esp)
  8015d9:	e8 c5 fd ff ff       	call   8013a3 <fd2data>
  8015de:	83 c4 10             	add    $0x10,%esp
  8015e1:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8015e3:	89 d8                	mov    %ebx,%eax
  8015e5:	c1 e8 16             	shr    $0x16,%eax
  8015e8:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015ef:	a8 01                	test   $0x1,%al
  8015f1:	74 11                	je     801604 <dup+0x74>
  8015f3:	89 d8                	mov    %ebx,%eax
  8015f5:	c1 e8 0c             	shr    $0xc,%eax
  8015f8:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8015ff:	f6 c2 01             	test   $0x1,%dl
  801602:	75 39                	jne    80163d <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801604:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801607:	89 d0                	mov    %edx,%eax
  801609:	c1 e8 0c             	shr    $0xc,%eax
  80160c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801613:	83 ec 0c             	sub    $0xc,%esp
  801616:	25 07 0e 00 00       	and    $0xe07,%eax
  80161b:	50                   	push   %eax
  80161c:	56                   	push   %esi
  80161d:	6a 00                	push   $0x0
  80161f:	52                   	push   %edx
  801620:	6a 00                	push   $0x0
  801622:	e8 ba fa ff ff       	call   8010e1 <sys_page_map>
  801627:	89 c3                	mov    %eax,%ebx
  801629:	83 c4 20             	add    $0x20,%esp
  80162c:	85 c0                	test   %eax,%eax
  80162e:	78 31                	js     801661 <dup+0xd1>
		goto err;

	return newfdnum;
  801630:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801633:	89 d8                	mov    %ebx,%eax
  801635:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801638:	5b                   	pop    %ebx
  801639:	5e                   	pop    %esi
  80163a:	5f                   	pop    %edi
  80163b:	5d                   	pop    %ebp
  80163c:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80163d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801644:	83 ec 0c             	sub    $0xc,%esp
  801647:	25 07 0e 00 00       	and    $0xe07,%eax
  80164c:	50                   	push   %eax
  80164d:	57                   	push   %edi
  80164e:	6a 00                	push   $0x0
  801650:	53                   	push   %ebx
  801651:	6a 00                	push   $0x0
  801653:	e8 89 fa ff ff       	call   8010e1 <sys_page_map>
  801658:	89 c3                	mov    %eax,%ebx
  80165a:	83 c4 20             	add    $0x20,%esp
  80165d:	85 c0                	test   %eax,%eax
  80165f:	79 a3                	jns    801604 <dup+0x74>
	sys_page_unmap(0, newfd);
  801661:	83 ec 08             	sub    $0x8,%esp
  801664:	56                   	push   %esi
  801665:	6a 00                	push   $0x0
  801667:	e8 b7 fa ff ff       	call   801123 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80166c:	83 c4 08             	add    $0x8,%esp
  80166f:	57                   	push   %edi
  801670:	6a 00                	push   $0x0
  801672:	e8 ac fa ff ff       	call   801123 <sys_page_unmap>
	return r;
  801677:	83 c4 10             	add    $0x10,%esp
  80167a:	eb b7                	jmp    801633 <dup+0xa3>

0080167c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80167c:	55                   	push   %ebp
  80167d:	89 e5                	mov    %esp,%ebp
  80167f:	53                   	push   %ebx
  801680:	83 ec 1c             	sub    $0x1c,%esp
  801683:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801686:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801689:	50                   	push   %eax
  80168a:	53                   	push   %ebx
  80168b:	e8 7c fd ff ff       	call   80140c <fd_lookup>
  801690:	83 c4 10             	add    $0x10,%esp
  801693:	85 c0                	test   %eax,%eax
  801695:	78 3f                	js     8016d6 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801697:	83 ec 08             	sub    $0x8,%esp
  80169a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80169d:	50                   	push   %eax
  80169e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a1:	ff 30                	pushl  (%eax)
  8016a3:	e8 b4 fd ff ff       	call   80145c <dev_lookup>
  8016a8:	83 c4 10             	add    $0x10,%esp
  8016ab:	85 c0                	test   %eax,%eax
  8016ad:	78 27                	js     8016d6 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8016af:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016b2:	8b 42 08             	mov    0x8(%edx),%eax
  8016b5:	83 e0 03             	and    $0x3,%eax
  8016b8:	83 f8 01             	cmp    $0x1,%eax
  8016bb:	74 1e                	je     8016db <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8016bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c0:	8b 40 08             	mov    0x8(%eax),%eax
  8016c3:	85 c0                	test   %eax,%eax
  8016c5:	74 35                	je     8016fc <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8016c7:	83 ec 04             	sub    $0x4,%esp
  8016ca:	ff 75 10             	pushl  0x10(%ebp)
  8016cd:	ff 75 0c             	pushl  0xc(%ebp)
  8016d0:	52                   	push   %edx
  8016d1:	ff d0                	call   *%eax
  8016d3:	83 c4 10             	add    $0x10,%esp
}
  8016d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016d9:	c9                   	leave  
  8016da:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8016db:	a1 08 44 80 00       	mov    0x804408,%eax
  8016e0:	8b 40 48             	mov    0x48(%eax),%eax
  8016e3:	83 ec 04             	sub    $0x4,%esp
  8016e6:	53                   	push   %ebx
  8016e7:	50                   	push   %eax
  8016e8:	68 28 2d 80 00       	push   $0x802d28
  8016ed:	e8 6b ed ff ff       	call   80045d <cprintf>
		return -E_INVAL;
  8016f2:	83 c4 10             	add    $0x10,%esp
  8016f5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016fa:	eb da                	jmp    8016d6 <read+0x5a>
		return -E_NOT_SUPP;
  8016fc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801701:	eb d3                	jmp    8016d6 <read+0x5a>

00801703 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801703:	55                   	push   %ebp
  801704:	89 e5                	mov    %esp,%ebp
  801706:	57                   	push   %edi
  801707:	56                   	push   %esi
  801708:	53                   	push   %ebx
  801709:	83 ec 0c             	sub    $0xc,%esp
  80170c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80170f:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801712:	bb 00 00 00 00       	mov    $0x0,%ebx
  801717:	39 f3                	cmp    %esi,%ebx
  801719:	73 23                	jae    80173e <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80171b:	83 ec 04             	sub    $0x4,%esp
  80171e:	89 f0                	mov    %esi,%eax
  801720:	29 d8                	sub    %ebx,%eax
  801722:	50                   	push   %eax
  801723:	89 d8                	mov    %ebx,%eax
  801725:	03 45 0c             	add    0xc(%ebp),%eax
  801728:	50                   	push   %eax
  801729:	57                   	push   %edi
  80172a:	e8 4d ff ff ff       	call   80167c <read>
		if (m < 0)
  80172f:	83 c4 10             	add    $0x10,%esp
  801732:	85 c0                	test   %eax,%eax
  801734:	78 06                	js     80173c <readn+0x39>
			return m;
		if (m == 0)
  801736:	74 06                	je     80173e <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801738:	01 c3                	add    %eax,%ebx
  80173a:	eb db                	jmp    801717 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80173c:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80173e:	89 d8                	mov    %ebx,%eax
  801740:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801743:	5b                   	pop    %ebx
  801744:	5e                   	pop    %esi
  801745:	5f                   	pop    %edi
  801746:	5d                   	pop    %ebp
  801747:	c3                   	ret    

00801748 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801748:	55                   	push   %ebp
  801749:	89 e5                	mov    %esp,%ebp
  80174b:	53                   	push   %ebx
  80174c:	83 ec 1c             	sub    $0x1c,%esp
  80174f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801752:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801755:	50                   	push   %eax
  801756:	53                   	push   %ebx
  801757:	e8 b0 fc ff ff       	call   80140c <fd_lookup>
  80175c:	83 c4 10             	add    $0x10,%esp
  80175f:	85 c0                	test   %eax,%eax
  801761:	78 3a                	js     80179d <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801763:	83 ec 08             	sub    $0x8,%esp
  801766:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801769:	50                   	push   %eax
  80176a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80176d:	ff 30                	pushl  (%eax)
  80176f:	e8 e8 fc ff ff       	call   80145c <dev_lookup>
  801774:	83 c4 10             	add    $0x10,%esp
  801777:	85 c0                	test   %eax,%eax
  801779:	78 22                	js     80179d <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80177b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80177e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801782:	74 1e                	je     8017a2 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801784:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801787:	8b 52 0c             	mov    0xc(%edx),%edx
  80178a:	85 d2                	test   %edx,%edx
  80178c:	74 35                	je     8017c3 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80178e:	83 ec 04             	sub    $0x4,%esp
  801791:	ff 75 10             	pushl  0x10(%ebp)
  801794:	ff 75 0c             	pushl  0xc(%ebp)
  801797:	50                   	push   %eax
  801798:	ff d2                	call   *%edx
  80179a:	83 c4 10             	add    $0x10,%esp
}
  80179d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017a0:	c9                   	leave  
  8017a1:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8017a2:	a1 08 44 80 00       	mov    0x804408,%eax
  8017a7:	8b 40 48             	mov    0x48(%eax),%eax
  8017aa:	83 ec 04             	sub    $0x4,%esp
  8017ad:	53                   	push   %ebx
  8017ae:	50                   	push   %eax
  8017af:	68 44 2d 80 00       	push   $0x802d44
  8017b4:	e8 a4 ec ff ff       	call   80045d <cprintf>
		return -E_INVAL;
  8017b9:	83 c4 10             	add    $0x10,%esp
  8017bc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017c1:	eb da                	jmp    80179d <write+0x55>
		return -E_NOT_SUPP;
  8017c3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017c8:	eb d3                	jmp    80179d <write+0x55>

008017ca <seek>:

int
seek(int fdnum, off_t offset)
{
  8017ca:	55                   	push   %ebp
  8017cb:	89 e5                	mov    %esp,%ebp
  8017cd:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017d0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017d3:	50                   	push   %eax
  8017d4:	ff 75 08             	pushl  0x8(%ebp)
  8017d7:	e8 30 fc ff ff       	call   80140c <fd_lookup>
  8017dc:	83 c4 10             	add    $0x10,%esp
  8017df:	85 c0                	test   %eax,%eax
  8017e1:	78 0e                	js     8017f1 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8017e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e9:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8017ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017f1:	c9                   	leave  
  8017f2:	c3                   	ret    

008017f3 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8017f3:	55                   	push   %ebp
  8017f4:	89 e5                	mov    %esp,%ebp
  8017f6:	53                   	push   %ebx
  8017f7:	83 ec 1c             	sub    $0x1c,%esp
  8017fa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017fd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801800:	50                   	push   %eax
  801801:	53                   	push   %ebx
  801802:	e8 05 fc ff ff       	call   80140c <fd_lookup>
  801807:	83 c4 10             	add    $0x10,%esp
  80180a:	85 c0                	test   %eax,%eax
  80180c:	78 37                	js     801845 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80180e:	83 ec 08             	sub    $0x8,%esp
  801811:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801814:	50                   	push   %eax
  801815:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801818:	ff 30                	pushl  (%eax)
  80181a:	e8 3d fc ff ff       	call   80145c <dev_lookup>
  80181f:	83 c4 10             	add    $0x10,%esp
  801822:	85 c0                	test   %eax,%eax
  801824:	78 1f                	js     801845 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801826:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801829:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80182d:	74 1b                	je     80184a <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80182f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801832:	8b 52 18             	mov    0x18(%edx),%edx
  801835:	85 d2                	test   %edx,%edx
  801837:	74 32                	je     80186b <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801839:	83 ec 08             	sub    $0x8,%esp
  80183c:	ff 75 0c             	pushl  0xc(%ebp)
  80183f:	50                   	push   %eax
  801840:	ff d2                	call   *%edx
  801842:	83 c4 10             	add    $0x10,%esp
}
  801845:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801848:	c9                   	leave  
  801849:	c3                   	ret    
			thisenv->env_id, fdnum);
  80184a:	a1 08 44 80 00       	mov    0x804408,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80184f:	8b 40 48             	mov    0x48(%eax),%eax
  801852:	83 ec 04             	sub    $0x4,%esp
  801855:	53                   	push   %ebx
  801856:	50                   	push   %eax
  801857:	68 04 2d 80 00       	push   $0x802d04
  80185c:	e8 fc eb ff ff       	call   80045d <cprintf>
		return -E_INVAL;
  801861:	83 c4 10             	add    $0x10,%esp
  801864:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801869:	eb da                	jmp    801845 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80186b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801870:	eb d3                	jmp    801845 <ftruncate+0x52>

00801872 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
  801875:	53                   	push   %ebx
  801876:	83 ec 1c             	sub    $0x1c,%esp
  801879:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80187c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80187f:	50                   	push   %eax
  801880:	ff 75 08             	pushl  0x8(%ebp)
  801883:	e8 84 fb ff ff       	call   80140c <fd_lookup>
  801888:	83 c4 10             	add    $0x10,%esp
  80188b:	85 c0                	test   %eax,%eax
  80188d:	78 4b                	js     8018da <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80188f:	83 ec 08             	sub    $0x8,%esp
  801892:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801895:	50                   	push   %eax
  801896:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801899:	ff 30                	pushl  (%eax)
  80189b:	e8 bc fb ff ff       	call   80145c <dev_lookup>
  8018a0:	83 c4 10             	add    $0x10,%esp
  8018a3:	85 c0                	test   %eax,%eax
  8018a5:	78 33                	js     8018da <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8018a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018aa:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8018ae:	74 2f                	je     8018df <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8018b0:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8018b3:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8018ba:	00 00 00 
	stat->st_isdir = 0;
  8018bd:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8018c4:	00 00 00 
	stat->st_dev = dev;
  8018c7:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8018cd:	83 ec 08             	sub    $0x8,%esp
  8018d0:	53                   	push   %ebx
  8018d1:	ff 75 f0             	pushl  -0x10(%ebp)
  8018d4:	ff 50 14             	call   *0x14(%eax)
  8018d7:	83 c4 10             	add    $0x10,%esp
}
  8018da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018dd:	c9                   	leave  
  8018de:	c3                   	ret    
		return -E_NOT_SUPP;
  8018df:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018e4:	eb f4                	jmp    8018da <fstat+0x68>

008018e6 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
  8018e9:	56                   	push   %esi
  8018ea:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8018eb:	83 ec 08             	sub    $0x8,%esp
  8018ee:	6a 00                	push   $0x0
  8018f0:	ff 75 08             	pushl  0x8(%ebp)
  8018f3:	e8 22 02 00 00       	call   801b1a <open>
  8018f8:	89 c3                	mov    %eax,%ebx
  8018fa:	83 c4 10             	add    $0x10,%esp
  8018fd:	85 c0                	test   %eax,%eax
  8018ff:	78 1b                	js     80191c <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801901:	83 ec 08             	sub    $0x8,%esp
  801904:	ff 75 0c             	pushl  0xc(%ebp)
  801907:	50                   	push   %eax
  801908:	e8 65 ff ff ff       	call   801872 <fstat>
  80190d:	89 c6                	mov    %eax,%esi
	close(fd);
  80190f:	89 1c 24             	mov    %ebx,(%esp)
  801912:	e8 27 fc ff ff       	call   80153e <close>
	return r;
  801917:	83 c4 10             	add    $0x10,%esp
  80191a:	89 f3                	mov    %esi,%ebx
}
  80191c:	89 d8                	mov    %ebx,%eax
  80191e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801921:	5b                   	pop    %ebx
  801922:	5e                   	pop    %esi
  801923:	5d                   	pop    %ebp
  801924:	c3                   	ret    

00801925 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801925:	55                   	push   %ebp
  801926:	89 e5                	mov    %esp,%ebp
  801928:	56                   	push   %esi
  801929:	53                   	push   %ebx
  80192a:	89 c6                	mov    %eax,%esi
  80192c:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80192e:	83 3d 00 44 80 00 00 	cmpl   $0x0,0x804400
  801935:	74 27                	je     80195e <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801937:	6a 07                	push   $0x7
  801939:	68 00 50 80 00       	push   $0x805000
  80193e:	56                   	push   %esi
  80193f:	ff 35 00 44 80 00    	pushl  0x804400
  801945:	e8 a7 0b 00 00       	call   8024f1 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80194a:	83 c4 0c             	add    $0xc,%esp
  80194d:	6a 00                	push   $0x0
  80194f:	53                   	push   %ebx
  801950:	6a 00                	push   $0x0
  801952:	e8 31 0b 00 00       	call   802488 <ipc_recv>
}
  801957:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80195a:	5b                   	pop    %ebx
  80195b:	5e                   	pop    %esi
  80195c:	5d                   	pop    %ebp
  80195d:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80195e:	83 ec 0c             	sub    $0xc,%esp
  801961:	6a 01                	push   $0x1
  801963:	e8 e1 0b 00 00       	call   802549 <ipc_find_env>
  801968:	a3 00 44 80 00       	mov    %eax,0x804400
  80196d:	83 c4 10             	add    $0x10,%esp
  801970:	eb c5                	jmp    801937 <fsipc+0x12>

00801972 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801972:	55                   	push   %ebp
  801973:	89 e5                	mov    %esp,%ebp
  801975:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801978:	8b 45 08             	mov    0x8(%ebp),%eax
  80197b:	8b 40 0c             	mov    0xc(%eax),%eax
  80197e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801983:	8b 45 0c             	mov    0xc(%ebp),%eax
  801986:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80198b:	ba 00 00 00 00       	mov    $0x0,%edx
  801990:	b8 02 00 00 00       	mov    $0x2,%eax
  801995:	e8 8b ff ff ff       	call   801925 <fsipc>
}
  80199a:	c9                   	leave  
  80199b:	c3                   	ret    

0080199c <devfile_flush>:
{
  80199c:	55                   	push   %ebp
  80199d:	89 e5                	mov    %esp,%ebp
  80199f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8019a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8019a8:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8019ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8019b2:	b8 06 00 00 00       	mov    $0x6,%eax
  8019b7:	e8 69 ff ff ff       	call   801925 <fsipc>
}
  8019bc:	c9                   	leave  
  8019bd:	c3                   	ret    

008019be <devfile_stat>:
{
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
  8019c1:	53                   	push   %ebx
  8019c2:	83 ec 04             	sub    $0x4,%esp
  8019c5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8019c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8019ce:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8019d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d8:	b8 05 00 00 00       	mov    $0x5,%eax
  8019dd:	e8 43 ff ff ff       	call   801925 <fsipc>
  8019e2:	85 c0                	test   %eax,%eax
  8019e4:	78 2c                	js     801a12 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8019e6:	83 ec 08             	sub    $0x8,%esp
  8019e9:	68 00 50 80 00       	push   $0x805000
  8019ee:	53                   	push   %ebx
  8019ef:	e8 b8 f2 ff ff       	call   800cac <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8019f4:	a1 80 50 80 00       	mov    0x805080,%eax
  8019f9:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8019ff:	a1 84 50 80 00       	mov    0x805084,%eax
  801a04:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a0a:	83 c4 10             	add    $0x10,%esp
  801a0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a15:	c9                   	leave  
  801a16:	c3                   	ret    

00801a17 <devfile_write>:
{
  801a17:	55                   	push   %ebp
  801a18:	89 e5                	mov    %esp,%ebp
  801a1a:	53                   	push   %ebx
  801a1b:	83 ec 08             	sub    $0x8,%esp
  801a1e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a21:	8b 45 08             	mov    0x8(%ebp),%eax
  801a24:	8b 40 0c             	mov    0xc(%eax),%eax
  801a27:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801a2c:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801a32:	53                   	push   %ebx
  801a33:	ff 75 0c             	pushl  0xc(%ebp)
  801a36:	68 08 50 80 00       	push   $0x805008
  801a3b:	e8 5c f4 ff ff       	call   800e9c <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801a40:	ba 00 00 00 00       	mov    $0x0,%edx
  801a45:	b8 04 00 00 00       	mov    $0x4,%eax
  801a4a:	e8 d6 fe ff ff       	call   801925 <fsipc>
  801a4f:	83 c4 10             	add    $0x10,%esp
  801a52:	85 c0                	test   %eax,%eax
  801a54:	78 0b                	js     801a61 <devfile_write+0x4a>
	assert(r <= n);
  801a56:	39 d8                	cmp    %ebx,%eax
  801a58:	77 0c                	ja     801a66 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801a5a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a5f:	7f 1e                	jg     801a7f <devfile_write+0x68>
}
  801a61:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a64:	c9                   	leave  
  801a65:	c3                   	ret    
	assert(r <= n);
  801a66:	68 78 2d 80 00       	push   $0x802d78
  801a6b:	68 7f 2d 80 00       	push   $0x802d7f
  801a70:	68 98 00 00 00       	push   $0x98
  801a75:	68 94 2d 80 00       	push   $0x802d94
  801a7a:	e8 e8 e8 ff ff       	call   800367 <_panic>
	assert(r <= PGSIZE);
  801a7f:	68 9f 2d 80 00       	push   $0x802d9f
  801a84:	68 7f 2d 80 00       	push   $0x802d7f
  801a89:	68 99 00 00 00       	push   $0x99
  801a8e:	68 94 2d 80 00       	push   $0x802d94
  801a93:	e8 cf e8 ff ff       	call   800367 <_panic>

00801a98 <devfile_read>:
{
  801a98:	55                   	push   %ebp
  801a99:	89 e5                	mov    %esp,%ebp
  801a9b:	56                   	push   %esi
  801a9c:	53                   	push   %ebx
  801a9d:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa3:	8b 40 0c             	mov    0xc(%eax),%eax
  801aa6:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801aab:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801ab1:	ba 00 00 00 00       	mov    $0x0,%edx
  801ab6:	b8 03 00 00 00       	mov    $0x3,%eax
  801abb:	e8 65 fe ff ff       	call   801925 <fsipc>
  801ac0:	89 c3                	mov    %eax,%ebx
  801ac2:	85 c0                	test   %eax,%eax
  801ac4:	78 1f                	js     801ae5 <devfile_read+0x4d>
	assert(r <= n);
  801ac6:	39 f0                	cmp    %esi,%eax
  801ac8:	77 24                	ja     801aee <devfile_read+0x56>
	assert(r <= PGSIZE);
  801aca:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801acf:	7f 33                	jg     801b04 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801ad1:	83 ec 04             	sub    $0x4,%esp
  801ad4:	50                   	push   %eax
  801ad5:	68 00 50 80 00       	push   $0x805000
  801ada:	ff 75 0c             	pushl  0xc(%ebp)
  801add:	e8 58 f3 ff ff       	call   800e3a <memmove>
	return r;
  801ae2:	83 c4 10             	add    $0x10,%esp
}
  801ae5:	89 d8                	mov    %ebx,%eax
  801ae7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aea:	5b                   	pop    %ebx
  801aeb:	5e                   	pop    %esi
  801aec:	5d                   	pop    %ebp
  801aed:	c3                   	ret    
	assert(r <= n);
  801aee:	68 78 2d 80 00       	push   $0x802d78
  801af3:	68 7f 2d 80 00       	push   $0x802d7f
  801af8:	6a 7c                	push   $0x7c
  801afa:	68 94 2d 80 00       	push   $0x802d94
  801aff:	e8 63 e8 ff ff       	call   800367 <_panic>
	assert(r <= PGSIZE);
  801b04:	68 9f 2d 80 00       	push   $0x802d9f
  801b09:	68 7f 2d 80 00       	push   $0x802d7f
  801b0e:	6a 7d                	push   $0x7d
  801b10:	68 94 2d 80 00       	push   $0x802d94
  801b15:	e8 4d e8 ff ff       	call   800367 <_panic>

00801b1a <open>:
{
  801b1a:	55                   	push   %ebp
  801b1b:	89 e5                	mov    %esp,%ebp
  801b1d:	56                   	push   %esi
  801b1e:	53                   	push   %ebx
  801b1f:	83 ec 1c             	sub    $0x1c,%esp
  801b22:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801b25:	56                   	push   %esi
  801b26:	e8 48 f1 ff ff       	call   800c73 <strlen>
  801b2b:	83 c4 10             	add    $0x10,%esp
  801b2e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b33:	7f 6c                	jg     801ba1 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801b35:	83 ec 0c             	sub    $0xc,%esp
  801b38:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b3b:	50                   	push   %eax
  801b3c:	e8 79 f8 ff ff       	call   8013ba <fd_alloc>
  801b41:	89 c3                	mov    %eax,%ebx
  801b43:	83 c4 10             	add    $0x10,%esp
  801b46:	85 c0                	test   %eax,%eax
  801b48:	78 3c                	js     801b86 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801b4a:	83 ec 08             	sub    $0x8,%esp
  801b4d:	56                   	push   %esi
  801b4e:	68 00 50 80 00       	push   $0x805000
  801b53:	e8 54 f1 ff ff       	call   800cac <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b58:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b5b:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b63:	b8 01 00 00 00       	mov    $0x1,%eax
  801b68:	e8 b8 fd ff ff       	call   801925 <fsipc>
  801b6d:	89 c3                	mov    %eax,%ebx
  801b6f:	83 c4 10             	add    $0x10,%esp
  801b72:	85 c0                	test   %eax,%eax
  801b74:	78 19                	js     801b8f <open+0x75>
	return fd2num(fd);
  801b76:	83 ec 0c             	sub    $0xc,%esp
  801b79:	ff 75 f4             	pushl  -0xc(%ebp)
  801b7c:	e8 12 f8 ff ff       	call   801393 <fd2num>
  801b81:	89 c3                	mov    %eax,%ebx
  801b83:	83 c4 10             	add    $0x10,%esp
}
  801b86:	89 d8                	mov    %ebx,%eax
  801b88:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b8b:	5b                   	pop    %ebx
  801b8c:	5e                   	pop    %esi
  801b8d:	5d                   	pop    %ebp
  801b8e:	c3                   	ret    
		fd_close(fd, 0);
  801b8f:	83 ec 08             	sub    $0x8,%esp
  801b92:	6a 00                	push   $0x0
  801b94:	ff 75 f4             	pushl  -0xc(%ebp)
  801b97:	e8 1b f9 ff ff       	call   8014b7 <fd_close>
		return r;
  801b9c:	83 c4 10             	add    $0x10,%esp
  801b9f:	eb e5                	jmp    801b86 <open+0x6c>
		return -E_BAD_PATH;
  801ba1:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801ba6:	eb de                	jmp    801b86 <open+0x6c>

00801ba8 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801ba8:	55                   	push   %ebp
  801ba9:	89 e5                	mov    %esp,%ebp
  801bab:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801bae:	ba 00 00 00 00       	mov    $0x0,%edx
  801bb3:	b8 08 00 00 00       	mov    $0x8,%eax
  801bb8:	e8 68 fd ff ff       	call   801925 <fsipc>
}
  801bbd:	c9                   	leave  
  801bbe:	c3                   	ret    

00801bbf <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  801bbf:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801bc3:	7f 01                	jg     801bc6 <writebuf+0x7>
  801bc5:	c3                   	ret    
{
  801bc6:	55                   	push   %ebp
  801bc7:	89 e5                	mov    %esp,%ebp
  801bc9:	53                   	push   %ebx
  801bca:	83 ec 08             	sub    $0x8,%esp
  801bcd:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  801bcf:	ff 70 04             	pushl  0x4(%eax)
  801bd2:	8d 40 10             	lea    0x10(%eax),%eax
  801bd5:	50                   	push   %eax
  801bd6:	ff 33                	pushl  (%ebx)
  801bd8:	e8 6b fb ff ff       	call   801748 <write>
		if (result > 0)
  801bdd:	83 c4 10             	add    $0x10,%esp
  801be0:	85 c0                	test   %eax,%eax
  801be2:	7e 03                	jle    801be7 <writebuf+0x28>
			b->result += result;
  801be4:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801be7:	39 43 04             	cmp    %eax,0x4(%ebx)
  801bea:	74 0d                	je     801bf9 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  801bec:	85 c0                	test   %eax,%eax
  801bee:	ba 00 00 00 00       	mov    $0x0,%edx
  801bf3:	0f 4f c2             	cmovg  %edx,%eax
  801bf6:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801bf9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    

00801bfe <putch>:

static void
putch(int ch, void *thunk)
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
  801c01:	53                   	push   %ebx
  801c02:	83 ec 04             	sub    $0x4,%esp
  801c05:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801c08:	8b 53 04             	mov    0x4(%ebx),%edx
  801c0b:	8d 42 01             	lea    0x1(%edx),%eax
  801c0e:	89 43 04             	mov    %eax,0x4(%ebx)
  801c11:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c14:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801c18:	3d 00 01 00 00       	cmp    $0x100,%eax
  801c1d:	74 06                	je     801c25 <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  801c1f:	83 c4 04             	add    $0x4,%esp
  801c22:	5b                   	pop    %ebx
  801c23:	5d                   	pop    %ebp
  801c24:	c3                   	ret    
		writebuf(b);
  801c25:	89 d8                	mov    %ebx,%eax
  801c27:	e8 93 ff ff ff       	call   801bbf <writebuf>
		b->idx = 0;
  801c2c:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  801c33:	eb ea                	jmp    801c1f <putch+0x21>

00801c35 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801c35:	55                   	push   %ebp
  801c36:	89 e5                	mov    %esp,%ebp
  801c38:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c41:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801c47:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801c4e:	00 00 00 
	b.result = 0;
  801c51:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801c58:	00 00 00 
	b.error = 1;
  801c5b:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801c62:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801c65:	ff 75 10             	pushl  0x10(%ebp)
  801c68:	ff 75 0c             	pushl  0xc(%ebp)
  801c6b:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801c71:	50                   	push   %eax
  801c72:	68 fe 1b 80 00       	push   $0x801bfe
  801c77:	e8 0e e9 ff ff       	call   80058a <vprintfmt>
	if (b.idx > 0)
  801c7c:	83 c4 10             	add    $0x10,%esp
  801c7f:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801c86:	7f 11                	jg     801c99 <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  801c88:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801c8e:	85 c0                	test   %eax,%eax
  801c90:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801c97:	c9                   	leave  
  801c98:	c3                   	ret    
		writebuf(&b);
  801c99:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801c9f:	e8 1b ff ff ff       	call   801bbf <writebuf>
  801ca4:	eb e2                	jmp    801c88 <vfprintf+0x53>

00801ca6 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801ca6:	55                   	push   %ebp
  801ca7:	89 e5                	mov    %esp,%ebp
  801ca9:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801cac:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801caf:	50                   	push   %eax
  801cb0:	ff 75 0c             	pushl  0xc(%ebp)
  801cb3:	ff 75 08             	pushl  0x8(%ebp)
  801cb6:	e8 7a ff ff ff       	call   801c35 <vfprintf>
	va_end(ap);

	return cnt;
}
  801cbb:	c9                   	leave  
  801cbc:	c3                   	ret    

00801cbd <printf>:

int
printf(const char *fmt, ...)
{
  801cbd:	55                   	push   %ebp
  801cbe:	89 e5                	mov    %esp,%ebp
  801cc0:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801cc3:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801cc6:	50                   	push   %eax
  801cc7:	ff 75 08             	pushl  0x8(%ebp)
  801cca:	6a 01                	push   $0x1
  801ccc:	e8 64 ff ff ff       	call   801c35 <vfprintf>
	va_end(ap);

	return cnt;
}
  801cd1:	c9                   	leave  
  801cd2:	c3                   	ret    

00801cd3 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801cd3:	55                   	push   %ebp
  801cd4:	89 e5                	mov    %esp,%ebp
  801cd6:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801cd9:	68 ab 2d 80 00       	push   $0x802dab
  801cde:	ff 75 0c             	pushl  0xc(%ebp)
  801ce1:	e8 c6 ef ff ff       	call   800cac <strcpy>
	return 0;
}
  801ce6:	b8 00 00 00 00       	mov    $0x0,%eax
  801ceb:	c9                   	leave  
  801cec:	c3                   	ret    

00801ced <devsock_close>:
{
  801ced:	55                   	push   %ebp
  801cee:	89 e5                	mov    %esp,%ebp
  801cf0:	53                   	push   %ebx
  801cf1:	83 ec 10             	sub    $0x10,%esp
  801cf4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801cf7:	53                   	push   %ebx
  801cf8:	e8 87 08 00 00       	call   802584 <pageref>
  801cfd:	83 c4 10             	add    $0x10,%esp
		return 0;
  801d00:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801d05:	83 f8 01             	cmp    $0x1,%eax
  801d08:	74 07                	je     801d11 <devsock_close+0x24>
}
  801d0a:	89 d0                	mov    %edx,%eax
  801d0c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d0f:	c9                   	leave  
  801d10:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801d11:	83 ec 0c             	sub    $0xc,%esp
  801d14:	ff 73 0c             	pushl  0xc(%ebx)
  801d17:	e8 b9 02 00 00       	call   801fd5 <nsipc_close>
  801d1c:	89 c2                	mov    %eax,%edx
  801d1e:	83 c4 10             	add    $0x10,%esp
  801d21:	eb e7                	jmp    801d0a <devsock_close+0x1d>

00801d23 <devsock_write>:
{
  801d23:	55                   	push   %ebp
  801d24:	89 e5                	mov    %esp,%ebp
  801d26:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801d29:	6a 00                	push   $0x0
  801d2b:	ff 75 10             	pushl  0x10(%ebp)
  801d2e:	ff 75 0c             	pushl  0xc(%ebp)
  801d31:	8b 45 08             	mov    0x8(%ebp),%eax
  801d34:	ff 70 0c             	pushl  0xc(%eax)
  801d37:	e8 76 03 00 00       	call   8020b2 <nsipc_send>
}
  801d3c:	c9                   	leave  
  801d3d:	c3                   	ret    

00801d3e <devsock_read>:
{
  801d3e:	55                   	push   %ebp
  801d3f:	89 e5                	mov    %esp,%ebp
  801d41:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801d44:	6a 00                	push   $0x0
  801d46:	ff 75 10             	pushl  0x10(%ebp)
  801d49:	ff 75 0c             	pushl  0xc(%ebp)
  801d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4f:	ff 70 0c             	pushl  0xc(%eax)
  801d52:	e8 ef 02 00 00       	call   802046 <nsipc_recv>
}
  801d57:	c9                   	leave  
  801d58:	c3                   	ret    

00801d59 <fd2sockid>:
{
  801d59:	55                   	push   %ebp
  801d5a:	89 e5                	mov    %esp,%ebp
  801d5c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801d5f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801d62:	52                   	push   %edx
  801d63:	50                   	push   %eax
  801d64:	e8 a3 f6 ff ff       	call   80140c <fd_lookup>
  801d69:	83 c4 10             	add    $0x10,%esp
  801d6c:	85 c0                	test   %eax,%eax
  801d6e:	78 10                	js     801d80 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801d70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d73:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801d79:	39 08                	cmp    %ecx,(%eax)
  801d7b:	75 05                	jne    801d82 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801d7d:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801d80:	c9                   	leave  
  801d81:	c3                   	ret    
		return -E_NOT_SUPP;
  801d82:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d87:	eb f7                	jmp    801d80 <fd2sockid+0x27>

00801d89 <alloc_sockfd>:
{
  801d89:	55                   	push   %ebp
  801d8a:	89 e5                	mov    %esp,%ebp
  801d8c:	56                   	push   %esi
  801d8d:	53                   	push   %ebx
  801d8e:	83 ec 1c             	sub    $0x1c,%esp
  801d91:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801d93:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d96:	50                   	push   %eax
  801d97:	e8 1e f6 ff ff       	call   8013ba <fd_alloc>
  801d9c:	89 c3                	mov    %eax,%ebx
  801d9e:	83 c4 10             	add    $0x10,%esp
  801da1:	85 c0                	test   %eax,%eax
  801da3:	78 43                	js     801de8 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801da5:	83 ec 04             	sub    $0x4,%esp
  801da8:	68 07 04 00 00       	push   $0x407
  801dad:	ff 75 f4             	pushl  -0xc(%ebp)
  801db0:	6a 00                	push   $0x0
  801db2:	e8 e7 f2 ff ff       	call   80109e <sys_page_alloc>
  801db7:	89 c3                	mov    %eax,%ebx
  801db9:	83 c4 10             	add    $0x10,%esp
  801dbc:	85 c0                	test   %eax,%eax
  801dbe:	78 28                	js     801de8 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801dc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc3:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801dc9:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801dcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dce:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801dd5:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801dd8:	83 ec 0c             	sub    $0xc,%esp
  801ddb:	50                   	push   %eax
  801ddc:	e8 b2 f5 ff ff       	call   801393 <fd2num>
  801de1:	89 c3                	mov    %eax,%ebx
  801de3:	83 c4 10             	add    $0x10,%esp
  801de6:	eb 0c                	jmp    801df4 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801de8:	83 ec 0c             	sub    $0xc,%esp
  801deb:	56                   	push   %esi
  801dec:	e8 e4 01 00 00       	call   801fd5 <nsipc_close>
		return r;
  801df1:	83 c4 10             	add    $0x10,%esp
}
  801df4:	89 d8                	mov    %ebx,%eax
  801df6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801df9:	5b                   	pop    %ebx
  801dfa:	5e                   	pop    %esi
  801dfb:	5d                   	pop    %ebp
  801dfc:	c3                   	ret    

00801dfd <accept>:
{
  801dfd:	55                   	push   %ebp
  801dfe:	89 e5                	mov    %esp,%ebp
  801e00:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e03:	8b 45 08             	mov    0x8(%ebp),%eax
  801e06:	e8 4e ff ff ff       	call   801d59 <fd2sockid>
  801e0b:	85 c0                	test   %eax,%eax
  801e0d:	78 1b                	js     801e2a <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801e0f:	83 ec 04             	sub    $0x4,%esp
  801e12:	ff 75 10             	pushl  0x10(%ebp)
  801e15:	ff 75 0c             	pushl  0xc(%ebp)
  801e18:	50                   	push   %eax
  801e19:	e8 0e 01 00 00       	call   801f2c <nsipc_accept>
  801e1e:	83 c4 10             	add    $0x10,%esp
  801e21:	85 c0                	test   %eax,%eax
  801e23:	78 05                	js     801e2a <accept+0x2d>
	return alloc_sockfd(r);
  801e25:	e8 5f ff ff ff       	call   801d89 <alloc_sockfd>
}
  801e2a:	c9                   	leave  
  801e2b:	c3                   	ret    

00801e2c <bind>:
{
  801e2c:	55                   	push   %ebp
  801e2d:	89 e5                	mov    %esp,%ebp
  801e2f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e32:	8b 45 08             	mov    0x8(%ebp),%eax
  801e35:	e8 1f ff ff ff       	call   801d59 <fd2sockid>
  801e3a:	85 c0                	test   %eax,%eax
  801e3c:	78 12                	js     801e50 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801e3e:	83 ec 04             	sub    $0x4,%esp
  801e41:	ff 75 10             	pushl  0x10(%ebp)
  801e44:	ff 75 0c             	pushl  0xc(%ebp)
  801e47:	50                   	push   %eax
  801e48:	e8 31 01 00 00       	call   801f7e <nsipc_bind>
  801e4d:	83 c4 10             	add    $0x10,%esp
}
  801e50:	c9                   	leave  
  801e51:	c3                   	ret    

00801e52 <shutdown>:
{
  801e52:	55                   	push   %ebp
  801e53:	89 e5                	mov    %esp,%ebp
  801e55:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e58:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5b:	e8 f9 fe ff ff       	call   801d59 <fd2sockid>
  801e60:	85 c0                	test   %eax,%eax
  801e62:	78 0f                	js     801e73 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801e64:	83 ec 08             	sub    $0x8,%esp
  801e67:	ff 75 0c             	pushl  0xc(%ebp)
  801e6a:	50                   	push   %eax
  801e6b:	e8 43 01 00 00       	call   801fb3 <nsipc_shutdown>
  801e70:	83 c4 10             	add    $0x10,%esp
}
  801e73:	c9                   	leave  
  801e74:	c3                   	ret    

00801e75 <connect>:
{
  801e75:	55                   	push   %ebp
  801e76:	89 e5                	mov    %esp,%ebp
  801e78:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7e:	e8 d6 fe ff ff       	call   801d59 <fd2sockid>
  801e83:	85 c0                	test   %eax,%eax
  801e85:	78 12                	js     801e99 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801e87:	83 ec 04             	sub    $0x4,%esp
  801e8a:	ff 75 10             	pushl  0x10(%ebp)
  801e8d:	ff 75 0c             	pushl  0xc(%ebp)
  801e90:	50                   	push   %eax
  801e91:	e8 59 01 00 00       	call   801fef <nsipc_connect>
  801e96:	83 c4 10             	add    $0x10,%esp
}
  801e99:	c9                   	leave  
  801e9a:	c3                   	ret    

00801e9b <listen>:
{
  801e9b:	55                   	push   %ebp
  801e9c:	89 e5                	mov    %esp,%ebp
  801e9e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea4:	e8 b0 fe ff ff       	call   801d59 <fd2sockid>
  801ea9:	85 c0                	test   %eax,%eax
  801eab:	78 0f                	js     801ebc <listen+0x21>
	return nsipc_listen(r, backlog);
  801ead:	83 ec 08             	sub    $0x8,%esp
  801eb0:	ff 75 0c             	pushl  0xc(%ebp)
  801eb3:	50                   	push   %eax
  801eb4:	e8 6b 01 00 00       	call   802024 <nsipc_listen>
  801eb9:	83 c4 10             	add    $0x10,%esp
}
  801ebc:	c9                   	leave  
  801ebd:	c3                   	ret    

00801ebe <socket>:

int
socket(int domain, int type, int protocol)
{
  801ebe:	55                   	push   %ebp
  801ebf:	89 e5                	mov    %esp,%ebp
  801ec1:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801ec4:	ff 75 10             	pushl  0x10(%ebp)
  801ec7:	ff 75 0c             	pushl  0xc(%ebp)
  801eca:	ff 75 08             	pushl  0x8(%ebp)
  801ecd:	e8 3e 02 00 00       	call   802110 <nsipc_socket>
  801ed2:	83 c4 10             	add    $0x10,%esp
  801ed5:	85 c0                	test   %eax,%eax
  801ed7:	78 05                	js     801ede <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801ed9:	e8 ab fe ff ff       	call   801d89 <alloc_sockfd>
}
  801ede:	c9                   	leave  
  801edf:	c3                   	ret    

00801ee0 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801ee0:	55                   	push   %ebp
  801ee1:	89 e5                	mov    %esp,%ebp
  801ee3:	53                   	push   %ebx
  801ee4:	83 ec 04             	sub    $0x4,%esp
  801ee7:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801ee9:	83 3d 04 44 80 00 00 	cmpl   $0x0,0x804404
  801ef0:	74 26                	je     801f18 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801ef2:	6a 07                	push   $0x7
  801ef4:	68 00 60 80 00       	push   $0x806000
  801ef9:	53                   	push   %ebx
  801efa:	ff 35 04 44 80 00    	pushl  0x804404
  801f00:	e8 ec 05 00 00       	call   8024f1 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801f05:	83 c4 0c             	add    $0xc,%esp
  801f08:	6a 00                	push   $0x0
  801f0a:	6a 00                	push   $0x0
  801f0c:	6a 00                	push   $0x0
  801f0e:	e8 75 05 00 00       	call   802488 <ipc_recv>
}
  801f13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f16:	c9                   	leave  
  801f17:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801f18:	83 ec 0c             	sub    $0xc,%esp
  801f1b:	6a 02                	push   $0x2
  801f1d:	e8 27 06 00 00       	call   802549 <ipc_find_env>
  801f22:	a3 04 44 80 00       	mov    %eax,0x804404
  801f27:	83 c4 10             	add    $0x10,%esp
  801f2a:	eb c6                	jmp    801ef2 <nsipc+0x12>

00801f2c <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801f2c:	55                   	push   %ebp
  801f2d:	89 e5                	mov    %esp,%ebp
  801f2f:	56                   	push   %esi
  801f30:	53                   	push   %ebx
  801f31:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801f34:	8b 45 08             	mov    0x8(%ebp),%eax
  801f37:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801f3c:	8b 06                	mov    (%esi),%eax
  801f3e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801f43:	b8 01 00 00 00       	mov    $0x1,%eax
  801f48:	e8 93 ff ff ff       	call   801ee0 <nsipc>
  801f4d:	89 c3                	mov    %eax,%ebx
  801f4f:	85 c0                	test   %eax,%eax
  801f51:	79 09                	jns    801f5c <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801f53:	89 d8                	mov    %ebx,%eax
  801f55:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f58:	5b                   	pop    %ebx
  801f59:	5e                   	pop    %esi
  801f5a:	5d                   	pop    %ebp
  801f5b:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801f5c:	83 ec 04             	sub    $0x4,%esp
  801f5f:	ff 35 10 60 80 00    	pushl  0x806010
  801f65:	68 00 60 80 00       	push   $0x806000
  801f6a:	ff 75 0c             	pushl  0xc(%ebp)
  801f6d:	e8 c8 ee ff ff       	call   800e3a <memmove>
		*addrlen = ret->ret_addrlen;
  801f72:	a1 10 60 80 00       	mov    0x806010,%eax
  801f77:	89 06                	mov    %eax,(%esi)
  801f79:	83 c4 10             	add    $0x10,%esp
	return r;
  801f7c:	eb d5                	jmp    801f53 <nsipc_accept+0x27>

00801f7e <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801f7e:	55                   	push   %ebp
  801f7f:	89 e5                	mov    %esp,%ebp
  801f81:	53                   	push   %ebx
  801f82:	83 ec 08             	sub    $0x8,%esp
  801f85:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801f88:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8b:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801f90:	53                   	push   %ebx
  801f91:	ff 75 0c             	pushl  0xc(%ebp)
  801f94:	68 04 60 80 00       	push   $0x806004
  801f99:	e8 9c ee ff ff       	call   800e3a <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801f9e:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801fa4:	b8 02 00 00 00       	mov    $0x2,%eax
  801fa9:	e8 32 ff ff ff       	call   801ee0 <nsipc>
}
  801fae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fb1:	c9                   	leave  
  801fb2:	c3                   	ret    

00801fb3 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801fb3:	55                   	push   %ebp
  801fb4:	89 e5                	mov    %esp,%ebp
  801fb6:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbc:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801fc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fc4:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801fc9:	b8 03 00 00 00       	mov    $0x3,%eax
  801fce:	e8 0d ff ff ff       	call   801ee0 <nsipc>
}
  801fd3:	c9                   	leave  
  801fd4:	c3                   	ret    

00801fd5 <nsipc_close>:

int
nsipc_close(int s)
{
  801fd5:	55                   	push   %ebp
  801fd6:	89 e5                	mov    %esp,%ebp
  801fd8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fde:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801fe3:	b8 04 00 00 00       	mov    $0x4,%eax
  801fe8:	e8 f3 fe ff ff       	call   801ee0 <nsipc>
}
  801fed:	c9                   	leave  
  801fee:	c3                   	ret    

00801fef <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801fef:	55                   	push   %ebp
  801ff0:	89 e5                	mov    %esp,%ebp
  801ff2:	53                   	push   %ebx
  801ff3:	83 ec 08             	sub    $0x8,%esp
  801ff6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffc:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802001:	53                   	push   %ebx
  802002:	ff 75 0c             	pushl  0xc(%ebp)
  802005:	68 04 60 80 00       	push   $0x806004
  80200a:	e8 2b ee ff ff       	call   800e3a <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80200f:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  802015:	b8 05 00 00 00       	mov    $0x5,%eax
  80201a:	e8 c1 fe ff ff       	call   801ee0 <nsipc>
}
  80201f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802022:	c9                   	leave  
  802023:	c3                   	ret    

00802024 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802024:	55                   	push   %ebp
  802025:	89 e5                	mov    %esp,%ebp
  802027:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80202a:	8b 45 08             	mov    0x8(%ebp),%eax
  80202d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  802032:	8b 45 0c             	mov    0xc(%ebp),%eax
  802035:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  80203a:	b8 06 00 00 00       	mov    $0x6,%eax
  80203f:	e8 9c fe ff ff       	call   801ee0 <nsipc>
}
  802044:	c9                   	leave  
  802045:	c3                   	ret    

00802046 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802046:	55                   	push   %ebp
  802047:	89 e5                	mov    %esp,%ebp
  802049:	56                   	push   %esi
  80204a:	53                   	push   %ebx
  80204b:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80204e:	8b 45 08             	mov    0x8(%ebp),%eax
  802051:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  802056:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  80205c:	8b 45 14             	mov    0x14(%ebp),%eax
  80205f:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802064:	b8 07 00 00 00       	mov    $0x7,%eax
  802069:	e8 72 fe ff ff       	call   801ee0 <nsipc>
  80206e:	89 c3                	mov    %eax,%ebx
  802070:	85 c0                	test   %eax,%eax
  802072:	78 1f                	js     802093 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802074:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802079:	7f 21                	jg     80209c <nsipc_recv+0x56>
  80207b:	39 c6                	cmp    %eax,%esi
  80207d:	7c 1d                	jl     80209c <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80207f:	83 ec 04             	sub    $0x4,%esp
  802082:	50                   	push   %eax
  802083:	68 00 60 80 00       	push   $0x806000
  802088:	ff 75 0c             	pushl  0xc(%ebp)
  80208b:	e8 aa ed ff ff       	call   800e3a <memmove>
  802090:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802093:	89 d8                	mov    %ebx,%eax
  802095:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802098:	5b                   	pop    %ebx
  802099:	5e                   	pop    %esi
  80209a:	5d                   	pop    %ebp
  80209b:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80209c:	68 b7 2d 80 00       	push   $0x802db7
  8020a1:	68 7f 2d 80 00       	push   $0x802d7f
  8020a6:	6a 62                	push   $0x62
  8020a8:	68 cc 2d 80 00       	push   $0x802dcc
  8020ad:	e8 b5 e2 ff ff       	call   800367 <_panic>

008020b2 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8020b2:	55                   	push   %ebp
  8020b3:	89 e5                	mov    %esp,%ebp
  8020b5:	53                   	push   %ebx
  8020b6:	83 ec 04             	sub    $0x4,%esp
  8020b9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8020bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bf:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8020c4:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8020ca:	7f 2e                	jg     8020fa <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8020cc:	83 ec 04             	sub    $0x4,%esp
  8020cf:	53                   	push   %ebx
  8020d0:	ff 75 0c             	pushl  0xc(%ebp)
  8020d3:	68 0c 60 80 00       	push   $0x80600c
  8020d8:	e8 5d ed ff ff       	call   800e3a <memmove>
	nsipcbuf.send.req_size = size;
  8020dd:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8020e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8020e6:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8020eb:	b8 08 00 00 00       	mov    $0x8,%eax
  8020f0:	e8 eb fd ff ff       	call   801ee0 <nsipc>
}
  8020f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020f8:	c9                   	leave  
  8020f9:	c3                   	ret    
	assert(size < 1600);
  8020fa:	68 d8 2d 80 00       	push   $0x802dd8
  8020ff:	68 7f 2d 80 00       	push   $0x802d7f
  802104:	6a 6d                	push   $0x6d
  802106:	68 cc 2d 80 00       	push   $0x802dcc
  80210b:	e8 57 e2 ff ff       	call   800367 <_panic>

00802110 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802110:	55                   	push   %ebp
  802111:	89 e5                	mov    %esp,%ebp
  802113:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802116:	8b 45 08             	mov    0x8(%ebp),%eax
  802119:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  80211e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802121:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  802126:	8b 45 10             	mov    0x10(%ebp),%eax
  802129:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  80212e:	b8 09 00 00 00       	mov    $0x9,%eax
  802133:	e8 a8 fd ff ff       	call   801ee0 <nsipc>
}
  802138:	c9                   	leave  
  802139:	c3                   	ret    

0080213a <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80213a:	55                   	push   %ebp
  80213b:	89 e5                	mov    %esp,%ebp
  80213d:	56                   	push   %esi
  80213e:	53                   	push   %ebx
  80213f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802142:	83 ec 0c             	sub    $0xc,%esp
  802145:	ff 75 08             	pushl  0x8(%ebp)
  802148:	e8 56 f2 ff ff       	call   8013a3 <fd2data>
  80214d:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80214f:	83 c4 08             	add    $0x8,%esp
  802152:	68 e4 2d 80 00       	push   $0x802de4
  802157:	53                   	push   %ebx
  802158:	e8 4f eb ff ff       	call   800cac <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80215d:	8b 46 04             	mov    0x4(%esi),%eax
  802160:	2b 06                	sub    (%esi),%eax
  802162:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802168:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80216f:	00 00 00 
	stat->st_dev = &devpipe;
  802172:	c7 83 88 00 00 00 58 	movl   $0x803058,0x88(%ebx)
  802179:	30 80 00 
	return 0;
}
  80217c:	b8 00 00 00 00       	mov    $0x0,%eax
  802181:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802184:	5b                   	pop    %ebx
  802185:	5e                   	pop    %esi
  802186:	5d                   	pop    %ebp
  802187:	c3                   	ret    

00802188 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802188:	55                   	push   %ebp
  802189:	89 e5                	mov    %esp,%ebp
  80218b:	53                   	push   %ebx
  80218c:	83 ec 0c             	sub    $0xc,%esp
  80218f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802192:	53                   	push   %ebx
  802193:	6a 00                	push   $0x0
  802195:	e8 89 ef ff ff       	call   801123 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80219a:	89 1c 24             	mov    %ebx,(%esp)
  80219d:	e8 01 f2 ff ff       	call   8013a3 <fd2data>
  8021a2:	83 c4 08             	add    $0x8,%esp
  8021a5:	50                   	push   %eax
  8021a6:	6a 00                	push   $0x0
  8021a8:	e8 76 ef ff ff       	call   801123 <sys_page_unmap>
}
  8021ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021b0:	c9                   	leave  
  8021b1:	c3                   	ret    

008021b2 <_pipeisclosed>:
{
  8021b2:	55                   	push   %ebp
  8021b3:	89 e5                	mov    %esp,%ebp
  8021b5:	57                   	push   %edi
  8021b6:	56                   	push   %esi
  8021b7:	53                   	push   %ebx
  8021b8:	83 ec 1c             	sub    $0x1c,%esp
  8021bb:	89 c7                	mov    %eax,%edi
  8021bd:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8021bf:	a1 08 44 80 00       	mov    0x804408,%eax
  8021c4:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8021c7:	83 ec 0c             	sub    $0xc,%esp
  8021ca:	57                   	push   %edi
  8021cb:	e8 b4 03 00 00       	call   802584 <pageref>
  8021d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8021d3:	89 34 24             	mov    %esi,(%esp)
  8021d6:	e8 a9 03 00 00       	call   802584 <pageref>
		nn = thisenv->env_runs;
  8021db:	8b 15 08 44 80 00    	mov    0x804408,%edx
  8021e1:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8021e4:	83 c4 10             	add    $0x10,%esp
  8021e7:	39 cb                	cmp    %ecx,%ebx
  8021e9:	74 1b                	je     802206 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8021eb:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8021ee:	75 cf                	jne    8021bf <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8021f0:	8b 42 58             	mov    0x58(%edx),%eax
  8021f3:	6a 01                	push   $0x1
  8021f5:	50                   	push   %eax
  8021f6:	53                   	push   %ebx
  8021f7:	68 eb 2d 80 00       	push   $0x802deb
  8021fc:	e8 5c e2 ff ff       	call   80045d <cprintf>
  802201:	83 c4 10             	add    $0x10,%esp
  802204:	eb b9                	jmp    8021bf <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802206:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802209:	0f 94 c0             	sete   %al
  80220c:	0f b6 c0             	movzbl %al,%eax
}
  80220f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802212:	5b                   	pop    %ebx
  802213:	5e                   	pop    %esi
  802214:	5f                   	pop    %edi
  802215:	5d                   	pop    %ebp
  802216:	c3                   	ret    

00802217 <devpipe_write>:
{
  802217:	55                   	push   %ebp
  802218:	89 e5                	mov    %esp,%ebp
  80221a:	57                   	push   %edi
  80221b:	56                   	push   %esi
  80221c:	53                   	push   %ebx
  80221d:	83 ec 28             	sub    $0x28,%esp
  802220:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802223:	56                   	push   %esi
  802224:	e8 7a f1 ff ff       	call   8013a3 <fd2data>
  802229:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80222b:	83 c4 10             	add    $0x10,%esp
  80222e:	bf 00 00 00 00       	mov    $0x0,%edi
  802233:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802236:	74 4f                	je     802287 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802238:	8b 43 04             	mov    0x4(%ebx),%eax
  80223b:	8b 0b                	mov    (%ebx),%ecx
  80223d:	8d 51 20             	lea    0x20(%ecx),%edx
  802240:	39 d0                	cmp    %edx,%eax
  802242:	72 14                	jb     802258 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802244:	89 da                	mov    %ebx,%edx
  802246:	89 f0                	mov    %esi,%eax
  802248:	e8 65 ff ff ff       	call   8021b2 <_pipeisclosed>
  80224d:	85 c0                	test   %eax,%eax
  80224f:	75 3b                	jne    80228c <devpipe_write+0x75>
			sys_yield();
  802251:	e8 29 ee ff ff       	call   80107f <sys_yield>
  802256:	eb e0                	jmp    802238 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802258:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80225b:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80225f:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802262:	89 c2                	mov    %eax,%edx
  802264:	c1 fa 1f             	sar    $0x1f,%edx
  802267:	89 d1                	mov    %edx,%ecx
  802269:	c1 e9 1b             	shr    $0x1b,%ecx
  80226c:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80226f:	83 e2 1f             	and    $0x1f,%edx
  802272:	29 ca                	sub    %ecx,%edx
  802274:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802278:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80227c:	83 c0 01             	add    $0x1,%eax
  80227f:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802282:	83 c7 01             	add    $0x1,%edi
  802285:	eb ac                	jmp    802233 <devpipe_write+0x1c>
	return i;
  802287:	8b 45 10             	mov    0x10(%ebp),%eax
  80228a:	eb 05                	jmp    802291 <devpipe_write+0x7a>
				return 0;
  80228c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802291:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802294:	5b                   	pop    %ebx
  802295:	5e                   	pop    %esi
  802296:	5f                   	pop    %edi
  802297:	5d                   	pop    %ebp
  802298:	c3                   	ret    

00802299 <devpipe_read>:
{
  802299:	55                   	push   %ebp
  80229a:	89 e5                	mov    %esp,%ebp
  80229c:	57                   	push   %edi
  80229d:	56                   	push   %esi
  80229e:	53                   	push   %ebx
  80229f:	83 ec 18             	sub    $0x18,%esp
  8022a2:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8022a5:	57                   	push   %edi
  8022a6:	e8 f8 f0 ff ff       	call   8013a3 <fd2data>
  8022ab:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8022ad:	83 c4 10             	add    $0x10,%esp
  8022b0:	be 00 00 00 00       	mov    $0x0,%esi
  8022b5:	3b 75 10             	cmp    0x10(%ebp),%esi
  8022b8:	75 14                	jne    8022ce <devpipe_read+0x35>
	return i;
  8022ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8022bd:	eb 02                	jmp    8022c1 <devpipe_read+0x28>
				return i;
  8022bf:	89 f0                	mov    %esi,%eax
}
  8022c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022c4:	5b                   	pop    %ebx
  8022c5:	5e                   	pop    %esi
  8022c6:	5f                   	pop    %edi
  8022c7:	5d                   	pop    %ebp
  8022c8:	c3                   	ret    
			sys_yield();
  8022c9:	e8 b1 ed ff ff       	call   80107f <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8022ce:	8b 03                	mov    (%ebx),%eax
  8022d0:	3b 43 04             	cmp    0x4(%ebx),%eax
  8022d3:	75 18                	jne    8022ed <devpipe_read+0x54>
			if (i > 0)
  8022d5:	85 f6                	test   %esi,%esi
  8022d7:	75 e6                	jne    8022bf <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8022d9:	89 da                	mov    %ebx,%edx
  8022db:	89 f8                	mov    %edi,%eax
  8022dd:	e8 d0 fe ff ff       	call   8021b2 <_pipeisclosed>
  8022e2:	85 c0                	test   %eax,%eax
  8022e4:	74 e3                	je     8022c9 <devpipe_read+0x30>
				return 0;
  8022e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8022eb:	eb d4                	jmp    8022c1 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8022ed:	99                   	cltd   
  8022ee:	c1 ea 1b             	shr    $0x1b,%edx
  8022f1:	01 d0                	add    %edx,%eax
  8022f3:	83 e0 1f             	and    $0x1f,%eax
  8022f6:	29 d0                	sub    %edx,%eax
  8022f8:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8022fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802300:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802303:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802306:	83 c6 01             	add    $0x1,%esi
  802309:	eb aa                	jmp    8022b5 <devpipe_read+0x1c>

0080230b <pipe>:
{
  80230b:	55                   	push   %ebp
  80230c:	89 e5                	mov    %esp,%ebp
  80230e:	56                   	push   %esi
  80230f:	53                   	push   %ebx
  802310:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802313:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802316:	50                   	push   %eax
  802317:	e8 9e f0 ff ff       	call   8013ba <fd_alloc>
  80231c:	89 c3                	mov    %eax,%ebx
  80231e:	83 c4 10             	add    $0x10,%esp
  802321:	85 c0                	test   %eax,%eax
  802323:	0f 88 23 01 00 00    	js     80244c <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802329:	83 ec 04             	sub    $0x4,%esp
  80232c:	68 07 04 00 00       	push   $0x407
  802331:	ff 75 f4             	pushl  -0xc(%ebp)
  802334:	6a 00                	push   $0x0
  802336:	e8 63 ed ff ff       	call   80109e <sys_page_alloc>
  80233b:	89 c3                	mov    %eax,%ebx
  80233d:	83 c4 10             	add    $0x10,%esp
  802340:	85 c0                	test   %eax,%eax
  802342:	0f 88 04 01 00 00    	js     80244c <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802348:	83 ec 0c             	sub    $0xc,%esp
  80234b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80234e:	50                   	push   %eax
  80234f:	e8 66 f0 ff ff       	call   8013ba <fd_alloc>
  802354:	89 c3                	mov    %eax,%ebx
  802356:	83 c4 10             	add    $0x10,%esp
  802359:	85 c0                	test   %eax,%eax
  80235b:	0f 88 db 00 00 00    	js     80243c <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802361:	83 ec 04             	sub    $0x4,%esp
  802364:	68 07 04 00 00       	push   $0x407
  802369:	ff 75 f0             	pushl  -0x10(%ebp)
  80236c:	6a 00                	push   $0x0
  80236e:	e8 2b ed ff ff       	call   80109e <sys_page_alloc>
  802373:	89 c3                	mov    %eax,%ebx
  802375:	83 c4 10             	add    $0x10,%esp
  802378:	85 c0                	test   %eax,%eax
  80237a:	0f 88 bc 00 00 00    	js     80243c <pipe+0x131>
	va = fd2data(fd0);
  802380:	83 ec 0c             	sub    $0xc,%esp
  802383:	ff 75 f4             	pushl  -0xc(%ebp)
  802386:	e8 18 f0 ff ff       	call   8013a3 <fd2data>
  80238b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80238d:	83 c4 0c             	add    $0xc,%esp
  802390:	68 07 04 00 00       	push   $0x407
  802395:	50                   	push   %eax
  802396:	6a 00                	push   $0x0
  802398:	e8 01 ed ff ff       	call   80109e <sys_page_alloc>
  80239d:	89 c3                	mov    %eax,%ebx
  80239f:	83 c4 10             	add    $0x10,%esp
  8023a2:	85 c0                	test   %eax,%eax
  8023a4:	0f 88 82 00 00 00    	js     80242c <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023aa:	83 ec 0c             	sub    $0xc,%esp
  8023ad:	ff 75 f0             	pushl  -0x10(%ebp)
  8023b0:	e8 ee ef ff ff       	call   8013a3 <fd2data>
  8023b5:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8023bc:	50                   	push   %eax
  8023bd:	6a 00                	push   $0x0
  8023bf:	56                   	push   %esi
  8023c0:	6a 00                	push   $0x0
  8023c2:	e8 1a ed ff ff       	call   8010e1 <sys_page_map>
  8023c7:	89 c3                	mov    %eax,%ebx
  8023c9:	83 c4 20             	add    $0x20,%esp
  8023cc:	85 c0                	test   %eax,%eax
  8023ce:	78 4e                	js     80241e <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8023d0:	a1 58 30 80 00       	mov    0x803058,%eax
  8023d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023d8:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8023da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023dd:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8023e4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023e7:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8023e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ec:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8023f3:	83 ec 0c             	sub    $0xc,%esp
  8023f6:	ff 75 f4             	pushl  -0xc(%ebp)
  8023f9:	e8 95 ef ff ff       	call   801393 <fd2num>
  8023fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802401:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802403:	83 c4 04             	add    $0x4,%esp
  802406:	ff 75 f0             	pushl  -0x10(%ebp)
  802409:	e8 85 ef ff ff       	call   801393 <fd2num>
  80240e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802411:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802414:	83 c4 10             	add    $0x10,%esp
  802417:	bb 00 00 00 00       	mov    $0x0,%ebx
  80241c:	eb 2e                	jmp    80244c <pipe+0x141>
	sys_page_unmap(0, va);
  80241e:	83 ec 08             	sub    $0x8,%esp
  802421:	56                   	push   %esi
  802422:	6a 00                	push   $0x0
  802424:	e8 fa ec ff ff       	call   801123 <sys_page_unmap>
  802429:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80242c:	83 ec 08             	sub    $0x8,%esp
  80242f:	ff 75 f0             	pushl  -0x10(%ebp)
  802432:	6a 00                	push   $0x0
  802434:	e8 ea ec ff ff       	call   801123 <sys_page_unmap>
  802439:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80243c:	83 ec 08             	sub    $0x8,%esp
  80243f:	ff 75 f4             	pushl  -0xc(%ebp)
  802442:	6a 00                	push   $0x0
  802444:	e8 da ec ff ff       	call   801123 <sys_page_unmap>
  802449:	83 c4 10             	add    $0x10,%esp
}
  80244c:	89 d8                	mov    %ebx,%eax
  80244e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802451:	5b                   	pop    %ebx
  802452:	5e                   	pop    %esi
  802453:	5d                   	pop    %ebp
  802454:	c3                   	ret    

00802455 <pipeisclosed>:
{
  802455:	55                   	push   %ebp
  802456:	89 e5                	mov    %esp,%ebp
  802458:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80245b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80245e:	50                   	push   %eax
  80245f:	ff 75 08             	pushl  0x8(%ebp)
  802462:	e8 a5 ef ff ff       	call   80140c <fd_lookup>
  802467:	83 c4 10             	add    $0x10,%esp
  80246a:	85 c0                	test   %eax,%eax
  80246c:	78 18                	js     802486 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80246e:	83 ec 0c             	sub    $0xc,%esp
  802471:	ff 75 f4             	pushl  -0xc(%ebp)
  802474:	e8 2a ef ff ff       	call   8013a3 <fd2data>
	return _pipeisclosed(fd, p);
  802479:	89 c2                	mov    %eax,%edx
  80247b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247e:	e8 2f fd ff ff       	call   8021b2 <_pipeisclosed>
  802483:	83 c4 10             	add    $0x10,%esp
}
  802486:	c9                   	leave  
  802487:	c3                   	ret    

00802488 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802488:	55                   	push   %ebp
  802489:	89 e5                	mov    %esp,%ebp
  80248b:	56                   	push   %esi
  80248c:	53                   	push   %ebx
  80248d:	8b 75 08             	mov    0x8(%ebp),%esi
  802490:	8b 45 0c             	mov    0xc(%ebp),%eax
  802493:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802496:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802498:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80249d:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8024a0:	83 ec 0c             	sub    $0xc,%esp
  8024a3:	50                   	push   %eax
  8024a4:	e8 a5 ed ff ff       	call   80124e <sys_ipc_recv>
	if(ret < 0){
  8024a9:	83 c4 10             	add    $0x10,%esp
  8024ac:	85 c0                	test   %eax,%eax
  8024ae:	78 2b                	js     8024db <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8024b0:	85 f6                	test   %esi,%esi
  8024b2:	74 0a                	je     8024be <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8024b4:	a1 08 44 80 00       	mov    0x804408,%eax
  8024b9:	8b 40 74             	mov    0x74(%eax),%eax
  8024bc:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8024be:	85 db                	test   %ebx,%ebx
  8024c0:	74 0a                	je     8024cc <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8024c2:	a1 08 44 80 00       	mov    0x804408,%eax
  8024c7:	8b 40 78             	mov    0x78(%eax),%eax
  8024ca:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8024cc:	a1 08 44 80 00       	mov    0x804408,%eax
  8024d1:	8b 40 70             	mov    0x70(%eax),%eax
}
  8024d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024d7:	5b                   	pop    %ebx
  8024d8:	5e                   	pop    %esi
  8024d9:	5d                   	pop    %ebp
  8024da:	c3                   	ret    
		if(from_env_store)
  8024db:	85 f6                	test   %esi,%esi
  8024dd:	74 06                	je     8024e5 <ipc_recv+0x5d>
			*from_env_store = 0;
  8024df:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8024e5:	85 db                	test   %ebx,%ebx
  8024e7:	74 eb                	je     8024d4 <ipc_recv+0x4c>
			*perm_store = 0;
  8024e9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8024ef:	eb e3                	jmp    8024d4 <ipc_recv+0x4c>

008024f1 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8024f1:	55                   	push   %ebp
  8024f2:	89 e5                	mov    %esp,%ebp
  8024f4:	57                   	push   %edi
  8024f5:	56                   	push   %esi
  8024f6:	53                   	push   %ebx
  8024f7:	83 ec 0c             	sub    $0xc,%esp
  8024fa:	8b 7d 08             	mov    0x8(%ebp),%edi
  8024fd:	8b 75 0c             	mov    0xc(%ebp),%esi
  802500:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802503:	85 db                	test   %ebx,%ebx
  802505:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80250a:	0f 44 d8             	cmove  %eax,%ebx
  80250d:	eb 05                	jmp    802514 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80250f:	e8 6b eb ff ff       	call   80107f <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802514:	ff 75 14             	pushl  0x14(%ebp)
  802517:	53                   	push   %ebx
  802518:	56                   	push   %esi
  802519:	57                   	push   %edi
  80251a:	e8 0c ed ff ff       	call   80122b <sys_ipc_try_send>
  80251f:	83 c4 10             	add    $0x10,%esp
  802522:	85 c0                	test   %eax,%eax
  802524:	74 1b                	je     802541 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802526:	79 e7                	jns    80250f <ipc_send+0x1e>
  802528:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80252b:	74 e2                	je     80250f <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80252d:	83 ec 04             	sub    $0x4,%esp
  802530:	68 03 2e 80 00       	push   $0x802e03
  802535:	6a 46                	push   $0x46
  802537:	68 18 2e 80 00       	push   $0x802e18
  80253c:	e8 26 de ff ff       	call   800367 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802541:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802544:	5b                   	pop    %ebx
  802545:	5e                   	pop    %esi
  802546:	5f                   	pop    %edi
  802547:	5d                   	pop    %ebp
  802548:	c3                   	ret    

00802549 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802549:	55                   	push   %ebp
  80254a:	89 e5                	mov    %esp,%ebp
  80254c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80254f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802554:	89 c2                	mov    %eax,%edx
  802556:	c1 e2 07             	shl    $0x7,%edx
  802559:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80255f:	8b 52 50             	mov    0x50(%edx),%edx
  802562:	39 ca                	cmp    %ecx,%edx
  802564:	74 11                	je     802577 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802566:	83 c0 01             	add    $0x1,%eax
  802569:	3d 00 04 00 00       	cmp    $0x400,%eax
  80256e:	75 e4                	jne    802554 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802570:	b8 00 00 00 00       	mov    $0x0,%eax
  802575:	eb 0b                	jmp    802582 <ipc_find_env+0x39>
			return envs[i].env_id;
  802577:	c1 e0 07             	shl    $0x7,%eax
  80257a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80257f:	8b 40 48             	mov    0x48(%eax),%eax
}
  802582:	5d                   	pop    %ebp
  802583:	c3                   	ret    

00802584 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802584:	55                   	push   %ebp
  802585:	89 e5                	mov    %esp,%ebp
  802587:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80258a:	89 d0                	mov    %edx,%eax
  80258c:	c1 e8 16             	shr    $0x16,%eax
  80258f:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802596:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80259b:	f6 c1 01             	test   $0x1,%cl
  80259e:	74 1d                	je     8025bd <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8025a0:	c1 ea 0c             	shr    $0xc,%edx
  8025a3:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8025aa:	f6 c2 01             	test   $0x1,%dl
  8025ad:	74 0e                	je     8025bd <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8025af:	c1 ea 0c             	shr    $0xc,%edx
  8025b2:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8025b9:	ef 
  8025ba:	0f b7 c0             	movzwl %ax,%eax
}
  8025bd:	5d                   	pop    %ebp
  8025be:	c3                   	ret    
  8025bf:	90                   	nop

008025c0 <__udivdi3>:
  8025c0:	55                   	push   %ebp
  8025c1:	57                   	push   %edi
  8025c2:	56                   	push   %esi
  8025c3:	53                   	push   %ebx
  8025c4:	83 ec 1c             	sub    $0x1c,%esp
  8025c7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8025cb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8025cf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8025d3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8025d7:	85 d2                	test   %edx,%edx
  8025d9:	75 4d                	jne    802628 <__udivdi3+0x68>
  8025db:	39 f3                	cmp    %esi,%ebx
  8025dd:	76 19                	jbe    8025f8 <__udivdi3+0x38>
  8025df:	31 ff                	xor    %edi,%edi
  8025e1:	89 e8                	mov    %ebp,%eax
  8025e3:	89 f2                	mov    %esi,%edx
  8025e5:	f7 f3                	div    %ebx
  8025e7:	89 fa                	mov    %edi,%edx
  8025e9:	83 c4 1c             	add    $0x1c,%esp
  8025ec:	5b                   	pop    %ebx
  8025ed:	5e                   	pop    %esi
  8025ee:	5f                   	pop    %edi
  8025ef:	5d                   	pop    %ebp
  8025f0:	c3                   	ret    
  8025f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025f8:	89 d9                	mov    %ebx,%ecx
  8025fa:	85 db                	test   %ebx,%ebx
  8025fc:	75 0b                	jne    802609 <__udivdi3+0x49>
  8025fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802603:	31 d2                	xor    %edx,%edx
  802605:	f7 f3                	div    %ebx
  802607:	89 c1                	mov    %eax,%ecx
  802609:	31 d2                	xor    %edx,%edx
  80260b:	89 f0                	mov    %esi,%eax
  80260d:	f7 f1                	div    %ecx
  80260f:	89 c6                	mov    %eax,%esi
  802611:	89 e8                	mov    %ebp,%eax
  802613:	89 f7                	mov    %esi,%edi
  802615:	f7 f1                	div    %ecx
  802617:	89 fa                	mov    %edi,%edx
  802619:	83 c4 1c             	add    $0x1c,%esp
  80261c:	5b                   	pop    %ebx
  80261d:	5e                   	pop    %esi
  80261e:	5f                   	pop    %edi
  80261f:	5d                   	pop    %ebp
  802620:	c3                   	ret    
  802621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802628:	39 f2                	cmp    %esi,%edx
  80262a:	77 1c                	ja     802648 <__udivdi3+0x88>
  80262c:	0f bd fa             	bsr    %edx,%edi
  80262f:	83 f7 1f             	xor    $0x1f,%edi
  802632:	75 2c                	jne    802660 <__udivdi3+0xa0>
  802634:	39 f2                	cmp    %esi,%edx
  802636:	72 06                	jb     80263e <__udivdi3+0x7e>
  802638:	31 c0                	xor    %eax,%eax
  80263a:	39 eb                	cmp    %ebp,%ebx
  80263c:	77 a9                	ja     8025e7 <__udivdi3+0x27>
  80263e:	b8 01 00 00 00       	mov    $0x1,%eax
  802643:	eb a2                	jmp    8025e7 <__udivdi3+0x27>
  802645:	8d 76 00             	lea    0x0(%esi),%esi
  802648:	31 ff                	xor    %edi,%edi
  80264a:	31 c0                	xor    %eax,%eax
  80264c:	89 fa                	mov    %edi,%edx
  80264e:	83 c4 1c             	add    $0x1c,%esp
  802651:	5b                   	pop    %ebx
  802652:	5e                   	pop    %esi
  802653:	5f                   	pop    %edi
  802654:	5d                   	pop    %ebp
  802655:	c3                   	ret    
  802656:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80265d:	8d 76 00             	lea    0x0(%esi),%esi
  802660:	89 f9                	mov    %edi,%ecx
  802662:	b8 20 00 00 00       	mov    $0x20,%eax
  802667:	29 f8                	sub    %edi,%eax
  802669:	d3 e2                	shl    %cl,%edx
  80266b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80266f:	89 c1                	mov    %eax,%ecx
  802671:	89 da                	mov    %ebx,%edx
  802673:	d3 ea                	shr    %cl,%edx
  802675:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802679:	09 d1                	or     %edx,%ecx
  80267b:	89 f2                	mov    %esi,%edx
  80267d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802681:	89 f9                	mov    %edi,%ecx
  802683:	d3 e3                	shl    %cl,%ebx
  802685:	89 c1                	mov    %eax,%ecx
  802687:	d3 ea                	shr    %cl,%edx
  802689:	89 f9                	mov    %edi,%ecx
  80268b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80268f:	89 eb                	mov    %ebp,%ebx
  802691:	d3 e6                	shl    %cl,%esi
  802693:	89 c1                	mov    %eax,%ecx
  802695:	d3 eb                	shr    %cl,%ebx
  802697:	09 de                	or     %ebx,%esi
  802699:	89 f0                	mov    %esi,%eax
  80269b:	f7 74 24 08          	divl   0x8(%esp)
  80269f:	89 d6                	mov    %edx,%esi
  8026a1:	89 c3                	mov    %eax,%ebx
  8026a3:	f7 64 24 0c          	mull   0xc(%esp)
  8026a7:	39 d6                	cmp    %edx,%esi
  8026a9:	72 15                	jb     8026c0 <__udivdi3+0x100>
  8026ab:	89 f9                	mov    %edi,%ecx
  8026ad:	d3 e5                	shl    %cl,%ebp
  8026af:	39 c5                	cmp    %eax,%ebp
  8026b1:	73 04                	jae    8026b7 <__udivdi3+0xf7>
  8026b3:	39 d6                	cmp    %edx,%esi
  8026b5:	74 09                	je     8026c0 <__udivdi3+0x100>
  8026b7:	89 d8                	mov    %ebx,%eax
  8026b9:	31 ff                	xor    %edi,%edi
  8026bb:	e9 27 ff ff ff       	jmp    8025e7 <__udivdi3+0x27>
  8026c0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8026c3:	31 ff                	xor    %edi,%edi
  8026c5:	e9 1d ff ff ff       	jmp    8025e7 <__udivdi3+0x27>
  8026ca:	66 90                	xchg   %ax,%ax
  8026cc:	66 90                	xchg   %ax,%ax
  8026ce:	66 90                	xchg   %ax,%ax

008026d0 <__umoddi3>:
  8026d0:	55                   	push   %ebp
  8026d1:	57                   	push   %edi
  8026d2:	56                   	push   %esi
  8026d3:	53                   	push   %ebx
  8026d4:	83 ec 1c             	sub    $0x1c,%esp
  8026d7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8026db:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8026df:	8b 74 24 30          	mov    0x30(%esp),%esi
  8026e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8026e7:	89 da                	mov    %ebx,%edx
  8026e9:	85 c0                	test   %eax,%eax
  8026eb:	75 43                	jne    802730 <__umoddi3+0x60>
  8026ed:	39 df                	cmp    %ebx,%edi
  8026ef:	76 17                	jbe    802708 <__umoddi3+0x38>
  8026f1:	89 f0                	mov    %esi,%eax
  8026f3:	f7 f7                	div    %edi
  8026f5:	89 d0                	mov    %edx,%eax
  8026f7:	31 d2                	xor    %edx,%edx
  8026f9:	83 c4 1c             	add    $0x1c,%esp
  8026fc:	5b                   	pop    %ebx
  8026fd:	5e                   	pop    %esi
  8026fe:	5f                   	pop    %edi
  8026ff:	5d                   	pop    %ebp
  802700:	c3                   	ret    
  802701:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802708:	89 fd                	mov    %edi,%ebp
  80270a:	85 ff                	test   %edi,%edi
  80270c:	75 0b                	jne    802719 <__umoddi3+0x49>
  80270e:	b8 01 00 00 00       	mov    $0x1,%eax
  802713:	31 d2                	xor    %edx,%edx
  802715:	f7 f7                	div    %edi
  802717:	89 c5                	mov    %eax,%ebp
  802719:	89 d8                	mov    %ebx,%eax
  80271b:	31 d2                	xor    %edx,%edx
  80271d:	f7 f5                	div    %ebp
  80271f:	89 f0                	mov    %esi,%eax
  802721:	f7 f5                	div    %ebp
  802723:	89 d0                	mov    %edx,%eax
  802725:	eb d0                	jmp    8026f7 <__umoddi3+0x27>
  802727:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80272e:	66 90                	xchg   %ax,%ax
  802730:	89 f1                	mov    %esi,%ecx
  802732:	39 d8                	cmp    %ebx,%eax
  802734:	76 0a                	jbe    802740 <__umoddi3+0x70>
  802736:	89 f0                	mov    %esi,%eax
  802738:	83 c4 1c             	add    $0x1c,%esp
  80273b:	5b                   	pop    %ebx
  80273c:	5e                   	pop    %esi
  80273d:	5f                   	pop    %edi
  80273e:	5d                   	pop    %ebp
  80273f:	c3                   	ret    
  802740:	0f bd e8             	bsr    %eax,%ebp
  802743:	83 f5 1f             	xor    $0x1f,%ebp
  802746:	75 20                	jne    802768 <__umoddi3+0x98>
  802748:	39 d8                	cmp    %ebx,%eax
  80274a:	0f 82 b0 00 00 00    	jb     802800 <__umoddi3+0x130>
  802750:	39 f7                	cmp    %esi,%edi
  802752:	0f 86 a8 00 00 00    	jbe    802800 <__umoddi3+0x130>
  802758:	89 c8                	mov    %ecx,%eax
  80275a:	83 c4 1c             	add    $0x1c,%esp
  80275d:	5b                   	pop    %ebx
  80275e:	5e                   	pop    %esi
  80275f:	5f                   	pop    %edi
  802760:	5d                   	pop    %ebp
  802761:	c3                   	ret    
  802762:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802768:	89 e9                	mov    %ebp,%ecx
  80276a:	ba 20 00 00 00       	mov    $0x20,%edx
  80276f:	29 ea                	sub    %ebp,%edx
  802771:	d3 e0                	shl    %cl,%eax
  802773:	89 44 24 08          	mov    %eax,0x8(%esp)
  802777:	89 d1                	mov    %edx,%ecx
  802779:	89 f8                	mov    %edi,%eax
  80277b:	d3 e8                	shr    %cl,%eax
  80277d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802781:	89 54 24 04          	mov    %edx,0x4(%esp)
  802785:	8b 54 24 04          	mov    0x4(%esp),%edx
  802789:	09 c1                	or     %eax,%ecx
  80278b:	89 d8                	mov    %ebx,%eax
  80278d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802791:	89 e9                	mov    %ebp,%ecx
  802793:	d3 e7                	shl    %cl,%edi
  802795:	89 d1                	mov    %edx,%ecx
  802797:	d3 e8                	shr    %cl,%eax
  802799:	89 e9                	mov    %ebp,%ecx
  80279b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80279f:	d3 e3                	shl    %cl,%ebx
  8027a1:	89 c7                	mov    %eax,%edi
  8027a3:	89 d1                	mov    %edx,%ecx
  8027a5:	89 f0                	mov    %esi,%eax
  8027a7:	d3 e8                	shr    %cl,%eax
  8027a9:	89 e9                	mov    %ebp,%ecx
  8027ab:	89 fa                	mov    %edi,%edx
  8027ad:	d3 e6                	shl    %cl,%esi
  8027af:	09 d8                	or     %ebx,%eax
  8027b1:	f7 74 24 08          	divl   0x8(%esp)
  8027b5:	89 d1                	mov    %edx,%ecx
  8027b7:	89 f3                	mov    %esi,%ebx
  8027b9:	f7 64 24 0c          	mull   0xc(%esp)
  8027bd:	89 c6                	mov    %eax,%esi
  8027bf:	89 d7                	mov    %edx,%edi
  8027c1:	39 d1                	cmp    %edx,%ecx
  8027c3:	72 06                	jb     8027cb <__umoddi3+0xfb>
  8027c5:	75 10                	jne    8027d7 <__umoddi3+0x107>
  8027c7:	39 c3                	cmp    %eax,%ebx
  8027c9:	73 0c                	jae    8027d7 <__umoddi3+0x107>
  8027cb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8027cf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8027d3:	89 d7                	mov    %edx,%edi
  8027d5:	89 c6                	mov    %eax,%esi
  8027d7:	89 ca                	mov    %ecx,%edx
  8027d9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8027de:	29 f3                	sub    %esi,%ebx
  8027e0:	19 fa                	sbb    %edi,%edx
  8027e2:	89 d0                	mov    %edx,%eax
  8027e4:	d3 e0                	shl    %cl,%eax
  8027e6:	89 e9                	mov    %ebp,%ecx
  8027e8:	d3 eb                	shr    %cl,%ebx
  8027ea:	d3 ea                	shr    %cl,%edx
  8027ec:	09 d8                	or     %ebx,%eax
  8027ee:	83 c4 1c             	add    $0x1c,%esp
  8027f1:	5b                   	pop    %ebx
  8027f2:	5e                   	pop    %esi
  8027f3:	5f                   	pop    %edi
  8027f4:	5d                   	pop    %ebp
  8027f5:	c3                   	ret    
  8027f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027fd:	8d 76 00             	lea    0x0(%esi),%esi
  802800:	89 da                	mov    %ebx,%edx
  802802:	29 fe                	sub    %edi,%esi
  802804:	19 c2                	sbb    %eax,%edx
  802806:	89 f1                	mov    %esi,%ecx
  802808:	89 c8                	mov    %ecx,%eax
  80280a:	e9 4b ff ff ff       	jmp    80275a <__umoddi3+0x8a>
