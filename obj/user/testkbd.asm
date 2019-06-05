
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
  80004e:	e8 cb 14 00 00       	call   80151e <close>
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
  800062:	68 1c 28 80 00       	push   $0x80281c
  800067:	6a 11                	push   $0x11
  800069:	68 0d 28 80 00       	push   $0x80280d
  80006e:	e8 f4 02 00 00       	call   800367 <_panic>
		panic("opencons: %e", r);
  800073:	50                   	push   %eax
  800074:	68 00 28 80 00       	push   $0x802800
  800079:	6a 0f                	push   $0xf
  80007b:	68 0d 28 80 00       	push   $0x80280d
  800080:	e8 e2 02 00 00       	call   800367 <_panic>
	if ((r = dup(0, 1)) < 0)
  800085:	83 ec 08             	sub    $0x8,%esp
  800088:	6a 01                	push   $0x1
  80008a:	6a 00                	push   $0x0
  80008c:	e8 df 14 00 00       	call   801570 <dup>
  800091:	83 c4 10             	add    $0x10,%esp
  800094:	85 c0                	test   %eax,%eax
  800096:	79 24                	jns    8000bc <umain+0x89>
		panic("dup: %e", r);
  800098:	50                   	push   %eax
  800099:	68 36 28 80 00       	push   $0x802836
  80009e:	6a 13                	push   $0x13
  8000a0:	68 0d 28 80 00       	push   $0x80280d
  8000a5:	e8 bd 02 00 00       	call   800367 <_panic>

		buf = readline("Type a line: ");
		if (buf != NULL)
			fprintf(1, "%s\n", buf);
		else
			fprintf(1, "(end of file received)\n");
  8000aa:	83 ec 08             	sub    $0x8,%esp
  8000ad:	68 4c 28 80 00       	push   $0x80284c
  8000b2:	6a 01                	push   $0x1
  8000b4:	e8 cd 1b 00 00       	call   801c86 <fprintf>
  8000b9:	83 c4 10             	add    $0x10,%esp
		buf = readline("Type a line: ");
  8000bc:	83 ec 0c             	sub    $0xc,%esp
  8000bf:	68 3e 28 80 00       	push   $0x80283e
  8000c4:	e8 ba 0a 00 00       	call   800b83 <readline>
		if (buf != NULL)
  8000c9:	83 c4 10             	add    $0x10,%esp
  8000cc:	85 c0                	test   %eax,%eax
  8000ce:	74 da                	je     8000aa <umain+0x77>
			fprintf(1, "%s\n", buf);
  8000d0:	83 ec 04             	sub    $0x4,%esp
  8000d3:	50                   	push   %eax
  8000d4:	68 cf 28 80 00       	push   $0x8028cf
  8000d9:	6a 01                	push   $0x1
  8000db:	e8 a6 1b 00 00       	call   801c86 <fprintf>
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
  8000f1:	68 64 28 80 00       	push   $0x802864
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
  8001c1:	e8 96 14 00 00       	call   80165c <read>
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
  8001e9:	e8 fe 11 00 00       	call   8013ec <fd_lookup>
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
  800212:	e8 83 11 00 00       	call   80139a <fd_alloc>
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
  800250:	e8 1e 11 00 00       	call   801373 <fd2num>
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
  8002dd:	68 70 28 80 00       	push   $0x802870
  8002e2:	e8 76 01 00 00       	call   80045d <cprintf>
	cprintf("before umain\n");
  8002e7:	c7 04 24 8e 28 80 00 	movl   $0x80288e,(%esp)
  8002ee:	e8 6a 01 00 00       	call   80045d <cprintf>
	// call user main routine
	umain(argc, argv);
  8002f3:	83 c4 08             	add    $0x8,%esp
  8002f6:	ff 75 0c             	pushl  0xc(%ebp)
  8002f9:	ff 75 08             	pushl  0x8(%ebp)
  8002fc:	e8 32 fd ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  800301:	c7 04 24 9c 28 80 00 	movl   $0x80289c,(%esp)
  800308:	e8 50 01 00 00       	call   80045d <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  80030d:	a1 08 44 80 00       	mov    0x804408,%eax
  800312:	8b 40 48             	mov    0x48(%eax),%eax
  800315:	83 c4 08             	add    $0x8,%esp
  800318:	50                   	push   %eax
  800319:	68 a9 28 80 00       	push   $0x8028a9
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
  800341:	68 d4 28 80 00       	push   $0x8028d4
  800346:	50                   	push   %eax
  800347:	68 c8 28 80 00       	push   $0x8028c8
  80034c:	e8 0c 01 00 00       	call   80045d <cprintf>
	close_all();
  800351:	e8 f5 11 00 00       	call   80154b <close_all>
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
  800377:	68 00 29 80 00       	push   $0x802900
  80037c:	50                   	push   %eax
  80037d:	68 c8 28 80 00       	push   $0x8028c8
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
  8003a0:	68 dc 28 80 00       	push   $0x8028dc
  8003a5:	e8 b3 00 00 00       	call   80045d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003aa:	83 c4 18             	add    $0x18,%esp
  8003ad:	53                   	push   %ebx
  8003ae:	ff 75 10             	pushl  0x10(%ebp)
  8003b1:	e8 56 00 00 00       	call   80040c <vcprintf>
	cprintf("\n");
  8003b6:	c7 04 24 8c 28 80 00 	movl   $0x80288c,(%esp)
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
  80050a:	e8 91 20 00 00       	call   8025a0 <__udivdi3>
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
  800533:	e8 78 21 00 00       	call   8026b0 <__umoddi3>
  800538:	83 c4 14             	add    $0x14,%esp
  80053b:	0f be 80 07 29 80 00 	movsbl 0x802907(%eax),%eax
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
  8005e4:	ff 24 85 e0 2a 80 00 	jmp    *0x802ae0(,%eax,4)
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
  8006af:	8b 14 85 40 2c 80 00 	mov    0x802c40(,%eax,4),%edx
  8006b6:	85 d2                	test   %edx,%edx
  8006b8:	74 18                	je     8006d2 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8006ba:	52                   	push   %edx
  8006bb:	68 71 2d 80 00       	push   $0x802d71
  8006c0:	53                   	push   %ebx
  8006c1:	56                   	push   %esi
  8006c2:	e8 a6 fe ff ff       	call   80056d <printfmt>
  8006c7:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8006ca:	89 7d 14             	mov    %edi,0x14(%ebp)
  8006cd:	e9 fe 02 00 00       	jmp    8009d0 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8006d2:	50                   	push   %eax
  8006d3:	68 1f 29 80 00       	push   $0x80291f
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
  8006fa:	b8 18 29 80 00       	mov    $0x802918,%eax
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
  800a92:	bf 3d 2a 80 00       	mov    $0x802a3d,%edi
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
  800abe:	bf 75 2a 80 00       	mov    $0x802a75,%edi
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
  800b97:	68 71 2d 80 00       	push   $0x802d71
  800b9c:	6a 01                	push   $0x1
  800b9e:	e8 e3 10 00 00       	call   801c86 <fprintf>
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
  800bd2:	68 88 2c 80 00       	push   $0x802c88
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
  80104f:	68 98 2c 80 00       	push   $0x802c98
  801054:	6a 43                	push   $0x43
  801056:	68 b5 2c 80 00       	push   $0x802cb5
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
  8010d0:	68 98 2c 80 00       	push   $0x802c98
  8010d5:	6a 43                	push   $0x43
  8010d7:	68 b5 2c 80 00       	push   $0x802cb5
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
  801112:	68 98 2c 80 00       	push   $0x802c98
  801117:	6a 43                	push   $0x43
  801119:	68 b5 2c 80 00       	push   $0x802cb5
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
  801154:	68 98 2c 80 00       	push   $0x802c98
  801159:	6a 43                	push   $0x43
  80115b:	68 b5 2c 80 00       	push   $0x802cb5
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
  801196:	68 98 2c 80 00       	push   $0x802c98
  80119b:	6a 43                	push   $0x43
  80119d:	68 b5 2c 80 00       	push   $0x802cb5
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
  8011d8:	68 98 2c 80 00       	push   $0x802c98
  8011dd:	6a 43                	push   $0x43
  8011df:	68 b5 2c 80 00       	push   $0x802cb5
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
  80121a:	68 98 2c 80 00       	push   $0x802c98
  80121f:	6a 43                	push   $0x43
  801221:	68 b5 2c 80 00       	push   $0x802cb5
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
  80127e:	68 98 2c 80 00       	push   $0x802c98
  801283:	6a 43                	push   $0x43
  801285:	68 b5 2c 80 00       	push   $0x802cb5
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
  801362:	68 98 2c 80 00       	push   $0x802c98
  801367:	6a 43                	push   $0x43
  801369:	68 b5 2c 80 00       	push   $0x802cb5
  80136e:	e8 f4 ef ff ff       	call   800367 <_panic>

00801373 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801373:	55                   	push   %ebp
  801374:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801376:	8b 45 08             	mov    0x8(%ebp),%eax
  801379:	05 00 00 00 30       	add    $0x30000000,%eax
  80137e:	c1 e8 0c             	shr    $0xc,%eax
}
  801381:	5d                   	pop    %ebp
  801382:	c3                   	ret    

00801383 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801383:	55                   	push   %ebp
  801384:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801386:	8b 45 08             	mov    0x8(%ebp),%eax
  801389:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80138e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801393:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801398:	5d                   	pop    %ebp
  801399:	c3                   	ret    

0080139a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80139a:	55                   	push   %ebp
  80139b:	89 e5                	mov    %esp,%ebp
  80139d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8013a2:	89 c2                	mov    %eax,%edx
  8013a4:	c1 ea 16             	shr    $0x16,%edx
  8013a7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013ae:	f6 c2 01             	test   $0x1,%dl
  8013b1:	74 2d                	je     8013e0 <fd_alloc+0x46>
  8013b3:	89 c2                	mov    %eax,%edx
  8013b5:	c1 ea 0c             	shr    $0xc,%edx
  8013b8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013bf:	f6 c2 01             	test   $0x1,%dl
  8013c2:	74 1c                	je     8013e0 <fd_alloc+0x46>
  8013c4:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8013c9:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8013ce:	75 d2                	jne    8013a2 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8013d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8013d9:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8013de:	eb 0a                	jmp    8013ea <fd_alloc+0x50>
			*fd_store = fd;
  8013e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013e3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013ea:	5d                   	pop    %ebp
  8013eb:	c3                   	ret    

008013ec <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8013ec:	55                   	push   %ebp
  8013ed:	89 e5                	mov    %esp,%ebp
  8013ef:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8013f2:	83 f8 1f             	cmp    $0x1f,%eax
  8013f5:	77 30                	ja     801427 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8013f7:	c1 e0 0c             	shl    $0xc,%eax
  8013fa:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8013ff:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801405:	f6 c2 01             	test   $0x1,%dl
  801408:	74 24                	je     80142e <fd_lookup+0x42>
  80140a:	89 c2                	mov    %eax,%edx
  80140c:	c1 ea 0c             	shr    $0xc,%edx
  80140f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801416:	f6 c2 01             	test   $0x1,%dl
  801419:	74 1a                	je     801435 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80141b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80141e:	89 02                	mov    %eax,(%edx)
	return 0;
  801420:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801425:	5d                   	pop    %ebp
  801426:	c3                   	ret    
		return -E_INVAL;
  801427:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80142c:	eb f7                	jmp    801425 <fd_lookup+0x39>
		return -E_INVAL;
  80142e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801433:	eb f0                	jmp    801425 <fd_lookup+0x39>
  801435:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80143a:	eb e9                	jmp    801425 <fd_lookup+0x39>

0080143c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80143c:	55                   	push   %ebp
  80143d:	89 e5                	mov    %esp,%ebp
  80143f:	83 ec 08             	sub    $0x8,%esp
  801442:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801445:	ba 00 00 00 00       	mov    $0x0,%edx
  80144a:	b8 20 30 80 00       	mov    $0x803020,%eax
		if (devtab[i]->dev_id == dev_id) {
  80144f:	39 08                	cmp    %ecx,(%eax)
  801451:	74 38                	je     80148b <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801453:	83 c2 01             	add    $0x1,%edx
  801456:	8b 04 95 44 2d 80 00 	mov    0x802d44(,%edx,4),%eax
  80145d:	85 c0                	test   %eax,%eax
  80145f:	75 ee                	jne    80144f <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801461:	a1 08 44 80 00       	mov    0x804408,%eax
  801466:	8b 40 48             	mov    0x48(%eax),%eax
  801469:	83 ec 04             	sub    $0x4,%esp
  80146c:	51                   	push   %ecx
  80146d:	50                   	push   %eax
  80146e:	68 c4 2c 80 00       	push   $0x802cc4
  801473:	e8 e5 ef ff ff       	call   80045d <cprintf>
	*dev = 0;
  801478:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801481:	83 c4 10             	add    $0x10,%esp
  801484:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801489:	c9                   	leave  
  80148a:	c3                   	ret    
			*dev = devtab[i];
  80148b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80148e:	89 01                	mov    %eax,(%ecx)
			return 0;
  801490:	b8 00 00 00 00       	mov    $0x0,%eax
  801495:	eb f2                	jmp    801489 <dev_lookup+0x4d>

00801497 <fd_close>:
{
  801497:	55                   	push   %ebp
  801498:	89 e5                	mov    %esp,%ebp
  80149a:	57                   	push   %edi
  80149b:	56                   	push   %esi
  80149c:	53                   	push   %ebx
  80149d:	83 ec 24             	sub    $0x24,%esp
  8014a0:	8b 75 08             	mov    0x8(%ebp),%esi
  8014a3:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014a6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014a9:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014aa:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8014b0:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014b3:	50                   	push   %eax
  8014b4:	e8 33 ff ff ff       	call   8013ec <fd_lookup>
  8014b9:	89 c3                	mov    %eax,%ebx
  8014bb:	83 c4 10             	add    $0x10,%esp
  8014be:	85 c0                	test   %eax,%eax
  8014c0:	78 05                	js     8014c7 <fd_close+0x30>
	    || fd != fd2)
  8014c2:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8014c5:	74 16                	je     8014dd <fd_close+0x46>
		return (must_exist ? r : 0);
  8014c7:	89 f8                	mov    %edi,%eax
  8014c9:	84 c0                	test   %al,%al
  8014cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d0:	0f 44 d8             	cmove  %eax,%ebx
}
  8014d3:	89 d8                	mov    %ebx,%eax
  8014d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014d8:	5b                   	pop    %ebx
  8014d9:	5e                   	pop    %esi
  8014da:	5f                   	pop    %edi
  8014db:	5d                   	pop    %ebp
  8014dc:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8014dd:	83 ec 08             	sub    $0x8,%esp
  8014e0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8014e3:	50                   	push   %eax
  8014e4:	ff 36                	pushl  (%esi)
  8014e6:	e8 51 ff ff ff       	call   80143c <dev_lookup>
  8014eb:	89 c3                	mov    %eax,%ebx
  8014ed:	83 c4 10             	add    $0x10,%esp
  8014f0:	85 c0                	test   %eax,%eax
  8014f2:	78 1a                	js     80150e <fd_close+0x77>
		if (dev->dev_close)
  8014f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014f7:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8014fa:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8014ff:	85 c0                	test   %eax,%eax
  801501:	74 0b                	je     80150e <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801503:	83 ec 0c             	sub    $0xc,%esp
  801506:	56                   	push   %esi
  801507:	ff d0                	call   *%eax
  801509:	89 c3                	mov    %eax,%ebx
  80150b:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80150e:	83 ec 08             	sub    $0x8,%esp
  801511:	56                   	push   %esi
  801512:	6a 00                	push   $0x0
  801514:	e8 0a fc ff ff       	call   801123 <sys_page_unmap>
	return r;
  801519:	83 c4 10             	add    $0x10,%esp
  80151c:	eb b5                	jmp    8014d3 <fd_close+0x3c>

0080151e <close>:

int
close(int fdnum)
{
  80151e:	55                   	push   %ebp
  80151f:	89 e5                	mov    %esp,%ebp
  801521:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801524:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801527:	50                   	push   %eax
  801528:	ff 75 08             	pushl  0x8(%ebp)
  80152b:	e8 bc fe ff ff       	call   8013ec <fd_lookup>
  801530:	83 c4 10             	add    $0x10,%esp
  801533:	85 c0                	test   %eax,%eax
  801535:	79 02                	jns    801539 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801537:	c9                   	leave  
  801538:	c3                   	ret    
		return fd_close(fd, 1);
  801539:	83 ec 08             	sub    $0x8,%esp
  80153c:	6a 01                	push   $0x1
  80153e:	ff 75 f4             	pushl  -0xc(%ebp)
  801541:	e8 51 ff ff ff       	call   801497 <fd_close>
  801546:	83 c4 10             	add    $0x10,%esp
  801549:	eb ec                	jmp    801537 <close+0x19>

0080154b <close_all>:

void
close_all(void)
{
  80154b:	55                   	push   %ebp
  80154c:	89 e5                	mov    %esp,%ebp
  80154e:	53                   	push   %ebx
  80154f:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801552:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801557:	83 ec 0c             	sub    $0xc,%esp
  80155a:	53                   	push   %ebx
  80155b:	e8 be ff ff ff       	call   80151e <close>
	for (i = 0; i < MAXFD; i++)
  801560:	83 c3 01             	add    $0x1,%ebx
  801563:	83 c4 10             	add    $0x10,%esp
  801566:	83 fb 20             	cmp    $0x20,%ebx
  801569:	75 ec                	jne    801557 <close_all+0xc>
}
  80156b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80156e:	c9                   	leave  
  80156f:	c3                   	ret    

00801570 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801570:	55                   	push   %ebp
  801571:	89 e5                	mov    %esp,%ebp
  801573:	57                   	push   %edi
  801574:	56                   	push   %esi
  801575:	53                   	push   %ebx
  801576:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801579:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80157c:	50                   	push   %eax
  80157d:	ff 75 08             	pushl  0x8(%ebp)
  801580:	e8 67 fe ff ff       	call   8013ec <fd_lookup>
  801585:	89 c3                	mov    %eax,%ebx
  801587:	83 c4 10             	add    $0x10,%esp
  80158a:	85 c0                	test   %eax,%eax
  80158c:	0f 88 81 00 00 00    	js     801613 <dup+0xa3>
		return r;
	close(newfdnum);
  801592:	83 ec 0c             	sub    $0xc,%esp
  801595:	ff 75 0c             	pushl  0xc(%ebp)
  801598:	e8 81 ff ff ff       	call   80151e <close>

	newfd = INDEX2FD(newfdnum);
  80159d:	8b 75 0c             	mov    0xc(%ebp),%esi
  8015a0:	c1 e6 0c             	shl    $0xc,%esi
  8015a3:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8015a9:	83 c4 04             	add    $0x4,%esp
  8015ac:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015af:	e8 cf fd ff ff       	call   801383 <fd2data>
  8015b4:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8015b6:	89 34 24             	mov    %esi,(%esp)
  8015b9:	e8 c5 fd ff ff       	call   801383 <fd2data>
  8015be:	83 c4 10             	add    $0x10,%esp
  8015c1:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8015c3:	89 d8                	mov    %ebx,%eax
  8015c5:	c1 e8 16             	shr    $0x16,%eax
  8015c8:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015cf:	a8 01                	test   $0x1,%al
  8015d1:	74 11                	je     8015e4 <dup+0x74>
  8015d3:	89 d8                	mov    %ebx,%eax
  8015d5:	c1 e8 0c             	shr    $0xc,%eax
  8015d8:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8015df:	f6 c2 01             	test   $0x1,%dl
  8015e2:	75 39                	jne    80161d <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8015e4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8015e7:	89 d0                	mov    %edx,%eax
  8015e9:	c1 e8 0c             	shr    $0xc,%eax
  8015ec:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015f3:	83 ec 0c             	sub    $0xc,%esp
  8015f6:	25 07 0e 00 00       	and    $0xe07,%eax
  8015fb:	50                   	push   %eax
  8015fc:	56                   	push   %esi
  8015fd:	6a 00                	push   $0x0
  8015ff:	52                   	push   %edx
  801600:	6a 00                	push   $0x0
  801602:	e8 da fa ff ff       	call   8010e1 <sys_page_map>
  801607:	89 c3                	mov    %eax,%ebx
  801609:	83 c4 20             	add    $0x20,%esp
  80160c:	85 c0                	test   %eax,%eax
  80160e:	78 31                	js     801641 <dup+0xd1>
		goto err;

	return newfdnum;
  801610:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801613:	89 d8                	mov    %ebx,%eax
  801615:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801618:	5b                   	pop    %ebx
  801619:	5e                   	pop    %esi
  80161a:	5f                   	pop    %edi
  80161b:	5d                   	pop    %ebp
  80161c:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80161d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801624:	83 ec 0c             	sub    $0xc,%esp
  801627:	25 07 0e 00 00       	and    $0xe07,%eax
  80162c:	50                   	push   %eax
  80162d:	57                   	push   %edi
  80162e:	6a 00                	push   $0x0
  801630:	53                   	push   %ebx
  801631:	6a 00                	push   $0x0
  801633:	e8 a9 fa ff ff       	call   8010e1 <sys_page_map>
  801638:	89 c3                	mov    %eax,%ebx
  80163a:	83 c4 20             	add    $0x20,%esp
  80163d:	85 c0                	test   %eax,%eax
  80163f:	79 a3                	jns    8015e4 <dup+0x74>
	sys_page_unmap(0, newfd);
  801641:	83 ec 08             	sub    $0x8,%esp
  801644:	56                   	push   %esi
  801645:	6a 00                	push   $0x0
  801647:	e8 d7 fa ff ff       	call   801123 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80164c:	83 c4 08             	add    $0x8,%esp
  80164f:	57                   	push   %edi
  801650:	6a 00                	push   $0x0
  801652:	e8 cc fa ff ff       	call   801123 <sys_page_unmap>
	return r;
  801657:	83 c4 10             	add    $0x10,%esp
  80165a:	eb b7                	jmp    801613 <dup+0xa3>

0080165c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80165c:	55                   	push   %ebp
  80165d:	89 e5                	mov    %esp,%ebp
  80165f:	53                   	push   %ebx
  801660:	83 ec 1c             	sub    $0x1c,%esp
  801663:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801666:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801669:	50                   	push   %eax
  80166a:	53                   	push   %ebx
  80166b:	e8 7c fd ff ff       	call   8013ec <fd_lookup>
  801670:	83 c4 10             	add    $0x10,%esp
  801673:	85 c0                	test   %eax,%eax
  801675:	78 3f                	js     8016b6 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801677:	83 ec 08             	sub    $0x8,%esp
  80167a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80167d:	50                   	push   %eax
  80167e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801681:	ff 30                	pushl  (%eax)
  801683:	e8 b4 fd ff ff       	call   80143c <dev_lookup>
  801688:	83 c4 10             	add    $0x10,%esp
  80168b:	85 c0                	test   %eax,%eax
  80168d:	78 27                	js     8016b6 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80168f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801692:	8b 42 08             	mov    0x8(%edx),%eax
  801695:	83 e0 03             	and    $0x3,%eax
  801698:	83 f8 01             	cmp    $0x1,%eax
  80169b:	74 1e                	je     8016bb <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80169d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a0:	8b 40 08             	mov    0x8(%eax),%eax
  8016a3:	85 c0                	test   %eax,%eax
  8016a5:	74 35                	je     8016dc <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8016a7:	83 ec 04             	sub    $0x4,%esp
  8016aa:	ff 75 10             	pushl  0x10(%ebp)
  8016ad:	ff 75 0c             	pushl  0xc(%ebp)
  8016b0:	52                   	push   %edx
  8016b1:	ff d0                	call   *%eax
  8016b3:	83 c4 10             	add    $0x10,%esp
}
  8016b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016b9:	c9                   	leave  
  8016ba:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8016bb:	a1 08 44 80 00       	mov    0x804408,%eax
  8016c0:	8b 40 48             	mov    0x48(%eax),%eax
  8016c3:	83 ec 04             	sub    $0x4,%esp
  8016c6:	53                   	push   %ebx
  8016c7:	50                   	push   %eax
  8016c8:	68 08 2d 80 00       	push   $0x802d08
  8016cd:	e8 8b ed ff ff       	call   80045d <cprintf>
		return -E_INVAL;
  8016d2:	83 c4 10             	add    $0x10,%esp
  8016d5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016da:	eb da                	jmp    8016b6 <read+0x5a>
		return -E_NOT_SUPP;
  8016dc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016e1:	eb d3                	jmp    8016b6 <read+0x5a>

008016e3 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8016e3:	55                   	push   %ebp
  8016e4:	89 e5                	mov    %esp,%ebp
  8016e6:	57                   	push   %edi
  8016e7:	56                   	push   %esi
  8016e8:	53                   	push   %ebx
  8016e9:	83 ec 0c             	sub    $0xc,%esp
  8016ec:	8b 7d 08             	mov    0x8(%ebp),%edi
  8016ef:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8016f2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016f7:	39 f3                	cmp    %esi,%ebx
  8016f9:	73 23                	jae    80171e <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016fb:	83 ec 04             	sub    $0x4,%esp
  8016fe:	89 f0                	mov    %esi,%eax
  801700:	29 d8                	sub    %ebx,%eax
  801702:	50                   	push   %eax
  801703:	89 d8                	mov    %ebx,%eax
  801705:	03 45 0c             	add    0xc(%ebp),%eax
  801708:	50                   	push   %eax
  801709:	57                   	push   %edi
  80170a:	e8 4d ff ff ff       	call   80165c <read>
		if (m < 0)
  80170f:	83 c4 10             	add    $0x10,%esp
  801712:	85 c0                	test   %eax,%eax
  801714:	78 06                	js     80171c <readn+0x39>
			return m;
		if (m == 0)
  801716:	74 06                	je     80171e <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801718:	01 c3                	add    %eax,%ebx
  80171a:	eb db                	jmp    8016f7 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80171c:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80171e:	89 d8                	mov    %ebx,%eax
  801720:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801723:	5b                   	pop    %ebx
  801724:	5e                   	pop    %esi
  801725:	5f                   	pop    %edi
  801726:	5d                   	pop    %ebp
  801727:	c3                   	ret    

00801728 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801728:	55                   	push   %ebp
  801729:	89 e5                	mov    %esp,%ebp
  80172b:	53                   	push   %ebx
  80172c:	83 ec 1c             	sub    $0x1c,%esp
  80172f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801732:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801735:	50                   	push   %eax
  801736:	53                   	push   %ebx
  801737:	e8 b0 fc ff ff       	call   8013ec <fd_lookup>
  80173c:	83 c4 10             	add    $0x10,%esp
  80173f:	85 c0                	test   %eax,%eax
  801741:	78 3a                	js     80177d <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801743:	83 ec 08             	sub    $0x8,%esp
  801746:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801749:	50                   	push   %eax
  80174a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80174d:	ff 30                	pushl  (%eax)
  80174f:	e8 e8 fc ff ff       	call   80143c <dev_lookup>
  801754:	83 c4 10             	add    $0x10,%esp
  801757:	85 c0                	test   %eax,%eax
  801759:	78 22                	js     80177d <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80175b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80175e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801762:	74 1e                	je     801782 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801764:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801767:	8b 52 0c             	mov    0xc(%edx),%edx
  80176a:	85 d2                	test   %edx,%edx
  80176c:	74 35                	je     8017a3 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80176e:	83 ec 04             	sub    $0x4,%esp
  801771:	ff 75 10             	pushl  0x10(%ebp)
  801774:	ff 75 0c             	pushl  0xc(%ebp)
  801777:	50                   	push   %eax
  801778:	ff d2                	call   *%edx
  80177a:	83 c4 10             	add    $0x10,%esp
}
  80177d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801780:	c9                   	leave  
  801781:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801782:	a1 08 44 80 00       	mov    0x804408,%eax
  801787:	8b 40 48             	mov    0x48(%eax),%eax
  80178a:	83 ec 04             	sub    $0x4,%esp
  80178d:	53                   	push   %ebx
  80178e:	50                   	push   %eax
  80178f:	68 24 2d 80 00       	push   $0x802d24
  801794:	e8 c4 ec ff ff       	call   80045d <cprintf>
		return -E_INVAL;
  801799:	83 c4 10             	add    $0x10,%esp
  80179c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017a1:	eb da                	jmp    80177d <write+0x55>
		return -E_NOT_SUPP;
  8017a3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017a8:	eb d3                	jmp    80177d <write+0x55>

008017aa <seek>:

int
seek(int fdnum, off_t offset)
{
  8017aa:	55                   	push   %ebp
  8017ab:	89 e5                	mov    %esp,%ebp
  8017ad:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017b0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017b3:	50                   	push   %eax
  8017b4:	ff 75 08             	pushl  0x8(%ebp)
  8017b7:	e8 30 fc ff ff       	call   8013ec <fd_lookup>
  8017bc:	83 c4 10             	add    $0x10,%esp
  8017bf:	85 c0                	test   %eax,%eax
  8017c1:	78 0e                	js     8017d1 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8017c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c9:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8017cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017d1:	c9                   	leave  
  8017d2:	c3                   	ret    

008017d3 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8017d3:	55                   	push   %ebp
  8017d4:	89 e5                	mov    %esp,%ebp
  8017d6:	53                   	push   %ebx
  8017d7:	83 ec 1c             	sub    $0x1c,%esp
  8017da:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017dd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017e0:	50                   	push   %eax
  8017e1:	53                   	push   %ebx
  8017e2:	e8 05 fc ff ff       	call   8013ec <fd_lookup>
  8017e7:	83 c4 10             	add    $0x10,%esp
  8017ea:	85 c0                	test   %eax,%eax
  8017ec:	78 37                	js     801825 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017ee:	83 ec 08             	sub    $0x8,%esp
  8017f1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017f4:	50                   	push   %eax
  8017f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017f8:	ff 30                	pushl  (%eax)
  8017fa:	e8 3d fc ff ff       	call   80143c <dev_lookup>
  8017ff:	83 c4 10             	add    $0x10,%esp
  801802:	85 c0                	test   %eax,%eax
  801804:	78 1f                	js     801825 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801806:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801809:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80180d:	74 1b                	je     80182a <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80180f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801812:	8b 52 18             	mov    0x18(%edx),%edx
  801815:	85 d2                	test   %edx,%edx
  801817:	74 32                	je     80184b <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801819:	83 ec 08             	sub    $0x8,%esp
  80181c:	ff 75 0c             	pushl  0xc(%ebp)
  80181f:	50                   	push   %eax
  801820:	ff d2                	call   *%edx
  801822:	83 c4 10             	add    $0x10,%esp
}
  801825:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801828:	c9                   	leave  
  801829:	c3                   	ret    
			thisenv->env_id, fdnum);
  80182a:	a1 08 44 80 00       	mov    0x804408,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80182f:	8b 40 48             	mov    0x48(%eax),%eax
  801832:	83 ec 04             	sub    $0x4,%esp
  801835:	53                   	push   %ebx
  801836:	50                   	push   %eax
  801837:	68 e4 2c 80 00       	push   $0x802ce4
  80183c:	e8 1c ec ff ff       	call   80045d <cprintf>
		return -E_INVAL;
  801841:	83 c4 10             	add    $0x10,%esp
  801844:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801849:	eb da                	jmp    801825 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80184b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801850:	eb d3                	jmp    801825 <ftruncate+0x52>

00801852 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801852:	55                   	push   %ebp
  801853:	89 e5                	mov    %esp,%ebp
  801855:	53                   	push   %ebx
  801856:	83 ec 1c             	sub    $0x1c,%esp
  801859:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80185c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80185f:	50                   	push   %eax
  801860:	ff 75 08             	pushl  0x8(%ebp)
  801863:	e8 84 fb ff ff       	call   8013ec <fd_lookup>
  801868:	83 c4 10             	add    $0x10,%esp
  80186b:	85 c0                	test   %eax,%eax
  80186d:	78 4b                	js     8018ba <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80186f:	83 ec 08             	sub    $0x8,%esp
  801872:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801875:	50                   	push   %eax
  801876:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801879:	ff 30                	pushl  (%eax)
  80187b:	e8 bc fb ff ff       	call   80143c <dev_lookup>
  801880:	83 c4 10             	add    $0x10,%esp
  801883:	85 c0                	test   %eax,%eax
  801885:	78 33                	js     8018ba <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801887:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80188a:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80188e:	74 2f                	je     8018bf <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801890:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801893:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80189a:	00 00 00 
	stat->st_isdir = 0;
  80189d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8018a4:	00 00 00 
	stat->st_dev = dev;
  8018a7:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8018ad:	83 ec 08             	sub    $0x8,%esp
  8018b0:	53                   	push   %ebx
  8018b1:	ff 75 f0             	pushl  -0x10(%ebp)
  8018b4:	ff 50 14             	call   *0x14(%eax)
  8018b7:	83 c4 10             	add    $0x10,%esp
}
  8018ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018bd:	c9                   	leave  
  8018be:	c3                   	ret    
		return -E_NOT_SUPP;
  8018bf:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018c4:	eb f4                	jmp    8018ba <fstat+0x68>

008018c6 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8018c6:	55                   	push   %ebp
  8018c7:	89 e5                	mov    %esp,%ebp
  8018c9:	56                   	push   %esi
  8018ca:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8018cb:	83 ec 08             	sub    $0x8,%esp
  8018ce:	6a 00                	push   $0x0
  8018d0:	ff 75 08             	pushl  0x8(%ebp)
  8018d3:	e8 22 02 00 00       	call   801afa <open>
  8018d8:	89 c3                	mov    %eax,%ebx
  8018da:	83 c4 10             	add    $0x10,%esp
  8018dd:	85 c0                	test   %eax,%eax
  8018df:	78 1b                	js     8018fc <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8018e1:	83 ec 08             	sub    $0x8,%esp
  8018e4:	ff 75 0c             	pushl  0xc(%ebp)
  8018e7:	50                   	push   %eax
  8018e8:	e8 65 ff ff ff       	call   801852 <fstat>
  8018ed:	89 c6                	mov    %eax,%esi
	close(fd);
  8018ef:	89 1c 24             	mov    %ebx,(%esp)
  8018f2:	e8 27 fc ff ff       	call   80151e <close>
	return r;
  8018f7:	83 c4 10             	add    $0x10,%esp
  8018fa:	89 f3                	mov    %esi,%ebx
}
  8018fc:	89 d8                	mov    %ebx,%eax
  8018fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801901:	5b                   	pop    %ebx
  801902:	5e                   	pop    %esi
  801903:	5d                   	pop    %ebp
  801904:	c3                   	ret    

00801905 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801905:	55                   	push   %ebp
  801906:	89 e5                	mov    %esp,%ebp
  801908:	56                   	push   %esi
  801909:	53                   	push   %ebx
  80190a:	89 c6                	mov    %eax,%esi
  80190c:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80190e:	83 3d 00 44 80 00 00 	cmpl   $0x0,0x804400
  801915:	74 27                	je     80193e <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801917:	6a 07                	push   $0x7
  801919:	68 00 50 80 00       	push   $0x805000
  80191e:	56                   	push   %esi
  80191f:	ff 35 00 44 80 00    	pushl  0x804400
  801925:	e8 a7 0b 00 00       	call   8024d1 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80192a:	83 c4 0c             	add    $0xc,%esp
  80192d:	6a 00                	push   $0x0
  80192f:	53                   	push   %ebx
  801930:	6a 00                	push   $0x0
  801932:	e8 31 0b 00 00       	call   802468 <ipc_recv>
}
  801937:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80193a:	5b                   	pop    %ebx
  80193b:	5e                   	pop    %esi
  80193c:	5d                   	pop    %ebp
  80193d:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80193e:	83 ec 0c             	sub    $0xc,%esp
  801941:	6a 01                	push   $0x1
  801943:	e8 e1 0b 00 00       	call   802529 <ipc_find_env>
  801948:	a3 00 44 80 00       	mov    %eax,0x804400
  80194d:	83 c4 10             	add    $0x10,%esp
  801950:	eb c5                	jmp    801917 <fsipc+0x12>

00801952 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801952:	55                   	push   %ebp
  801953:	89 e5                	mov    %esp,%ebp
  801955:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801958:	8b 45 08             	mov    0x8(%ebp),%eax
  80195b:	8b 40 0c             	mov    0xc(%eax),%eax
  80195e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801963:	8b 45 0c             	mov    0xc(%ebp),%eax
  801966:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80196b:	ba 00 00 00 00       	mov    $0x0,%edx
  801970:	b8 02 00 00 00       	mov    $0x2,%eax
  801975:	e8 8b ff ff ff       	call   801905 <fsipc>
}
  80197a:	c9                   	leave  
  80197b:	c3                   	ret    

0080197c <devfile_flush>:
{
  80197c:	55                   	push   %ebp
  80197d:	89 e5                	mov    %esp,%ebp
  80197f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801982:	8b 45 08             	mov    0x8(%ebp),%eax
  801985:	8b 40 0c             	mov    0xc(%eax),%eax
  801988:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80198d:	ba 00 00 00 00       	mov    $0x0,%edx
  801992:	b8 06 00 00 00       	mov    $0x6,%eax
  801997:	e8 69 ff ff ff       	call   801905 <fsipc>
}
  80199c:	c9                   	leave  
  80199d:	c3                   	ret    

0080199e <devfile_stat>:
{
  80199e:	55                   	push   %ebp
  80199f:	89 e5                	mov    %esp,%ebp
  8019a1:	53                   	push   %ebx
  8019a2:	83 ec 04             	sub    $0x4,%esp
  8019a5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8019a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8019ae:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8019b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8019b8:	b8 05 00 00 00       	mov    $0x5,%eax
  8019bd:	e8 43 ff ff ff       	call   801905 <fsipc>
  8019c2:	85 c0                	test   %eax,%eax
  8019c4:	78 2c                	js     8019f2 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8019c6:	83 ec 08             	sub    $0x8,%esp
  8019c9:	68 00 50 80 00       	push   $0x805000
  8019ce:	53                   	push   %ebx
  8019cf:	e8 d8 f2 ff ff       	call   800cac <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8019d4:	a1 80 50 80 00       	mov    0x805080,%eax
  8019d9:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8019df:	a1 84 50 80 00       	mov    0x805084,%eax
  8019e4:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8019ea:	83 c4 10             	add    $0x10,%esp
  8019ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019f5:	c9                   	leave  
  8019f6:	c3                   	ret    

008019f7 <devfile_write>:
{
  8019f7:	55                   	push   %ebp
  8019f8:	89 e5                	mov    %esp,%ebp
  8019fa:	53                   	push   %ebx
  8019fb:	83 ec 08             	sub    $0x8,%esp
  8019fe:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a01:	8b 45 08             	mov    0x8(%ebp),%eax
  801a04:	8b 40 0c             	mov    0xc(%eax),%eax
  801a07:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801a0c:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801a12:	53                   	push   %ebx
  801a13:	ff 75 0c             	pushl  0xc(%ebp)
  801a16:	68 08 50 80 00       	push   $0x805008
  801a1b:	e8 7c f4 ff ff       	call   800e9c <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801a20:	ba 00 00 00 00       	mov    $0x0,%edx
  801a25:	b8 04 00 00 00       	mov    $0x4,%eax
  801a2a:	e8 d6 fe ff ff       	call   801905 <fsipc>
  801a2f:	83 c4 10             	add    $0x10,%esp
  801a32:	85 c0                	test   %eax,%eax
  801a34:	78 0b                	js     801a41 <devfile_write+0x4a>
	assert(r <= n);
  801a36:	39 d8                	cmp    %ebx,%eax
  801a38:	77 0c                	ja     801a46 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801a3a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a3f:	7f 1e                	jg     801a5f <devfile_write+0x68>
}
  801a41:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a44:	c9                   	leave  
  801a45:	c3                   	ret    
	assert(r <= n);
  801a46:	68 58 2d 80 00       	push   $0x802d58
  801a4b:	68 5f 2d 80 00       	push   $0x802d5f
  801a50:	68 98 00 00 00       	push   $0x98
  801a55:	68 74 2d 80 00       	push   $0x802d74
  801a5a:	e8 08 e9 ff ff       	call   800367 <_panic>
	assert(r <= PGSIZE);
  801a5f:	68 7f 2d 80 00       	push   $0x802d7f
  801a64:	68 5f 2d 80 00       	push   $0x802d5f
  801a69:	68 99 00 00 00       	push   $0x99
  801a6e:	68 74 2d 80 00       	push   $0x802d74
  801a73:	e8 ef e8 ff ff       	call   800367 <_panic>

00801a78 <devfile_read>:
{
  801a78:	55                   	push   %ebp
  801a79:	89 e5                	mov    %esp,%ebp
  801a7b:	56                   	push   %esi
  801a7c:	53                   	push   %ebx
  801a7d:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a80:	8b 45 08             	mov    0x8(%ebp),%eax
  801a83:	8b 40 0c             	mov    0xc(%eax),%eax
  801a86:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801a8b:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a91:	ba 00 00 00 00       	mov    $0x0,%edx
  801a96:	b8 03 00 00 00       	mov    $0x3,%eax
  801a9b:	e8 65 fe ff ff       	call   801905 <fsipc>
  801aa0:	89 c3                	mov    %eax,%ebx
  801aa2:	85 c0                	test   %eax,%eax
  801aa4:	78 1f                	js     801ac5 <devfile_read+0x4d>
	assert(r <= n);
  801aa6:	39 f0                	cmp    %esi,%eax
  801aa8:	77 24                	ja     801ace <devfile_read+0x56>
	assert(r <= PGSIZE);
  801aaa:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801aaf:	7f 33                	jg     801ae4 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801ab1:	83 ec 04             	sub    $0x4,%esp
  801ab4:	50                   	push   %eax
  801ab5:	68 00 50 80 00       	push   $0x805000
  801aba:	ff 75 0c             	pushl  0xc(%ebp)
  801abd:	e8 78 f3 ff ff       	call   800e3a <memmove>
	return r;
  801ac2:	83 c4 10             	add    $0x10,%esp
}
  801ac5:	89 d8                	mov    %ebx,%eax
  801ac7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aca:	5b                   	pop    %ebx
  801acb:	5e                   	pop    %esi
  801acc:	5d                   	pop    %ebp
  801acd:	c3                   	ret    
	assert(r <= n);
  801ace:	68 58 2d 80 00       	push   $0x802d58
  801ad3:	68 5f 2d 80 00       	push   $0x802d5f
  801ad8:	6a 7c                	push   $0x7c
  801ada:	68 74 2d 80 00       	push   $0x802d74
  801adf:	e8 83 e8 ff ff       	call   800367 <_panic>
	assert(r <= PGSIZE);
  801ae4:	68 7f 2d 80 00       	push   $0x802d7f
  801ae9:	68 5f 2d 80 00       	push   $0x802d5f
  801aee:	6a 7d                	push   $0x7d
  801af0:	68 74 2d 80 00       	push   $0x802d74
  801af5:	e8 6d e8 ff ff       	call   800367 <_panic>

00801afa <open>:
{
  801afa:	55                   	push   %ebp
  801afb:	89 e5                	mov    %esp,%ebp
  801afd:	56                   	push   %esi
  801afe:	53                   	push   %ebx
  801aff:	83 ec 1c             	sub    $0x1c,%esp
  801b02:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801b05:	56                   	push   %esi
  801b06:	e8 68 f1 ff ff       	call   800c73 <strlen>
  801b0b:	83 c4 10             	add    $0x10,%esp
  801b0e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b13:	7f 6c                	jg     801b81 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801b15:	83 ec 0c             	sub    $0xc,%esp
  801b18:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b1b:	50                   	push   %eax
  801b1c:	e8 79 f8 ff ff       	call   80139a <fd_alloc>
  801b21:	89 c3                	mov    %eax,%ebx
  801b23:	83 c4 10             	add    $0x10,%esp
  801b26:	85 c0                	test   %eax,%eax
  801b28:	78 3c                	js     801b66 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801b2a:	83 ec 08             	sub    $0x8,%esp
  801b2d:	56                   	push   %esi
  801b2e:	68 00 50 80 00       	push   $0x805000
  801b33:	e8 74 f1 ff ff       	call   800cac <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b38:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b3b:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b40:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b43:	b8 01 00 00 00       	mov    $0x1,%eax
  801b48:	e8 b8 fd ff ff       	call   801905 <fsipc>
  801b4d:	89 c3                	mov    %eax,%ebx
  801b4f:	83 c4 10             	add    $0x10,%esp
  801b52:	85 c0                	test   %eax,%eax
  801b54:	78 19                	js     801b6f <open+0x75>
	return fd2num(fd);
  801b56:	83 ec 0c             	sub    $0xc,%esp
  801b59:	ff 75 f4             	pushl  -0xc(%ebp)
  801b5c:	e8 12 f8 ff ff       	call   801373 <fd2num>
  801b61:	89 c3                	mov    %eax,%ebx
  801b63:	83 c4 10             	add    $0x10,%esp
}
  801b66:	89 d8                	mov    %ebx,%eax
  801b68:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b6b:	5b                   	pop    %ebx
  801b6c:	5e                   	pop    %esi
  801b6d:	5d                   	pop    %ebp
  801b6e:	c3                   	ret    
		fd_close(fd, 0);
  801b6f:	83 ec 08             	sub    $0x8,%esp
  801b72:	6a 00                	push   $0x0
  801b74:	ff 75 f4             	pushl  -0xc(%ebp)
  801b77:	e8 1b f9 ff ff       	call   801497 <fd_close>
		return r;
  801b7c:	83 c4 10             	add    $0x10,%esp
  801b7f:	eb e5                	jmp    801b66 <open+0x6c>
		return -E_BAD_PATH;
  801b81:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801b86:	eb de                	jmp    801b66 <open+0x6c>

00801b88 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
  801b8b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b8e:	ba 00 00 00 00       	mov    $0x0,%edx
  801b93:	b8 08 00 00 00       	mov    $0x8,%eax
  801b98:	e8 68 fd ff ff       	call   801905 <fsipc>
}
  801b9d:	c9                   	leave  
  801b9e:	c3                   	ret    

00801b9f <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  801b9f:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801ba3:	7f 01                	jg     801ba6 <writebuf+0x7>
  801ba5:	c3                   	ret    
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
  801ba9:	53                   	push   %ebx
  801baa:	83 ec 08             	sub    $0x8,%esp
  801bad:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  801baf:	ff 70 04             	pushl  0x4(%eax)
  801bb2:	8d 40 10             	lea    0x10(%eax),%eax
  801bb5:	50                   	push   %eax
  801bb6:	ff 33                	pushl  (%ebx)
  801bb8:	e8 6b fb ff ff       	call   801728 <write>
		if (result > 0)
  801bbd:	83 c4 10             	add    $0x10,%esp
  801bc0:	85 c0                	test   %eax,%eax
  801bc2:	7e 03                	jle    801bc7 <writebuf+0x28>
			b->result += result;
  801bc4:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801bc7:	39 43 04             	cmp    %eax,0x4(%ebx)
  801bca:	74 0d                	je     801bd9 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  801bcc:	85 c0                	test   %eax,%eax
  801bce:	ba 00 00 00 00       	mov    $0x0,%edx
  801bd3:	0f 4f c2             	cmovg  %edx,%eax
  801bd6:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801bd9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bdc:	c9                   	leave  
  801bdd:	c3                   	ret    

00801bde <putch>:

static void
putch(int ch, void *thunk)
{
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
  801be1:	53                   	push   %ebx
  801be2:	83 ec 04             	sub    $0x4,%esp
  801be5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801be8:	8b 53 04             	mov    0x4(%ebx),%edx
  801beb:	8d 42 01             	lea    0x1(%edx),%eax
  801bee:	89 43 04             	mov    %eax,0x4(%ebx)
  801bf1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bf4:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801bf8:	3d 00 01 00 00       	cmp    $0x100,%eax
  801bfd:	74 06                	je     801c05 <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  801bff:	83 c4 04             	add    $0x4,%esp
  801c02:	5b                   	pop    %ebx
  801c03:	5d                   	pop    %ebp
  801c04:	c3                   	ret    
		writebuf(b);
  801c05:	89 d8                	mov    %ebx,%eax
  801c07:	e8 93 ff ff ff       	call   801b9f <writebuf>
		b->idx = 0;
  801c0c:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  801c13:	eb ea                	jmp    801bff <putch+0x21>

00801c15 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801c15:	55                   	push   %ebp
  801c16:	89 e5                	mov    %esp,%ebp
  801c18:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c21:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801c27:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801c2e:	00 00 00 
	b.result = 0;
  801c31:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801c38:	00 00 00 
	b.error = 1;
  801c3b:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801c42:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801c45:	ff 75 10             	pushl  0x10(%ebp)
  801c48:	ff 75 0c             	pushl  0xc(%ebp)
  801c4b:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801c51:	50                   	push   %eax
  801c52:	68 de 1b 80 00       	push   $0x801bde
  801c57:	e8 2e e9 ff ff       	call   80058a <vprintfmt>
	if (b.idx > 0)
  801c5c:	83 c4 10             	add    $0x10,%esp
  801c5f:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801c66:	7f 11                	jg     801c79 <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  801c68:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801c6e:	85 c0                	test   %eax,%eax
  801c70:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801c77:	c9                   	leave  
  801c78:	c3                   	ret    
		writebuf(&b);
  801c79:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801c7f:	e8 1b ff ff ff       	call   801b9f <writebuf>
  801c84:	eb e2                	jmp    801c68 <vfprintf+0x53>

00801c86 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801c86:	55                   	push   %ebp
  801c87:	89 e5                	mov    %esp,%ebp
  801c89:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801c8c:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801c8f:	50                   	push   %eax
  801c90:	ff 75 0c             	pushl  0xc(%ebp)
  801c93:	ff 75 08             	pushl  0x8(%ebp)
  801c96:	e8 7a ff ff ff       	call   801c15 <vfprintf>
	va_end(ap);

	return cnt;
}
  801c9b:	c9                   	leave  
  801c9c:	c3                   	ret    

00801c9d <printf>:

int
printf(const char *fmt, ...)
{
  801c9d:	55                   	push   %ebp
  801c9e:	89 e5                	mov    %esp,%ebp
  801ca0:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801ca3:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801ca6:	50                   	push   %eax
  801ca7:	ff 75 08             	pushl  0x8(%ebp)
  801caa:	6a 01                	push   $0x1
  801cac:	e8 64 ff ff ff       	call   801c15 <vfprintf>
	va_end(ap);

	return cnt;
}
  801cb1:	c9                   	leave  
  801cb2:	c3                   	ret    

00801cb3 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801cb3:	55                   	push   %ebp
  801cb4:	89 e5                	mov    %esp,%ebp
  801cb6:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801cb9:	68 8b 2d 80 00       	push   $0x802d8b
  801cbe:	ff 75 0c             	pushl  0xc(%ebp)
  801cc1:	e8 e6 ef ff ff       	call   800cac <strcpy>
	return 0;
}
  801cc6:	b8 00 00 00 00       	mov    $0x0,%eax
  801ccb:	c9                   	leave  
  801ccc:	c3                   	ret    

00801ccd <devsock_close>:
{
  801ccd:	55                   	push   %ebp
  801cce:	89 e5                	mov    %esp,%ebp
  801cd0:	53                   	push   %ebx
  801cd1:	83 ec 10             	sub    $0x10,%esp
  801cd4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801cd7:	53                   	push   %ebx
  801cd8:	e8 87 08 00 00       	call   802564 <pageref>
  801cdd:	83 c4 10             	add    $0x10,%esp
		return 0;
  801ce0:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801ce5:	83 f8 01             	cmp    $0x1,%eax
  801ce8:	74 07                	je     801cf1 <devsock_close+0x24>
}
  801cea:	89 d0                	mov    %edx,%eax
  801cec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cef:	c9                   	leave  
  801cf0:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801cf1:	83 ec 0c             	sub    $0xc,%esp
  801cf4:	ff 73 0c             	pushl  0xc(%ebx)
  801cf7:	e8 b9 02 00 00       	call   801fb5 <nsipc_close>
  801cfc:	89 c2                	mov    %eax,%edx
  801cfe:	83 c4 10             	add    $0x10,%esp
  801d01:	eb e7                	jmp    801cea <devsock_close+0x1d>

00801d03 <devsock_write>:
{
  801d03:	55                   	push   %ebp
  801d04:	89 e5                	mov    %esp,%ebp
  801d06:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801d09:	6a 00                	push   $0x0
  801d0b:	ff 75 10             	pushl  0x10(%ebp)
  801d0e:	ff 75 0c             	pushl  0xc(%ebp)
  801d11:	8b 45 08             	mov    0x8(%ebp),%eax
  801d14:	ff 70 0c             	pushl  0xc(%eax)
  801d17:	e8 76 03 00 00       	call   802092 <nsipc_send>
}
  801d1c:	c9                   	leave  
  801d1d:	c3                   	ret    

00801d1e <devsock_read>:
{
  801d1e:	55                   	push   %ebp
  801d1f:	89 e5                	mov    %esp,%ebp
  801d21:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801d24:	6a 00                	push   $0x0
  801d26:	ff 75 10             	pushl  0x10(%ebp)
  801d29:	ff 75 0c             	pushl  0xc(%ebp)
  801d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2f:	ff 70 0c             	pushl  0xc(%eax)
  801d32:	e8 ef 02 00 00       	call   802026 <nsipc_recv>
}
  801d37:	c9                   	leave  
  801d38:	c3                   	ret    

00801d39 <fd2sockid>:
{
  801d39:	55                   	push   %ebp
  801d3a:	89 e5                	mov    %esp,%ebp
  801d3c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801d3f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801d42:	52                   	push   %edx
  801d43:	50                   	push   %eax
  801d44:	e8 a3 f6 ff ff       	call   8013ec <fd_lookup>
  801d49:	83 c4 10             	add    $0x10,%esp
  801d4c:	85 c0                	test   %eax,%eax
  801d4e:	78 10                	js     801d60 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d53:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801d59:	39 08                	cmp    %ecx,(%eax)
  801d5b:	75 05                	jne    801d62 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801d5d:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801d60:	c9                   	leave  
  801d61:	c3                   	ret    
		return -E_NOT_SUPP;
  801d62:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d67:	eb f7                	jmp    801d60 <fd2sockid+0x27>

00801d69 <alloc_sockfd>:
{
  801d69:	55                   	push   %ebp
  801d6a:	89 e5                	mov    %esp,%ebp
  801d6c:	56                   	push   %esi
  801d6d:	53                   	push   %ebx
  801d6e:	83 ec 1c             	sub    $0x1c,%esp
  801d71:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801d73:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d76:	50                   	push   %eax
  801d77:	e8 1e f6 ff ff       	call   80139a <fd_alloc>
  801d7c:	89 c3                	mov    %eax,%ebx
  801d7e:	83 c4 10             	add    $0x10,%esp
  801d81:	85 c0                	test   %eax,%eax
  801d83:	78 43                	js     801dc8 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801d85:	83 ec 04             	sub    $0x4,%esp
  801d88:	68 07 04 00 00       	push   $0x407
  801d8d:	ff 75 f4             	pushl  -0xc(%ebp)
  801d90:	6a 00                	push   $0x0
  801d92:	e8 07 f3 ff ff       	call   80109e <sys_page_alloc>
  801d97:	89 c3                	mov    %eax,%ebx
  801d99:	83 c4 10             	add    $0x10,%esp
  801d9c:	85 c0                	test   %eax,%eax
  801d9e:	78 28                	js     801dc8 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801da0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da3:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801da9:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dae:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801db5:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801db8:	83 ec 0c             	sub    $0xc,%esp
  801dbb:	50                   	push   %eax
  801dbc:	e8 b2 f5 ff ff       	call   801373 <fd2num>
  801dc1:	89 c3                	mov    %eax,%ebx
  801dc3:	83 c4 10             	add    $0x10,%esp
  801dc6:	eb 0c                	jmp    801dd4 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801dc8:	83 ec 0c             	sub    $0xc,%esp
  801dcb:	56                   	push   %esi
  801dcc:	e8 e4 01 00 00       	call   801fb5 <nsipc_close>
		return r;
  801dd1:	83 c4 10             	add    $0x10,%esp
}
  801dd4:	89 d8                	mov    %ebx,%eax
  801dd6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dd9:	5b                   	pop    %ebx
  801dda:	5e                   	pop    %esi
  801ddb:	5d                   	pop    %ebp
  801ddc:	c3                   	ret    

00801ddd <accept>:
{
  801ddd:	55                   	push   %ebp
  801dde:	89 e5                	mov    %esp,%ebp
  801de0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801de3:	8b 45 08             	mov    0x8(%ebp),%eax
  801de6:	e8 4e ff ff ff       	call   801d39 <fd2sockid>
  801deb:	85 c0                	test   %eax,%eax
  801ded:	78 1b                	js     801e0a <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801def:	83 ec 04             	sub    $0x4,%esp
  801df2:	ff 75 10             	pushl  0x10(%ebp)
  801df5:	ff 75 0c             	pushl  0xc(%ebp)
  801df8:	50                   	push   %eax
  801df9:	e8 0e 01 00 00       	call   801f0c <nsipc_accept>
  801dfe:	83 c4 10             	add    $0x10,%esp
  801e01:	85 c0                	test   %eax,%eax
  801e03:	78 05                	js     801e0a <accept+0x2d>
	return alloc_sockfd(r);
  801e05:	e8 5f ff ff ff       	call   801d69 <alloc_sockfd>
}
  801e0a:	c9                   	leave  
  801e0b:	c3                   	ret    

00801e0c <bind>:
{
  801e0c:	55                   	push   %ebp
  801e0d:	89 e5                	mov    %esp,%ebp
  801e0f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e12:	8b 45 08             	mov    0x8(%ebp),%eax
  801e15:	e8 1f ff ff ff       	call   801d39 <fd2sockid>
  801e1a:	85 c0                	test   %eax,%eax
  801e1c:	78 12                	js     801e30 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801e1e:	83 ec 04             	sub    $0x4,%esp
  801e21:	ff 75 10             	pushl  0x10(%ebp)
  801e24:	ff 75 0c             	pushl  0xc(%ebp)
  801e27:	50                   	push   %eax
  801e28:	e8 31 01 00 00       	call   801f5e <nsipc_bind>
  801e2d:	83 c4 10             	add    $0x10,%esp
}
  801e30:	c9                   	leave  
  801e31:	c3                   	ret    

00801e32 <shutdown>:
{
  801e32:	55                   	push   %ebp
  801e33:	89 e5                	mov    %esp,%ebp
  801e35:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e38:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3b:	e8 f9 fe ff ff       	call   801d39 <fd2sockid>
  801e40:	85 c0                	test   %eax,%eax
  801e42:	78 0f                	js     801e53 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801e44:	83 ec 08             	sub    $0x8,%esp
  801e47:	ff 75 0c             	pushl  0xc(%ebp)
  801e4a:	50                   	push   %eax
  801e4b:	e8 43 01 00 00       	call   801f93 <nsipc_shutdown>
  801e50:	83 c4 10             	add    $0x10,%esp
}
  801e53:	c9                   	leave  
  801e54:	c3                   	ret    

00801e55 <connect>:
{
  801e55:	55                   	push   %ebp
  801e56:	89 e5                	mov    %esp,%ebp
  801e58:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5e:	e8 d6 fe ff ff       	call   801d39 <fd2sockid>
  801e63:	85 c0                	test   %eax,%eax
  801e65:	78 12                	js     801e79 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801e67:	83 ec 04             	sub    $0x4,%esp
  801e6a:	ff 75 10             	pushl  0x10(%ebp)
  801e6d:	ff 75 0c             	pushl  0xc(%ebp)
  801e70:	50                   	push   %eax
  801e71:	e8 59 01 00 00       	call   801fcf <nsipc_connect>
  801e76:	83 c4 10             	add    $0x10,%esp
}
  801e79:	c9                   	leave  
  801e7a:	c3                   	ret    

00801e7b <listen>:
{
  801e7b:	55                   	push   %ebp
  801e7c:	89 e5                	mov    %esp,%ebp
  801e7e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e81:	8b 45 08             	mov    0x8(%ebp),%eax
  801e84:	e8 b0 fe ff ff       	call   801d39 <fd2sockid>
  801e89:	85 c0                	test   %eax,%eax
  801e8b:	78 0f                	js     801e9c <listen+0x21>
	return nsipc_listen(r, backlog);
  801e8d:	83 ec 08             	sub    $0x8,%esp
  801e90:	ff 75 0c             	pushl  0xc(%ebp)
  801e93:	50                   	push   %eax
  801e94:	e8 6b 01 00 00       	call   802004 <nsipc_listen>
  801e99:	83 c4 10             	add    $0x10,%esp
}
  801e9c:	c9                   	leave  
  801e9d:	c3                   	ret    

00801e9e <socket>:

int
socket(int domain, int type, int protocol)
{
  801e9e:	55                   	push   %ebp
  801e9f:	89 e5                	mov    %esp,%ebp
  801ea1:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801ea4:	ff 75 10             	pushl  0x10(%ebp)
  801ea7:	ff 75 0c             	pushl  0xc(%ebp)
  801eaa:	ff 75 08             	pushl  0x8(%ebp)
  801ead:	e8 3e 02 00 00       	call   8020f0 <nsipc_socket>
  801eb2:	83 c4 10             	add    $0x10,%esp
  801eb5:	85 c0                	test   %eax,%eax
  801eb7:	78 05                	js     801ebe <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801eb9:	e8 ab fe ff ff       	call   801d69 <alloc_sockfd>
}
  801ebe:	c9                   	leave  
  801ebf:	c3                   	ret    

00801ec0 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801ec0:	55                   	push   %ebp
  801ec1:	89 e5                	mov    %esp,%ebp
  801ec3:	53                   	push   %ebx
  801ec4:	83 ec 04             	sub    $0x4,%esp
  801ec7:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801ec9:	83 3d 04 44 80 00 00 	cmpl   $0x0,0x804404
  801ed0:	74 26                	je     801ef8 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801ed2:	6a 07                	push   $0x7
  801ed4:	68 00 60 80 00       	push   $0x806000
  801ed9:	53                   	push   %ebx
  801eda:	ff 35 04 44 80 00    	pushl  0x804404
  801ee0:	e8 ec 05 00 00       	call   8024d1 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801ee5:	83 c4 0c             	add    $0xc,%esp
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	e8 75 05 00 00       	call   802468 <ipc_recv>
}
  801ef3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ef6:	c9                   	leave  
  801ef7:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801ef8:	83 ec 0c             	sub    $0xc,%esp
  801efb:	6a 02                	push   $0x2
  801efd:	e8 27 06 00 00       	call   802529 <ipc_find_env>
  801f02:	a3 04 44 80 00       	mov    %eax,0x804404
  801f07:	83 c4 10             	add    $0x10,%esp
  801f0a:	eb c6                	jmp    801ed2 <nsipc+0x12>

00801f0c <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801f0c:	55                   	push   %ebp
  801f0d:	89 e5                	mov    %esp,%ebp
  801f0f:	56                   	push   %esi
  801f10:	53                   	push   %ebx
  801f11:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801f14:	8b 45 08             	mov    0x8(%ebp),%eax
  801f17:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801f1c:	8b 06                	mov    (%esi),%eax
  801f1e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801f23:	b8 01 00 00 00       	mov    $0x1,%eax
  801f28:	e8 93 ff ff ff       	call   801ec0 <nsipc>
  801f2d:	89 c3                	mov    %eax,%ebx
  801f2f:	85 c0                	test   %eax,%eax
  801f31:	79 09                	jns    801f3c <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801f33:	89 d8                	mov    %ebx,%eax
  801f35:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f38:	5b                   	pop    %ebx
  801f39:	5e                   	pop    %esi
  801f3a:	5d                   	pop    %ebp
  801f3b:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801f3c:	83 ec 04             	sub    $0x4,%esp
  801f3f:	ff 35 10 60 80 00    	pushl  0x806010
  801f45:	68 00 60 80 00       	push   $0x806000
  801f4a:	ff 75 0c             	pushl  0xc(%ebp)
  801f4d:	e8 e8 ee ff ff       	call   800e3a <memmove>
		*addrlen = ret->ret_addrlen;
  801f52:	a1 10 60 80 00       	mov    0x806010,%eax
  801f57:	89 06                	mov    %eax,(%esi)
  801f59:	83 c4 10             	add    $0x10,%esp
	return r;
  801f5c:	eb d5                	jmp    801f33 <nsipc_accept+0x27>

00801f5e <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801f5e:	55                   	push   %ebp
  801f5f:	89 e5                	mov    %esp,%ebp
  801f61:	53                   	push   %ebx
  801f62:	83 ec 08             	sub    $0x8,%esp
  801f65:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801f68:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6b:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801f70:	53                   	push   %ebx
  801f71:	ff 75 0c             	pushl  0xc(%ebp)
  801f74:	68 04 60 80 00       	push   $0x806004
  801f79:	e8 bc ee ff ff       	call   800e3a <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801f7e:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801f84:	b8 02 00 00 00       	mov    $0x2,%eax
  801f89:	e8 32 ff ff ff       	call   801ec0 <nsipc>
}
  801f8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f91:	c9                   	leave  
  801f92:	c3                   	ret    

00801f93 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801f93:	55                   	push   %ebp
  801f94:	89 e5                	mov    %esp,%ebp
  801f96:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801f99:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801fa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fa4:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801fa9:	b8 03 00 00 00       	mov    $0x3,%eax
  801fae:	e8 0d ff ff ff       	call   801ec0 <nsipc>
}
  801fb3:	c9                   	leave  
  801fb4:	c3                   	ret    

00801fb5 <nsipc_close>:

int
nsipc_close(int s)
{
  801fb5:	55                   	push   %ebp
  801fb6:	89 e5                	mov    %esp,%ebp
  801fb8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbe:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801fc3:	b8 04 00 00 00       	mov    $0x4,%eax
  801fc8:	e8 f3 fe ff ff       	call   801ec0 <nsipc>
}
  801fcd:	c9                   	leave  
  801fce:	c3                   	ret    

00801fcf <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801fcf:	55                   	push   %ebp
  801fd0:	89 e5                	mov    %esp,%ebp
  801fd2:	53                   	push   %ebx
  801fd3:	83 ec 08             	sub    $0x8,%esp
  801fd6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdc:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801fe1:	53                   	push   %ebx
  801fe2:	ff 75 0c             	pushl  0xc(%ebp)
  801fe5:	68 04 60 80 00       	push   $0x806004
  801fea:	e8 4b ee ff ff       	call   800e3a <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801fef:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801ff5:	b8 05 00 00 00       	mov    $0x5,%eax
  801ffa:	e8 c1 fe ff ff       	call   801ec0 <nsipc>
}
  801fff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802002:	c9                   	leave  
  802003:	c3                   	ret    

00802004 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802004:	55                   	push   %ebp
  802005:	89 e5                	mov    %esp,%ebp
  802007:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80200a:	8b 45 08             	mov    0x8(%ebp),%eax
  80200d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  802012:	8b 45 0c             	mov    0xc(%ebp),%eax
  802015:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  80201a:	b8 06 00 00 00       	mov    $0x6,%eax
  80201f:	e8 9c fe ff ff       	call   801ec0 <nsipc>
}
  802024:	c9                   	leave  
  802025:	c3                   	ret    

00802026 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802026:	55                   	push   %ebp
  802027:	89 e5                	mov    %esp,%ebp
  802029:	56                   	push   %esi
  80202a:	53                   	push   %ebx
  80202b:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80202e:	8b 45 08             	mov    0x8(%ebp),%eax
  802031:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  802036:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  80203c:	8b 45 14             	mov    0x14(%ebp),%eax
  80203f:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802044:	b8 07 00 00 00       	mov    $0x7,%eax
  802049:	e8 72 fe ff ff       	call   801ec0 <nsipc>
  80204e:	89 c3                	mov    %eax,%ebx
  802050:	85 c0                	test   %eax,%eax
  802052:	78 1f                	js     802073 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802054:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802059:	7f 21                	jg     80207c <nsipc_recv+0x56>
  80205b:	39 c6                	cmp    %eax,%esi
  80205d:	7c 1d                	jl     80207c <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80205f:	83 ec 04             	sub    $0x4,%esp
  802062:	50                   	push   %eax
  802063:	68 00 60 80 00       	push   $0x806000
  802068:	ff 75 0c             	pushl  0xc(%ebp)
  80206b:	e8 ca ed ff ff       	call   800e3a <memmove>
  802070:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802073:	89 d8                	mov    %ebx,%eax
  802075:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802078:	5b                   	pop    %ebx
  802079:	5e                   	pop    %esi
  80207a:	5d                   	pop    %ebp
  80207b:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80207c:	68 97 2d 80 00       	push   $0x802d97
  802081:	68 5f 2d 80 00       	push   $0x802d5f
  802086:	6a 62                	push   $0x62
  802088:	68 ac 2d 80 00       	push   $0x802dac
  80208d:	e8 d5 e2 ff ff       	call   800367 <_panic>

00802092 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802092:	55                   	push   %ebp
  802093:	89 e5                	mov    %esp,%ebp
  802095:	53                   	push   %ebx
  802096:	83 ec 04             	sub    $0x4,%esp
  802099:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80209c:	8b 45 08             	mov    0x8(%ebp),%eax
  80209f:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8020a4:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8020aa:	7f 2e                	jg     8020da <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8020ac:	83 ec 04             	sub    $0x4,%esp
  8020af:	53                   	push   %ebx
  8020b0:	ff 75 0c             	pushl  0xc(%ebp)
  8020b3:	68 0c 60 80 00       	push   $0x80600c
  8020b8:	e8 7d ed ff ff       	call   800e3a <memmove>
	nsipcbuf.send.req_size = size;
  8020bd:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8020c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8020c6:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8020cb:	b8 08 00 00 00       	mov    $0x8,%eax
  8020d0:	e8 eb fd ff ff       	call   801ec0 <nsipc>
}
  8020d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020d8:	c9                   	leave  
  8020d9:	c3                   	ret    
	assert(size < 1600);
  8020da:	68 b8 2d 80 00       	push   $0x802db8
  8020df:	68 5f 2d 80 00       	push   $0x802d5f
  8020e4:	6a 6d                	push   $0x6d
  8020e6:	68 ac 2d 80 00       	push   $0x802dac
  8020eb:	e8 77 e2 ff ff       	call   800367 <_panic>

008020f0 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8020f0:	55                   	push   %ebp
  8020f1:	89 e5                	mov    %esp,%ebp
  8020f3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8020f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  8020fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802101:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  802106:	8b 45 10             	mov    0x10(%ebp),%eax
  802109:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  80210e:	b8 09 00 00 00       	mov    $0x9,%eax
  802113:	e8 a8 fd ff ff       	call   801ec0 <nsipc>
}
  802118:	c9                   	leave  
  802119:	c3                   	ret    

0080211a <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80211a:	55                   	push   %ebp
  80211b:	89 e5                	mov    %esp,%ebp
  80211d:	56                   	push   %esi
  80211e:	53                   	push   %ebx
  80211f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802122:	83 ec 0c             	sub    $0xc,%esp
  802125:	ff 75 08             	pushl  0x8(%ebp)
  802128:	e8 56 f2 ff ff       	call   801383 <fd2data>
  80212d:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80212f:	83 c4 08             	add    $0x8,%esp
  802132:	68 c4 2d 80 00       	push   $0x802dc4
  802137:	53                   	push   %ebx
  802138:	e8 6f eb ff ff       	call   800cac <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80213d:	8b 46 04             	mov    0x4(%esi),%eax
  802140:	2b 06                	sub    (%esi),%eax
  802142:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802148:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80214f:	00 00 00 
	stat->st_dev = &devpipe;
  802152:	c7 83 88 00 00 00 58 	movl   $0x803058,0x88(%ebx)
  802159:	30 80 00 
	return 0;
}
  80215c:	b8 00 00 00 00       	mov    $0x0,%eax
  802161:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802164:	5b                   	pop    %ebx
  802165:	5e                   	pop    %esi
  802166:	5d                   	pop    %ebp
  802167:	c3                   	ret    

00802168 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802168:	55                   	push   %ebp
  802169:	89 e5                	mov    %esp,%ebp
  80216b:	53                   	push   %ebx
  80216c:	83 ec 0c             	sub    $0xc,%esp
  80216f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802172:	53                   	push   %ebx
  802173:	6a 00                	push   $0x0
  802175:	e8 a9 ef ff ff       	call   801123 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80217a:	89 1c 24             	mov    %ebx,(%esp)
  80217d:	e8 01 f2 ff ff       	call   801383 <fd2data>
  802182:	83 c4 08             	add    $0x8,%esp
  802185:	50                   	push   %eax
  802186:	6a 00                	push   $0x0
  802188:	e8 96 ef ff ff       	call   801123 <sys_page_unmap>
}
  80218d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802190:	c9                   	leave  
  802191:	c3                   	ret    

00802192 <_pipeisclosed>:
{
  802192:	55                   	push   %ebp
  802193:	89 e5                	mov    %esp,%ebp
  802195:	57                   	push   %edi
  802196:	56                   	push   %esi
  802197:	53                   	push   %ebx
  802198:	83 ec 1c             	sub    $0x1c,%esp
  80219b:	89 c7                	mov    %eax,%edi
  80219d:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80219f:	a1 08 44 80 00       	mov    0x804408,%eax
  8021a4:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8021a7:	83 ec 0c             	sub    $0xc,%esp
  8021aa:	57                   	push   %edi
  8021ab:	e8 b4 03 00 00       	call   802564 <pageref>
  8021b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8021b3:	89 34 24             	mov    %esi,(%esp)
  8021b6:	e8 a9 03 00 00       	call   802564 <pageref>
		nn = thisenv->env_runs;
  8021bb:	8b 15 08 44 80 00    	mov    0x804408,%edx
  8021c1:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8021c4:	83 c4 10             	add    $0x10,%esp
  8021c7:	39 cb                	cmp    %ecx,%ebx
  8021c9:	74 1b                	je     8021e6 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8021cb:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8021ce:	75 cf                	jne    80219f <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8021d0:	8b 42 58             	mov    0x58(%edx),%eax
  8021d3:	6a 01                	push   $0x1
  8021d5:	50                   	push   %eax
  8021d6:	53                   	push   %ebx
  8021d7:	68 cb 2d 80 00       	push   $0x802dcb
  8021dc:	e8 7c e2 ff ff       	call   80045d <cprintf>
  8021e1:	83 c4 10             	add    $0x10,%esp
  8021e4:	eb b9                	jmp    80219f <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8021e6:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8021e9:	0f 94 c0             	sete   %al
  8021ec:	0f b6 c0             	movzbl %al,%eax
}
  8021ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021f2:	5b                   	pop    %ebx
  8021f3:	5e                   	pop    %esi
  8021f4:	5f                   	pop    %edi
  8021f5:	5d                   	pop    %ebp
  8021f6:	c3                   	ret    

008021f7 <devpipe_write>:
{
  8021f7:	55                   	push   %ebp
  8021f8:	89 e5                	mov    %esp,%ebp
  8021fa:	57                   	push   %edi
  8021fb:	56                   	push   %esi
  8021fc:	53                   	push   %ebx
  8021fd:	83 ec 28             	sub    $0x28,%esp
  802200:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802203:	56                   	push   %esi
  802204:	e8 7a f1 ff ff       	call   801383 <fd2data>
  802209:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80220b:	83 c4 10             	add    $0x10,%esp
  80220e:	bf 00 00 00 00       	mov    $0x0,%edi
  802213:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802216:	74 4f                	je     802267 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802218:	8b 43 04             	mov    0x4(%ebx),%eax
  80221b:	8b 0b                	mov    (%ebx),%ecx
  80221d:	8d 51 20             	lea    0x20(%ecx),%edx
  802220:	39 d0                	cmp    %edx,%eax
  802222:	72 14                	jb     802238 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802224:	89 da                	mov    %ebx,%edx
  802226:	89 f0                	mov    %esi,%eax
  802228:	e8 65 ff ff ff       	call   802192 <_pipeisclosed>
  80222d:	85 c0                	test   %eax,%eax
  80222f:	75 3b                	jne    80226c <devpipe_write+0x75>
			sys_yield();
  802231:	e8 49 ee ff ff       	call   80107f <sys_yield>
  802236:	eb e0                	jmp    802218 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802238:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80223b:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80223f:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802242:	89 c2                	mov    %eax,%edx
  802244:	c1 fa 1f             	sar    $0x1f,%edx
  802247:	89 d1                	mov    %edx,%ecx
  802249:	c1 e9 1b             	shr    $0x1b,%ecx
  80224c:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80224f:	83 e2 1f             	and    $0x1f,%edx
  802252:	29 ca                	sub    %ecx,%edx
  802254:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802258:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80225c:	83 c0 01             	add    $0x1,%eax
  80225f:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802262:	83 c7 01             	add    $0x1,%edi
  802265:	eb ac                	jmp    802213 <devpipe_write+0x1c>
	return i;
  802267:	8b 45 10             	mov    0x10(%ebp),%eax
  80226a:	eb 05                	jmp    802271 <devpipe_write+0x7a>
				return 0;
  80226c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802271:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802274:	5b                   	pop    %ebx
  802275:	5e                   	pop    %esi
  802276:	5f                   	pop    %edi
  802277:	5d                   	pop    %ebp
  802278:	c3                   	ret    

00802279 <devpipe_read>:
{
  802279:	55                   	push   %ebp
  80227a:	89 e5                	mov    %esp,%ebp
  80227c:	57                   	push   %edi
  80227d:	56                   	push   %esi
  80227e:	53                   	push   %ebx
  80227f:	83 ec 18             	sub    $0x18,%esp
  802282:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802285:	57                   	push   %edi
  802286:	e8 f8 f0 ff ff       	call   801383 <fd2data>
  80228b:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80228d:	83 c4 10             	add    $0x10,%esp
  802290:	be 00 00 00 00       	mov    $0x0,%esi
  802295:	3b 75 10             	cmp    0x10(%ebp),%esi
  802298:	75 14                	jne    8022ae <devpipe_read+0x35>
	return i;
  80229a:	8b 45 10             	mov    0x10(%ebp),%eax
  80229d:	eb 02                	jmp    8022a1 <devpipe_read+0x28>
				return i;
  80229f:	89 f0                	mov    %esi,%eax
}
  8022a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022a4:	5b                   	pop    %ebx
  8022a5:	5e                   	pop    %esi
  8022a6:	5f                   	pop    %edi
  8022a7:	5d                   	pop    %ebp
  8022a8:	c3                   	ret    
			sys_yield();
  8022a9:	e8 d1 ed ff ff       	call   80107f <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8022ae:	8b 03                	mov    (%ebx),%eax
  8022b0:	3b 43 04             	cmp    0x4(%ebx),%eax
  8022b3:	75 18                	jne    8022cd <devpipe_read+0x54>
			if (i > 0)
  8022b5:	85 f6                	test   %esi,%esi
  8022b7:	75 e6                	jne    80229f <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8022b9:	89 da                	mov    %ebx,%edx
  8022bb:	89 f8                	mov    %edi,%eax
  8022bd:	e8 d0 fe ff ff       	call   802192 <_pipeisclosed>
  8022c2:	85 c0                	test   %eax,%eax
  8022c4:	74 e3                	je     8022a9 <devpipe_read+0x30>
				return 0;
  8022c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8022cb:	eb d4                	jmp    8022a1 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8022cd:	99                   	cltd   
  8022ce:	c1 ea 1b             	shr    $0x1b,%edx
  8022d1:	01 d0                	add    %edx,%eax
  8022d3:	83 e0 1f             	and    $0x1f,%eax
  8022d6:	29 d0                	sub    %edx,%eax
  8022d8:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8022dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8022e0:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8022e3:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8022e6:	83 c6 01             	add    $0x1,%esi
  8022e9:	eb aa                	jmp    802295 <devpipe_read+0x1c>

008022eb <pipe>:
{
  8022eb:	55                   	push   %ebp
  8022ec:	89 e5                	mov    %esp,%ebp
  8022ee:	56                   	push   %esi
  8022ef:	53                   	push   %ebx
  8022f0:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8022f3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022f6:	50                   	push   %eax
  8022f7:	e8 9e f0 ff ff       	call   80139a <fd_alloc>
  8022fc:	89 c3                	mov    %eax,%ebx
  8022fe:	83 c4 10             	add    $0x10,%esp
  802301:	85 c0                	test   %eax,%eax
  802303:	0f 88 23 01 00 00    	js     80242c <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802309:	83 ec 04             	sub    $0x4,%esp
  80230c:	68 07 04 00 00       	push   $0x407
  802311:	ff 75 f4             	pushl  -0xc(%ebp)
  802314:	6a 00                	push   $0x0
  802316:	e8 83 ed ff ff       	call   80109e <sys_page_alloc>
  80231b:	89 c3                	mov    %eax,%ebx
  80231d:	83 c4 10             	add    $0x10,%esp
  802320:	85 c0                	test   %eax,%eax
  802322:	0f 88 04 01 00 00    	js     80242c <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802328:	83 ec 0c             	sub    $0xc,%esp
  80232b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80232e:	50                   	push   %eax
  80232f:	e8 66 f0 ff ff       	call   80139a <fd_alloc>
  802334:	89 c3                	mov    %eax,%ebx
  802336:	83 c4 10             	add    $0x10,%esp
  802339:	85 c0                	test   %eax,%eax
  80233b:	0f 88 db 00 00 00    	js     80241c <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802341:	83 ec 04             	sub    $0x4,%esp
  802344:	68 07 04 00 00       	push   $0x407
  802349:	ff 75 f0             	pushl  -0x10(%ebp)
  80234c:	6a 00                	push   $0x0
  80234e:	e8 4b ed ff ff       	call   80109e <sys_page_alloc>
  802353:	89 c3                	mov    %eax,%ebx
  802355:	83 c4 10             	add    $0x10,%esp
  802358:	85 c0                	test   %eax,%eax
  80235a:	0f 88 bc 00 00 00    	js     80241c <pipe+0x131>
	va = fd2data(fd0);
  802360:	83 ec 0c             	sub    $0xc,%esp
  802363:	ff 75 f4             	pushl  -0xc(%ebp)
  802366:	e8 18 f0 ff ff       	call   801383 <fd2data>
  80236b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80236d:	83 c4 0c             	add    $0xc,%esp
  802370:	68 07 04 00 00       	push   $0x407
  802375:	50                   	push   %eax
  802376:	6a 00                	push   $0x0
  802378:	e8 21 ed ff ff       	call   80109e <sys_page_alloc>
  80237d:	89 c3                	mov    %eax,%ebx
  80237f:	83 c4 10             	add    $0x10,%esp
  802382:	85 c0                	test   %eax,%eax
  802384:	0f 88 82 00 00 00    	js     80240c <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80238a:	83 ec 0c             	sub    $0xc,%esp
  80238d:	ff 75 f0             	pushl  -0x10(%ebp)
  802390:	e8 ee ef ff ff       	call   801383 <fd2data>
  802395:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80239c:	50                   	push   %eax
  80239d:	6a 00                	push   $0x0
  80239f:	56                   	push   %esi
  8023a0:	6a 00                	push   $0x0
  8023a2:	e8 3a ed ff ff       	call   8010e1 <sys_page_map>
  8023a7:	89 c3                	mov    %eax,%ebx
  8023a9:	83 c4 20             	add    $0x20,%esp
  8023ac:	85 c0                	test   %eax,%eax
  8023ae:	78 4e                	js     8023fe <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8023b0:	a1 58 30 80 00       	mov    0x803058,%eax
  8023b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023b8:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8023ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023bd:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8023c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023c7:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8023c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023cc:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8023d3:	83 ec 0c             	sub    $0xc,%esp
  8023d6:	ff 75 f4             	pushl  -0xc(%ebp)
  8023d9:	e8 95 ef ff ff       	call   801373 <fd2num>
  8023de:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023e1:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8023e3:	83 c4 04             	add    $0x4,%esp
  8023e6:	ff 75 f0             	pushl  -0x10(%ebp)
  8023e9:	e8 85 ef ff ff       	call   801373 <fd2num>
  8023ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023f1:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8023f4:	83 c4 10             	add    $0x10,%esp
  8023f7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8023fc:	eb 2e                	jmp    80242c <pipe+0x141>
	sys_page_unmap(0, va);
  8023fe:	83 ec 08             	sub    $0x8,%esp
  802401:	56                   	push   %esi
  802402:	6a 00                	push   $0x0
  802404:	e8 1a ed ff ff       	call   801123 <sys_page_unmap>
  802409:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80240c:	83 ec 08             	sub    $0x8,%esp
  80240f:	ff 75 f0             	pushl  -0x10(%ebp)
  802412:	6a 00                	push   $0x0
  802414:	e8 0a ed ff ff       	call   801123 <sys_page_unmap>
  802419:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80241c:	83 ec 08             	sub    $0x8,%esp
  80241f:	ff 75 f4             	pushl  -0xc(%ebp)
  802422:	6a 00                	push   $0x0
  802424:	e8 fa ec ff ff       	call   801123 <sys_page_unmap>
  802429:	83 c4 10             	add    $0x10,%esp
}
  80242c:	89 d8                	mov    %ebx,%eax
  80242e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802431:	5b                   	pop    %ebx
  802432:	5e                   	pop    %esi
  802433:	5d                   	pop    %ebp
  802434:	c3                   	ret    

00802435 <pipeisclosed>:
{
  802435:	55                   	push   %ebp
  802436:	89 e5                	mov    %esp,%ebp
  802438:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80243b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80243e:	50                   	push   %eax
  80243f:	ff 75 08             	pushl  0x8(%ebp)
  802442:	e8 a5 ef ff ff       	call   8013ec <fd_lookup>
  802447:	83 c4 10             	add    $0x10,%esp
  80244a:	85 c0                	test   %eax,%eax
  80244c:	78 18                	js     802466 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80244e:	83 ec 0c             	sub    $0xc,%esp
  802451:	ff 75 f4             	pushl  -0xc(%ebp)
  802454:	e8 2a ef ff ff       	call   801383 <fd2data>
	return _pipeisclosed(fd, p);
  802459:	89 c2                	mov    %eax,%edx
  80245b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245e:	e8 2f fd ff ff       	call   802192 <_pipeisclosed>
  802463:	83 c4 10             	add    $0x10,%esp
}
  802466:	c9                   	leave  
  802467:	c3                   	ret    

00802468 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802468:	55                   	push   %ebp
  802469:	89 e5                	mov    %esp,%ebp
  80246b:	56                   	push   %esi
  80246c:	53                   	push   %ebx
  80246d:	8b 75 08             	mov    0x8(%ebp),%esi
  802470:	8b 45 0c             	mov    0xc(%ebp),%eax
  802473:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// cprintf("in %s\n", __FUNCTION__);
	int ret;
	if(!pg)
  802476:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802478:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80247d:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802480:	83 ec 0c             	sub    $0xc,%esp
  802483:	50                   	push   %eax
  802484:	e8 c5 ed ff ff       	call   80124e <sys_ipc_recv>
	if(ret < 0){
  802489:	83 c4 10             	add    $0x10,%esp
  80248c:	85 c0                	test   %eax,%eax
  80248e:	78 2b                	js     8024bb <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802490:	85 f6                	test   %esi,%esi
  802492:	74 0a                	je     80249e <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  802494:	a1 08 44 80 00       	mov    0x804408,%eax
  802499:	8b 40 74             	mov    0x74(%eax),%eax
  80249c:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80249e:	85 db                	test   %ebx,%ebx
  8024a0:	74 0a                	je     8024ac <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  8024a2:	a1 08 44 80 00       	mov    0x804408,%eax
  8024a7:	8b 40 78             	mov    0x78(%eax),%eax
  8024aa:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  8024ac:	a1 08 44 80 00       	mov    0x804408,%eax
  8024b1:	8b 40 70             	mov    0x70(%eax),%eax
}
  8024b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024b7:	5b                   	pop    %ebx
  8024b8:	5e                   	pop    %esi
  8024b9:	5d                   	pop    %ebp
  8024ba:	c3                   	ret    
		if(from_env_store)
  8024bb:	85 f6                	test   %esi,%esi
  8024bd:	74 06                	je     8024c5 <ipc_recv+0x5d>
			*from_env_store = 0;
  8024bf:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8024c5:	85 db                	test   %ebx,%ebx
  8024c7:	74 eb                	je     8024b4 <ipc_recv+0x4c>
			*perm_store = 0;
  8024c9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8024cf:	eb e3                	jmp    8024b4 <ipc_recv+0x4c>

008024d1 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8024d1:	55                   	push   %ebp
  8024d2:	89 e5                	mov    %esp,%ebp
  8024d4:	57                   	push   %edi
  8024d5:	56                   	push   %esi
  8024d6:	53                   	push   %ebx
  8024d7:	83 ec 0c             	sub    $0xc,%esp
  8024da:	8b 7d 08             	mov    0x8(%ebp),%edi
  8024dd:	8b 75 0c             	mov    0xc(%ebp),%esi
  8024e0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8024e3:	85 db                	test   %ebx,%ebx
  8024e5:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8024ea:	0f 44 d8             	cmove  %eax,%ebx
  8024ed:	eb 05                	jmp    8024f4 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8024ef:	e8 8b eb ff ff       	call   80107f <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8024f4:	ff 75 14             	pushl  0x14(%ebp)
  8024f7:	53                   	push   %ebx
  8024f8:	56                   	push   %esi
  8024f9:	57                   	push   %edi
  8024fa:	e8 2c ed ff ff       	call   80122b <sys_ipc_try_send>
  8024ff:	83 c4 10             	add    $0x10,%esp
  802502:	85 c0                	test   %eax,%eax
  802504:	74 1b                	je     802521 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802506:	79 e7                	jns    8024ef <ipc_send+0x1e>
  802508:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80250b:	74 e2                	je     8024ef <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80250d:	83 ec 04             	sub    $0x4,%esp
  802510:	68 e3 2d 80 00       	push   $0x802de3
  802515:	6a 4a                	push   $0x4a
  802517:	68 f8 2d 80 00       	push   $0x802df8
  80251c:	e8 46 de ff ff       	call   800367 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802521:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802524:	5b                   	pop    %ebx
  802525:	5e                   	pop    %esi
  802526:	5f                   	pop    %edi
  802527:	5d                   	pop    %ebp
  802528:	c3                   	ret    

00802529 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802529:	55                   	push   %ebp
  80252a:	89 e5                	mov    %esp,%ebp
  80252c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80252f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802534:	89 c2                	mov    %eax,%edx
  802536:	c1 e2 07             	shl    $0x7,%edx
  802539:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80253f:	8b 52 50             	mov    0x50(%edx),%edx
  802542:	39 ca                	cmp    %ecx,%edx
  802544:	74 11                	je     802557 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802546:	83 c0 01             	add    $0x1,%eax
  802549:	3d 00 04 00 00       	cmp    $0x400,%eax
  80254e:	75 e4                	jne    802534 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802550:	b8 00 00 00 00       	mov    $0x0,%eax
  802555:	eb 0b                	jmp    802562 <ipc_find_env+0x39>
			return envs[i].env_id;
  802557:	c1 e0 07             	shl    $0x7,%eax
  80255a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80255f:	8b 40 48             	mov    0x48(%eax),%eax
}
  802562:	5d                   	pop    %ebp
  802563:	c3                   	ret    

00802564 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802564:	55                   	push   %ebp
  802565:	89 e5                	mov    %esp,%ebp
  802567:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80256a:	89 d0                	mov    %edx,%eax
  80256c:	c1 e8 16             	shr    $0x16,%eax
  80256f:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802576:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80257b:	f6 c1 01             	test   $0x1,%cl
  80257e:	74 1d                	je     80259d <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802580:	c1 ea 0c             	shr    $0xc,%edx
  802583:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80258a:	f6 c2 01             	test   $0x1,%dl
  80258d:	74 0e                	je     80259d <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80258f:	c1 ea 0c             	shr    $0xc,%edx
  802592:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802599:	ef 
  80259a:	0f b7 c0             	movzwl %ax,%eax
}
  80259d:	5d                   	pop    %ebp
  80259e:	c3                   	ret    
  80259f:	90                   	nop

008025a0 <__udivdi3>:
  8025a0:	55                   	push   %ebp
  8025a1:	57                   	push   %edi
  8025a2:	56                   	push   %esi
  8025a3:	53                   	push   %ebx
  8025a4:	83 ec 1c             	sub    $0x1c,%esp
  8025a7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8025ab:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8025af:	8b 74 24 34          	mov    0x34(%esp),%esi
  8025b3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8025b7:	85 d2                	test   %edx,%edx
  8025b9:	75 4d                	jne    802608 <__udivdi3+0x68>
  8025bb:	39 f3                	cmp    %esi,%ebx
  8025bd:	76 19                	jbe    8025d8 <__udivdi3+0x38>
  8025bf:	31 ff                	xor    %edi,%edi
  8025c1:	89 e8                	mov    %ebp,%eax
  8025c3:	89 f2                	mov    %esi,%edx
  8025c5:	f7 f3                	div    %ebx
  8025c7:	89 fa                	mov    %edi,%edx
  8025c9:	83 c4 1c             	add    $0x1c,%esp
  8025cc:	5b                   	pop    %ebx
  8025cd:	5e                   	pop    %esi
  8025ce:	5f                   	pop    %edi
  8025cf:	5d                   	pop    %ebp
  8025d0:	c3                   	ret    
  8025d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025d8:	89 d9                	mov    %ebx,%ecx
  8025da:	85 db                	test   %ebx,%ebx
  8025dc:	75 0b                	jne    8025e9 <__udivdi3+0x49>
  8025de:	b8 01 00 00 00       	mov    $0x1,%eax
  8025e3:	31 d2                	xor    %edx,%edx
  8025e5:	f7 f3                	div    %ebx
  8025e7:	89 c1                	mov    %eax,%ecx
  8025e9:	31 d2                	xor    %edx,%edx
  8025eb:	89 f0                	mov    %esi,%eax
  8025ed:	f7 f1                	div    %ecx
  8025ef:	89 c6                	mov    %eax,%esi
  8025f1:	89 e8                	mov    %ebp,%eax
  8025f3:	89 f7                	mov    %esi,%edi
  8025f5:	f7 f1                	div    %ecx
  8025f7:	89 fa                	mov    %edi,%edx
  8025f9:	83 c4 1c             	add    $0x1c,%esp
  8025fc:	5b                   	pop    %ebx
  8025fd:	5e                   	pop    %esi
  8025fe:	5f                   	pop    %edi
  8025ff:	5d                   	pop    %ebp
  802600:	c3                   	ret    
  802601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802608:	39 f2                	cmp    %esi,%edx
  80260a:	77 1c                	ja     802628 <__udivdi3+0x88>
  80260c:	0f bd fa             	bsr    %edx,%edi
  80260f:	83 f7 1f             	xor    $0x1f,%edi
  802612:	75 2c                	jne    802640 <__udivdi3+0xa0>
  802614:	39 f2                	cmp    %esi,%edx
  802616:	72 06                	jb     80261e <__udivdi3+0x7e>
  802618:	31 c0                	xor    %eax,%eax
  80261a:	39 eb                	cmp    %ebp,%ebx
  80261c:	77 a9                	ja     8025c7 <__udivdi3+0x27>
  80261e:	b8 01 00 00 00       	mov    $0x1,%eax
  802623:	eb a2                	jmp    8025c7 <__udivdi3+0x27>
  802625:	8d 76 00             	lea    0x0(%esi),%esi
  802628:	31 ff                	xor    %edi,%edi
  80262a:	31 c0                	xor    %eax,%eax
  80262c:	89 fa                	mov    %edi,%edx
  80262e:	83 c4 1c             	add    $0x1c,%esp
  802631:	5b                   	pop    %ebx
  802632:	5e                   	pop    %esi
  802633:	5f                   	pop    %edi
  802634:	5d                   	pop    %ebp
  802635:	c3                   	ret    
  802636:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80263d:	8d 76 00             	lea    0x0(%esi),%esi
  802640:	89 f9                	mov    %edi,%ecx
  802642:	b8 20 00 00 00       	mov    $0x20,%eax
  802647:	29 f8                	sub    %edi,%eax
  802649:	d3 e2                	shl    %cl,%edx
  80264b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80264f:	89 c1                	mov    %eax,%ecx
  802651:	89 da                	mov    %ebx,%edx
  802653:	d3 ea                	shr    %cl,%edx
  802655:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802659:	09 d1                	or     %edx,%ecx
  80265b:	89 f2                	mov    %esi,%edx
  80265d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802661:	89 f9                	mov    %edi,%ecx
  802663:	d3 e3                	shl    %cl,%ebx
  802665:	89 c1                	mov    %eax,%ecx
  802667:	d3 ea                	shr    %cl,%edx
  802669:	89 f9                	mov    %edi,%ecx
  80266b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80266f:	89 eb                	mov    %ebp,%ebx
  802671:	d3 e6                	shl    %cl,%esi
  802673:	89 c1                	mov    %eax,%ecx
  802675:	d3 eb                	shr    %cl,%ebx
  802677:	09 de                	or     %ebx,%esi
  802679:	89 f0                	mov    %esi,%eax
  80267b:	f7 74 24 08          	divl   0x8(%esp)
  80267f:	89 d6                	mov    %edx,%esi
  802681:	89 c3                	mov    %eax,%ebx
  802683:	f7 64 24 0c          	mull   0xc(%esp)
  802687:	39 d6                	cmp    %edx,%esi
  802689:	72 15                	jb     8026a0 <__udivdi3+0x100>
  80268b:	89 f9                	mov    %edi,%ecx
  80268d:	d3 e5                	shl    %cl,%ebp
  80268f:	39 c5                	cmp    %eax,%ebp
  802691:	73 04                	jae    802697 <__udivdi3+0xf7>
  802693:	39 d6                	cmp    %edx,%esi
  802695:	74 09                	je     8026a0 <__udivdi3+0x100>
  802697:	89 d8                	mov    %ebx,%eax
  802699:	31 ff                	xor    %edi,%edi
  80269b:	e9 27 ff ff ff       	jmp    8025c7 <__udivdi3+0x27>
  8026a0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8026a3:	31 ff                	xor    %edi,%edi
  8026a5:	e9 1d ff ff ff       	jmp    8025c7 <__udivdi3+0x27>
  8026aa:	66 90                	xchg   %ax,%ax
  8026ac:	66 90                	xchg   %ax,%ax
  8026ae:	66 90                	xchg   %ax,%ax

008026b0 <__umoddi3>:
  8026b0:	55                   	push   %ebp
  8026b1:	57                   	push   %edi
  8026b2:	56                   	push   %esi
  8026b3:	53                   	push   %ebx
  8026b4:	83 ec 1c             	sub    $0x1c,%esp
  8026b7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8026bb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8026bf:	8b 74 24 30          	mov    0x30(%esp),%esi
  8026c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8026c7:	89 da                	mov    %ebx,%edx
  8026c9:	85 c0                	test   %eax,%eax
  8026cb:	75 43                	jne    802710 <__umoddi3+0x60>
  8026cd:	39 df                	cmp    %ebx,%edi
  8026cf:	76 17                	jbe    8026e8 <__umoddi3+0x38>
  8026d1:	89 f0                	mov    %esi,%eax
  8026d3:	f7 f7                	div    %edi
  8026d5:	89 d0                	mov    %edx,%eax
  8026d7:	31 d2                	xor    %edx,%edx
  8026d9:	83 c4 1c             	add    $0x1c,%esp
  8026dc:	5b                   	pop    %ebx
  8026dd:	5e                   	pop    %esi
  8026de:	5f                   	pop    %edi
  8026df:	5d                   	pop    %ebp
  8026e0:	c3                   	ret    
  8026e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026e8:	89 fd                	mov    %edi,%ebp
  8026ea:	85 ff                	test   %edi,%edi
  8026ec:	75 0b                	jne    8026f9 <__umoddi3+0x49>
  8026ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8026f3:	31 d2                	xor    %edx,%edx
  8026f5:	f7 f7                	div    %edi
  8026f7:	89 c5                	mov    %eax,%ebp
  8026f9:	89 d8                	mov    %ebx,%eax
  8026fb:	31 d2                	xor    %edx,%edx
  8026fd:	f7 f5                	div    %ebp
  8026ff:	89 f0                	mov    %esi,%eax
  802701:	f7 f5                	div    %ebp
  802703:	89 d0                	mov    %edx,%eax
  802705:	eb d0                	jmp    8026d7 <__umoddi3+0x27>
  802707:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80270e:	66 90                	xchg   %ax,%ax
  802710:	89 f1                	mov    %esi,%ecx
  802712:	39 d8                	cmp    %ebx,%eax
  802714:	76 0a                	jbe    802720 <__umoddi3+0x70>
  802716:	89 f0                	mov    %esi,%eax
  802718:	83 c4 1c             	add    $0x1c,%esp
  80271b:	5b                   	pop    %ebx
  80271c:	5e                   	pop    %esi
  80271d:	5f                   	pop    %edi
  80271e:	5d                   	pop    %ebp
  80271f:	c3                   	ret    
  802720:	0f bd e8             	bsr    %eax,%ebp
  802723:	83 f5 1f             	xor    $0x1f,%ebp
  802726:	75 20                	jne    802748 <__umoddi3+0x98>
  802728:	39 d8                	cmp    %ebx,%eax
  80272a:	0f 82 b0 00 00 00    	jb     8027e0 <__umoddi3+0x130>
  802730:	39 f7                	cmp    %esi,%edi
  802732:	0f 86 a8 00 00 00    	jbe    8027e0 <__umoddi3+0x130>
  802738:	89 c8                	mov    %ecx,%eax
  80273a:	83 c4 1c             	add    $0x1c,%esp
  80273d:	5b                   	pop    %ebx
  80273e:	5e                   	pop    %esi
  80273f:	5f                   	pop    %edi
  802740:	5d                   	pop    %ebp
  802741:	c3                   	ret    
  802742:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802748:	89 e9                	mov    %ebp,%ecx
  80274a:	ba 20 00 00 00       	mov    $0x20,%edx
  80274f:	29 ea                	sub    %ebp,%edx
  802751:	d3 e0                	shl    %cl,%eax
  802753:	89 44 24 08          	mov    %eax,0x8(%esp)
  802757:	89 d1                	mov    %edx,%ecx
  802759:	89 f8                	mov    %edi,%eax
  80275b:	d3 e8                	shr    %cl,%eax
  80275d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802761:	89 54 24 04          	mov    %edx,0x4(%esp)
  802765:	8b 54 24 04          	mov    0x4(%esp),%edx
  802769:	09 c1                	or     %eax,%ecx
  80276b:	89 d8                	mov    %ebx,%eax
  80276d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802771:	89 e9                	mov    %ebp,%ecx
  802773:	d3 e7                	shl    %cl,%edi
  802775:	89 d1                	mov    %edx,%ecx
  802777:	d3 e8                	shr    %cl,%eax
  802779:	89 e9                	mov    %ebp,%ecx
  80277b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80277f:	d3 e3                	shl    %cl,%ebx
  802781:	89 c7                	mov    %eax,%edi
  802783:	89 d1                	mov    %edx,%ecx
  802785:	89 f0                	mov    %esi,%eax
  802787:	d3 e8                	shr    %cl,%eax
  802789:	89 e9                	mov    %ebp,%ecx
  80278b:	89 fa                	mov    %edi,%edx
  80278d:	d3 e6                	shl    %cl,%esi
  80278f:	09 d8                	or     %ebx,%eax
  802791:	f7 74 24 08          	divl   0x8(%esp)
  802795:	89 d1                	mov    %edx,%ecx
  802797:	89 f3                	mov    %esi,%ebx
  802799:	f7 64 24 0c          	mull   0xc(%esp)
  80279d:	89 c6                	mov    %eax,%esi
  80279f:	89 d7                	mov    %edx,%edi
  8027a1:	39 d1                	cmp    %edx,%ecx
  8027a3:	72 06                	jb     8027ab <__umoddi3+0xfb>
  8027a5:	75 10                	jne    8027b7 <__umoddi3+0x107>
  8027a7:	39 c3                	cmp    %eax,%ebx
  8027a9:	73 0c                	jae    8027b7 <__umoddi3+0x107>
  8027ab:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8027af:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8027b3:	89 d7                	mov    %edx,%edi
  8027b5:	89 c6                	mov    %eax,%esi
  8027b7:	89 ca                	mov    %ecx,%edx
  8027b9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8027be:	29 f3                	sub    %esi,%ebx
  8027c0:	19 fa                	sbb    %edi,%edx
  8027c2:	89 d0                	mov    %edx,%eax
  8027c4:	d3 e0                	shl    %cl,%eax
  8027c6:	89 e9                	mov    %ebp,%ecx
  8027c8:	d3 eb                	shr    %cl,%ebx
  8027ca:	d3 ea                	shr    %cl,%edx
  8027cc:	09 d8                	or     %ebx,%eax
  8027ce:	83 c4 1c             	add    $0x1c,%esp
  8027d1:	5b                   	pop    %ebx
  8027d2:	5e                   	pop    %esi
  8027d3:	5f                   	pop    %edi
  8027d4:	5d                   	pop    %ebp
  8027d5:	c3                   	ret    
  8027d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027dd:	8d 76 00             	lea    0x0(%esi),%esi
  8027e0:	89 da                	mov    %ebx,%edx
  8027e2:	29 fe                	sub    %edi,%esi
  8027e4:	19 c2                	sbb    %eax,%edx
  8027e6:	89 f1                	mov    %esi,%ecx
  8027e8:	89 c8                	mov    %ecx,%eax
  8027ea:	e9 4b ff ff ff       	jmp    80273a <__umoddi3+0x8a>
