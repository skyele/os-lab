
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
  80003f:	e8 d5 0f 00 00       	call   801019 <sys_yield>
	for (i = 0; i < 10; ++i)
  800044:	83 eb 01             	sub    $0x1,%ebx
  800047:	75 f6                	jne    80003f <umain+0xc>

	close(0);
  800049:	83 ec 0c             	sub    $0xc,%esp
  80004c:	6a 00                	push   $0x0
  80004e:	e8 bd 13 00 00       	call   801410 <close>
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
  800062:	68 3c 22 80 00       	push   $0x80223c
  800067:	6a 11                	push   $0x11
  800069:	68 2d 22 80 00       	push   $0x80222d
  80006e:	e8 8e 02 00 00       	call   800301 <_panic>
		panic("opencons: %e", r);
  800073:	50                   	push   %eax
  800074:	68 20 22 80 00       	push   $0x802220
  800079:	6a 0f                	push   $0xf
  80007b:	68 2d 22 80 00       	push   $0x80222d
  800080:	e8 7c 02 00 00       	call   800301 <_panic>
	if ((r = dup(0, 1)) < 0)
  800085:	83 ec 08             	sub    $0x8,%esp
  800088:	6a 01                	push   $0x1
  80008a:	6a 00                	push   $0x0
  80008c:	e8 d1 13 00 00       	call   801462 <dup>
  800091:	83 c4 10             	add    $0x10,%esp
  800094:	85 c0                	test   %eax,%eax
  800096:	79 24                	jns    8000bc <umain+0x89>
		panic("dup: %e", r);
  800098:	50                   	push   %eax
  800099:	68 56 22 80 00       	push   $0x802256
  80009e:	6a 13                	push   $0x13
  8000a0:	68 2d 22 80 00       	push   $0x80222d
  8000a5:	e8 57 02 00 00       	call   800301 <_panic>

		buf = readline("Type a line: ");
		if (buf != NULL)
			fprintf(1, "%s\n", buf);
		else
			fprintf(1, "(end of file received)\n");
  8000aa:	83 ec 08             	sub    $0x8,%esp
  8000ad:	68 6c 22 80 00       	push   $0x80226c
  8000b2:	6a 01                	push   $0x1
  8000b4:	e8 58 1a 00 00       	call   801b11 <fprintf>
  8000b9:	83 c4 10             	add    $0x10,%esp
		buf = readline("Type a line: ");
  8000bc:	83 ec 0c             	sub    $0xc,%esp
  8000bf:	68 5e 22 80 00       	push   $0x80225e
  8000c4:	e8 54 0a 00 00       	call   800b1d <readline>
		if (buf != NULL)
  8000c9:	83 c4 10             	add    $0x10,%esp
  8000cc:	85 c0                	test   %eax,%eax
  8000ce:	74 da                	je     8000aa <umain+0x77>
			fprintf(1, "%s\n", buf);
  8000d0:	83 ec 04             	sub    $0x4,%esp
  8000d3:	50                   	push   %eax
  8000d4:	68 a1 22 80 00       	push   $0x8022a1
  8000d9:	6a 01                	push   $0x1
  8000db:	e8 31 1a 00 00       	call   801b11 <fprintf>
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
  8000f1:	68 84 22 80 00       	push   $0x802284
  8000f6:	ff 75 0c             	pushl  0xc(%ebp)
  8000f9:	e8 48 0b 00 00       	call   800c46 <strcpy>
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
  80013c:	e8 93 0c 00 00       	call   800dd4 <memmove>
		sys_cputs(buf, m);
  800141:	83 c4 08             	add    $0x8,%esp
  800144:	53                   	push   %ebx
  800145:	57                   	push   %edi
  800146:	e8 31 0e 00 00       	call   800f7c <sys_cputs>
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
  80016d:	e8 28 0e 00 00       	call   800f9a <sys_cgetc>
  800172:	85 c0                	test   %eax,%eax
  800174:	75 07                	jne    80017d <devcons_read+0x21>
		sys_yield();
  800176:	e8 9e 0e 00 00       	call   801019 <sys_yield>
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
  8001a9:	e8 ce 0d 00 00       	call   800f7c <sys_cputs>
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
  8001c1:	e8 88 13 00 00       	call   80154e <read>
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
  8001e9:	e8 f5 10 00 00       	call   8012e3 <fd_lookup>
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
  800212:	e8 7a 10 00 00       	call   801291 <fd_alloc>
  800217:	83 c4 10             	add    $0x10,%esp
  80021a:	85 c0                	test   %eax,%eax
  80021c:	78 3a                	js     800258 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80021e:	83 ec 04             	sub    $0x4,%esp
  800221:	68 07 04 00 00       	push   $0x407
  800226:	ff 75 f4             	pushl  -0xc(%ebp)
  800229:	6a 00                	push   $0x0
  80022b:	e8 08 0e 00 00       	call   801038 <sys_page_alloc>
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
  800250:	e8 15 10 00 00       	call   80126a <fd2num>
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
  800263:	c7 05 04 44 80 00 00 	movl   $0x0,0x804404
  80026a:	00 00 00 
	envid_t find = sys_getenvid();
  80026d:	e8 88 0d 00 00       	call   800ffa <sys_getenvid>
  800272:	8b 1d 04 44 80 00    	mov    0x804404,%ebx
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
  8002bb:	89 1d 04 44 80 00    	mov    %ebx,0x804404
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

	// call user main routine
	umain(argc, argv);
  8002d1:	83 ec 08             	sub    $0x8,%esp
  8002d4:	ff 75 0c             	pushl  0xc(%ebp)
  8002d7:	ff 75 08             	pushl  0x8(%ebp)
  8002da:	e8 54 fd ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8002df:	e8 0b 00 00 00       	call   8002ef <exit>
}
  8002e4:	83 c4 10             	add    $0x10,%esp
  8002e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002ea:	5b                   	pop    %ebx
  8002eb:	5e                   	pop    %esi
  8002ec:	5f                   	pop    %edi
  8002ed:	5d                   	pop    %ebp
  8002ee:	c3                   	ret    

008002ef <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8002ef:	55                   	push   %ebp
  8002f0:	89 e5                	mov    %esp,%ebp
  8002f2:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8002f5:	6a 00                	push   $0x0
  8002f7:	e8 bd 0c 00 00       	call   800fb9 <sys_env_destroy>
}
  8002fc:	83 c4 10             	add    $0x10,%esp
  8002ff:	c9                   	leave  
  800300:	c3                   	ret    

00800301 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800301:	55                   	push   %ebp
  800302:	89 e5                	mov    %esp,%ebp
  800304:	56                   	push   %esi
  800305:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800306:	a1 04 44 80 00       	mov    0x804404,%eax
  80030b:	8b 40 48             	mov    0x48(%eax),%eax
  80030e:	83 ec 04             	sub    $0x4,%esp
  800311:	68 cc 22 80 00       	push   $0x8022cc
  800316:	50                   	push   %eax
  800317:	68 9a 22 80 00       	push   $0x80229a
  80031c:	e8 d6 00 00 00       	call   8003f7 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800321:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800324:	8b 35 1c 30 80 00    	mov    0x80301c,%esi
  80032a:	e8 cb 0c 00 00       	call   800ffa <sys_getenvid>
  80032f:	83 c4 04             	add    $0x4,%esp
  800332:	ff 75 0c             	pushl  0xc(%ebp)
  800335:	ff 75 08             	pushl  0x8(%ebp)
  800338:	56                   	push   %esi
  800339:	50                   	push   %eax
  80033a:	68 a8 22 80 00       	push   $0x8022a8
  80033f:	e8 b3 00 00 00       	call   8003f7 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800344:	83 c4 18             	add    $0x18,%esp
  800347:	53                   	push   %ebx
  800348:	ff 75 10             	pushl  0x10(%ebp)
  80034b:	e8 56 00 00 00       	call   8003a6 <vcprintf>
	cprintf("\n");
  800350:	c7 04 24 af 27 80 00 	movl   $0x8027af,(%esp)
  800357:	e8 9b 00 00 00       	call   8003f7 <cprintf>
  80035c:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80035f:	cc                   	int3   
  800360:	eb fd                	jmp    80035f <_panic+0x5e>

00800362 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800362:	55                   	push   %ebp
  800363:	89 e5                	mov    %esp,%ebp
  800365:	53                   	push   %ebx
  800366:	83 ec 04             	sub    $0x4,%esp
  800369:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80036c:	8b 13                	mov    (%ebx),%edx
  80036e:	8d 42 01             	lea    0x1(%edx),%eax
  800371:	89 03                	mov    %eax,(%ebx)
  800373:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800376:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80037a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80037f:	74 09                	je     80038a <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800381:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800385:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800388:	c9                   	leave  
  800389:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80038a:	83 ec 08             	sub    $0x8,%esp
  80038d:	68 ff 00 00 00       	push   $0xff
  800392:	8d 43 08             	lea    0x8(%ebx),%eax
  800395:	50                   	push   %eax
  800396:	e8 e1 0b 00 00       	call   800f7c <sys_cputs>
		b->idx = 0;
  80039b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003a1:	83 c4 10             	add    $0x10,%esp
  8003a4:	eb db                	jmp    800381 <putch+0x1f>

008003a6 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003a6:	55                   	push   %ebp
  8003a7:	89 e5                	mov    %esp,%ebp
  8003a9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003af:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003b6:	00 00 00 
	b.cnt = 0;
  8003b9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003c0:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003c3:	ff 75 0c             	pushl  0xc(%ebp)
  8003c6:	ff 75 08             	pushl  0x8(%ebp)
  8003c9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003cf:	50                   	push   %eax
  8003d0:	68 62 03 80 00       	push   $0x800362
  8003d5:	e8 4a 01 00 00       	call   800524 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003da:	83 c4 08             	add    $0x8,%esp
  8003dd:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8003e3:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003e9:	50                   	push   %eax
  8003ea:	e8 8d 0b 00 00       	call   800f7c <sys_cputs>

	return b.cnt;
}
  8003ef:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8003f5:	c9                   	leave  
  8003f6:	c3                   	ret    

008003f7 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8003f7:	55                   	push   %ebp
  8003f8:	89 e5                	mov    %esp,%ebp
  8003fa:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003fd:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800400:	50                   	push   %eax
  800401:	ff 75 08             	pushl  0x8(%ebp)
  800404:	e8 9d ff ff ff       	call   8003a6 <vcprintf>
	va_end(ap);

	return cnt;
}
  800409:	c9                   	leave  
  80040a:	c3                   	ret    

0080040b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80040b:	55                   	push   %ebp
  80040c:	89 e5                	mov    %esp,%ebp
  80040e:	57                   	push   %edi
  80040f:	56                   	push   %esi
  800410:	53                   	push   %ebx
  800411:	83 ec 1c             	sub    $0x1c,%esp
  800414:	89 c6                	mov    %eax,%esi
  800416:	89 d7                	mov    %edx,%edi
  800418:	8b 45 08             	mov    0x8(%ebp),%eax
  80041b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80041e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800421:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800424:	8b 45 10             	mov    0x10(%ebp),%eax
  800427:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80042a:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80042e:	74 2c                	je     80045c <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800430:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800433:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80043a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80043d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800440:	39 c2                	cmp    %eax,%edx
  800442:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800445:	73 43                	jae    80048a <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800447:	83 eb 01             	sub    $0x1,%ebx
  80044a:	85 db                	test   %ebx,%ebx
  80044c:	7e 6c                	jle    8004ba <printnum+0xaf>
				putch(padc, putdat);
  80044e:	83 ec 08             	sub    $0x8,%esp
  800451:	57                   	push   %edi
  800452:	ff 75 18             	pushl  0x18(%ebp)
  800455:	ff d6                	call   *%esi
  800457:	83 c4 10             	add    $0x10,%esp
  80045a:	eb eb                	jmp    800447 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80045c:	83 ec 0c             	sub    $0xc,%esp
  80045f:	6a 20                	push   $0x20
  800461:	6a 00                	push   $0x0
  800463:	50                   	push   %eax
  800464:	ff 75 e4             	pushl  -0x1c(%ebp)
  800467:	ff 75 e0             	pushl  -0x20(%ebp)
  80046a:	89 fa                	mov    %edi,%edx
  80046c:	89 f0                	mov    %esi,%eax
  80046e:	e8 98 ff ff ff       	call   80040b <printnum>
		while (--width > 0)
  800473:	83 c4 20             	add    $0x20,%esp
  800476:	83 eb 01             	sub    $0x1,%ebx
  800479:	85 db                	test   %ebx,%ebx
  80047b:	7e 65                	jle    8004e2 <printnum+0xd7>
			putch(padc, putdat);
  80047d:	83 ec 08             	sub    $0x8,%esp
  800480:	57                   	push   %edi
  800481:	6a 20                	push   $0x20
  800483:	ff d6                	call   *%esi
  800485:	83 c4 10             	add    $0x10,%esp
  800488:	eb ec                	jmp    800476 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80048a:	83 ec 0c             	sub    $0xc,%esp
  80048d:	ff 75 18             	pushl  0x18(%ebp)
  800490:	83 eb 01             	sub    $0x1,%ebx
  800493:	53                   	push   %ebx
  800494:	50                   	push   %eax
  800495:	83 ec 08             	sub    $0x8,%esp
  800498:	ff 75 dc             	pushl  -0x24(%ebp)
  80049b:	ff 75 d8             	pushl  -0x28(%ebp)
  80049e:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004a1:	ff 75 e0             	pushl  -0x20(%ebp)
  8004a4:	e8 27 1b 00 00       	call   801fd0 <__udivdi3>
  8004a9:	83 c4 18             	add    $0x18,%esp
  8004ac:	52                   	push   %edx
  8004ad:	50                   	push   %eax
  8004ae:	89 fa                	mov    %edi,%edx
  8004b0:	89 f0                	mov    %esi,%eax
  8004b2:	e8 54 ff ff ff       	call   80040b <printnum>
  8004b7:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8004ba:	83 ec 08             	sub    $0x8,%esp
  8004bd:	57                   	push   %edi
  8004be:	83 ec 04             	sub    $0x4,%esp
  8004c1:	ff 75 dc             	pushl  -0x24(%ebp)
  8004c4:	ff 75 d8             	pushl  -0x28(%ebp)
  8004c7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004ca:	ff 75 e0             	pushl  -0x20(%ebp)
  8004cd:	e8 0e 1c 00 00       	call   8020e0 <__umoddi3>
  8004d2:	83 c4 14             	add    $0x14,%esp
  8004d5:	0f be 80 d3 22 80 00 	movsbl 0x8022d3(%eax),%eax
  8004dc:	50                   	push   %eax
  8004dd:	ff d6                	call   *%esi
  8004df:	83 c4 10             	add    $0x10,%esp
	}
}
  8004e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004e5:	5b                   	pop    %ebx
  8004e6:	5e                   	pop    %esi
  8004e7:	5f                   	pop    %edi
  8004e8:	5d                   	pop    %ebp
  8004e9:	c3                   	ret    

008004ea <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004ea:	55                   	push   %ebp
  8004eb:	89 e5                	mov    %esp,%ebp
  8004ed:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004f0:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004f4:	8b 10                	mov    (%eax),%edx
  8004f6:	3b 50 04             	cmp    0x4(%eax),%edx
  8004f9:	73 0a                	jae    800505 <sprintputch+0x1b>
		*b->buf++ = ch;
  8004fb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004fe:	89 08                	mov    %ecx,(%eax)
  800500:	8b 45 08             	mov    0x8(%ebp),%eax
  800503:	88 02                	mov    %al,(%edx)
}
  800505:	5d                   	pop    %ebp
  800506:	c3                   	ret    

00800507 <printfmt>:
{
  800507:	55                   	push   %ebp
  800508:	89 e5                	mov    %esp,%ebp
  80050a:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80050d:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800510:	50                   	push   %eax
  800511:	ff 75 10             	pushl  0x10(%ebp)
  800514:	ff 75 0c             	pushl  0xc(%ebp)
  800517:	ff 75 08             	pushl  0x8(%ebp)
  80051a:	e8 05 00 00 00       	call   800524 <vprintfmt>
}
  80051f:	83 c4 10             	add    $0x10,%esp
  800522:	c9                   	leave  
  800523:	c3                   	ret    

00800524 <vprintfmt>:
{
  800524:	55                   	push   %ebp
  800525:	89 e5                	mov    %esp,%ebp
  800527:	57                   	push   %edi
  800528:	56                   	push   %esi
  800529:	53                   	push   %ebx
  80052a:	83 ec 3c             	sub    $0x3c,%esp
  80052d:	8b 75 08             	mov    0x8(%ebp),%esi
  800530:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800533:	8b 7d 10             	mov    0x10(%ebp),%edi
  800536:	e9 32 04 00 00       	jmp    80096d <vprintfmt+0x449>
		padc = ' ';
  80053b:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80053f:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800546:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80054d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800554:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80055b:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800562:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800567:	8d 47 01             	lea    0x1(%edi),%eax
  80056a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80056d:	0f b6 17             	movzbl (%edi),%edx
  800570:	8d 42 dd             	lea    -0x23(%edx),%eax
  800573:	3c 55                	cmp    $0x55,%al
  800575:	0f 87 12 05 00 00    	ja     800a8d <vprintfmt+0x569>
  80057b:	0f b6 c0             	movzbl %al,%eax
  80057e:	ff 24 85 c0 24 80 00 	jmp    *0x8024c0(,%eax,4)
  800585:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800588:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80058c:	eb d9                	jmp    800567 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80058e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800591:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800595:	eb d0                	jmp    800567 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800597:	0f b6 d2             	movzbl %dl,%edx
  80059a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80059d:	b8 00 00 00 00       	mov    $0x0,%eax
  8005a2:	89 75 08             	mov    %esi,0x8(%ebp)
  8005a5:	eb 03                	jmp    8005aa <vprintfmt+0x86>
  8005a7:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8005aa:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8005ad:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8005b1:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8005b4:	8d 72 d0             	lea    -0x30(%edx),%esi
  8005b7:	83 fe 09             	cmp    $0x9,%esi
  8005ba:	76 eb                	jbe    8005a7 <vprintfmt+0x83>
  8005bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005bf:	8b 75 08             	mov    0x8(%ebp),%esi
  8005c2:	eb 14                	jmp    8005d8 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8005c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c7:	8b 00                	mov    (%eax),%eax
  8005c9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cf:	8d 40 04             	lea    0x4(%eax),%eax
  8005d2:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005d5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8005d8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005dc:	79 89                	jns    800567 <vprintfmt+0x43>
				width = precision, precision = -1;
  8005de:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005e4:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8005eb:	e9 77 ff ff ff       	jmp    800567 <vprintfmt+0x43>
  8005f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005f3:	85 c0                	test   %eax,%eax
  8005f5:	0f 48 c1             	cmovs  %ecx,%eax
  8005f8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005fb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005fe:	e9 64 ff ff ff       	jmp    800567 <vprintfmt+0x43>
  800603:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800606:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80060d:	e9 55 ff ff ff       	jmp    800567 <vprintfmt+0x43>
			lflag++;
  800612:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800616:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800619:	e9 49 ff ff ff       	jmp    800567 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80061e:	8b 45 14             	mov    0x14(%ebp),%eax
  800621:	8d 78 04             	lea    0x4(%eax),%edi
  800624:	83 ec 08             	sub    $0x8,%esp
  800627:	53                   	push   %ebx
  800628:	ff 30                	pushl  (%eax)
  80062a:	ff d6                	call   *%esi
			break;
  80062c:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80062f:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800632:	e9 33 03 00 00       	jmp    80096a <vprintfmt+0x446>
			err = va_arg(ap, int);
  800637:	8b 45 14             	mov    0x14(%ebp),%eax
  80063a:	8d 78 04             	lea    0x4(%eax),%edi
  80063d:	8b 00                	mov    (%eax),%eax
  80063f:	99                   	cltd   
  800640:	31 d0                	xor    %edx,%eax
  800642:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800644:	83 f8 0f             	cmp    $0xf,%eax
  800647:	7f 23                	jg     80066c <vprintfmt+0x148>
  800649:	8b 14 85 20 26 80 00 	mov    0x802620(,%eax,4),%edx
  800650:	85 d2                	test   %edx,%edx
  800652:	74 18                	je     80066c <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800654:	52                   	push   %edx
  800655:	68 6e 27 80 00       	push   $0x80276e
  80065a:	53                   	push   %ebx
  80065b:	56                   	push   %esi
  80065c:	e8 a6 fe ff ff       	call   800507 <printfmt>
  800661:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800664:	89 7d 14             	mov    %edi,0x14(%ebp)
  800667:	e9 fe 02 00 00       	jmp    80096a <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80066c:	50                   	push   %eax
  80066d:	68 eb 22 80 00       	push   $0x8022eb
  800672:	53                   	push   %ebx
  800673:	56                   	push   %esi
  800674:	e8 8e fe ff ff       	call   800507 <printfmt>
  800679:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80067c:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80067f:	e9 e6 02 00 00       	jmp    80096a <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800684:	8b 45 14             	mov    0x14(%ebp),%eax
  800687:	83 c0 04             	add    $0x4,%eax
  80068a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80068d:	8b 45 14             	mov    0x14(%ebp),%eax
  800690:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800692:	85 c9                	test   %ecx,%ecx
  800694:	b8 e4 22 80 00       	mov    $0x8022e4,%eax
  800699:	0f 45 c1             	cmovne %ecx,%eax
  80069c:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80069f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006a3:	7e 06                	jle    8006ab <vprintfmt+0x187>
  8006a5:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8006a9:	75 0d                	jne    8006b8 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006ab:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8006ae:	89 c7                	mov    %eax,%edi
  8006b0:	03 45 e0             	add    -0x20(%ebp),%eax
  8006b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006b6:	eb 53                	jmp    80070b <vprintfmt+0x1e7>
  8006b8:	83 ec 08             	sub    $0x8,%esp
  8006bb:	ff 75 d8             	pushl  -0x28(%ebp)
  8006be:	50                   	push   %eax
  8006bf:	e8 61 05 00 00       	call   800c25 <strnlen>
  8006c4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006c7:	29 c1                	sub    %eax,%ecx
  8006c9:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8006cc:	83 c4 10             	add    $0x10,%esp
  8006cf:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8006d1:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8006d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8006d8:	eb 0f                	jmp    8006e9 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8006da:	83 ec 08             	sub    $0x8,%esp
  8006dd:	53                   	push   %ebx
  8006de:	ff 75 e0             	pushl  -0x20(%ebp)
  8006e1:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006e3:	83 ef 01             	sub    $0x1,%edi
  8006e6:	83 c4 10             	add    $0x10,%esp
  8006e9:	85 ff                	test   %edi,%edi
  8006eb:	7f ed                	jg     8006da <vprintfmt+0x1b6>
  8006ed:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8006f0:	85 c9                	test   %ecx,%ecx
  8006f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8006f7:	0f 49 c1             	cmovns %ecx,%eax
  8006fa:	29 c1                	sub    %eax,%ecx
  8006fc:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8006ff:	eb aa                	jmp    8006ab <vprintfmt+0x187>
					putch(ch, putdat);
  800701:	83 ec 08             	sub    $0x8,%esp
  800704:	53                   	push   %ebx
  800705:	52                   	push   %edx
  800706:	ff d6                	call   *%esi
  800708:	83 c4 10             	add    $0x10,%esp
  80070b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80070e:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800710:	83 c7 01             	add    $0x1,%edi
  800713:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800717:	0f be d0             	movsbl %al,%edx
  80071a:	85 d2                	test   %edx,%edx
  80071c:	74 4b                	je     800769 <vprintfmt+0x245>
  80071e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800722:	78 06                	js     80072a <vprintfmt+0x206>
  800724:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800728:	78 1e                	js     800748 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  80072a:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80072e:	74 d1                	je     800701 <vprintfmt+0x1dd>
  800730:	0f be c0             	movsbl %al,%eax
  800733:	83 e8 20             	sub    $0x20,%eax
  800736:	83 f8 5e             	cmp    $0x5e,%eax
  800739:	76 c6                	jbe    800701 <vprintfmt+0x1dd>
					putch('?', putdat);
  80073b:	83 ec 08             	sub    $0x8,%esp
  80073e:	53                   	push   %ebx
  80073f:	6a 3f                	push   $0x3f
  800741:	ff d6                	call   *%esi
  800743:	83 c4 10             	add    $0x10,%esp
  800746:	eb c3                	jmp    80070b <vprintfmt+0x1e7>
  800748:	89 cf                	mov    %ecx,%edi
  80074a:	eb 0e                	jmp    80075a <vprintfmt+0x236>
				putch(' ', putdat);
  80074c:	83 ec 08             	sub    $0x8,%esp
  80074f:	53                   	push   %ebx
  800750:	6a 20                	push   $0x20
  800752:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800754:	83 ef 01             	sub    $0x1,%edi
  800757:	83 c4 10             	add    $0x10,%esp
  80075a:	85 ff                	test   %edi,%edi
  80075c:	7f ee                	jg     80074c <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80075e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800761:	89 45 14             	mov    %eax,0x14(%ebp)
  800764:	e9 01 02 00 00       	jmp    80096a <vprintfmt+0x446>
  800769:	89 cf                	mov    %ecx,%edi
  80076b:	eb ed                	jmp    80075a <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80076d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800770:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800777:	e9 eb fd ff ff       	jmp    800567 <vprintfmt+0x43>
	if (lflag >= 2)
  80077c:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800780:	7f 21                	jg     8007a3 <vprintfmt+0x27f>
	else if (lflag)
  800782:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800786:	74 68                	je     8007f0 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800788:	8b 45 14             	mov    0x14(%ebp),%eax
  80078b:	8b 00                	mov    (%eax),%eax
  80078d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800790:	89 c1                	mov    %eax,%ecx
  800792:	c1 f9 1f             	sar    $0x1f,%ecx
  800795:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800798:	8b 45 14             	mov    0x14(%ebp),%eax
  80079b:	8d 40 04             	lea    0x4(%eax),%eax
  80079e:	89 45 14             	mov    %eax,0x14(%ebp)
  8007a1:	eb 17                	jmp    8007ba <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8007a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a6:	8b 50 04             	mov    0x4(%eax),%edx
  8007a9:	8b 00                	mov    (%eax),%eax
  8007ab:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8007ae:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8007b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b4:	8d 40 08             	lea    0x8(%eax),%eax
  8007b7:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8007ba:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007bd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8007c0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c3:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8007c6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8007ca:	78 3f                	js     80080b <vprintfmt+0x2e7>
			base = 10;
  8007cc:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8007d1:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8007d5:	0f 84 71 01 00 00    	je     80094c <vprintfmt+0x428>
				putch('+', putdat);
  8007db:	83 ec 08             	sub    $0x8,%esp
  8007de:	53                   	push   %ebx
  8007df:	6a 2b                	push   $0x2b
  8007e1:	ff d6                	call   *%esi
  8007e3:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007e6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007eb:	e9 5c 01 00 00       	jmp    80094c <vprintfmt+0x428>
		return va_arg(*ap, int);
  8007f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f3:	8b 00                	mov    (%eax),%eax
  8007f5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8007f8:	89 c1                	mov    %eax,%ecx
  8007fa:	c1 f9 1f             	sar    $0x1f,%ecx
  8007fd:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800800:	8b 45 14             	mov    0x14(%ebp),%eax
  800803:	8d 40 04             	lea    0x4(%eax),%eax
  800806:	89 45 14             	mov    %eax,0x14(%ebp)
  800809:	eb af                	jmp    8007ba <vprintfmt+0x296>
				putch('-', putdat);
  80080b:	83 ec 08             	sub    $0x8,%esp
  80080e:	53                   	push   %ebx
  80080f:	6a 2d                	push   $0x2d
  800811:	ff d6                	call   *%esi
				num = -(long long) num;
  800813:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800816:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800819:	f7 d8                	neg    %eax
  80081b:	83 d2 00             	adc    $0x0,%edx
  80081e:	f7 da                	neg    %edx
  800820:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800823:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800826:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800829:	b8 0a 00 00 00       	mov    $0xa,%eax
  80082e:	e9 19 01 00 00       	jmp    80094c <vprintfmt+0x428>
	if (lflag >= 2)
  800833:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800837:	7f 29                	jg     800862 <vprintfmt+0x33e>
	else if (lflag)
  800839:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80083d:	74 44                	je     800883 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80083f:	8b 45 14             	mov    0x14(%ebp),%eax
  800842:	8b 00                	mov    (%eax),%eax
  800844:	ba 00 00 00 00       	mov    $0x0,%edx
  800849:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80084c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80084f:	8b 45 14             	mov    0x14(%ebp),%eax
  800852:	8d 40 04             	lea    0x4(%eax),%eax
  800855:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800858:	b8 0a 00 00 00       	mov    $0xa,%eax
  80085d:	e9 ea 00 00 00       	jmp    80094c <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800862:	8b 45 14             	mov    0x14(%ebp),%eax
  800865:	8b 50 04             	mov    0x4(%eax),%edx
  800868:	8b 00                	mov    (%eax),%eax
  80086a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80086d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800870:	8b 45 14             	mov    0x14(%ebp),%eax
  800873:	8d 40 08             	lea    0x8(%eax),%eax
  800876:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800879:	b8 0a 00 00 00       	mov    $0xa,%eax
  80087e:	e9 c9 00 00 00       	jmp    80094c <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800883:	8b 45 14             	mov    0x14(%ebp),%eax
  800886:	8b 00                	mov    (%eax),%eax
  800888:	ba 00 00 00 00       	mov    $0x0,%edx
  80088d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800890:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800893:	8b 45 14             	mov    0x14(%ebp),%eax
  800896:	8d 40 04             	lea    0x4(%eax),%eax
  800899:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80089c:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008a1:	e9 a6 00 00 00       	jmp    80094c <vprintfmt+0x428>
			putch('0', putdat);
  8008a6:	83 ec 08             	sub    $0x8,%esp
  8008a9:	53                   	push   %ebx
  8008aa:	6a 30                	push   $0x30
  8008ac:	ff d6                	call   *%esi
	if (lflag >= 2)
  8008ae:	83 c4 10             	add    $0x10,%esp
  8008b1:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8008b5:	7f 26                	jg     8008dd <vprintfmt+0x3b9>
	else if (lflag)
  8008b7:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8008bb:	74 3e                	je     8008fb <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8008bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c0:	8b 00                	mov    (%eax),%eax
  8008c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8008c7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008ca:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d0:	8d 40 04             	lea    0x4(%eax),%eax
  8008d3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008d6:	b8 08 00 00 00       	mov    $0x8,%eax
  8008db:	eb 6f                	jmp    80094c <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8008dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e0:	8b 50 04             	mov    0x4(%eax),%edx
  8008e3:	8b 00                	mov    (%eax),%eax
  8008e5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008e8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ee:	8d 40 08             	lea    0x8(%eax),%eax
  8008f1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008f4:	b8 08 00 00 00       	mov    $0x8,%eax
  8008f9:	eb 51                	jmp    80094c <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8008fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fe:	8b 00                	mov    (%eax),%eax
  800900:	ba 00 00 00 00       	mov    $0x0,%edx
  800905:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800908:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80090b:	8b 45 14             	mov    0x14(%ebp),%eax
  80090e:	8d 40 04             	lea    0x4(%eax),%eax
  800911:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800914:	b8 08 00 00 00       	mov    $0x8,%eax
  800919:	eb 31                	jmp    80094c <vprintfmt+0x428>
			putch('0', putdat);
  80091b:	83 ec 08             	sub    $0x8,%esp
  80091e:	53                   	push   %ebx
  80091f:	6a 30                	push   $0x30
  800921:	ff d6                	call   *%esi
			putch('x', putdat);
  800923:	83 c4 08             	add    $0x8,%esp
  800926:	53                   	push   %ebx
  800927:	6a 78                	push   $0x78
  800929:	ff d6                	call   *%esi
			num = (unsigned long long)
  80092b:	8b 45 14             	mov    0x14(%ebp),%eax
  80092e:	8b 00                	mov    (%eax),%eax
  800930:	ba 00 00 00 00       	mov    $0x0,%edx
  800935:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800938:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80093b:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80093e:	8b 45 14             	mov    0x14(%ebp),%eax
  800941:	8d 40 04             	lea    0x4(%eax),%eax
  800944:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800947:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80094c:	83 ec 0c             	sub    $0xc,%esp
  80094f:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800953:	52                   	push   %edx
  800954:	ff 75 e0             	pushl  -0x20(%ebp)
  800957:	50                   	push   %eax
  800958:	ff 75 dc             	pushl  -0x24(%ebp)
  80095b:	ff 75 d8             	pushl  -0x28(%ebp)
  80095e:	89 da                	mov    %ebx,%edx
  800960:	89 f0                	mov    %esi,%eax
  800962:	e8 a4 fa ff ff       	call   80040b <printnum>
			break;
  800967:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80096a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80096d:	83 c7 01             	add    $0x1,%edi
  800970:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800974:	83 f8 25             	cmp    $0x25,%eax
  800977:	0f 84 be fb ff ff    	je     80053b <vprintfmt+0x17>
			if (ch == '\0')
  80097d:	85 c0                	test   %eax,%eax
  80097f:	0f 84 28 01 00 00    	je     800aad <vprintfmt+0x589>
			putch(ch, putdat);
  800985:	83 ec 08             	sub    $0x8,%esp
  800988:	53                   	push   %ebx
  800989:	50                   	push   %eax
  80098a:	ff d6                	call   *%esi
  80098c:	83 c4 10             	add    $0x10,%esp
  80098f:	eb dc                	jmp    80096d <vprintfmt+0x449>
	if (lflag >= 2)
  800991:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800995:	7f 26                	jg     8009bd <vprintfmt+0x499>
	else if (lflag)
  800997:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80099b:	74 41                	je     8009de <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  80099d:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a0:	8b 00                	mov    (%eax),%eax
  8009a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8009a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009aa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b0:	8d 40 04             	lea    0x4(%eax),%eax
  8009b3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009b6:	b8 10 00 00 00       	mov    $0x10,%eax
  8009bb:	eb 8f                	jmp    80094c <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8009bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c0:	8b 50 04             	mov    0x4(%eax),%edx
  8009c3:	8b 00                	mov    (%eax),%eax
  8009c5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009c8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ce:	8d 40 08             	lea    0x8(%eax),%eax
  8009d1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009d4:	b8 10 00 00 00       	mov    $0x10,%eax
  8009d9:	e9 6e ff ff ff       	jmp    80094c <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8009de:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e1:	8b 00                	mov    (%eax),%eax
  8009e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8009e8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009eb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f1:	8d 40 04             	lea    0x4(%eax),%eax
  8009f4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009f7:	b8 10 00 00 00       	mov    $0x10,%eax
  8009fc:	e9 4b ff ff ff       	jmp    80094c <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800a01:	8b 45 14             	mov    0x14(%ebp),%eax
  800a04:	83 c0 04             	add    $0x4,%eax
  800a07:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a0a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0d:	8b 00                	mov    (%eax),%eax
  800a0f:	85 c0                	test   %eax,%eax
  800a11:	74 14                	je     800a27 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800a13:	8b 13                	mov    (%ebx),%edx
  800a15:	83 fa 7f             	cmp    $0x7f,%edx
  800a18:	7f 37                	jg     800a51 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800a1a:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800a1c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a1f:	89 45 14             	mov    %eax,0x14(%ebp)
  800a22:	e9 43 ff ff ff       	jmp    80096a <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800a27:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a2c:	bf 09 24 80 00       	mov    $0x802409,%edi
							putch(ch, putdat);
  800a31:	83 ec 08             	sub    $0x8,%esp
  800a34:	53                   	push   %ebx
  800a35:	50                   	push   %eax
  800a36:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800a38:	83 c7 01             	add    $0x1,%edi
  800a3b:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800a3f:	83 c4 10             	add    $0x10,%esp
  800a42:	85 c0                	test   %eax,%eax
  800a44:	75 eb                	jne    800a31 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800a46:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a49:	89 45 14             	mov    %eax,0x14(%ebp)
  800a4c:	e9 19 ff ff ff       	jmp    80096a <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800a51:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800a53:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a58:	bf 41 24 80 00       	mov    $0x802441,%edi
							putch(ch, putdat);
  800a5d:	83 ec 08             	sub    $0x8,%esp
  800a60:	53                   	push   %ebx
  800a61:	50                   	push   %eax
  800a62:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800a64:	83 c7 01             	add    $0x1,%edi
  800a67:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800a6b:	83 c4 10             	add    $0x10,%esp
  800a6e:	85 c0                	test   %eax,%eax
  800a70:	75 eb                	jne    800a5d <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800a72:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a75:	89 45 14             	mov    %eax,0x14(%ebp)
  800a78:	e9 ed fe ff ff       	jmp    80096a <vprintfmt+0x446>
			putch(ch, putdat);
  800a7d:	83 ec 08             	sub    $0x8,%esp
  800a80:	53                   	push   %ebx
  800a81:	6a 25                	push   $0x25
  800a83:	ff d6                	call   *%esi
			break;
  800a85:	83 c4 10             	add    $0x10,%esp
  800a88:	e9 dd fe ff ff       	jmp    80096a <vprintfmt+0x446>
			putch('%', putdat);
  800a8d:	83 ec 08             	sub    $0x8,%esp
  800a90:	53                   	push   %ebx
  800a91:	6a 25                	push   $0x25
  800a93:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a95:	83 c4 10             	add    $0x10,%esp
  800a98:	89 f8                	mov    %edi,%eax
  800a9a:	eb 03                	jmp    800a9f <vprintfmt+0x57b>
  800a9c:	83 e8 01             	sub    $0x1,%eax
  800a9f:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800aa3:	75 f7                	jne    800a9c <vprintfmt+0x578>
  800aa5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800aa8:	e9 bd fe ff ff       	jmp    80096a <vprintfmt+0x446>
}
  800aad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ab0:	5b                   	pop    %ebx
  800ab1:	5e                   	pop    %esi
  800ab2:	5f                   	pop    %edi
  800ab3:	5d                   	pop    %ebp
  800ab4:	c3                   	ret    

00800ab5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ab5:	55                   	push   %ebp
  800ab6:	89 e5                	mov    %esp,%ebp
  800ab8:	83 ec 18             	sub    $0x18,%esp
  800abb:	8b 45 08             	mov    0x8(%ebp),%eax
  800abe:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ac1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ac4:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800ac8:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800acb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ad2:	85 c0                	test   %eax,%eax
  800ad4:	74 26                	je     800afc <vsnprintf+0x47>
  800ad6:	85 d2                	test   %edx,%edx
  800ad8:	7e 22                	jle    800afc <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ada:	ff 75 14             	pushl  0x14(%ebp)
  800add:	ff 75 10             	pushl  0x10(%ebp)
  800ae0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ae3:	50                   	push   %eax
  800ae4:	68 ea 04 80 00       	push   $0x8004ea
  800ae9:	e8 36 fa ff ff       	call   800524 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800aee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800af1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800af7:	83 c4 10             	add    $0x10,%esp
}
  800afa:	c9                   	leave  
  800afb:	c3                   	ret    
		return -E_INVAL;
  800afc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b01:	eb f7                	jmp    800afa <vsnprintf+0x45>

00800b03 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b03:	55                   	push   %ebp
  800b04:	89 e5                	mov    %esp,%ebp
  800b06:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b09:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800b0c:	50                   	push   %eax
  800b0d:	ff 75 10             	pushl  0x10(%ebp)
  800b10:	ff 75 0c             	pushl  0xc(%ebp)
  800b13:	ff 75 08             	pushl  0x8(%ebp)
  800b16:	e8 9a ff ff ff       	call   800ab5 <vsnprintf>
	va_end(ap);

	return rc;
}
  800b1b:	c9                   	leave  
  800b1c:	c3                   	ret    

00800b1d <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  800b1d:	55                   	push   %ebp
  800b1e:	89 e5                	mov    %esp,%ebp
  800b20:	57                   	push   %edi
  800b21:	56                   	push   %esi
  800b22:	53                   	push   %ebx
  800b23:	83 ec 0c             	sub    $0xc,%esp
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  800b29:	85 c0                	test   %eax,%eax
  800b2b:	74 13                	je     800b40 <readline+0x23>
		fprintf(1, "%s", prompt);
  800b2d:	83 ec 04             	sub    $0x4,%esp
  800b30:	50                   	push   %eax
  800b31:	68 6e 27 80 00       	push   $0x80276e
  800b36:	6a 01                	push   $0x1
  800b38:	e8 d4 0f 00 00       	call   801b11 <fprintf>
  800b3d:	83 c4 10             	add    $0x10,%esp
#endif

	i = 0;
	echoing = iscons(0);
  800b40:	83 ec 0c             	sub    $0xc,%esp
  800b43:	6a 00                	push   $0x0
  800b45:	e8 92 f6 ff ff       	call   8001dc <iscons>
  800b4a:	89 c7                	mov    %eax,%edi
  800b4c:	83 c4 10             	add    $0x10,%esp
	i = 0;
  800b4f:	be 00 00 00 00       	mov    $0x0,%esi
  800b54:	eb 57                	jmp    800bad <readline+0x90>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
  800b56:	b8 00 00 00 00       	mov    $0x0,%eax
			if (c != -E_EOF)
  800b5b:	83 fb f8             	cmp    $0xfffffff8,%ebx
  800b5e:	75 08                	jne    800b68 <readline+0x4b>
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
  800b60:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b63:	5b                   	pop    %ebx
  800b64:	5e                   	pop    %esi
  800b65:	5f                   	pop    %edi
  800b66:	5d                   	pop    %ebp
  800b67:	c3                   	ret    
				cprintf("read error: %e\n", c);
  800b68:	83 ec 08             	sub    $0x8,%esp
  800b6b:	53                   	push   %ebx
  800b6c:	68 60 26 80 00       	push   $0x802660
  800b71:	e8 81 f8 ff ff       	call   8003f7 <cprintf>
  800b76:	83 c4 10             	add    $0x10,%esp
			return NULL;
  800b79:	b8 00 00 00 00       	mov    $0x0,%eax
  800b7e:	eb e0                	jmp    800b60 <readline+0x43>
			if (echoing)
  800b80:	85 ff                	test   %edi,%edi
  800b82:	75 05                	jne    800b89 <readline+0x6c>
			i--;
  800b84:	83 ee 01             	sub    $0x1,%esi
  800b87:	eb 24                	jmp    800bad <readline+0x90>
				cputchar('\b');
  800b89:	83 ec 0c             	sub    $0xc,%esp
  800b8c:	6a 08                	push   $0x8
  800b8e:	e8 04 f6 ff ff       	call   800197 <cputchar>
  800b93:	83 c4 10             	add    $0x10,%esp
  800b96:	eb ec                	jmp    800b84 <readline+0x67>
				cputchar(c);
  800b98:	83 ec 0c             	sub    $0xc,%esp
  800b9b:	53                   	push   %ebx
  800b9c:	e8 f6 f5 ff ff       	call   800197 <cputchar>
  800ba1:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800ba4:	88 9e 00 40 80 00    	mov    %bl,0x804000(%esi)
  800baa:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
  800bad:	e8 01 f6 ff ff       	call   8001b3 <getchar>
  800bb2:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  800bb4:	85 c0                	test   %eax,%eax
  800bb6:	78 9e                	js     800b56 <readline+0x39>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  800bb8:	83 f8 08             	cmp    $0x8,%eax
  800bbb:	0f 94 c2             	sete   %dl
  800bbe:	83 f8 7f             	cmp    $0x7f,%eax
  800bc1:	0f 94 c0             	sete   %al
  800bc4:	08 c2                	or     %al,%dl
  800bc6:	74 04                	je     800bcc <readline+0xaf>
  800bc8:	85 f6                	test   %esi,%esi
  800bca:	7f b4                	jg     800b80 <readline+0x63>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800bcc:	83 fb 1f             	cmp    $0x1f,%ebx
  800bcf:	7e 0e                	jle    800bdf <readline+0xc2>
  800bd1:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  800bd7:	7f 06                	jg     800bdf <readline+0xc2>
			if (echoing)
  800bd9:	85 ff                	test   %edi,%edi
  800bdb:	74 c7                	je     800ba4 <readline+0x87>
  800bdd:	eb b9                	jmp    800b98 <readline+0x7b>
		} else if (c == '\n' || c == '\r') {
  800bdf:	83 fb 0a             	cmp    $0xa,%ebx
  800be2:	74 05                	je     800be9 <readline+0xcc>
  800be4:	83 fb 0d             	cmp    $0xd,%ebx
  800be7:	75 c4                	jne    800bad <readline+0x90>
			if (echoing)
  800be9:	85 ff                	test   %edi,%edi
  800beb:	75 11                	jne    800bfe <readline+0xe1>
			buf[i] = 0;
  800bed:	c6 86 00 40 80 00 00 	movb   $0x0,0x804000(%esi)
			return buf;
  800bf4:	b8 00 40 80 00       	mov    $0x804000,%eax
  800bf9:	e9 62 ff ff ff       	jmp    800b60 <readline+0x43>
				cputchar('\n');
  800bfe:	83 ec 0c             	sub    $0xc,%esp
  800c01:	6a 0a                	push   $0xa
  800c03:	e8 8f f5 ff ff       	call   800197 <cputchar>
  800c08:	83 c4 10             	add    $0x10,%esp
  800c0b:	eb e0                	jmp    800bed <readline+0xd0>

00800c0d <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800c0d:	55                   	push   %ebp
  800c0e:	89 e5                	mov    %esp,%ebp
  800c10:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800c13:	b8 00 00 00 00       	mov    $0x0,%eax
  800c18:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800c1c:	74 05                	je     800c23 <strlen+0x16>
		n++;
  800c1e:	83 c0 01             	add    $0x1,%eax
  800c21:	eb f5                	jmp    800c18 <strlen+0xb>
	return n;
}
  800c23:	5d                   	pop    %ebp
  800c24:	c3                   	ret    

00800c25 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800c25:	55                   	push   %ebp
  800c26:	89 e5                	mov    %esp,%ebp
  800c28:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c2b:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c2e:	ba 00 00 00 00       	mov    $0x0,%edx
  800c33:	39 c2                	cmp    %eax,%edx
  800c35:	74 0d                	je     800c44 <strnlen+0x1f>
  800c37:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800c3b:	74 05                	je     800c42 <strnlen+0x1d>
		n++;
  800c3d:	83 c2 01             	add    $0x1,%edx
  800c40:	eb f1                	jmp    800c33 <strnlen+0xe>
  800c42:	89 d0                	mov    %edx,%eax
	return n;
}
  800c44:	5d                   	pop    %ebp
  800c45:	c3                   	ret    

00800c46 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c46:	55                   	push   %ebp
  800c47:	89 e5                	mov    %esp,%ebp
  800c49:	53                   	push   %ebx
  800c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800c50:	ba 00 00 00 00       	mov    $0x0,%edx
  800c55:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800c59:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800c5c:	83 c2 01             	add    $0x1,%edx
  800c5f:	84 c9                	test   %cl,%cl
  800c61:	75 f2                	jne    800c55 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800c63:	5b                   	pop    %ebx
  800c64:	5d                   	pop    %ebp
  800c65:	c3                   	ret    

00800c66 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800c66:	55                   	push   %ebp
  800c67:	89 e5                	mov    %esp,%ebp
  800c69:	53                   	push   %ebx
  800c6a:	83 ec 10             	sub    $0x10,%esp
  800c6d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800c70:	53                   	push   %ebx
  800c71:	e8 97 ff ff ff       	call   800c0d <strlen>
  800c76:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800c79:	ff 75 0c             	pushl  0xc(%ebp)
  800c7c:	01 d8                	add    %ebx,%eax
  800c7e:	50                   	push   %eax
  800c7f:	e8 c2 ff ff ff       	call   800c46 <strcpy>
	return dst;
}
  800c84:	89 d8                	mov    %ebx,%eax
  800c86:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c89:	c9                   	leave  
  800c8a:	c3                   	ret    

00800c8b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c8b:	55                   	push   %ebp
  800c8c:	89 e5                	mov    %esp,%ebp
  800c8e:	56                   	push   %esi
  800c8f:	53                   	push   %ebx
  800c90:	8b 45 08             	mov    0x8(%ebp),%eax
  800c93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c96:	89 c6                	mov    %eax,%esi
  800c98:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c9b:	89 c2                	mov    %eax,%edx
  800c9d:	39 f2                	cmp    %esi,%edx
  800c9f:	74 11                	je     800cb2 <strncpy+0x27>
		*dst++ = *src;
  800ca1:	83 c2 01             	add    $0x1,%edx
  800ca4:	0f b6 19             	movzbl (%ecx),%ebx
  800ca7:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800caa:	80 fb 01             	cmp    $0x1,%bl
  800cad:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800cb0:	eb eb                	jmp    800c9d <strncpy+0x12>
	}
	return ret;
}
  800cb2:	5b                   	pop    %ebx
  800cb3:	5e                   	pop    %esi
  800cb4:	5d                   	pop    %ebp
  800cb5:	c3                   	ret    

00800cb6 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800cb6:	55                   	push   %ebp
  800cb7:	89 e5                	mov    %esp,%ebp
  800cb9:	56                   	push   %esi
  800cba:	53                   	push   %ebx
  800cbb:	8b 75 08             	mov    0x8(%ebp),%esi
  800cbe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc1:	8b 55 10             	mov    0x10(%ebp),%edx
  800cc4:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800cc6:	85 d2                	test   %edx,%edx
  800cc8:	74 21                	je     800ceb <strlcpy+0x35>
  800cca:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800cce:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800cd0:	39 c2                	cmp    %eax,%edx
  800cd2:	74 14                	je     800ce8 <strlcpy+0x32>
  800cd4:	0f b6 19             	movzbl (%ecx),%ebx
  800cd7:	84 db                	test   %bl,%bl
  800cd9:	74 0b                	je     800ce6 <strlcpy+0x30>
			*dst++ = *src++;
  800cdb:	83 c1 01             	add    $0x1,%ecx
  800cde:	83 c2 01             	add    $0x1,%edx
  800ce1:	88 5a ff             	mov    %bl,-0x1(%edx)
  800ce4:	eb ea                	jmp    800cd0 <strlcpy+0x1a>
  800ce6:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800ce8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ceb:	29 f0                	sub    %esi,%eax
}
  800ced:	5b                   	pop    %ebx
  800cee:	5e                   	pop    %esi
  800cef:	5d                   	pop    %ebp
  800cf0:	c3                   	ret    

00800cf1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cf1:	55                   	push   %ebp
  800cf2:	89 e5                	mov    %esp,%ebp
  800cf4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cf7:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800cfa:	0f b6 01             	movzbl (%ecx),%eax
  800cfd:	84 c0                	test   %al,%al
  800cff:	74 0c                	je     800d0d <strcmp+0x1c>
  800d01:	3a 02                	cmp    (%edx),%al
  800d03:	75 08                	jne    800d0d <strcmp+0x1c>
		p++, q++;
  800d05:	83 c1 01             	add    $0x1,%ecx
  800d08:	83 c2 01             	add    $0x1,%edx
  800d0b:	eb ed                	jmp    800cfa <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d0d:	0f b6 c0             	movzbl %al,%eax
  800d10:	0f b6 12             	movzbl (%edx),%edx
  800d13:	29 d0                	sub    %edx,%eax
}
  800d15:	5d                   	pop    %ebp
  800d16:	c3                   	ret    

00800d17 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800d17:	55                   	push   %ebp
  800d18:	89 e5                	mov    %esp,%ebp
  800d1a:	53                   	push   %ebx
  800d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d21:	89 c3                	mov    %eax,%ebx
  800d23:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800d26:	eb 06                	jmp    800d2e <strncmp+0x17>
		n--, p++, q++;
  800d28:	83 c0 01             	add    $0x1,%eax
  800d2b:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800d2e:	39 d8                	cmp    %ebx,%eax
  800d30:	74 16                	je     800d48 <strncmp+0x31>
  800d32:	0f b6 08             	movzbl (%eax),%ecx
  800d35:	84 c9                	test   %cl,%cl
  800d37:	74 04                	je     800d3d <strncmp+0x26>
  800d39:	3a 0a                	cmp    (%edx),%cl
  800d3b:	74 eb                	je     800d28 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d3d:	0f b6 00             	movzbl (%eax),%eax
  800d40:	0f b6 12             	movzbl (%edx),%edx
  800d43:	29 d0                	sub    %edx,%eax
}
  800d45:	5b                   	pop    %ebx
  800d46:	5d                   	pop    %ebp
  800d47:	c3                   	ret    
		return 0;
  800d48:	b8 00 00 00 00       	mov    $0x0,%eax
  800d4d:	eb f6                	jmp    800d45 <strncmp+0x2e>

00800d4f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d4f:	55                   	push   %ebp
  800d50:	89 e5                	mov    %esp,%ebp
  800d52:	8b 45 08             	mov    0x8(%ebp),%eax
  800d55:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d59:	0f b6 10             	movzbl (%eax),%edx
  800d5c:	84 d2                	test   %dl,%dl
  800d5e:	74 09                	je     800d69 <strchr+0x1a>
		if (*s == c)
  800d60:	38 ca                	cmp    %cl,%dl
  800d62:	74 0a                	je     800d6e <strchr+0x1f>
	for (; *s; s++)
  800d64:	83 c0 01             	add    $0x1,%eax
  800d67:	eb f0                	jmp    800d59 <strchr+0xa>
			return (char *) s;
	return 0;
  800d69:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d6e:	5d                   	pop    %ebp
  800d6f:	c3                   	ret    

00800d70 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d70:	55                   	push   %ebp
  800d71:	89 e5                	mov    %esp,%ebp
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d7a:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800d7d:	38 ca                	cmp    %cl,%dl
  800d7f:	74 09                	je     800d8a <strfind+0x1a>
  800d81:	84 d2                	test   %dl,%dl
  800d83:	74 05                	je     800d8a <strfind+0x1a>
	for (; *s; s++)
  800d85:	83 c0 01             	add    $0x1,%eax
  800d88:	eb f0                	jmp    800d7a <strfind+0xa>
			break;
	return (char *) s;
}
  800d8a:	5d                   	pop    %ebp
  800d8b:	c3                   	ret    

00800d8c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d8c:	55                   	push   %ebp
  800d8d:	89 e5                	mov    %esp,%ebp
  800d8f:	57                   	push   %edi
  800d90:	56                   	push   %esi
  800d91:	53                   	push   %ebx
  800d92:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d95:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d98:	85 c9                	test   %ecx,%ecx
  800d9a:	74 31                	je     800dcd <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d9c:	89 f8                	mov    %edi,%eax
  800d9e:	09 c8                	or     %ecx,%eax
  800da0:	a8 03                	test   $0x3,%al
  800da2:	75 23                	jne    800dc7 <memset+0x3b>
		c &= 0xFF;
  800da4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800da8:	89 d3                	mov    %edx,%ebx
  800daa:	c1 e3 08             	shl    $0x8,%ebx
  800dad:	89 d0                	mov    %edx,%eax
  800daf:	c1 e0 18             	shl    $0x18,%eax
  800db2:	89 d6                	mov    %edx,%esi
  800db4:	c1 e6 10             	shl    $0x10,%esi
  800db7:	09 f0                	or     %esi,%eax
  800db9:	09 c2                	or     %eax,%edx
  800dbb:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800dbd:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800dc0:	89 d0                	mov    %edx,%eax
  800dc2:	fc                   	cld    
  800dc3:	f3 ab                	rep stos %eax,%es:(%edi)
  800dc5:	eb 06                	jmp    800dcd <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800dc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dca:	fc                   	cld    
  800dcb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800dcd:	89 f8                	mov    %edi,%eax
  800dcf:	5b                   	pop    %ebx
  800dd0:	5e                   	pop    %esi
  800dd1:	5f                   	pop    %edi
  800dd2:	5d                   	pop    %ebp
  800dd3:	c3                   	ret    

00800dd4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800dd4:	55                   	push   %ebp
  800dd5:	89 e5                	mov    %esp,%ebp
  800dd7:	57                   	push   %edi
  800dd8:	56                   	push   %esi
  800dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddc:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ddf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800de2:	39 c6                	cmp    %eax,%esi
  800de4:	73 32                	jae    800e18 <memmove+0x44>
  800de6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800de9:	39 c2                	cmp    %eax,%edx
  800deb:	76 2b                	jbe    800e18 <memmove+0x44>
		s += n;
		d += n;
  800ded:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800df0:	89 fe                	mov    %edi,%esi
  800df2:	09 ce                	or     %ecx,%esi
  800df4:	09 d6                	or     %edx,%esi
  800df6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800dfc:	75 0e                	jne    800e0c <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800dfe:	83 ef 04             	sub    $0x4,%edi
  800e01:	8d 72 fc             	lea    -0x4(%edx),%esi
  800e04:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800e07:	fd                   	std    
  800e08:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e0a:	eb 09                	jmp    800e15 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800e0c:	83 ef 01             	sub    $0x1,%edi
  800e0f:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800e12:	fd                   	std    
  800e13:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800e15:	fc                   	cld    
  800e16:	eb 1a                	jmp    800e32 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e18:	89 c2                	mov    %eax,%edx
  800e1a:	09 ca                	or     %ecx,%edx
  800e1c:	09 f2                	or     %esi,%edx
  800e1e:	f6 c2 03             	test   $0x3,%dl
  800e21:	75 0a                	jne    800e2d <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800e23:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800e26:	89 c7                	mov    %eax,%edi
  800e28:	fc                   	cld    
  800e29:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e2b:	eb 05                	jmp    800e32 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800e2d:	89 c7                	mov    %eax,%edi
  800e2f:	fc                   	cld    
  800e30:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800e32:	5e                   	pop    %esi
  800e33:	5f                   	pop    %edi
  800e34:	5d                   	pop    %ebp
  800e35:	c3                   	ret    

00800e36 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e36:	55                   	push   %ebp
  800e37:	89 e5                	mov    %esp,%ebp
  800e39:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800e3c:	ff 75 10             	pushl  0x10(%ebp)
  800e3f:	ff 75 0c             	pushl  0xc(%ebp)
  800e42:	ff 75 08             	pushl  0x8(%ebp)
  800e45:	e8 8a ff ff ff       	call   800dd4 <memmove>
}
  800e4a:	c9                   	leave  
  800e4b:	c3                   	ret    

00800e4c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e4c:	55                   	push   %ebp
  800e4d:	89 e5                	mov    %esp,%ebp
  800e4f:	56                   	push   %esi
  800e50:	53                   	push   %ebx
  800e51:	8b 45 08             	mov    0x8(%ebp),%eax
  800e54:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e57:	89 c6                	mov    %eax,%esi
  800e59:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e5c:	39 f0                	cmp    %esi,%eax
  800e5e:	74 1c                	je     800e7c <memcmp+0x30>
		if (*s1 != *s2)
  800e60:	0f b6 08             	movzbl (%eax),%ecx
  800e63:	0f b6 1a             	movzbl (%edx),%ebx
  800e66:	38 d9                	cmp    %bl,%cl
  800e68:	75 08                	jne    800e72 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800e6a:	83 c0 01             	add    $0x1,%eax
  800e6d:	83 c2 01             	add    $0x1,%edx
  800e70:	eb ea                	jmp    800e5c <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800e72:	0f b6 c1             	movzbl %cl,%eax
  800e75:	0f b6 db             	movzbl %bl,%ebx
  800e78:	29 d8                	sub    %ebx,%eax
  800e7a:	eb 05                	jmp    800e81 <memcmp+0x35>
	}

	return 0;
  800e7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e81:	5b                   	pop    %ebx
  800e82:	5e                   	pop    %esi
  800e83:	5d                   	pop    %ebp
  800e84:	c3                   	ret    

00800e85 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e85:	55                   	push   %ebp
  800e86:	89 e5                	mov    %esp,%ebp
  800e88:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800e8e:	89 c2                	mov    %eax,%edx
  800e90:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e93:	39 d0                	cmp    %edx,%eax
  800e95:	73 09                	jae    800ea0 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e97:	38 08                	cmp    %cl,(%eax)
  800e99:	74 05                	je     800ea0 <memfind+0x1b>
	for (; s < ends; s++)
  800e9b:	83 c0 01             	add    $0x1,%eax
  800e9e:	eb f3                	jmp    800e93 <memfind+0xe>
			break;
	return (void *) s;
}
  800ea0:	5d                   	pop    %ebp
  800ea1:	c3                   	ret    

00800ea2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ea2:	55                   	push   %ebp
  800ea3:	89 e5                	mov    %esp,%ebp
  800ea5:	57                   	push   %edi
  800ea6:	56                   	push   %esi
  800ea7:	53                   	push   %ebx
  800ea8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800eab:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800eae:	eb 03                	jmp    800eb3 <strtol+0x11>
		s++;
  800eb0:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800eb3:	0f b6 01             	movzbl (%ecx),%eax
  800eb6:	3c 20                	cmp    $0x20,%al
  800eb8:	74 f6                	je     800eb0 <strtol+0xe>
  800eba:	3c 09                	cmp    $0x9,%al
  800ebc:	74 f2                	je     800eb0 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ebe:	3c 2b                	cmp    $0x2b,%al
  800ec0:	74 2a                	je     800eec <strtol+0x4a>
	int neg = 0;
  800ec2:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ec7:	3c 2d                	cmp    $0x2d,%al
  800ec9:	74 2b                	je     800ef6 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ecb:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ed1:	75 0f                	jne    800ee2 <strtol+0x40>
  800ed3:	80 39 30             	cmpb   $0x30,(%ecx)
  800ed6:	74 28                	je     800f00 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ed8:	85 db                	test   %ebx,%ebx
  800eda:	b8 0a 00 00 00       	mov    $0xa,%eax
  800edf:	0f 44 d8             	cmove  %eax,%ebx
  800ee2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ee7:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800eea:	eb 50                	jmp    800f3c <strtol+0x9a>
		s++;
  800eec:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800eef:	bf 00 00 00 00       	mov    $0x0,%edi
  800ef4:	eb d5                	jmp    800ecb <strtol+0x29>
		s++, neg = 1;
  800ef6:	83 c1 01             	add    $0x1,%ecx
  800ef9:	bf 01 00 00 00       	mov    $0x1,%edi
  800efe:	eb cb                	jmp    800ecb <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f00:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800f04:	74 0e                	je     800f14 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800f06:	85 db                	test   %ebx,%ebx
  800f08:	75 d8                	jne    800ee2 <strtol+0x40>
		s++, base = 8;
  800f0a:	83 c1 01             	add    $0x1,%ecx
  800f0d:	bb 08 00 00 00       	mov    $0x8,%ebx
  800f12:	eb ce                	jmp    800ee2 <strtol+0x40>
		s += 2, base = 16;
  800f14:	83 c1 02             	add    $0x2,%ecx
  800f17:	bb 10 00 00 00       	mov    $0x10,%ebx
  800f1c:	eb c4                	jmp    800ee2 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800f1e:	8d 72 9f             	lea    -0x61(%edx),%esi
  800f21:	89 f3                	mov    %esi,%ebx
  800f23:	80 fb 19             	cmp    $0x19,%bl
  800f26:	77 29                	ja     800f51 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800f28:	0f be d2             	movsbl %dl,%edx
  800f2b:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800f2e:	3b 55 10             	cmp    0x10(%ebp),%edx
  800f31:	7d 30                	jge    800f63 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800f33:	83 c1 01             	add    $0x1,%ecx
  800f36:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f3a:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800f3c:	0f b6 11             	movzbl (%ecx),%edx
  800f3f:	8d 72 d0             	lea    -0x30(%edx),%esi
  800f42:	89 f3                	mov    %esi,%ebx
  800f44:	80 fb 09             	cmp    $0x9,%bl
  800f47:	77 d5                	ja     800f1e <strtol+0x7c>
			dig = *s - '0';
  800f49:	0f be d2             	movsbl %dl,%edx
  800f4c:	83 ea 30             	sub    $0x30,%edx
  800f4f:	eb dd                	jmp    800f2e <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800f51:	8d 72 bf             	lea    -0x41(%edx),%esi
  800f54:	89 f3                	mov    %esi,%ebx
  800f56:	80 fb 19             	cmp    $0x19,%bl
  800f59:	77 08                	ja     800f63 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800f5b:	0f be d2             	movsbl %dl,%edx
  800f5e:	83 ea 37             	sub    $0x37,%edx
  800f61:	eb cb                	jmp    800f2e <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800f63:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f67:	74 05                	je     800f6e <strtol+0xcc>
		*endptr = (char *) s;
  800f69:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f6c:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800f6e:	89 c2                	mov    %eax,%edx
  800f70:	f7 da                	neg    %edx
  800f72:	85 ff                	test   %edi,%edi
  800f74:	0f 45 c2             	cmovne %edx,%eax
}
  800f77:	5b                   	pop    %ebx
  800f78:	5e                   	pop    %esi
  800f79:	5f                   	pop    %edi
  800f7a:	5d                   	pop    %ebp
  800f7b:	c3                   	ret    

00800f7c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800f7c:	55                   	push   %ebp
  800f7d:	89 e5                	mov    %esp,%ebp
  800f7f:	57                   	push   %edi
  800f80:	56                   	push   %esi
  800f81:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f82:	b8 00 00 00 00       	mov    $0x0,%eax
  800f87:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f8d:	89 c3                	mov    %eax,%ebx
  800f8f:	89 c7                	mov    %eax,%edi
  800f91:	89 c6                	mov    %eax,%esi
  800f93:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800f95:	5b                   	pop    %ebx
  800f96:	5e                   	pop    %esi
  800f97:	5f                   	pop    %edi
  800f98:	5d                   	pop    %ebp
  800f99:	c3                   	ret    

00800f9a <sys_cgetc>:

int
sys_cgetc(void)
{
  800f9a:	55                   	push   %ebp
  800f9b:	89 e5                	mov    %esp,%ebp
  800f9d:	57                   	push   %edi
  800f9e:	56                   	push   %esi
  800f9f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fa0:	ba 00 00 00 00       	mov    $0x0,%edx
  800fa5:	b8 01 00 00 00       	mov    $0x1,%eax
  800faa:	89 d1                	mov    %edx,%ecx
  800fac:	89 d3                	mov    %edx,%ebx
  800fae:	89 d7                	mov    %edx,%edi
  800fb0:	89 d6                	mov    %edx,%esi
  800fb2:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800fb4:	5b                   	pop    %ebx
  800fb5:	5e                   	pop    %esi
  800fb6:	5f                   	pop    %edi
  800fb7:	5d                   	pop    %ebp
  800fb8:	c3                   	ret    

00800fb9 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800fb9:	55                   	push   %ebp
  800fba:	89 e5                	mov    %esp,%ebp
  800fbc:	57                   	push   %edi
  800fbd:	56                   	push   %esi
  800fbe:	53                   	push   %ebx
  800fbf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fc2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fc7:	8b 55 08             	mov    0x8(%ebp),%edx
  800fca:	b8 03 00 00 00       	mov    $0x3,%eax
  800fcf:	89 cb                	mov    %ecx,%ebx
  800fd1:	89 cf                	mov    %ecx,%edi
  800fd3:	89 ce                	mov    %ecx,%esi
  800fd5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fd7:	85 c0                	test   %eax,%eax
  800fd9:	7f 08                	jg     800fe3 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800fdb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fde:	5b                   	pop    %ebx
  800fdf:	5e                   	pop    %esi
  800fe0:	5f                   	pop    %edi
  800fe1:	5d                   	pop    %ebp
  800fe2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fe3:	83 ec 0c             	sub    $0xc,%esp
  800fe6:	50                   	push   %eax
  800fe7:	6a 03                	push   $0x3
  800fe9:	68 70 26 80 00       	push   $0x802670
  800fee:	6a 43                	push   $0x43
  800ff0:	68 8d 26 80 00       	push   $0x80268d
  800ff5:	e8 07 f3 ff ff       	call   800301 <_panic>

00800ffa <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ffa:	55                   	push   %ebp
  800ffb:	89 e5                	mov    %esp,%ebp
  800ffd:	57                   	push   %edi
  800ffe:	56                   	push   %esi
  800fff:	53                   	push   %ebx
	asm volatile("int %1\n"
  801000:	ba 00 00 00 00       	mov    $0x0,%edx
  801005:	b8 02 00 00 00       	mov    $0x2,%eax
  80100a:	89 d1                	mov    %edx,%ecx
  80100c:	89 d3                	mov    %edx,%ebx
  80100e:	89 d7                	mov    %edx,%edi
  801010:	89 d6                	mov    %edx,%esi
  801012:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801014:	5b                   	pop    %ebx
  801015:	5e                   	pop    %esi
  801016:	5f                   	pop    %edi
  801017:	5d                   	pop    %ebp
  801018:	c3                   	ret    

00801019 <sys_yield>:

void
sys_yield(void)
{
  801019:	55                   	push   %ebp
  80101a:	89 e5                	mov    %esp,%ebp
  80101c:	57                   	push   %edi
  80101d:	56                   	push   %esi
  80101e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80101f:	ba 00 00 00 00       	mov    $0x0,%edx
  801024:	b8 0b 00 00 00       	mov    $0xb,%eax
  801029:	89 d1                	mov    %edx,%ecx
  80102b:	89 d3                	mov    %edx,%ebx
  80102d:	89 d7                	mov    %edx,%edi
  80102f:	89 d6                	mov    %edx,%esi
  801031:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801033:	5b                   	pop    %ebx
  801034:	5e                   	pop    %esi
  801035:	5f                   	pop    %edi
  801036:	5d                   	pop    %ebp
  801037:	c3                   	ret    

00801038 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801038:	55                   	push   %ebp
  801039:	89 e5                	mov    %esp,%ebp
  80103b:	57                   	push   %edi
  80103c:	56                   	push   %esi
  80103d:	53                   	push   %ebx
  80103e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801041:	be 00 00 00 00       	mov    $0x0,%esi
  801046:	8b 55 08             	mov    0x8(%ebp),%edx
  801049:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80104c:	b8 04 00 00 00       	mov    $0x4,%eax
  801051:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801054:	89 f7                	mov    %esi,%edi
  801056:	cd 30                	int    $0x30
	if(check && ret > 0)
  801058:	85 c0                	test   %eax,%eax
  80105a:	7f 08                	jg     801064 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
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
  801068:	6a 04                	push   $0x4
  80106a:	68 70 26 80 00       	push   $0x802670
  80106f:	6a 43                	push   $0x43
  801071:	68 8d 26 80 00       	push   $0x80268d
  801076:	e8 86 f2 ff ff       	call   800301 <_panic>

0080107b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80107b:	55                   	push   %ebp
  80107c:	89 e5                	mov    %esp,%ebp
  80107e:	57                   	push   %edi
  80107f:	56                   	push   %esi
  801080:	53                   	push   %ebx
  801081:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801084:	8b 55 08             	mov    0x8(%ebp),%edx
  801087:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80108a:	b8 05 00 00 00       	mov    $0x5,%eax
  80108f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801092:	8b 7d 14             	mov    0x14(%ebp),%edi
  801095:	8b 75 18             	mov    0x18(%ebp),%esi
  801098:	cd 30                	int    $0x30
	if(check && ret > 0)
  80109a:	85 c0                	test   %eax,%eax
  80109c:	7f 08                	jg     8010a6 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
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
  8010aa:	6a 05                	push   $0x5
  8010ac:	68 70 26 80 00       	push   $0x802670
  8010b1:	6a 43                	push   $0x43
  8010b3:	68 8d 26 80 00       	push   $0x80268d
  8010b8:	e8 44 f2 ff ff       	call   800301 <_panic>

008010bd <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
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
  8010d1:	b8 06 00 00 00       	mov    $0x6,%eax
  8010d6:	89 df                	mov    %ebx,%edi
  8010d8:	89 de                	mov    %ebx,%esi
  8010da:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010dc:	85 c0                	test   %eax,%eax
  8010de:	7f 08                	jg     8010e8 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
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
  8010ec:	6a 06                	push   $0x6
  8010ee:	68 70 26 80 00       	push   $0x802670
  8010f3:	6a 43                	push   $0x43
  8010f5:	68 8d 26 80 00       	push   $0x80268d
  8010fa:	e8 02 f2 ff ff       	call   800301 <_panic>

008010ff <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
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
  801113:	b8 08 00 00 00       	mov    $0x8,%eax
  801118:	89 df                	mov    %ebx,%edi
  80111a:	89 de                	mov    %ebx,%esi
  80111c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80111e:	85 c0                	test   %eax,%eax
  801120:	7f 08                	jg     80112a <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
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
  80112e:	6a 08                	push   $0x8
  801130:	68 70 26 80 00       	push   $0x802670
  801135:	6a 43                	push   $0x43
  801137:	68 8d 26 80 00       	push   $0x80268d
  80113c:	e8 c0 f1 ff ff       	call   800301 <_panic>

00801141 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801141:	55                   	push   %ebp
  801142:	89 e5                	mov    %esp,%ebp
  801144:	57                   	push   %edi
  801145:	56                   	push   %esi
  801146:	53                   	push   %ebx
  801147:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80114a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80114f:	8b 55 08             	mov    0x8(%ebp),%edx
  801152:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801155:	b8 09 00 00 00       	mov    $0x9,%eax
  80115a:	89 df                	mov    %ebx,%edi
  80115c:	89 de                	mov    %ebx,%esi
  80115e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801160:	85 c0                	test   %eax,%eax
  801162:	7f 08                	jg     80116c <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801164:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801167:	5b                   	pop    %ebx
  801168:	5e                   	pop    %esi
  801169:	5f                   	pop    %edi
  80116a:	5d                   	pop    %ebp
  80116b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80116c:	83 ec 0c             	sub    $0xc,%esp
  80116f:	50                   	push   %eax
  801170:	6a 09                	push   $0x9
  801172:	68 70 26 80 00       	push   $0x802670
  801177:	6a 43                	push   $0x43
  801179:	68 8d 26 80 00       	push   $0x80268d
  80117e:	e8 7e f1 ff ff       	call   800301 <_panic>

00801183 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801183:	55                   	push   %ebp
  801184:	89 e5                	mov    %esp,%ebp
  801186:	57                   	push   %edi
  801187:	56                   	push   %esi
  801188:	53                   	push   %ebx
  801189:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80118c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801191:	8b 55 08             	mov    0x8(%ebp),%edx
  801194:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801197:	b8 0a 00 00 00       	mov    $0xa,%eax
  80119c:	89 df                	mov    %ebx,%edi
  80119e:	89 de                	mov    %ebx,%esi
  8011a0:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011a2:	85 c0                	test   %eax,%eax
  8011a4:	7f 08                	jg     8011ae <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8011a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011a9:	5b                   	pop    %ebx
  8011aa:	5e                   	pop    %esi
  8011ab:	5f                   	pop    %edi
  8011ac:	5d                   	pop    %ebp
  8011ad:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011ae:	83 ec 0c             	sub    $0xc,%esp
  8011b1:	50                   	push   %eax
  8011b2:	6a 0a                	push   $0xa
  8011b4:	68 70 26 80 00       	push   $0x802670
  8011b9:	6a 43                	push   $0x43
  8011bb:	68 8d 26 80 00       	push   $0x80268d
  8011c0:	e8 3c f1 ff ff       	call   800301 <_panic>

008011c5 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8011c5:	55                   	push   %ebp
  8011c6:	89 e5                	mov    %esp,%ebp
  8011c8:	57                   	push   %edi
  8011c9:	56                   	push   %esi
  8011ca:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011d1:	b8 0c 00 00 00       	mov    $0xc,%eax
  8011d6:	be 00 00 00 00       	mov    $0x0,%esi
  8011db:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011de:	8b 7d 14             	mov    0x14(%ebp),%edi
  8011e1:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8011e3:	5b                   	pop    %ebx
  8011e4:	5e                   	pop    %esi
  8011e5:	5f                   	pop    %edi
  8011e6:	5d                   	pop    %ebp
  8011e7:	c3                   	ret    

008011e8 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8011e8:	55                   	push   %ebp
  8011e9:	89 e5                	mov    %esp,%ebp
  8011eb:	57                   	push   %edi
  8011ec:	56                   	push   %esi
  8011ed:	53                   	push   %ebx
  8011ee:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011f1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8011f9:	b8 0d 00 00 00       	mov    $0xd,%eax
  8011fe:	89 cb                	mov    %ecx,%ebx
  801200:	89 cf                	mov    %ecx,%edi
  801202:	89 ce                	mov    %ecx,%esi
  801204:	cd 30                	int    $0x30
	if(check && ret > 0)
  801206:	85 c0                	test   %eax,%eax
  801208:	7f 08                	jg     801212 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80120a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80120d:	5b                   	pop    %ebx
  80120e:	5e                   	pop    %esi
  80120f:	5f                   	pop    %edi
  801210:	5d                   	pop    %ebp
  801211:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801212:	83 ec 0c             	sub    $0xc,%esp
  801215:	50                   	push   %eax
  801216:	6a 0d                	push   $0xd
  801218:	68 70 26 80 00       	push   $0x802670
  80121d:	6a 43                	push   $0x43
  80121f:	68 8d 26 80 00       	push   $0x80268d
  801224:	e8 d8 f0 ff ff       	call   800301 <_panic>

00801229 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801229:	55                   	push   %ebp
  80122a:	89 e5                	mov    %esp,%ebp
  80122c:	57                   	push   %edi
  80122d:	56                   	push   %esi
  80122e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80122f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801234:	8b 55 08             	mov    0x8(%ebp),%edx
  801237:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80123a:	b8 0e 00 00 00       	mov    $0xe,%eax
  80123f:	89 df                	mov    %ebx,%edi
  801241:	89 de                	mov    %ebx,%esi
  801243:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801245:	5b                   	pop    %ebx
  801246:	5e                   	pop    %esi
  801247:	5f                   	pop    %edi
  801248:	5d                   	pop    %ebp
  801249:	c3                   	ret    

0080124a <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  80124a:	55                   	push   %ebp
  80124b:	89 e5                	mov    %esp,%ebp
  80124d:	57                   	push   %edi
  80124e:	56                   	push   %esi
  80124f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801250:	b9 00 00 00 00       	mov    $0x0,%ecx
  801255:	8b 55 08             	mov    0x8(%ebp),%edx
  801258:	b8 0f 00 00 00       	mov    $0xf,%eax
  80125d:	89 cb                	mov    %ecx,%ebx
  80125f:	89 cf                	mov    %ecx,%edi
  801261:	89 ce                	mov    %ecx,%esi
  801263:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801265:	5b                   	pop    %ebx
  801266:	5e                   	pop    %esi
  801267:	5f                   	pop    %edi
  801268:	5d                   	pop    %ebp
  801269:	c3                   	ret    

0080126a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80126a:	55                   	push   %ebp
  80126b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80126d:	8b 45 08             	mov    0x8(%ebp),%eax
  801270:	05 00 00 00 30       	add    $0x30000000,%eax
  801275:	c1 e8 0c             	shr    $0xc,%eax
}
  801278:	5d                   	pop    %ebp
  801279:	c3                   	ret    

0080127a <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80127a:	55                   	push   %ebp
  80127b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80127d:	8b 45 08             	mov    0x8(%ebp),%eax
  801280:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801285:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80128a:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80128f:	5d                   	pop    %ebp
  801290:	c3                   	ret    

00801291 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801291:	55                   	push   %ebp
  801292:	89 e5                	mov    %esp,%ebp
  801294:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801299:	89 c2                	mov    %eax,%edx
  80129b:	c1 ea 16             	shr    $0x16,%edx
  80129e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012a5:	f6 c2 01             	test   $0x1,%dl
  8012a8:	74 2d                	je     8012d7 <fd_alloc+0x46>
  8012aa:	89 c2                	mov    %eax,%edx
  8012ac:	c1 ea 0c             	shr    $0xc,%edx
  8012af:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012b6:	f6 c2 01             	test   $0x1,%dl
  8012b9:	74 1c                	je     8012d7 <fd_alloc+0x46>
  8012bb:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8012c0:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8012c5:	75 d2                	jne    801299 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8012c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8012d0:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8012d5:	eb 0a                	jmp    8012e1 <fd_alloc+0x50>
			*fd_store = fd;
  8012d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012da:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012e1:	5d                   	pop    %ebp
  8012e2:	c3                   	ret    

008012e3 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8012e3:	55                   	push   %ebp
  8012e4:	89 e5                	mov    %esp,%ebp
  8012e6:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8012e9:	83 f8 1f             	cmp    $0x1f,%eax
  8012ec:	77 30                	ja     80131e <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8012ee:	c1 e0 0c             	shl    $0xc,%eax
  8012f1:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8012f6:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8012fc:	f6 c2 01             	test   $0x1,%dl
  8012ff:	74 24                	je     801325 <fd_lookup+0x42>
  801301:	89 c2                	mov    %eax,%edx
  801303:	c1 ea 0c             	shr    $0xc,%edx
  801306:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80130d:	f6 c2 01             	test   $0x1,%dl
  801310:	74 1a                	je     80132c <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801312:	8b 55 0c             	mov    0xc(%ebp),%edx
  801315:	89 02                	mov    %eax,(%edx)
	return 0;
  801317:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80131c:	5d                   	pop    %ebp
  80131d:	c3                   	ret    
		return -E_INVAL;
  80131e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801323:	eb f7                	jmp    80131c <fd_lookup+0x39>
		return -E_INVAL;
  801325:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80132a:	eb f0                	jmp    80131c <fd_lookup+0x39>
  80132c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801331:	eb e9                	jmp    80131c <fd_lookup+0x39>

00801333 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801333:	55                   	push   %ebp
  801334:	89 e5                	mov    %esp,%ebp
  801336:	83 ec 08             	sub    $0x8,%esp
  801339:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80133c:	ba 1c 27 80 00       	mov    $0x80271c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801341:	b8 20 30 80 00       	mov    $0x803020,%eax
		if (devtab[i]->dev_id == dev_id) {
  801346:	39 08                	cmp    %ecx,(%eax)
  801348:	74 33                	je     80137d <dev_lookup+0x4a>
  80134a:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80134d:	8b 02                	mov    (%edx),%eax
  80134f:	85 c0                	test   %eax,%eax
  801351:	75 f3                	jne    801346 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801353:	a1 04 44 80 00       	mov    0x804404,%eax
  801358:	8b 40 48             	mov    0x48(%eax),%eax
  80135b:	83 ec 04             	sub    $0x4,%esp
  80135e:	51                   	push   %ecx
  80135f:	50                   	push   %eax
  801360:	68 9c 26 80 00       	push   $0x80269c
  801365:	e8 8d f0 ff ff       	call   8003f7 <cprintf>
	*dev = 0;
  80136a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801373:	83 c4 10             	add    $0x10,%esp
  801376:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80137b:	c9                   	leave  
  80137c:	c3                   	ret    
			*dev = devtab[i];
  80137d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801380:	89 01                	mov    %eax,(%ecx)
			return 0;
  801382:	b8 00 00 00 00       	mov    $0x0,%eax
  801387:	eb f2                	jmp    80137b <dev_lookup+0x48>

00801389 <fd_close>:
{
  801389:	55                   	push   %ebp
  80138a:	89 e5                	mov    %esp,%ebp
  80138c:	57                   	push   %edi
  80138d:	56                   	push   %esi
  80138e:	53                   	push   %ebx
  80138f:	83 ec 24             	sub    $0x24,%esp
  801392:	8b 75 08             	mov    0x8(%ebp),%esi
  801395:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801398:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80139b:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80139c:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8013a2:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013a5:	50                   	push   %eax
  8013a6:	e8 38 ff ff ff       	call   8012e3 <fd_lookup>
  8013ab:	89 c3                	mov    %eax,%ebx
  8013ad:	83 c4 10             	add    $0x10,%esp
  8013b0:	85 c0                	test   %eax,%eax
  8013b2:	78 05                	js     8013b9 <fd_close+0x30>
	    || fd != fd2)
  8013b4:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8013b7:	74 16                	je     8013cf <fd_close+0x46>
		return (must_exist ? r : 0);
  8013b9:	89 f8                	mov    %edi,%eax
  8013bb:	84 c0                	test   %al,%al
  8013bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8013c2:	0f 44 d8             	cmove  %eax,%ebx
}
  8013c5:	89 d8                	mov    %ebx,%eax
  8013c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013ca:	5b                   	pop    %ebx
  8013cb:	5e                   	pop    %esi
  8013cc:	5f                   	pop    %edi
  8013cd:	5d                   	pop    %ebp
  8013ce:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8013cf:	83 ec 08             	sub    $0x8,%esp
  8013d2:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8013d5:	50                   	push   %eax
  8013d6:	ff 36                	pushl  (%esi)
  8013d8:	e8 56 ff ff ff       	call   801333 <dev_lookup>
  8013dd:	89 c3                	mov    %eax,%ebx
  8013df:	83 c4 10             	add    $0x10,%esp
  8013e2:	85 c0                	test   %eax,%eax
  8013e4:	78 1a                	js     801400 <fd_close+0x77>
		if (dev->dev_close)
  8013e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013e9:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8013ec:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8013f1:	85 c0                	test   %eax,%eax
  8013f3:	74 0b                	je     801400 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8013f5:	83 ec 0c             	sub    $0xc,%esp
  8013f8:	56                   	push   %esi
  8013f9:	ff d0                	call   *%eax
  8013fb:	89 c3                	mov    %eax,%ebx
  8013fd:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801400:	83 ec 08             	sub    $0x8,%esp
  801403:	56                   	push   %esi
  801404:	6a 00                	push   $0x0
  801406:	e8 b2 fc ff ff       	call   8010bd <sys_page_unmap>
	return r;
  80140b:	83 c4 10             	add    $0x10,%esp
  80140e:	eb b5                	jmp    8013c5 <fd_close+0x3c>

00801410 <close>:

int
close(int fdnum)
{
  801410:	55                   	push   %ebp
  801411:	89 e5                	mov    %esp,%ebp
  801413:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801416:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801419:	50                   	push   %eax
  80141a:	ff 75 08             	pushl  0x8(%ebp)
  80141d:	e8 c1 fe ff ff       	call   8012e3 <fd_lookup>
  801422:	83 c4 10             	add    $0x10,%esp
  801425:	85 c0                	test   %eax,%eax
  801427:	79 02                	jns    80142b <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801429:	c9                   	leave  
  80142a:	c3                   	ret    
		return fd_close(fd, 1);
  80142b:	83 ec 08             	sub    $0x8,%esp
  80142e:	6a 01                	push   $0x1
  801430:	ff 75 f4             	pushl  -0xc(%ebp)
  801433:	e8 51 ff ff ff       	call   801389 <fd_close>
  801438:	83 c4 10             	add    $0x10,%esp
  80143b:	eb ec                	jmp    801429 <close+0x19>

0080143d <close_all>:

void
close_all(void)
{
  80143d:	55                   	push   %ebp
  80143e:	89 e5                	mov    %esp,%ebp
  801440:	53                   	push   %ebx
  801441:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801444:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801449:	83 ec 0c             	sub    $0xc,%esp
  80144c:	53                   	push   %ebx
  80144d:	e8 be ff ff ff       	call   801410 <close>
	for (i = 0; i < MAXFD; i++)
  801452:	83 c3 01             	add    $0x1,%ebx
  801455:	83 c4 10             	add    $0x10,%esp
  801458:	83 fb 20             	cmp    $0x20,%ebx
  80145b:	75 ec                	jne    801449 <close_all+0xc>
}
  80145d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801460:	c9                   	leave  
  801461:	c3                   	ret    

00801462 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801462:	55                   	push   %ebp
  801463:	89 e5                	mov    %esp,%ebp
  801465:	57                   	push   %edi
  801466:	56                   	push   %esi
  801467:	53                   	push   %ebx
  801468:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80146b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80146e:	50                   	push   %eax
  80146f:	ff 75 08             	pushl  0x8(%ebp)
  801472:	e8 6c fe ff ff       	call   8012e3 <fd_lookup>
  801477:	89 c3                	mov    %eax,%ebx
  801479:	83 c4 10             	add    $0x10,%esp
  80147c:	85 c0                	test   %eax,%eax
  80147e:	0f 88 81 00 00 00    	js     801505 <dup+0xa3>
		return r;
	close(newfdnum);
  801484:	83 ec 0c             	sub    $0xc,%esp
  801487:	ff 75 0c             	pushl  0xc(%ebp)
  80148a:	e8 81 ff ff ff       	call   801410 <close>

	newfd = INDEX2FD(newfdnum);
  80148f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801492:	c1 e6 0c             	shl    $0xc,%esi
  801495:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80149b:	83 c4 04             	add    $0x4,%esp
  80149e:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014a1:	e8 d4 fd ff ff       	call   80127a <fd2data>
  8014a6:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8014a8:	89 34 24             	mov    %esi,(%esp)
  8014ab:	e8 ca fd ff ff       	call   80127a <fd2data>
  8014b0:	83 c4 10             	add    $0x10,%esp
  8014b3:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8014b5:	89 d8                	mov    %ebx,%eax
  8014b7:	c1 e8 16             	shr    $0x16,%eax
  8014ba:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014c1:	a8 01                	test   $0x1,%al
  8014c3:	74 11                	je     8014d6 <dup+0x74>
  8014c5:	89 d8                	mov    %ebx,%eax
  8014c7:	c1 e8 0c             	shr    $0xc,%eax
  8014ca:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8014d1:	f6 c2 01             	test   $0x1,%dl
  8014d4:	75 39                	jne    80150f <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8014d6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014d9:	89 d0                	mov    %edx,%eax
  8014db:	c1 e8 0c             	shr    $0xc,%eax
  8014de:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014e5:	83 ec 0c             	sub    $0xc,%esp
  8014e8:	25 07 0e 00 00       	and    $0xe07,%eax
  8014ed:	50                   	push   %eax
  8014ee:	56                   	push   %esi
  8014ef:	6a 00                	push   $0x0
  8014f1:	52                   	push   %edx
  8014f2:	6a 00                	push   $0x0
  8014f4:	e8 82 fb ff ff       	call   80107b <sys_page_map>
  8014f9:	89 c3                	mov    %eax,%ebx
  8014fb:	83 c4 20             	add    $0x20,%esp
  8014fe:	85 c0                	test   %eax,%eax
  801500:	78 31                	js     801533 <dup+0xd1>
		goto err;

	return newfdnum;
  801502:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801505:	89 d8                	mov    %ebx,%eax
  801507:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80150a:	5b                   	pop    %ebx
  80150b:	5e                   	pop    %esi
  80150c:	5f                   	pop    %edi
  80150d:	5d                   	pop    %ebp
  80150e:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80150f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801516:	83 ec 0c             	sub    $0xc,%esp
  801519:	25 07 0e 00 00       	and    $0xe07,%eax
  80151e:	50                   	push   %eax
  80151f:	57                   	push   %edi
  801520:	6a 00                	push   $0x0
  801522:	53                   	push   %ebx
  801523:	6a 00                	push   $0x0
  801525:	e8 51 fb ff ff       	call   80107b <sys_page_map>
  80152a:	89 c3                	mov    %eax,%ebx
  80152c:	83 c4 20             	add    $0x20,%esp
  80152f:	85 c0                	test   %eax,%eax
  801531:	79 a3                	jns    8014d6 <dup+0x74>
	sys_page_unmap(0, newfd);
  801533:	83 ec 08             	sub    $0x8,%esp
  801536:	56                   	push   %esi
  801537:	6a 00                	push   $0x0
  801539:	e8 7f fb ff ff       	call   8010bd <sys_page_unmap>
	sys_page_unmap(0, nva);
  80153e:	83 c4 08             	add    $0x8,%esp
  801541:	57                   	push   %edi
  801542:	6a 00                	push   $0x0
  801544:	e8 74 fb ff ff       	call   8010bd <sys_page_unmap>
	return r;
  801549:	83 c4 10             	add    $0x10,%esp
  80154c:	eb b7                	jmp    801505 <dup+0xa3>

0080154e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80154e:	55                   	push   %ebp
  80154f:	89 e5                	mov    %esp,%ebp
  801551:	53                   	push   %ebx
  801552:	83 ec 1c             	sub    $0x1c,%esp
  801555:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801558:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80155b:	50                   	push   %eax
  80155c:	53                   	push   %ebx
  80155d:	e8 81 fd ff ff       	call   8012e3 <fd_lookup>
  801562:	83 c4 10             	add    $0x10,%esp
  801565:	85 c0                	test   %eax,%eax
  801567:	78 3f                	js     8015a8 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801569:	83 ec 08             	sub    $0x8,%esp
  80156c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80156f:	50                   	push   %eax
  801570:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801573:	ff 30                	pushl  (%eax)
  801575:	e8 b9 fd ff ff       	call   801333 <dev_lookup>
  80157a:	83 c4 10             	add    $0x10,%esp
  80157d:	85 c0                	test   %eax,%eax
  80157f:	78 27                	js     8015a8 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801581:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801584:	8b 42 08             	mov    0x8(%edx),%eax
  801587:	83 e0 03             	and    $0x3,%eax
  80158a:	83 f8 01             	cmp    $0x1,%eax
  80158d:	74 1e                	je     8015ad <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80158f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801592:	8b 40 08             	mov    0x8(%eax),%eax
  801595:	85 c0                	test   %eax,%eax
  801597:	74 35                	je     8015ce <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801599:	83 ec 04             	sub    $0x4,%esp
  80159c:	ff 75 10             	pushl  0x10(%ebp)
  80159f:	ff 75 0c             	pushl  0xc(%ebp)
  8015a2:	52                   	push   %edx
  8015a3:	ff d0                	call   *%eax
  8015a5:	83 c4 10             	add    $0x10,%esp
}
  8015a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015ab:	c9                   	leave  
  8015ac:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8015ad:	a1 04 44 80 00       	mov    0x804404,%eax
  8015b2:	8b 40 48             	mov    0x48(%eax),%eax
  8015b5:	83 ec 04             	sub    $0x4,%esp
  8015b8:	53                   	push   %ebx
  8015b9:	50                   	push   %eax
  8015ba:	68 e0 26 80 00       	push   $0x8026e0
  8015bf:	e8 33 ee ff ff       	call   8003f7 <cprintf>
		return -E_INVAL;
  8015c4:	83 c4 10             	add    $0x10,%esp
  8015c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015cc:	eb da                	jmp    8015a8 <read+0x5a>
		return -E_NOT_SUPP;
  8015ce:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015d3:	eb d3                	jmp    8015a8 <read+0x5a>

008015d5 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8015d5:	55                   	push   %ebp
  8015d6:	89 e5                	mov    %esp,%ebp
  8015d8:	57                   	push   %edi
  8015d9:	56                   	push   %esi
  8015da:	53                   	push   %ebx
  8015db:	83 ec 0c             	sub    $0xc,%esp
  8015de:	8b 7d 08             	mov    0x8(%ebp),%edi
  8015e1:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8015e4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015e9:	39 f3                	cmp    %esi,%ebx
  8015eb:	73 23                	jae    801610 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015ed:	83 ec 04             	sub    $0x4,%esp
  8015f0:	89 f0                	mov    %esi,%eax
  8015f2:	29 d8                	sub    %ebx,%eax
  8015f4:	50                   	push   %eax
  8015f5:	89 d8                	mov    %ebx,%eax
  8015f7:	03 45 0c             	add    0xc(%ebp),%eax
  8015fa:	50                   	push   %eax
  8015fb:	57                   	push   %edi
  8015fc:	e8 4d ff ff ff       	call   80154e <read>
		if (m < 0)
  801601:	83 c4 10             	add    $0x10,%esp
  801604:	85 c0                	test   %eax,%eax
  801606:	78 06                	js     80160e <readn+0x39>
			return m;
		if (m == 0)
  801608:	74 06                	je     801610 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80160a:	01 c3                	add    %eax,%ebx
  80160c:	eb db                	jmp    8015e9 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80160e:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801610:	89 d8                	mov    %ebx,%eax
  801612:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801615:	5b                   	pop    %ebx
  801616:	5e                   	pop    %esi
  801617:	5f                   	pop    %edi
  801618:	5d                   	pop    %ebp
  801619:	c3                   	ret    

0080161a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80161a:	55                   	push   %ebp
  80161b:	89 e5                	mov    %esp,%ebp
  80161d:	53                   	push   %ebx
  80161e:	83 ec 1c             	sub    $0x1c,%esp
  801621:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801624:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801627:	50                   	push   %eax
  801628:	53                   	push   %ebx
  801629:	e8 b5 fc ff ff       	call   8012e3 <fd_lookup>
  80162e:	83 c4 10             	add    $0x10,%esp
  801631:	85 c0                	test   %eax,%eax
  801633:	78 3a                	js     80166f <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801635:	83 ec 08             	sub    $0x8,%esp
  801638:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80163b:	50                   	push   %eax
  80163c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80163f:	ff 30                	pushl  (%eax)
  801641:	e8 ed fc ff ff       	call   801333 <dev_lookup>
  801646:	83 c4 10             	add    $0x10,%esp
  801649:	85 c0                	test   %eax,%eax
  80164b:	78 22                	js     80166f <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80164d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801650:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801654:	74 1e                	je     801674 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801656:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801659:	8b 52 0c             	mov    0xc(%edx),%edx
  80165c:	85 d2                	test   %edx,%edx
  80165e:	74 35                	je     801695 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801660:	83 ec 04             	sub    $0x4,%esp
  801663:	ff 75 10             	pushl  0x10(%ebp)
  801666:	ff 75 0c             	pushl  0xc(%ebp)
  801669:	50                   	push   %eax
  80166a:	ff d2                	call   *%edx
  80166c:	83 c4 10             	add    $0x10,%esp
}
  80166f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801672:	c9                   	leave  
  801673:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801674:	a1 04 44 80 00       	mov    0x804404,%eax
  801679:	8b 40 48             	mov    0x48(%eax),%eax
  80167c:	83 ec 04             	sub    $0x4,%esp
  80167f:	53                   	push   %ebx
  801680:	50                   	push   %eax
  801681:	68 fc 26 80 00       	push   $0x8026fc
  801686:	e8 6c ed ff ff       	call   8003f7 <cprintf>
		return -E_INVAL;
  80168b:	83 c4 10             	add    $0x10,%esp
  80168e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801693:	eb da                	jmp    80166f <write+0x55>
		return -E_NOT_SUPP;
  801695:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80169a:	eb d3                	jmp    80166f <write+0x55>

0080169c <seek>:

int
seek(int fdnum, off_t offset)
{
  80169c:	55                   	push   %ebp
  80169d:	89 e5                	mov    %esp,%ebp
  80169f:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016a5:	50                   	push   %eax
  8016a6:	ff 75 08             	pushl  0x8(%ebp)
  8016a9:	e8 35 fc ff ff       	call   8012e3 <fd_lookup>
  8016ae:	83 c4 10             	add    $0x10,%esp
  8016b1:	85 c0                	test   %eax,%eax
  8016b3:	78 0e                	js     8016c3 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8016b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016bb:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8016be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016c3:	c9                   	leave  
  8016c4:	c3                   	ret    

008016c5 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8016c5:	55                   	push   %ebp
  8016c6:	89 e5                	mov    %esp,%ebp
  8016c8:	53                   	push   %ebx
  8016c9:	83 ec 1c             	sub    $0x1c,%esp
  8016cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016cf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016d2:	50                   	push   %eax
  8016d3:	53                   	push   %ebx
  8016d4:	e8 0a fc ff ff       	call   8012e3 <fd_lookup>
  8016d9:	83 c4 10             	add    $0x10,%esp
  8016dc:	85 c0                	test   %eax,%eax
  8016de:	78 37                	js     801717 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016e0:	83 ec 08             	sub    $0x8,%esp
  8016e3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016e6:	50                   	push   %eax
  8016e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ea:	ff 30                	pushl  (%eax)
  8016ec:	e8 42 fc ff ff       	call   801333 <dev_lookup>
  8016f1:	83 c4 10             	add    $0x10,%esp
  8016f4:	85 c0                	test   %eax,%eax
  8016f6:	78 1f                	js     801717 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016fb:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016ff:	74 1b                	je     80171c <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801701:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801704:	8b 52 18             	mov    0x18(%edx),%edx
  801707:	85 d2                	test   %edx,%edx
  801709:	74 32                	je     80173d <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80170b:	83 ec 08             	sub    $0x8,%esp
  80170e:	ff 75 0c             	pushl  0xc(%ebp)
  801711:	50                   	push   %eax
  801712:	ff d2                	call   *%edx
  801714:	83 c4 10             	add    $0x10,%esp
}
  801717:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80171a:	c9                   	leave  
  80171b:	c3                   	ret    
			thisenv->env_id, fdnum);
  80171c:	a1 04 44 80 00       	mov    0x804404,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801721:	8b 40 48             	mov    0x48(%eax),%eax
  801724:	83 ec 04             	sub    $0x4,%esp
  801727:	53                   	push   %ebx
  801728:	50                   	push   %eax
  801729:	68 bc 26 80 00       	push   $0x8026bc
  80172e:	e8 c4 ec ff ff       	call   8003f7 <cprintf>
		return -E_INVAL;
  801733:	83 c4 10             	add    $0x10,%esp
  801736:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80173b:	eb da                	jmp    801717 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80173d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801742:	eb d3                	jmp    801717 <ftruncate+0x52>

00801744 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801744:	55                   	push   %ebp
  801745:	89 e5                	mov    %esp,%ebp
  801747:	53                   	push   %ebx
  801748:	83 ec 1c             	sub    $0x1c,%esp
  80174b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80174e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801751:	50                   	push   %eax
  801752:	ff 75 08             	pushl  0x8(%ebp)
  801755:	e8 89 fb ff ff       	call   8012e3 <fd_lookup>
  80175a:	83 c4 10             	add    $0x10,%esp
  80175d:	85 c0                	test   %eax,%eax
  80175f:	78 4b                	js     8017ac <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801761:	83 ec 08             	sub    $0x8,%esp
  801764:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801767:	50                   	push   %eax
  801768:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80176b:	ff 30                	pushl  (%eax)
  80176d:	e8 c1 fb ff ff       	call   801333 <dev_lookup>
  801772:	83 c4 10             	add    $0x10,%esp
  801775:	85 c0                	test   %eax,%eax
  801777:	78 33                	js     8017ac <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801779:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80177c:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801780:	74 2f                	je     8017b1 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801782:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801785:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80178c:	00 00 00 
	stat->st_isdir = 0;
  80178f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801796:	00 00 00 
	stat->st_dev = dev;
  801799:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80179f:	83 ec 08             	sub    $0x8,%esp
  8017a2:	53                   	push   %ebx
  8017a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8017a6:	ff 50 14             	call   *0x14(%eax)
  8017a9:	83 c4 10             	add    $0x10,%esp
}
  8017ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017af:	c9                   	leave  
  8017b0:	c3                   	ret    
		return -E_NOT_SUPP;
  8017b1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017b6:	eb f4                	jmp    8017ac <fstat+0x68>

008017b8 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8017b8:	55                   	push   %ebp
  8017b9:	89 e5                	mov    %esp,%ebp
  8017bb:	56                   	push   %esi
  8017bc:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8017bd:	83 ec 08             	sub    $0x8,%esp
  8017c0:	6a 00                	push   $0x0
  8017c2:	ff 75 08             	pushl  0x8(%ebp)
  8017c5:	e8 bb 01 00 00       	call   801985 <open>
  8017ca:	89 c3                	mov    %eax,%ebx
  8017cc:	83 c4 10             	add    $0x10,%esp
  8017cf:	85 c0                	test   %eax,%eax
  8017d1:	78 1b                	js     8017ee <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8017d3:	83 ec 08             	sub    $0x8,%esp
  8017d6:	ff 75 0c             	pushl  0xc(%ebp)
  8017d9:	50                   	push   %eax
  8017da:	e8 65 ff ff ff       	call   801744 <fstat>
  8017df:	89 c6                	mov    %eax,%esi
	close(fd);
  8017e1:	89 1c 24             	mov    %ebx,(%esp)
  8017e4:	e8 27 fc ff ff       	call   801410 <close>
	return r;
  8017e9:	83 c4 10             	add    $0x10,%esp
  8017ec:	89 f3                	mov    %esi,%ebx
}
  8017ee:	89 d8                	mov    %ebx,%eax
  8017f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017f3:	5b                   	pop    %ebx
  8017f4:	5e                   	pop    %esi
  8017f5:	5d                   	pop    %ebp
  8017f6:	c3                   	ret    

008017f7 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8017f7:	55                   	push   %ebp
  8017f8:	89 e5                	mov    %esp,%ebp
  8017fa:	56                   	push   %esi
  8017fb:	53                   	push   %ebx
  8017fc:	89 c6                	mov    %eax,%esi
  8017fe:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801800:	83 3d 00 44 80 00 00 	cmpl   $0x0,0x804400
  801807:	74 27                	je     801830 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801809:	6a 07                	push   $0x7
  80180b:	68 00 50 80 00       	push   $0x805000
  801810:	56                   	push   %esi
  801811:	ff 35 00 44 80 00    	pushl  0x804400
  801817:	e8 d9 06 00 00       	call   801ef5 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80181c:	83 c4 0c             	add    $0xc,%esp
  80181f:	6a 00                	push   $0x0
  801821:	53                   	push   %ebx
  801822:	6a 00                	push   $0x0
  801824:	e8 63 06 00 00       	call   801e8c <ipc_recv>
}
  801829:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80182c:	5b                   	pop    %ebx
  80182d:	5e                   	pop    %esi
  80182e:	5d                   	pop    %ebp
  80182f:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801830:	83 ec 0c             	sub    $0xc,%esp
  801833:	6a 01                	push   $0x1
  801835:	e8 13 07 00 00       	call   801f4d <ipc_find_env>
  80183a:	a3 00 44 80 00       	mov    %eax,0x804400
  80183f:	83 c4 10             	add    $0x10,%esp
  801842:	eb c5                	jmp    801809 <fsipc+0x12>

00801844 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801844:	55                   	push   %ebp
  801845:	89 e5                	mov    %esp,%ebp
  801847:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80184a:	8b 45 08             	mov    0x8(%ebp),%eax
  80184d:	8b 40 0c             	mov    0xc(%eax),%eax
  801850:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801855:	8b 45 0c             	mov    0xc(%ebp),%eax
  801858:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80185d:	ba 00 00 00 00       	mov    $0x0,%edx
  801862:	b8 02 00 00 00       	mov    $0x2,%eax
  801867:	e8 8b ff ff ff       	call   8017f7 <fsipc>
}
  80186c:	c9                   	leave  
  80186d:	c3                   	ret    

0080186e <devfile_flush>:
{
  80186e:	55                   	push   %ebp
  80186f:	89 e5                	mov    %esp,%ebp
  801871:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801874:	8b 45 08             	mov    0x8(%ebp),%eax
  801877:	8b 40 0c             	mov    0xc(%eax),%eax
  80187a:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80187f:	ba 00 00 00 00       	mov    $0x0,%edx
  801884:	b8 06 00 00 00       	mov    $0x6,%eax
  801889:	e8 69 ff ff ff       	call   8017f7 <fsipc>
}
  80188e:	c9                   	leave  
  80188f:	c3                   	ret    

00801890 <devfile_stat>:
{
  801890:	55                   	push   %ebp
  801891:	89 e5                	mov    %esp,%ebp
  801893:	53                   	push   %ebx
  801894:	83 ec 04             	sub    $0x4,%esp
  801897:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80189a:	8b 45 08             	mov    0x8(%ebp),%eax
  80189d:	8b 40 0c             	mov    0xc(%eax),%eax
  8018a0:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8018a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8018aa:	b8 05 00 00 00       	mov    $0x5,%eax
  8018af:	e8 43 ff ff ff       	call   8017f7 <fsipc>
  8018b4:	85 c0                	test   %eax,%eax
  8018b6:	78 2c                	js     8018e4 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8018b8:	83 ec 08             	sub    $0x8,%esp
  8018bb:	68 00 50 80 00       	push   $0x805000
  8018c0:	53                   	push   %ebx
  8018c1:	e8 80 f3 ff ff       	call   800c46 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8018c6:	a1 80 50 80 00       	mov    0x805080,%eax
  8018cb:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8018d1:	a1 84 50 80 00       	mov    0x805084,%eax
  8018d6:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8018dc:	83 c4 10             	add    $0x10,%esp
  8018df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018e7:	c9                   	leave  
  8018e8:	c3                   	ret    

008018e9 <devfile_write>:
{
  8018e9:	55                   	push   %ebp
  8018ea:	89 e5                	mov    %esp,%ebp
  8018ec:	83 ec 0c             	sub    $0xc,%esp
	panic("devfile_write not implemented");
  8018ef:	68 2c 27 80 00       	push   $0x80272c
  8018f4:	68 90 00 00 00       	push   $0x90
  8018f9:	68 4a 27 80 00       	push   $0x80274a
  8018fe:	e8 fe e9 ff ff       	call   800301 <_panic>

00801903 <devfile_read>:
{
  801903:	55                   	push   %ebp
  801904:	89 e5                	mov    %esp,%ebp
  801906:	56                   	push   %esi
  801907:	53                   	push   %ebx
  801908:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80190b:	8b 45 08             	mov    0x8(%ebp),%eax
  80190e:	8b 40 0c             	mov    0xc(%eax),%eax
  801911:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801916:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80191c:	ba 00 00 00 00       	mov    $0x0,%edx
  801921:	b8 03 00 00 00       	mov    $0x3,%eax
  801926:	e8 cc fe ff ff       	call   8017f7 <fsipc>
  80192b:	89 c3                	mov    %eax,%ebx
  80192d:	85 c0                	test   %eax,%eax
  80192f:	78 1f                	js     801950 <devfile_read+0x4d>
	assert(r <= n);
  801931:	39 f0                	cmp    %esi,%eax
  801933:	77 24                	ja     801959 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801935:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80193a:	7f 33                	jg     80196f <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80193c:	83 ec 04             	sub    $0x4,%esp
  80193f:	50                   	push   %eax
  801940:	68 00 50 80 00       	push   $0x805000
  801945:	ff 75 0c             	pushl  0xc(%ebp)
  801948:	e8 87 f4 ff ff       	call   800dd4 <memmove>
	return r;
  80194d:	83 c4 10             	add    $0x10,%esp
}
  801950:	89 d8                	mov    %ebx,%eax
  801952:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801955:	5b                   	pop    %ebx
  801956:	5e                   	pop    %esi
  801957:	5d                   	pop    %ebp
  801958:	c3                   	ret    
	assert(r <= n);
  801959:	68 55 27 80 00       	push   $0x802755
  80195e:	68 5c 27 80 00       	push   $0x80275c
  801963:	6a 7c                	push   $0x7c
  801965:	68 4a 27 80 00       	push   $0x80274a
  80196a:	e8 92 e9 ff ff       	call   800301 <_panic>
	assert(r <= PGSIZE);
  80196f:	68 71 27 80 00       	push   $0x802771
  801974:	68 5c 27 80 00       	push   $0x80275c
  801979:	6a 7d                	push   $0x7d
  80197b:	68 4a 27 80 00       	push   $0x80274a
  801980:	e8 7c e9 ff ff       	call   800301 <_panic>

00801985 <open>:
{
  801985:	55                   	push   %ebp
  801986:	89 e5                	mov    %esp,%ebp
  801988:	56                   	push   %esi
  801989:	53                   	push   %ebx
  80198a:	83 ec 1c             	sub    $0x1c,%esp
  80198d:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801990:	56                   	push   %esi
  801991:	e8 77 f2 ff ff       	call   800c0d <strlen>
  801996:	83 c4 10             	add    $0x10,%esp
  801999:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80199e:	7f 6c                	jg     801a0c <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8019a0:	83 ec 0c             	sub    $0xc,%esp
  8019a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019a6:	50                   	push   %eax
  8019a7:	e8 e5 f8 ff ff       	call   801291 <fd_alloc>
  8019ac:	89 c3                	mov    %eax,%ebx
  8019ae:	83 c4 10             	add    $0x10,%esp
  8019b1:	85 c0                	test   %eax,%eax
  8019b3:	78 3c                	js     8019f1 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8019b5:	83 ec 08             	sub    $0x8,%esp
  8019b8:	56                   	push   %esi
  8019b9:	68 00 50 80 00       	push   $0x805000
  8019be:	e8 83 f2 ff ff       	call   800c46 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8019c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c6:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8019cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8019d3:	e8 1f fe ff ff       	call   8017f7 <fsipc>
  8019d8:	89 c3                	mov    %eax,%ebx
  8019da:	83 c4 10             	add    $0x10,%esp
  8019dd:	85 c0                	test   %eax,%eax
  8019df:	78 19                	js     8019fa <open+0x75>
	return fd2num(fd);
  8019e1:	83 ec 0c             	sub    $0xc,%esp
  8019e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8019e7:	e8 7e f8 ff ff       	call   80126a <fd2num>
  8019ec:	89 c3                	mov    %eax,%ebx
  8019ee:	83 c4 10             	add    $0x10,%esp
}
  8019f1:	89 d8                	mov    %ebx,%eax
  8019f3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019f6:	5b                   	pop    %ebx
  8019f7:	5e                   	pop    %esi
  8019f8:	5d                   	pop    %ebp
  8019f9:	c3                   	ret    
		fd_close(fd, 0);
  8019fa:	83 ec 08             	sub    $0x8,%esp
  8019fd:	6a 00                	push   $0x0
  8019ff:	ff 75 f4             	pushl  -0xc(%ebp)
  801a02:	e8 82 f9 ff ff       	call   801389 <fd_close>
		return r;
  801a07:	83 c4 10             	add    $0x10,%esp
  801a0a:	eb e5                	jmp    8019f1 <open+0x6c>
		return -E_BAD_PATH;
  801a0c:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801a11:	eb de                	jmp    8019f1 <open+0x6c>

00801a13 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801a13:	55                   	push   %ebp
  801a14:	89 e5                	mov    %esp,%ebp
  801a16:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801a19:	ba 00 00 00 00       	mov    $0x0,%edx
  801a1e:	b8 08 00 00 00       	mov    $0x8,%eax
  801a23:	e8 cf fd ff ff       	call   8017f7 <fsipc>
}
  801a28:	c9                   	leave  
  801a29:	c3                   	ret    

00801a2a <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  801a2a:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801a2e:	7f 01                	jg     801a31 <writebuf+0x7>
  801a30:	c3                   	ret    
{
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
  801a34:	53                   	push   %ebx
  801a35:	83 ec 08             	sub    $0x8,%esp
  801a38:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  801a3a:	ff 70 04             	pushl  0x4(%eax)
  801a3d:	8d 40 10             	lea    0x10(%eax),%eax
  801a40:	50                   	push   %eax
  801a41:	ff 33                	pushl  (%ebx)
  801a43:	e8 d2 fb ff ff       	call   80161a <write>
		if (result > 0)
  801a48:	83 c4 10             	add    $0x10,%esp
  801a4b:	85 c0                	test   %eax,%eax
  801a4d:	7e 03                	jle    801a52 <writebuf+0x28>
			b->result += result;
  801a4f:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801a52:	39 43 04             	cmp    %eax,0x4(%ebx)
  801a55:	74 0d                	je     801a64 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  801a57:	85 c0                	test   %eax,%eax
  801a59:	ba 00 00 00 00       	mov    $0x0,%edx
  801a5e:	0f 4f c2             	cmovg  %edx,%eax
  801a61:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801a64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a67:	c9                   	leave  
  801a68:	c3                   	ret    

00801a69 <putch>:

static void
putch(int ch, void *thunk)
{
  801a69:	55                   	push   %ebp
  801a6a:	89 e5                	mov    %esp,%ebp
  801a6c:	53                   	push   %ebx
  801a6d:	83 ec 04             	sub    $0x4,%esp
  801a70:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801a73:	8b 53 04             	mov    0x4(%ebx),%edx
  801a76:	8d 42 01             	lea    0x1(%edx),%eax
  801a79:	89 43 04             	mov    %eax,0x4(%ebx)
  801a7c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a7f:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801a83:	3d 00 01 00 00       	cmp    $0x100,%eax
  801a88:	74 06                	je     801a90 <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  801a8a:	83 c4 04             	add    $0x4,%esp
  801a8d:	5b                   	pop    %ebx
  801a8e:	5d                   	pop    %ebp
  801a8f:	c3                   	ret    
		writebuf(b);
  801a90:	89 d8                	mov    %ebx,%eax
  801a92:	e8 93 ff ff ff       	call   801a2a <writebuf>
		b->idx = 0;
  801a97:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  801a9e:	eb ea                	jmp    801a8a <putch+0x21>

00801aa0 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801aa0:	55                   	push   %ebp
  801aa1:	89 e5                	mov    %esp,%ebp
  801aa3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  801aac:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801ab2:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801ab9:	00 00 00 
	b.result = 0;
  801abc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801ac3:	00 00 00 
	b.error = 1;
  801ac6:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801acd:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801ad0:	ff 75 10             	pushl  0x10(%ebp)
  801ad3:	ff 75 0c             	pushl  0xc(%ebp)
  801ad6:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801adc:	50                   	push   %eax
  801add:	68 69 1a 80 00       	push   $0x801a69
  801ae2:	e8 3d ea ff ff       	call   800524 <vprintfmt>
	if (b.idx > 0)
  801ae7:	83 c4 10             	add    $0x10,%esp
  801aea:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801af1:	7f 11                	jg     801b04 <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  801af3:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801af9:	85 c0                	test   %eax,%eax
  801afb:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801b02:	c9                   	leave  
  801b03:	c3                   	ret    
		writebuf(&b);
  801b04:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801b0a:	e8 1b ff ff ff       	call   801a2a <writebuf>
  801b0f:	eb e2                	jmp    801af3 <vfprintf+0x53>

00801b11 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801b11:	55                   	push   %ebp
  801b12:	89 e5                	mov    %esp,%ebp
  801b14:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801b17:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801b1a:	50                   	push   %eax
  801b1b:	ff 75 0c             	pushl  0xc(%ebp)
  801b1e:	ff 75 08             	pushl  0x8(%ebp)
  801b21:	e8 7a ff ff ff       	call   801aa0 <vfprintf>
	va_end(ap);

	return cnt;
}
  801b26:	c9                   	leave  
  801b27:	c3                   	ret    

00801b28 <printf>:

int
printf(const char *fmt, ...)
{
  801b28:	55                   	push   %ebp
  801b29:	89 e5                	mov    %esp,%ebp
  801b2b:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801b2e:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801b31:	50                   	push   %eax
  801b32:	ff 75 08             	pushl  0x8(%ebp)
  801b35:	6a 01                	push   $0x1
  801b37:	e8 64 ff ff ff       	call   801aa0 <vfprintf>
	va_end(ap);

	return cnt;
}
  801b3c:	c9                   	leave  
  801b3d:	c3                   	ret    

00801b3e <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801b3e:	55                   	push   %ebp
  801b3f:	89 e5                	mov    %esp,%ebp
  801b41:	56                   	push   %esi
  801b42:	53                   	push   %ebx
  801b43:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801b46:	83 ec 0c             	sub    $0xc,%esp
  801b49:	ff 75 08             	pushl  0x8(%ebp)
  801b4c:	e8 29 f7 ff ff       	call   80127a <fd2data>
  801b51:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801b53:	83 c4 08             	add    $0x8,%esp
  801b56:	68 7d 27 80 00       	push   $0x80277d
  801b5b:	53                   	push   %ebx
  801b5c:	e8 e5 f0 ff ff       	call   800c46 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801b61:	8b 46 04             	mov    0x4(%esi),%eax
  801b64:	2b 06                	sub    (%esi),%eax
  801b66:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801b6c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b73:	00 00 00 
	stat->st_dev = &devpipe;
  801b76:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801b7d:	30 80 00 
	return 0;
}
  801b80:	b8 00 00 00 00       	mov    $0x0,%eax
  801b85:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b88:	5b                   	pop    %ebx
  801b89:	5e                   	pop    %esi
  801b8a:	5d                   	pop    %ebp
  801b8b:	c3                   	ret    

00801b8c <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b8c:	55                   	push   %ebp
  801b8d:	89 e5                	mov    %esp,%ebp
  801b8f:	53                   	push   %ebx
  801b90:	83 ec 0c             	sub    $0xc,%esp
  801b93:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801b96:	53                   	push   %ebx
  801b97:	6a 00                	push   $0x0
  801b99:	e8 1f f5 ff ff       	call   8010bd <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801b9e:	89 1c 24             	mov    %ebx,(%esp)
  801ba1:	e8 d4 f6 ff ff       	call   80127a <fd2data>
  801ba6:	83 c4 08             	add    $0x8,%esp
  801ba9:	50                   	push   %eax
  801baa:	6a 00                	push   $0x0
  801bac:	e8 0c f5 ff ff       	call   8010bd <sys_page_unmap>
}
  801bb1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bb4:	c9                   	leave  
  801bb5:	c3                   	ret    

00801bb6 <_pipeisclosed>:
{
  801bb6:	55                   	push   %ebp
  801bb7:	89 e5                	mov    %esp,%ebp
  801bb9:	57                   	push   %edi
  801bba:	56                   	push   %esi
  801bbb:	53                   	push   %ebx
  801bbc:	83 ec 1c             	sub    $0x1c,%esp
  801bbf:	89 c7                	mov    %eax,%edi
  801bc1:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801bc3:	a1 04 44 80 00       	mov    0x804404,%eax
  801bc8:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801bcb:	83 ec 0c             	sub    $0xc,%esp
  801bce:	57                   	push   %edi
  801bcf:	e8 b4 03 00 00       	call   801f88 <pageref>
  801bd4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801bd7:	89 34 24             	mov    %esi,(%esp)
  801bda:	e8 a9 03 00 00       	call   801f88 <pageref>
		nn = thisenv->env_runs;
  801bdf:	8b 15 04 44 80 00    	mov    0x804404,%edx
  801be5:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801be8:	83 c4 10             	add    $0x10,%esp
  801beb:	39 cb                	cmp    %ecx,%ebx
  801bed:	74 1b                	je     801c0a <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801bef:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801bf2:	75 cf                	jne    801bc3 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801bf4:	8b 42 58             	mov    0x58(%edx),%eax
  801bf7:	6a 01                	push   $0x1
  801bf9:	50                   	push   %eax
  801bfa:	53                   	push   %ebx
  801bfb:	68 84 27 80 00       	push   $0x802784
  801c00:	e8 f2 e7 ff ff       	call   8003f7 <cprintf>
  801c05:	83 c4 10             	add    $0x10,%esp
  801c08:	eb b9                	jmp    801bc3 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801c0a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c0d:	0f 94 c0             	sete   %al
  801c10:	0f b6 c0             	movzbl %al,%eax
}
  801c13:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c16:	5b                   	pop    %ebx
  801c17:	5e                   	pop    %esi
  801c18:	5f                   	pop    %edi
  801c19:	5d                   	pop    %ebp
  801c1a:	c3                   	ret    

00801c1b <devpipe_write>:
{
  801c1b:	55                   	push   %ebp
  801c1c:	89 e5                	mov    %esp,%ebp
  801c1e:	57                   	push   %edi
  801c1f:	56                   	push   %esi
  801c20:	53                   	push   %ebx
  801c21:	83 ec 28             	sub    $0x28,%esp
  801c24:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801c27:	56                   	push   %esi
  801c28:	e8 4d f6 ff ff       	call   80127a <fd2data>
  801c2d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c2f:	83 c4 10             	add    $0x10,%esp
  801c32:	bf 00 00 00 00       	mov    $0x0,%edi
  801c37:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801c3a:	74 4f                	je     801c8b <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801c3c:	8b 43 04             	mov    0x4(%ebx),%eax
  801c3f:	8b 0b                	mov    (%ebx),%ecx
  801c41:	8d 51 20             	lea    0x20(%ecx),%edx
  801c44:	39 d0                	cmp    %edx,%eax
  801c46:	72 14                	jb     801c5c <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801c48:	89 da                	mov    %ebx,%edx
  801c4a:	89 f0                	mov    %esi,%eax
  801c4c:	e8 65 ff ff ff       	call   801bb6 <_pipeisclosed>
  801c51:	85 c0                	test   %eax,%eax
  801c53:	75 3b                	jne    801c90 <devpipe_write+0x75>
			sys_yield();
  801c55:	e8 bf f3 ff ff       	call   801019 <sys_yield>
  801c5a:	eb e0                	jmp    801c3c <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801c5c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c5f:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801c63:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801c66:	89 c2                	mov    %eax,%edx
  801c68:	c1 fa 1f             	sar    $0x1f,%edx
  801c6b:	89 d1                	mov    %edx,%ecx
  801c6d:	c1 e9 1b             	shr    $0x1b,%ecx
  801c70:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801c73:	83 e2 1f             	and    $0x1f,%edx
  801c76:	29 ca                	sub    %ecx,%edx
  801c78:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801c7c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801c80:	83 c0 01             	add    $0x1,%eax
  801c83:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801c86:	83 c7 01             	add    $0x1,%edi
  801c89:	eb ac                	jmp    801c37 <devpipe_write+0x1c>
	return i;
  801c8b:	8b 45 10             	mov    0x10(%ebp),%eax
  801c8e:	eb 05                	jmp    801c95 <devpipe_write+0x7a>
				return 0;
  801c90:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c95:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c98:	5b                   	pop    %ebx
  801c99:	5e                   	pop    %esi
  801c9a:	5f                   	pop    %edi
  801c9b:	5d                   	pop    %ebp
  801c9c:	c3                   	ret    

00801c9d <devpipe_read>:
{
  801c9d:	55                   	push   %ebp
  801c9e:	89 e5                	mov    %esp,%ebp
  801ca0:	57                   	push   %edi
  801ca1:	56                   	push   %esi
  801ca2:	53                   	push   %ebx
  801ca3:	83 ec 18             	sub    $0x18,%esp
  801ca6:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801ca9:	57                   	push   %edi
  801caa:	e8 cb f5 ff ff       	call   80127a <fd2data>
  801caf:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801cb1:	83 c4 10             	add    $0x10,%esp
  801cb4:	be 00 00 00 00       	mov    $0x0,%esi
  801cb9:	3b 75 10             	cmp    0x10(%ebp),%esi
  801cbc:	75 14                	jne    801cd2 <devpipe_read+0x35>
	return i;
  801cbe:	8b 45 10             	mov    0x10(%ebp),%eax
  801cc1:	eb 02                	jmp    801cc5 <devpipe_read+0x28>
				return i;
  801cc3:	89 f0                	mov    %esi,%eax
}
  801cc5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cc8:	5b                   	pop    %ebx
  801cc9:	5e                   	pop    %esi
  801cca:	5f                   	pop    %edi
  801ccb:	5d                   	pop    %ebp
  801ccc:	c3                   	ret    
			sys_yield();
  801ccd:	e8 47 f3 ff ff       	call   801019 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801cd2:	8b 03                	mov    (%ebx),%eax
  801cd4:	3b 43 04             	cmp    0x4(%ebx),%eax
  801cd7:	75 18                	jne    801cf1 <devpipe_read+0x54>
			if (i > 0)
  801cd9:	85 f6                	test   %esi,%esi
  801cdb:	75 e6                	jne    801cc3 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801cdd:	89 da                	mov    %ebx,%edx
  801cdf:	89 f8                	mov    %edi,%eax
  801ce1:	e8 d0 fe ff ff       	call   801bb6 <_pipeisclosed>
  801ce6:	85 c0                	test   %eax,%eax
  801ce8:	74 e3                	je     801ccd <devpipe_read+0x30>
				return 0;
  801cea:	b8 00 00 00 00       	mov    $0x0,%eax
  801cef:	eb d4                	jmp    801cc5 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801cf1:	99                   	cltd   
  801cf2:	c1 ea 1b             	shr    $0x1b,%edx
  801cf5:	01 d0                	add    %edx,%eax
  801cf7:	83 e0 1f             	and    $0x1f,%eax
  801cfa:	29 d0                	sub    %edx,%eax
  801cfc:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801d01:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d04:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801d07:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801d0a:	83 c6 01             	add    $0x1,%esi
  801d0d:	eb aa                	jmp    801cb9 <devpipe_read+0x1c>

00801d0f <pipe>:
{
  801d0f:	55                   	push   %ebp
  801d10:	89 e5                	mov    %esp,%ebp
  801d12:	56                   	push   %esi
  801d13:	53                   	push   %ebx
  801d14:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801d17:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d1a:	50                   	push   %eax
  801d1b:	e8 71 f5 ff ff       	call   801291 <fd_alloc>
  801d20:	89 c3                	mov    %eax,%ebx
  801d22:	83 c4 10             	add    $0x10,%esp
  801d25:	85 c0                	test   %eax,%eax
  801d27:	0f 88 23 01 00 00    	js     801e50 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d2d:	83 ec 04             	sub    $0x4,%esp
  801d30:	68 07 04 00 00       	push   $0x407
  801d35:	ff 75 f4             	pushl  -0xc(%ebp)
  801d38:	6a 00                	push   $0x0
  801d3a:	e8 f9 f2 ff ff       	call   801038 <sys_page_alloc>
  801d3f:	89 c3                	mov    %eax,%ebx
  801d41:	83 c4 10             	add    $0x10,%esp
  801d44:	85 c0                	test   %eax,%eax
  801d46:	0f 88 04 01 00 00    	js     801e50 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801d4c:	83 ec 0c             	sub    $0xc,%esp
  801d4f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d52:	50                   	push   %eax
  801d53:	e8 39 f5 ff ff       	call   801291 <fd_alloc>
  801d58:	89 c3                	mov    %eax,%ebx
  801d5a:	83 c4 10             	add    $0x10,%esp
  801d5d:	85 c0                	test   %eax,%eax
  801d5f:	0f 88 db 00 00 00    	js     801e40 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d65:	83 ec 04             	sub    $0x4,%esp
  801d68:	68 07 04 00 00       	push   $0x407
  801d6d:	ff 75 f0             	pushl  -0x10(%ebp)
  801d70:	6a 00                	push   $0x0
  801d72:	e8 c1 f2 ff ff       	call   801038 <sys_page_alloc>
  801d77:	89 c3                	mov    %eax,%ebx
  801d79:	83 c4 10             	add    $0x10,%esp
  801d7c:	85 c0                	test   %eax,%eax
  801d7e:	0f 88 bc 00 00 00    	js     801e40 <pipe+0x131>
	va = fd2data(fd0);
  801d84:	83 ec 0c             	sub    $0xc,%esp
  801d87:	ff 75 f4             	pushl  -0xc(%ebp)
  801d8a:	e8 eb f4 ff ff       	call   80127a <fd2data>
  801d8f:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d91:	83 c4 0c             	add    $0xc,%esp
  801d94:	68 07 04 00 00       	push   $0x407
  801d99:	50                   	push   %eax
  801d9a:	6a 00                	push   $0x0
  801d9c:	e8 97 f2 ff ff       	call   801038 <sys_page_alloc>
  801da1:	89 c3                	mov    %eax,%ebx
  801da3:	83 c4 10             	add    $0x10,%esp
  801da6:	85 c0                	test   %eax,%eax
  801da8:	0f 88 82 00 00 00    	js     801e30 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801dae:	83 ec 0c             	sub    $0xc,%esp
  801db1:	ff 75 f0             	pushl  -0x10(%ebp)
  801db4:	e8 c1 f4 ff ff       	call   80127a <fd2data>
  801db9:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801dc0:	50                   	push   %eax
  801dc1:	6a 00                	push   $0x0
  801dc3:	56                   	push   %esi
  801dc4:	6a 00                	push   $0x0
  801dc6:	e8 b0 f2 ff ff       	call   80107b <sys_page_map>
  801dcb:	89 c3                	mov    %eax,%ebx
  801dcd:	83 c4 20             	add    $0x20,%esp
  801dd0:	85 c0                	test   %eax,%eax
  801dd2:	78 4e                	js     801e22 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801dd4:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801dd9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ddc:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801dde:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801de1:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801de8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801deb:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801ded:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801df0:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801df7:	83 ec 0c             	sub    $0xc,%esp
  801dfa:	ff 75 f4             	pushl  -0xc(%ebp)
  801dfd:	e8 68 f4 ff ff       	call   80126a <fd2num>
  801e02:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e05:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801e07:	83 c4 04             	add    $0x4,%esp
  801e0a:	ff 75 f0             	pushl  -0x10(%ebp)
  801e0d:	e8 58 f4 ff ff       	call   80126a <fd2num>
  801e12:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e15:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801e18:	83 c4 10             	add    $0x10,%esp
  801e1b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e20:	eb 2e                	jmp    801e50 <pipe+0x141>
	sys_page_unmap(0, va);
  801e22:	83 ec 08             	sub    $0x8,%esp
  801e25:	56                   	push   %esi
  801e26:	6a 00                	push   $0x0
  801e28:	e8 90 f2 ff ff       	call   8010bd <sys_page_unmap>
  801e2d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801e30:	83 ec 08             	sub    $0x8,%esp
  801e33:	ff 75 f0             	pushl  -0x10(%ebp)
  801e36:	6a 00                	push   $0x0
  801e38:	e8 80 f2 ff ff       	call   8010bd <sys_page_unmap>
  801e3d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801e40:	83 ec 08             	sub    $0x8,%esp
  801e43:	ff 75 f4             	pushl  -0xc(%ebp)
  801e46:	6a 00                	push   $0x0
  801e48:	e8 70 f2 ff ff       	call   8010bd <sys_page_unmap>
  801e4d:	83 c4 10             	add    $0x10,%esp
}
  801e50:	89 d8                	mov    %ebx,%eax
  801e52:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e55:	5b                   	pop    %ebx
  801e56:	5e                   	pop    %esi
  801e57:	5d                   	pop    %ebp
  801e58:	c3                   	ret    

00801e59 <pipeisclosed>:
{
  801e59:	55                   	push   %ebp
  801e5a:	89 e5                	mov    %esp,%ebp
  801e5c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e5f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e62:	50                   	push   %eax
  801e63:	ff 75 08             	pushl  0x8(%ebp)
  801e66:	e8 78 f4 ff ff       	call   8012e3 <fd_lookup>
  801e6b:	83 c4 10             	add    $0x10,%esp
  801e6e:	85 c0                	test   %eax,%eax
  801e70:	78 18                	js     801e8a <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801e72:	83 ec 0c             	sub    $0xc,%esp
  801e75:	ff 75 f4             	pushl  -0xc(%ebp)
  801e78:	e8 fd f3 ff ff       	call   80127a <fd2data>
	return _pipeisclosed(fd, p);
  801e7d:	89 c2                	mov    %eax,%edx
  801e7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e82:	e8 2f fd ff ff       	call   801bb6 <_pipeisclosed>
  801e87:	83 c4 10             	add    $0x10,%esp
}
  801e8a:	c9                   	leave  
  801e8b:	c3                   	ret    

00801e8c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801e8c:	55                   	push   %ebp
  801e8d:	89 e5                	mov    %esp,%ebp
  801e8f:	56                   	push   %esi
  801e90:	53                   	push   %ebx
  801e91:	8b 75 08             	mov    0x8(%ebp),%esi
  801e94:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e97:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// cprintf("in %s\n", __FUNCTION__);
	int ret;
	if(!pg)
  801e9a:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801e9c:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801ea1:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  801ea4:	83 ec 0c             	sub    $0xc,%esp
  801ea7:	50                   	push   %eax
  801ea8:	e8 3b f3 ff ff       	call   8011e8 <sys_ipc_recv>
	if(ret < 0){
  801ead:	83 c4 10             	add    $0x10,%esp
  801eb0:	85 c0                	test   %eax,%eax
  801eb2:	78 2b                	js     801edf <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  801eb4:	85 f6                	test   %esi,%esi
  801eb6:	74 0a                	je     801ec2 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  801eb8:	a1 04 44 80 00       	mov    0x804404,%eax
  801ebd:	8b 40 74             	mov    0x74(%eax),%eax
  801ec0:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  801ec2:	85 db                	test   %ebx,%ebx
  801ec4:	74 0a                	je     801ed0 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  801ec6:	a1 04 44 80 00       	mov    0x804404,%eax
  801ecb:	8b 40 78             	mov    0x78(%eax),%eax
  801ece:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  801ed0:	a1 04 44 80 00       	mov    0x804404,%eax
  801ed5:	8b 40 70             	mov    0x70(%eax),%eax
}
  801ed8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801edb:	5b                   	pop    %ebx
  801edc:	5e                   	pop    %esi
  801edd:	5d                   	pop    %ebp
  801ede:	c3                   	ret    
		if(from_env_store)
  801edf:	85 f6                	test   %esi,%esi
  801ee1:	74 06                	je     801ee9 <ipc_recv+0x5d>
			*from_env_store = 0;
  801ee3:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  801ee9:	85 db                	test   %ebx,%ebx
  801eeb:	74 eb                	je     801ed8 <ipc_recv+0x4c>
			*perm_store = 0;
  801eed:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801ef3:	eb e3                	jmp    801ed8 <ipc_recv+0x4c>

00801ef5 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  801ef5:	55                   	push   %ebp
  801ef6:	89 e5                	mov    %esp,%ebp
  801ef8:	57                   	push   %edi
  801ef9:	56                   	push   %esi
  801efa:	53                   	push   %ebx
  801efb:	83 ec 0c             	sub    $0xc,%esp
  801efe:	8b 7d 08             	mov    0x8(%ebp),%edi
  801f01:	8b 75 0c             	mov    0xc(%ebp),%esi
  801f04:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  801f07:	85 db                	test   %ebx,%ebx
  801f09:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801f0e:	0f 44 d8             	cmove  %eax,%ebx
  801f11:	eb 05                	jmp    801f18 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  801f13:	e8 01 f1 ff ff       	call   801019 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  801f18:	ff 75 14             	pushl  0x14(%ebp)
  801f1b:	53                   	push   %ebx
  801f1c:	56                   	push   %esi
  801f1d:	57                   	push   %edi
  801f1e:	e8 a2 f2 ff ff       	call   8011c5 <sys_ipc_try_send>
  801f23:	83 c4 10             	add    $0x10,%esp
  801f26:	85 c0                	test   %eax,%eax
  801f28:	74 1b                	je     801f45 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  801f2a:	79 e7                	jns    801f13 <ipc_send+0x1e>
  801f2c:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801f2f:	74 e2                	je     801f13 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  801f31:	83 ec 04             	sub    $0x4,%esp
  801f34:	68 9c 27 80 00       	push   $0x80279c
  801f39:	6a 49                	push   $0x49
  801f3b:	68 b1 27 80 00       	push   $0x8027b1
  801f40:	e8 bc e3 ff ff       	call   800301 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  801f45:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f48:	5b                   	pop    %ebx
  801f49:	5e                   	pop    %esi
  801f4a:	5f                   	pop    %edi
  801f4b:	5d                   	pop    %ebp
  801f4c:	c3                   	ret    

00801f4d <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801f4d:	55                   	push   %ebp
  801f4e:	89 e5                	mov    %esp,%ebp
  801f50:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801f53:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801f58:	89 c2                	mov    %eax,%edx
  801f5a:	c1 e2 07             	shl    $0x7,%edx
  801f5d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801f63:	8b 52 50             	mov    0x50(%edx),%edx
  801f66:	39 ca                	cmp    %ecx,%edx
  801f68:	74 11                	je     801f7b <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  801f6a:	83 c0 01             	add    $0x1,%eax
  801f6d:	3d 00 04 00 00       	cmp    $0x400,%eax
  801f72:	75 e4                	jne    801f58 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801f74:	b8 00 00 00 00       	mov    $0x0,%eax
  801f79:	eb 0b                	jmp    801f86 <ipc_find_env+0x39>
			return envs[i].env_id;
  801f7b:	c1 e0 07             	shl    $0x7,%eax
  801f7e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801f83:	8b 40 48             	mov    0x48(%eax),%eax
}
  801f86:	5d                   	pop    %ebp
  801f87:	c3                   	ret    

00801f88 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801f88:	55                   	push   %ebp
  801f89:	89 e5                	mov    %esp,%ebp
  801f8b:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801f8e:	89 d0                	mov    %edx,%eax
  801f90:	c1 e8 16             	shr    $0x16,%eax
  801f93:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801f9a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801f9f:	f6 c1 01             	test   $0x1,%cl
  801fa2:	74 1d                	je     801fc1 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801fa4:	c1 ea 0c             	shr    $0xc,%edx
  801fa7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801fae:	f6 c2 01             	test   $0x1,%dl
  801fb1:	74 0e                	je     801fc1 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801fb3:	c1 ea 0c             	shr    $0xc,%edx
  801fb6:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801fbd:	ef 
  801fbe:	0f b7 c0             	movzwl %ax,%eax
}
  801fc1:	5d                   	pop    %ebp
  801fc2:	c3                   	ret    
  801fc3:	66 90                	xchg   %ax,%ax
  801fc5:	66 90                	xchg   %ax,%ax
  801fc7:	66 90                	xchg   %ax,%ax
  801fc9:	66 90                	xchg   %ax,%ax
  801fcb:	66 90                	xchg   %ax,%ax
  801fcd:	66 90                	xchg   %ax,%ax
  801fcf:	90                   	nop

00801fd0 <__udivdi3>:
  801fd0:	55                   	push   %ebp
  801fd1:	57                   	push   %edi
  801fd2:	56                   	push   %esi
  801fd3:	53                   	push   %ebx
  801fd4:	83 ec 1c             	sub    $0x1c,%esp
  801fd7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801fdb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801fdf:	8b 74 24 34          	mov    0x34(%esp),%esi
  801fe3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801fe7:	85 d2                	test   %edx,%edx
  801fe9:	75 4d                	jne    802038 <__udivdi3+0x68>
  801feb:	39 f3                	cmp    %esi,%ebx
  801fed:	76 19                	jbe    802008 <__udivdi3+0x38>
  801fef:	31 ff                	xor    %edi,%edi
  801ff1:	89 e8                	mov    %ebp,%eax
  801ff3:	89 f2                	mov    %esi,%edx
  801ff5:	f7 f3                	div    %ebx
  801ff7:	89 fa                	mov    %edi,%edx
  801ff9:	83 c4 1c             	add    $0x1c,%esp
  801ffc:	5b                   	pop    %ebx
  801ffd:	5e                   	pop    %esi
  801ffe:	5f                   	pop    %edi
  801fff:	5d                   	pop    %ebp
  802000:	c3                   	ret    
  802001:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802008:	89 d9                	mov    %ebx,%ecx
  80200a:	85 db                	test   %ebx,%ebx
  80200c:	75 0b                	jne    802019 <__udivdi3+0x49>
  80200e:	b8 01 00 00 00       	mov    $0x1,%eax
  802013:	31 d2                	xor    %edx,%edx
  802015:	f7 f3                	div    %ebx
  802017:	89 c1                	mov    %eax,%ecx
  802019:	31 d2                	xor    %edx,%edx
  80201b:	89 f0                	mov    %esi,%eax
  80201d:	f7 f1                	div    %ecx
  80201f:	89 c6                	mov    %eax,%esi
  802021:	89 e8                	mov    %ebp,%eax
  802023:	89 f7                	mov    %esi,%edi
  802025:	f7 f1                	div    %ecx
  802027:	89 fa                	mov    %edi,%edx
  802029:	83 c4 1c             	add    $0x1c,%esp
  80202c:	5b                   	pop    %ebx
  80202d:	5e                   	pop    %esi
  80202e:	5f                   	pop    %edi
  80202f:	5d                   	pop    %ebp
  802030:	c3                   	ret    
  802031:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802038:	39 f2                	cmp    %esi,%edx
  80203a:	77 1c                	ja     802058 <__udivdi3+0x88>
  80203c:	0f bd fa             	bsr    %edx,%edi
  80203f:	83 f7 1f             	xor    $0x1f,%edi
  802042:	75 2c                	jne    802070 <__udivdi3+0xa0>
  802044:	39 f2                	cmp    %esi,%edx
  802046:	72 06                	jb     80204e <__udivdi3+0x7e>
  802048:	31 c0                	xor    %eax,%eax
  80204a:	39 eb                	cmp    %ebp,%ebx
  80204c:	77 a9                	ja     801ff7 <__udivdi3+0x27>
  80204e:	b8 01 00 00 00       	mov    $0x1,%eax
  802053:	eb a2                	jmp    801ff7 <__udivdi3+0x27>
  802055:	8d 76 00             	lea    0x0(%esi),%esi
  802058:	31 ff                	xor    %edi,%edi
  80205a:	31 c0                	xor    %eax,%eax
  80205c:	89 fa                	mov    %edi,%edx
  80205e:	83 c4 1c             	add    $0x1c,%esp
  802061:	5b                   	pop    %ebx
  802062:	5e                   	pop    %esi
  802063:	5f                   	pop    %edi
  802064:	5d                   	pop    %ebp
  802065:	c3                   	ret    
  802066:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80206d:	8d 76 00             	lea    0x0(%esi),%esi
  802070:	89 f9                	mov    %edi,%ecx
  802072:	b8 20 00 00 00       	mov    $0x20,%eax
  802077:	29 f8                	sub    %edi,%eax
  802079:	d3 e2                	shl    %cl,%edx
  80207b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80207f:	89 c1                	mov    %eax,%ecx
  802081:	89 da                	mov    %ebx,%edx
  802083:	d3 ea                	shr    %cl,%edx
  802085:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802089:	09 d1                	or     %edx,%ecx
  80208b:	89 f2                	mov    %esi,%edx
  80208d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802091:	89 f9                	mov    %edi,%ecx
  802093:	d3 e3                	shl    %cl,%ebx
  802095:	89 c1                	mov    %eax,%ecx
  802097:	d3 ea                	shr    %cl,%edx
  802099:	89 f9                	mov    %edi,%ecx
  80209b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80209f:	89 eb                	mov    %ebp,%ebx
  8020a1:	d3 e6                	shl    %cl,%esi
  8020a3:	89 c1                	mov    %eax,%ecx
  8020a5:	d3 eb                	shr    %cl,%ebx
  8020a7:	09 de                	or     %ebx,%esi
  8020a9:	89 f0                	mov    %esi,%eax
  8020ab:	f7 74 24 08          	divl   0x8(%esp)
  8020af:	89 d6                	mov    %edx,%esi
  8020b1:	89 c3                	mov    %eax,%ebx
  8020b3:	f7 64 24 0c          	mull   0xc(%esp)
  8020b7:	39 d6                	cmp    %edx,%esi
  8020b9:	72 15                	jb     8020d0 <__udivdi3+0x100>
  8020bb:	89 f9                	mov    %edi,%ecx
  8020bd:	d3 e5                	shl    %cl,%ebp
  8020bf:	39 c5                	cmp    %eax,%ebp
  8020c1:	73 04                	jae    8020c7 <__udivdi3+0xf7>
  8020c3:	39 d6                	cmp    %edx,%esi
  8020c5:	74 09                	je     8020d0 <__udivdi3+0x100>
  8020c7:	89 d8                	mov    %ebx,%eax
  8020c9:	31 ff                	xor    %edi,%edi
  8020cb:	e9 27 ff ff ff       	jmp    801ff7 <__udivdi3+0x27>
  8020d0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8020d3:	31 ff                	xor    %edi,%edi
  8020d5:	e9 1d ff ff ff       	jmp    801ff7 <__udivdi3+0x27>
  8020da:	66 90                	xchg   %ax,%ax
  8020dc:	66 90                	xchg   %ax,%ax
  8020de:	66 90                	xchg   %ax,%ax

008020e0 <__umoddi3>:
  8020e0:	55                   	push   %ebp
  8020e1:	57                   	push   %edi
  8020e2:	56                   	push   %esi
  8020e3:	53                   	push   %ebx
  8020e4:	83 ec 1c             	sub    $0x1c,%esp
  8020e7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8020eb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8020ef:	8b 74 24 30          	mov    0x30(%esp),%esi
  8020f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8020f7:	89 da                	mov    %ebx,%edx
  8020f9:	85 c0                	test   %eax,%eax
  8020fb:	75 43                	jne    802140 <__umoddi3+0x60>
  8020fd:	39 df                	cmp    %ebx,%edi
  8020ff:	76 17                	jbe    802118 <__umoddi3+0x38>
  802101:	89 f0                	mov    %esi,%eax
  802103:	f7 f7                	div    %edi
  802105:	89 d0                	mov    %edx,%eax
  802107:	31 d2                	xor    %edx,%edx
  802109:	83 c4 1c             	add    $0x1c,%esp
  80210c:	5b                   	pop    %ebx
  80210d:	5e                   	pop    %esi
  80210e:	5f                   	pop    %edi
  80210f:	5d                   	pop    %ebp
  802110:	c3                   	ret    
  802111:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802118:	89 fd                	mov    %edi,%ebp
  80211a:	85 ff                	test   %edi,%edi
  80211c:	75 0b                	jne    802129 <__umoddi3+0x49>
  80211e:	b8 01 00 00 00       	mov    $0x1,%eax
  802123:	31 d2                	xor    %edx,%edx
  802125:	f7 f7                	div    %edi
  802127:	89 c5                	mov    %eax,%ebp
  802129:	89 d8                	mov    %ebx,%eax
  80212b:	31 d2                	xor    %edx,%edx
  80212d:	f7 f5                	div    %ebp
  80212f:	89 f0                	mov    %esi,%eax
  802131:	f7 f5                	div    %ebp
  802133:	89 d0                	mov    %edx,%eax
  802135:	eb d0                	jmp    802107 <__umoddi3+0x27>
  802137:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80213e:	66 90                	xchg   %ax,%ax
  802140:	89 f1                	mov    %esi,%ecx
  802142:	39 d8                	cmp    %ebx,%eax
  802144:	76 0a                	jbe    802150 <__umoddi3+0x70>
  802146:	89 f0                	mov    %esi,%eax
  802148:	83 c4 1c             	add    $0x1c,%esp
  80214b:	5b                   	pop    %ebx
  80214c:	5e                   	pop    %esi
  80214d:	5f                   	pop    %edi
  80214e:	5d                   	pop    %ebp
  80214f:	c3                   	ret    
  802150:	0f bd e8             	bsr    %eax,%ebp
  802153:	83 f5 1f             	xor    $0x1f,%ebp
  802156:	75 20                	jne    802178 <__umoddi3+0x98>
  802158:	39 d8                	cmp    %ebx,%eax
  80215a:	0f 82 b0 00 00 00    	jb     802210 <__umoddi3+0x130>
  802160:	39 f7                	cmp    %esi,%edi
  802162:	0f 86 a8 00 00 00    	jbe    802210 <__umoddi3+0x130>
  802168:	89 c8                	mov    %ecx,%eax
  80216a:	83 c4 1c             	add    $0x1c,%esp
  80216d:	5b                   	pop    %ebx
  80216e:	5e                   	pop    %esi
  80216f:	5f                   	pop    %edi
  802170:	5d                   	pop    %ebp
  802171:	c3                   	ret    
  802172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802178:	89 e9                	mov    %ebp,%ecx
  80217a:	ba 20 00 00 00       	mov    $0x20,%edx
  80217f:	29 ea                	sub    %ebp,%edx
  802181:	d3 e0                	shl    %cl,%eax
  802183:	89 44 24 08          	mov    %eax,0x8(%esp)
  802187:	89 d1                	mov    %edx,%ecx
  802189:	89 f8                	mov    %edi,%eax
  80218b:	d3 e8                	shr    %cl,%eax
  80218d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802191:	89 54 24 04          	mov    %edx,0x4(%esp)
  802195:	8b 54 24 04          	mov    0x4(%esp),%edx
  802199:	09 c1                	or     %eax,%ecx
  80219b:	89 d8                	mov    %ebx,%eax
  80219d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8021a1:	89 e9                	mov    %ebp,%ecx
  8021a3:	d3 e7                	shl    %cl,%edi
  8021a5:	89 d1                	mov    %edx,%ecx
  8021a7:	d3 e8                	shr    %cl,%eax
  8021a9:	89 e9                	mov    %ebp,%ecx
  8021ab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8021af:	d3 e3                	shl    %cl,%ebx
  8021b1:	89 c7                	mov    %eax,%edi
  8021b3:	89 d1                	mov    %edx,%ecx
  8021b5:	89 f0                	mov    %esi,%eax
  8021b7:	d3 e8                	shr    %cl,%eax
  8021b9:	89 e9                	mov    %ebp,%ecx
  8021bb:	89 fa                	mov    %edi,%edx
  8021bd:	d3 e6                	shl    %cl,%esi
  8021bf:	09 d8                	or     %ebx,%eax
  8021c1:	f7 74 24 08          	divl   0x8(%esp)
  8021c5:	89 d1                	mov    %edx,%ecx
  8021c7:	89 f3                	mov    %esi,%ebx
  8021c9:	f7 64 24 0c          	mull   0xc(%esp)
  8021cd:	89 c6                	mov    %eax,%esi
  8021cf:	89 d7                	mov    %edx,%edi
  8021d1:	39 d1                	cmp    %edx,%ecx
  8021d3:	72 06                	jb     8021db <__umoddi3+0xfb>
  8021d5:	75 10                	jne    8021e7 <__umoddi3+0x107>
  8021d7:	39 c3                	cmp    %eax,%ebx
  8021d9:	73 0c                	jae    8021e7 <__umoddi3+0x107>
  8021db:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8021df:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8021e3:	89 d7                	mov    %edx,%edi
  8021e5:	89 c6                	mov    %eax,%esi
  8021e7:	89 ca                	mov    %ecx,%edx
  8021e9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8021ee:	29 f3                	sub    %esi,%ebx
  8021f0:	19 fa                	sbb    %edi,%edx
  8021f2:	89 d0                	mov    %edx,%eax
  8021f4:	d3 e0                	shl    %cl,%eax
  8021f6:	89 e9                	mov    %ebp,%ecx
  8021f8:	d3 eb                	shr    %cl,%ebx
  8021fa:	d3 ea                	shr    %cl,%edx
  8021fc:	09 d8                	or     %ebx,%eax
  8021fe:	83 c4 1c             	add    $0x1c,%esp
  802201:	5b                   	pop    %ebx
  802202:	5e                   	pop    %esi
  802203:	5f                   	pop    %edi
  802204:	5d                   	pop    %ebp
  802205:	c3                   	ret    
  802206:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80220d:	8d 76 00             	lea    0x0(%esi),%esi
  802210:	89 da                	mov    %ebx,%edx
  802212:	29 fe                	sub    %edi,%esi
  802214:	19 c2                	sbb    %eax,%edx
  802216:	89 f1                	mov    %esi,%ecx
  802218:	89 c8                	mov    %ecx,%eax
  80221a:	e9 4b ff ff ff       	jmp    80216a <__umoddi3+0x8a>
