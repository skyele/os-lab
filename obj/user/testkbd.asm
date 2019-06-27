
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
  80003f:	e8 3d 10 00 00       	call   801081 <sys_yield>
	for (i = 0; i < 10; ++i)
  800044:	83 eb 01             	sub    $0x1,%ebx
  800047:	75 f6                	jne    80003f <umain+0xc>

	close(0);
  800049:	83 ec 0c             	sub    $0xc,%esp
  80004c:	6a 00                	push   $0x0
  80004e:	e8 ed 14 00 00       	call   801540 <close>
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
  80006e:	e8 f6 02 00 00       	call   800369 <_panic>
		panic("opencons: %e", r);
  800073:	50                   	push   %eax
  800074:	68 20 28 80 00       	push   $0x802820
  800079:	6a 0f                	push   $0xf
  80007b:	68 2d 28 80 00       	push   $0x80282d
  800080:	e8 e4 02 00 00       	call   800369 <_panic>
	if ((r = dup(0, 1)) < 0)
  800085:	83 ec 08             	sub    $0x8,%esp
  800088:	6a 01                	push   $0x1
  80008a:	6a 00                	push   $0x0
  80008c:	e8 01 15 00 00       	call   801592 <dup>
  800091:	83 c4 10             	add    $0x10,%esp
  800094:	85 c0                	test   %eax,%eax
  800096:	79 24                	jns    8000bc <umain+0x89>
		panic("dup: %e", r);
  800098:	50                   	push   %eax
  800099:	68 56 28 80 00       	push   $0x802856
  80009e:	6a 13                	push   $0x13
  8000a0:	68 2d 28 80 00       	push   $0x80282d
  8000a5:	e8 bf 02 00 00       	call   800369 <_panic>

		buf = readline("Type a line: ");
		if (buf != NULL)
			fprintf(1, "%s\n", buf);
		else
			fprintf(1, "(end of file received)\n");
  8000aa:	83 ec 08             	sub    $0x8,%esp
  8000ad:	68 6c 28 80 00       	push   $0x80286c
  8000b2:	6a 01                	push   $0x1
  8000b4:	e8 ef 1b 00 00       	call   801ca8 <fprintf>
  8000b9:	83 c4 10             	add    $0x10,%esp
		buf = readline("Type a line: ");
  8000bc:	83 ec 0c             	sub    $0xc,%esp
  8000bf:	68 5e 28 80 00       	push   $0x80285e
  8000c4:	e8 bc 0a 00 00       	call   800b85 <readline>
		if (buf != NULL)
  8000c9:	83 c4 10             	add    $0x10,%esp
  8000cc:	85 c0                	test   %eax,%eax
  8000ce:	74 da                	je     8000aa <umain+0x77>
			fprintf(1, "%s\n", buf);
  8000d0:	83 ec 04             	sub    $0x4,%esp
  8000d3:	50                   	push   %eax
  8000d4:	68 ef 28 80 00       	push   $0x8028ef
  8000d9:	6a 01                	push   $0x1
  8000db:	e8 c8 1b 00 00       	call   801ca8 <fprintf>
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
  8000f9:	e8 b0 0b 00 00       	call   800cae <strcpy>
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
  80013c:	e8 fb 0c 00 00       	call   800e3c <memmove>
		sys_cputs(buf, m);
  800141:	83 c4 08             	add    $0x8,%esp
  800144:	53                   	push   %ebx
  800145:	57                   	push   %edi
  800146:	e8 99 0e 00 00       	call   800fe4 <sys_cputs>
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
  80016d:	e8 90 0e 00 00       	call   801002 <sys_cgetc>
  800172:	85 c0                	test   %eax,%eax
  800174:	75 07                	jne    80017d <devcons_read+0x21>
		sys_yield();
  800176:	e8 06 0f 00 00       	call   801081 <sys_yield>
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
  8001a9:	e8 36 0e 00 00       	call   800fe4 <sys_cputs>
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
  8001c1:	e8 b8 14 00 00       	call   80167e <read>
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
  8001e9:	e8 20 12 00 00       	call   80140e <fd_lookup>
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
  800212:	e8 a5 11 00 00       	call   8013bc <fd_alloc>
  800217:	83 c4 10             	add    $0x10,%esp
  80021a:	85 c0                	test   %eax,%eax
  80021c:	78 3a                	js     800258 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80021e:	83 ec 04             	sub    $0x4,%esp
  800221:	68 07 04 00 00       	push   $0x407
  800226:	ff 75 f4             	pushl  -0xc(%ebp)
  800229:	6a 00                	push   $0x0
  80022b:	e8 70 0e 00 00       	call   8010a0 <sys_page_alloc>
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
  800250:	e8 40 11 00 00       	call   801395 <fd2num>
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
  80026d:	e8 f0 0d 00 00       	call   801062 <sys_getenvid>
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
  800292:	74 23                	je     8002b7 <libmain+0x5d>
		if(envs[i].env_id == find)
  800294:	69 ca 84 00 00 00    	imul   $0x84,%edx,%ecx
  80029a:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  8002a0:	8b 49 48             	mov    0x48(%ecx),%ecx
  8002a3:	39 c1                	cmp    %eax,%ecx
  8002a5:	75 e2                	jne    800289 <libmain+0x2f>
  8002a7:	69 da 84 00 00 00    	imul   $0x84,%edx,%ebx
  8002ad:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8002b3:	89 fe                	mov    %edi,%esi
  8002b5:	eb d2                	jmp    800289 <libmain+0x2f>
  8002b7:	89 f0                	mov    %esi,%eax
  8002b9:	84 c0                	test   %al,%al
  8002bb:	74 06                	je     8002c3 <libmain+0x69>
  8002bd:	89 1d 08 44 80 00    	mov    %ebx,0x804408
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002c7:	7e 0a                	jle    8002d3 <libmain+0x79>
		binaryname = argv[0];
  8002c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002cc:	8b 00                	mov    (%eax),%eax
  8002ce:	a3 1c 30 80 00       	mov    %eax,0x80301c

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  8002d3:	a1 08 44 80 00       	mov    0x804408,%eax
  8002d8:	8b 40 48             	mov    0x48(%eax),%eax
  8002db:	83 ec 08             	sub    $0x8,%esp
  8002de:	50                   	push   %eax
  8002df:	68 90 28 80 00       	push   $0x802890
  8002e4:	e8 76 01 00 00       	call   80045f <cprintf>
	cprintf("before umain\n");
  8002e9:	c7 04 24 ae 28 80 00 	movl   $0x8028ae,(%esp)
  8002f0:	e8 6a 01 00 00       	call   80045f <cprintf>
	// call user main routine
	umain(argc, argv);
  8002f5:	83 c4 08             	add    $0x8,%esp
  8002f8:	ff 75 0c             	pushl  0xc(%ebp)
  8002fb:	ff 75 08             	pushl  0x8(%ebp)
  8002fe:	e8 30 fd ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  800303:	c7 04 24 bc 28 80 00 	movl   $0x8028bc,(%esp)
  80030a:	e8 50 01 00 00       	call   80045f <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  80030f:	a1 08 44 80 00       	mov    0x804408,%eax
  800314:	8b 40 48             	mov    0x48(%eax),%eax
  800317:	83 c4 08             	add    $0x8,%esp
  80031a:	50                   	push   %eax
  80031b:	68 c9 28 80 00       	push   $0x8028c9
  800320:	e8 3a 01 00 00       	call   80045f <cprintf>
	// exit gracefully
	exit();
  800325:	e8 0b 00 00 00       	call   800335 <exit>
}
  80032a:	83 c4 10             	add    $0x10,%esp
  80032d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800330:	5b                   	pop    %ebx
  800331:	5e                   	pop    %esi
  800332:	5f                   	pop    %edi
  800333:	5d                   	pop    %ebp
  800334:	c3                   	ret    

00800335 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800335:	55                   	push   %ebp
  800336:	89 e5                	mov    %esp,%ebp
  800338:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80033b:	a1 08 44 80 00       	mov    0x804408,%eax
  800340:	8b 40 48             	mov    0x48(%eax),%eax
  800343:	68 f4 28 80 00       	push   $0x8028f4
  800348:	50                   	push   %eax
  800349:	68 e8 28 80 00       	push   $0x8028e8
  80034e:	e8 0c 01 00 00       	call   80045f <cprintf>
	close_all();
  800353:	e8 15 12 00 00       	call   80156d <close_all>
	sys_env_destroy(0);
  800358:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80035f:	e8 bd 0c 00 00       	call   801021 <sys_env_destroy>
}
  800364:	83 c4 10             	add    $0x10,%esp
  800367:	c9                   	leave  
  800368:	c3                   	ret    

00800369 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800369:	55                   	push   %ebp
  80036a:	89 e5                	mov    %esp,%ebp
  80036c:	56                   	push   %esi
  80036d:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80036e:	a1 08 44 80 00       	mov    0x804408,%eax
  800373:	8b 40 48             	mov    0x48(%eax),%eax
  800376:	83 ec 04             	sub    $0x4,%esp
  800379:	68 20 29 80 00       	push   $0x802920
  80037e:	50                   	push   %eax
  80037f:	68 e8 28 80 00       	push   $0x8028e8
  800384:	e8 d6 00 00 00       	call   80045f <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800389:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80038c:	8b 35 1c 30 80 00    	mov    0x80301c,%esi
  800392:	e8 cb 0c 00 00       	call   801062 <sys_getenvid>
  800397:	83 c4 04             	add    $0x4,%esp
  80039a:	ff 75 0c             	pushl  0xc(%ebp)
  80039d:	ff 75 08             	pushl  0x8(%ebp)
  8003a0:	56                   	push   %esi
  8003a1:	50                   	push   %eax
  8003a2:	68 fc 28 80 00       	push   $0x8028fc
  8003a7:	e8 b3 00 00 00       	call   80045f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003ac:	83 c4 18             	add    $0x18,%esp
  8003af:	53                   	push   %ebx
  8003b0:	ff 75 10             	pushl  0x10(%ebp)
  8003b3:	e8 56 00 00 00       	call   80040e <vcprintf>
	cprintf("\n");
  8003b8:	c7 04 24 ac 28 80 00 	movl   $0x8028ac,(%esp)
  8003bf:	e8 9b 00 00 00       	call   80045f <cprintf>
  8003c4:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003c7:	cc                   	int3   
  8003c8:	eb fd                	jmp    8003c7 <_panic+0x5e>

008003ca <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8003ca:	55                   	push   %ebp
  8003cb:	89 e5                	mov    %esp,%ebp
  8003cd:	53                   	push   %ebx
  8003ce:	83 ec 04             	sub    $0x4,%esp
  8003d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8003d4:	8b 13                	mov    (%ebx),%edx
  8003d6:	8d 42 01             	lea    0x1(%edx),%eax
  8003d9:	89 03                	mov    %eax,(%ebx)
  8003db:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003de:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003e2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003e7:	74 09                	je     8003f2 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8003e9:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003f0:	c9                   	leave  
  8003f1:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8003f2:	83 ec 08             	sub    $0x8,%esp
  8003f5:	68 ff 00 00 00       	push   $0xff
  8003fa:	8d 43 08             	lea    0x8(%ebx),%eax
  8003fd:	50                   	push   %eax
  8003fe:	e8 e1 0b 00 00       	call   800fe4 <sys_cputs>
		b->idx = 0;
  800403:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800409:	83 c4 10             	add    $0x10,%esp
  80040c:	eb db                	jmp    8003e9 <putch+0x1f>

0080040e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80040e:	55                   	push   %ebp
  80040f:	89 e5                	mov    %esp,%ebp
  800411:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800417:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80041e:	00 00 00 
	b.cnt = 0;
  800421:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800428:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80042b:	ff 75 0c             	pushl  0xc(%ebp)
  80042e:	ff 75 08             	pushl  0x8(%ebp)
  800431:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800437:	50                   	push   %eax
  800438:	68 ca 03 80 00       	push   $0x8003ca
  80043d:	e8 4a 01 00 00       	call   80058c <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800442:	83 c4 08             	add    $0x8,%esp
  800445:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80044b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800451:	50                   	push   %eax
  800452:	e8 8d 0b 00 00       	call   800fe4 <sys_cputs>

	return b.cnt;
}
  800457:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80045d:	c9                   	leave  
  80045e:	c3                   	ret    

0080045f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80045f:	55                   	push   %ebp
  800460:	89 e5                	mov    %esp,%ebp
  800462:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800465:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800468:	50                   	push   %eax
  800469:	ff 75 08             	pushl  0x8(%ebp)
  80046c:	e8 9d ff ff ff       	call   80040e <vcprintf>
	va_end(ap);

	return cnt;
}
  800471:	c9                   	leave  
  800472:	c3                   	ret    

00800473 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800473:	55                   	push   %ebp
  800474:	89 e5                	mov    %esp,%ebp
  800476:	57                   	push   %edi
  800477:	56                   	push   %esi
  800478:	53                   	push   %ebx
  800479:	83 ec 1c             	sub    $0x1c,%esp
  80047c:	89 c6                	mov    %eax,%esi
  80047e:	89 d7                	mov    %edx,%edi
  800480:	8b 45 08             	mov    0x8(%ebp),%eax
  800483:	8b 55 0c             	mov    0xc(%ebp),%edx
  800486:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800489:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80048c:	8b 45 10             	mov    0x10(%ebp),%eax
  80048f:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800492:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800496:	74 2c                	je     8004c4 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800498:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80049b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8004a2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004a5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004a8:	39 c2                	cmp    %eax,%edx
  8004aa:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8004ad:	73 43                	jae    8004f2 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8004af:	83 eb 01             	sub    $0x1,%ebx
  8004b2:	85 db                	test   %ebx,%ebx
  8004b4:	7e 6c                	jle    800522 <printnum+0xaf>
				putch(padc, putdat);
  8004b6:	83 ec 08             	sub    $0x8,%esp
  8004b9:	57                   	push   %edi
  8004ba:	ff 75 18             	pushl  0x18(%ebp)
  8004bd:	ff d6                	call   *%esi
  8004bf:	83 c4 10             	add    $0x10,%esp
  8004c2:	eb eb                	jmp    8004af <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8004c4:	83 ec 0c             	sub    $0xc,%esp
  8004c7:	6a 20                	push   $0x20
  8004c9:	6a 00                	push   $0x0
  8004cb:	50                   	push   %eax
  8004cc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004cf:	ff 75 e0             	pushl  -0x20(%ebp)
  8004d2:	89 fa                	mov    %edi,%edx
  8004d4:	89 f0                	mov    %esi,%eax
  8004d6:	e8 98 ff ff ff       	call   800473 <printnum>
		while (--width > 0)
  8004db:	83 c4 20             	add    $0x20,%esp
  8004de:	83 eb 01             	sub    $0x1,%ebx
  8004e1:	85 db                	test   %ebx,%ebx
  8004e3:	7e 65                	jle    80054a <printnum+0xd7>
			putch(padc, putdat);
  8004e5:	83 ec 08             	sub    $0x8,%esp
  8004e8:	57                   	push   %edi
  8004e9:	6a 20                	push   $0x20
  8004eb:	ff d6                	call   *%esi
  8004ed:	83 c4 10             	add    $0x10,%esp
  8004f0:	eb ec                	jmp    8004de <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8004f2:	83 ec 0c             	sub    $0xc,%esp
  8004f5:	ff 75 18             	pushl  0x18(%ebp)
  8004f8:	83 eb 01             	sub    $0x1,%ebx
  8004fb:	53                   	push   %ebx
  8004fc:	50                   	push   %eax
  8004fd:	83 ec 08             	sub    $0x8,%esp
  800500:	ff 75 dc             	pushl  -0x24(%ebp)
  800503:	ff 75 d8             	pushl  -0x28(%ebp)
  800506:	ff 75 e4             	pushl  -0x1c(%ebp)
  800509:	ff 75 e0             	pushl  -0x20(%ebp)
  80050c:	e8 bf 20 00 00       	call   8025d0 <__udivdi3>
  800511:	83 c4 18             	add    $0x18,%esp
  800514:	52                   	push   %edx
  800515:	50                   	push   %eax
  800516:	89 fa                	mov    %edi,%edx
  800518:	89 f0                	mov    %esi,%eax
  80051a:	e8 54 ff ff ff       	call   800473 <printnum>
  80051f:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800522:	83 ec 08             	sub    $0x8,%esp
  800525:	57                   	push   %edi
  800526:	83 ec 04             	sub    $0x4,%esp
  800529:	ff 75 dc             	pushl  -0x24(%ebp)
  80052c:	ff 75 d8             	pushl  -0x28(%ebp)
  80052f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800532:	ff 75 e0             	pushl  -0x20(%ebp)
  800535:	e8 a6 21 00 00       	call   8026e0 <__umoddi3>
  80053a:	83 c4 14             	add    $0x14,%esp
  80053d:	0f be 80 27 29 80 00 	movsbl 0x802927(%eax),%eax
  800544:	50                   	push   %eax
  800545:	ff d6                	call   *%esi
  800547:	83 c4 10             	add    $0x10,%esp
	}
}
  80054a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80054d:	5b                   	pop    %ebx
  80054e:	5e                   	pop    %esi
  80054f:	5f                   	pop    %edi
  800550:	5d                   	pop    %ebp
  800551:	c3                   	ret    

00800552 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800552:	55                   	push   %ebp
  800553:	89 e5                	mov    %esp,%ebp
  800555:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800558:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80055c:	8b 10                	mov    (%eax),%edx
  80055e:	3b 50 04             	cmp    0x4(%eax),%edx
  800561:	73 0a                	jae    80056d <sprintputch+0x1b>
		*b->buf++ = ch;
  800563:	8d 4a 01             	lea    0x1(%edx),%ecx
  800566:	89 08                	mov    %ecx,(%eax)
  800568:	8b 45 08             	mov    0x8(%ebp),%eax
  80056b:	88 02                	mov    %al,(%edx)
}
  80056d:	5d                   	pop    %ebp
  80056e:	c3                   	ret    

0080056f <printfmt>:
{
  80056f:	55                   	push   %ebp
  800570:	89 e5                	mov    %esp,%ebp
  800572:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800575:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800578:	50                   	push   %eax
  800579:	ff 75 10             	pushl  0x10(%ebp)
  80057c:	ff 75 0c             	pushl  0xc(%ebp)
  80057f:	ff 75 08             	pushl  0x8(%ebp)
  800582:	e8 05 00 00 00       	call   80058c <vprintfmt>
}
  800587:	83 c4 10             	add    $0x10,%esp
  80058a:	c9                   	leave  
  80058b:	c3                   	ret    

0080058c <vprintfmt>:
{
  80058c:	55                   	push   %ebp
  80058d:	89 e5                	mov    %esp,%ebp
  80058f:	57                   	push   %edi
  800590:	56                   	push   %esi
  800591:	53                   	push   %ebx
  800592:	83 ec 3c             	sub    $0x3c,%esp
  800595:	8b 75 08             	mov    0x8(%ebp),%esi
  800598:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80059b:	8b 7d 10             	mov    0x10(%ebp),%edi
  80059e:	e9 32 04 00 00       	jmp    8009d5 <vprintfmt+0x449>
		padc = ' ';
  8005a3:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8005a7:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8005ae:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8005b5:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8005bc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005c3:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8005ca:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8005cf:	8d 47 01             	lea    0x1(%edi),%eax
  8005d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005d5:	0f b6 17             	movzbl (%edi),%edx
  8005d8:	8d 42 dd             	lea    -0x23(%edx),%eax
  8005db:	3c 55                	cmp    $0x55,%al
  8005dd:	0f 87 12 05 00 00    	ja     800af5 <vprintfmt+0x569>
  8005e3:	0f b6 c0             	movzbl %al,%eax
  8005e6:	ff 24 85 00 2b 80 00 	jmp    *0x802b00(,%eax,4)
  8005ed:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8005f0:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8005f4:	eb d9                	jmp    8005cf <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8005f6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8005f9:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8005fd:	eb d0                	jmp    8005cf <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8005ff:	0f b6 d2             	movzbl %dl,%edx
  800602:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800605:	b8 00 00 00 00       	mov    $0x0,%eax
  80060a:	89 75 08             	mov    %esi,0x8(%ebp)
  80060d:	eb 03                	jmp    800612 <vprintfmt+0x86>
  80060f:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800612:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800615:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800619:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80061c:	8d 72 d0             	lea    -0x30(%edx),%esi
  80061f:	83 fe 09             	cmp    $0x9,%esi
  800622:	76 eb                	jbe    80060f <vprintfmt+0x83>
  800624:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800627:	8b 75 08             	mov    0x8(%ebp),%esi
  80062a:	eb 14                	jmp    800640 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  80062c:	8b 45 14             	mov    0x14(%ebp),%eax
  80062f:	8b 00                	mov    (%eax),%eax
  800631:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800634:	8b 45 14             	mov    0x14(%ebp),%eax
  800637:	8d 40 04             	lea    0x4(%eax),%eax
  80063a:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80063d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800640:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800644:	79 89                	jns    8005cf <vprintfmt+0x43>
				width = precision, precision = -1;
  800646:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800649:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80064c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800653:	e9 77 ff ff ff       	jmp    8005cf <vprintfmt+0x43>
  800658:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80065b:	85 c0                	test   %eax,%eax
  80065d:	0f 48 c1             	cmovs  %ecx,%eax
  800660:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800663:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800666:	e9 64 ff ff ff       	jmp    8005cf <vprintfmt+0x43>
  80066b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80066e:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800675:	e9 55 ff ff ff       	jmp    8005cf <vprintfmt+0x43>
			lflag++;
  80067a:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80067e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800681:	e9 49 ff ff ff       	jmp    8005cf <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800686:	8b 45 14             	mov    0x14(%ebp),%eax
  800689:	8d 78 04             	lea    0x4(%eax),%edi
  80068c:	83 ec 08             	sub    $0x8,%esp
  80068f:	53                   	push   %ebx
  800690:	ff 30                	pushl  (%eax)
  800692:	ff d6                	call   *%esi
			break;
  800694:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800697:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80069a:	e9 33 03 00 00       	jmp    8009d2 <vprintfmt+0x446>
			err = va_arg(ap, int);
  80069f:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a2:	8d 78 04             	lea    0x4(%eax),%edi
  8006a5:	8b 00                	mov    (%eax),%eax
  8006a7:	99                   	cltd   
  8006a8:	31 d0                	xor    %edx,%eax
  8006aa:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8006ac:	83 f8 11             	cmp    $0x11,%eax
  8006af:	7f 23                	jg     8006d4 <vprintfmt+0x148>
  8006b1:	8b 14 85 60 2c 80 00 	mov    0x802c60(,%eax,4),%edx
  8006b8:	85 d2                	test   %edx,%edx
  8006ba:	74 18                	je     8006d4 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8006bc:	52                   	push   %edx
  8006bd:	68 91 2d 80 00       	push   $0x802d91
  8006c2:	53                   	push   %ebx
  8006c3:	56                   	push   %esi
  8006c4:	e8 a6 fe ff ff       	call   80056f <printfmt>
  8006c9:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8006cc:	89 7d 14             	mov    %edi,0x14(%ebp)
  8006cf:	e9 fe 02 00 00       	jmp    8009d2 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8006d4:	50                   	push   %eax
  8006d5:	68 3f 29 80 00       	push   $0x80293f
  8006da:	53                   	push   %ebx
  8006db:	56                   	push   %esi
  8006dc:	e8 8e fe ff ff       	call   80056f <printfmt>
  8006e1:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8006e4:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8006e7:	e9 e6 02 00 00       	jmp    8009d2 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8006ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ef:	83 c0 04             	add    $0x4,%eax
  8006f2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8006f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f8:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8006fa:	85 c9                	test   %ecx,%ecx
  8006fc:	b8 38 29 80 00       	mov    $0x802938,%eax
  800701:	0f 45 c1             	cmovne %ecx,%eax
  800704:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800707:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80070b:	7e 06                	jle    800713 <vprintfmt+0x187>
  80070d:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800711:	75 0d                	jne    800720 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800713:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800716:	89 c7                	mov    %eax,%edi
  800718:	03 45 e0             	add    -0x20(%ebp),%eax
  80071b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80071e:	eb 53                	jmp    800773 <vprintfmt+0x1e7>
  800720:	83 ec 08             	sub    $0x8,%esp
  800723:	ff 75 d8             	pushl  -0x28(%ebp)
  800726:	50                   	push   %eax
  800727:	e8 61 05 00 00       	call   800c8d <strnlen>
  80072c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80072f:	29 c1                	sub    %eax,%ecx
  800731:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800734:	83 c4 10             	add    $0x10,%esp
  800737:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800739:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  80073d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800740:	eb 0f                	jmp    800751 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800742:	83 ec 08             	sub    $0x8,%esp
  800745:	53                   	push   %ebx
  800746:	ff 75 e0             	pushl  -0x20(%ebp)
  800749:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80074b:	83 ef 01             	sub    $0x1,%edi
  80074e:	83 c4 10             	add    $0x10,%esp
  800751:	85 ff                	test   %edi,%edi
  800753:	7f ed                	jg     800742 <vprintfmt+0x1b6>
  800755:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800758:	85 c9                	test   %ecx,%ecx
  80075a:	b8 00 00 00 00       	mov    $0x0,%eax
  80075f:	0f 49 c1             	cmovns %ecx,%eax
  800762:	29 c1                	sub    %eax,%ecx
  800764:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800767:	eb aa                	jmp    800713 <vprintfmt+0x187>
					putch(ch, putdat);
  800769:	83 ec 08             	sub    $0x8,%esp
  80076c:	53                   	push   %ebx
  80076d:	52                   	push   %edx
  80076e:	ff d6                	call   *%esi
  800770:	83 c4 10             	add    $0x10,%esp
  800773:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800776:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800778:	83 c7 01             	add    $0x1,%edi
  80077b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80077f:	0f be d0             	movsbl %al,%edx
  800782:	85 d2                	test   %edx,%edx
  800784:	74 4b                	je     8007d1 <vprintfmt+0x245>
  800786:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80078a:	78 06                	js     800792 <vprintfmt+0x206>
  80078c:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800790:	78 1e                	js     8007b0 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800792:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800796:	74 d1                	je     800769 <vprintfmt+0x1dd>
  800798:	0f be c0             	movsbl %al,%eax
  80079b:	83 e8 20             	sub    $0x20,%eax
  80079e:	83 f8 5e             	cmp    $0x5e,%eax
  8007a1:	76 c6                	jbe    800769 <vprintfmt+0x1dd>
					putch('?', putdat);
  8007a3:	83 ec 08             	sub    $0x8,%esp
  8007a6:	53                   	push   %ebx
  8007a7:	6a 3f                	push   $0x3f
  8007a9:	ff d6                	call   *%esi
  8007ab:	83 c4 10             	add    $0x10,%esp
  8007ae:	eb c3                	jmp    800773 <vprintfmt+0x1e7>
  8007b0:	89 cf                	mov    %ecx,%edi
  8007b2:	eb 0e                	jmp    8007c2 <vprintfmt+0x236>
				putch(' ', putdat);
  8007b4:	83 ec 08             	sub    $0x8,%esp
  8007b7:	53                   	push   %ebx
  8007b8:	6a 20                	push   $0x20
  8007ba:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8007bc:	83 ef 01             	sub    $0x1,%edi
  8007bf:	83 c4 10             	add    $0x10,%esp
  8007c2:	85 ff                	test   %edi,%edi
  8007c4:	7f ee                	jg     8007b4 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8007c6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8007c9:	89 45 14             	mov    %eax,0x14(%ebp)
  8007cc:	e9 01 02 00 00       	jmp    8009d2 <vprintfmt+0x446>
  8007d1:	89 cf                	mov    %ecx,%edi
  8007d3:	eb ed                	jmp    8007c2 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8007d5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8007d8:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8007df:	e9 eb fd ff ff       	jmp    8005cf <vprintfmt+0x43>
	if (lflag >= 2)
  8007e4:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007e8:	7f 21                	jg     80080b <vprintfmt+0x27f>
	else if (lflag)
  8007ea:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007ee:	74 68                	je     800858 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8007f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f3:	8b 00                	mov    (%eax),%eax
  8007f5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8007f8:	89 c1                	mov    %eax,%ecx
  8007fa:	c1 f9 1f             	sar    $0x1f,%ecx
  8007fd:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800800:	8b 45 14             	mov    0x14(%ebp),%eax
  800803:	8d 40 04             	lea    0x4(%eax),%eax
  800806:	89 45 14             	mov    %eax,0x14(%ebp)
  800809:	eb 17                	jmp    800822 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  80080b:	8b 45 14             	mov    0x14(%ebp),%eax
  80080e:	8b 50 04             	mov    0x4(%eax),%edx
  800811:	8b 00                	mov    (%eax),%eax
  800813:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800816:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800819:	8b 45 14             	mov    0x14(%ebp),%eax
  80081c:	8d 40 08             	lea    0x8(%eax),%eax
  80081f:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800822:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800825:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800828:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80082b:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80082e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800832:	78 3f                	js     800873 <vprintfmt+0x2e7>
			base = 10;
  800834:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800839:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80083d:	0f 84 71 01 00 00    	je     8009b4 <vprintfmt+0x428>
				putch('+', putdat);
  800843:	83 ec 08             	sub    $0x8,%esp
  800846:	53                   	push   %ebx
  800847:	6a 2b                	push   $0x2b
  800849:	ff d6                	call   *%esi
  80084b:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80084e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800853:	e9 5c 01 00 00       	jmp    8009b4 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800858:	8b 45 14             	mov    0x14(%ebp),%eax
  80085b:	8b 00                	mov    (%eax),%eax
  80085d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800860:	89 c1                	mov    %eax,%ecx
  800862:	c1 f9 1f             	sar    $0x1f,%ecx
  800865:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800868:	8b 45 14             	mov    0x14(%ebp),%eax
  80086b:	8d 40 04             	lea    0x4(%eax),%eax
  80086e:	89 45 14             	mov    %eax,0x14(%ebp)
  800871:	eb af                	jmp    800822 <vprintfmt+0x296>
				putch('-', putdat);
  800873:	83 ec 08             	sub    $0x8,%esp
  800876:	53                   	push   %ebx
  800877:	6a 2d                	push   $0x2d
  800879:	ff d6                	call   *%esi
				num = -(long long) num;
  80087b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80087e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800881:	f7 d8                	neg    %eax
  800883:	83 d2 00             	adc    $0x0,%edx
  800886:	f7 da                	neg    %edx
  800888:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80088b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80088e:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800891:	b8 0a 00 00 00       	mov    $0xa,%eax
  800896:	e9 19 01 00 00       	jmp    8009b4 <vprintfmt+0x428>
	if (lflag >= 2)
  80089b:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80089f:	7f 29                	jg     8008ca <vprintfmt+0x33e>
	else if (lflag)
  8008a1:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8008a5:	74 44                	je     8008eb <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8008a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008aa:	8b 00                	mov    (%eax),%eax
  8008ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8008b1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008b4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ba:	8d 40 04             	lea    0x4(%eax),%eax
  8008bd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008c0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008c5:	e9 ea 00 00 00       	jmp    8009b4 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8008ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cd:	8b 50 04             	mov    0x4(%eax),%edx
  8008d0:	8b 00                	mov    (%eax),%eax
  8008d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008d5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008db:	8d 40 08             	lea    0x8(%eax),%eax
  8008de:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008e1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008e6:	e9 c9 00 00 00       	jmp    8009b4 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8008eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ee:	8b 00                	mov    (%eax),%eax
  8008f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008f8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fe:	8d 40 04             	lea    0x4(%eax),%eax
  800901:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800904:	b8 0a 00 00 00       	mov    $0xa,%eax
  800909:	e9 a6 00 00 00       	jmp    8009b4 <vprintfmt+0x428>
			putch('0', putdat);
  80090e:	83 ec 08             	sub    $0x8,%esp
  800911:	53                   	push   %ebx
  800912:	6a 30                	push   $0x30
  800914:	ff d6                	call   *%esi
	if (lflag >= 2)
  800916:	83 c4 10             	add    $0x10,%esp
  800919:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80091d:	7f 26                	jg     800945 <vprintfmt+0x3b9>
	else if (lflag)
  80091f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800923:	74 3e                	je     800963 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800925:	8b 45 14             	mov    0x14(%ebp),%eax
  800928:	8b 00                	mov    (%eax),%eax
  80092a:	ba 00 00 00 00       	mov    $0x0,%edx
  80092f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800932:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800935:	8b 45 14             	mov    0x14(%ebp),%eax
  800938:	8d 40 04             	lea    0x4(%eax),%eax
  80093b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80093e:	b8 08 00 00 00       	mov    $0x8,%eax
  800943:	eb 6f                	jmp    8009b4 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800945:	8b 45 14             	mov    0x14(%ebp),%eax
  800948:	8b 50 04             	mov    0x4(%eax),%edx
  80094b:	8b 00                	mov    (%eax),%eax
  80094d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800950:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800953:	8b 45 14             	mov    0x14(%ebp),%eax
  800956:	8d 40 08             	lea    0x8(%eax),%eax
  800959:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80095c:	b8 08 00 00 00       	mov    $0x8,%eax
  800961:	eb 51                	jmp    8009b4 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800963:	8b 45 14             	mov    0x14(%ebp),%eax
  800966:	8b 00                	mov    (%eax),%eax
  800968:	ba 00 00 00 00       	mov    $0x0,%edx
  80096d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800970:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800973:	8b 45 14             	mov    0x14(%ebp),%eax
  800976:	8d 40 04             	lea    0x4(%eax),%eax
  800979:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80097c:	b8 08 00 00 00       	mov    $0x8,%eax
  800981:	eb 31                	jmp    8009b4 <vprintfmt+0x428>
			putch('0', putdat);
  800983:	83 ec 08             	sub    $0x8,%esp
  800986:	53                   	push   %ebx
  800987:	6a 30                	push   $0x30
  800989:	ff d6                	call   *%esi
			putch('x', putdat);
  80098b:	83 c4 08             	add    $0x8,%esp
  80098e:	53                   	push   %ebx
  80098f:	6a 78                	push   $0x78
  800991:	ff d6                	call   *%esi
			num = (unsigned long long)
  800993:	8b 45 14             	mov    0x14(%ebp),%eax
  800996:	8b 00                	mov    (%eax),%eax
  800998:	ba 00 00 00 00       	mov    $0x0,%edx
  80099d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009a0:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8009a3:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8009a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a9:	8d 40 04             	lea    0x4(%eax),%eax
  8009ac:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009af:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8009b4:	83 ec 0c             	sub    $0xc,%esp
  8009b7:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8009bb:	52                   	push   %edx
  8009bc:	ff 75 e0             	pushl  -0x20(%ebp)
  8009bf:	50                   	push   %eax
  8009c0:	ff 75 dc             	pushl  -0x24(%ebp)
  8009c3:	ff 75 d8             	pushl  -0x28(%ebp)
  8009c6:	89 da                	mov    %ebx,%edx
  8009c8:	89 f0                	mov    %esi,%eax
  8009ca:	e8 a4 fa ff ff       	call   800473 <printnum>
			break;
  8009cf:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8009d2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009d5:	83 c7 01             	add    $0x1,%edi
  8009d8:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8009dc:	83 f8 25             	cmp    $0x25,%eax
  8009df:	0f 84 be fb ff ff    	je     8005a3 <vprintfmt+0x17>
			if (ch == '\0')
  8009e5:	85 c0                	test   %eax,%eax
  8009e7:	0f 84 28 01 00 00    	je     800b15 <vprintfmt+0x589>
			putch(ch, putdat);
  8009ed:	83 ec 08             	sub    $0x8,%esp
  8009f0:	53                   	push   %ebx
  8009f1:	50                   	push   %eax
  8009f2:	ff d6                	call   *%esi
  8009f4:	83 c4 10             	add    $0x10,%esp
  8009f7:	eb dc                	jmp    8009d5 <vprintfmt+0x449>
	if (lflag >= 2)
  8009f9:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8009fd:	7f 26                	jg     800a25 <vprintfmt+0x499>
	else if (lflag)
  8009ff:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800a03:	74 41                	je     800a46 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800a05:	8b 45 14             	mov    0x14(%ebp),%eax
  800a08:	8b 00                	mov    (%eax),%eax
  800a0a:	ba 00 00 00 00       	mov    $0x0,%edx
  800a0f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a12:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a15:	8b 45 14             	mov    0x14(%ebp),%eax
  800a18:	8d 40 04             	lea    0x4(%eax),%eax
  800a1b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a1e:	b8 10 00 00 00       	mov    $0x10,%eax
  800a23:	eb 8f                	jmp    8009b4 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800a25:	8b 45 14             	mov    0x14(%ebp),%eax
  800a28:	8b 50 04             	mov    0x4(%eax),%edx
  800a2b:	8b 00                	mov    (%eax),%eax
  800a2d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a30:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a33:	8b 45 14             	mov    0x14(%ebp),%eax
  800a36:	8d 40 08             	lea    0x8(%eax),%eax
  800a39:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a3c:	b8 10 00 00 00       	mov    $0x10,%eax
  800a41:	e9 6e ff ff ff       	jmp    8009b4 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800a46:	8b 45 14             	mov    0x14(%ebp),%eax
  800a49:	8b 00                	mov    (%eax),%eax
  800a4b:	ba 00 00 00 00       	mov    $0x0,%edx
  800a50:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a53:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a56:	8b 45 14             	mov    0x14(%ebp),%eax
  800a59:	8d 40 04             	lea    0x4(%eax),%eax
  800a5c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a5f:	b8 10 00 00 00       	mov    $0x10,%eax
  800a64:	e9 4b ff ff ff       	jmp    8009b4 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800a69:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6c:	83 c0 04             	add    $0x4,%eax
  800a6f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a72:	8b 45 14             	mov    0x14(%ebp),%eax
  800a75:	8b 00                	mov    (%eax),%eax
  800a77:	85 c0                	test   %eax,%eax
  800a79:	74 14                	je     800a8f <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800a7b:	8b 13                	mov    (%ebx),%edx
  800a7d:	83 fa 7f             	cmp    $0x7f,%edx
  800a80:	7f 37                	jg     800ab9 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800a82:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800a84:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a87:	89 45 14             	mov    %eax,0x14(%ebp)
  800a8a:	e9 43 ff ff ff       	jmp    8009d2 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800a8f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a94:	bf 5d 2a 80 00       	mov    $0x802a5d,%edi
							putch(ch, putdat);
  800a99:	83 ec 08             	sub    $0x8,%esp
  800a9c:	53                   	push   %ebx
  800a9d:	50                   	push   %eax
  800a9e:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800aa0:	83 c7 01             	add    $0x1,%edi
  800aa3:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800aa7:	83 c4 10             	add    $0x10,%esp
  800aaa:	85 c0                	test   %eax,%eax
  800aac:	75 eb                	jne    800a99 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800aae:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800ab1:	89 45 14             	mov    %eax,0x14(%ebp)
  800ab4:	e9 19 ff ff ff       	jmp    8009d2 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800ab9:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800abb:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ac0:	bf 95 2a 80 00       	mov    $0x802a95,%edi
							putch(ch, putdat);
  800ac5:	83 ec 08             	sub    $0x8,%esp
  800ac8:	53                   	push   %ebx
  800ac9:	50                   	push   %eax
  800aca:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800acc:	83 c7 01             	add    $0x1,%edi
  800acf:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800ad3:	83 c4 10             	add    $0x10,%esp
  800ad6:	85 c0                	test   %eax,%eax
  800ad8:	75 eb                	jne    800ac5 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800ada:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800add:	89 45 14             	mov    %eax,0x14(%ebp)
  800ae0:	e9 ed fe ff ff       	jmp    8009d2 <vprintfmt+0x446>
			putch(ch, putdat);
  800ae5:	83 ec 08             	sub    $0x8,%esp
  800ae8:	53                   	push   %ebx
  800ae9:	6a 25                	push   $0x25
  800aeb:	ff d6                	call   *%esi
			break;
  800aed:	83 c4 10             	add    $0x10,%esp
  800af0:	e9 dd fe ff ff       	jmp    8009d2 <vprintfmt+0x446>
			putch('%', putdat);
  800af5:	83 ec 08             	sub    $0x8,%esp
  800af8:	53                   	push   %ebx
  800af9:	6a 25                	push   $0x25
  800afb:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800afd:	83 c4 10             	add    $0x10,%esp
  800b00:	89 f8                	mov    %edi,%eax
  800b02:	eb 03                	jmp    800b07 <vprintfmt+0x57b>
  800b04:	83 e8 01             	sub    $0x1,%eax
  800b07:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800b0b:	75 f7                	jne    800b04 <vprintfmt+0x578>
  800b0d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b10:	e9 bd fe ff ff       	jmp    8009d2 <vprintfmt+0x446>
}
  800b15:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b18:	5b                   	pop    %ebx
  800b19:	5e                   	pop    %esi
  800b1a:	5f                   	pop    %edi
  800b1b:	5d                   	pop    %ebp
  800b1c:	c3                   	ret    

00800b1d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b1d:	55                   	push   %ebp
  800b1e:	89 e5                	mov    %esp,%ebp
  800b20:	83 ec 18             	sub    $0x18,%esp
  800b23:	8b 45 08             	mov    0x8(%ebp),%eax
  800b26:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b29:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b2c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b30:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b33:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b3a:	85 c0                	test   %eax,%eax
  800b3c:	74 26                	je     800b64 <vsnprintf+0x47>
  800b3e:	85 d2                	test   %edx,%edx
  800b40:	7e 22                	jle    800b64 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b42:	ff 75 14             	pushl  0x14(%ebp)
  800b45:	ff 75 10             	pushl  0x10(%ebp)
  800b48:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b4b:	50                   	push   %eax
  800b4c:	68 52 05 80 00       	push   $0x800552
  800b51:	e8 36 fa ff ff       	call   80058c <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b59:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b5f:	83 c4 10             	add    $0x10,%esp
}
  800b62:	c9                   	leave  
  800b63:	c3                   	ret    
		return -E_INVAL;
  800b64:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b69:	eb f7                	jmp    800b62 <vsnprintf+0x45>

00800b6b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b6b:	55                   	push   %ebp
  800b6c:	89 e5                	mov    %esp,%ebp
  800b6e:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b71:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800b74:	50                   	push   %eax
  800b75:	ff 75 10             	pushl  0x10(%ebp)
  800b78:	ff 75 0c             	pushl  0xc(%ebp)
  800b7b:	ff 75 08             	pushl  0x8(%ebp)
  800b7e:	e8 9a ff ff ff       	call   800b1d <vsnprintf>
	va_end(ap);

	return rc;
}
  800b83:	c9                   	leave  
  800b84:	c3                   	ret    

00800b85 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  800b85:	55                   	push   %ebp
  800b86:	89 e5                	mov    %esp,%ebp
  800b88:	57                   	push   %edi
  800b89:	56                   	push   %esi
  800b8a:	53                   	push   %ebx
  800b8b:	83 ec 0c             	sub    $0xc,%esp
  800b8e:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  800b91:	85 c0                	test   %eax,%eax
  800b93:	74 13                	je     800ba8 <readline+0x23>
		fprintf(1, "%s", prompt);
  800b95:	83 ec 04             	sub    $0x4,%esp
  800b98:	50                   	push   %eax
  800b99:	68 91 2d 80 00       	push   $0x802d91
  800b9e:	6a 01                	push   $0x1
  800ba0:	e8 03 11 00 00       	call   801ca8 <fprintf>
  800ba5:	83 c4 10             	add    $0x10,%esp
#endif

	i = 0;
	echoing = iscons(0);
  800ba8:	83 ec 0c             	sub    $0xc,%esp
  800bab:	6a 00                	push   $0x0
  800bad:	e8 2a f6 ff ff       	call   8001dc <iscons>
  800bb2:	89 c7                	mov    %eax,%edi
  800bb4:	83 c4 10             	add    $0x10,%esp
	i = 0;
  800bb7:	be 00 00 00 00       	mov    $0x0,%esi
  800bbc:	eb 57                	jmp    800c15 <readline+0x90>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
  800bbe:	b8 00 00 00 00       	mov    $0x0,%eax
			if (c != -E_EOF)
  800bc3:	83 fb f8             	cmp    $0xfffffff8,%ebx
  800bc6:	75 08                	jne    800bd0 <readline+0x4b>
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
  800bc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bcb:	5b                   	pop    %ebx
  800bcc:	5e                   	pop    %esi
  800bcd:	5f                   	pop    %edi
  800bce:	5d                   	pop    %ebp
  800bcf:	c3                   	ret    
				cprintf("read error: %e\n", c);
  800bd0:	83 ec 08             	sub    $0x8,%esp
  800bd3:	53                   	push   %ebx
  800bd4:	68 a8 2c 80 00       	push   $0x802ca8
  800bd9:	e8 81 f8 ff ff       	call   80045f <cprintf>
  800bde:	83 c4 10             	add    $0x10,%esp
			return NULL;
  800be1:	b8 00 00 00 00       	mov    $0x0,%eax
  800be6:	eb e0                	jmp    800bc8 <readline+0x43>
			if (echoing)
  800be8:	85 ff                	test   %edi,%edi
  800bea:	75 05                	jne    800bf1 <readline+0x6c>
			i--;
  800bec:	83 ee 01             	sub    $0x1,%esi
  800bef:	eb 24                	jmp    800c15 <readline+0x90>
				cputchar('\b');
  800bf1:	83 ec 0c             	sub    $0xc,%esp
  800bf4:	6a 08                	push   $0x8
  800bf6:	e8 9c f5 ff ff       	call   800197 <cputchar>
  800bfb:	83 c4 10             	add    $0x10,%esp
  800bfe:	eb ec                	jmp    800bec <readline+0x67>
				cputchar(c);
  800c00:	83 ec 0c             	sub    $0xc,%esp
  800c03:	53                   	push   %ebx
  800c04:	e8 8e f5 ff ff       	call   800197 <cputchar>
  800c09:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800c0c:	88 9e 00 40 80 00    	mov    %bl,0x804000(%esi)
  800c12:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
  800c15:	e8 99 f5 ff ff       	call   8001b3 <getchar>
  800c1a:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  800c1c:	85 c0                	test   %eax,%eax
  800c1e:	78 9e                	js     800bbe <readline+0x39>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  800c20:	83 f8 08             	cmp    $0x8,%eax
  800c23:	0f 94 c2             	sete   %dl
  800c26:	83 f8 7f             	cmp    $0x7f,%eax
  800c29:	0f 94 c0             	sete   %al
  800c2c:	08 c2                	or     %al,%dl
  800c2e:	74 04                	je     800c34 <readline+0xaf>
  800c30:	85 f6                	test   %esi,%esi
  800c32:	7f b4                	jg     800be8 <readline+0x63>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800c34:	83 fb 1f             	cmp    $0x1f,%ebx
  800c37:	7e 0e                	jle    800c47 <readline+0xc2>
  800c39:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  800c3f:	7f 06                	jg     800c47 <readline+0xc2>
			if (echoing)
  800c41:	85 ff                	test   %edi,%edi
  800c43:	74 c7                	je     800c0c <readline+0x87>
  800c45:	eb b9                	jmp    800c00 <readline+0x7b>
		} else if (c == '\n' || c == '\r') {
  800c47:	83 fb 0a             	cmp    $0xa,%ebx
  800c4a:	74 05                	je     800c51 <readline+0xcc>
  800c4c:	83 fb 0d             	cmp    $0xd,%ebx
  800c4f:	75 c4                	jne    800c15 <readline+0x90>
			if (echoing)
  800c51:	85 ff                	test   %edi,%edi
  800c53:	75 11                	jne    800c66 <readline+0xe1>
			buf[i] = 0;
  800c55:	c6 86 00 40 80 00 00 	movb   $0x0,0x804000(%esi)
			return buf;
  800c5c:	b8 00 40 80 00       	mov    $0x804000,%eax
  800c61:	e9 62 ff ff ff       	jmp    800bc8 <readline+0x43>
				cputchar('\n');
  800c66:	83 ec 0c             	sub    $0xc,%esp
  800c69:	6a 0a                	push   $0xa
  800c6b:	e8 27 f5 ff ff       	call   800197 <cputchar>
  800c70:	83 c4 10             	add    $0x10,%esp
  800c73:	eb e0                	jmp    800c55 <readline+0xd0>

00800c75 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800c75:	55                   	push   %ebp
  800c76:	89 e5                	mov    %esp,%ebp
  800c78:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800c7b:	b8 00 00 00 00       	mov    $0x0,%eax
  800c80:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800c84:	74 05                	je     800c8b <strlen+0x16>
		n++;
  800c86:	83 c0 01             	add    $0x1,%eax
  800c89:	eb f5                	jmp    800c80 <strlen+0xb>
	return n;
}
  800c8b:	5d                   	pop    %ebp
  800c8c:	c3                   	ret    

00800c8d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800c8d:	55                   	push   %ebp
  800c8e:	89 e5                	mov    %esp,%ebp
  800c90:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c93:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c96:	ba 00 00 00 00       	mov    $0x0,%edx
  800c9b:	39 c2                	cmp    %eax,%edx
  800c9d:	74 0d                	je     800cac <strnlen+0x1f>
  800c9f:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800ca3:	74 05                	je     800caa <strnlen+0x1d>
		n++;
  800ca5:	83 c2 01             	add    $0x1,%edx
  800ca8:	eb f1                	jmp    800c9b <strnlen+0xe>
  800caa:	89 d0                	mov    %edx,%eax
	return n;
}
  800cac:	5d                   	pop    %ebp
  800cad:	c3                   	ret    

00800cae <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cae:	55                   	push   %ebp
  800caf:	89 e5                	mov    %esp,%ebp
  800cb1:	53                   	push   %ebx
  800cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800cb8:	ba 00 00 00 00       	mov    $0x0,%edx
  800cbd:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800cc1:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800cc4:	83 c2 01             	add    $0x1,%edx
  800cc7:	84 c9                	test   %cl,%cl
  800cc9:	75 f2                	jne    800cbd <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800ccb:	5b                   	pop    %ebx
  800ccc:	5d                   	pop    %ebp
  800ccd:	c3                   	ret    

00800cce <strcat>:

char *
strcat(char *dst, const char *src)
{
  800cce:	55                   	push   %ebp
  800ccf:	89 e5                	mov    %esp,%ebp
  800cd1:	53                   	push   %ebx
  800cd2:	83 ec 10             	sub    $0x10,%esp
  800cd5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800cd8:	53                   	push   %ebx
  800cd9:	e8 97 ff ff ff       	call   800c75 <strlen>
  800cde:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800ce1:	ff 75 0c             	pushl  0xc(%ebp)
  800ce4:	01 d8                	add    %ebx,%eax
  800ce6:	50                   	push   %eax
  800ce7:	e8 c2 ff ff ff       	call   800cae <strcpy>
	return dst;
}
  800cec:	89 d8                	mov    %ebx,%eax
  800cee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cf1:	c9                   	leave  
  800cf2:	c3                   	ret    

00800cf3 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800cf3:	55                   	push   %ebp
  800cf4:	89 e5                	mov    %esp,%ebp
  800cf6:	56                   	push   %esi
  800cf7:	53                   	push   %ebx
  800cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cfe:	89 c6                	mov    %eax,%esi
  800d00:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d03:	89 c2                	mov    %eax,%edx
  800d05:	39 f2                	cmp    %esi,%edx
  800d07:	74 11                	je     800d1a <strncpy+0x27>
		*dst++ = *src;
  800d09:	83 c2 01             	add    $0x1,%edx
  800d0c:	0f b6 19             	movzbl (%ecx),%ebx
  800d0f:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800d12:	80 fb 01             	cmp    $0x1,%bl
  800d15:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800d18:	eb eb                	jmp    800d05 <strncpy+0x12>
	}
	return ret;
}
  800d1a:	5b                   	pop    %ebx
  800d1b:	5e                   	pop    %esi
  800d1c:	5d                   	pop    %ebp
  800d1d:	c3                   	ret    

00800d1e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800d1e:	55                   	push   %ebp
  800d1f:	89 e5                	mov    %esp,%ebp
  800d21:	56                   	push   %esi
  800d22:	53                   	push   %ebx
  800d23:	8b 75 08             	mov    0x8(%ebp),%esi
  800d26:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d29:	8b 55 10             	mov    0x10(%ebp),%edx
  800d2c:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800d2e:	85 d2                	test   %edx,%edx
  800d30:	74 21                	je     800d53 <strlcpy+0x35>
  800d32:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800d36:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800d38:	39 c2                	cmp    %eax,%edx
  800d3a:	74 14                	je     800d50 <strlcpy+0x32>
  800d3c:	0f b6 19             	movzbl (%ecx),%ebx
  800d3f:	84 db                	test   %bl,%bl
  800d41:	74 0b                	je     800d4e <strlcpy+0x30>
			*dst++ = *src++;
  800d43:	83 c1 01             	add    $0x1,%ecx
  800d46:	83 c2 01             	add    $0x1,%edx
  800d49:	88 5a ff             	mov    %bl,-0x1(%edx)
  800d4c:	eb ea                	jmp    800d38 <strlcpy+0x1a>
  800d4e:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800d50:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d53:	29 f0                	sub    %esi,%eax
}
  800d55:	5b                   	pop    %ebx
  800d56:	5e                   	pop    %esi
  800d57:	5d                   	pop    %ebp
  800d58:	c3                   	ret    

00800d59 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d59:	55                   	push   %ebp
  800d5a:	89 e5                	mov    %esp,%ebp
  800d5c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d5f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800d62:	0f b6 01             	movzbl (%ecx),%eax
  800d65:	84 c0                	test   %al,%al
  800d67:	74 0c                	je     800d75 <strcmp+0x1c>
  800d69:	3a 02                	cmp    (%edx),%al
  800d6b:	75 08                	jne    800d75 <strcmp+0x1c>
		p++, q++;
  800d6d:	83 c1 01             	add    $0x1,%ecx
  800d70:	83 c2 01             	add    $0x1,%edx
  800d73:	eb ed                	jmp    800d62 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d75:	0f b6 c0             	movzbl %al,%eax
  800d78:	0f b6 12             	movzbl (%edx),%edx
  800d7b:	29 d0                	sub    %edx,%eax
}
  800d7d:	5d                   	pop    %ebp
  800d7e:	c3                   	ret    

00800d7f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800d7f:	55                   	push   %ebp
  800d80:	89 e5                	mov    %esp,%ebp
  800d82:	53                   	push   %ebx
  800d83:	8b 45 08             	mov    0x8(%ebp),%eax
  800d86:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d89:	89 c3                	mov    %eax,%ebx
  800d8b:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800d8e:	eb 06                	jmp    800d96 <strncmp+0x17>
		n--, p++, q++;
  800d90:	83 c0 01             	add    $0x1,%eax
  800d93:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800d96:	39 d8                	cmp    %ebx,%eax
  800d98:	74 16                	je     800db0 <strncmp+0x31>
  800d9a:	0f b6 08             	movzbl (%eax),%ecx
  800d9d:	84 c9                	test   %cl,%cl
  800d9f:	74 04                	je     800da5 <strncmp+0x26>
  800da1:	3a 0a                	cmp    (%edx),%cl
  800da3:	74 eb                	je     800d90 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800da5:	0f b6 00             	movzbl (%eax),%eax
  800da8:	0f b6 12             	movzbl (%edx),%edx
  800dab:	29 d0                	sub    %edx,%eax
}
  800dad:	5b                   	pop    %ebx
  800dae:	5d                   	pop    %ebp
  800daf:	c3                   	ret    
		return 0;
  800db0:	b8 00 00 00 00       	mov    $0x0,%eax
  800db5:	eb f6                	jmp    800dad <strncmp+0x2e>

00800db7 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800db7:	55                   	push   %ebp
  800db8:	89 e5                	mov    %esp,%ebp
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbd:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800dc1:	0f b6 10             	movzbl (%eax),%edx
  800dc4:	84 d2                	test   %dl,%dl
  800dc6:	74 09                	je     800dd1 <strchr+0x1a>
		if (*s == c)
  800dc8:	38 ca                	cmp    %cl,%dl
  800dca:	74 0a                	je     800dd6 <strchr+0x1f>
	for (; *s; s++)
  800dcc:	83 c0 01             	add    $0x1,%eax
  800dcf:	eb f0                	jmp    800dc1 <strchr+0xa>
			return (char *) s;
	return 0;
  800dd1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dd6:	5d                   	pop    %ebp
  800dd7:	c3                   	ret    

00800dd8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dd8:	55                   	push   %ebp
  800dd9:	89 e5                	mov    %esp,%ebp
  800ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dde:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800de2:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800de5:	38 ca                	cmp    %cl,%dl
  800de7:	74 09                	je     800df2 <strfind+0x1a>
  800de9:	84 d2                	test   %dl,%dl
  800deb:	74 05                	je     800df2 <strfind+0x1a>
	for (; *s; s++)
  800ded:	83 c0 01             	add    $0x1,%eax
  800df0:	eb f0                	jmp    800de2 <strfind+0xa>
			break;
	return (char *) s;
}
  800df2:	5d                   	pop    %ebp
  800df3:	c3                   	ret    

00800df4 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800df4:	55                   	push   %ebp
  800df5:	89 e5                	mov    %esp,%ebp
  800df7:	57                   	push   %edi
  800df8:	56                   	push   %esi
  800df9:	53                   	push   %ebx
  800dfa:	8b 7d 08             	mov    0x8(%ebp),%edi
  800dfd:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800e00:	85 c9                	test   %ecx,%ecx
  800e02:	74 31                	je     800e35 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800e04:	89 f8                	mov    %edi,%eax
  800e06:	09 c8                	or     %ecx,%eax
  800e08:	a8 03                	test   $0x3,%al
  800e0a:	75 23                	jne    800e2f <memset+0x3b>
		c &= 0xFF;
  800e0c:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800e10:	89 d3                	mov    %edx,%ebx
  800e12:	c1 e3 08             	shl    $0x8,%ebx
  800e15:	89 d0                	mov    %edx,%eax
  800e17:	c1 e0 18             	shl    $0x18,%eax
  800e1a:	89 d6                	mov    %edx,%esi
  800e1c:	c1 e6 10             	shl    $0x10,%esi
  800e1f:	09 f0                	or     %esi,%eax
  800e21:	09 c2                	or     %eax,%edx
  800e23:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800e25:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800e28:	89 d0                	mov    %edx,%eax
  800e2a:	fc                   	cld    
  800e2b:	f3 ab                	rep stos %eax,%es:(%edi)
  800e2d:	eb 06                	jmp    800e35 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800e2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e32:	fc                   	cld    
  800e33:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800e35:	89 f8                	mov    %edi,%eax
  800e37:	5b                   	pop    %ebx
  800e38:	5e                   	pop    %esi
  800e39:	5f                   	pop    %edi
  800e3a:	5d                   	pop    %ebp
  800e3b:	c3                   	ret    

00800e3c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800e3c:	55                   	push   %ebp
  800e3d:	89 e5                	mov    %esp,%ebp
  800e3f:	57                   	push   %edi
  800e40:	56                   	push   %esi
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
  800e44:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e47:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e4a:	39 c6                	cmp    %eax,%esi
  800e4c:	73 32                	jae    800e80 <memmove+0x44>
  800e4e:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800e51:	39 c2                	cmp    %eax,%edx
  800e53:	76 2b                	jbe    800e80 <memmove+0x44>
		s += n;
		d += n;
  800e55:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e58:	89 fe                	mov    %edi,%esi
  800e5a:	09 ce                	or     %ecx,%esi
  800e5c:	09 d6                	or     %edx,%esi
  800e5e:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800e64:	75 0e                	jne    800e74 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800e66:	83 ef 04             	sub    $0x4,%edi
  800e69:	8d 72 fc             	lea    -0x4(%edx),%esi
  800e6c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800e6f:	fd                   	std    
  800e70:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e72:	eb 09                	jmp    800e7d <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800e74:	83 ef 01             	sub    $0x1,%edi
  800e77:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800e7a:	fd                   	std    
  800e7b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800e7d:	fc                   	cld    
  800e7e:	eb 1a                	jmp    800e9a <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e80:	89 c2                	mov    %eax,%edx
  800e82:	09 ca                	or     %ecx,%edx
  800e84:	09 f2                	or     %esi,%edx
  800e86:	f6 c2 03             	test   $0x3,%dl
  800e89:	75 0a                	jne    800e95 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800e8b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800e8e:	89 c7                	mov    %eax,%edi
  800e90:	fc                   	cld    
  800e91:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e93:	eb 05                	jmp    800e9a <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800e95:	89 c7                	mov    %eax,%edi
  800e97:	fc                   	cld    
  800e98:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800e9a:	5e                   	pop    %esi
  800e9b:	5f                   	pop    %edi
  800e9c:	5d                   	pop    %ebp
  800e9d:	c3                   	ret    

00800e9e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e9e:	55                   	push   %ebp
  800e9f:	89 e5                	mov    %esp,%ebp
  800ea1:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ea4:	ff 75 10             	pushl  0x10(%ebp)
  800ea7:	ff 75 0c             	pushl  0xc(%ebp)
  800eaa:	ff 75 08             	pushl  0x8(%ebp)
  800ead:	e8 8a ff ff ff       	call   800e3c <memmove>
}
  800eb2:	c9                   	leave  
  800eb3:	c3                   	ret    

00800eb4 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800eb4:	55                   	push   %ebp
  800eb5:	89 e5                	mov    %esp,%ebp
  800eb7:	56                   	push   %esi
  800eb8:	53                   	push   %ebx
  800eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ebf:	89 c6                	mov    %eax,%esi
  800ec1:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ec4:	39 f0                	cmp    %esi,%eax
  800ec6:	74 1c                	je     800ee4 <memcmp+0x30>
		if (*s1 != *s2)
  800ec8:	0f b6 08             	movzbl (%eax),%ecx
  800ecb:	0f b6 1a             	movzbl (%edx),%ebx
  800ece:	38 d9                	cmp    %bl,%cl
  800ed0:	75 08                	jne    800eda <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800ed2:	83 c0 01             	add    $0x1,%eax
  800ed5:	83 c2 01             	add    $0x1,%edx
  800ed8:	eb ea                	jmp    800ec4 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800eda:	0f b6 c1             	movzbl %cl,%eax
  800edd:	0f b6 db             	movzbl %bl,%ebx
  800ee0:	29 d8                	sub    %ebx,%eax
  800ee2:	eb 05                	jmp    800ee9 <memcmp+0x35>
	}

	return 0;
  800ee4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ee9:	5b                   	pop    %ebx
  800eea:	5e                   	pop    %esi
  800eeb:	5d                   	pop    %ebp
  800eec:	c3                   	ret    

00800eed <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800eed:	55                   	push   %ebp
  800eee:	89 e5                	mov    %esp,%ebp
  800ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ef6:	89 c2                	mov    %eax,%edx
  800ef8:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800efb:	39 d0                	cmp    %edx,%eax
  800efd:	73 09                	jae    800f08 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800eff:	38 08                	cmp    %cl,(%eax)
  800f01:	74 05                	je     800f08 <memfind+0x1b>
	for (; s < ends; s++)
  800f03:	83 c0 01             	add    $0x1,%eax
  800f06:	eb f3                	jmp    800efb <memfind+0xe>
			break;
	return (void *) s;
}
  800f08:	5d                   	pop    %ebp
  800f09:	c3                   	ret    

00800f0a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f0a:	55                   	push   %ebp
  800f0b:	89 e5                	mov    %esp,%ebp
  800f0d:	57                   	push   %edi
  800f0e:	56                   	push   %esi
  800f0f:	53                   	push   %ebx
  800f10:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f13:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f16:	eb 03                	jmp    800f1b <strtol+0x11>
		s++;
  800f18:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800f1b:	0f b6 01             	movzbl (%ecx),%eax
  800f1e:	3c 20                	cmp    $0x20,%al
  800f20:	74 f6                	je     800f18 <strtol+0xe>
  800f22:	3c 09                	cmp    $0x9,%al
  800f24:	74 f2                	je     800f18 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800f26:	3c 2b                	cmp    $0x2b,%al
  800f28:	74 2a                	je     800f54 <strtol+0x4a>
	int neg = 0;
  800f2a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800f2f:	3c 2d                	cmp    $0x2d,%al
  800f31:	74 2b                	je     800f5e <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f33:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800f39:	75 0f                	jne    800f4a <strtol+0x40>
  800f3b:	80 39 30             	cmpb   $0x30,(%ecx)
  800f3e:	74 28                	je     800f68 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800f40:	85 db                	test   %ebx,%ebx
  800f42:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f47:	0f 44 d8             	cmove  %eax,%ebx
  800f4a:	b8 00 00 00 00       	mov    $0x0,%eax
  800f4f:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800f52:	eb 50                	jmp    800fa4 <strtol+0x9a>
		s++;
  800f54:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800f57:	bf 00 00 00 00       	mov    $0x0,%edi
  800f5c:	eb d5                	jmp    800f33 <strtol+0x29>
		s++, neg = 1;
  800f5e:	83 c1 01             	add    $0x1,%ecx
  800f61:	bf 01 00 00 00       	mov    $0x1,%edi
  800f66:	eb cb                	jmp    800f33 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f68:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800f6c:	74 0e                	je     800f7c <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800f6e:	85 db                	test   %ebx,%ebx
  800f70:	75 d8                	jne    800f4a <strtol+0x40>
		s++, base = 8;
  800f72:	83 c1 01             	add    $0x1,%ecx
  800f75:	bb 08 00 00 00       	mov    $0x8,%ebx
  800f7a:	eb ce                	jmp    800f4a <strtol+0x40>
		s += 2, base = 16;
  800f7c:	83 c1 02             	add    $0x2,%ecx
  800f7f:	bb 10 00 00 00       	mov    $0x10,%ebx
  800f84:	eb c4                	jmp    800f4a <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800f86:	8d 72 9f             	lea    -0x61(%edx),%esi
  800f89:	89 f3                	mov    %esi,%ebx
  800f8b:	80 fb 19             	cmp    $0x19,%bl
  800f8e:	77 29                	ja     800fb9 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800f90:	0f be d2             	movsbl %dl,%edx
  800f93:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800f96:	3b 55 10             	cmp    0x10(%ebp),%edx
  800f99:	7d 30                	jge    800fcb <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800f9b:	83 c1 01             	add    $0x1,%ecx
  800f9e:	0f af 45 10          	imul   0x10(%ebp),%eax
  800fa2:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800fa4:	0f b6 11             	movzbl (%ecx),%edx
  800fa7:	8d 72 d0             	lea    -0x30(%edx),%esi
  800faa:	89 f3                	mov    %esi,%ebx
  800fac:	80 fb 09             	cmp    $0x9,%bl
  800faf:	77 d5                	ja     800f86 <strtol+0x7c>
			dig = *s - '0';
  800fb1:	0f be d2             	movsbl %dl,%edx
  800fb4:	83 ea 30             	sub    $0x30,%edx
  800fb7:	eb dd                	jmp    800f96 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800fb9:	8d 72 bf             	lea    -0x41(%edx),%esi
  800fbc:	89 f3                	mov    %esi,%ebx
  800fbe:	80 fb 19             	cmp    $0x19,%bl
  800fc1:	77 08                	ja     800fcb <strtol+0xc1>
			dig = *s - 'A' + 10;
  800fc3:	0f be d2             	movsbl %dl,%edx
  800fc6:	83 ea 37             	sub    $0x37,%edx
  800fc9:	eb cb                	jmp    800f96 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800fcb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fcf:	74 05                	je     800fd6 <strtol+0xcc>
		*endptr = (char *) s;
  800fd1:	8b 75 0c             	mov    0xc(%ebp),%esi
  800fd4:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800fd6:	89 c2                	mov    %eax,%edx
  800fd8:	f7 da                	neg    %edx
  800fda:	85 ff                	test   %edi,%edi
  800fdc:	0f 45 c2             	cmovne %edx,%eax
}
  800fdf:	5b                   	pop    %ebx
  800fe0:	5e                   	pop    %esi
  800fe1:	5f                   	pop    %edi
  800fe2:	5d                   	pop    %ebp
  800fe3:	c3                   	ret    

00800fe4 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800fe4:	55                   	push   %ebp
  800fe5:	89 e5                	mov    %esp,%ebp
  800fe7:	57                   	push   %edi
  800fe8:	56                   	push   %esi
  800fe9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fea:	b8 00 00 00 00       	mov    $0x0,%eax
  800fef:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff5:	89 c3                	mov    %eax,%ebx
  800ff7:	89 c7                	mov    %eax,%edi
  800ff9:	89 c6                	mov    %eax,%esi
  800ffb:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ffd:	5b                   	pop    %ebx
  800ffe:	5e                   	pop    %esi
  800fff:	5f                   	pop    %edi
  801000:	5d                   	pop    %ebp
  801001:	c3                   	ret    

00801002 <sys_cgetc>:

int
sys_cgetc(void)
{
  801002:	55                   	push   %ebp
  801003:	89 e5                	mov    %esp,%ebp
  801005:	57                   	push   %edi
  801006:	56                   	push   %esi
  801007:	53                   	push   %ebx
	asm volatile("int %1\n"
  801008:	ba 00 00 00 00       	mov    $0x0,%edx
  80100d:	b8 01 00 00 00       	mov    $0x1,%eax
  801012:	89 d1                	mov    %edx,%ecx
  801014:	89 d3                	mov    %edx,%ebx
  801016:	89 d7                	mov    %edx,%edi
  801018:	89 d6                	mov    %edx,%esi
  80101a:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80101c:	5b                   	pop    %ebx
  80101d:	5e                   	pop    %esi
  80101e:	5f                   	pop    %edi
  80101f:	5d                   	pop    %ebp
  801020:	c3                   	ret    

00801021 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801021:	55                   	push   %ebp
  801022:	89 e5                	mov    %esp,%ebp
  801024:	57                   	push   %edi
  801025:	56                   	push   %esi
  801026:	53                   	push   %ebx
  801027:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80102a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80102f:	8b 55 08             	mov    0x8(%ebp),%edx
  801032:	b8 03 00 00 00       	mov    $0x3,%eax
  801037:	89 cb                	mov    %ecx,%ebx
  801039:	89 cf                	mov    %ecx,%edi
  80103b:	89 ce                	mov    %ecx,%esi
  80103d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80103f:	85 c0                	test   %eax,%eax
  801041:	7f 08                	jg     80104b <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801043:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801046:	5b                   	pop    %ebx
  801047:	5e                   	pop    %esi
  801048:	5f                   	pop    %edi
  801049:	5d                   	pop    %ebp
  80104a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80104b:	83 ec 0c             	sub    $0xc,%esp
  80104e:	50                   	push   %eax
  80104f:	6a 03                	push   $0x3
  801051:	68 b8 2c 80 00       	push   $0x802cb8
  801056:	6a 43                	push   $0x43
  801058:	68 d5 2c 80 00       	push   $0x802cd5
  80105d:	e8 07 f3 ff ff       	call   800369 <_panic>

00801062 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801062:	55                   	push   %ebp
  801063:	89 e5                	mov    %esp,%ebp
  801065:	57                   	push   %edi
  801066:	56                   	push   %esi
  801067:	53                   	push   %ebx
	asm volatile("int %1\n"
  801068:	ba 00 00 00 00       	mov    $0x0,%edx
  80106d:	b8 02 00 00 00       	mov    $0x2,%eax
  801072:	89 d1                	mov    %edx,%ecx
  801074:	89 d3                	mov    %edx,%ebx
  801076:	89 d7                	mov    %edx,%edi
  801078:	89 d6                	mov    %edx,%esi
  80107a:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80107c:	5b                   	pop    %ebx
  80107d:	5e                   	pop    %esi
  80107e:	5f                   	pop    %edi
  80107f:	5d                   	pop    %ebp
  801080:	c3                   	ret    

00801081 <sys_yield>:

void
sys_yield(void)
{
  801081:	55                   	push   %ebp
  801082:	89 e5                	mov    %esp,%ebp
  801084:	57                   	push   %edi
  801085:	56                   	push   %esi
  801086:	53                   	push   %ebx
	asm volatile("int %1\n"
  801087:	ba 00 00 00 00       	mov    $0x0,%edx
  80108c:	b8 0b 00 00 00       	mov    $0xb,%eax
  801091:	89 d1                	mov    %edx,%ecx
  801093:	89 d3                	mov    %edx,%ebx
  801095:	89 d7                	mov    %edx,%edi
  801097:	89 d6                	mov    %edx,%esi
  801099:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80109b:	5b                   	pop    %ebx
  80109c:	5e                   	pop    %esi
  80109d:	5f                   	pop    %edi
  80109e:	5d                   	pop    %ebp
  80109f:	c3                   	ret    

008010a0 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8010a0:	55                   	push   %ebp
  8010a1:	89 e5                	mov    %esp,%ebp
  8010a3:	57                   	push   %edi
  8010a4:	56                   	push   %esi
  8010a5:	53                   	push   %ebx
  8010a6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010a9:	be 00 00 00 00       	mov    $0x0,%esi
  8010ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010b4:	b8 04 00 00 00       	mov    $0x4,%eax
  8010b9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010bc:	89 f7                	mov    %esi,%edi
  8010be:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010c0:	85 c0                	test   %eax,%eax
  8010c2:	7f 08                	jg     8010cc <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
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
  8010d0:	6a 04                	push   $0x4
  8010d2:	68 b8 2c 80 00       	push   $0x802cb8
  8010d7:	6a 43                	push   $0x43
  8010d9:	68 d5 2c 80 00       	push   $0x802cd5
  8010de:	e8 86 f2 ff ff       	call   800369 <_panic>

008010e3 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8010e3:	55                   	push   %ebp
  8010e4:	89 e5                	mov    %esp,%ebp
  8010e6:	57                   	push   %edi
  8010e7:	56                   	push   %esi
  8010e8:	53                   	push   %ebx
  8010e9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010f2:	b8 05 00 00 00       	mov    $0x5,%eax
  8010f7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010fa:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010fd:	8b 75 18             	mov    0x18(%ebp),%esi
  801100:	cd 30                	int    $0x30
	if(check && ret > 0)
  801102:	85 c0                	test   %eax,%eax
  801104:	7f 08                	jg     80110e <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
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
  801112:	6a 05                	push   $0x5
  801114:	68 b8 2c 80 00       	push   $0x802cb8
  801119:	6a 43                	push   $0x43
  80111b:	68 d5 2c 80 00       	push   $0x802cd5
  801120:	e8 44 f2 ff ff       	call   800369 <_panic>

00801125 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
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
  801139:	b8 06 00 00 00       	mov    $0x6,%eax
  80113e:	89 df                	mov    %ebx,%edi
  801140:	89 de                	mov    %ebx,%esi
  801142:	cd 30                	int    $0x30
	if(check && ret > 0)
  801144:	85 c0                	test   %eax,%eax
  801146:	7f 08                	jg     801150 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
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
  801154:	6a 06                	push   $0x6
  801156:	68 b8 2c 80 00       	push   $0x802cb8
  80115b:	6a 43                	push   $0x43
  80115d:	68 d5 2c 80 00       	push   $0x802cd5
  801162:	e8 02 f2 ff ff       	call   800369 <_panic>

00801167 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
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
  80117b:	b8 08 00 00 00       	mov    $0x8,%eax
  801180:	89 df                	mov    %ebx,%edi
  801182:	89 de                	mov    %ebx,%esi
  801184:	cd 30                	int    $0x30
	if(check && ret > 0)
  801186:	85 c0                	test   %eax,%eax
  801188:	7f 08                	jg     801192 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
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
  801196:	6a 08                	push   $0x8
  801198:	68 b8 2c 80 00       	push   $0x802cb8
  80119d:	6a 43                	push   $0x43
  80119f:	68 d5 2c 80 00       	push   $0x802cd5
  8011a4:	e8 c0 f1 ff ff       	call   800369 <_panic>

008011a9 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8011a9:	55                   	push   %ebp
  8011aa:	89 e5                	mov    %esp,%ebp
  8011ac:	57                   	push   %edi
  8011ad:	56                   	push   %esi
  8011ae:	53                   	push   %ebx
  8011af:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011b2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011bd:	b8 09 00 00 00       	mov    $0x9,%eax
  8011c2:	89 df                	mov    %ebx,%edi
  8011c4:	89 de                	mov    %ebx,%esi
  8011c6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011c8:	85 c0                	test   %eax,%eax
  8011ca:	7f 08                	jg     8011d4 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8011cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011cf:	5b                   	pop    %ebx
  8011d0:	5e                   	pop    %esi
  8011d1:	5f                   	pop    %edi
  8011d2:	5d                   	pop    %ebp
  8011d3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011d4:	83 ec 0c             	sub    $0xc,%esp
  8011d7:	50                   	push   %eax
  8011d8:	6a 09                	push   $0x9
  8011da:	68 b8 2c 80 00       	push   $0x802cb8
  8011df:	6a 43                	push   $0x43
  8011e1:	68 d5 2c 80 00       	push   $0x802cd5
  8011e6:	e8 7e f1 ff ff       	call   800369 <_panic>

008011eb <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8011eb:	55                   	push   %ebp
  8011ec:	89 e5                	mov    %esp,%ebp
  8011ee:	57                   	push   %edi
  8011ef:	56                   	push   %esi
  8011f0:	53                   	push   %ebx
  8011f1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011f4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8011fc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011ff:	b8 0a 00 00 00       	mov    $0xa,%eax
  801204:	89 df                	mov    %ebx,%edi
  801206:	89 de                	mov    %ebx,%esi
  801208:	cd 30                	int    $0x30
	if(check && ret > 0)
  80120a:	85 c0                	test   %eax,%eax
  80120c:	7f 08                	jg     801216 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80120e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801211:	5b                   	pop    %ebx
  801212:	5e                   	pop    %esi
  801213:	5f                   	pop    %edi
  801214:	5d                   	pop    %ebp
  801215:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801216:	83 ec 0c             	sub    $0xc,%esp
  801219:	50                   	push   %eax
  80121a:	6a 0a                	push   $0xa
  80121c:	68 b8 2c 80 00       	push   $0x802cb8
  801221:	6a 43                	push   $0x43
  801223:	68 d5 2c 80 00       	push   $0x802cd5
  801228:	e8 3c f1 ff ff       	call   800369 <_panic>

0080122d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80122d:	55                   	push   %ebp
  80122e:	89 e5                	mov    %esp,%ebp
  801230:	57                   	push   %edi
  801231:	56                   	push   %esi
  801232:	53                   	push   %ebx
	asm volatile("int %1\n"
  801233:	8b 55 08             	mov    0x8(%ebp),%edx
  801236:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801239:	b8 0c 00 00 00       	mov    $0xc,%eax
  80123e:	be 00 00 00 00       	mov    $0x0,%esi
  801243:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801246:	8b 7d 14             	mov    0x14(%ebp),%edi
  801249:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80124b:	5b                   	pop    %ebx
  80124c:	5e                   	pop    %esi
  80124d:	5f                   	pop    %edi
  80124e:	5d                   	pop    %ebp
  80124f:	c3                   	ret    

00801250 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801250:	55                   	push   %ebp
  801251:	89 e5                	mov    %esp,%ebp
  801253:	57                   	push   %edi
  801254:	56                   	push   %esi
  801255:	53                   	push   %ebx
  801256:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801259:	b9 00 00 00 00       	mov    $0x0,%ecx
  80125e:	8b 55 08             	mov    0x8(%ebp),%edx
  801261:	b8 0d 00 00 00       	mov    $0xd,%eax
  801266:	89 cb                	mov    %ecx,%ebx
  801268:	89 cf                	mov    %ecx,%edi
  80126a:	89 ce                	mov    %ecx,%esi
  80126c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80126e:	85 c0                	test   %eax,%eax
  801270:	7f 08                	jg     80127a <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801272:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801275:	5b                   	pop    %ebx
  801276:	5e                   	pop    %esi
  801277:	5f                   	pop    %edi
  801278:	5d                   	pop    %ebp
  801279:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80127a:	83 ec 0c             	sub    $0xc,%esp
  80127d:	50                   	push   %eax
  80127e:	6a 0d                	push   $0xd
  801280:	68 b8 2c 80 00       	push   $0x802cb8
  801285:	6a 43                	push   $0x43
  801287:	68 d5 2c 80 00       	push   $0x802cd5
  80128c:	e8 d8 f0 ff ff       	call   800369 <_panic>

00801291 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801291:	55                   	push   %ebp
  801292:	89 e5                	mov    %esp,%ebp
  801294:	57                   	push   %edi
  801295:	56                   	push   %esi
  801296:	53                   	push   %ebx
	asm volatile("int %1\n"
  801297:	bb 00 00 00 00       	mov    $0x0,%ebx
  80129c:	8b 55 08             	mov    0x8(%ebp),%edx
  80129f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012a2:	b8 0e 00 00 00       	mov    $0xe,%eax
  8012a7:	89 df                	mov    %ebx,%edi
  8012a9:	89 de                	mov    %ebx,%esi
  8012ab:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8012ad:	5b                   	pop    %ebx
  8012ae:	5e                   	pop    %esi
  8012af:	5f                   	pop    %edi
  8012b0:	5d                   	pop    %ebp
  8012b1:	c3                   	ret    

008012b2 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8012b2:	55                   	push   %ebp
  8012b3:	89 e5                	mov    %esp,%ebp
  8012b5:	57                   	push   %edi
  8012b6:	56                   	push   %esi
  8012b7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8012b8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8012c0:	b8 0f 00 00 00       	mov    $0xf,%eax
  8012c5:	89 cb                	mov    %ecx,%ebx
  8012c7:	89 cf                	mov    %ecx,%edi
  8012c9:	89 ce                	mov    %ecx,%esi
  8012cb:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8012cd:	5b                   	pop    %ebx
  8012ce:	5e                   	pop    %esi
  8012cf:	5f                   	pop    %edi
  8012d0:	5d                   	pop    %ebp
  8012d1:	c3                   	ret    

008012d2 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8012d2:	55                   	push   %ebp
  8012d3:	89 e5                	mov    %esp,%ebp
  8012d5:	57                   	push   %edi
  8012d6:	56                   	push   %esi
  8012d7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8012d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8012dd:	b8 10 00 00 00       	mov    $0x10,%eax
  8012e2:	89 d1                	mov    %edx,%ecx
  8012e4:	89 d3                	mov    %edx,%ebx
  8012e6:	89 d7                	mov    %edx,%edi
  8012e8:	89 d6                	mov    %edx,%esi
  8012ea:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8012ec:	5b                   	pop    %ebx
  8012ed:	5e                   	pop    %esi
  8012ee:	5f                   	pop    %edi
  8012ef:	5d                   	pop    %ebp
  8012f0:	c3                   	ret    

008012f1 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  8012f1:	55                   	push   %ebp
  8012f2:	89 e5                	mov    %esp,%ebp
  8012f4:	57                   	push   %edi
  8012f5:	56                   	push   %esi
  8012f6:	53                   	push   %ebx
	asm volatile("int %1\n"
  8012f7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8012ff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801302:	b8 11 00 00 00       	mov    $0x11,%eax
  801307:	89 df                	mov    %ebx,%edi
  801309:	89 de                	mov    %ebx,%esi
  80130b:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80130d:	5b                   	pop    %ebx
  80130e:	5e                   	pop    %esi
  80130f:	5f                   	pop    %edi
  801310:	5d                   	pop    %ebp
  801311:	c3                   	ret    

00801312 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801312:	55                   	push   %ebp
  801313:	89 e5                	mov    %esp,%ebp
  801315:	57                   	push   %edi
  801316:	56                   	push   %esi
  801317:	53                   	push   %ebx
	asm volatile("int %1\n"
  801318:	bb 00 00 00 00       	mov    $0x0,%ebx
  80131d:	8b 55 08             	mov    0x8(%ebp),%edx
  801320:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801323:	b8 12 00 00 00       	mov    $0x12,%eax
  801328:	89 df                	mov    %ebx,%edi
  80132a:	89 de                	mov    %ebx,%esi
  80132c:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80132e:	5b                   	pop    %ebx
  80132f:	5e                   	pop    %esi
  801330:	5f                   	pop    %edi
  801331:	5d                   	pop    %ebp
  801332:	c3                   	ret    

00801333 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801333:	55                   	push   %ebp
  801334:	89 e5                	mov    %esp,%ebp
  801336:	57                   	push   %edi
  801337:	56                   	push   %esi
  801338:	53                   	push   %ebx
  801339:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80133c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801341:	8b 55 08             	mov    0x8(%ebp),%edx
  801344:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801347:	b8 13 00 00 00       	mov    $0x13,%eax
  80134c:	89 df                	mov    %ebx,%edi
  80134e:	89 de                	mov    %ebx,%esi
  801350:	cd 30                	int    $0x30
	if(check && ret > 0)
  801352:	85 c0                	test   %eax,%eax
  801354:	7f 08                	jg     80135e <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801356:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801359:	5b                   	pop    %ebx
  80135a:	5e                   	pop    %esi
  80135b:	5f                   	pop    %edi
  80135c:	5d                   	pop    %ebp
  80135d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80135e:	83 ec 0c             	sub    $0xc,%esp
  801361:	50                   	push   %eax
  801362:	6a 13                	push   $0x13
  801364:	68 b8 2c 80 00       	push   $0x802cb8
  801369:	6a 43                	push   $0x43
  80136b:	68 d5 2c 80 00       	push   $0x802cd5
  801370:	e8 f4 ef ff ff       	call   800369 <_panic>

00801375 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  801375:	55                   	push   %ebp
  801376:	89 e5                	mov    %esp,%ebp
  801378:	57                   	push   %edi
  801379:	56                   	push   %esi
  80137a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80137b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801380:	8b 55 08             	mov    0x8(%ebp),%edx
  801383:	b8 14 00 00 00       	mov    $0x14,%eax
  801388:	89 cb                	mov    %ecx,%ebx
  80138a:	89 cf                	mov    %ecx,%edi
  80138c:	89 ce                	mov    %ecx,%esi
  80138e:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801390:	5b                   	pop    %ebx
  801391:	5e                   	pop    %esi
  801392:	5f                   	pop    %edi
  801393:	5d                   	pop    %ebp
  801394:	c3                   	ret    

00801395 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801395:	55                   	push   %ebp
  801396:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801398:	8b 45 08             	mov    0x8(%ebp),%eax
  80139b:	05 00 00 00 30       	add    $0x30000000,%eax
  8013a0:	c1 e8 0c             	shr    $0xc,%eax
}
  8013a3:	5d                   	pop    %ebp
  8013a4:	c3                   	ret    

008013a5 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8013a5:	55                   	push   %ebp
  8013a6:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ab:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8013b0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013b5:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8013ba:	5d                   	pop    %ebp
  8013bb:	c3                   	ret    

008013bc <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8013bc:	55                   	push   %ebp
  8013bd:	89 e5                	mov    %esp,%ebp
  8013bf:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8013c4:	89 c2                	mov    %eax,%edx
  8013c6:	c1 ea 16             	shr    $0x16,%edx
  8013c9:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013d0:	f6 c2 01             	test   $0x1,%dl
  8013d3:	74 2d                	je     801402 <fd_alloc+0x46>
  8013d5:	89 c2                	mov    %eax,%edx
  8013d7:	c1 ea 0c             	shr    $0xc,%edx
  8013da:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013e1:	f6 c2 01             	test   $0x1,%dl
  8013e4:	74 1c                	je     801402 <fd_alloc+0x46>
  8013e6:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8013eb:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8013f0:	75 d2                	jne    8013c4 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8013f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8013fb:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801400:	eb 0a                	jmp    80140c <fd_alloc+0x50>
			*fd_store = fd;
  801402:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801405:	89 01                	mov    %eax,(%ecx)
			return 0;
  801407:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80140c:	5d                   	pop    %ebp
  80140d:	c3                   	ret    

0080140e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80140e:	55                   	push   %ebp
  80140f:	89 e5                	mov    %esp,%ebp
  801411:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801414:	83 f8 1f             	cmp    $0x1f,%eax
  801417:	77 30                	ja     801449 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801419:	c1 e0 0c             	shl    $0xc,%eax
  80141c:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801421:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801427:	f6 c2 01             	test   $0x1,%dl
  80142a:	74 24                	je     801450 <fd_lookup+0x42>
  80142c:	89 c2                	mov    %eax,%edx
  80142e:	c1 ea 0c             	shr    $0xc,%edx
  801431:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801438:	f6 c2 01             	test   $0x1,%dl
  80143b:	74 1a                	je     801457 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80143d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801440:	89 02                	mov    %eax,(%edx)
	return 0;
  801442:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801447:	5d                   	pop    %ebp
  801448:	c3                   	ret    
		return -E_INVAL;
  801449:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80144e:	eb f7                	jmp    801447 <fd_lookup+0x39>
		return -E_INVAL;
  801450:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801455:	eb f0                	jmp    801447 <fd_lookup+0x39>
  801457:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80145c:	eb e9                	jmp    801447 <fd_lookup+0x39>

0080145e <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80145e:	55                   	push   %ebp
  80145f:	89 e5                	mov    %esp,%ebp
  801461:	83 ec 08             	sub    $0x8,%esp
  801464:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801467:	ba 00 00 00 00       	mov    $0x0,%edx
  80146c:	b8 20 30 80 00       	mov    $0x803020,%eax
		if (devtab[i]->dev_id == dev_id) {
  801471:	39 08                	cmp    %ecx,(%eax)
  801473:	74 38                	je     8014ad <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801475:	83 c2 01             	add    $0x1,%edx
  801478:	8b 04 95 64 2d 80 00 	mov    0x802d64(,%edx,4),%eax
  80147f:	85 c0                	test   %eax,%eax
  801481:	75 ee                	jne    801471 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801483:	a1 08 44 80 00       	mov    0x804408,%eax
  801488:	8b 40 48             	mov    0x48(%eax),%eax
  80148b:	83 ec 04             	sub    $0x4,%esp
  80148e:	51                   	push   %ecx
  80148f:	50                   	push   %eax
  801490:	68 e4 2c 80 00       	push   $0x802ce4
  801495:	e8 c5 ef ff ff       	call   80045f <cprintf>
	*dev = 0;
  80149a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80149d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8014a3:	83 c4 10             	add    $0x10,%esp
  8014a6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8014ab:	c9                   	leave  
  8014ac:	c3                   	ret    
			*dev = devtab[i];
  8014ad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014b0:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8014b7:	eb f2                	jmp    8014ab <dev_lookup+0x4d>

008014b9 <fd_close>:
{
  8014b9:	55                   	push   %ebp
  8014ba:	89 e5                	mov    %esp,%ebp
  8014bc:	57                   	push   %edi
  8014bd:	56                   	push   %esi
  8014be:	53                   	push   %ebx
  8014bf:	83 ec 24             	sub    $0x24,%esp
  8014c2:	8b 75 08             	mov    0x8(%ebp),%esi
  8014c5:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014c8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014cb:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014cc:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8014d2:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014d5:	50                   	push   %eax
  8014d6:	e8 33 ff ff ff       	call   80140e <fd_lookup>
  8014db:	89 c3                	mov    %eax,%ebx
  8014dd:	83 c4 10             	add    $0x10,%esp
  8014e0:	85 c0                	test   %eax,%eax
  8014e2:	78 05                	js     8014e9 <fd_close+0x30>
	    || fd != fd2)
  8014e4:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8014e7:	74 16                	je     8014ff <fd_close+0x46>
		return (must_exist ? r : 0);
  8014e9:	89 f8                	mov    %edi,%eax
  8014eb:	84 c0                	test   %al,%al
  8014ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8014f2:	0f 44 d8             	cmove  %eax,%ebx
}
  8014f5:	89 d8                	mov    %ebx,%eax
  8014f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014fa:	5b                   	pop    %ebx
  8014fb:	5e                   	pop    %esi
  8014fc:	5f                   	pop    %edi
  8014fd:	5d                   	pop    %ebp
  8014fe:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8014ff:	83 ec 08             	sub    $0x8,%esp
  801502:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801505:	50                   	push   %eax
  801506:	ff 36                	pushl  (%esi)
  801508:	e8 51 ff ff ff       	call   80145e <dev_lookup>
  80150d:	89 c3                	mov    %eax,%ebx
  80150f:	83 c4 10             	add    $0x10,%esp
  801512:	85 c0                	test   %eax,%eax
  801514:	78 1a                	js     801530 <fd_close+0x77>
		if (dev->dev_close)
  801516:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801519:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80151c:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801521:	85 c0                	test   %eax,%eax
  801523:	74 0b                	je     801530 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801525:	83 ec 0c             	sub    $0xc,%esp
  801528:	56                   	push   %esi
  801529:	ff d0                	call   *%eax
  80152b:	89 c3                	mov    %eax,%ebx
  80152d:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801530:	83 ec 08             	sub    $0x8,%esp
  801533:	56                   	push   %esi
  801534:	6a 00                	push   $0x0
  801536:	e8 ea fb ff ff       	call   801125 <sys_page_unmap>
	return r;
  80153b:	83 c4 10             	add    $0x10,%esp
  80153e:	eb b5                	jmp    8014f5 <fd_close+0x3c>

00801540 <close>:

int
close(int fdnum)
{
  801540:	55                   	push   %ebp
  801541:	89 e5                	mov    %esp,%ebp
  801543:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801546:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801549:	50                   	push   %eax
  80154a:	ff 75 08             	pushl  0x8(%ebp)
  80154d:	e8 bc fe ff ff       	call   80140e <fd_lookup>
  801552:	83 c4 10             	add    $0x10,%esp
  801555:	85 c0                	test   %eax,%eax
  801557:	79 02                	jns    80155b <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801559:	c9                   	leave  
  80155a:	c3                   	ret    
		return fd_close(fd, 1);
  80155b:	83 ec 08             	sub    $0x8,%esp
  80155e:	6a 01                	push   $0x1
  801560:	ff 75 f4             	pushl  -0xc(%ebp)
  801563:	e8 51 ff ff ff       	call   8014b9 <fd_close>
  801568:	83 c4 10             	add    $0x10,%esp
  80156b:	eb ec                	jmp    801559 <close+0x19>

0080156d <close_all>:

void
close_all(void)
{
  80156d:	55                   	push   %ebp
  80156e:	89 e5                	mov    %esp,%ebp
  801570:	53                   	push   %ebx
  801571:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801574:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801579:	83 ec 0c             	sub    $0xc,%esp
  80157c:	53                   	push   %ebx
  80157d:	e8 be ff ff ff       	call   801540 <close>
	for (i = 0; i < MAXFD; i++)
  801582:	83 c3 01             	add    $0x1,%ebx
  801585:	83 c4 10             	add    $0x10,%esp
  801588:	83 fb 20             	cmp    $0x20,%ebx
  80158b:	75 ec                	jne    801579 <close_all+0xc>
}
  80158d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801590:	c9                   	leave  
  801591:	c3                   	ret    

00801592 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801592:	55                   	push   %ebp
  801593:	89 e5                	mov    %esp,%ebp
  801595:	57                   	push   %edi
  801596:	56                   	push   %esi
  801597:	53                   	push   %ebx
  801598:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80159b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80159e:	50                   	push   %eax
  80159f:	ff 75 08             	pushl  0x8(%ebp)
  8015a2:	e8 67 fe ff ff       	call   80140e <fd_lookup>
  8015a7:	89 c3                	mov    %eax,%ebx
  8015a9:	83 c4 10             	add    $0x10,%esp
  8015ac:	85 c0                	test   %eax,%eax
  8015ae:	0f 88 81 00 00 00    	js     801635 <dup+0xa3>
		return r;
	close(newfdnum);
  8015b4:	83 ec 0c             	sub    $0xc,%esp
  8015b7:	ff 75 0c             	pushl  0xc(%ebp)
  8015ba:	e8 81 ff ff ff       	call   801540 <close>

	newfd = INDEX2FD(newfdnum);
  8015bf:	8b 75 0c             	mov    0xc(%ebp),%esi
  8015c2:	c1 e6 0c             	shl    $0xc,%esi
  8015c5:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8015cb:	83 c4 04             	add    $0x4,%esp
  8015ce:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015d1:	e8 cf fd ff ff       	call   8013a5 <fd2data>
  8015d6:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8015d8:	89 34 24             	mov    %esi,(%esp)
  8015db:	e8 c5 fd ff ff       	call   8013a5 <fd2data>
  8015e0:	83 c4 10             	add    $0x10,%esp
  8015e3:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8015e5:	89 d8                	mov    %ebx,%eax
  8015e7:	c1 e8 16             	shr    $0x16,%eax
  8015ea:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015f1:	a8 01                	test   $0x1,%al
  8015f3:	74 11                	je     801606 <dup+0x74>
  8015f5:	89 d8                	mov    %ebx,%eax
  8015f7:	c1 e8 0c             	shr    $0xc,%eax
  8015fa:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801601:	f6 c2 01             	test   $0x1,%dl
  801604:	75 39                	jne    80163f <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801606:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801609:	89 d0                	mov    %edx,%eax
  80160b:	c1 e8 0c             	shr    $0xc,%eax
  80160e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801615:	83 ec 0c             	sub    $0xc,%esp
  801618:	25 07 0e 00 00       	and    $0xe07,%eax
  80161d:	50                   	push   %eax
  80161e:	56                   	push   %esi
  80161f:	6a 00                	push   $0x0
  801621:	52                   	push   %edx
  801622:	6a 00                	push   $0x0
  801624:	e8 ba fa ff ff       	call   8010e3 <sys_page_map>
  801629:	89 c3                	mov    %eax,%ebx
  80162b:	83 c4 20             	add    $0x20,%esp
  80162e:	85 c0                	test   %eax,%eax
  801630:	78 31                	js     801663 <dup+0xd1>
		goto err;

	return newfdnum;
  801632:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801635:	89 d8                	mov    %ebx,%eax
  801637:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80163a:	5b                   	pop    %ebx
  80163b:	5e                   	pop    %esi
  80163c:	5f                   	pop    %edi
  80163d:	5d                   	pop    %ebp
  80163e:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80163f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801646:	83 ec 0c             	sub    $0xc,%esp
  801649:	25 07 0e 00 00       	and    $0xe07,%eax
  80164e:	50                   	push   %eax
  80164f:	57                   	push   %edi
  801650:	6a 00                	push   $0x0
  801652:	53                   	push   %ebx
  801653:	6a 00                	push   $0x0
  801655:	e8 89 fa ff ff       	call   8010e3 <sys_page_map>
  80165a:	89 c3                	mov    %eax,%ebx
  80165c:	83 c4 20             	add    $0x20,%esp
  80165f:	85 c0                	test   %eax,%eax
  801661:	79 a3                	jns    801606 <dup+0x74>
	sys_page_unmap(0, newfd);
  801663:	83 ec 08             	sub    $0x8,%esp
  801666:	56                   	push   %esi
  801667:	6a 00                	push   $0x0
  801669:	e8 b7 fa ff ff       	call   801125 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80166e:	83 c4 08             	add    $0x8,%esp
  801671:	57                   	push   %edi
  801672:	6a 00                	push   $0x0
  801674:	e8 ac fa ff ff       	call   801125 <sys_page_unmap>
	return r;
  801679:	83 c4 10             	add    $0x10,%esp
  80167c:	eb b7                	jmp    801635 <dup+0xa3>

0080167e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80167e:	55                   	push   %ebp
  80167f:	89 e5                	mov    %esp,%ebp
  801681:	53                   	push   %ebx
  801682:	83 ec 1c             	sub    $0x1c,%esp
  801685:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801688:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80168b:	50                   	push   %eax
  80168c:	53                   	push   %ebx
  80168d:	e8 7c fd ff ff       	call   80140e <fd_lookup>
  801692:	83 c4 10             	add    $0x10,%esp
  801695:	85 c0                	test   %eax,%eax
  801697:	78 3f                	js     8016d8 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801699:	83 ec 08             	sub    $0x8,%esp
  80169c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80169f:	50                   	push   %eax
  8016a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a3:	ff 30                	pushl  (%eax)
  8016a5:	e8 b4 fd ff ff       	call   80145e <dev_lookup>
  8016aa:	83 c4 10             	add    $0x10,%esp
  8016ad:	85 c0                	test   %eax,%eax
  8016af:	78 27                	js     8016d8 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8016b1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016b4:	8b 42 08             	mov    0x8(%edx),%eax
  8016b7:	83 e0 03             	and    $0x3,%eax
  8016ba:	83 f8 01             	cmp    $0x1,%eax
  8016bd:	74 1e                	je     8016dd <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8016bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c2:	8b 40 08             	mov    0x8(%eax),%eax
  8016c5:	85 c0                	test   %eax,%eax
  8016c7:	74 35                	je     8016fe <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8016c9:	83 ec 04             	sub    $0x4,%esp
  8016cc:	ff 75 10             	pushl  0x10(%ebp)
  8016cf:	ff 75 0c             	pushl  0xc(%ebp)
  8016d2:	52                   	push   %edx
  8016d3:	ff d0                	call   *%eax
  8016d5:	83 c4 10             	add    $0x10,%esp
}
  8016d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016db:	c9                   	leave  
  8016dc:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8016dd:	a1 08 44 80 00       	mov    0x804408,%eax
  8016e2:	8b 40 48             	mov    0x48(%eax),%eax
  8016e5:	83 ec 04             	sub    $0x4,%esp
  8016e8:	53                   	push   %ebx
  8016e9:	50                   	push   %eax
  8016ea:	68 28 2d 80 00       	push   $0x802d28
  8016ef:	e8 6b ed ff ff       	call   80045f <cprintf>
		return -E_INVAL;
  8016f4:	83 c4 10             	add    $0x10,%esp
  8016f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016fc:	eb da                	jmp    8016d8 <read+0x5a>
		return -E_NOT_SUPP;
  8016fe:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801703:	eb d3                	jmp    8016d8 <read+0x5a>

00801705 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801705:	55                   	push   %ebp
  801706:	89 e5                	mov    %esp,%ebp
  801708:	57                   	push   %edi
  801709:	56                   	push   %esi
  80170a:	53                   	push   %ebx
  80170b:	83 ec 0c             	sub    $0xc,%esp
  80170e:	8b 7d 08             	mov    0x8(%ebp),%edi
  801711:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801714:	bb 00 00 00 00       	mov    $0x0,%ebx
  801719:	39 f3                	cmp    %esi,%ebx
  80171b:	73 23                	jae    801740 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80171d:	83 ec 04             	sub    $0x4,%esp
  801720:	89 f0                	mov    %esi,%eax
  801722:	29 d8                	sub    %ebx,%eax
  801724:	50                   	push   %eax
  801725:	89 d8                	mov    %ebx,%eax
  801727:	03 45 0c             	add    0xc(%ebp),%eax
  80172a:	50                   	push   %eax
  80172b:	57                   	push   %edi
  80172c:	e8 4d ff ff ff       	call   80167e <read>
		if (m < 0)
  801731:	83 c4 10             	add    $0x10,%esp
  801734:	85 c0                	test   %eax,%eax
  801736:	78 06                	js     80173e <readn+0x39>
			return m;
		if (m == 0)
  801738:	74 06                	je     801740 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80173a:	01 c3                	add    %eax,%ebx
  80173c:	eb db                	jmp    801719 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80173e:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801740:	89 d8                	mov    %ebx,%eax
  801742:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801745:	5b                   	pop    %ebx
  801746:	5e                   	pop    %esi
  801747:	5f                   	pop    %edi
  801748:	5d                   	pop    %ebp
  801749:	c3                   	ret    

0080174a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80174a:	55                   	push   %ebp
  80174b:	89 e5                	mov    %esp,%ebp
  80174d:	53                   	push   %ebx
  80174e:	83 ec 1c             	sub    $0x1c,%esp
  801751:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801754:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801757:	50                   	push   %eax
  801758:	53                   	push   %ebx
  801759:	e8 b0 fc ff ff       	call   80140e <fd_lookup>
  80175e:	83 c4 10             	add    $0x10,%esp
  801761:	85 c0                	test   %eax,%eax
  801763:	78 3a                	js     80179f <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801765:	83 ec 08             	sub    $0x8,%esp
  801768:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80176b:	50                   	push   %eax
  80176c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80176f:	ff 30                	pushl  (%eax)
  801771:	e8 e8 fc ff ff       	call   80145e <dev_lookup>
  801776:	83 c4 10             	add    $0x10,%esp
  801779:	85 c0                	test   %eax,%eax
  80177b:	78 22                	js     80179f <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80177d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801780:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801784:	74 1e                	je     8017a4 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801786:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801789:	8b 52 0c             	mov    0xc(%edx),%edx
  80178c:	85 d2                	test   %edx,%edx
  80178e:	74 35                	je     8017c5 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801790:	83 ec 04             	sub    $0x4,%esp
  801793:	ff 75 10             	pushl  0x10(%ebp)
  801796:	ff 75 0c             	pushl  0xc(%ebp)
  801799:	50                   	push   %eax
  80179a:	ff d2                	call   *%edx
  80179c:	83 c4 10             	add    $0x10,%esp
}
  80179f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017a2:	c9                   	leave  
  8017a3:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8017a4:	a1 08 44 80 00       	mov    0x804408,%eax
  8017a9:	8b 40 48             	mov    0x48(%eax),%eax
  8017ac:	83 ec 04             	sub    $0x4,%esp
  8017af:	53                   	push   %ebx
  8017b0:	50                   	push   %eax
  8017b1:	68 44 2d 80 00       	push   $0x802d44
  8017b6:	e8 a4 ec ff ff       	call   80045f <cprintf>
		return -E_INVAL;
  8017bb:	83 c4 10             	add    $0x10,%esp
  8017be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017c3:	eb da                	jmp    80179f <write+0x55>
		return -E_NOT_SUPP;
  8017c5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017ca:	eb d3                	jmp    80179f <write+0x55>

008017cc <seek>:

int
seek(int fdnum, off_t offset)
{
  8017cc:	55                   	push   %ebp
  8017cd:	89 e5                	mov    %esp,%ebp
  8017cf:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017d5:	50                   	push   %eax
  8017d6:	ff 75 08             	pushl  0x8(%ebp)
  8017d9:	e8 30 fc ff ff       	call   80140e <fd_lookup>
  8017de:	83 c4 10             	add    $0x10,%esp
  8017e1:	85 c0                	test   %eax,%eax
  8017e3:	78 0e                	js     8017f3 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8017e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017eb:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8017ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017f3:	c9                   	leave  
  8017f4:	c3                   	ret    

008017f5 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8017f5:	55                   	push   %ebp
  8017f6:	89 e5                	mov    %esp,%ebp
  8017f8:	53                   	push   %ebx
  8017f9:	83 ec 1c             	sub    $0x1c,%esp
  8017fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017ff:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801802:	50                   	push   %eax
  801803:	53                   	push   %ebx
  801804:	e8 05 fc ff ff       	call   80140e <fd_lookup>
  801809:	83 c4 10             	add    $0x10,%esp
  80180c:	85 c0                	test   %eax,%eax
  80180e:	78 37                	js     801847 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801810:	83 ec 08             	sub    $0x8,%esp
  801813:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801816:	50                   	push   %eax
  801817:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80181a:	ff 30                	pushl  (%eax)
  80181c:	e8 3d fc ff ff       	call   80145e <dev_lookup>
  801821:	83 c4 10             	add    $0x10,%esp
  801824:	85 c0                	test   %eax,%eax
  801826:	78 1f                	js     801847 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801828:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80182b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80182f:	74 1b                	je     80184c <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801831:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801834:	8b 52 18             	mov    0x18(%edx),%edx
  801837:	85 d2                	test   %edx,%edx
  801839:	74 32                	je     80186d <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80183b:	83 ec 08             	sub    $0x8,%esp
  80183e:	ff 75 0c             	pushl  0xc(%ebp)
  801841:	50                   	push   %eax
  801842:	ff d2                	call   *%edx
  801844:	83 c4 10             	add    $0x10,%esp
}
  801847:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80184a:	c9                   	leave  
  80184b:	c3                   	ret    
			thisenv->env_id, fdnum);
  80184c:	a1 08 44 80 00       	mov    0x804408,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801851:	8b 40 48             	mov    0x48(%eax),%eax
  801854:	83 ec 04             	sub    $0x4,%esp
  801857:	53                   	push   %ebx
  801858:	50                   	push   %eax
  801859:	68 04 2d 80 00       	push   $0x802d04
  80185e:	e8 fc eb ff ff       	call   80045f <cprintf>
		return -E_INVAL;
  801863:	83 c4 10             	add    $0x10,%esp
  801866:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80186b:	eb da                	jmp    801847 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80186d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801872:	eb d3                	jmp    801847 <ftruncate+0x52>

00801874 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801874:	55                   	push   %ebp
  801875:	89 e5                	mov    %esp,%ebp
  801877:	53                   	push   %ebx
  801878:	83 ec 1c             	sub    $0x1c,%esp
  80187b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80187e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801881:	50                   	push   %eax
  801882:	ff 75 08             	pushl  0x8(%ebp)
  801885:	e8 84 fb ff ff       	call   80140e <fd_lookup>
  80188a:	83 c4 10             	add    $0x10,%esp
  80188d:	85 c0                	test   %eax,%eax
  80188f:	78 4b                	js     8018dc <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801891:	83 ec 08             	sub    $0x8,%esp
  801894:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801897:	50                   	push   %eax
  801898:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80189b:	ff 30                	pushl  (%eax)
  80189d:	e8 bc fb ff ff       	call   80145e <dev_lookup>
  8018a2:	83 c4 10             	add    $0x10,%esp
  8018a5:	85 c0                	test   %eax,%eax
  8018a7:	78 33                	js     8018dc <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8018a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ac:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8018b0:	74 2f                	je     8018e1 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8018b2:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8018b5:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8018bc:	00 00 00 
	stat->st_isdir = 0;
  8018bf:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8018c6:	00 00 00 
	stat->st_dev = dev;
  8018c9:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8018cf:	83 ec 08             	sub    $0x8,%esp
  8018d2:	53                   	push   %ebx
  8018d3:	ff 75 f0             	pushl  -0x10(%ebp)
  8018d6:	ff 50 14             	call   *0x14(%eax)
  8018d9:	83 c4 10             	add    $0x10,%esp
}
  8018dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018df:	c9                   	leave  
  8018e0:	c3                   	ret    
		return -E_NOT_SUPP;
  8018e1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018e6:	eb f4                	jmp    8018dc <fstat+0x68>

008018e8 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
  8018eb:	56                   	push   %esi
  8018ec:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8018ed:	83 ec 08             	sub    $0x8,%esp
  8018f0:	6a 00                	push   $0x0
  8018f2:	ff 75 08             	pushl  0x8(%ebp)
  8018f5:	e8 22 02 00 00       	call   801b1c <open>
  8018fa:	89 c3                	mov    %eax,%ebx
  8018fc:	83 c4 10             	add    $0x10,%esp
  8018ff:	85 c0                	test   %eax,%eax
  801901:	78 1b                	js     80191e <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801903:	83 ec 08             	sub    $0x8,%esp
  801906:	ff 75 0c             	pushl  0xc(%ebp)
  801909:	50                   	push   %eax
  80190a:	e8 65 ff ff ff       	call   801874 <fstat>
  80190f:	89 c6                	mov    %eax,%esi
	close(fd);
  801911:	89 1c 24             	mov    %ebx,(%esp)
  801914:	e8 27 fc ff ff       	call   801540 <close>
	return r;
  801919:	83 c4 10             	add    $0x10,%esp
  80191c:	89 f3                	mov    %esi,%ebx
}
  80191e:	89 d8                	mov    %ebx,%eax
  801920:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801923:	5b                   	pop    %ebx
  801924:	5e                   	pop    %esi
  801925:	5d                   	pop    %ebp
  801926:	c3                   	ret    

00801927 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801927:	55                   	push   %ebp
  801928:	89 e5                	mov    %esp,%ebp
  80192a:	56                   	push   %esi
  80192b:	53                   	push   %ebx
  80192c:	89 c6                	mov    %eax,%esi
  80192e:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801930:	83 3d 00 44 80 00 00 	cmpl   $0x0,0x804400
  801937:	74 27                	je     801960 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801939:	6a 07                	push   $0x7
  80193b:	68 00 50 80 00       	push   $0x805000
  801940:	56                   	push   %esi
  801941:	ff 35 00 44 80 00    	pushl  0x804400
  801947:	e8 a7 0b 00 00       	call   8024f3 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80194c:	83 c4 0c             	add    $0xc,%esp
  80194f:	6a 00                	push   $0x0
  801951:	53                   	push   %ebx
  801952:	6a 00                	push   $0x0
  801954:	e8 31 0b 00 00       	call   80248a <ipc_recv>
}
  801959:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80195c:	5b                   	pop    %ebx
  80195d:	5e                   	pop    %esi
  80195e:	5d                   	pop    %ebp
  80195f:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801960:	83 ec 0c             	sub    $0xc,%esp
  801963:	6a 01                	push   $0x1
  801965:	e8 e1 0b 00 00       	call   80254b <ipc_find_env>
  80196a:	a3 00 44 80 00       	mov    %eax,0x804400
  80196f:	83 c4 10             	add    $0x10,%esp
  801972:	eb c5                	jmp    801939 <fsipc+0x12>

00801974 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801974:	55                   	push   %ebp
  801975:	89 e5                	mov    %esp,%ebp
  801977:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80197a:	8b 45 08             	mov    0x8(%ebp),%eax
  80197d:	8b 40 0c             	mov    0xc(%eax),%eax
  801980:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801985:	8b 45 0c             	mov    0xc(%ebp),%eax
  801988:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80198d:	ba 00 00 00 00       	mov    $0x0,%edx
  801992:	b8 02 00 00 00       	mov    $0x2,%eax
  801997:	e8 8b ff ff ff       	call   801927 <fsipc>
}
  80199c:	c9                   	leave  
  80199d:	c3                   	ret    

0080199e <devfile_flush>:
{
  80199e:	55                   	push   %ebp
  80199f:	89 e5                	mov    %esp,%ebp
  8019a1:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8019a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8019aa:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8019af:	ba 00 00 00 00       	mov    $0x0,%edx
  8019b4:	b8 06 00 00 00       	mov    $0x6,%eax
  8019b9:	e8 69 ff ff ff       	call   801927 <fsipc>
}
  8019be:	c9                   	leave  
  8019bf:	c3                   	ret    

008019c0 <devfile_stat>:
{
  8019c0:	55                   	push   %ebp
  8019c1:	89 e5                	mov    %esp,%ebp
  8019c3:	53                   	push   %ebx
  8019c4:	83 ec 04             	sub    $0x4,%esp
  8019c7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8019ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8019d0:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8019d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8019da:	b8 05 00 00 00       	mov    $0x5,%eax
  8019df:	e8 43 ff ff ff       	call   801927 <fsipc>
  8019e4:	85 c0                	test   %eax,%eax
  8019e6:	78 2c                	js     801a14 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8019e8:	83 ec 08             	sub    $0x8,%esp
  8019eb:	68 00 50 80 00       	push   $0x805000
  8019f0:	53                   	push   %ebx
  8019f1:	e8 b8 f2 ff ff       	call   800cae <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8019f6:	a1 80 50 80 00       	mov    0x805080,%eax
  8019fb:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a01:	a1 84 50 80 00       	mov    0x805084,%eax
  801a06:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a0c:	83 c4 10             	add    $0x10,%esp
  801a0f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a17:	c9                   	leave  
  801a18:	c3                   	ret    

00801a19 <devfile_write>:
{
  801a19:	55                   	push   %ebp
  801a1a:	89 e5                	mov    %esp,%ebp
  801a1c:	53                   	push   %ebx
  801a1d:	83 ec 08             	sub    $0x8,%esp
  801a20:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a23:	8b 45 08             	mov    0x8(%ebp),%eax
  801a26:	8b 40 0c             	mov    0xc(%eax),%eax
  801a29:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801a2e:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801a34:	53                   	push   %ebx
  801a35:	ff 75 0c             	pushl  0xc(%ebp)
  801a38:	68 08 50 80 00       	push   $0x805008
  801a3d:	e8 5c f4 ff ff       	call   800e9e <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801a42:	ba 00 00 00 00       	mov    $0x0,%edx
  801a47:	b8 04 00 00 00       	mov    $0x4,%eax
  801a4c:	e8 d6 fe ff ff       	call   801927 <fsipc>
  801a51:	83 c4 10             	add    $0x10,%esp
  801a54:	85 c0                	test   %eax,%eax
  801a56:	78 0b                	js     801a63 <devfile_write+0x4a>
	assert(r <= n);
  801a58:	39 d8                	cmp    %ebx,%eax
  801a5a:	77 0c                	ja     801a68 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801a5c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a61:	7f 1e                	jg     801a81 <devfile_write+0x68>
}
  801a63:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a66:	c9                   	leave  
  801a67:	c3                   	ret    
	assert(r <= n);
  801a68:	68 78 2d 80 00       	push   $0x802d78
  801a6d:	68 7f 2d 80 00       	push   $0x802d7f
  801a72:	68 98 00 00 00       	push   $0x98
  801a77:	68 94 2d 80 00       	push   $0x802d94
  801a7c:	e8 e8 e8 ff ff       	call   800369 <_panic>
	assert(r <= PGSIZE);
  801a81:	68 9f 2d 80 00       	push   $0x802d9f
  801a86:	68 7f 2d 80 00       	push   $0x802d7f
  801a8b:	68 99 00 00 00       	push   $0x99
  801a90:	68 94 2d 80 00       	push   $0x802d94
  801a95:	e8 cf e8 ff ff       	call   800369 <_panic>

00801a9a <devfile_read>:
{
  801a9a:	55                   	push   %ebp
  801a9b:	89 e5                	mov    %esp,%ebp
  801a9d:	56                   	push   %esi
  801a9e:	53                   	push   %ebx
  801a9f:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa5:	8b 40 0c             	mov    0xc(%eax),%eax
  801aa8:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801aad:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801ab3:	ba 00 00 00 00       	mov    $0x0,%edx
  801ab8:	b8 03 00 00 00       	mov    $0x3,%eax
  801abd:	e8 65 fe ff ff       	call   801927 <fsipc>
  801ac2:	89 c3                	mov    %eax,%ebx
  801ac4:	85 c0                	test   %eax,%eax
  801ac6:	78 1f                	js     801ae7 <devfile_read+0x4d>
	assert(r <= n);
  801ac8:	39 f0                	cmp    %esi,%eax
  801aca:	77 24                	ja     801af0 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801acc:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ad1:	7f 33                	jg     801b06 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801ad3:	83 ec 04             	sub    $0x4,%esp
  801ad6:	50                   	push   %eax
  801ad7:	68 00 50 80 00       	push   $0x805000
  801adc:	ff 75 0c             	pushl  0xc(%ebp)
  801adf:	e8 58 f3 ff ff       	call   800e3c <memmove>
	return r;
  801ae4:	83 c4 10             	add    $0x10,%esp
}
  801ae7:	89 d8                	mov    %ebx,%eax
  801ae9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aec:	5b                   	pop    %ebx
  801aed:	5e                   	pop    %esi
  801aee:	5d                   	pop    %ebp
  801aef:	c3                   	ret    
	assert(r <= n);
  801af0:	68 78 2d 80 00       	push   $0x802d78
  801af5:	68 7f 2d 80 00       	push   $0x802d7f
  801afa:	6a 7c                	push   $0x7c
  801afc:	68 94 2d 80 00       	push   $0x802d94
  801b01:	e8 63 e8 ff ff       	call   800369 <_panic>
	assert(r <= PGSIZE);
  801b06:	68 9f 2d 80 00       	push   $0x802d9f
  801b0b:	68 7f 2d 80 00       	push   $0x802d7f
  801b10:	6a 7d                	push   $0x7d
  801b12:	68 94 2d 80 00       	push   $0x802d94
  801b17:	e8 4d e8 ff ff       	call   800369 <_panic>

00801b1c <open>:
{
  801b1c:	55                   	push   %ebp
  801b1d:	89 e5                	mov    %esp,%ebp
  801b1f:	56                   	push   %esi
  801b20:	53                   	push   %ebx
  801b21:	83 ec 1c             	sub    $0x1c,%esp
  801b24:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801b27:	56                   	push   %esi
  801b28:	e8 48 f1 ff ff       	call   800c75 <strlen>
  801b2d:	83 c4 10             	add    $0x10,%esp
  801b30:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b35:	7f 6c                	jg     801ba3 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801b37:	83 ec 0c             	sub    $0xc,%esp
  801b3a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b3d:	50                   	push   %eax
  801b3e:	e8 79 f8 ff ff       	call   8013bc <fd_alloc>
  801b43:	89 c3                	mov    %eax,%ebx
  801b45:	83 c4 10             	add    $0x10,%esp
  801b48:	85 c0                	test   %eax,%eax
  801b4a:	78 3c                	js     801b88 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801b4c:	83 ec 08             	sub    $0x8,%esp
  801b4f:	56                   	push   %esi
  801b50:	68 00 50 80 00       	push   $0x805000
  801b55:	e8 54 f1 ff ff       	call   800cae <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b5d:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b65:	b8 01 00 00 00       	mov    $0x1,%eax
  801b6a:	e8 b8 fd ff ff       	call   801927 <fsipc>
  801b6f:	89 c3                	mov    %eax,%ebx
  801b71:	83 c4 10             	add    $0x10,%esp
  801b74:	85 c0                	test   %eax,%eax
  801b76:	78 19                	js     801b91 <open+0x75>
	return fd2num(fd);
  801b78:	83 ec 0c             	sub    $0xc,%esp
  801b7b:	ff 75 f4             	pushl  -0xc(%ebp)
  801b7e:	e8 12 f8 ff ff       	call   801395 <fd2num>
  801b83:	89 c3                	mov    %eax,%ebx
  801b85:	83 c4 10             	add    $0x10,%esp
}
  801b88:	89 d8                	mov    %ebx,%eax
  801b8a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b8d:	5b                   	pop    %ebx
  801b8e:	5e                   	pop    %esi
  801b8f:	5d                   	pop    %ebp
  801b90:	c3                   	ret    
		fd_close(fd, 0);
  801b91:	83 ec 08             	sub    $0x8,%esp
  801b94:	6a 00                	push   $0x0
  801b96:	ff 75 f4             	pushl  -0xc(%ebp)
  801b99:	e8 1b f9 ff ff       	call   8014b9 <fd_close>
		return r;
  801b9e:	83 c4 10             	add    $0x10,%esp
  801ba1:	eb e5                	jmp    801b88 <open+0x6c>
		return -E_BAD_PATH;
  801ba3:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801ba8:	eb de                	jmp    801b88 <open+0x6c>

00801baa <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801baa:	55                   	push   %ebp
  801bab:	89 e5                	mov    %esp,%ebp
  801bad:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801bb0:	ba 00 00 00 00       	mov    $0x0,%edx
  801bb5:	b8 08 00 00 00       	mov    $0x8,%eax
  801bba:	e8 68 fd ff ff       	call   801927 <fsipc>
}
  801bbf:	c9                   	leave  
  801bc0:	c3                   	ret    

00801bc1 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  801bc1:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801bc5:	7f 01                	jg     801bc8 <writebuf+0x7>
  801bc7:	c3                   	ret    
{
  801bc8:	55                   	push   %ebp
  801bc9:	89 e5                	mov    %esp,%ebp
  801bcb:	53                   	push   %ebx
  801bcc:	83 ec 08             	sub    $0x8,%esp
  801bcf:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  801bd1:	ff 70 04             	pushl  0x4(%eax)
  801bd4:	8d 40 10             	lea    0x10(%eax),%eax
  801bd7:	50                   	push   %eax
  801bd8:	ff 33                	pushl  (%ebx)
  801bda:	e8 6b fb ff ff       	call   80174a <write>
		if (result > 0)
  801bdf:	83 c4 10             	add    $0x10,%esp
  801be2:	85 c0                	test   %eax,%eax
  801be4:	7e 03                	jle    801be9 <writebuf+0x28>
			b->result += result;
  801be6:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801be9:	39 43 04             	cmp    %eax,0x4(%ebx)
  801bec:	74 0d                	je     801bfb <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  801bee:	85 c0                	test   %eax,%eax
  801bf0:	ba 00 00 00 00       	mov    $0x0,%edx
  801bf5:	0f 4f c2             	cmovg  %edx,%eax
  801bf8:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801bfb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bfe:	c9                   	leave  
  801bff:	c3                   	ret    

00801c00 <putch>:

static void
putch(int ch, void *thunk)
{
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
  801c03:	53                   	push   %ebx
  801c04:	83 ec 04             	sub    $0x4,%esp
  801c07:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801c0a:	8b 53 04             	mov    0x4(%ebx),%edx
  801c0d:	8d 42 01             	lea    0x1(%edx),%eax
  801c10:	89 43 04             	mov    %eax,0x4(%ebx)
  801c13:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c16:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801c1a:	3d 00 01 00 00       	cmp    $0x100,%eax
  801c1f:	74 06                	je     801c27 <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  801c21:	83 c4 04             	add    $0x4,%esp
  801c24:	5b                   	pop    %ebx
  801c25:	5d                   	pop    %ebp
  801c26:	c3                   	ret    
		writebuf(b);
  801c27:	89 d8                	mov    %ebx,%eax
  801c29:	e8 93 ff ff ff       	call   801bc1 <writebuf>
		b->idx = 0;
  801c2e:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  801c35:	eb ea                	jmp    801c21 <putch+0x21>

00801c37 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801c37:	55                   	push   %ebp
  801c38:	89 e5                	mov    %esp,%ebp
  801c3a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801c40:	8b 45 08             	mov    0x8(%ebp),%eax
  801c43:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801c49:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801c50:	00 00 00 
	b.result = 0;
  801c53:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801c5a:	00 00 00 
	b.error = 1;
  801c5d:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801c64:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801c67:	ff 75 10             	pushl  0x10(%ebp)
  801c6a:	ff 75 0c             	pushl  0xc(%ebp)
  801c6d:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801c73:	50                   	push   %eax
  801c74:	68 00 1c 80 00       	push   $0x801c00
  801c79:	e8 0e e9 ff ff       	call   80058c <vprintfmt>
	if (b.idx > 0)
  801c7e:	83 c4 10             	add    $0x10,%esp
  801c81:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801c88:	7f 11                	jg     801c9b <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  801c8a:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801c90:	85 c0                	test   %eax,%eax
  801c92:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801c99:	c9                   	leave  
  801c9a:	c3                   	ret    
		writebuf(&b);
  801c9b:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801ca1:	e8 1b ff ff ff       	call   801bc1 <writebuf>
  801ca6:	eb e2                	jmp    801c8a <vfprintf+0x53>

00801ca8 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801ca8:	55                   	push   %ebp
  801ca9:	89 e5                	mov    %esp,%ebp
  801cab:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801cae:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801cb1:	50                   	push   %eax
  801cb2:	ff 75 0c             	pushl  0xc(%ebp)
  801cb5:	ff 75 08             	pushl  0x8(%ebp)
  801cb8:	e8 7a ff ff ff       	call   801c37 <vfprintf>
	va_end(ap);

	return cnt;
}
  801cbd:	c9                   	leave  
  801cbe:	c3                   	ret    

00801cbf <printf>:

int
printf(const char *fmt, ...)
{
  801cbf:	55                   	push   %ebp
  801cc0:	89 e5                	mov    %esp,%ebp
  801cc2:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801cc5:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801cc8:	50                   	push   %eax
  801cc9:	ff 75 08             	pushl  0x8(%ebp)
  801ccc:	6a 01                	push   $0x1
  801cce:	e8 64 ff ff ff       	call   801c37 <vfprintf>
	va_end(ap);

	return cnt;
}
  801cd3:	c9                   	leave  
  801cd4:	c3                   	ret    

00801cd5 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801cd5:	55                   	push   %ebp
  801cd6:	89 e5                	mov    %esp,%ebp
  801cd8:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801cdb:	68 ab 2d 80 00       	push   $0x802dab
  801ce0:	ff 75 0c             	pushl  0xc(%ebp)
  801ce3:	e8 c6 ef ff ff       	call   800cae <strcpy>
	return 0;
}
  801ce8:	b8 00 00 00 00       	mov    $0x0,%eax
  801ced:	c9                   	leave  
  801cee:	c3                   	ret    

00801cef <devsock_close>:
{
  801cef:	55                   	push   %ebp
  801cf0:	89 e5                	mov    %esp,%ebp
  801cf2:	53                   	push   %ebx
  801cf3:	83 ec 10             	sub    $0x10,%esp
  801cf6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801cf9:	53                   	push   %ebx
  801cfa:	e8 8b 08 00 00       	call   80258a <pageref>
  801cff:	83 c4 10             	add    $0x10,%esp
		return 0;
  801d02:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801d07:	83 f8 01             	cmp    $0x1,%eax
  801d0a:	74 07                	je     801d13 <devsock_close+0x24>
}
  801d0c:	89 d0                	mov    %edx,%eax
  801d0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d11:	c9                   	leave  
  801d12:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801d13:	83 ec 0c             	sub    $0xc,%esp
  801d16:	ff 73 0c             	pushl  0xc(%ebx)
  801d19:	e8 b9 02 00 00       	call   801fd7 <nsipc_close>
  801d1e:	89 c2                	mov    %eax,%edx
  801d20:	83 c4 10             	add    $0x10,%esp
  801d23:	eb e7                	jmp    801d0c <devsock_close+0x1d>

00801d25 <devsock_write>:
{
  801d25:	55                   	push   %ebp
  801d26:	89 e5                	mov    %esp,%ebp
  801d28:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801d2b:	6a 00                	push   $0x0
  801d2d:	ff 75 10             	pushl  0x10(%ebp)
  801d30:	ff 75 0c             	pushl  0xc(%ebp)
  801d33:	8b 45 08             	mov    0x8(%ebp),%eax
  801d36:	ff 70 0c             	pushl  0xc(%eax)
  801d39:	e8 76 03 00 00       	call   8020b4 <nsipc_send>
}
  801d3e:	c9                   	leave  
  801d3f:	c3                   	ret    

00801d40 <devsock_read>:
{
  801d40:	55                   	push   %ebp
  801d41:	89 e5                	mov    %esp,%ebp
  801d43:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801d46:	6a 00                	push   $0x0
  801d48:	ff 75 10             	pushl  0x10(%ebp)
  801d4b:	ff 75 0c             	pushl  0xc(%ebp)
  801d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d51:	ff 70 0c             	pushl  0xc(%eax)
  801d54:	e8 ef 02 00 00       	call   802048 <nsipc_recv>
}
  801d59:	c9                   	leave  
  801d5a:	c3                   	ret    

00801d5b <fd2sockid>:
{
  801d5b:	55                   	push   %ebp
  801d5c:	89 e5                	mov    %esp,%ebp
  801d5e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801d61:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801d64:	52                   	push   %edx
  801d65:	50                   	push   %eax
  801d66:	e8 a3 f6 ff ff       	call   80140e <fd_lookup>
  801d6b:	83 c4 10             	add    $0x10,%esp
  801d6e:	85 c0                	test   %eax,%eax
  801d70:	78 10                	js     801d82 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801d72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d75:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801d7b:	39 08                	cmp    %ecx,(%eax)
  801d7d:	75 05                	jne    801d84 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801d7f:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801d82:	c9                   	leave  
  801d83:	c3                   	ret    
		return -E_NOT_SUPP;
  801d84:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d89:	eb f7                	jmp    801d82 <fd2sockid+0x27>

00801d8b <alloc_sockfd>:
{
  801d8b:	55                   	push   %ebp
  801d8c:	89 e5                	mov    %esp,%ebp
  801d8e:	56                   	push   %esi
  801d8f:	53                   	push   %ebx
  801d90:	83 ec 1c             	sub    $0x1c,%esp
  801d93:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801d95:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d98:	50                   	push   %eax
  801d99:	e8 1e f6 ff ff       	call   8013bc <fd_alloc>
  801d9e:	89 c3                	mov    %eax,%ebx
  801da0:	83 c4 10             	add    $0x10,%esp
  801da3:	85 c0                	test   %eax,%eax
  801da5:	78 43                	js     801dea <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801da7:	83 ec 04             	sub    $0x4,%esp
  801daa:	68 07 04 00 00       	push   $0x407
  801daf:	ff 75 f4             	pushl  -0xc(%ebp)
  801db2:	6a 00                	push   $0x0
  801db4:	e8 e7 f2 ff ff       	call   8010a0 <sys_page_alloc>
  801db9:	89 c3                	mov    %eax,%ebx
  801dbb:	83 c4 10             	add    $0x10,%esp
  801dbe:	85 c0                	test   %eax,%eax
  801dc0:	78 28                	js     801dea <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc5:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801dcb:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801dcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd0:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801dd7:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801dda:	83 ec 0c             	sub    $0xc,%esp
  801ddd:	50                   	push   %eax
  801dde:	e8 b2 f5 ff ff       	call   801395 <fd2num>
  801de3:	89 c3                	mov    %eax,%ebx
  801de5:	83 c4 10             	add    $0x10,%esp
  801de8:	eb 0c                	jmp    801df6 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801dea:	83 ec 0c             	sub    $0xc,%esp
  801ded:	56                   	push   %esi
  801dee:	e8 e4 01 00 00       	call   801fd7 <nsipc_close>
		return r;
  801df3:	83 c4 10             	add    $0x10,%esp
}
  801df6:	89 d8                	mov    %ebx,%eax
  801df8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dfb:	5b                   	pop    %ebx
  801dfc:	5e                   	pop    %esi
  801dfd:	5d                   	pop    %ebp
  801dfe:	c3                   	ret    

00801dff <accept>:
{
  801dff:	55                   	push   %ebp
  801e00:	89 e5                	mov    %esp,%ebp
  801e02:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e05:	8b 45 08             	mov    0x8(%ebp),%eax
  801e08:	e8 4e ff ff ff       	call   801d5b <fd2sockid>
  801e0d:	85 c0                	test   %eax,%eax
  801e0f:	78 1b                	js     801e2c <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801e11:	83 ec 04             	sub    $0x4,%esp
  801e14:	ff 75 10             	pushl  0x10(%ebp)
  801e17:	ff 75 0c             	pushl  0xc(%ebp)
  801e1a:	50                   	push   %eax
  801e1b:	e8 0e 01 00 00       	call   801f2e <nsipc_accept>
  801e20:	83 c4 10             	add    $0x10,%esp
  801e23:	85 c0                	test   %eax,%eax
  801e25:	78 05                	js     801e2c <accept+0x2d>
	return alloc_sockfd(r);
  801e27:	e8 5f ff ff ff       	call   801d8b <alloc_sockfd>
}
  801e2c:	c9                   	leave  
  801e2d:	c3                   	ret    

00801e2e <bind>:
{
  801e2e:	55                   	push   %ebp
  801e2f:	89 e5                	mov    %esp,%ebp
  801e31:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e34:	8b 45 08             	mov    0x8(%ebp),%eax
  801e37:	e8 1f ff ff ff       	call   801d5b <fd2sockid>
  801e3c:	85 c0                	test   %eax,%eax
  801e3e:	78 12                	js     801e52 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801e40:	83 ec 04             	sub    $0x4,%esp
  801e43:	ff 75 10             	pushl  0x10(%ebp)
  801e46:	ff 75 0c             	pushl  0xc(%ebp)
  801e49:	50                   	push   %eax
  801e4a:	e8 31 01 00 00       	call   801f80 <nsipc_bind>
  801e4f:	83 c4 10             	add    $0x10,%esp
}
  801e52:	c9                   	leave  
  801e53:	c3                   	ret    

00801e54 <shutdown>:
{
  801e54:	55                   	push   %ebp
  801e55:	89 e5                	mov    %esp,%ebp
  801e57:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5d:	e8 f9 fe ff ff       	call   801d5b <fd2sockid>
  801e62:	85 c0                	test   %eax,%eax
  801e64:	78 0f                	js     801e75 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801e66:	83 ec 08             	sub    $0x8,%esp
  801e69:	ff 75 0c             	pushl  0xc(%ebp)
  801e6c:	50                   	push   %eax
  801e6d:	e8 43 01 00 00       	call   801fb5 <nsipc_shutdown>
  801e72:	83 c4 10             	add    $0x10,%esp
}
  801e75:	c9                   	leave  
  801e76:	c3                   	ret    

00801e77 <connect>:
{
  801e77:	55                   	push   %ebp
  801e78:	89 e5                	mov    %esp,%ebp
  801e7a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e80:	e8 d6 fe ff ff       	call   801d5b <fd2sockid>
  801e85:	85 c0                	test   %eax,%eax
  801e87:	78 12                	js     801e9b <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801e89:	83 ec 04             	sub    $0x4,%esp
  801e8c:	ff 75 10             	pushl  0x10(%ebp)
  801e8f:	ff 75 0c             	pushl  0xc(%ebp)
  801e92:	50                   	push   %eax
  801e93:	e8 59 01 00 00       	call   801ff1 <nsipc_connect>
  801e98:	83 c4 10             	add    $0x10,%esp
}
  801e9b:	c9                   	leave  
  801e9c:	c3                   	ret    

00801e9d <listen>:
{
  801e9d:	55                   	push   %ebp
  801e9e:	89 e5                	mov    %esp,%ebp
  801ea0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea6:	e8 b0 fe ff ff       	call   801d5b <fd2sockid>
  801eab:	85 c0                	test   %eax,%eax
  801ead:	78 0f                	js     801ebe <listen+0x21>
	return nsipc_listen(r, backlog);
  801eaf:	83 ec 08             	sub    $0x8,%esp
  801eb2:	ff 75 0c             	pushl  0xc(%ebp)
  801eb5:	50                   	push   %eax
  801eb6:	e8 6b 01 00 00       	call   802026 <nsipc_listen>
  801ebb:	83 c4 10             	add    $0x10,%esp
}
  801ebe:	c9                   	leave  
  801ebf:	c3                   	ret    

00801ec0 <socket>:

int
socket(int domain, int type, int protocol)
{
  801ec0:	55                   	push   %ebp
  801ec1:	89 e5                	mov    %esp,%ebp
  801ec3:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801ec6:	ff 75 10             	pushl  0x10(%ebp)
  801ec9:	ff 75 0c             	pushl  0xc(%ebp)
  801ecc:	ff 75 08             	pushl  0x8(%ebp)
  801ecf:	e8 3e 02 00 00       	call   802112 <nsipc_socket>
  801ed4:	83 c4 10             	add    $0x10,%esp
  801ed7:	85 c0                	test   %eax,%eax
  801ed9:	78 05                	js     801ee0 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801edb:	e8 ab fe ff ff       	call   801d8b <alloc_sockfd>
}
  801ee0:	c9                   	leave  
  801ee1:	c3                   	ret    

00801ee2 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801ee2:	55                   	push   %ebp
  801ee3:	89 e5                	mov    %esp,%ebp
  801ee5:	53                   	push   %ebx
  801ee6:	83 ec 04             	sub    $0x4,%esp
  801ee9:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801eeb:	83 3d 04 44 80 00 00 	cmpl   $0x0,0x804404
  801ef2:	74 26                	je     801f1a <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801ef4:	6a 07                	push   $0x7
  801ef6:	68 00 60 80 00       	push   $0x806000
  801efb:	53                   	push   %ebx
  801efc:	ff 35 04 44 80 00    	pushl  0x804404
  801f02:	e8 ec 05 00 00       	call   8024f3 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801f07:	83 c4 0c             	add    $0xc,%esp
  801f0a:	6a 00                	push   $0x0
  801f0c:	6a 00                	push   $0x0
  801f0e:	6a 00                	push   $0x0
  801f10:	e8 75 05 00 00       	call   80248a <ipc_recv>
}
  801f15:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f18:	c9                   	leave  
  801f19:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801f1a:	83 ec 0c             	sub    $0xc,%esp
  801f1d:	6a 02                	push   $0x2
  801f1f:	e8 27 06 00 00       	call   80254b <ipc_find_env>
  801f24:	a3 04 44 80 00       	mov    %eax,0x804404
  801f29:	83 c4 10             	add    $0x10,%esp
  801f2c:	eb c6                	jmp    801ef4 <nsipc+0x12>

00801f2e <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801f2e:	55                   	push   %ebp
  801f2f:	89 e5                	mov    %esp,%ebp
  801f31:	56                   	push   %esi
  801f32:	53                   	push   %ebx
  801f33:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801f36:	8b 45 08             	mov    0x8(%ebp),%eax
  801f39:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801f3e:	8b 06                	mov    (%esi),%eax
  801f40:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801f45:	b8 01 00 00 00       	mov    $0x1,%eax
  801f4a:	e8 93 ff ff ff       	call   801ee2 <nsipc>
  801f4f:	89 c3                	mov    %eax,%ebx
  801f51:	85 c0                	test   %eax,%eax
  801f53:	79 09                	jns    801f5e <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801f55:	89 d8                	mov    %ebx,%eax
  801f57:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f5a:	5b                   	pop    %ebx
  801f5b:	5e                   	pop    %esi
  801f5c:	5d                   	pop    %ebp
  801f5d:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801f5e:	83 ec 04             	sub    $0x4,%esp
  801f61:	ff 35 10 60 80 00    	pushl  0x806010
  801f67:	68 00 60 80 00       	push   $0x806000
  801f6c:	ff 75 0c             	pushl  0xc(%ebp)
  801f6f:	e8 c8 ee ff ff       	call   800e3c <memmove>
		*addrlen = ret->ret_addrlen;
  801f74:	a1 10 60 80 00       	mov    0x806010,%eax
  801f79:	89 06                	mov    %eax,(%esi)
  801f7b:	83 c4 10             	add    $0x10,%esp
	return r;
  801f7e:	eb d5                	jmp    801f55 <nsipc_accept+0x27>

00801f80 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801f80:	55                   	push   %ebp
  801f81:	89 e5                	mov    %esp,%ebp
  801f83:	53                   	push   %ebx
  801f84:	83 ec 08             	sub    $0x8,%esp
  801f87:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8d:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801f92:	53                   	push   %ebx
  801f93:	ff 75 0c             	pushl  0xc(%ebp)
  801f96:	68 04 60 80 00       	push   $0x806004
  801f9b:	e8 9c ee ff ff       	call   800e3c <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801fa0:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801fa6:	b8 02 00 00 00       	mov    $0x2,%eax
  801fab:	e8 32 ff ff ff       	call   801ee2 <nsipc>
}
  801fb0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fb3:	c9                   	leave  
  801fb4:	c3                   	ret    

00801fb5 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801fb5:	55                   	push   %ebp
  801fb6:	89 e5                	mov    %esp,%ebp
  801fb8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbe:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801fc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fc6:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801fcb:	b8 03 00 00 00       	mov    $0x3,%eax
  801fd0:	e8 0d ff ff ff       	call   801ee2 <nsipc>
}
  801fd5:	c9                   	leave  
  801fd6:	c3                   	ret    

00801fd7 <nsipc_close>:

int
nsipc_close(int s)
{
  801fd7:	55                   	push   %ebp
  801fd8:	89 e5                	mov    %esp,%ebp
  801fda:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe0:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801fe5:	b8 04 00 00 00       	mov    $0x4,%eax
  801fea:	e8 f3 fe ff ff       	call   801ee2 <nsipc>
}
  801fef:	c9                   	leave  
  801ff0:	c3                   	ret    

00801ff1 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801ff1:	55                   	push   %ebp
  801ff2:	89 e5                	mov    %esp,%ebp
  801ff4:	53                   	push   %ebx
  801ff5:	83 ec 08             	sub    $0x8,%esp
  801ff8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffe:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802003:	53                   	push   %ebx
  802004:	ff 75 0c             	pushl  0xc(%ebp)
  802007:	68 04 60 80 00       	push   $0x806004
  80200c:	e8 2b ee ff ff       	call   800e3c <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802011:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  802017:	b8 05 00 00 00       	mov    $0x5,%eax
  80201c:	e8 c1 fe ff ff       	call   801ee2 <nsipc>
}
  802021:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802024:	c9                   	leave  
  802025:	c3                   	ret    

00802026 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802026:	55                   	push   %ebp
  802027:	89 e5                	mov    %esp,%ebp
  802029:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80202c:	8b 45 08             	mov    0x8(%ebp),%eax
  80202f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  802034:	8b 45 0c             	mov    0xc(%ebp),%eax
  802037:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  80203c:	b8 06 00 00 00       	mov    $0x6,%eax
  802041:	e8 9c fe ff ff       	call   801ee2 <nsipc>
}
  802046:	c9                   	leave  
  802047:	c3                   	ret    

00802048 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802048:	55                   	push   %ebp
  802049:	89 e5                	mov    %esp,%ebp
  80204b:	56                   	push   %esi
  80204c:	53                   	push   %ebx
  80204d:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802050:	8b 45 08             	mov    0x8(%ebp),%eax
  802053:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  802058:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  80205e:	8b 45 14             	mov    0x14(%ebp),%eax
  802061:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802066:	b8 07 00 00 00       	mov    $0x7,%eax
  80206b:	e8 72 fe ff ff       	call   801ee2 <nsipc>
  802070:	89 c3                	mov    %eax,%ebx
  802072:	85 c0                	test   %eax,%eax
  802074:	78 1f                	js     802095 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802076:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80207b:	7f 21                	jg     80209e <nsipc_recv+0x56>
  80207d:	39 c6                	cmp    %eax,%esi
  80207f:	7c 1d                	jl     80209e <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802081:	83 ec 04             	sub    $0x4,%esp
  802084:	50                   	push   %eax
  802085:	68 00 60 80 00       	push   $0x806000
  80208a:	ff 75 0c             	pushl  0xc(%ebp)
  80208d:	e8 aa ed ff ff       	call   800e3c <memmove>
  802092:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802095:	89 d8                	mov    %ebx,%eax
  802097:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80209a:	5b                   	pop    %ebx
  80209b:	5e                   	pop    %esi
  80209c:	5d                   	pop    %ebp
  80209d:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80209e:	68 b7 2d 80 00       	push   $0x802db7
  8020a3:	68 7f 2d 80 00       	push   $0x802d7f
  8020a8:	6a 62                	push   $0x62
  8020aa:	68 cc 2d 80 00       	push   $0x802dcc
  8020af:	e8 b5 e2 ff ff       	call   800369 <_panic>

008020b4 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8020b4:	55                   	push   %ebp
  8020b5:	89 e5                	mov    %esp,%ebp
  8020b7:	53                   	push   %ebx
  8020b8:	83 ec 04             	sub    $0x4,%esp
  8020bb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8020be:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c1:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8020c6:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8020cc:	7f 2e                	jg     8020fc <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8020ce:	83 ec 04             	sub    $0x4,%esp
  8020d1:	53                   	push   %ebx
  8020d2:	ff 75 0c             	pushl  0xc(%ebp)
  8020d5:	68 0c 60 80 00       	push   $0x80600c
  8020da:	e8 5d ed ff ff       	call   800e3c <memmove>
	nsipcbuf.send.req_size = size;
  8020df:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8020e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8020e8:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8020ed:	b8 08 00 00 00       	mov    $0x8,%eax
  8020f2:	e8 eb fd ff ff       	call   801ee2 <nsipc>
}
  8020f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020fa:	c9                   	leave  
  8020fb:	c3                   	ret    
	assert(size < 1600);
  8020fc:	68 d8 2d 80 00       	push   $0x802dd8
  802101:	68 7f 2d 80 00       	push   $0x802d7f
  802106:	6a 6d                	push   $0x6d
  802108:	68 cc 2d 80 00       	push   $0x802dcc
  80210d:	e8 57 e2 ff ff       	call   800369 <_panic>

00802112 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802112:	55                   	push   %ebp
  802113:	89 e5                	mov    %esp,%ebp
  802115:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802118:	8b 45 08             	mov    0x8(%ebp),%eax
  80211b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  802120:	8b 45 0c             	mov    0xc(%ebp),%eax
  802123:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  802128:	8b 45 10             	mov    0x10(%ebp),%eax
  80212b:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  802130:	b8 09 00 00 00       	mov    $0x9,%eax
  802135:	e8 a8 fd ff ff       	call   801ee2 <nsipc>
}
  80213a:	c9                   	leave  
  80213b:	c3                   	ret    

0080213c <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80213c:	55                   	push   %ebp
  80213d:	89 e5                	mov    %esp,%ebp
  80213f:	56                   	push   %esi
  802140:	53                   	push   %ebx
  802141:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802144:	83 ec 0c             	sub    $0xc,%esp
  802147:	ff 75 08             	pushl  0x8(%ebp)
  80214a:	e8 56 f2 ff ff       	call   8013a5 <fd2data>
  80214f:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802151:	83 c4 08             	add    $0x8,%esp
  802154:	68 e4 2d 80 00       	push   $0x802de4
  802159:	53                   	push   %ebx
  80215a:	e8 4f eb ff ff       	call   800cae <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80215f:	8b 46 04             	mov    0x4(%esi),%eax
  802162:	2b 06                	sub    (%esi),%eax
  802164:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80216a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802171:	00 00 00 
	stat->st_dev = &devpipe;
  802174:	c7 83 88 00 00 00 58 	movl   $0x803058,0x88(%ebx)
  80217b:	30 80 00 
	return 0;
}
  80217e:	b8 00 00 00 00       	mov    $0x0,%eax
  802183:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802186:	5b                   	pop    %ebx
  802187:	5e                   	pop    %esi
  802188:	5d                   	pop    %ebp
  802189:	c3                   	ret    

0080218a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80218a:	55                   	push   %ebp
  80218b:	89 e5                	mov    %esp,%ebp
  80218d:	53                   	push   %ebx
  80218e:	83 ec 0c             	sub    $0xc,%esp
  802191:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802194:	53                   	push   %ebx
  802195:	6a 00                	push   $0x0
  802197:	e8 89 ef ff ff       	call   801125 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80219c:	89 1c 24             	mov    %ebx,(%esp)
  80219f:	e8 01 f2 ff ff       	call   8013a5 <fd2data>
  8021a4:	83 c4 08             	add    $0x8,%esp
  8021a7:	50                   	push   %eax
  8021a8:	6a 00                	push   $0x0
  8021aa:	e8 76 ef ff ff       	call   801125 <sys_page_unmap>
}
  8021af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021b2:	c9                   	leave  
  8021b3:	c3                   	ret    

008021b4 <_pipeisclosed>:
{
  8021b4:	55                   	push   %ebp
  8021b5:	89 e5                	mov    %esp,%ebp
  8021b7:	57                   	push   %edi
  8021b8:	56                   	push   %esi
  8021b9:	53                   	push   %ebx
  8021ba:	83 ec 1c             	sub    $0x1c,%esp
  8021bd:	89 c7                	mov    %eax,%edi
  8021bf:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8021c1:	a1 08 44 80 00       	mov    0x804408,%eax
  8021c6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8021c9:	83 ec 0c             	sub    $0xc,%esp
  8021cc:	57                   	push   %edi
  8021cd:	e8 b8 03 00 00       	call   80258a <pageref>
  8021d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8021d5:	89 34 24             	mov    %esi,(%esp)
  8021d8:	e8 ad 03 00 00       	call   80258a <pageref>
		nn = thisenv->env_runs;
  8021dd:	8b 15 08 44 80 00    	mov    0x804408,%edx
  8021e3:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8021e6:	83 c4 10             	add    $0x10,%esp
  8021e9:	39 cb                	cmp    %ecx,%ebx
  8021eb:	74 1b                	je     802208 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8021ed:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8021f0:	75 cf                	jne    8021c1 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8021f2:	8b 42 58             	mov    0x58(%edx),%eax
  8021f5:	6a 01                	push   $0x1
  8021f7:	50                   	push   %eax
  8021f8:	53                   	push   %ebx
  8021f9:	68 eb 2d 80 00       	push   $0x802deb
  8021fe:	e8 5c e2 ff ff       	call   80045f <cprintf>
  802203:	83 c4 10             	add    $0x10,%esp
  802206:	eb b9                	jmp    8021c1 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802208:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80220b:	0f 94 c0             	sete   %al
  80220e:	0f b6 c0             	movzbl %al,%eax
}
  802211:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802214:	5b                   	pop    %ebx
  802215:	5e                   	pop    %esi
  802216:	5f                   	pop    %edi
  802217:	5d                   	pop    %ebp
  802218:	c3                   	ret    

00802219 <devpipe_write>:
{
  802219:	55                   	push   %ebp
  80221a:	89 e5                	mov    %esp,%ebp
  80221c:	57                   	push   %edi
  80221d:	56                   	push   %esi
  80221e:	53                   	push   %ebx
  80221f:	83 ec 28             	sub    $0x28,%esp
  802222:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802225:	56                   	push   %esi
  802226:	e8 7a f1 ff ff       	call   8013a5 <fd2data>
  80222b:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80222d:	83 c4 10             	add    $0x10,%esp
  802230:	bf 00 00 00 00       	mov    $0x0,%edi
  802235:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802238:	74 4f                	je     802289 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80223a:	8b 43 04             	mov    0x4(%ebx),%eax
  80223d:	8b 0b                	mov    (%ebx),%ecx
  80223f:	8d 51 20             	lea    0x20(%ecx),%edx
  802242:	39 d0                	cmp    %edx,%eax
  802244:	72 14                	jb     80225a <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802246:	89 da                	mov    %ebx,%edx
  802248:	89 f0                	mov    %esi,%eax
  80224a:	e8 65 ff ff ff       	call   8021b4 <_pipeisclosed>
  80224f:	85 c0                	test   %eax,%eax
  802251:	75 3b                	jne    80228e <devpipe_write+0x75>
			sys_yield();
  802253:	e8 29 ee ff ff       	call   801081 <sys_yield>
  802258:	eb e0                	jmp    80223a <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80225a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80225d:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802261:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802264:	89 c2                	mov    %eax,%edx
  802266:	c1 fa 1f             	sar    $0x1f,%edx
  802269:	89 d1                	mov    %edx,%ecx
  80226b:	c1 e9 1b             	shr    $0x1b,%ecx
  80226e:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802271:	83 e2 1f             	and    $0x1f,%edx
  802274:	29 ca                	sub    %ecx,%edx
  802276:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80227a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80227e:	83 c0 01             	add    $0x1,%eax
  802281:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802284:	83 c7 01             	add    $0x1,%edi
  802287:	eb ac                	jmp    802235 <devpipe_write+0x1c>
	return i;
  802289:	8b 45 10             	mov    0x10(%ebp),%eax
  80228c:	eb 05                	jmp    802293 <devpipe_write+0x7a>
				return 0;
  80228e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802293:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802296:	5b                   	pop    %ebx
  802297:	5e                   	pop    %esi
  802298:	5f                   	pop    %edi
  802299:	5d                   	pop    %ebp
  80229a:	c3                   	ret    

0080229b <devpipe_read>:
{
  80229b:	55                   	push   %ebp
  80229c:	89 e5                	mov    %esp,%ebp
  80229e:	57                   	push   %edi
  80229f:	56                   	push   %esi
  8022a0:	53                   	push   %ebx
  8022a1:	83 ec 18             	sub    $0x18,%esp
  8022a4:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8022a7:	57                   	push   %edi
  8022a8:	e8 f8 f0 ff ff       	call   8013a5 <fd2data>
  8022ad:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8022af:	83 c4 10             	add    $0x10,%esp
  8022b2:	be 00 00 00 00       	mov    $0x0,%esi
  8022b7:	3b 75 10             	cmp    0x10(%ebp),%esi
  8022ba:	75 14                	jne    8022d0 <devpipe_read+0x35>
	return i;
  8022bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8022bf:	eb 02                	jmp    8022c3 <devpipe_read+0x28>
				return i;
  8022c1:	89 f0                	mov    %esi,%eax
}
  8022c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022c6:	5b                   	pop    %ebx
  8022c7:	5e                   	pop    %esi
  8022c8:	5f                   	pop    %edi
  8022c9:	5d                   	pop    %ebp
  8022ca:	c3                   	ret    
			sys_yield();
  8022cb:	e8 b1 ed ff ff       	call   801081 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8022d0:	8b 03                	mov    (%ebx),%eax
  8022d2:	3b 43 04             	cmp    0x4(%ebx),%eax
  8022d5:	75 18                	jne    8022ef <devpipe_read+0x54>
			if (i > 0)
  8022d7:	85 f6                	test   %esi,%esi
  8022d9:	75 e6                	jne    8022c1 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8022db:	89 da                	mov    %ebx,%edx
  8022dd:	89 f8                	mov    %edi,%eax
  8022df:	e8 d0 fe ff ff       	call   8021b4 <_pipeisclosed>
  8022e4:	85 c0                	test   %eax,%eax
  8022e6:	74 e3                	je     8022cb <devpipe_read+0x30>
				return 0;
  8022e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ed:	eb d4                	jmp    8022c3 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8022ef:	99                   	cltd   
  8022f0:	c1 ea 1b             	shr    $0x1b,%edx
  8022f3:	01 d0                	add    %edx,%eax
  8022f5:	83 e0 1f             	and    $0x1f,%eax
  8022f8:	29 d0                	sub    %edx,%eax
  8022fa:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8022ff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802302:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802305:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802308:	83 c6 01             	add    $0x1,%esi
  80230b:	eb aa                	jmp    8022b7 <devpipe_read+0x1c>

0080230d <pipe>:
{
  80230d:	55                   	push   %ebp
  80230e:	89 e5                	mov    %esp,%ebp
  802310:	56                   	push   %esi
  802311:	53                   	push   %ebx
  802312:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802315:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802318:	50                   	push   %eax
  802319:	e8 9e f0 ff ff       	call   8013bc <fd_alloc>
  80231e:	89 c3                	mov    %eax,%ebx
  802320:	83 c4 10             	add    $0x10,%esp
  802323:	85 c0                	test   %eax,%eax
  802325:	0f 88 23 01 00 00    	js     80244e <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80232b:	83 ec 04             	sub    $0x4,%esp
  80232e:	68 07 04 00 00       	push   $0x407
  802333:	ff 75 f4             	pushl  -0xc(%ebp)
  802336:	6a 00                	push   $0x0
  802338:	e8 63 ed ff ff       	call   8010a0 <sys_page_alloc>
  80233d:	89 c3                	mov    %eax,%ebx
  80233f:	83 c4 10             	add    $0x10,%esp
  802342:	85 c0                	test   %eax,%eax
  802344:	0f 88 04 01 00 00    	js     80244e <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80234a:	83 ec 0c             	sub    $0xc,%esp
  80234d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802350:	50                   	push   %eax
  802351:	e8 66 f0 ff ff       	call   8013bc <fd_alloc>
  802356:	89 c3                	mov    %eax,%ebx
  802358:	83 c4 10             	add    $0x10,%esp
  80235b:	85 c0                	test   %eax,%eax
  80235d:	0f 88 db 00 00 00    	js     80243e <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802363:	83 ec 04             	sub    $0x4,%esp
  802366:	68 07 04 00 00       	push   $0x407
  80236b:	ff 75 f0             	pushl  -0x10(%ebp)
  80236e:	6a 00                	push   $0x0
  802370:	e8 2b ed ff ff       	call   8010a0 <sys_page_alloc>
  802375:	89 c3                	mov    %eax,%ebx
  802377:	83 c4 10             	add    $0x10,%esp
  80237a:	85 c0                	test   %eax,%eax
  80237c:	0f 88 bc 00 00 00    	js     80243e <pipe+0x131>
	va = fd2data(fd0);
  802382:	83 ec 0c             	sub    $0xc,%esp
  802385:	ff 75 f4             	pushl  -0xc(%ebp)
  802388:	e8 18 f0 ff ff       	call   8013a5 <fd2data>
  80238d:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80238f:	83 c4 0c             	add    $0xc,%esp
  802392:	68 07 04 00 00       	push   $0x407
  802397:	50                   	push   %eax
  802398:	6a 00                	push   $0x0
  80239a:	e8 01 ed ff ff       	call   8010a0 <sys_page_alloc>
  80239f:	89 c3                	mov    %eax,%ebx
  8023a1:	83 c4 10             	add    $0x10,%esp
  8023a4:	85 c0                	test   %eax,%eax
  8023a6:	0f 88 82 00 00 00    	js     80242e <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023ac:	83 ec 0c             	sub    $0xc,%esp
  8023af:	ff 75 f0             	pushl  -0x10(%ebp)
  8023b2:	e8 ee ef ff ff       	call   8013a5 <fd2data>
  8023b7:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8023be:	50                   	push   %eax
  8023bf:	6a 00                	push   $0x0
  8023c1:	56                   	push   %esi
  8023c2:	6a 00                	push   $0x0
  8023c4:	e8 1a ed ff ff       	call   8010e3 <sys_page_map>
  8023c9:	89 c3                	mov    %eax,%ebx
  8023cb:	83 c4 20             	add    $0x20,%esp
  8023ce:	85 c0                	test   %eax,%eax
  8023d0:	78 4e                	js     802420 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8023d2:	a1 58 30 80 00       	mov    0x803058,%eax
  8023d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023da:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8023dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023df:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8023e6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023e9:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8023eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ee:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8023f5:	83 ec 0c             	sub    $0xc,%esp
  8023f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8023fb:	e8 95 ef ff ff       	call   801395 <fd2num>
  802400:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802403:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802405:	83 c4 04             	add    $0x4,%esp
  802408:	ff 75 f0             	pushl  -0x10(%ebp)
  80240b:	e8 85 ef ff ff       	call   801395 <fd2num>
  802410:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802413:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802416:	83 c4 10             	add    $0x10,%esp
  802419:	bb 00 00 00 00       	mov    $0x0,%ebx
  80241e:	eb 2e                	jmp    80244e <pipe+0x141>
	sys_page_unmap(0, va);
  802420:	83 ec 08             	sub    $0x8,%esp
  802423:	56                   	push   %esi
  802424:	6a 00                	push   $0x0
  802426:	e8 fa ec ff ff       	call   801125 <sys_page_unmap>
  80242b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80242e:	83 ec 08             	sub    $0x8,%esp
  802431:	ff 75 f0             	pushl  -0x10(%ebp)
  802434:	6a 00                	push   $0x0
  802436:	e8 ea ec ff ff       	call   801125 <sys_page_unmap>
  80243b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80243e:	83 ec 08             	sub    $0x8,%esp
  802441:	ff 75 f4             	pushl  -0xc(%ebp)
  802444:	6a 00                	push   $0x0
  802446:	e8 da ec ff ff       	call   801125 <sys_page_unmap>
  80244b:	83 c4 10             	add    $0x10,%esp
}
  80244e:	89 d8                	mov    %ebx,%eax
  802450:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802453:	5b                   	pop    %ebx
  802454:	5e                   	pop    %esi
  802455:	5d                   	pop    %ebp
  802456:	c3                   	ret    

00802457 <pipeisclosed>:
{
  802457:	55                   	push   %ebp
  802458:	89 e5                	mov    %esp,%ebp
  80245a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80245d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802460:	50                   	push   %eax
  802461:	ff 75 08             	pushl  0x8(%ebp)
  802464:	e8 a5 ef ff ff       	call   80140e <fd_lookup>
  802469:	83 c4 10             	add    $0x10,%esp
  80246c:	85 c0                	test   %eax,%eax
  80246e:	78 18                	js     802488 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802470:	83 ec 0c             	sub    $0xc,%esp
  802473:	ff 75 f4             	pushl  -0xc(%ebp)
  802476:	e8 2a ef ff ff       	call   8013a5 <fd2data>
	return _pipeisclosed(fd, p);
  80247b:	89 c2                	mov    %eax,%edx
  80247d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802480:	e8 2f fd ff ff       	call   8021b4 <_pipeisclosed>
  802485:	83 c4 10             	add    $0x10,%esp
}
  802488:	c9                   	leave  
  802489:	c3                   	ret    

0080248a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80248a:	55                   	push   %ebp
  80248b:	89 e5                	mov    %esp,%ebp
  80248d:	56                   	push   %esi
  80248e:	53                   	push   %ebx
  80248f:	8b 75 08             	mov    0x8(%ebp),%esi
  802492:	8b 45 0c             	mov    0xc(%ebp),%eax
  802495:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802498:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80249a:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80249f:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8024a2:	83 ec 0c             	sub    $0xc,%esp
  8024a5:	50                   	push   %eax
  8024a6:	e8 a5 ed ff ff       	call   801250 <sys_ipc_recv>
	if(ret < 0){
  8024ab:	83 c4 10             	add    $0x10,%esp
  8024ae:	85 c0                	test   %eax,%eax
  8024b0:	78 2b                	js     8024dd <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8024b2:	85 f6                	test   %esi,%esi
  8024b4:	74 0a                	je     8024c0 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8024b6:	a1 08 44 80 00       	mov    0x804408,%eax
  8024bb:	8b 40 78             	mov    0x78(%eax),%eax
  8024be:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8024c0:	85 db                	test   %ebx,%ebx
  8024c2:	74 0a                	je     8024ce <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8024c4:	a1 08 44 80 00       	mov    0x804408,%eax
  8024c9:	8b 40 7c             	mov    0x7c(%eax),%eax
  8024cc:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8024ce:	a1 08 44 80 00       	mov    0x804408,%eax
  8024d3:	8b 40 74             	mov    0x74(%eax),%eax
}
  8024d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024d9:	5b                   	pop    %ebx
  8024da:	5e                   	pop    %esi
  8024db:	5d                   	pop    %ebp
  8024dc:	c3                   	ret    
		if(from_env_store)
  8024dd:	85 f6                	test   %esi,%esi
  8024df:	74 06                	je     8024e7 <ipc_recv+0x5d>
			*from_env_store = 0;
  8024e1:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8024e7:	85 db                	test   %ebx,%ebx
  8024e9:	74 eb                	je     8024d6 <ipc_recv+0x4c>
			*perm_store = 0;
  8024eb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8024f1:	eb e3                	jmp    8024d6 <ipc_recv+0x4c>

008024f3 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8024f3:	55                   	push   %ebp
  8024f4:	89 e5                	mov    %esp,%ebp
  8024f6:	57                   	push   %edi
  8024f7:	56                   	push   %esi
  8024f8:	53                   	push   %ebx
  8024f9:	83 ec 0c             	sub    $0xc,%esp
  8024fc:	8b 7d 08             	mov    0x8(%ebp),%edi
  8024ff:	8b 75 0c             	mov    0xc(%ebp),%esi
  802502:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802505:	85 db                	test   %ebx,%ebx
  802507:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80250c:	0f 44 d8             	cmove  %eax,%ebx
  80250f:	eb 05                	jmp    802516 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802511:	e8 6b eb ff ff       	call   801081 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802516:	ff 75 14             	pushl  0x14(%ebp)
  802519:	53                   	push   %ebx
  80251a:	56                   	push   %esi
  80251b:	57                   	push   %edi
  80251c:	e8 0c ed ff ff       	call   80122d <sys_ipc_try_send>
  802521:	83 c4 10             	add    $0x10,%esp
  802524:	85 c0                	test   %eax,%eax
  802526:	74 1b                	je     802543 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802528:	79 e7                	jns    802511 <ipc_send+0x1e>
  80252a:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80252d:	74 e2                	je     802511 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80252f:	83 ec 04             	sub    $0x4,%esp
  802532:	68 03 2e 80 00       	push   $0x802e03
  802537:	6a 46                	push   $0x46
  802539:	68 18 2e 80 00       	push   $0x802e18
  80253e:	e8 26 de ff ff       	call   800369 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802543:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802546:	5b                   	pop    %ebx
  802547:	5e                   	pop    %esi
  802548:	5f                   	pop    %edi
  802549:	5d                   	pop    %ebp
  80254a:	c3                   	ret    

0080254b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80254b:	55                   	push   %ebp
  80254c:	89 e5                	mov    %esp,%ebp
  80254e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802551:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802556:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  80255c:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802562:	8b 52 50             	mov    0x50(%edx),%edx
  802565:	39 ca                	cmp    %ecx,%edx
  802567:	74 11                	je     80257a <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  802569:	83 c0 01             	add    $0x1,%eax
  80256c:	3d 00 04 00 00       	cmp    $0x400,%eax
  802571:	75 e3                	jne    802556 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802573:	b8 00 00 00 00       	mov    $0x0,%eax
  802578:	eb 0e                	jmp    802588 <ipc_find_env+0x3d>
			return envs[i].env_id;
  80257a:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  802580:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802585:	8b 40 48             	mov    0x48(%eax),%eax
}
  802588:	5d                   	pop    %ebp
  802589:	c3                   	ret    

0080258a <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80258a:	55                   	push   %ebp
  80258b:	89 e5                	mov    %esp,%ebp
  80258d:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802590:	89 d0                	mov    %edx,%eax
  802592:	c1 e8 16             	shr    $0x16,%eax
  802595:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80259c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8025a1:	f6 c1 01             	test   $0x1,%cl
  8025a4:	74 1d                	je     8025c3 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8025a6:	c1 ea 0c             	shr    $0xc,%edx
  8025a9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8025b0:	f6 c2 01             	test   $0x1,%dl
  8025b3:	74 0e                	je     8025c3 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8025b5:	c1 ea 0c             	shr    $0xc,%edx
  8025b8:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8025bf:	ef 
  8025c0:	0f b7 c0             	movzwl %ax,%eax
}
  8025c3:	5d                   	pop    %ebp
  8025c4:	c3                   	ret    
  8025c5:	66 90                	xchg   %ax,%ax
  8025c7:	66 90                	xchg   %ax,%ax
  8025c9:	66 90                	xchg   %ax,%ax
  8025cb:	66 90                	xchg   %ax,%ax
  8025cd:	66 90                	xchg   %ax,%ax
  8025cf:	90                   	nop

008025d0 <__udivdi3>:
  8025d0:	55                   	push   %ebp
  8025d1:	57                   	push   %edi
  8025d2:	56                   	push   %esi
  8025d3:	53                   	push   %ebx
  8025d4:	83 ec 1c             	sub    $0x1c,%esp
  8025d7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8025db:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8025df:	8b 74 24 34          	mov    0x34(%esp),%esi
  8025e3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8025e7:	85 d2                	test   %edx,%edx
  8025e9:	75 4d                	jne    802638 <__udivdi3+0x68>
  8025eb:	39 f3                	cmp    %esi,%ebx
  8025ed:	76 19                	jbe    802608 <__udivdi3+0x38>
  8025ef:	31 ff                	xor    %edi,%edi
  8025f1:	89 e8                	mov    %ebp,%eax
  8025f3:	89 f2                	mov    %esi,%edx
  8025f5:	f7 f3                	div    %ebx
  8025f7:	89 fa                	mov    %edi,%edx
  8025f9:	83 c4 1c             	add    $0x1c,%esp
  8025fc:	5b                   	pop    %ebx
  8025fd:	5e                   	pop    %esi
  8025fe:	5f                   	pop    %edi
  8025ff:	5d                   	pop    %ebp
  802600:	c3                   	ret    
  802601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802608:	89 d9                	mov    %ebx,%ecx
  80260a:	85 db                	test   %ebx,%ebx
  80260c:	75 0b                	jne    802619 <__udivdi3+0x49>
  80260e:	b8 01 00 00 00       	mov    $0x1,%eax
  802613:	31 d2                	xor    %edx,%edx
  802615:	f7 f3                	div    %ebx
  802617:	89 c1                	mov    %eax,%ecx
  802619:	31 d2                	xor    %edx,%edx
  80261b:	89 f0                	mov    %esi,%eax
  80261d:	f7 f1                	div    %ecx
  80261f:	89 c6                	mov    %eax,%esi
  802621:	89 e8                	mov    %ebp,%eax
  802623:	89 f7                	mov    %esi,%edi
  802625:	f7 f1                	div    %ecx
  802627:	89 fa                	mov    %edi,%edx
  802629:	83 c4 1c             	add    $0x1c,%esp
  80262c:	5b                   	pop    %ebx
  80262d:	5e                   	pop    %esi
  80262e:	5f                   	pop    %edi
  80262f:	5d                   	pop    %ebp
  802630:	c3                   	ret    
  802631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802638:	39 f2                	cmp    %esi,%edx
  80263a:	77 1c                	ja     802658 <__udivdi3+0x88>
  80263c:	0f bd fa             	bsr    %edx,%edi
  80263f:	83 f7 1f             	xor    $0x1f,%edi
  802642:	75 2c                	jne    802670 <__udivdi3+0xa0>
  802644:	39 f2                	cmp    %esi,%edx
  802646:	72 06                	jb     80264e <__udivdi3+0x7e>
  802648:	31 c0                	xor    %eax,%eax
  80264a:	39 eb                	cmp    %ebp,%ebx
  80264c:	77 a9                	ja     8025f7 <__udivdi3+0x27>
  80264e:	b8 01 00 00 00       	mov    $0x1,%eax
  802653:	eb a2                	jmp    8025f7 <__udivdi3+0x27>
  802655:	8d 76 00             	lea    0x0(%esi),%esi
  802658:	31 ff                	xor    %edi,%edi
  80265a:	31 c0                	xor    %eax,%eax
  80265c:	89 fa                	mov    %edi,%edx
  80265e:	83 c4 1c             	add    $0x1c,%esp
  802661:	5b                   	pop    %ebx
  802662:	5e                   	pop    %esi
  802663:	5f                   	pop    %edi
  802664:	5d                   	pop    %ebp
  802665:	c3                   	ret    
  802666:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80266d:	8d 76 00             	lea    0x0(%esi),%esi
  802670:	89 f9                	mov    %edi,%ecx
  802672:	b8 20 00 00 00       	mov    $0x20,%eax
  802677:	29 f8                	sub    %edi,%eax
  802679:	d3 e2                	shl    %cl,%edx
  80267b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80267f:	89 c1                	mov    %eax,%ecx
  802681:	89 da                	mov    %ebx,%edx
  802683:	d3 ea                	shr    %cl,%edx
  802685:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802689:	09 d1                	or     %edx,%ecx
  80268b:	89 f2                	mov    %esi,%edx
  80268d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802691:	89 f9                	mov    %edi,%ecx
  802693:	d3 e3                	shl    %cl,%ebx
  802695:	89 c1                	mov    %eax,%ecx
  802697:	d3 ea                	shr    %cl,%edx
  802699:	89 f9                	mov    %edi,%ecx
  80269b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80269f:	89 eb                	mov    %ebp,%ebx
  8026a1:	d3 e6                	shl    %cl,%esi
  8026a3:	89 c1                	mov    %eax,%ecx
  8026a5:	d3 eb                	shr    %cl,%ebx
  8026a7:	09 de                	or     %ebx,%esi
  8026a9:	89 f0                	mov    %esi,%eax
  8026ab:	f7 74 24 08          	divl   0x8(%esp)
  8026af:	89 d6                	mov    %edx,%esi
  8026b1:	89 c3                	mov    %eax,%ebx
  8026b3:	f7 64 24 0c          	mull   0xc(%esp)
  8026b7:	39 d6                	cmp    %edx,%esi
  8026b9:	72 15                	jb     8026d0 <__udivdi3+0x100>
  8026bb:	89 f9                	mov    %edi,%ecx
  8026bd:	d3 e5                	shl    %cl,%ebp
  8026bf:	39 c5                	cmp    %eax,%ebp
  8026c1:	73 04                	jae    8026c7 <__udivdi3+0xf7>
  8026c3:	39 d6                	cmp    %edx,%esi
  8026c5:	74 09                	je     8026d0 <__udivdi3+0x100>
  8026c7:	89 d8                	mov    %ebx,%eax
  8026c9:	31 ff                	xor    %edi,%edi
  8026cb:	e9 27 ff ff ff       	jmp    8025f7 <__udivdi3+0x27>
  8026d0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8026d3:	31 ff                	xor    %edi,%edi
  8026d5:	e9 1d ff ff ff       	jmp    8025f7 <__udivdi3+0x27>
  8026da:	66 90                	xchg   %ax,%ax
  8026dc:	66 90                	xchg   %ax,%ax
  8026de:	66 90                	xchg   %ax,%ax

008026e0 <__umoddi3>:
  8026e0:	55                   	push   %ebp
  8026e1:	57                   	push   %edi
  8026e2:	56                   	push   %esi
  8026e3:	53                   	push   %ebx
  8026e4:	83 ec 1c             	sub    $0x1c,%esp
  8026e7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8026eb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8026ef:	8b 74 24 30          	mov    0x30(%esp),%esi
  8026f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8026f7:	89 da                	mov    %ebx,%edx
  8026f9:	85 c0                	test   %eax,%eax
  8026fb:	75 43                	jne    802740 <__umoddi3+0x60>
  8026fd:	39 df                	cmp    %ebx,%edi
  8026ff:	76 17                	jbe    802718 <__umoddi3+0x38>
  802701:	89 f0                	mov    %esi,%eax
  802703:	f7 f7                	div    %edi
  802705:	89 d0                	mov    %edx,%eax
  802707:	31 d2                	xor    %edx,%edx
  802709:	83 c4 1c             	add    $0x1c,%esp
  80270c:	5b                   	pop    %ebx
  80270d:	5e                   	pop    %esi
  80270e:	5f                   	pop    %edi
  80270f:	5d                   	pop    %ebp
  802710:	c3                   	ret    
  802711:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802718:	89 fd                	mov    %edi,%ebp
  80271a:	85 ff                	test   %edi,%edi
  80271c:	75 0b                	jne    802729 <__umoddi3+0x49>
  80271e:	b8 01 00 00 00       	mov    $0x1,%eax
  802723:	31 d2                	xor    %edx,%edx
  802725:	f7 f7                	div    %edi
  802727:	89 c5                	mov    %eax,%ebp
  802729:	89 d8                	mov    %ebx,%eax
  80272b:	31 d2                	xor    %edx,%edx
  80272d:	f7 f5                	div    %ebp
  80272f:	89 f0                	mov    %esi,%eax
  802731:	f7 f5                	div    %ebp
  802733:	89 d0                	mov    %edx,%eax
  802735:	eb d0                	jmp    802707 <__umoddi3+0x27>
  802737:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80273e:	66 90                	xchg   %ax,%ax
  802740:	89 f1                	mov    %esi,%ecx
  802742:	39 d8                	cmp    %ebx,%eax
  802744:	76 0a                	jbe    802750 <__umoddi3+0x70>
  802746:	89 f0                	mov    %esi,%eax
  802748:	83 c4 1c             	add    $0x1c,%esp
  80274b:	5b                   	pop    %ebx
  80274c:	5e                   	pop    %esi
  80274d:	5f                   	pop    %edi
  80274e:	5d                   	pop    %ebp
  80274f:	c3                   	ret    
  802750:	0f bd e8             	bsr    %eax,%ebp
  802753:	83 f5 1f             	xor    $0x1f,%ebp
  802756:	75 20                	jne    802778 <__umoddi3+0x98>
  802758:	39 d8                	cmp    %ebx,%eax
  80275a:	0f 82 b0 00 00 00    	jb     802810 <__umoddi3+0x130>
  802760:	39 f7                	cmp    %esi,%edi
  802762:	0f 86 a8 00 00 00    	jbe    802810 <__umoddi3+0x130>
  802768:	89 c8                	mov    %ecx,%eax
  80276a:	83 c4 1c             	add    $0x1c,%esp
  80276d:	5b                   	pop    %ebx
  80276e:	5e                   	pop    %esi
  80276f:	5f                   	pop    %edi
  802770:	5d                   	pop    %ebp
  802771:	c3                   	ret    
  802772:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802778:	89 e9                	mov    %ebp,%ecx
  80277a:	ba 20 00 00 00       	mov    $0x20,%edx
  80277f:	29 ea                	sub    %ebp,%edx
  802781:	d3 e0                	shl    %cl,%eax
  802783:	89 44 24 08          	mov    %eax,0x8(%esp)
  802787:	89 d1                	mov    %edx,%ecx
  802789:	89 f8                	mov    %edi,%eax
  80278b:	d3 e8                	shr    %cl,%eax
  80278d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802791:	89 54 24 04          	mov    %edx,0x4(%esp)
  802795:	8b 54 24 04          	mov    0x4(%esp),%edx
  802799:	09 c1                	or     %eax,%ecx
  80279b:	89 d8                	mov    %ebx,%eax
  80279d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8027a1:	89 e9                	mov    %ebp,%ecx
  8027a3:	d3 e7                	shl    %cl,%edi
  8027a5:	89 d1                	mov    %edx,%ecx
  8027a7:	d3 e8                	shr    %cl,%eax
  8027a9:	89 e9                	mov    %ebp,%ecx
  8027ab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8027af:	d3 e3                	shl    %cl,%ebx
  8027b1:	89 c7                	mov    %eax,%edi
  8027b3:	89 d1                	mov    %edx,%ecx
  8027b5:	89 f0                	mov    %esi,%eax
  8027b7:	d3 e8                	shr    %cl,%eax
  8027b9:	89 e9                	mov    %ebp,%ecx
  8027bb:	89 fa                	mov    %edi,%edx
  8027bd:	d3 e6                	shl    %cl,%esi
  8027bf:	09 d8                	or     %ebx,%eax
  8027c1:	f7 74 24 08          	divl   0x8(%esp)
  8027c5:	89 d1                	mov    %edx,%ecx
  8027c7:	89 f3                	mov    %esi,%ebx
  8027c9:	f7 64 24 0c          	mull   0xc(%esp)
  8027cd:	89 c6                	mov    %eax,%esi
  8027cf:	89 d7                	mov    %edx,%edi
  8027d1:	39 d1                	cmp    %edx,%ecx
  8027d3:	72 06                	jb     8027db <__umoddi3+0xfb>
  8027d5:	75 10                	jne    8027e7 <__umoddi3+0x107>
  8027d7:	39 c3                	cmp    %eax,%ebx
  8027d9:	73 0c                	jae    8027e7 <__umoddi3+0x107>
  8027db:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8027df:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8027e3:	89 d7                	mov    %edx,%edi
  8027e5:	89 c6                	mov    %eax,%esi
  8027e7:	89 ca                	mov    %ecx,%edx
  8027e9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8027ee:	29 f3                	sub    %esi,%ebx
  8027f0:	19 fa                	sbb    %edi,%edx
  8027f2:	89 d0                	mov    %edx,%eax
  8027f4:	d3 e0                	shl    %cl,%eax
  8027f6:	89 e9                	mov    %ebp,%ecx
  8027f8:	d3 eb                	shr    %cl,%ebx
  8027fa:	d3 ea                	shr    %cl,%edx
  8027fc:	09 d8                	or     %ebx,%eax
  8027fe:	83 c4 1c             	add    $0x1c,%esp
  802801:	5b                   	pop    %ebx
  802802:	5e                   	pop    %esi
  802803:	5f                   	pop    %edi
  802804:	5d                   	pop    %ebp
  802805:	c3                   	ret    
  802806:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80280d:	8d 76 00             	lea    0x0(%esi),%esi
  802810:	89 da                	mov    %ebx,%edx
  802812:	29 fe                	sub    %edi,%esi
  802814:	19 c2                	sbb    %eax,%edx
  802816:	89 f1                	mov    %esi,%ecx
  802818:	89 c8                	mov    %ecx,%eax
  80281a:	e9 4b ff ff ff       	jmp    80276a <__umoddi3+0x8a>
