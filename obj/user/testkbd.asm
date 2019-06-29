
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
  80003f:	e8 ab 0f 00 00       	call   800fef <sys_yield>
	for (i = 0; i < 10; ++i)
  800044:	83 eb 01             	sub    $0x1,%ebx
  800047:	75 f6                	jne    80003f <umain+0xc>

	close(0);
  800049:	83 ec 0c             	sub    $0xc,%esp
  80004c:	6a 00                	push   $0x0
  80004e:	e8 5b 14 00 00       	call   8014ae <close>
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
  80006e:	e8 64 02 00 00       	call   8002d7 <_panic>
		panic("opencons: %e", r);
  800073:	50                   	push   %eax
  800074:	68 a0 27 80 00       	push   $0x8027a0
  800079:	6a 0f                	push   $0xf
  80007b:	68 ad 27 80 00       	push   $0x8027ad
  800080:	e8 52 02 00 00       	call   8002d7 <_panic>
	if ((r = dup(0, 1)) < 0)
  800085:	83 ec 08             	sub    $0x8,%esp
  800088:	6a 01                	push   $0x1
  80008a:	6a 00                	push   $0x0
  80008c:	e8 6f 14 00 00       	call   801500 <dup>
  800091:	83 c4 10             	add    $0x10,%esp
  800094:	85 c0                	test   %eax,%eax
  800096:	79 24                	jns    8000bc <umain+0x89>
		panic("dup: %e", r);
  800098:	50                   	push   %eax
  800099:	68 d6 27 80 00       	push   $0x8027d6
  80009e:	6a 13                	push   $0x13
  8000a0:	68 ad 27 80 00       	push   $0x8027ad
  8000a5:	e8 2d 02 00 00       	call   8002d7 <_panic>

		buf = readline("Type a line: ");
		if (buf != NULL)
			fprintf(1, "%s\n", buf);
		else
			fprintf(1, "(end of file received)\n");
  8000aa:	83 ec 08             	sub    $0x8,%esp
  8000ad:	68 ec 27 80 00       	push   $0x8027ec
  8000b2:	6a 01                	push   $0x1
  8000b4:	e8 5d 1b 00 00       	call   801c16 <fprintf>
  8000b9:	83 c4 10             	add    $0x10,%esp
		buf = readline("Type a line: ");
  8000bc:	83 ec 0c             	sub    $0xc,%esp
  8000bf:	68 de 27 80 00       	push   $0x8027de
  8000c4:	e8 2a 0a 00 00       	call   800af3 <readline>
		if (buf != NULL)
  8000c9:	83 c4 10             	add    $0x10,%esp
  8000cc:	85 c0                	test   %eax,%eax
  8000ce:	74 da                	je     8000aa <umain+0x77>
			fprintf(1, "%s\n", buf);
  8000d0:	83 ec 04             	sub    $0x4,%esp
  8000d3:	50                   	push   %eax
  8000d4:	68 21 28 80 00       	push   $0x802821
  8000d9:	6a 01                	push   $0x1
  8000db:	e8 36 1b 00 00       	call   801c16 <fprintf>
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
  8000f9:	e8 1e 0b 00 00       	call   800c1c <strcpy>
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
  80013c:	e8 69 0c 00 00       	call   800daa <memmove>
		sys_cputs(buf, m);
  800141:	83 c4 08             	add    $0x8,%esp
  800144:	53                   	push   %ebx
  800145:	57                   	push   %edi
  800146:	e8 07 0e 00 00       	call   800f52 <sys_cputs>
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
  80016d:	e8 fe 0d 00 00       	call   800f70 <sys_cgetc>
  800172:	85 c0                	test   %eax,%eax
  800174:	75 07                	jne    80017d <devcons_read+0x21>
		sys_yield();
  800176:	e8 74 0e 00 00       	call   800fef <sys_yield>
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
  8001a9:	e8 a4 0d 00 00       	call   800f52 <sys_cputs>
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
  8001c1:	e8 26 14 00 00       	call   8015ec <read>
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
  8001e9:	e8 8e 11 00 00       	call   80137c <fd_lookup>
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
  800212:	e8 13 11 00 00       	call   80132a <fd_alloc>
  800217:	83 c4 10             	add    $0x10,%esp
  80021a:	85 c0                	test   %eax,%eax
  80021c:	78 3a                	js     800258 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80021e:	83 ec 04             	sub    $0x4,%esp
  800221:	68 07 04 00 00       	push   $0x407
  800226:	ff 75 f4             	pushl  -0xc(%ebp)
  800229:	6a 00                	push   $0x0
  80022b:	e8 de 0d 00 00       	call   80100e <sys_page_alloc>
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
  800250:	e8 ae 10 00 00       	call   801303 <fd2num>
  800255:	83 c4 10             	add    $0x10,%esp
}
  800258:	c9                   	leave  
  800259:	c3                   	ret    

0080025a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80025a:	55                   	push   %ebp
  80025b:	89 e5                	mov    %esp,%ebp
  80025d:	56                   	push   %esi
  80025e:	53                   	push   %ebx
  80025f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800262:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	envid_t curenv = sys_getenvid();
  800265:	e8 66 0d 00 00       	call   800fd0 <sys_getenvid>
	thisenv = envs + ENVX(curenv);
  80026a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80026f:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  800275:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80027a:	a3 08 44 80 00       	mov    %eax,0x804408

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80027f:	85 db                	test   %ebx,%ebx
  800281:	7e 07                	jle    80028a <libmain+0x30>
		binaryname = argv[0];
  800283:	8b 06                	mov    (%esi),%eax
  800285:	a3 1c 30 80 00       	mov    %eax,0x80301c

	// call user main routine
	umain(argc, argv);
  80028a:	83 ec 08             	sub    $0x8,%esp
  80028d:	56                   	push   %esi
  80028e:	53                   	push   %ebx
  80028f:	e8 9f fd ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800294:	e8 0a 00 00 00       	call   8002a3 <exit>
}
  800299:	83 c4 10             	add    $0x10,%esp
  80029c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80029f:	5b                   	pop    %ebx
  8002a0:	5e                   	pop    %esi
  8002a1:	5d                   	pop    %ebp
  8002a2:	c3                   	ret    

008002a3 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8002a3:	55                   	push   %ebp
  8002a4:	89 e5                	mov    %esp,%ebp
  8002a6:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8002a9:	a1 08 44 80 00       	mov    0x804408,%eax
  8002ae:	8b 40 48             	mov    0x48(%eax),%eax
  8002b1:	68 28 28 80 00       	push   $0x802828
  8002b6:	50                   	push   %eax
  8002b7:	68 1a 28 80 00       	push   $0x80281a
  8002bc:	e8 0c 01 00 00       	call   8003cd <cprintf>
	close_all();
  8002c1:	e8 15 12 00 00       	call   8014db <close_all>
	sys_env_destroy(0);
  8002c6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8002cd:	e8 bd 0c 00 00       	call   800f8f <sys_env_destroy>
}
  8002d2:	83 c4 10             	add    $0x10,%esp
  8002d5:	c9                   	leave  
  8002d6:	c3                   	ret    

008002d7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002d7:	55                   	push   %ebp
  8002d8:	89 e5                	mov    %esp,%ebp
  8002da:	56                   	push   %esi
  8002db:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8002dc:	a1 08 44 80 00       	mov    0x804408,%eax
  8002e1:	8b 40 48             	mov    0x48(%eax),%eax
  8002e4:	83 ec 04             	sub    $0x4,%esp
  8002e7:	68 54 28 80 00       	push   $0x802854
  8002ec:	50                   	push   %eax
  8002ed:	68 1a 28 80 00       	push   $0x80281a
  8002f2:	e8 d6 00 00 00       	call   8003cd <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8002f7:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002fa:	8b 35 1c 30 80 00    	mov    0x80301c,%esi
  800300:	e8 cb 0c 00 00       	call   800fd0 <sys_getenvid>
  800305:	83 c4 04             	add    $0x4,%esp
  800308:	ff 75 0c             	pushl  0xc(%ebp)
  80030b:	ff 75 08             	pushl  0x8(%ebp)
  80030e:	56                   	push   %esi
  80030f:	50                   	push   %eax
  800310:	68 30 28 80 00       	push   $0x802830
  800315:	e8 b3 00 00 00       	call   8003cd <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80031a:	83 c4 18             	add    $0x18,%esp
  80031d:	53                   	push   %ebx
  80031e:	ff 75 10             	pushl  0x10(%ebp)
  800321:	e8 56 00 00 00       	call   80037c <vcprintf>
	cprintf("\n");
  800326:	c7 04 24 56 2d 80 00 	movl   $0x802d56,(%esp)
  80032d:	e8 9b 00 00 00       	call   8003cd <cprintf>
  800332:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800335:	cc                   	int3   
  800336:	eb fd                	jmp    800335 <_panic+0x5e>

00800338 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800338:	55                   	push   %ebp
  800339:	89 e5                	mov    %esp,%ebp
  80033b:	53                   	push   %ebx
  80033c:	83 ec 04             	sub    $0x4,%esp
  80033f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800342:	8b 13                	mov    (%ebx),%edx
  800344:	8d 42 01             	lea    0x1(%edx),%eax
  800347:	89 03                	mov    %eax,(%ebx)
  800349:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80034c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800350:	3d ff 00 00 00       	cmp    $0xff,%eax
  800355:	74 09                	je     800360 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800357:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80035b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80035e:	c9                   	leave  
  80035f:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800360:	83 ec 08             	sub    $0x8,%esp
  800363:	68 ff 00 00 00       	push   $0xff
  800368:	8d 43 08             	lea    0x8(%ebx),%eax
  80036b:	50                   	push   %eax
  80036c:	e8 e1 0b 00 00       	call   800f52 <sys_cputs>
		b->idx = 0;
  800371:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800377:	83 c4 10             	add    $0x10,%esp
  80037a:	eb db                	jmp    800357 <putch+0x1f>

0080037c <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80037c:	55                   	push   %ebp
  80037d:	89 e5                	mov    %esp,%ebp
  80037f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800385:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80038c:	00 00 00 
	b.cnt = 0;
  80038f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800396:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800399:	ff 75 0c             	pushl  0xc(%ebp)
  80039c:	ff 75 08             	pushl  0x8(%ebp)
  80039f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003a5:	50                   	push   %eax
  8003a6:	68 38 03 80 00       	push   $0x800338
  8003ab:	e8 4a 01 00 00       	call   8004fa <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003b0:	83 c4 08             	add    $0x8,%esp
  8003b3:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8003b9:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003bf:	50                   	push   %eax
  8003c0:	e8 8d 0b 00 00       	call   800f52 <sys_cputs>

	return b.cnt;
}
  8003c5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8003cb:	c9                   	leave  
  8003cc:	c3                   	ret    

008003cd <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8003cd:	55                   	push   %ebp
  8003ce:	89 e5                	mov    %esp,%ebp
  8003d0:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003d3:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8003d6:	50                   	push   %eax
  8003d7:	ff 75 08             	pushl  0x8(%ebp)
  8003da:	e8 9d ff ff ff       	call   80037c <vcprintf>
	va_end(ap);

	return cnt;
}
  8003df:	c9                   	leave  
  8003e0:	c3                   	ret    

008003e1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003e1:	55                   	push   %ebp
  8003e2:	89 e5                	mov    %esp,%ebp
  8003e4:	57                   	push   %edi
  8003e5:	56                   	push   %esi
  8003e6:	53                   	push   %ebx
  8003e7:	83 ec 1c             	sub    $0x1c,%esp
  8003ea:	89 c6                	mov    %eax,%esi
  8003ec:	89 d7                	mov    %edx,%edi
  8003ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003f7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8003fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8003fd:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800400:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800404:	74 2c                	je     800432 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800406:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800409:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800410:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800413:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800416:	39 c2                	cmp    %eax,%edx
  800418:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80041b:	73 43                	jae    800460 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  80041d:	83 eb 01             	sub    $0x1,%ebx
  800420:	85 db                	test   %ebx,%ebx
  800422:	7e 6c                	jle    800490 <printnum+0xaf>
				putch(padc, putdat);
  800424:	83 ec 08             	sub    $0x8,%esp
  800427:	57                   	push   %edi
  800428:	ff 75 18             	pushl  0x18(%ebp)
  80042b:	ff d6                	call   *%esi
  80042d:	83 c4 10             	add    $0x10,%esp
  800430:	eb eb                	jmp    80041d <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800432:	83 ec 0c             	sub    $0xc,%esp
  800435:	6a 20                	push   $0x20
  800437:	6a 00                	push   $0x0
  800439:	50                   	push   %eax
  80043a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80043d:	ff 75 e0             	pushl  -0x20(%ebp)
  800440:	89 fa                	mov    %edi,%edx
  800442:	89 f0                	mov    %esi,%eax
  800444:	e8 98 ff ff ff       	call   8003e1 <printnum>
		while (--width > 0)
  800449:	83 c4 20             	add    $0x20,%esp
  80044c:	83 eb 01             	sub    $0x1,%ebx
  80044f:	85 db                	test   %ebx,%ebx
  800451:	7e 65                	jle    8004b8 <printnum+0xd7>
			putch(padc, putdat);
  800453:	83 ec 08             	sub    $0x8,%esp
  800456:	57                   	push   %edi
  800457:	6a 20                	push   $0x20
  800459:	ff d6                	call   *%esi
  80045b:	83 c4 10             	add    $0x10,%esp
  80045e:	eb ec                	jmp    80044c <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800460:	83 ec 0c             	sub    $0xc,%esp
  800463:	ff 75 18             	pushl  0x18(%ebp)
  800466:	83 eb 01             	sub    $0x1,%ebx
  800469:	53                   	push   %ebx
  80046a:	50                   	push   %eax
  80046b:	83 ec 08             	sub    $0x8,%esp
  80046e:	ff 75 dc             	pushl  -0x24(%ebp)
  800471:	ff 75 d8             	pushl  -0x28(%ebp)
  800474:	ff 75 e4             	pushl  -0x1c(%ebp)
  800477:	ff 75 e0             	pushl  -0x20(%ebp)
  80047a:	e8 c1 20 00 00       	call   802540 <__udivdi3>
  80047f:	83 c4 18             	add    $0x18,%esp
  800482:	52                   	push   %edx
  800483:	50                   	push   %eax
  800484:	89 fa                	mov    %edi,%edx
  800486:	89 f0                	mov    %esi,%eax
  800488:	e8 54 ff ff ff       	call   8003e1 <printnum>
  80048d:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800490:	83 ec 08             	sub    $0x8,%esp
  800493:	57                   	push   %edi
  800494:	83 ec 04             	sub    $0x4,%esp
  800497:	ff 75 dc             	pushl  -0x24(%ebp)
  80049a:	ff 75 d8             	pushl  -0x28(%ebp)
  80049d:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004a0:	ff 75 e0             	pushl  -0x20(%ebp)
  8004a3:	e8 a8 21 00 00       	call   802650 <__umoddi3>
  8004a8:	83 c4 14             	add    $0x14,%esp
  8004ab:	0f be 80 5b 28 80 00 	movsbl 0x80285b(%eax),%eax
  8004b2:	50                   	push   %eax
  8004b3:	ff d6                	call   *%esi
  8004b5:	83 c4 10             	add    $0x10,%esp
	}
}
  8004b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004bb:	5b                   	pop    %ebx
  8004bc:	5e                   	pop    %esi
  8004bd:	5f                   	pop    %edi
  8004be:	5d                   	pop    %ebp
  8004bf:	c3                   	ret    

008004c0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004c0:	55                   	push   %ebp
  8004c1:	89 e5                	mov    %esp,%ebp
  8004c3:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004c6:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004ca:	8b 10                	mov    (%eax),%edx
  8004cc:	3b 50 04             	cmp    0x4(%eax),%edx
  8004cf:	73 0a                	jae    8004db <sprintputch+0x1b>
		*b->buf++ = ch;
  8004d1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004d4:	89 08                	mov    %ecx,(%eax)
  8004d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d9:	88 02                	mov    %al,(%edx)
}
  8004db:	5d                   	pop    %ebp
  8004dc:	c3                   	ret    

008004dd <printfmt>:
{
  8004dd:	55                   	push   %ebp
  8004de:	89 e5                	mov    %esp,%ebp
  8004e0:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8004e3:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004e6:	50                   	push   %eax
  8004e7:	ff 75 10             	pushl  0x10(%ebp)
  8004ea:	ff 75 0c             	pushl  0xc(%ebp)
  8004ed:	ff 75 08             	pushl  0x8(%ebp)
  8004f0:	e8 05 00 00 00       	call   8004fa <vprintfmt>
}
  8004f5:	83 c4 10             	add    $0x10,%esp
  8004f8:	c9                   	leave  
  8004f9:	c3                   	ret    

008004fa <vprintfmt>:
{
  8004fa:	55                   	push   %ebp
  8004fb:	89 e5                	mov    %esp,%ebp
  8004fd:	57                   	push   %edi
  8004fe:	56                   	push   %esi
  8004ff:	53                   	push   %ebx
  800500:	83 ec 3c             	sub    $0x3c,%esp
  800503:	8b 75 08             	mov    0x8(%ebp),%esi
  800506:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800509:	8b 7d 10             	mov    0x10(%ebp),%edi
  80050c:	e9 32 04 00 00       	jmp    800943 <vprintfmt+0x449>
		padc = ' ';
  800511:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800515:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  80051c:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800523:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80052a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800531:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800538:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80053d:	8d 47 01             	lea    0x1(%edi),%eax
  800540:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800543:	0f b6 17             	movzbl (%edi),%edx
  800546:	8d 42 dd             	lea    -0x23(%edx),%eax
  800549:	3c 55                	cmp    $0x55,%al
  80054b:	0f 87 12 05 00 00    	ja     800a63 <vprintfmt+0x569>
  800551:	0f b6 c0             	movzbl %al,%eax
  800554:	ff 24 85 40 2a 80 00 	jmp    *0x802a40(,%eax,4)
  80055b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80055e:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800562:	eb d9                	jmp    80053d <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800564:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800567:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80056b:	eb d0                	jmp    80053d <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80056d:	0f b6 d2             	movzbl %dl,%edx
  800570:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800573:	b8 00 00 00 00       	mov    $0x0,%eax
  800578:	89 75 08             	mov    %esi,0x8(%ebp)
  80057b:	eb 03                	jmp    800580 <vprintfmt+0x86>
  80057d:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800580:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800583:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800587:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80058a:	8d 72 d0             	lea    -0x30(%edx),%esi
  80058d:	83 fe 09             	cmp    $0x9,%esi
  800590:	76 eb                	jbe    80057d <vprintfmt+0x83>
  800592:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800595:	8b 75 08             	mov    0x8(%ebp),%esi
  800598:	eb 14                	jmp    8005ae <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  80059a:	8b 45 14             	mov    0x14(%ebp),%eax
  80059d:	8b 00                	mov    (%eax),%eax
  80059f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a5:	8d 40 04             	lea    0x4(%eax),%eax
  8005a8:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005ab:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8005ae:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005b2:	79 89                	jns    80053d <vprintfmt+0x43>
				width = precision, precision = -1;
  8005b4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005b7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005ba:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8005c1:	e9 77 ff ff ff       	jmp    80053d <vprintfmt+0x43>
  8005c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005c9:	85 c0                	test   %eax,%eax
  8005cb:	0f 48 c1             	cmovs  %ecx,%eax
  8005ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005d1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005d4:	e9 64 ff ff ff       	jmp    80053d <vprintfmt+0x43>
  8005d9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005dc:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8005e3:	e9 55 ff ff ff       	jmp    80053d <vprintfmt+0x43>
			lflag++;
  8005e8:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005ec:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005ef:	e9 49 ff ff ff       	jmp    80053d <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8005f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f7:	8d 78 04             	lea    0x4(%eax),%edi
  8005fa:	83 ec 08             	sub    $0x8,%esp
  8005fd:	53                   	push   %ebx
  8005fe:	ff 30                	pushl  (%eax)
  800600:	ff d6                	call   *%esi
			break;
  800602:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800605:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800608:	e9 33 03 00 00       	jmp    800940 <vprintfmt+0x446>
			err = va_arg(ap, int);
  80060d:	8b 45 14             	mov    0x14(%ebp),%eax
  800610:	8d 78 04             	lea    0x4(%eax),%edi
  800613:	8b 00                	mov    (%eax),%eax
  800615:	99                   	cltd   
  800616:	31 d0                	xor    %edx,%eax
  800618:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80061a:	83 f8 11             	cmp    $0x11,%eax
  80061d:	7f 23                	jg     800642 <vprintfmt+0x148>
  80061f:	8b 14 85 a0 2b 80 00 	mov    0x802ba0(,%eax,4),%edx
  800626:	85 d2                	test   %edx,%edx
  800628:	74 18                	je     800642 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80062a:	52                   	push   %edx
  80062b:	68 d1 2c 80 00       	push   $0x802cd1
  800630:	53                   	push   %ebx
  800631:	56                   	push   %esi
  800632:	e8 a6 fe ff ff       	call   8004dd <printfmt>
  800637:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80063a:	89 7d 14             	mov    %edi,0x14(%ebp)
  80063d:	e9 fe 02 00 00       	jmp    800940 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800642:	50                   	push   %eax
  800643:	68 73 28 80 00       	push   $0x802873
  800648:	53                   	push   %ebx
  800649:	56                   	push   %esi
  80064a:	e8 8e fe ff ff       	call   8004dd <printfmt>
  80064f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800652:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800655:	e9 e6 02 00 00       	jmp    800940 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  80065a:	8b 45 14             	mov    0x14(%ebp),%eax
  80065d:	83 c0 04             	add    $0x4,%eax
  800660:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800663:	8b 45 14             	mov    0x14(%ebp),%eax
  800666:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800668:	85 c9                	test   %ecx,%ecx
  80066a:	b8 6c 28 80 00       	mov    $0x80286c,%eax
  80066f:	0f 45 c1             	cmovne %ecx,%eax
  800672:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800675:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800679:	7e 06                	jle    800681 <vprintfmt+0x187>
  80067b:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80067f:	75 0d                	jne    80068e <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800681:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800684:	89 c7                	mov    %eax,%edi
  800686:	03 45 e0             	add    -0x20(%ebp),%eax
  800689:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80068c:	eb 53                	jmp    8006e1 <vprintfmt+0x1e7>
  80068e:	83 ec 08             	sub    $0x8,%esp
  800691:	ff 75 d8             	pushl  -0x28(%ebp)
  800694:	50                   	push   %eax
  800695:	e8 61 05 00 00       	call   800bfb <strnlen>
  80069a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80069d:	29 c1                	sub    %eax,%ecx
  80069f:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8006a2:	83 c4 10             	add    $0x10,%esp
  8006a5:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8006a7:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8006ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8006ae:	eb 0f                	jmp    8006bf <vprintfmt+0x1c5>
					putch(padc, putdat);
  8006b0:	83 ec 08             	sub    $0x8,%esp
  8006b3:	53                   	push   %ebx
  8006b4:	ff 75 e0             	pushl  -0x20(%ebp)
  8006b7:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006b9:	83 ef 01             	sub    $0x1,%edi
  8006bc:	83 c4 10             	add    $0x10,%esp
  8006bf:	85 ff                	test   %edi,%edi
  8006c1:	7f ed                	jg     8006b0 <vprintfmt+0x1b6>
  8006c3:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8006c6:	85 c9                	test   %ecx,%ecx
  8006c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8006cd:	0f 49 c1             	cmovns %ecx,%eax
  8006d0:	29 c1                	sub    %eax,%ecx
  8006d2:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8006d5:	eb aa                	jmp    800681 <vprintfmt+0x187>
					putch(ch, putdat);
  8006d7:	83 ec 08             	sub    $0x8,%esp
  8006da:	53                   	push   %ebx
  8006db:	52                   	push   %edx
  8006dc:	ff d6                	call   *%esi
  8006de:	83 c4 10             	add    $0x10,%esp
  8006e1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006e4:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006e6:	83 c7 01             	add    $0x1,%edi
  8006e9:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006ed:	0f be d0             	movsbl %al,%edx
  8006f0:	85 d2                	test   %edx,%edx
  8006f2:	74 4b                	je     80073f <vprintfmt+0x245>
  8006f4:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006f8:	78 06                	js     800700 <vprintfmt+0x206>
  8006fa:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8006fe:	78 1e                	js     80071e <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800700:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800704:	74 d1                	je     8006d7 <vprintfmt+0x1dd>
  800706:	0f be c0             	movsbl %al,%eax
  800709:	83 e8 20             	sub    $0x20,%eax
  80070c:	83 f8 5e             	cmp    $0x5e,%eax
  80070f:	76 c6                	jbe    8006d7 <vprintfmt+0x1dd>
					putch('?', putdat);
  800711:	83 ec 08             	sub    $0x8,%esp
  800714:	53                   	push   %ebx
  800715:	6a 3f                	push   $0x3f
  800717:	ff d6                	call   *%esi
  800719:	83 c4 10             	add    $0x10,%esp
  80071c:	eb c3                	jmp    8006e1 <vprintfmt+0x1e7>
  80071e:	89 cf                	mov    %ecx,%edi
  800720:	eb 0e                	jmp    800730 <vprintfmt+0x236>
				putch(' ', putdat);
  800722:	83 ec 08             	sub    $0x8,%esp
  800725:	53                   	push   %ebx
  800726:	6a 20                	push   $0x20
  800728:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80072a:	83 ef 01             	sub    $0x1,%edi
  80072d:	83 c4 10             	add    $0x10,%esp
  800730:	85 ff                	test   %edi,%edi
  800732:	7f ee                	jg     800722 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800734:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800737:	89 45 14             	mov    %eax,0x14(%ebp)
  80073a:	e9 01 02 00 00       	jmp    800940 <vprintfmt+0x446>
  80073f:	89 cf                	mov    %ecx,%edi
  800741:	eb ed                	jmp    800730 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800743:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800746:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  80074d:	e9 eb fd ff ff       	jmp    80053d <vprintfmt+0x43>
	if (lflag >= 2)
  800752:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800756:	7f 21                	jg     800779 <vprintfmt+0x27f>
	else if (lflag)
  800758:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80075c:	74 68                	je     8007c6 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80075e:	8b 45 14             	mov    0x14(%ebp),%eax
  800761:	8b 00                	mov    (%eax),%eax
  800763:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800766:	89 c1                	mov    %eax,%ecx
  800768:	c1 f9 1f             	sar    $0x1f,%ecx
  80076b:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80076e:	8b 45 14             	mov    0x14(%ebp),%eax
  800771:	8d 40 04             	lea    0x4(%eax),%eax
  800774:	89 45 14             	mov    %eax,0x14(%ebp)
  800777:	eb 17                	jmp    800790 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800779:	8b 45 14             	mov    0x14(%ebp),%eax
  80077c:	8b 50 04             	mov    0x4(%eax),%edx
  80077f:	8b 00                	mov    (%eax),%eax
  800781:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800784:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800787:	8b 45 14             	mov    0x14(%ebp),%eax
  80078a:	8d 40 08             	lea    0x8(%eax),%eax
  80078d:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800790:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800793:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800796:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800799:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80079c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8007a0:	78 3f                	js     8007e1 <vprintfmt+0x2e7>
			base = 10;
  8007a2:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8007a7:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8007ab:	0f 84 71 01 00 00    	je     800922 <vprintfmt+0x428>
				putch('+', putdat);
  8007b1:	83 ec 08             	sub    $0x8,%esp
  8007b4:	53                   	push   %ebx
  8007b5:	6a 2b                	push   $0x2b
  8007b7:	ff d6                	call   *%esi
  8007b9:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007bc:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007c1:	e9 5c 01 00 00       	jmp    800922 <vprintfmt+0x428>
		return va_arg(*ap, int);
  8007c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c9:	8b 00                	mov    (%eax),%eax
  8007cb:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8007ce:	89 c1                	mov    %eax,%ecx
  8007d0:	c1 f9 1f             	sar    $0x1f,%ecx
  8007d3:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8007d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d9:	8d 40 04             	lea    0x4(%eax),%eax
  8007dc:	89 45 14             	mov    %eax,0x14(%ebp)
  8007df:	eb af                	jmp    800790 <vprintfmt+0x296>
				putch('-', putdat);
  8007e1:	83 ec 08             	sub    $0x8,%esp
  8007e4:	53                   	push   %ebx
  8007e5:	6a 2d                	push   $0x2d
  8007e7:	ff d6                	call   *%esi
				num = -(long long) num;
  8007e9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007ec:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8007ef:	f7 d8                	neg    %eax
  8007f1:	83 d2 00             	adc    $0x0,%edx
  8007f4:	f7 da                	neg    %edx
  8007f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007fc:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007ff:	b8 0a 00 00 00       	mov    $0xa,%eax
  800804:	e9 19 01 00 00       	jmp    800922 <vprintfmt+0x428>
	if (lflag >= 2)
  800809:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80080d:	7f 29                	jg     800838 <vprintfmt+0x33e>
	else if (lflag)
  80080f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800813:	74 44                	je     800859 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800815:	8b 45 14             	mov    0x14(%ebp),%eax
  800818:	8b 00                	mov    (%eax),%eax
  80081a:	ba 00 00 00 00       	mov    $0x0,%edx
  80081f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800822:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800825:	8b 45 14             	mov    0x14(%ebp),%eax
  800828:	8d 40 04             	lea    0x4(%eax),%eax
  80082b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80082e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800833:	e9 ea 00 00 00       	jmp    800922 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800838:	8b 45 14             	mov    0x14(%ebp),%eax
  80083b:	8b 50 04             	mov    0x4(%eax),%edx
  80083e:	8b 00                	mov    (%eax),%eax
  800840:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800843:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800846:	8b 45 14             	mov    0x14(%ebp),%eax
  800849:	8d 40 08             	lea    0x8(%eax),%eax
  80084c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80084f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800854:	e9 c9 00 00 00       	jmp    800922 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800859:	8b 45 14             	mov    0x14(%ebp),%eax
  80085c:	8b 00                	mov    (%eax),%eax
  80085e:	ba 00 00 00 00       	mov    $0x0,%edx
  800863:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800866:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800869:	8b 45 14             	mov    0x14(%ebp),%eax
  80086c:	8d 40 04             	lea    0x4(%eax),%eax
  80086f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800872:	b8 0a 00 00 00       	mov    $0xa,%eax
  800877:	e9 a6 00 00 00       	jmp    800922 <vprintfmt+0x428>
			putch('0', putdat);
  80087c:	83 ec 08             	sub    $0x8,%esp
  80087f:	53                   	push   %ebx
  800880:	6a 30                	push   $0x30
  800882:	ff d6                	call   *%esi
	if (lflag >= 2)
  800884:	83 c4 10             	add    $0x10,%esp
  800887:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80088b:	7f 26                	jg     8008b3 <vprintfmt+0x3b9>
	else if (lflag)
  80088d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800891:	74 3e                	je     8008d1 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800893:	8b 45 14             	mov    0x14(%ebp),%eax
  800896:	8b 00                	mov    (%eax),%eax
  800898:	ba 00 00 00 00       	mov    $0x0,%edx
  80089d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008a0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a6:	8d 40 04             	lea    0x4(%eax),%eax
  8008a9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008ac:	b8 08 00 00 00       	mov    $0x8,%eax
  8008b1:	eb 6f                	jmp    800922 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8008b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b6:	8b 50 04             	mov    0x4(%eax),%edx
  8008b9:	8b 00                	mov    (%eax),%eax
  8008bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008be:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c4:	8d 40 08             	lea    0x8(%eax),%eax
  8008c7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008ca:	b8 08 00 00 00       	mov    $0x8,%eax
  8008cf:	eb 51                	jmp    800922 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8008d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d4:	8b 00                	mov    (%eax),%eax
  8008d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8008db:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008de:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e4:	8d 40 04             	lea    0x4(%eax),%eax
  8008e7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008ea:	b8 08 00 00 00       	mov    $0x8,%eax
  8008ef:	eb 31                	jmp    800922 <vprintfmt+0x428>
			putch('0', putdat);
  8008f1:	83 ec 08             	sub    $0x8,%esp
  8008f4:	53                   	push   %ebx
  8008f5:	6a 30                	push   $0x30
  8008f7:	ff d6                	call   *%esi
			putch('x', putdat);
  8008f9:	83 c4 08             	add    $0x8,%esp
  8008fc:	53                   	push   %ebx
  8008fd:	6a 78                	push   $0x78
  8008ff:	ff d6                	call   *%esi
			num = (unsigned long long)
  800901:	8b 45 14             	mov    0x14(%ebp),%eax
  800904:	8b 00                	mov    (%eax),%eax
  800906:	ba 00 00 00 00       	mov    $0x0,%edx
  80090b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80090e:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800911:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800914:	8b 45 14             	mov    0x14(%ebp),%eax
  800917:	8d 40 04             	lea    0x4(%eax),%eax
  80091a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80091d:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800922:	83 ec 0c             	sub    $0xc,%esp
  800925:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800929:	52                   	push   %edx
  80092a:	ff 75 e0             	pushl  -0x20(%ebp)
  80092d:	50                   	push   %eax
  80092e:	ff 75 dc             	pushl  -0x24(%ebp)
  800931:	ff 75 d8             	pushl  -0x28(%ebp)
  800934:	89 da                	mov    %ebx,%edx
  800936:	89 f0                	mov    %esi,%eax
  800938:	e8 a4 fa ff ff       	call   8003e1 <printnum>
			break;
  80093d:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800940:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800943:	83 c7 01             	add    $0x1,%edi
  800946:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80094a:	83 f8 25             	cmp    $0x25,%eax
  80094d:	0f 84 be fb ff ff    	je     800511 <vprintfmt+0x17>
			if (ch == '\0')
  800953:	85 c0                	test   %eax,%eax
  800955:	0f 84 28 01 00 00    	je     800a83 <vprintfmt+0x589>
			putch(ch, putdat);
  80095b:	83 ec 08             	sub    $0x8,%esp
  80095e:	53                   	push   %ebx
  80095f:	50                   	push   %eax
  800960:	ff d6                	call   *%esi
  800962:	83 c4 10             	add    $0x10,%esp
  800965:	eb dc                	jmp    800943 <vprintfmt+0x449>
	if (lflag >= 2)
  800967:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80096b:	7f 26                	jg     800993 <vprintfmt+0x499>
	else if (lflag)
  80096d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800971:	74 41                	je     8009b4 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800973:	8b 45 14             	mov    0x14(%ebp),%eax
  800976:	8b 00                	mov    (%eax),%eax
  800978:	ba 00 00 00 00       	mov    $0x0,%edx
  80097d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800980:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800983:	8b 45 14             	mov    0x14(%ebp),%eax
  800986:	8d 40 04             	lea    0x4(%eax),%eax
  800989:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80098c:	b8 10 00 00 00       	mov    $0x10,%eax
  800991:	eb 8f                	jmp    800922 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800993:	8b 45 14             	mov    0x14(%ebp),%eax
  800996:	8b 50 04             	mov    0x4(%eax),%edx
  800999:	8b 00                	mov    (%eax),%eax
  80099b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80099e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a4:	8d 40 08             	lea    0x8(%eax),%eax
  8009a7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009aa:	b8 10 00 00 00       	mov    $0x10,%eax
  8009af:	e9 6e ff ff ff       	jmp    800922 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8009b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b7:	8b 00                	mov    (%eax),%eax
  8009b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8009be:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009c1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c7:	8d 40 04             	lea    0x4(%eax),%eax
  8009ca:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009cd:	b8 10 00 00 00       	mov    $0x10,%eax
  8009d2:	e9 4b ff ff ff       	jmp    800922 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8009d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009da:	83 c0 04             	add    $0x4,%eax
  8009dd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e3:	8b 00                	mov    (%eax),%eax
  8009e5:	85 c0                	test   %eax,%eax
  8009e7:	74 14                	je     8009fd <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8009e9:	8b 13                	mov    (%ebx),%edx
  8009eb:	83 fa 7f             	cmp    $0x7f,%edx
  8009ee:	7f 37                	jg     800a27 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8009f0:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8009f2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009f5:	89 45 14             	mov    %eax,0x14(%ebp)
  8009f8:	e9 43 ff ff ff       	jmp    800940 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8009fd:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a02:	bf 91 29 80 00       	mov    $0x802991,%edi
							putch(ch, putdat);
  800a07:	83 ec 08             	sub    $0x8,%esp
  800a0a:	53                   	push   %ebx
  800a0b:	50                   	push   %eax
  800a0c:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800a0e:	83 c7 01             	add    $0x1,%edi
  800a11:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800a15:	83 c4 10             	add    $0x10,%esp
  800a18:	85 c0                	test   %eax,%eax
  800a1a:	75 eb                	jne    800a07 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800a1c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a1f:	89 45 14             	mov    %eax,0x14(%ebp)
  800a22:	e9 19 ff ff ff       	jmp    800940 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800a27:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800a29:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a2e:	bf c9 29 80 00       	mov    $0x8029c9,%edi
							putch(ch, putdat);
  800a33:	83 ec 08             	sub    $0x8,%esp
  800a36:	53                   	push   %ebx
  800a37:	50                   	push   %eax
  800a38:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800a3a:	83 c7 01             	add    $0x1,%edi
  800a3d:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800a41:	83 c4 10             	add    $0x10,%esp
  800a44:	85 c0                	test   %eax,%eax
  800a46:	75 eb                	jne    800a33 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800a48:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a4b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a4e:	e9 ed fe ff ff       	jmp    800940 <vprintfmt+0x446>
			putch(ch, putdat);
  800a53:	83 ec 08             	sub    $0x8,%esp
  800a56:	53                   	push   %ebx
  800a57:	6a 25                	push   $0x25
  800a59:	ff d6                	call   *%esi
			break;
  800a5b:	83 c4 10             	add    $0x10,%esp
  800a5e:	e9 dd fe ff ff       	jmp    800940 <vprintfmt+0x446>
			putch('%', putdat);
  800a63:	83 ec 08             	sub    $0x8,%esp
  800a66:	53                   	push   %ebx
  800a67:	6a 25                	push   $0x25
  800a69:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a6b:	83 c4 10             	add    $0x10,%esp
  800a6e:	89 f8                	mov    %edi,%eax
  800a70:	eb 03                	jmp    800a75 <vprintfmt+0x57b>
  800a72:	83 e8 01             	sub    $0x1,%eax
  800a75:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800a79:	75 f7                	jne    800a72 <vprintfmt+0x578>
  800a7b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a7e:	e9 bd fe ff ff       	jmp    800940 <vprintfmt+0x446>
}
  800a83:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a86:	5b                   	pop    %ebx
  800a87:	5e                   	pop    %esi
  800a88:	5f                   	pop    %edi
  800a89:	5d                   	pop    %ebp
  800a8a:	c3                   	ret    

00800a8b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a8b:	55                   	push   %ebp
  800a8c:	89 e5                	mov    %esp,%ebp
  800a8e:	83 ec 18             	sub    $0x18,%esp
  800a91:	8b 45 08             	mov    0x8(%ebp),%eax
  800a94:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a97:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a9a:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a9e:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800aa1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800aa8:	85 c0                	test   %eax,%eax
  800aaa:	74 26                	je     800ad2 <vsnprintf+0x47>
  800aac:	85 d2                	test   %edx,%edx
  800aae:	7e 22                	jle    800ad2 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ab0:	ff 75 14             	pushl  0x14(%ebp)
  800ab3:	ff 75 10             	pushl  0x10(%ebp)
  800ab6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ab9:	50                   	push   %eax
  800aba:	68 c0 04 80 00       	push   $0x8004c0
  800abf:	e8 36 fa ff ff       	call   8004fa <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800ac4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ac7:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800acd:	83 c4 10             	add    $0x10,%esp
}
  800ad0:	c9                   	leave  
  800ad1:	c3                   	ret    
		return -E_INVAL;
  800ad2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ad7:	eb f7                	jmp    800ad0 <vsnprintf+0x45>

00800ad9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ad9:	55                   	push   %ebp
  800ada:	89 e5                	mov    %esp,%ebp
  800adc:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800adf:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800ae2:	50                   	push   %eax
  800ae3:	ff 75 10             	pushl  0x10(%ebp)
  800ae6:	ff 75 0c             	pushl  0xc(%ebp)
  800ae9:	ff 75 08             	pushl  0x8(%ebp)
  800aec:	e8 9a ff ff ff       	call   800a8b <vsnprintf>
	va_end(ap);

	return rc;
}
  800af1:	c9                   	leave  
  800af2:	c3                   	ret    

00800af3 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  800af3:	55                   	push   %ebp
  800af4:	89 e5                	mov    %esp,%ebp
  800af6:	57                   	push   %edi
  800af7:	56                   	push   %esi
  800af8:	53                   	push   %ebx
  800af9:	83 ec 0c             	sub    $0xc,%esp
  800afc:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  800aff:	85 c0                	test   %eax,%eax
  800b01:	74 13                	je     800b16 <readline+0x23>
		fprintf(1, "%s", prompt);
  800b03:	83 ec 04             	sub    $0x4,%esp
  800b06:	50                   	push   %eax
  800b07:	68 d1 2c 80 00       	push   $0x802cd1
  800b0c:	6a 01                	push   $0x1
  800b0e:	e8 03 11 00 00       	call   801c16 <fprintf>
  800b13:	83 c4 10             	add    $0x10,%esp
#endif

	i = 0;
	echoing = iscons(0);
  800b16:	83 ec 0c             	sub    $0xc,%esp
  800b19:	6a 00                	push   $0x0
  800b1b:	e8 bc f6 ff ff       	call   8001dc <iscons>
  800b20:	89 c7                	mov    %eax,%edi
  800b22:	83 c4 10             	add    $0x10,%esp
	i = 0;
  800b25:	be 00 00 00 00       	mov    $0x0,%esi
  800b2a:	eb 57                	jmp    800b83 <readline+0x90>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
  800b2c:	b8 00 00 00 00       	mov    $0x0,%eax
			if (c != -E_EOF)
  800b31:	83 fb f8             	cmp    $0xfffffff8,%ebx
  800b34:	75 08                	jne    800b3e <readline+0x4b>
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
  800b36:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b39:	5b                   	pop    %ebx
  800b3a:	5e                   	pop    %esi
  800b3b:	5f                   	pop    %edi
  800b3c:	5d                   	pop    %ebp
  800b3d:	c3                   	ret    
				cprintf("read error: %e\n", c);
  800b3e:	83 ec 08             	sub    $0x8,%esp
  800b41:	53                   	push   %ebx
  800b42:	68 e8 2b 80 00       	push   $0x802be8
  800b47:	e8 81 f8 ff ff       	call   8003cd <cprintf>
  800b4c:	83 c4 10             	add    $0x10,%esp
			return NULL;
  800b4f:	b8 00 00 00 00       	mov    $0x0,%eax
  800b54:	eb e0                	jmp    800b36 <readline+0x43>
			if (echoing)
  800b56:	85 ff                	test   %edi,%edi
  800b58:	75 05                	jne    800b5f <readline+0x6c>
			i--;
  800b5a:	83 ee 01             	sub    $0x1,%esi
  800b5d:	eb 24                	jmp    800b83 <readline+0x90>
				cputchar('\b');
  800b5f:	83 ec 0c             	sub    $0xc,%esp
  800b62:	6a 08                	push   $0x8
  800b64:	e8 2e f6 ff ff       	call   800197 <cputchar>
  800b69:	83 c4 10             	add    $0x10,%esp
  800b6c:	eb ec                	jmp    800b5a <readline+0x67>
				cputchar(c);
  800b6e:	83 ec 0c             	sub    $0xc,%esp
  800b71:	53                   	push   %ebx
  800b72:	e8 20 f6 ff ff       	call   800197 <cputchar>
  800b77:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800b7a:	88 9e 00 40 80 00    	mov    %bl,0x804000(%esi)
  800b80:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
  800b83:	e8 2b f6 ff ff       	call   8001b3 <getchar>
  800b88:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  800b8a:	85 c0                	test   %eax,%eax
  800b8c:	78 9e                	js     800b2c <readline+0x39>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  800b8e:	83 f8 08             	cmp    $0x8,%eax
  800b91:	0f 94 c2             	sete   %dl
  800b94:	83 f8 7f             	cmp    $0x7f,%eax
  800b97:	0f 94 c0             	sete   %al
  800b9a:	08 c2                	or     %al,%dl
  800b9c:	74 04                	je     800ba2 <readline+0xaf>
  800b9e:	85 f6                	test   %esi,%esi
  800ba0:	7f b4                	jg     800b56 <readline+0x63>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800ba2:	83 fb 1f             	cmp    $0x1f,%ebx
  800ba5:	7e 0e                	jle    800bb5 <readline+0xc2>
  800ba7:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  800bad:	7f 06                	jg     800bb5 <readline+0xc2>
			if (echoing)
  800baf:	85 ff                	test   %edi,%edi
  800bb1:	74 c7                	je     800b7a <readline+0x87>
  800bb3:	eb b9                	jmp    800b6e <readline+0x7b>
		} else if (c == '\n' || c == '\r') {
  800bb5:	83 fb 0a             	cmp    $0xa,%ebx
  800bb8:	74 05                	je     800bbf <readline+0xcc>
  800bba:	83 fb 0d             	cmp    $0xd,%ebx
  800bbd:	75 c4                	jne    800b83 <readline+0x90>
			if (echoing)
  800bbf:	85 ff                	test   %edi,%edi
  800bc1:	75 11                	jne    800bd4 <readline+0xe1>
			buf[i] = 0;
  800bc3:	c6 86 00 40 80 00 00 	movb   $0x0,0x804000(%esi)
			return buf;
  800bca:	b8 00 40 80 00       	mov    $0x804000,%eax
  800bcf:	e9 62 ff ff ff       	jmp    800b36 <readline+0x43>
				cputchar('\n');
  800bd4:	83 ec 0c             	sub    $0xc,%esp
  800bd7:	6a 0a                	push   $0xa
  800bd9:	e8 b9 f5 ff ff       	call   800197 <cputchar>
  800bde:	83 c4 10             	add    $0x10,%esp
  800be1:	eb e0                	jmp    800bc3 <readline+0xd0>

00800be3 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800be3:	55                   	push   %ebp
  800be4:	89 e5                	mov    %esp,%ebp
  800be6:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800be9:	b8 00 00 00 00       	mov    $0x0,%eax
  800bee:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800bf2:	74 05                	je     800bf9 <strlen+0x16>
		n++;
  800bf4:	83 c0 01             	add    $0x1,%eax
  800bf7:	eb f5                	jmp    800bee <strlen+0xb>
	return n;
}
  800bf9:	5d                   	pop    %ebp
  800bfa:	c3                   	ret    

00800bfb <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800bfb:	55                   	push   %ebp
  800bfc:	89 e5                	mov    %esp,%ebp
  800bfe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c01:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c04:	ba 00 00 00 00       	mov    $0x0,%edx
  800c09:	39 c2                	cmp    %eax,%edx
  800c0b:	74 0d                	je     800c1a <strnlen+0x1f>
  800c0d:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800c11:	74 05                	je     800c18 <strnlen+0x1d>
		n++;
  800c13:	83 c2 01             	add    $0x1,%edx
  800c16:	eb f1                	jmp    800c09 <strnlen+0xe>
  800c18:	89 d0                	mov    %edx,%eax
	return n;
}
  800c1a:	5d                   	pop    %ebp
  800c1b:	c3                   	ret    

00800c1c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c1c:	55                   	push   %ebp
  800c1d:	89 e5                	mov    %esp,%ebp
  800c1f:	53                   	push   %ebx
  800c20:	8b 45 08             	mov    0x8(%ebp),%eax
  800c23:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800c26:	ba 00 00 00 00       	mov    $0x0,%edx
  800c2b:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800c2f:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800c32:	83 c2 01             	add    $0x1,%edx
  800c35:	84 c9                	test   %cl,%cl
  800c37:	75 f2                	jne    800c2b <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800c39:	5b                   	pop    %ebx
  800c3a:	5d                   	pop    %ebp
  800c3b:	c3                   	ret    

00800c3c <strcat>:

char *
strcat(char *dst, const char *src)
{
  800c3c:	55                   	push   %ebp
  800c3d:	89 e5                	mov    %esp,%ebp
  800c3f:	53                   	push   %ebx
  800c40:	83 ec 10             	sub    $0x10,%esp
  800c43:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800c46:	53                   	push   %ebx
  800c47:	e8 97 ff ff ff       	call   800be3 <strlen>
  800c4c:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800c4f:	ff 75 0c             	pushl  0xc(%ebp)
  800c52:	01 d8                	add    %ebx,%eax
  800c54:	50                   	push   %eax
  800c55:	e8 c2 ff ff ff       	call   800c1c <strcpy>
	return dst;
}
  800c5a:	89 d8                	mov    %ebx,%eax
  800c5c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c5f:	c9                   	leave  
  800c60:	c3                   	ret    

00800c61 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c61:	55                   	push   %ebp
  800c62:	89 e5                	mov    %esp,%ebp
  800c64:	56                   	push   %esi
  800c65:	53                   	push   %ebx
  800c66:	8b 45 08             	mov    0x8(%ebp),%eax
  800c69:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c6c:	89 c6                	mov    %eax,%esi
  800c6e:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c71:	89 c2                	mov    %eax,%edx
  800c73:	39 f2                	cmp    %esi,%edx
  800c75:	74 11                	je     800c88 <strncpy+0x27>
		*dst++ = *src;
  800c77:	83 c2 01             	add    $0x1,%edx
  800c7a:	0f b6 19             	movzbl (%ecx),%ebx
  800c7d:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c80:	80 fb 01             	cmp    $0x1,%bl
  800c83:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800c86:	eb eb                	jmp    800c73 <strncpy+0x12>
	}
	return ret;
}
  800c88:	5b                   	pop    %ebx
  800c89:	5e                   	pop    %esi
  800c8a:	5d                   	pop    %ebp
  800c8b:	c3                   	ret    

00800c8c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c8c:	55                   	push   %ebp
  800c8d:	89 e5                	mov    %esp,%ebp
  800c8f:	56                   	push   %esi
  800c90:	53                   	push   %ebx
  800c91:	8b 75 08             	mov    0x8(%ebp),%esi
  800c94:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c97:	8b 55 10             	mov    0x10(%ebp),%edx
  800c9a:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c9c:	85 d2                	test   %edx,%edx
  800c9e:	74 21                	je     800cc1 <strlcpy+0x35>
  800ca0:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800ca4:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800ca6:	39 c2                	cmp    %eax,%edx
  800ca8:	74 14                	je     800cbe <strlcpy+0x32>
  800caa:	0f b6 19             	movzbl (%ecx),%ebx
  800cad:	84 db                	test   %bl,%bl
  800caf:	74 0b                	je     800cbc <strlcpy+0x30>
			*dst++ = *src++;
  800cb1:	83 c1 01             	add    $0x1,%ecx
  800cb4:	83 c2 01             	add    $0x1,%edx
  800cb7:	88 5a ff             	mov    %bl,-0x1(%edx)
  800cba:	eb ea                	jmp    800ca6 <strlcpy+0x1a>
  800cbc:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800cbe:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cc1:	29 f0                	sub    %esi,%eax
}
  800cc3:	5b                   	pop    %ebx
  800cc4:	5e                   	pop    %esi
  800cc5:	5d                   	pop    %ebp
  800cc6:	c3                   	ret    

00800cc7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cc7:	55                   	push   %ebp
  800cc8:	89 e5                	mov    %esp,%ebp
  800cca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ccd:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800cd0:	0f b6 01             	movzbl (%ecx),%eax
  800cd3:	84 c0                	test   %al,%al
  800cd5:	74 0c                	je     800ce3 <strcmp+0x1c>
  800cd7:	3a 02                	cmp    (%edx),%al
  800cd9:	75 08                	jne    800ce3 <strcmp+0x1c>
		p++, q++;
  800cdb:	83 c1 01             	add    $0x1,%ecx
  800cde:	83 c2 01             	add    $0x1,%edx
  800ce1:	eb ed                	jmp    800cd0 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ce3:	0f b6 c0             	movzbl %al,%eax
  800ce6:	0f b6 12             	movzbl (%edx),%edx
  800ce9:	29 d0                	sub    %edx,%eax
}
  800ceb:	5d                   	pop    %ebp
  800cec:	c3                   	ret    

00800ced <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ced:	55                   	push   %ebp
  800cee:	89 e5                	mov    %esp,%ebp
  800cf0:	53                   	push   %ebx
  800cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cf7:	89 c3                	mov    %eax,%ebx
  800cf9:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800cfc:	eb 06                	jmp    800d04 <strncmp+0x17>
		n--, p++, q++;
  800cfe:	83 c0 01             	add    $0x1,%eax
  800d01:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800d04:	39 d8                	cmp    %ebx,%eax
  800d06:	74 16                	je     800d1e <strncmp+0x31>
  800d08:	0f b6 08             	movzbl (%eax),%ecx
  800d0b:	84 c9                	test   %cl,%cl
  800d0d:	74 04                	je     800d13 <strncmp+0x26>
  800d0f:	3a 0a                	cmp    (%edx),%cl
  800d11:	74 eb                	je     800cfe <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d13:	0f b6 00             	movzbl (%eax),%eax
  800d16:	0f b6 12             	movzbl (%edx),%edx
  800d19:	29 d0                	sub    %edx,%eax
}
  800d1b:	5b                   	pop    %ebx
  800d1c:	5d                   	pop    %ebp
  800d1d:	c3                   	ret    
		return 0;
  800d1e:	b8 00 00 00 00       	mov    $0x0,%eax
  800d23:	eb f6                	jmp    800d1b <strncmp+0x2e>

00800d25 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d25:	55                   	push   %ebp
  800d26:	89 e5                	mov    %esp,%ebp
  800d28:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d2f:	0f b6 10             	movzbl (%eax),%edx
  800d32:	84 d2                	test   %dl,%dl
  800d34:	74 09                	je     800d3f <strchr+0x1a>
		if (*s == c)
  800d36:	38 ca                	cmp    %cl,%dl
  800d38:	74 0a                	je     800d44 <strchr+0x1f>
	for (; *s; s++)
  800d3a:	83 c0 01             	add    $0x1,%eax
  800d3d:	eb f0                	jmp    800d2f <strchr+0xa>
			return (char *) s;
	return 0;
  800d3f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d44:	5d                   	pop    %ebp
  800d45:	c3                   	ret    

00800d46 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d46:	55                   	push   %ebp
  800d47:	89 e5                	mov    %esp,%ebp
  800d49:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d50:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800d53:	38 ca                	cmp    %cl,%dl
  800d55:	74 09                	je     800d60 <strfind+0x1a>
  800d57:	84 d2                	test   %dl,%dl
  800d59:	74 05                	je     800d60 <strfind+0x1a>
	for (; *s; s++)
  800d5b:	83 c0 01             	add    $0x1,%eax
  800d5e:	eb f0                	jmp    800d50 <strfind+0xa>
			break;
	return (char *) s;
}
  800d60:	5d                   	pop    %ebp
  800d61:	c3                   	ret    

00800d62 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d62:	55                   	push   %ebp
  800d63:	89 e5                	mov    %esp,%ebp
  800d65:	57                   	push   %edi
  800d66:	56                   	push   %esi
  800d67:	53                   	push   %ebx
  800d68:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d6b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d6e:	85 c9                	test   %ecx,%ecx
  800d70:	74 31                	je     800da3 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d72:	89 f8                	mov    %edi,%eax
  800d74:	09 c8                	or     %ecx,%eax
  800d76:	a8 03                	test   $0x3,%al
  800d78:	75 23                	jne    800d9d <memset+0x3b>
		c &= 0xFF;
  800d7a:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d7e:	89 d3                	mov    %edx,%ebx
  800d80:	c1 e3 08             	shl    $0x8,%ebx
  800d83:	89 d0                	mov    %edx,%eax
  800d85:	c1 e0 18             	shl    $0x18,%eax
  800d88:	89 d6                	mov    %edx,%esi
  800d8a:	c1 e6 10             	shl    $0x10,%esi
  800d8d:	09 f0                	or     %esi,%eax
  800d8f:	09 c2                	or     %eax,%edx
  800d91:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d93:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800d96:	89 d0                	mov    %edx,%eax
  800d98:	fc                   	cld    
  800d99:	f3 ab                	rep stos %eax,%es:(%edi)
  800d9b:	eb 06                	jmp    800da3 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da0:	fc                   	cld    
  800da1:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800da3:	89 f8                	mov    %edi,%eax
  800da5:	5b                   	pop    %ebx
  800da6:	5e                   	pop    %esi
  800da7:	5f                   	pop    %edi
  800da8:	5d                   	pop    %ebp
  800da9:	c3                   	ret    

00800daa <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	57                   	push   %edi
  800dae:	56                   	push   %esi
  800daf:	8b 45 08             	mov    0x8(%ebp),%eax
  800db2:	8b 75 0c             	mov    0xc(%ebp),%esi
  800db5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800db8:	39 c6                	cmp    %eax,%esi
  800dba:	73 32                	jae    800dee <memmove+0x44>
  800dbc:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800dbf:	39 c2                	cmp    %eax,%edx
  800dc1:	76 2b                	jbe    800dee <memmove+0x44>
		s += n;
		d += n;
  800dc3:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800dc6:	89 fe                	mov    %edi,%esi
  800dc8:	09 ce                	or     %ecx,%esi
  800dca:	09 d6                	or     %edx,%esi
  800dcc:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800dd2:	75 0e                	jne    800de2 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800dd4:	83 ef 04             	sub    $0x4,%edi
  800dd7:	8d 72 fc             	lea    -0x4(%edx),%esi
  800dda:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ddd:	fd                   	std    
  800dde:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800de0:	eb 09                	jmp    800deb <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800de2:	83 ef 01             	sub    $0x1,%edi
  800de5:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800de8:	fd                   	std    
  800de9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800deb:	fc                   	cld    
  800dec:	eb 1a                	jmp    800e08 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800dee:	89 c2                	mov    %eax,%edx
  800df0:	09 ca                	or     %ecx,%edx
  800df2:	09 f2                	or     %esi,%edx
  800df4:	f6 c2 03             	test   $0x3,%dl
  800df7:	75 0a                	jne    800e03 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800df9:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800dfc:	89 c7                	mov    %eax,%edi
  800dfe:	fc                   	cld    
  800dff:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e01:	eb 05                	jmp    800e08 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800e03:	89 c7                	mov    %eax,%edi
  800e05:	fc                   	cld    
  800e06:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800e08:	5e                   	pop    %esi
  800e09:	5f                   	pop    %edi
  800e0a:	5d                   	pop    %ebp
  800e0b:	c3                   	ret    

00800e0c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e0c:	55                   	push   %ebp
  800e0d:	89 e5                	mov    %esp,%ebp
  800e0f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800e12:	ff 75 10             	pushl  0x10(%ebp)
  800e15:	ff 75 0c             	pushl  0xc(%ebp)
  800e18:	ff 75 08             	pushl  0x8(%ebp)
  800e1b:	e8 8a ff ff ff       	call   800daa <memmove>
}
  800e20:	c9                   	leave  
  800e21:	c3                   	ret    

00800e22 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e22:	55                   	push   %ebp
  800e23:	89 e5                	mov    %esp,%ebp
  800e25:	56                   	push   %esi
  800e26:	53                   	push   %ebx
  800e27:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e2d:	89 c6                	mov    %eax,%esi
  800e2f:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e32:	39 f0                	cmp    %esi,%eax
  800e34:	74 1c                	je     800e52 <memcmp+0x30>
		if (*s1 != *s2)
  800e36:	0f b6 08             	movzbl (%eax),%ecx
  800e39:	0f b6 1a             	movzbl (%edx),%ebx
  800e3c:	38 d9                	cmp    %bl,%cl
  800e3e:	75 08                	jne    800e48 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800e40:	83 c0 01             	add    $0x1,%eax
  800e43:	83 c2 01             	add    $0x1,%edx
  800e46:	eb ea                	jmp    800e32 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800e48:	0f b6 c1             	movzbl %cl,%eax
  800e4b:	0f b6 db             	movzbl %bl,%ebx
  800e4e:	29 d8                	sub    %ebx,%eax
  800e50:	eb 05                	jmp    800e57 <memcmp+0x35>
	}

	return 0;
  800e52:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e57:	5b                   	pop    %ebx
  800e58:	5e                   	pop    %esi
  800e59:	5d                   	pop    %ebp
  800e5a:	c3                   	ret    

00800e5b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e5b:	55                   	push   %ebp
  800e5c:	89 e5                	mov    %esp,%ebp
  800e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e61:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800e64:	89 c2                	mov    %eax,%edx
  800e66:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e69:	39 d0                	cmp    %edx,%eax
  800e6b:	73 09                	jae    800e76 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e6d:	38 08                	cmp    %cl,(%eax)
  800e6f:	74 05                	je     800e76 <memfind+0x1b>
	for (; s < ends; s++)
  800e71:	83 c0 01             	add    $0x1,%eax
  800e74:	eb f3                	jmp    800e69 <memfind+0xe>
			break;
	return (void *) s;
}
  800e76:	5d                   	pop    %ebp
  800e77:	c3                   	ret    

00800e78 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e78:	55                   	push   %ebp
  800e79:	89 e5                	mov    %esp,%ebp
  800e7b:	57                   	push   %edi
  800e7c:	56                   	push   %esi
  800e7d:	53                   	push   %ebx
  800e7e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e81:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e84:	eb 03                	jmp    800e89 <strtol+0x11>
		s++;
  800e86:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800e89:	0f b6 01             	movzbl (%ecx),%eax
  800e8c:	3c 20                	cmp    $0x20,%al
  800e8e:	74 f6                	je     800e86 <strtol+0xe>
  800e90:	3c 09                	cmp    $0x9,%al
  800e92:	74 f2                	je     800e86 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800e94:	3c 2b                	cmp    $0x2b,%al
  800e96:	74 2a                	je     800ec2 <strtol+0x4a>
	int neg = 0;
  800e98:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800e9d:	3c 2d                	cmp    $0x2d,%al
  800e9f:	74 2b                	je     800ecc <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ea1:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ea7:	75 0f                	jne    800eb8 <strtol+0x40>
  800ea9:	80 39 30             	cmpb   $0x30,(%ecx)
  800eac:	74 28                	je     800ed6 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800eae:	85 db                	test   %ebx,%ebx
  800eb0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800eb5:	0f 44 d8             	cmove  %eax,%ebx
  800eb8:	b8 00 00 00 00       	mov    $0x0,%eax
  800ebd:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ec0:	eb 50                	jmp    800f12 <strtol+0x9a>
		s++;
  800ec2:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ec5:	bf 00 00 00 00       	mov    $0x0,%edi
  800eca:	eb d5                	jmp    800ea1 <strtol+0x29>
		s++, neg = 1;
  800ecc:	83 c1 01             	add    $0x1,%ecx
  800ecf:	bf 01 00 00 00       	mov    $0x1,%edi
  800ed4:	eb cb                	jmp    800ea1 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ed6:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800eda:	74 0e                	je     800eea <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800edc:	85 db                	test   %ebx,%ebx
  800ede:	75 d8                	jne    800eb8 <strtol+0x40>
		s++, base = 8;
  800ee0:	83 c1 01             	add    $0x1,%ecx
  800ee3:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ee8:	eb ce                	jmp    800eb8 <strtol+0x40>
		s += 2, base = 16;
  800eea:	83 c1 02             	add    $0x2,%ecx
  800eed:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ef2:	eb c4                	jmp    800eb8 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800ef4:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ef7:	89 f3                	mov    %esi,%ebx
  800ef9:	80 fb 19             	cmp    $0x19,%bl
  800efc:	77 29                	ja     800f27 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800efe:	0f be d2             	movsbl %dl,%edx
  800f01:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800f04:	3b 55 10             	cmp    0x10(%ebp),%edx
  800f07:	7d 30                	jge    800f39 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800f09:	83 c1 01             	add    $0x1,%ecx
  800f0c:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f10:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800f12:	0f b6 11             	movzbl (%ecx),%edx
  800f15:	8d 72 d0             	lea    -0x30(%edx),%esi
  800f18:	89 f3                	mov    %esi,%ebx
  800f1a:	80 fb 09             	cmp    $0x9,%bl
  800f1d:	77 d5                	ja     800ef4 <strtol+0x7c>
			dig = *s - '0';
  800f1f:	0f be d2             	movsbl %dl,%edx
  800f22:	83 ea 30             	sub    $0x30,%edx
  800f25:	eb dd                	jmp    800f04 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800f27:	8d 72 bf             	lea    -0x41(%edx),%esi
  800f2a:	89 f3                	mov    %esi,%ebx
  800f2c:	80 fb 19             	cmp    $0x19,%bl
  800f2f:	77 08                	ja     800f39 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800f31:	0f be d2             	movsbl %dl,%edx
  800f34:	83 ea 37             	sub    $0x37,%edx
  800f37:	eb cb                	jmp    800f04 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800f39:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f3d:	74 05                	je     800f44 <strtol+0xcc>
		*endptr = (char *) s;
  800f3f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f42:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800f44:	89 c2                	mov    %eax,%edx
  800f46:	f7 da                	neg    %edx
  800f48:	85 ff                	test   %edi,%edi
  800f4a:	0f 45 c2             	cmovne %edx,%eax
}
  800f4d:	5b                   	pop    %ebx
  800f4e:	5e                   	pop    %esi
  800f4f:	5f                   	pop    %edi
  800f50:	5d                   	pop    %ebp
  800f51:	c3                   	ret    

00800f52 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800f52:	55                   	push   %ebp
  800f53:	89 e5                	mov    %esp,%ebp
  800f55:	57                   	push   %edi
  800f56:	56                   	push   %esi
  800f57:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f58:	b8 00 00 00 00       	mov    $0x0,%eax
  800f5d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f60:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f63:	89 c3                	mov    %eax,%ebx
  800f65:	89 c7                	mov    %eax,%edi
  800f67:	89 c6                	mov    %eax,%esi
  800f69:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800f6b:	5b                   	pop    %ebx
  800f6c:	5e                   	pop    %esi
  800f6d:	5f                   	pop    %edi
  800f6e:	5d                   	pop    %ebp
  800f6f:	c3                   	ret    

00800f70 <sys_cgetc>:

int
sys_cgetc(void)
{
  800f70:	55                   	push   %ebp
  800f71:	89 e5                	mov    %esp,%ebp
  800f73:	57                   	push   %edi
  800f74:	56                   	push   %esi
  800f75:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f76:	ba 00 00 00 00       	mov    $0x0,%edx
  800f7b:	b8 01 00 00 00       	mov    $0x1,%eax
  800f80:	89 d1                	mov    %edx,%ecx
  800f82:	89 d3                	mov    %edx,%ebx
  800f84:	89 d7                	mov    %edx,%edi
  800f86:	89 d6                	mov    %edx,%esi
  800f88:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800f8a:	5b                   	pop    %ebx
  800f8b:	5e                   	pop    %esi
  800f8c:	5f                   	pop    %edi
  800f8d:	5d                   	pop    %ebp
  800f8e:	c3                   	ret    

00800f8f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800f8f:	55                   	push   %ebp
  800f90:	89 e5                	mov    %esp,%ebp
  800f92:	57                   	push   %edi
  800f93:	56                   	push   %esi
  800f94:	53                   	push   %ebx
  800f95:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f98:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f9d:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa0:	b8 03 00 00 00       	mov    $0x3,%eax
  800fa5:	89 cb                	mov    %ecx,%ebx
  800fa7:	89 cf                	mov    %ecx,%edi
  800fa9:	89 ce                	mov    %ecx,%esi
  800fab:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fad:	85 c0                	test   %eax,%eax
  800faf:	7f 08                	jg     800fb9 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800fb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fb4:	5b                   	pop    %ebx
  800fb5:	5e                   	pop    %esi
  800fb6:	5f                   	pop    %edi
  800fb7:	5d                   	pop    %ebp
  800fb8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fb9:	83 ec 0c             	sub    $0xc,%esp
  800fbc:	50                   	push   %eax
  800fbd:	6a 03                	push   $0x3
  800fbf:	68 f8 2b 80 00       	push   $0x802bf8
  800fc4:	6a 43                	push   $0x43
  800fc6:	68 15 2c 80 00       	push   $0x802c15
  800fcb:	e8 07 f3 ff ff       	call   8002d7 <_panic>

00800fd0 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800fd0:	55                   	push   %ebp
  800fd1:	89 e5                	mov    %esp,%ebp
  800fd3:	57                   	push   %edi
  800fd4:	56                   	push   %esi
  800fd5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fd6:	ba 00 00 00 00       	mov    $0x0,%edx
  800fdb:	b8 02 00 00 00       	mov    $0x2,%eax
  800fe0:	89 d1                	mov    %edx,%ecx
  800fe2:	89 d3                	mov    %edx,%ebx
  800fe4:	89 d7                	mov    %edx,%edi
  800fe6:	89 d6                	mov    %edx,%esi
  800fe8:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800fea:	5b                   	pop    %ebx
  800feb:	5e                   	pop    %esi
  800fec:	5f                   	pop    %edi
  800fed:	5d                   	pop    %ebp
  800fee:	c3                   	ret    

00800fef <sys_yield>:

void
sys_yield(void)
{
  800fef:	55                   	push   %ebp
  800ff0:	89 e5                	mov    %esp,%ebp
  800ff2:	57                   	push   %edi
  800ff3:	56                   	push   %esi
  800ff4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ff5:	ba 00 00 00 00       	mov    $0x0,%edx
  800ffa:	b8 0b 00 00 00       	mov    $0xb,%eax
  800fff:	89 d1                	mov    %edx,%ecx
  801001:	89 d3                	mov    %edx,%ebx
  801003:	89 d7                	mov    %edx,%edi
  801005:	89 d6                	mov    %edx,%esi
  801007:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801009:	5b                   	pop    %ebx
  80100a:	5e                   	pop    %esi
  80100b:	5f                   	pop    %edi
  80100c:	5d                   	pop    %ebp
  80100d:	c3                   	ret    

0080100e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80100e:	55                   	push   %ebp
  80100f:	89 e5                	mov    %esp,%ebp
  801011:	57                   	push   %edi
  801012:	56                   	push   %esi
  801013:	53                   	push   %ebx
  801014:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801017:	be 00 00 00 00       	mov    $0x0,%esi
  80101c:	8b 55 08             	mov    0x8(%ebp),%edx
  80101f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801022:	b8 04 00 00 00       	mov    $0x4,%eax
  801027:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80102a:	89 f7                	mov    %esi,%edi
  80102c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80102e:	85 c0                	test   %eax,%eax
  801030:	7f 08                	jg     80103a <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
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
  80103e:	6a 04                	push   $0x4
  801040:	68 f8 2b 80 00       	push   $0x802bf8
  801045:	6a 43                	push   $0x43
  801047:	68 15 2c 80 00       	push   $0x802c15
  80104c:	e8 86 f2 ff ff       	call   8002d7 <_panic>

00801051 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801051:	55                   	push   %ebp
  801052:	89 e5                	mov    %esp,%ebp
  801054:	57                   	push   %edi
  801055:	56                   	push   %esi
  801056:	53                   	push   %ebx
  801057:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80105a:	8b 55 08             	mov    0x8(%ebp),%edx
  80105d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801060:	b8 05 00 00 00       	mov    $0x5,%eax
  801065:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801068:	8b 7d 14             	mov    0x14(%ebp),%edi
  80106b:	8b 75 18             	mov    0x18(%ebp),%esi
  80106e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801070:	85 c0                	test   %eax,%eax
  801072:	7f 08                	jg     80107c <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
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
  801080:	6a 05                	push   $0x5
  801082:	68 f8 2b 80 00       	push   $0x802bf8
  801087:	6a 43                	push   $0x43
  801089:	68 15 2c 80 00       	push   $0x802c15
  80108e:	e8 44 f2 ff ff       	call   8002d7 <_panic>

00801093 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
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
  8010a7:	b8 06 00 00 00       	mov    $0x6,%eax
  8010ac:	89 df                	mov    %ebx,%edi
  8010ae:	89 de                	mov    %ebx,%esi
  8010b0:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010b2:	85 c0                	test   %eax,%eax
  8010b4:	7f 08                	jg     8010be <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
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
  8010c2:	6a 06                	push   $0x6
  8010c4:	68 f8 2b 80 00       	push   $0x802bf8
  8010c9:	6a 43                	push   $0x43
  8010cb:	68 15 2c 80 00       	push   $0x802c15
  8010d0:	e8 02 f2 ff ff       	call   8002d7 <_panic>

008010d5 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
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
  8010e9:	b8 08 00 00 00       	mov    $0x8,%eax
  8010ee:	89 df                	mov    %ebx,%edi
  8010f0:	89 de                	mov    %ebx,%esi
  8010f2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010f4:	85 c0                	test   %eax,%eax
  8010f6:	7f 08                	jg     801100 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
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
  801104:	6a 08                	push   $0x8
  801106:	68 f8 2b 80 00       	push   $0x802bf8
  80110b:	6a 43                	push   $0x43
  80110d:	68 15 2c 80 00       	push   $0x802c15
  801112:	e8 c0 f1 ff ff       	call   8002d7 <_panic>

00801117 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801117:	55                   	push   %ebp
  801118:	89 e5                	mov    %esp,%ebp
  80111a:	57                   	push   %edi
  80111b:	56                   	push   %esi
  80111c:	53                   	push   %ebx
  80111d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801120:	bb 00 00 00 00       	mov    $0x0,%ebx
  801125:	8b 55 08             	mov    0x8(%ebp),%edx
  801128:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80112b:	b8 09 00 00 00       	mov    $0x9,%eax
  801130:	89 df                	mov    %ebx,%edi
  801132:	89 de                	mov    %ebx,%esi
  801134:	cd 30                	int    $0x30
	if(check && ret > 0)
  801136:	85 c0                	test   %eax,%eax
  801138:	7f 08                	jg     801142 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80113a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80113d:	5b                   	pop    %ebx
  80113e:	5e                   	pop    %esi
  80113f:	5f                   	pop    %edi
  801140:	5d                   	pop    %ebp
  801141:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801142:	83 ec 0c             	sub    $0xc,%esp
  801145:	50                   	push   %eax
  801146:	6a 09                	push   $0x9
  801148:	68 f8 2b 80 00       	push   $0x802bf8
  80114d:	6a 43                	push   $0x43
  80114f:	68 15 2c 80 00       	push   $0x802c15
  801154:	e8 7e f1 ff ff       	call   8002d7 <_panic>

00801159 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801159:	55                   	push   %ebp
  80115a:	89 e5                	mov    %esp,%ebp
  80115c:	57                   	push   %edi
  80115d:	56                   	push   %esi
  80115e:	53                   	push   %ebx
  80115f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801162:	bb 00 00 00 00       	mov    $0x0,%ebx
  801167:	8b 55 08             	mov    0x8(%ebp),%edx
  80116a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80116d:	b8 0a 00 00 00       	mov    $0xa,%eax
  801172:	89 df                	mov    %ebx,%edi
  801174:	89 de                	mov    %ebx,%esi
  801176:	cd 30                	int    $0x30
	if(check && ret > 0)
  801178:	85 c0                	test   %eax,%eax
  80117a:	7f 08                	jg     801184 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80117c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80117f:	5b                   	pop    %ebx
  801180:	5e                   	pop    %esi
  801181:	5f                   	pop    %edi
  801182:	5d                   	pop    %ebp
  801183:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801184:	83 ec 0c             	sub    $0xc,%esp
  801187:	50                   	push   %eax
  801188:	6a 0a                	push   $0xa
  80118a:	68 f8 2b 80 00       	push   $0x802bf8
  80118f:	6a 43                	push   $0x43
  801191:	68 15 2c 80 00       	push   $0x802c15
  801196:	e8 3c f1 ff ff       	call   8002d7 <_panic>

0080119b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80119b:	55                   	push   %ebp
  80119c:	89 e5                	mov    %esp,%ebp
  80119e:	57                   	push   %edi
  80119f:	56                   	push   %esi
  8011a0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011a7:	b8 0c 00 00 00       	mov    $0xc,%eax
  8011ac:	be 00 00 00 00       	mov    $0x0,%esi
  8011b1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011b4:	8b 7d 14             	mov    0x14(%ebp),%edi
  8011b7:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8011b9:	5b                   	pop    %ebx
  8011ba:	5e                   	pop    %esi
  8011bb:	5f                   	pop    %edi
  8011bc:	5d                   	pop    %ebp
  8011bd:	c3                   	ret    

008011be <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8011be:	55                   	push   %ebp
  8011bf:	89 e5                	mov    %esp,%ebp
  8011c1:	57                   	push   %edi
  8011c2:	56                   	push   %esi
  8011c3:	53                   	push   %ebx
  8011c4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011c7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8011cf:	b8 0d 00 00 00       	mov    $0xd,%eax
  8011d4:	89 cb                	mov    %ecx,%ebx
  8011d6:	89 cf                	mov    %ecx,%edi
  8011d8:	89 ce                	mov    %ecx,%esi
  8011da:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011dc:	85 c0                	test   %eax,%eax
  8011de:	7f 08                	jg     8011e8 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8011e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011e3:	5b                   	pop    %ebx
  8011e4:	5e                   	pop    %esi
  8011e5:	5f                   	pop    %edi
  8011e6:	5d                   	pop    %ebp
  8011e7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011e8:	83 ec 0c             	sub    $0xc,%esp
  8011eb:	50                   	push   %eax
  8011ec:	6a 0d                	push   $0xd
  8011ee:	68 f8 2b 80 00       	push   $0x802bf8
  8011f3:	6a 43                	push   $0x43
  8011f5:	68 15 2c 80 00       	push   $0x802c15
  8011fa:	e8 d8 f0 ff ff       	call   8002d7 <_panic>

008011ff <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  8011ff:	55                   	push   %ebp
  801200:	89 e5                	mov    %esp,%ebp
  801202:	57                   	push   %edi
  801203:	56                   	push   %esi
  801204:	53                   	push   %ebx
	asm volatile("int %1\n"
  801205:	bb 00 00 00 00       	mov    $0x0,%ebx
  80120a:	8b 55 08             	mov    0x8(%ebp),%edx
  80120d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801210:	b8 0e 00 00 00       	mov    $0xe,%eax
  801215:	89 df                	mov    %ebx,%edi
  801217:	89 de                	mov    %ebx,%esi
  801219:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  80121b:	5b                   	pop    %ebx
  80121c:	5e                   	pop    %esi
  80121d:	5f                   	pop    %edi
  80121e:	5d                   	pop    %ebp
  80121f:	c3                   	ret    

00801220 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801220:	55                   	push   %ebp
  801221:	89 e5                	mov    %esp,%ebp
  801223:	57                   	push   %edi
  801224:	56                   	push   %esi
  801225:	53                   	push   %ebx
	asm volatile("int %1\n"
  801226:	b9 00 00 00 00       	mov    $0x0,%ecx
  80122b:	8b 55 08             	mov    0x8(%ebp),%edx
  80122e:	b8 0f 00 00 00       	mov    $0xf,%eax
  801233:	89 cb                	mov    %ecx,%ebx
  801235:	89 cf                	mov    %ecx,%edi
  801237:	89 ce                	mov    %ecx,%esi
  801239:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  80123b:	5b                   	pop    %ebx
  80123c:	5e                   	pop    %esi
  80123d:	5f                   	pop    %edi
  80123e:	5d                   	pop    %ebp
  80123f:	c3                   	ret    

00801240 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801240:	55                   	push   %ebp
  801241:	89 e5                	mov    %esp,%ebp
  801243:	57                   	push   %edi
  801244:	56                   	push   %esi
  801245:	53                   	push   %ebx
	asm volatile("int %1\n"
  801246:	ba 00 00 00 00       	mov    $0x0,%edx
  80124b:	b8 10 00 00 00       	mov    $0x10,%eax
  801250:	89 d1                	mov    %edx,%ecx
  801252:	89 d3                	mov    %edx,%ebx
  801254:	89 d7                	mov    %edx,%edi
  801256:	89 d6                	mov    %edx,%esi
  801258:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80125a:	5b                   	pop    %ebx
  80125b:	5e                   	pop    %esi
  80125c:	5f                   	pop    %edi
  80125d:	5d                   	pop    %ebp
  80125e:	c3                   	ret    

0080125f <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  80125f:	55                   	push   %ebp
  801260:	89 e5                	mov    %esp,%ebp
  801262:	57                   	push   %edi
  801263:	56                   	push   %esi
  801264:	53                   	push   %ebx
	asm volatile("int %1\n"
  801265:	bb 00 00 00 00       	mov    $0x0,%ebx
  80126a:	8b 55 08             	mov    0x8(%ebp),%edx
  80126d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801270:	b8 11 00 00 00       	mov    $0x11,%eax
  801275:	89 df                	mov    %ebx,%edi
  801277:	89 de                	mov    %ebx,%esi
  801279:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80127b:	5b                   	pop    %ebx
  80127c:	5e                   	pop    %esi
  80127d:	5f                   	pop    %edi
  80127e:	5d                   	pop    %ebp
  80127f:	c3                   	ret    

00801280 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801280:	55                   	push   %ebp
  801281:	89 e5                	mov    %esp,%ebp
  801283:	57                   	push   %edi
  801284:	56                   	push   %esi
  801285:	53                   	push   %ebx
	asm volatile("int %1\n"
  801286:	bb 00 00 00 00       	mov    $0x0,%ebx
  80128b:	8b 55 08             	mov    0x8(%ebp),%edx
  80128e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801291:	b8 12 00 00 00       	mov    $0x12,%eax
  801296:	89 df                	mov    %ebx,%edi
  801298:	89 de                	mov    %ebx,%esi
  80129a:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80129c:	5b                   	pop    %ebx
  80129d:	5e                   	pop    %esi
  80129e:	5f                   	pop    %edi
  80129f:	5d                   	pop    %ebp
  8012a0:	c3                   	ret    

008012a1 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  8012a1:	55                   	push   %ebp
  8012a2:	89 e5                	mov    %esp,%ebp
  8012a4:	57                   	push   %edi
  8012a5:	56                   	push   %esi
  8012a6:	53                   	push   %ebx
  8012a7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012aa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012af:	8b 55 08             	mov    0x8(%ebp),%edx
  8012b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012b5:	b8 13 00 00 00       	mov    $0x13,%eax
  8012ba:	89 df                	mov    %ebx,%edi
  8012bc:	89 de                	mov    %ebx,%esi
  8012be:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012c0:	85 c0                	test   %eax,%eax
  8012c2:	7f 08                	jg     8012cc <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8012c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012c7:	5b                   	pop    %ebx
  8012c8:	5e                   	pop    %esi
  8012c9:	5f                   	pop    %edi
  8012ca:	5d                   	pop    %ebp
  8012cb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012cc:	83 ec 0c             	sub    $0xc,%esp
  8012cf:	50                   	push   %eax
  8012d0:	6a 13                	push   $0x13
  8012d2:	68 f8 2b 80 00       	push   $0x802bf8
  8012d7:	6a 43                	push   $0x43
  8012d9:	68 15 2c 80 00       	push   $0x802c15
  8012de:	e8 f4 ef ff ff       	call   8002d7 <_panic>

008012e3 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  8012e3:	55                   	push   %ebp
  8012e4:	89 e5                	mov    %esp,%ebp
  8012e6:	57                   	push   %edi
  8012e7:	56                   	push   %esi
  8012e8:	53                   	push   %ebx
	asm volatile("int %1\n"
  8012e9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8012f1:	b8 14 00 00 00       	mov    $0x14,%eax
  8012f6:	89 cb                	mov    %ecx,%ebx
  8012f8:	89 cf                	mov    %ecx,%edi
  8012fa:	89 ce                	mov    %ecx,%esi
  8012fc:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  8012fe:	5b                   	pop    %ebx
  8012ff:	5e                   	pop    %esi
  801300:	5f                   	pop    %edi
  801301:	5d                   	pop    %ebp
  801302:	c3                   	ret    

00801303 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801303:	55                   	push   %ebp
  801304:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801306:	8b 45 08             	mov    0x8(%ebp),%eax
  801309:	05 00 00 00 30       	add    $0x30000000,%eax
  80130e:	c1 e8 0c             	shr    $0xc,%eax
}
  801311:	5d                   	pop    %ebp
  801312:	c3                   	ret    

00801313 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801313:	55                   	push   %ebp
  801314:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801316:	8b 45 08             	mov    0x8(%ebp),%eax
  801319:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80131e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801323:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801328:	5d                   	pop    %ebp
  801329:	c3                   	ret    

0080132a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80132a:	55                   	push   %ebp
  80132b:	89 e5                	mov    %esp,%ebp
  80132d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801332:	89 c2                	mov    %eax,%edx
  801334:	c1 ea 16             	shr    $0x16,%edx
  801337:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80133e:	f6 c2 01             	test   $0x1,%dl
  801341:	74 2d                	je     801370 <fd_alloc+0x46>
  801343:	89 c2                	mov    %eax,%edx
  801345:	c1 ea 0c             	shr    $0xc,%edx
  801348:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80134f:	f6 c2 01             	test   $0x1,%dl
  801352:	74 1c                	je     801370 <fd_alloc+0x46>
  801354:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801359:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80135e:	75 d2                	jne    801332 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801360:	8b 45 08             	mov    0x8(%ebp),%eax
  801363:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801369:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80136e:	eb 0a                	jmp    80137a <fd_alloc+0x50>
			*fd_store = fd;
  801370:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801373:	89 01                	mov    %eax,(%ecx)
			return 0;
  801375:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80137a:	5d                   	pop    %ebp
  80137b:	c3                   	ret    

0080137c <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80137c:	55                   	push   %ebp
  80137d:	89 e5                	mov    %esp,%ebp
  80137f:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801382:	83 f8 1f             	cmp    $0x1f,%eax
  801385:	77 30                	ja     8013b7 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801387:	c1 e0 0c             	shl    $0xc,%eax
  80138a:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80138f:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801395:	f6 c2 01             	test   $0x1,%dl
  801398:	74 24                	je     8013be <fd_lookup+0x42>
  80139a:	89 c2                	mov    %eax,%edx
  80139c:	c1 ea 0c             	shr    $0xc,%edx
  80139f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013a6:	f6 c2 01             	test   $0x1,%dl
  8013a9:	74 1a                	je     8013c5 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8013ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013ae:	89 02                	mov    %eax,(%edx)
	return 0;
  8013b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013b5:	5d                   	pop    %ebp
  8013b6:	c3                   	ret    
		return -E_INVAL;
  8013b7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013bc:	eb f7                	jmp    8013b5 <fd_lookup+0x39>
		return -E_INVAL;
  8013be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013c3:	eb f0                	jmp    8013b5 <fd_lookup+0x39>
  8013c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013ca:	eb e9                	jmp    8013b5 <fd_lookup+0x39>

008013cc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8013cc:	55                   	push   %ebp
  8013cd:	89 e5                	mov    %esp,%ebp
  8013cf:	83 ec 08             	sub    $0x8,%esp
  8013d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8013d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8013da:	b8 20 30 80 00       	mov    $0x803020,%eax
		if (devtab[i]->dev_id == dev_id) {
  8013df:	39 08                	cmp    %ecx,(%eax)
  8013e1:	74 38                	je     80141b <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8013e3:	83 c2 01             	add    $0x1,%edx
  8013e6:	8b 04 95 a4 2c 80 00 	mov    0x802ca4(,%edx,4),%eax
  8013ed:	85 c0                	test   %eax,%eax
  8013ef:	75 ee                	jne    8013df <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8013f1:	a1 08 44 80 00       	mov    0x804408,%eax
  8013f6:	8b 40 48             	mov    0x48(%eax),%eax
  8013f9:	83 ec 04             	sub    $0x4,%esp
  8013fc:	51                   	push   %ecx
  8013fd:	50                   	push   %eax
  8013fe:	68 24 2c 80 00       	push   $0x802c24
  801403:	e8 c5 ef ff ff       	call   8003cd <cprintf>
	*dev = 0;
  801408:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801411:	83 c4 10             	add    $0x10,%esp
  801414:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801419:	c9                   	leave  
  80141a:	c3                   	ret    
			*dev = devtab[i];
  80141b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80141e:	89 01                	mov    %eax,(%ecx)
			return 0;
  801420:	b8 00 00 00 00       	mov    $0x0,%eax
  801425:	eb f2                	jmp    801419 <dev_lookup+0x4d>

00801427 <fd_close>:
{
  801427:	55                   	push   %ebp
  801428:	89 e5                	mov    %esp,%ebp
  80142a:	57                   	push   %edi
  80142b:	56                   	push   %esi
  80142c:	53                   	push   %ebx
  80142d:	83 ec 24             	sub    $0x24,%esp
  801430:	8b 75 08             	mov    0x8(%ebp),%esi
  801433:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801436:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801439:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80143a:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801440:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801443:	50                   	push   %eax
  801444:	e8 33 ff ff ff       	call   80137c <fd_lookup>
  801449:	89 c3                	mov    %eax,%ebx
  80144b:	83 c4 10             	add    $0x10,%esp
  80144e:	85 c0                	test   %eax,%eax
  801450:	78 05                	js     801457 <fd_close+0x30>
	    || fd != fd2)
  801452:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801455:	74 16                	je     80146d <fd_close+0x46>
		return (must_exist ? r : 0);
  801457:	89 f8                	mov    %edi,%eax
  801459:	84 c0                	test   %al,%al
  80145b:	b8 00 00 00 00       	mov    $0x0,%eax
  801460:	0f 44 d8             	cmove  %eax,%ebx
}
  801463:	89 d8                	mov    %ebx,%eax
  801465:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801468:	5b                   	pop    %ebx
  801469:	5e                   	pop    %esi
  80146a:	5f                   	pop    %edi
  80146b:	5d                   	pop    %ebp
  80146c:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80146d:	83 ec 08             	sub    $0x8,%esp
  801470:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801473:	50                   	push   %eax
  801474:	ff 36                	pushl  (%esi)
  801476:	e8 51 ff ff ff       	call   8013cc <dev_lookup>
  80147b:	89 c3                	mov    %eax,%ebx
  80147d:	83 c4 10             	add    $0x10,%esp
  801480:	85 c0                	test   %eax,%eax
  801482:	78 1a                	js     80149e <fd_close+0x77>
		if (dev->dev_close)
  801484:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801487:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80148a:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80148f:	85 c0                	test   %eax,%eax
  801491:	74 0b                	je     80149e <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801493:	83 ec 0c             	sub    $0xc,%esp
  801496:	56                   	push   %esi
  801497:	ff d0                	call   *%eax
  801499:	89 c3                	mov    %eax,%ebx
  80149b:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80149e:	83 ec 08             	sub    $0x8,%esp
  8014a1:	56                   	push   %esi
  8014a2:	6a 00                	push   $0x0
  8014a4:	e8 ea fb ff ff       	call   801093 <sys_page_unmap>
	return r;
  8014a9:	83 c4 10             	add    $0x10,%esp
  8014ac:	eb b5                	jmp    801463 <fd_close+0x3c>

008014ae <close>:

int
close(int fdnum)
{
  8014ae:	55                   	push   %ebp
  8014af:	89 e5                	mov    %esp,%ebp
  8014b1:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014b7:	50                   	push   %eax
  8014b8:	ff 75 08             	pushl  0x8(%ebp)
  8014bb:	e8 bc fe ff ff       	call   80137c <fd_lookup>
  8014c0:	83 c4 10             	add    $0x10,%esp
  8014c3:	85 c0                	test   %eax,%eax
  8014c5:	79 02                	jns    8014c9 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8014c7:	c9                   	leave  
  8014c8:	c3                   	ret    
		return fd_close(fd, 1);
  8014c9:	83 ec 08             	sub    $0x8,%esp
  8014cc:	6a 01                	push   $0x1
  8014ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8014d1:	e8 51 ff ff ff       	call   801427 <fd_close>
  8014d6:	83 c4 10             	add    $0x10,%esp
  8014d9:	eb ec                	jmp    8014c7 <close+0x19>

008014db <close_all>:

void
close_all(void)
{
  8014db:	55                   	push   %ebp
  8014dc:	89 e5                	mov    %esp,%ebp
  8014de:	53                   	push   %ebx
  8014df:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8014e2:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8014e7:	83 ec 0c             	sub    $0xc,%esp
  8014ea:	53                   	push   %ebx
  8014eb:	e8 be ff ff ff       	call   8014ae <close>
	for (i = 0; i < MAXFD; i++)
  8014f0:	83 c3 01             	add    $0x1,%ebx
  8014f3:	83 c4 10             	add    $0x10,%esp
  8014f6:	83 fb 20             	cmp    $0x20,%ebx
  8014f9:	75 ec                	jne    8014e7 <close_all+0xc>
}
  8014fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014fe:	c9                   	leave  
  8014ff:	c3                   	ret    

00801500 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801500:	55                   	push   %ebp
  801501:	89 e5                	mov    %esp,%ebp
  801503:	57                   	push   %edi
  801504:	56                   	push   %esi
  801505:	53                   	push   %ebx
  801506:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801509:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80150c:	50                   	push   %eax
  80150d:	ff 75 08             	pushl  0x8(%ebp)
  801510:	e8 67 fe ff ff       	call   80137c <fd_lookup>
  801515:	89 c3                	mov    %eax,%ebx
  801517:	83 c4 10             	add    $0x10,%esp
  80151a:	85 c0                	test   %eax,%eax
  80151c:	0f 88 81 00 00 00    	js     8015a3 <dup+0xa3>
		return r;
	close(newfdnum);
  801522:	83 ec 0c             	sub    $0xc,%esp
  801525:	ff 75 0c             	pushl  0xc(%ebp)
  801528:	e8 81 ff ff ff       	call   8014ae <close>

	newfd = INDEX2FD(newfdnum);
  80152d:	8b 75 0c             	mov    0xc(%ebp),%esi
  801530:	c1 e6 0c             	shl    $0xc,%esi
  801533:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801539:	83 c4 04             	add    $0x4,%esp
  80153c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80153f:	e8 cf fd ff ff       	call   801313 <fd2data>
  801544:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801546:	89 34 24             	mov    %esi,(%esp)
  801549:	e8 c5 fd ff ff       	call   801313 <fd2data>
  80154e:	83 c4 10             	add    $0x10,%esp
  801551:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801553:	89 d8                	mov    %ebx,%eax
  801555:	c1 e8 16             	shr    $0x16,%eax
  801558:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80155f:	a8 01                	test   $0x1,%al
  801561:	74 11                	je     801574 <dup+0x74>
  801563:	89 d8                	mov    %ebx,%eax
  801565:	c1 e8 0c             	shr    $0xc,%eax
  801568:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80156f:	f6 c2 01             	test   $0x1,%dl
  801572:	75 39                	jne    8015ad <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801574:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801577:	89 d0                	mov    %edx,%eax
  801579:	c1 e8 0c             	shr    $0xc,%eax
  80157c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801583:	83 ec 0c             	sub    $0xc,%esp
  801586:	25 07 0e 00 00       	and    $0xe07,%eax
  80158b:	50                   	push   %eax
  80158c:	56                   	push   %esi
  80158d:	6a 00                	push   $0x0
  80158f:	52                   	push   %edx
  801590:	6a 00                	push   $0x0
  801592:	e8 ba fa ff ff       	call   801051 <sys_page_map>
  801597:	89 c3                	mov    %eax,%ebx
  801599:	83 c4 20             	add    $0x20,%esp
  80159c:	85 c0                	test   %eax,%eax
  80159e:	78 31                	js     8015d1 <dup+0xd1>
		goto err;

	return newfdnum;
  8015a0:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8015a3:	89 d8                	mov    %ebx,%eax
  8015a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015a8:	5b                   	pop    %ebx
  8015a9:	5e                   	pop    %esi
  8015aa:	5f                   	pop    %edi
  8015ab:	5d                   	pop    %ebp
  8015ac:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8015ad:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015b4:	83 ec 0c             	sub    $0xc,%esp
  8015b7:	25 07 0e 00 00       	and    $0xe07,%eax
  8015bc:	50                   	push   %eax
  8015bd:	57                   	push   %edi
  8015be:	6a 00                	push   $0x0
  8015c0:	53                   	push   %ebx
  8015c1:	6a 00                	push   $0x0
  8015c3:	e8 89 fa ff ff       	call   801051 <sys_page_map>
  8015c8:	89 c3                	mov    %eax,%ebx
  8015ca:	83 c4 20             	add    $0x20,%esp
  8015cd:	85 c0                	test   %eax,%eax
  8015cf:	79 a3                	jns    801574 <dup+0x74>
	sys_page_unmap(0, newfd);
  8015d1:	83 ec 08             	sub    $0x8,%esp
  8015d4:	56                   	push   %esi
  8015d5:	6a 00                	push   $0x0
  8015d7:	e8 b7 fa ff ff       	call   801093 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8015dc:	83 c4 08             	add    $0x8,%esp
  8015df:	57                   	push   %edi
  8015e0:	6a 00                	push   $0x0
  8015e2:	e8 ac fa ff ff       	call   801093 <sys_page_unmap>
	return r;
  8015e7:	83 c4 10             	add    $0x10,%esp
  8015ea:	eb b7                	jmp    8015a3 <dup+0xa3>

008015ec <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8015ec:	55                   	push   %ebp
  8015ed:	89 e5                	mov    %esp,%ebp
  8015ef:	53                   	push   %ebx
  8015f0:	83 ec 1c             	sub    $0x1c,%esp
  8015f3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015f6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015f9:	50                   	push   %eax
  8015fa:	53                   	push   %ebx
  8015fb:	e8 7c fd ff ff       	call   80137c <fd_lookup>
  801600:	83 c4 10             	add    $0x10,%esp
  801603:	85 c0                	test   %eax,%eax
  801605:	78 3f                	js     801646 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801607:	83 ec 08             	sub    $0x8,%esp
  80160a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80160d:	50                   	push   %eax
  80160e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801611:	ff 30                	pushl  (%eax)
  801613:	e8 b4 fd ff ff       	call   8013cc <dev_lookup>
  801618:	83 c4 10             	add    $0x10,%esp
  80161b:	85 c0                	test   %eax,%eax
  80161d:	78 27                	js     801646 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80161f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801622:	8b 42 08             	mov    0x8(%edx),%eax
  801625:	83 e0 03             	and    $0x3,%eax
  801628:	83 f8 01             	cmp    $0x1,%eax
  80162b:	74 1e                	je     80164b <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80162d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801630:	8b 40 08             	mov    0x8(%eax),%eax
  801633:	85 c0                	test   %eax,%eax
  801635:	74 35                	je     80166c <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801637:	83 ec 04             	sub    $0x4,%esp
  80163a:	ff 75 10             	pushl  0x10(%ebp)
  80163d:	ff 75 0c             	pushl  0xc(%ebp)
  801640:	52                   	push   %edx
  801641:	ff d0                	call   *%eax
  801643:	83 c4 10             	add    $0x10,%esp
}
  801646:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801649:	c9                   	leave  
  80164a:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80164b:	a1 08 44 80 00       	mov    0x804408,%eax
  801650:	8b 40 48             	mov    0x48(%eax),%eax
  801653:	83 ec 04             	sub    $0x4,%esp
  801656:	53                   	push   %ebx
  801657:	50                   	push   %eax
  801658:	68 68 2c 80 00       	push   $0x802c68
  80165d:	e8 6b ed ff ff       	call   8003cd <cprintf>
		return -E_INVAL;
  801662:	83 c4 10             	add    $0x10,%esp
  801665:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80166a:	eb da                	jmp    801646 <read+0x5a>
		return -E_NOT_SUPP;
  80166c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801671:	eb d3                	jmp    801646 <read+0x5a>

00801673 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801673:	55                   	push   %ebp
  801674:	89 e5                	mov    %esp,%ebp
  801676:	57                   	push   %edi
  801677:	56                   	push   %esi
  801678:	53                   	push   %ebx
  801679:	83 ec 0c             	sub    $0xc,%esp
  80167c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80167f:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801682:	bb 00 00 00 00       	mov    $0x0,%ebx
  801687:	39 f3                	cmp    %esi,%ebx
  801689:	73 23                	jae    8016ae <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80168b:	83 ec 04             	sub    $0x4,%esp
  80168e:	89 f0                	mov    %esi,%eax
  801690:	29 d8                	sub    %ebx,%eax
  801692:	50                   	push   %eax
  801693:	89 d8                	mov    %ebx,%eax
  801695:	03 45 0c             	add    0xc(%ebp),%eax
  801698:	50                   	push   %eax
  801699:	57                   	push   %edi
  80169a:	e8 4d ff ff ff       	call   8015ec <read>
		if (m < 0)
  80169f:	83 c4 10             	add    $0x10,%esp
  8016a2:	85 c0                	test   %eax,%eax
  8016a4:	78 06                	js     8016ac <readn+0x39>
			return m;
		if (m == 0)
  8016a6:	74 06                	je     8016ae <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8016a8:	01 c3                	add    %eax,%ebx
  8016aa:	eb db                	jmp    801687 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016ac:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8016ae:	89 d8                	mov    %ebx,%eax
  8016b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016b3:	5b                   	pop    %ebx
  8016b4:	5e                   	pop    %esi
  8016b5:	5f                   	pop    %edi
  8016b6:	5d                   	pop    %ebp
  8016b7:	c3                   	ret    

008016b8 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8016b8:	55                   	push   %ebp
  8016b9:	89 e5                	mov    %esp,%ebp
  8016bb:	53                   	push   %ebx
  8016bc:	83 ec 1c             	sub    $0x1c,%esp
  8016bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016c2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016c5:	50                   	push   %eax
  8016c6:	53                   	push   %ebx
  8016c7:	e8 b0 fc ff ff       	call   80137c <fd_lookup>
  8016cc:	83 c4 10             	add    $0x10,%esp
  8016cf:	85 c0                	test   %eax,%eax
  8016d1:	78 3a                	js     80170d <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016d3:	83 ec 08             	sub    $0x8,%esp
  8016d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016d9:	50                   	push   %eax
  8016da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016dd:	ff 30                	pushl  (%eax)
  8016df:	e8 e8 fc ff ff       	call   8013cc <dev_lookup>
  8016e4:	83 c4 10             	add    $0x10,%esp
  8016e7:	85 c0                	test   %eax,%eax
  8016e9:	78 22                	js     80170d <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ee:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016f2:	74 1e                	je     801712 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8016f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016f7:	8b 52 0c             	mov    0xc(%edx),%edx
  8016fa:	85 d2                	test   %edx,%edx
  8016fc:	74 35                	je     801733 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8016fe:	83 ec 04             	sub    $0x4,%esp
  801701:	ff 75 10             	pushl  0x10(%ebp)
  801704:	ff 75 0c             	pushl  0xc(%ebp)
  801707:	50                   	push   %eax
  801708:	ff d2                	call   *%edx
  80170a:	83 c4 10             	add    $0x10,%esp
}
  80170d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801710:	c9                   	leave  
  801711:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801712:	a1 08 44 80 00       	mov    0x804408,%eax
  801717:	8b 40 48             	mov    0x48(%eax),%eax
  80171a:	83 ec 04             	sub    $0x4,%esp
  80171d:	53                   	push   %ebx
  80171e:	50                   	push   %eax
  80171f:	68 84 2c 80 00       	push   $0x802c84
  801724:	e8 a4 ec ff ff       	call   8003cd <cprintf>
		return -E_INVAL;
  801729:	83 c4 10             	add    $0x10,%esp
  80172c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801731:	eb da                	jmp    80170d <write+0x55>
		return -E_NOT_SUPP;
  801733:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801738:	eb d3                	jmp    80170d <write+0x55>

0080173a <seek>:

int
seek(int fdnum, off_t offset)
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
  80173d:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801740:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801743:	50                   	push   %eax
  801744:	ff 75 08             	pushl  0x8(%ebp)
  801747:	e8 30 fc ff ff       	call   80137c <fd_lookup>
  80174c:	83 c4 10             	add    $0x10,%esp
  80174f:	85 c0                	test   %eax,%eax
  801751:	78 0e                	js     801761 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801753:	8b 55 0c             	mov    0xc(%ebp),%edx
  801756:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801759:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80175c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801761:	c9                   	leave  
  801762:	c3                   	ret    

00801763 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801763:	55                   	push   %ebp
  801764:	89 e5                	mov    %esp,%ebp
  801766:	53                   	push   %ebx
  801767:	83 ec 1c             	sub    $0x1c,%esp
  80176a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80176d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801770:	50                   	push   %eax
  801771:	53                   	push   %ebx
  801772:	e8 05 fc ff ff       	call   80137c <fd_lookup>
  801777:	83 c4 10             	add    $0x10,%esp
  80177a:	85 c0                	test   %eax,%eax
  80177c:	78 37                	js     8017b5 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80177e:	83 ec 08             	sub    $0x8,%esp
  801781:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801784:	50                   	push   %eax
  801785:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801788:	ff 30                	pushl  (%eax)
  80178a:	e8 3d fc ff ff       	call   8013cc <dev_lookup>
  80178f:	83 c4 10             	add    $0x10,%esp
  801792:	85 c0                	test   %eax,%eax
  801794:	78 1f                	js     8017b5 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801796:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801799:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80179d:	74 1b                	je     8017ba <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80179f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017a2:	8b 52 18             	mov    0x18(%edx),%edx
  8017a5:	85 d2                	test   %edx,%edx
  8017a7:	74 32                	je     8017db <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8017a9:	83 ec 08             	sub    $0x8,%esp
  8017ac:	ff 75 0c             	pushl  0xc(%ebp)
  8017af:	50                   	push   %eax
  8017b0:	ff d2                	call   *%edx
  8017b2:	83 c4 10             	add    $0x10,%esp
}
  8017b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017b8:	c9                   	leave  
  8017b9:	c3                   	ret    
			thisenv->env_id, fdnum);
  8017ba:	a1 08 44 80 00       	mov    0x804408,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8017bf:	8b 40 48             	mov    0x48(%eax),%eax
  8017c2:	83 ec 04             	sub    $0x4,%esp
  8017c5:	53                   	push   %ebx
  8017c6:	50                   	push   %eax
  8017c7:	68 44 2c 80 00       	push   $0x802c44
  8017cc:	e8 fc eb ff ff       	call   8003cd <cprintf>
		return -E_INVAL;
  8017d1:	83 c4 10             	add    $0x10,%esp
  8017d4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017d9:	eb da                	jmp    8017b5 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8017db:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017e0:	eb d3                	jmp    8017b5 <ftruncate+0x52>

008017e2 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8017e2:	55                   	push   %ebp
  8017e3:	89 e5                	mov    %esp,%ebp
  8017e5:	53                   	push   %ebx
  8017e6:	83 ec 1c             	sub    $0x1c,%esp
  8017e9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017ec:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017ef:	50                   	push   %eax
  8017f0:	ff 75 08             	pushl  0x8(%ebp)
  8017f3:	e8 84 fb ff ff       	call   80137c <fd_lookup>
  8017f8:	83 c4 10             	add    $0x10,%esp
  8017fb:	85 c0                	test   %eax,%eax
  8017fd:	78 4b                	js     80184a <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017ff:	83 ec 08             	sub    $0x8,%esp
  801802:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801805:	50                   	push   %eax
  801806:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801809:	ff 30                	pushl  (%eax)
  80180b:	e8 bc fb ff ff       	call   8013cc <dev_lookup>
  801810:	83 c4 10             	add    $0x10,%esp
  801813:	85 c0                	test   %eax,%eax
  801815:	78 33                	js     80184a <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801817:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80181a:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80181e:	74 2f                	je     80184f <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801820:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801823:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80182a:	00 00 00 
	stat->st_isdir = 0;
  80182d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801834:	00 00 00 
	stat->st_dev = dev;
  801837:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80183d:	83 ec 08             	sub    $0x8,%esp
  801840:	53                   	push   %ebx
  801841:	ff 75 f0             	pushl  -0x10(%ebp)
  801844:	ff 50 14             	call   *0x14(%eax)
  801847:	83 c4 10             	add    $0x10,%esp
}
  80184a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80184d:	c9                   	leave  
  80184e:	c3                   	ret    
		return -E_NOT_SUPP;
  80184f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801854:	eb f4                	jmp    80184a <fstat+0x68>

00801856 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801856:	55                   	push   %ebp
  801857:	89 e5                	mov    %esp,%ebp
  801859:	56                   	push   %esi
  80185a:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80185b:	83 ec 08             	sub    $0x8,%esp
  80185e:	6a 00                	push   $0x0
  801860:	ff 75 08             	pushl  0x8(%ebp)
  801863:	e8 22 02 00 00       	call   801a8a <open>
  801868:	89 c3                	mov    %eax,%ebx
  80186a:	83 c4 10             	add    $0x10,%esp
  80186d:	85 c0                	test   %eax,%eax
  80186f:	78 1b                	js     80188c <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801871:	83 ec 08             	sub    $0x8,%esp
  801874:	ff 75 0c             	pushl  0xc(%ebp)
  801877:	50                   	push   %eax
  801878:	e8 65 ff ff ff       	call   8017e2 <fstat>
  80187d:	89 c6                	mov    %eax,%esi
	close(fd);
  80187f:	89 1c 24             	mov    %ebx,(%esp)
  801882:	e8 27 fc ff ff       	call   8014ae <close>
	return r;
  801887:	83 c4 10             	add    $0x10,%esp
  80188a:	89 f3                	mov    %esi,%ebx
}
  80188c:	89 d8                	mov    %ebx,%eax
  80188e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801891:	5b                   	pop    %ebx
  801892:	5e                   	pop    %esi
  801893:	5d                   	pop    %ebp
  801894:	c3                   	ret    

00801895 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801895:	55                   	push   %ebp
  801896:	89 e5                	mov    %esp,%ebp
  801898:	56                   	push   %esi
  801899:	53                   	push   %ebx
  80189a:	89 c6                	mov    %eax,%esi
  80189c:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80189e:	83 3d 00 44 80 00 00 	cmpl   $0x0,0x804400
  8018a5:	74 27                	je     8018ce <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8018a7:	6a 07                	push   $0x7
  8018a9:	68 00 50 80 00       	push   $0x805000
  8018ae:	56                   	push   %esi
  8018af:	ff 35 00 44 80 00    	pushl  0x804400
  8018b5:	e8 a7 0b 00 00       	call   802461 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8018ba:	83 c4 0c             	add    $0xc,%esp
  8018bd:	6a 00                	push   $0x0
  8018bf:	53                   	push   %ebx
  8018c0:	6a 00                	push   $0x0
  8018c2:	e8 31 0b 00 00       	call   8023f8 <ipc_recv>
}
  8018c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018ca:	5b                   	pop    %ebx
  8018cb:	5e                   	pop    %esi
  8018cc:	5d                   	pop    %ebp
  8018cd:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8018ce:	83 ec 0c             	sub    $0xc,%esp
  8018d1:	6a 01                	push   $0x1
  8018d3:	e8 e1 0b 00 00       	call   8024b9 <ipc_find_env>
  8018d8:	a3 00 44 80 00       	mov    %eax,0x804400
  8018dd:	83 c4 10             	add    $0x10,%esp
  8018e0:	eb c5                	jmp    8018a7 <fsipc+0x12>

008018e2 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8018e2:	55                   	push   %ebp
  8018e3:	89 e5                	mov    %esp,%ebp
  8018e5:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8018e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8018ee:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8018f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f6:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8018fb:	ba 00 00 00 00       	mov    $0x0,%edx
  801900:	b8 02 00 00 00       	mov    $0x2,%eax
  801905:	e8 8b ff ff ff       	call   801895 <fsipc>
}
  80190a:	c9                   	leave  
  80190b:	c3                   	ret    

0080190c <devfile_flush>:
{
  80190c:	55                   	push   %ebp
  80190d:	89 e5                	mov    %esp,%ebp
  80190f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801912:	8b 45 08             	mov    0x8(%ebp),%eax
  801915:	8b 40 0c             	mov    0xc(%eax),%eax
  801918:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80191d:	ba 00 00 00 00       	mov    $0x0,%edx
  801922:	b8 06 00 00 00       	mov    $0x6,%eax
  801927:	e8 69 ff ff ff       	call   801895 <fsipc>
}
  80192c:	c9                   	leave  
  80192d:	c3                   	ret    

0080192e <devfile_stat>:
{
  80192e:	55                   	push   %ebp
  80192f:	89 e5                	mov    %esp,%ebp
  801931:	53                   	push   %ebx
  801932:	83 ec 04             	sub    $0x4,%esp
  801935:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801938:	8b 45 08             	mov    0x8(%ebp),%eax
  80193b:	8b 40 0c             	mov    0xc(%eax),%eax
  80193e:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801943:	ba 00 00 00 00       	mov    $0x0,%edx
  801948:	b8 05 00 00 00       	mov    $0x5,%eax
  80194d:	e8 43 ff ff ff       	call   801895 <fsipc>
  801952:	85 c0                	test   %eax,%eax
  801954:	78 2c                	js     801982 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801956:	83 ec 08             	sub    $0x8,%esp
  801959:	68 00 50 80 00       	push   $0x805000
  80195e:	53                   	push   %ebx
  80195f:	e8 b8 f2 ff ff       	call   800c1c <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801964:	a1 80 50 80 00       	mov    0x805080,%eax
  801969:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80196f:	a1 84 50 80 00       	mov    0x805084,%eax
  801974:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80197a:	83 c4 10             	add    $0x10,%esp
  80197d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801982:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801985:	c9                   	leave  
  801986:	c3                   	ret    

00801987 <devfile_write>:
{
  801987:	55                   	push   %ebp
  801988:	89 e5                	mov    %esp,%ebp
  80198a:	53                   	push   %ebx
  80198b:	83 ec 08             	sub    $0x8,%esp
  80198e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801991:	8b 45 08             	mov    0x8(%ebp),%eax
  801994:	8b 40 0c             	mov    0xc(%eax),%eax
  801997:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  80199c:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8019a2:	53                   	push   %ebx
  8019a3:	ff 75 0c             	pushl  0xc(%ebp)
  8019a6:	68 08 50 80 00       	push   $0x805008
  8019ab:	e8 5c f4 ff ff       	call   800e0c <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8019b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8019b5:	b8 04 00 00 00       	mov    $0x4,%eax
  8019ba:	e8 d6 fe ff ff       	call   801895 <fsipc>
  8019bf:	83 c4 10             	add    $0x10,%esp
  8019c2:	85 c0                	test   %eax,%eax
  8019c4:	78 0b                	js     8019d1 <devfile_write+0x4a>
	assert(r <= n);
  8019c6:	39 d8                	cmp    %ebx,%eax
  8019c8:	77 0c                	ja     8019d6 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8019ca:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8019cf:	7f 1e                	jg     8019ef <devfile_write+0x68>
}
  8019d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019d4:	c9                   	leave  
  8019d5:	c3                   	ret    
	assert(r <= n);
  8019d6:	68 b8 2c 80 00       	push   $0x802cb8
  8019db:	68 bf 2c 80 00       	push   $0x802cbf
  8019e0:	68 98 00 00 00       	push   $0x98
  8019e5:	68 d4 2c 80 00       	push   $0x802cd4
  8019ea:	e8 e8 e8 ff ff       	call   8002d7 <_panic>
	assert(r <= PGSIZE);
  8019ef:	68 df 2c 80 00       	push   $0x802cdf
  8019f4:	68 bf 2c 80 00       	push   $0x802cbf
  8019f9:	68 99 00 00 00       	push   $0x99
  8019fe:	68 d4 2c 80 00       	push   $0x802cd4
  801a03:	e8 cf e8 ff ff       	call   8002d7 <_panic>

00801a08 <devfile_read>:
{
  801a08:	55                   	push   %ebp
  801a09:	89 e5                	mov    %esp,%ebp
  801a0b:	56                   	push   %esi
  801a0c:	53                   	push   %ebx
  801a0d:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a10:	8b 45 08             	mov    0x8(%ebp),%eax
  801a13:	8b 40 0c             	mov    0xc(%eax),%eax
  801a16:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801a1b:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a21:	ba 00 00 00 00       	mov    $0x0,%edx
  801a26:	b8 03 00 00 00       	mov    $0x3,%eax
  801a2b:	e8 65 fe ff ff       	call   801895 <fsipc>
  801a30:	89 c3                	mov    %eax,%ebx
  801a32:	85 c0                	test   %eax,%eax
  801a34:	78 1f                	js     801a55 <devfile_read+0x4d>
	assert(r <= n);
  801a36:	39 f0                	cmp    %esi,%eax
  801a38:	77 24                	ja     801a5e <devfile_read+0x56>
	assert(r <= PGSIZE);
  801a3a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a3f:	7f 33                	jg     801a74 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801a41:	83 ec 04             	sub    $0x4,%esp
  801a44:	50                   	push   %eax
  801a45:	68 00 50 80 00       	push   $0x805000
  801a4a:	ff 75 0c             	pushl  0xc(%ebp)
  801a4d:	e8 58 f3 ff ff       	call   800daa <memmove>
	return r;
  801a52:	83 c4 10             	add    $0x10,%esp
}
  801a55:	89 d8                	mov    %ebx,%eax
  801a57:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a5a:	5b                   	pop    %ebx
  801a5b:	5e                   	pop    %esi
  801a5c:	5d                   	pop    %ebp
  801a5d:	c3                   	ret    
	assert(r <= n);
  801a5e:	68 b8 2c 80 00       	push   $0x802cb8
  801a63:	68 bf 2c 80 00       	push   $0x802cbf
  801a68:	6a 7c                	push   $0x7c
  801a6a:	68 d4 2c 80 00       	push   $0x802cd4
  801a6f:	e8 63 e8 ff ff       	call   8002d7 <_panic>
	assert(r <= PGSIZE);
  801a74:	68 df 2c 80 00       	push   $0x802cdf
  801a79:	68 bf 2c 80 00       	push   $0x802cbf
  801a7e:	6a 7d                	push   $0x7d
  801a80:	68 d4 2c 80 00       	push   $0x802cd4
  801a85:	e8 4d e8 ff ff       	call   8002d7 <_panic>

00801a8a <open>:
{
  801a8a:	55                   	push   %ebp
  801a8b:	89 e5                	mov    %esp,%ebp
  801a8d:	56                   	push   %esi
  801a8e:	53                   	push   %ebx
  801a8f:	83 ec 1c             	sub    $0x1c,%esp
  801a92:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801a95:	56                   	push   %esi
  801a96:	e8 48 f1 ff ff       	call   800be3 <strlen>
  801a9b:	83 c4 10             	add    $0x10,%esp
  801a9e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801aa3:	7f 6c                	jg     801b11 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801aa5:	83 ec 0c             	sub    $0xc,%esp
  801aa8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aab:	50                   	push   %eax
  801aac:	e8 79 f8 ff ff       	call   80132a <fd_alloc>
  801ab1:	89 c3                	mov    %eax,%ebx
  801ab3:	83 c4 10             	add    $0x10,%esp
  801ab6:	85 c0                	test   %eax,%eax
  801ab8:	78 3c                	js     801af6 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801aba:	83 ec 08             	sub    $0x8,%esp
  801abd:	56                   	push   %esi
  801abe:	68 00 50 80 00       	push   $0x805000
  801ac3:	e8 54 f1 ff ff       	call   800c1c <strcpy>
	fsipcbuf.open.req_omode = mode;
  801ac8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801acb:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801ad0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ad3:	b8 01 00 00 00       	mov    $0x1,%eax
  801ad8:	e8 b8 fd ff ff       	call   801895 <fsipc>
  801add:	89 c3                	mov    %eax,%ebx
  801adf:	83 c4 10             	add    $0x10,%esp
  801ae2:	85 c0                	test   %eax,%eax
  801ae4:	78 19                	js     801aff <open+0x75>
	return fd2num(fd);
  801ae6:	83 ec 0c             	sub    $0xc,%esp
  801ae9:	ff 75 f4             	pushl  -0xc(%ebp)
  801aec:	e8 12 f8 ff ff       	call   801303 <fd2num>
  801af1:	89 c3                	mov    %eax,%ebx
  801af3:	83 c4 10             	add    $0x10,%esp
}
  801af6:	89 d8                	mov    %ebx,%eax
  801af8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801afb:	5b                   	pop    %ebx
  801afc:	5e                   	pop    %esi
  801afd:	5d                   	pop    %ebp
  801afe:	c3                   	ret    
		fd_close(fd, 0);
  801aff:	83 ec 08             	sub    $0x8,%esp
  801b02:	6a 00                	push   $0x0
  801b04:	ff 75 f4             	pushl  -0xc(%ebp)
  801b07:	e8 1b f9 ff ff       	call   801427 <fd_close>
		return r;
  801b0c:	83 c4 10             	add    $0x10,%esp
  801b0f:	eb e5                	jmp    801af6 <open+0x6c>
		return -E_BAD_PATH;
  801b11:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801b16:	eb de                	jmp    801af6 <open+0x6c>

00801b18 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801b18:	55                   	push   %ebp
  801b19:	89 e5                	mov    %esp,%ebp
  801b1b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b1e:	ba 00 00 00 00       	mov    $0x0,%edx
  801b23:	b8 08 00 00 00       	mov    $0x8,%eax
  801b28:	e8 68 fd ff ff       	call   801895 <fsipc>
}
  801b2d:	c9                   	leave  
  801b2e:	c3                   	ret    

00801b2f <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  801b2f:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801b33:	7f 01                	jg     801b36 <writebuf+0x7>
  801b35:	c3                   	ret    
{
  801b36:	55                   	push   %ebp
  801b37:	89 e5                	mov    %esp,%ebp
  801b39:	53                   	push   %ebx
  801b3a:	83 ec 08             	sub    $0x8,%esp
  801b3d:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  801b3f:	ff 70 04             	pushl  0x4(%eax)
  801b42:	8d 40 10             	lea    0x10(%eax),%eax
  801b45:	50                   	push   %eax
  801b46:	ff 33                	pushl  (%ebx)
  801b48:	e8 6b fb ff ff       	call   8016b8 <write>
		if (result > 0)
  801b4d:	83 c4 10             	add    $0x10,%esp
  801b50:	85 c0                	test   %eax,%eax
  801b52:	7e 03                	jle    801b57 <writebuf+0x28>
			b->result += result;
  801b54:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801b57:	39 43 04             	cmp    %eax,0x4(%ebx)
  801b5a:	74 0d                	je     801b69 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  801b5c:	85 c0                	test   %eax,%eax
  801b5e:	ba 00 00 00 00       	mov    $0x0,%edx
  801b63:	0f 4f c2             	cmovg  %edx,%eax
  801b66:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801b69:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b6c:	c9                   	leave  
  801b6d:	c3                   	ret    

00801b6e <putch>:

static void
putch(int ch, void *thunk)
{
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
  801b71:	53                   	push   %ebx
  801b72:	83 ec 04             	sub    $0x4,%esp
  801b75:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801b78:	8b 53 04             	mov    0x4(%ebx),%edx
  801b7b:	8d 42 01             	lea    0x1(%edx),%eax
  801b7e:	89 43 04             	mov    %eax,0x4(%ebx)
  801b81:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b84:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801b88:	3d 00 01 00 00       	cmp    $0x100,%eax
  801b8d:	74 06                	je     801b95 <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  801b8f:	83 c4 04             	add    $0x4,%esp
  801b92:	5b                   	pop    %ebx
  801b93:	5d                   	pop    %ebp
  801b94:	c3                   	ret    
		writebuf(b);
  801b95:	89 d8                	mov    %ebx,%eax
  801b97:	e8 93 ff ff ff       	call   801b2f <writebuf>
		b->idx = 0;
  801b9c:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  801ba3:	eb ea                	jmp    801b8f <putch+0x21>

00801ba5 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801ba5:	55                   	push   %ebp
  801ba6:	89 e5                	mov    %esp,%ebp
  801ba8:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801bae:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb1:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801bb7:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801bbe:	00 00 00 
	b.result = 0;
  801bc1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801bc8:	00 00 00 
	b.error = 1;
  801bcb:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801bd2:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801bd5:	ff 75 10             	pushl  0x10(%ebp)
  801bd8:	ff 75 0c             	pushl  0xc(%ebp)
  801bdb:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801be1:	50                   	push   %eax
  801be2:	68 6e 1b 80 00       	push   $0x801b6e
  801be7:	e8 0e e9 ff ff       	call   8004fa <vprintfmt>
	if (b.idx > 0)
  801bec:	83 c4 10             	add    $0x10,%esp
  801bef:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801bf6:	7f 11                	jg     801c09 <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  801bf8:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801bfe:	85 c0                	test   %eax,%eax
  801c00:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801c07:	c9                   	leave  
  801c08:	c3                   	ret    
		writebuf(&b);
  801c09:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801c0f:	e8 1b ff ff ff       	call   801b2f <writebuf>
  801c14:	eb e2                	jmp    801bf8 <vfprintf+0x53>

00801c16 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
  801c19:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801c1c:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801c1f:	50                   	push   %eax
  801c20:	ff 75 0c             	pushl  0xc(%ebp)
  801c23:	ff 75 08             	pushl  0x8(%ebp)
  801c26:	e8 7a ff ff ff       	call   801ba5 <vfprintf>
	va_end(ap);

	return cnt;
}
  801c2b:	c9                   	leave  
  801c2c:	c3                   	ret    

00801c2d <printf>:

int
printf(const char *fmt, ...)
{
  801c2d:	55                   	push   %ebp
  801c2e:	89 e5                	mov    %esp,%ebp
  801c30:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801c33:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801c36:	50                   	push   %eax
  801c37:	ff 75 08             	pushl  0x8(%ebp)
  801c3a:	6a 01                	push   $0x1
  801c3c:	e8 64 ff ff ff       	call   801ba5 <vfprintf>
	va_end(ap);

	return cnt;
}
  801c41:	c9                   	leave  
  801c42:	c3                   	ret    

00801c43 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
  801c46:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801c49:	68 eb 2c 80 00       	push   $0x802ceb
  801c4e:	ff 75 0c             	pushl  0xc(%ebp)
  801c51:	e8 c6 ef ff ff       	call   800c1c <strcpy>
	return 0;
}
  801c56:	b8 00 00 00 00       	mov    $0x0,%eax
  801c5b:	c9                   	leave  
  801c5c:	c3                   	ret    

00801c5d <devsock_close>:
{
  801c5d:	55                   	push   %ebp
  801c5e:	89 e5                	mov    %esp,%ebp
  801c60:	53                   	push   %ebx
  801c61:	83 ec 10             	sub    $0x10,%esp
  801c64:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801c67:	53                   	push   %ebx
  801c68:	e8 8b 08 00 00       	call   8024f8 <pageref>
  801c6d:	83 c4 10             	add    $0x10,%esp
		return 0;
  801c70:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801c75:	83 f8 01             	cmp    $0x1,%eax
  801c78:	74 07                	je     801c81 <devsock_close+0x24>
}
  801c7a:	89 d0                	mov    %edx,%eax
  801c7c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c7f:	c9                   	leave  
  801c80:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801c81:	83 ec 0c             	sub    $0xc,%esp
  801c84:	ff 73 0c             	pushl  0xc(%ebx)
  801c87:	e8 b9 02 00 00       	call   801f45 <nsipc_close>
  801c8c:	89 c2                	mov    %eax,%edx
  801c8e:	83 c4 10             	add    $0x10,%esp
  801c91:	eb e7                	jmp    801c7a <devsock_close+0x1d>

00801c93 <devsock_write>:
{
  801c93:	55                   	push   %ebp
  801c94:	89 e5                	mov    %esp,%ebp
  801c96:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801c99:	6a 00                	push   $0x0
  801c9b:	ff 75 10             	pushl  0x10(%ebp)
  801c9e:	ff 75 0c             	pushl  0xc(%ebp)
  801ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca4:	ff 70 0c             	pushl  0xc(%eax)
  801ca7:	e8 76 03 00 00       	call   802022 <nsipc_send>
}
  801cac:	c9                   	leave  
  801cad:	c3                   	ret    

00801cae <devsock_read>:
{
  801cae:	55                   	push   %ebp
  801caf:	89 e5                	mov    %esp,%ebp
  801cb1:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801cb4:	6a 00                	push   $0x0
  801cb6:	ff 75 10             	pushl  0x10(%ebp)
  801cb9:	ff 75 0c             	pushl  0xc(%ebp)
  801cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbf:	ff 70 0c             	pushl  0xc(%eax)
  801cc2:	e8 ef 02 00 00       	call   801fb6 <nsipc_recv>
}
  801cc7:	c9                   	leave  
  801cc8:	c3                   	ret    

00801cc9 <fd2sockid>:
{
  801cc9:	55                   	push   %ebp
  801cca:	89 e5                	mov    %esp,%ebp
  801ccc:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801ccf:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801cd2:	52                   	push   %edx
  801cd3:	50                   	push   %eax
  801cd4:	e8 a3 f6 ff ff       	call   80137c <fd_lookup>
  801cd9:	83 c4 10             	add    $0x10,%esp
  801cdc:	85 c0                	test   %eax,%eax
  801cde:	78 10                	js     801cf0 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce3:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801ce9:	39 08                	cmp    %ecx,(%eax)
  801ceb:	75 05                	jne    801cf2 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801ced:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801cf0:	c9                   	leave  
  801cf1:	c3                   	ret    
		return -E_NOT_SUPP;
  801cf2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801cf7:	eb f7                	jmp    801cf0 <fd2sockid+0x27>

00801cf9 <alloc_sockfd>:
{
  801cf9:	55                   	push   %ebp
  801cfa:	89 e5                	mov    %esp,%ebp
  801cfc:	56                   	push   %esi
  801cfd:	53                   	push   %ebx
  801cfe:	83 ec 1c             	sub    $0x1c,%esp
  801d01:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801d03:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d06:	50                   	push   %eax
  801d07:	e8 1e f6 ff ff       	call   80132a <fd_alloc>
  801d0c:	89 c3                	mov    %eax,%ebx
  801d0e:	83 c4 10             	add    $0x10,%esp
  801d11:	85 c0                	test   %eax,%eax
  801d13:	78 43                	js     801d58 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801d15:	83 ec 04             	sub    $0x4,%esp
  801d18:	68 07 04 00 00       	push   $0x407
  801d1d:	ff 75 f4             	pushl  -0xc(%ebp)
  801d20:	6a 00                	push   $0x0
  801d22:	e8 e7 f2 ff ff       	call   80100e <sys_page_alloc>
  801d27:	89 c3                	mov    %eax,%ebx
  801d29:	83 c4 10             	add    $0x10,%esp
  801d2c:	85 c0                	test   %eax,%eax
  801d2e:	78 28                	js     801d58 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801d30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d33:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801d39:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801d3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d3e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801d45:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801d48:	83 ec 0c             	sub    $0xc,%esp
  801d4b:	50                   	push   %eax
  801d4c:	e8 b2 f5 ff ff       	call   801303 <fd2num>
  801d51:	89 c3                	mov    %eax,%ebx
  801d53:	83 c4 10             	add    $0x10,%esp
  801d56:	eb 0c                	jmp    801d64 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801d58:	83 ec 0c             	sub    $0xc,%esp
  801d5b:	56                   	push   %esi
  801d5c:	e8 e4 01 00 00       	call   801f45 <nsipc_close>
		return r;
  801d61:	83 c4 10             	add    $0x10,%esp
}
  801d64:	89 d8                	mov    %ebx,%eax
  801d66:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d69:	5b                   	pop    %ebx
  801d6a:	5e                   	pop    %esi
  801d6b:	5d                   	pop    %ebp
  801d6c:	c3                   	ret    

00801d6d <accept>:
{
  801d6d:	55                   	push   %ebp
  801d6e:	89 e5                	mov    %esp,%ebp
  801d70:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d73:	8b 45 08             	mov    0x8(%ebp),%eax
  801d76:	e8 4e ff ff ff       	call   801cc9 <fd2sockid>
  801d7b:	85 c0                	test   %eax,%eax
  801d7d:	78 1b                	js     801d9a <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801d7f:	83 ec 04             	sub    $0x4,%esp
  801d82:	ff 75 10             	pushl  0x10(%ebp)
  801d85:	ff 75 0c             	pushl  0xc(%ebp)
  801d88:	50                   	push   %eax
  801d89:	e8 0e 01 00 00       	call   801e9c <nsipc_accept>
  801d8e:	83 c4 10             	add    $0x10,%esp
  801d91:	85 c0                	test   %eax,%eax
  801d93:	78 05                	js     801d9a <accept+0x2d>
	return alloc_sockfd(r);
  801d95:	e8 5f ff ff ff       	call   801cf9 <alloc_sockfd>
}
  801d9a:	c9                   	leave  
  801d9b:	c3                   	ret    

00801d9c <bind>:
{
  801d9c:	55                   	push   %ebp
  801d9d:	89 e5                	mov    %esp,%ebp
  801d9f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801da2:	8b 45 08             	mov    0x8(%ebp),%eax
  801da5:	e8 1f ff ff ff       	call   801cc9 <fd2sockid>
  801daa:	85 c0                	test   %eax,%eax
  801dac:	78 12                	js     801dc0 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801dae:	83 ec 04             	sub    $0x4,%esp
  801db1:	ff 75 10             	pushl  0x10(%ebp)
  801db4:	ff 75 0c             	pushl  0xc(%ebp)
  801db7:	50                   	push   %eax
  801db8:	e8 31 01 00 00       	call   801eee <nsipc_bind>
  801dbd:	83 c4 10             	add    $0x10,%esp
}
  801dc0:	c9                   	leave  
  801dc1:	c3                   	ret    

00801dc2 <shutdown>:
{
  801dc2:	55                   	push   %ebp
  801dc3:	89 e5                	mov    %esp,%ebp
  801dc5:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcb:	e8 f9 fe ff ff       	call   801cc9 <fd2sockid>
  801dd0:	85 c0                	test   %eax,%eax
  801dd2:	78 0f                	js     801de3 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801dd4:	83 ec 08             	sub    $0x8,%esp
  801dd7:	ff 75 0c             	pushl  0xc(%ebp)
  801dda:	50                   	push   %eax
  801ddb:	e8 43 01 00 00       	call   801f23 <nsipc_shutdown>
  801de0:	83 c4 10             	add    $0x10,%esp
}
  801de3:	c9                   	leave  
  801de4:	c3                   	ret    

00801de5 <connect>:
{
  801de5:	55                   	push   %ebp
  801de6:	89 e5                	mov    %esp,%ebp
  801de8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801deb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dee:	e8 d6 fe ff ff       	call   801cc9 <fd2sockid>
  801df3:	85 c0                	test   %eax,%eax
  801df5:	78 12                	js     801e09 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801df7:	83 ec 04             	sub    $0x4,%esp
  801dfa:	ff 75 10             	pushl  0x10(%ebp)
  801dfd:	ff 75 0c             	pushl  0xc(%ebp)
  801e00:	50                   	push   %eax
  801e01:	e8 59 01 00 00       	call   801f5f <nsipc_connect>
  801e06:	83 c4 10             	add    $0x10,%esp
}
  801e09:	c9                   	leave  
  801e0a:	c3                   	ret    

00801e0b <listen>:
{
  801e0b:	55                   	push   %ebp
  801e0c:	89 e5                	mov    %esp,%ebp
  801e0e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e11:	8b 45 08             	mov    0x8(%ebp),%eax
  801e14:	e8 b0 fe ff ff       	call   801cc9 <fd2sockid>
  801e19:	85 c0                	test   %eax,%eax
  801e1b:	78 0f                	js     801e2c <listen+0x21>
	return nsipc_listen(r, backlog);
  801e1d:	83 ec 08             	sub    $0x8,%esp
  801e20:	ff 75 0c             	pushl  0xc(%ebp)
  801e23:	50                   	push   %eax
  801e24:	e8 6b 01 00 00       	call   801f94 <nsipc_listen>
  801e29:	83 c4 10             	add    $0x10,%esp
}
  801e2c:	c9                   	leave  
  801e2d:	c3                   	ret    

00801e2e <socket>:

int
socket(int domain, int type, int protocol)
{
  801e2e:	55                   	push   %ebp
  801e2f:	89 e5                	mov    %esp,%ebp
  801e31:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801e34:	ff 75 10             	pushl  0x10(%ebp)
  801e37:	ff 75 0c             	pushl  0xc(%ebp)
  801e3a:	ff 75 08             	pushl  0x8(%ebp)
  801e3d:	e8 3e 02 00 00       	call   802080 <nsipc_socket>
  801e42:	83 c4 10             	add    $0x10,%esp
  801e45:	85 c0                	test   %eax,%eax
  801e47:	78 05                	js     801e4e <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801e49:	e8 ab fe ff ff       	call   801cf9 <alloc_sockfd>
}
  801e4e:	c9                   	leave  
  801e4f:	c3                   	ret    

00801e50 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801e50:	55                   	push   %ebp
  801e51:	89 e5                	mov    %esp,%ebp
  801e53:	53                   	push   %ebx
  801e54:	83 ec 04             	sub    $0x4,%esp
  801e57:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801e59:	83 3d 04 44 80 00 00 	cmpl   $0x0,0x804404
  801e60:	74 26                	je     801e88 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801e62:	6a 07                	push   $0x7
  801e64:	68 00 60 80 00       	push   $0x806000
  801e69:	53                   	push   %ebx
  801e6a:	ff 35 04 44 80 00    	pushl  0x804404
  801e70:	e8 ec 05 00 00       	call   802461 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801e75:	83 c4 0c             	add    $0xc,%esp
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 00                	push   $0x0
  801e7e:	e8 75 05 00 00       	call   8023f8 <ipc_recv>
}
  801e83:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e86:	c9                   	leave  
  801e87:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801e88:	83 ec 0c             	sub    $0xc,%esp
  801e8b:	6a 02                	push   $0x2
  801e8d:	e8 27 06 00 00       	call   8024b9 <ipc_find_env>
  801e92:	a3 04 44 80 00       	mov    %eax,0x804404
  801e97:	83 c4 10             	add    $0x10,%esp
  801e9a:	eb c6                	jmp    801e62 <nsipc+0x12>

00801e9c <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801e9c:	55                   	push   %ebp
  801e9d:	89 e5                	mov    %esp,%ebp
  801e9f:	56                   	push   %esi
  801ea0:	53                   	push   %ebx
  801ea1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801eac:	8b 06                	mov    (%esi),%eax
  801eae:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801eb3:	b8 01 00 00 00       	mov    $0x1,%eax
  801eb8:	e8 93 ff ff ff       	call   801e50 <nsipc>
  801ebd:	89 c3                	mov    %eax,%ebx
  801ebf:	85 c0                	test   %eax,%eax
  801ec1:	79 09                	jns    801ecc <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801ec3:	89 d8                	mov    %ebx,%eax
  801ec5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ec8:	5b                   	pop    %ebx
  801ec9:	5e                   	pop    %esi
  801eca:	5d                   	pop    %ebp
  801ecb:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801ecc:	83 ec 04             	sub    $0x4,%esp
  801ecf:	ff 35 10 60 80 00    	pushl  0x806010
  801ed5:	68 00 60 80 00       	push   $0x806000
  801eda:	ff 75 0c             	pushl  0xc(%ebp)
  801edd:	e8 c8 ee ff ff       	call   800daa <memmove>
		*addrlen = ret->ret_addrlen;
  801ee2:	a1 10 60 80 00       	mov    0x806010,%eax
  801ee7:	89 06                	mov    %eax,(%esi)
  801ee9:	83 c4 10             	add    $0x10,%esp
	return r;
  801eec:	eb d5                	jmp    801ec3 <nsipc_accept+0x27>

00801eee <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801eee:	55                   	push   %ebp
  801eef:	89 e5                	mov    %esp,%ebp
  801ef1:	53                   	push   %ebx
  801ef2:	83 ec 08             	sub    $0x8,%esp
  801ef5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  801efb:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801f00:	53                   	push   %ebx
  801f01:	ff 75 0c             	pushl  0xc(%ebp)
  801f04:	68 04 60 80 00       	push   $0x806004
  801f09:	e8 9c ee ff ff       	call   800daa <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801f0e:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801f14:	b8 02 00 00 00       	mov    $0x2,%eax
  801f19:	e8 32 ff ff ff       	call   801e50 <nsipc>
}
  801f1e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f21:	c9                   	leave  
  801f22:	c3                   	ret    

00801f23 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801f23:	55                   	push   %ebp
  801f24:	89 e5                	mov    %esp,%ebp
  801f26:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801f29:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801f31:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f34:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801f39:	b8 03 00 00 00       	mov    $0x3,%eax
  801f3e:	e8 0d ff ff ff       	call   801e50 <nsipc>
}
  801f43:	c9                   	leave  
  801f44:	c3                   	ret    

00801f45 <nsipc_close>:

int
nsipc_close(int s)
{
  801f45:	55                   	push   %ebp
  801f46:	89 e5                	mov    %esp,%ebp
  801f48:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4e:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801f53:	b8 04 00 00 00       	mov    $0x4,%eax
  801f58:	e8 f3 fe ff ff       	call   801e50 <nsipc>
}
  801f5d:	c9                   	leave  
  801f5e:	c3                   	ret    

00801f5f <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801f5f:	55                   	push   %ebp
  801f60:	89 e5                	mov    %esp,%ebp
  801f62:	53                   	push   %ebx
  801f63:	83 ec 08             	sub    $0x8,%esp
  801f66:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801f69:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801f71:	53                   	push   %ebx
  801f72:	ff 75 0c             	pushl  0xc(%ebp)
  801f75:	68 04 60 80 00       	push   $0x806004
  801f7a:	e8 2b ee ff ff       	call   800daa <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801f7f:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801f85:	b8 05 00 00 00       	mov    $0x5,%eax
  801f8a:	e8 c1 fe ff ff       	call   801e50 <nsipc>
}
  801f8f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f92:	c9                   	leave  
  801f93:	c3                   	ret    

00801f94 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801f94:	55                   	push   %ebp
  801f95:	89 e5                	mov    %esp,%ebp
  801f97:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801fa2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fa5:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801faa:	b8 06 00 00 00       	mov    $0x6,%eax
  801faf:	e8 9c fe ff ff       	call   801e50 <nsipc>
}
  801fb4:	c9                   	leave  
  801fb5:	c3                   	ret    

00801fb6 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801fb6:	55                   	push   %ebp
  801fb7:	89 e5                	mov    %esp,%ebp
  801fb9:	56                   	push   %esi
  801fba:	53                   	push   %ebx
  801fbb:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc1:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801fc6:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801fcc:	8b 45 14             	mov    0x14(%ebp),%eax
  801fcf:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801fd4:	b8 07 00 00 00       	mov    $0x7,%eax
  801fd9:	e8 72 fe ff ff       	call   801e50 <nsipc>
  801fde:	89 c3                	mov    %eax,%ebx
  801fe0:	85 c0                	test   %eax,%eax
  801fe2:	78 1f                	js     802003 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801fe4:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801fe9:	7f 21                	jg     80200c <nsipc_recv+0x56>
  801feb:	39 c6                	cmp    %eax,%esi
  801fed:	7c 1d                	jl     80200c <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801fef:	83 ec 04             	sub    $0x4,%esp
  801ff2:	50                   	push   %eax
  801ff3:	68 00 60 80 00       	push   $0x806000
  801ff8:	ff 75 0c             	pushl  0xc(%ebp)
  801ffb:	e8 aa ed ff ff       	call   800daa <memmove>
  802000:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802003:	89 d8                	mov    %ebx,%eax
  802005:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802008:	5b                   	pop    %ebx
  802009:	5e                   	pop    %esi
  80200a:	5d                   	pop    %ebp
  80200b:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80200c:	68 f7 2c 80 00       	push   $0x802cf7
  802011:	68 bf 2c 80 00       	push   $0x802cbf
  802016:	6a 62                	push   $0x62
  802018:	68 0c 2d 80 00       	push   $0x802d0c
  80201d:	e8 b5 e2 ff ff       	call   8002d7 <_panic>

00802022 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802022:	55                   	push   %ebp
  802023:	89 e5                	mov    %esp,%ebp
  802025:	53                   	push   %ebx
  802026:	83 ec 04             	sub    $0x4,%esp
  802029:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80202c:	8b 45 08             	mov    0x8(%ebp),%eax
  80202f:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  802034:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80203a:	7f 2e                	jg     80206a <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80203c:	83 ec 04             	sub    $0x4,%esp
  80203f:	53                   	push   %ebx
  802040:	ff 75 0c             	pushl  0xc(%ebp)
  802043:	68 0c 60 80 00       	push   $0x80600c
  802048:	e8 5d ed ff ff       	call   800daa <memmove>
	nsipcbuf.send.req_size = size;
  80204d:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  802053:	8b 45 14             	mov    0x14(%ebp),%eax
  802056:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  80205b:	b8 08 00 00 00       	mov    $0x8,%eax
  802060:	e8 eb fd ff ff       	call   801e50 <nsipc>
}
  802065:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802068:	c9                   	leave  
  802069:	c3                   	ret    
	assert(size < 1600);
  80206a:	68 18 2d 80 00       	push   $0x802d18
  80206f:	68 bf 2c 80 00       	push   $0x802cbf
  802074:	6a 6d                	push   $0x6d
  802076:	68 0c 2d 80 00       	push   $0x802d0c
  80207b:	e8 57 e2 ff ff       	call   8002d7 <_panic>

00802080 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802080:	55                   	push   %ebp
  802081:	89 e5                	mov    %esp,%ebp
  802083:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802086:	8b 45 08             	mov    0x8(%ebp),%eax
  802089:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  80208e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802091:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  802096:	8b 45 10             	mov    0x10(%ebp),%eax
  802099:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  80209e:	b8 09 00 00 00       	mov    $0x9,%eax
  8020a3:	e8 a8 fd ff ff       	call   801e50 <nsipc>
}
  8020a8:	c9                   	leave  
  8020a9:	c3                   	ret    

008020aa <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8020aa:	55                   	push   %ebp
  8020ab:	89 e5                	mov    %esp,%ebp
  8020ad:	56                   	push   %esi
  8020ae:	53                   	push   %ebx
  8020af:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8020b2:	83 ec 0c             	sub    $0xc,%esp
  8020b5:	ff 75 08             	pushl  0x8(%ebp)
  8020b8:	e8 56 f2 ff ff       	call   801313 <fd2data>
  8020bd:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8020bf:	83 c4 08             	add    $0x8,%esp
  8020c2:	68 24 2d 80 00       	push   $0x802d24
  8020c7:	53                   	push   %ebx
  8020c8:	e8 4f eb ff ff       	call   800c1c <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8020cd:	8b 46 04             	mov    0x4(%esi),%eax
  8020d0:	2b 06                	sub    (%esi),%eax
  8020d2:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8020d8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8020df:	00 00 00 
	stat->st_dev = &devpipe;
  8020e2:	c7 83 88 00 00 00 58 	movl   $0x803058,0x88(%ebx)
  8020e9:	30 80 00 
	return 0;
}
  8020ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020f4:	5b                   	pop    %ebx
  8020f5:	5e                   	pop    %esi
  8020f6:	5d                   	pop    %ebp
  8020f7:	c3                   	ret    

008020f8 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8020f8:	55                   	push   %ebp
  8020f9:	89 e5                	mov    %esp,%ebp
  8020fb:	53                   	push   %ebx
  8020fc:	83 ec 0c             	sub    $0xc,%esp
  8020ff:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802102:	53                   	push   %ebx
  802103:	6a 00                	push   $0x0
  802105:	e8 89 ef ff ff       	call   801093 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80210a:	89 1c 24             	mov    %ebx,(%esp)
  80210d:	e8 01 f2 ff ff       	call   801313 <fd2data>
  802112:	83 c4 08             	add    $0x8,%esp
  802115:	50                   	push   %eax
  802116:	6a 00                	push   $0x0
  802118:	e8 76 ef ff ff       	call   801093 <sys_page_unmap>
}
  80211d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802120:	c9                   	leave  
  802121:	c3                   	ret    

00802122 <_pipeisclosed>:
{
  802122:	55                   	push   %ebp
  802123:	89 e5                	mov    %esp,%ebp
  802125:	57                   	push   %edi
  802126:	56                   	push   %esi
  802127:	53                   	push   %ebx
  802128:	83 ec 1c             	sub    $0x1c,%esp
  80212b:	89 c7                	mov    %eax,%edi
  80212d:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80212f:	a1 08 44 80 00       	mov    0x804408,%eax
  802134:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802137:	83 ec 0c             	sub    $0xc,%esp
  80213a:	57                   	push   %edi
  80213b:	e8 b8 03 00 00       	call   8024f8 <pageref>
  802140:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802143:	89 34 24             	mov    %esi,(%esp)
  802146:	e8 ad 03 00 00       	call   8024f8 <pageref>
		nn = thisenv->env_runs;
  80214b:	8b 15 08 44 80 00    	mov    0x804408,%edx
  802151:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802154:	83 c4 10             	add    $0x10,%esp
  802157:	39 cb                	cmp    %ecx,%ebx
  802159:	74 1b                	je     802176 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80215b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80215e:	75 cf                	jne    80212f <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802160:	8b 42 58             	mov    0x58(%edx),%eax
  802163:	6a 01                	push   $0x1
  802165:	50                   	push   %eax
  802166:	53                   	push   %ebx
  802167:	68 2b 2d 80 00       	push   $0x802d2b
  80216c:	e8 5c e2 ff ff       	call   8003cd <cprintf>
  802171:	83 c4 10             	add    $0x10,%esp
  802174:	eb b9                	jmp    80212f <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802176:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802179:	0f 94 c0             	sete   %al
  80217c:	0f b6 c0             	movzbl %al,%eax
}
  80217f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802182:	5b                   	pop    %ebx
  802183:	5e                   	pop    %esi
  802184:	5f                   	pop    %edi
  802185:	5d                   	pop    %ebp
  802186:	c3                   	ret    

00802187 <devpipe_write>:
{
  802187:	55                   	push   %ebp
  802188:	89 e5                	mov    %esp,%ebp
  80218a:	57                   	push   %edi
  80218b:	56                   	push   %esi
  80218c:	53                   	push   %ebx
  80218d:	83 ec 28             	sub    $0x28,%esp
  802190:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802193:	56                   	push   %esi
  802194:	e8 7a f1 ff ff       	call   801313 <fd2data>
  802199:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80219b:	83 c4 10             	add    $0x10,%esp
  80219e:	bf 00 00 00 00       	mov    $0x0,%edi
  8021a3:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8021a6:	74 4f                	je     8021f7 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8021a8:	8b 43 04             	mov    0x4(%ebx),%eax
  8021ab:	8b 0b                	mov    (%ebx),%ecx
  8021ad:	8d 51 20             	lea    0x20(%ecx),%edx
  8021b0:	39 d0                	cmp    %edx,%eax
  8021b2:	72 14                	jb     8021c8 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8021b4:	89 da                	mov    %ebx,%edx
  8021b6:	89 f0                	mov    %esi,%eax
  8021b8:	e8 65 ff ff ff       	call   802122 <_pipeisclosed>
  8021bd:	85 c0                	test   %eax,%eax
  8021bf:	75 3b                	jne    8021fc <devpipe_write+0x75>
			sys_yield();
  8021c1:	e8 29 ee ff ff       	call   800fef <sys_yield>
  8021c6:	eb e0                	jmp    8021a8 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8021c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8021cb:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8021cf:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8021d2:	89 c2                	mov    %eax,%edx
  8021d4:	c1 fa 1f             	sar    $0x1f,%edx
  8021d7:	89 d1                	mov    %edx,%ecx
  8021d9:	c1 e9 1b             	shr    $0x1b,%ecx
  8021dc:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8021df:	83 e2 1f             	and    $0x1f,%edx
  8021e2:	29 ca                	sub    %ecx,%edx
  8021e4:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8021e8:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8021ec:	83 c0 01             	add    $0x1,%eax
  8021ef:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8021f2:	83 c7 01             	add    $0x1,%edi
  8021f5:	eb ac                	jmp    8021a3 <devpipe_write+0x1c>
	return i;
  8021f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8021fa:	eb 05                	jmp    802201 <devpipe_write+0x7a>
				return 0;
  8021fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802201:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802204:	5b                   	pop    %ebx
  802205:	5e                   	pop    %esi
  802206:	5f                   	pop    %edi
  802207:	5d                   	pop    %ebp
  802208:	c3                   	ret    

00802209 <devpipe_read>:
{
  802209:	55                   	push   %ebp
  80220a:	89 e5                	mov    %esp,%ebp
  80220c:	57                   	push   %edi
  80220d:	56                   	push   %esi
  80220e:	53                   	push   %ebx
  80220f:	83 ec 18             	sub    $0x18,%esp
  802212:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802215:	57                   	push   %edi
  802216:	e8 f8 f0 ff ff       	call   801313 <fd2data>
  80221b:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80221d:	83 c4 10             	add    $0x10,%esp
  802220:	be 00 00 00 00       	mov    $0x0,%esi
  802225:	3b 75 10             	cmp    0x10(%ebp),%esi
  802228:	75 14                	jne    80223e <devpipe_read+0x35>
	return i;
  80222a:	8b 45 10             	mov    0x10(%ebp),%eax
  80222d:	eb 02                	jmp    802231 <devpipe_read+0x28>
				return i;
  80222f:	89 f0                	mov    %esi,%eax
}
  802231:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802234:	5b                   	pop    %ebx
  802235:	5e                   	pop    %esi
  802236:	5f                   	pop    %edi
  802237:	5d                   	pop    %ebp
  802238:	c3                   	ret    
			sys_yield();
  802239:	e8 b1 ed ff ff       	call   800fef <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80223e:	8b 03                	mov    (%ebx),%eax
  802240:	3b 43 04             	cmp    0x4(%ebx),%eax
  802243:	75 18                	jne    80225d <devpipe_read+0x54>
			if (i > 0)
  802245:	85 f6                	test   %esi,%esi
  802247:	75 e6                	jne    80222f <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802249:	89 da                	mov    %ebx,%edx
  80224b:	89 f8                	mov    %edi,%eax
  80224d:	e8 d0 fe ff ff       	call   802122 <_pipeisclosed>
  802252:	85 c0                	test   %eax,%eax
  802254:	74 e3                	je     802239 <devpipe_read+0x30>
				return 0;
  802256:	b8 00 00 00 00       	mov    $0x0,%eax
  80225b:	eb d4                	jmp    802231 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80225d:	99                   	cltd   
  80225e:	c1 ea 1b             	shr    $0x1b,%edx
  802261:	01 d0                	add    %edx,%eax
  802263:	83 e0 1f             	and    $0x1f,%eax
  802266:	29 d0                	sub    %edx,%eax
  802268:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80226d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802270:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802273:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802276:	83 c6 01             	add    $0x1,%esi
  802279:	eb aa                	jmp    802225 <devpipe_read+0x1c>

0080227b <pipe>:
{
  80227b:	55                   	push   %ebp
  80227c:	89 e5                	mov    %esp,%ebp
  80227e:	56                   	push   %esi
  80227f:	53                   	push   %ebx
  802280:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802283:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802286:	50                   	push   %eax
  802287:	e8 9e f0 ff ff       	call   80132a <fd_alloc>
  80228c:	89 c3                	mov    %eax,%ebx
  80228e:	83 c4 10             	add    $0x10,%esp
  802291:	85 c0                	test   %eax,%eax
  802293:	0f 88 23 01 00 00    	js     8023bc <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802299:	83 ec 04             	sub    $0x4,%esp
  80229c:	68 07 04 00 00       	push   $0x407
  8022a1:	ff 75 f4             	pushl  -0xc(%ebp)
  8022a4:	6a 00                	push   $0x0
  8022a6:	e8 63 ed ff ff       	call   80100e <sys_page_alloc>
  8022ab:	89 c3                	mov    %eax,%ebx
  8022ad:	83 c4 10             	add    $0x10,%esp
  8022b0:	85 c0                	test   %eax,%eax
  8022b2:	0f 88 04 01 00 00    	js     8023bc <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8022b8:	83 ec 0c             	sub    $0xc,%esp
  8022bb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8022be:	50                   	push   %eax
  8022bf:	e8 66 f0 ff ff       	call   80132a <fd_alloc>
  8022c4:	89 c3                	mov    %eax,%ebx
  8022c6:	83 c4 10             	add    $0x10,%esp
  8022c9:	85 c0                	test   %eax,%eax
  8022cb:	0f 88 db 00 00 00    	js     8023ac <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022d1:	83 ec 04             	sub    $0x4,%esp
  8022d4:	68 07 04 00 00       	push   $0x407
  8022d9:	ff 75 f0             	pushl  -0x10(%ebp)
  8022dc:	6a 00                	push   $0x0
  8022de:	e8 2b ed ff ff       	call   80100e <sys_page_alloc>
  8022e3:	89 c3                	mov    %eax,%ebx
  8022e5:	83 c4 10             	add    $0x10,%esp
  8022e8:	85 c0                	test   %eax,%eax
  8022ea:	0f 88 bc 00 00 00    	js     8023ac <pipe+0x131>
	va = fd2data(fd0);
  8022f0:	83 ec 0c             	sub    $0xc,%esp
  8022f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8022f6:	e8 18 f0 ff ff       	call   801313 <fd2data>
  8022fb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022fd:	83 c4 0c             	add    $0xc,%esp
  802300:	68 07 04 00 00       	push   $0x407
  802305:	50                   	push   %eax
  802306:	6a 00                	push   $0x0
  802308:	e8 01 ed ff ff       	call   80100e <sys_page_alloc>
  80230d:	89 c3                	mov    %eax,%ebx
  80230f:	83 c4 10             	add    $0x10,%esp
  802312:	85 c0                	test   %eax,%eax
  802314:	0f 88 82 00 00 00    	js     80239c <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80231a:	83 ec 0c             	sub    $0xc,%esp
  80231d:	ff 75 f0             	pushl  -0x10(%ebp)
  802320:	e8 ee ef ff ff       	call   801313 <fd2data>
  802325:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80232c:	50                   	push   %eax
  80232d:	6a 00                	push   $0x0
  80232f:	56                   	push   %esi
  802330:	6a 00                	push   $0x0
  802332:	e8 1a ed ff ff       	call   801051 <sys_page_map>
  802337:	89 c3                	mov    %eax,%ebx
  802339:	83 c4 20             	add    $0x20,%esp
  80233c:	85 c0                	test   %eax,%eax
  80233e:	78 4e                	js     80238e <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802340:	a1 58 30 80 00       	mov    0x803058,%eax
  802345:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802348:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80234a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80234d:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802354:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802357:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802359:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80235c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802363:	83 ec 0c             	sub    $0xc,%esp
  802366:	ff 75 f4             	pushl  -0xc(%ebp)
  802369:	e8 95 ef ff ff       	call   801303 <fd2num>
  80236e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802371:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802373:	83 c4 04             	add    $0x4,%esp
  802376:	ff 75 f0             	pushl  -0x10(%ebp)
  802379:	e8 85 ef ff ff       	call   801303 <fd2num>
  80237e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802381:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802384:	83 c4 10             	add    $0x10,%esp
  802387:	bb 00 00 00 00       	mov    $0x0,%ebx
  80238c:	eb 2e                	jmp    8023bc <pipe+0x141>
	sys_page_unmap(0, va);
  80238e:	83 ec 08             	sub    $0x8,%esp
  802391:	56                   	push   %esi
  802392:	6a 00                	push   $0x0
  802394:	e8 fa ec ff ff       	call   801093 <sys_page_unmap>
  802399:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80239c:	83 ec 08             	sub    $0x8,%esp
  80239f:	ff 75 f0             	pushl  -0x10(%ebp)
  8023a2:	6a 00                	push   $0x0
  8023a4:	e8 ea ec ff ff       	call   801093 <sys_page_unmap>
  8023a9:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8023ac:	83 ec 08             	sub    $0x8,%esp
  8023af:	ff 75 f4             	pushl  -0xc(%ebp)
  8023b2:	6a 00                	push   $0x0
  8023b4:	e8 da ec ff ff       	call   801093 <sys_page_unmap>
  8023b9:	83 c4 10             	add    $0x10,%esp
}
  8023bc:	89 d8                	mov    %ebx,%eax
  8023be:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023c1:	5b                   	pop    %ebx
  8023c2:	5e                   	pop    %esi
  8023c3:	5d                   	pop    %ebp
  8023c4:	c3                   	ret    

008023c5 <pipeisclosed>:
{
  8023c5:	55                   	push   %ebp
  8023c6:	89 e5                	mov    %esp,%ebp
  8023c8:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023ce:	50                   	push   %eax
  8023cf:	ff 75 08             	pushl  0x8(%ebp)
  8023d2:	e8 a5 ef ff ff       	call   80137c <fd_lookup>
  8023d7:	83 c4 10             	add    $0x10,%esp
  8023da:	85 c0                	test   %eax,%eax
  8023dc:	78 18                	js     8023f6 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8023de:	83 ec 0c             	sub    $0xc,%esp
  8023e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8023e4:	e8 2a ef ff ff       	call   801313 <fd2data>
	return _pipeisclosed(fd, p);
  8023e9:	89 c2                	mov    %eax,%edx
  8023eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ee:	e8 2f fd ff ff       	call   802122 <_pipeisclosed>
  8023f3:	83 c4 10             	add    $0x10,%esp
}
  8023f6:	c9                   	leave  
  8023f7:	c3                   	ret    

008023f8 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8023f8:	55                   	push   %ebp
  8023f9:	89 e5                	mov    %esp,%ebp
  8023fb:	56                   	push   %esi
  8023fc:	53                   	push   %ebx
  8023fd:	8b 75 08             	mov    0x8(%ebp),%esi
  802400:	8b 45 0c             	mov    0xc(%ebp),%eax
  802403:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802406:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802408:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80240d:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802410:	83 ec 0c             	sub    $0xc,%esp
  802413:	50                   	push   %eax
  802414:	e8 a5 ed ff ff       	call   8011be <sys_ipc_recv>
	if(ret < 0){
  802419:	83 c4 10             	add    $0x10,%esp
  80241c:	85 c0                	test   %eax,%eax
  80241e:	78 2b                	js     80244b <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802420:	85 f6                	test   %esi,%esi
  802422:	74 0a                	je     80242e <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802424:	a1 08 44 80 00       	mov    0x804408,%eax
  802429:	8b 40 78             	mov    0x78(%eax),%eax
  80242c:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80242e:	85 db                	test   %ebx,%ebx
  802430:	74 0a                	je     80243c <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802432:	a1 08 44 80 00       	mov    0x804408,%eax
  802437:	8b 40 7c             	mov    0x7c(%eax),%eax
  80243a:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  80243c:	a1 08 44 80 00       	mov    0x804408,%eax
  802441:	8b 40 74             	mov    0x74(%eax),%eax
}
  802444:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802447:	5b                   	pop    %ebx
  802448:	5e                   	pop    %esi
  802449:	5d                   	pop    %ebp
  80244a:	c3                   	ret    
		if(from_env_store)
  80244b:	85 f6                	test   %esi,%esi
  80244d:	74 06                	je     802455 <ipc_recv+0x5d>
			*from_env_store = 0;
  80244f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802455:	85 db                	test   %ebx,%ebx
  802457:	74 eb                	je     802444 <ipc_recv+0x4c>
			*perm_store = 0;
  802459:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80245f:	eb e3                	jmp    802444 <ipc_recv+0x4c>

00802461 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802461:	55                   	push   %ebp
  802462:	89 e5                	mov    %esp,%ebp
  802464:	57                   	push   %edi
  802465:	56                   	push   %esi
  802466:	53                   	push   %ebx
  802467:	83 ec 0c             	sub    $0xc,%esp
  80246a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80246d:	8b 75 0c             	mov    0xc(%ebp),%esi
  802470:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802473:	85 db                	test   %ebx,%ebx
  802475:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80247a:	0f 44 d8             	cmove  %eax,%ebx
  80247d:	eb 05                	jmp    802484 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80247f:	e8 6b eb ff ff       	call   800fef <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802484:	ff 75 14             	pushl  0x14(%ebp)
  802487:	53                   	push   %ebx
  802488:	56                   	push   %esi
  802489:	57                   	push   %edi
  80248a:	e8 0c ed ff ff       	call   80119b <sys_ipc_try_send>
  80248f:	83 c4 10             	add    $0x10,%esp
  802492:	85 c0                	test   %eax,%eax
  802494:	74 1b                	je     8024b1 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802496:	79 e7                	jns    80247f <ipc_send+0x1e>
  802498:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80249b:	74 e2                	je     80247f <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80249d:	83 ec 04             	sub    $0x4,%esp
  8024a0:	68 43 2d 80 00       	push   $0x802d43
  8024a5:	6a 46                	push   $0x46
  8024a7:	68 58 2d 80 00       	push   $0x802d58
  8024ac:	e8 26 de ff ff       	call   8002d7 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8024b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024b4:	5b                   	pop    %ebx
  8024b5:	5e                   	pop    %esi
  8024b6:	5f                   	pop    %edi
  8024b7:	5d                   	pop    %ebp
  8024b8:	c3                   	ret    

008024b9 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8024b9:	55                   	push   %ebp
  8024ba:	89 e5                	mov    %esp,%ebp
  8024bc:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8024bf:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8024c4:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  8024ca:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8024d0:	8b 52 50             	mov    0x50(%edx),%edx
  8024d3:	39 ca                	cmp    %ecx,%edx
  8024d5:	74 11                	je     8024e8 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8024d7:	83 c0 01             	add    $0x1,%eax
  8024da:	3d 00 04 00 00       	cmp    $0x400,%eax
  8024df:	75 e3                	jne    8024c4 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8024e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e6:	eb 0e                	jmp    8024f6 <ipc_find_env+0x3d>
			return envs[i].env_id;
  8024e8:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8024ee:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8024f3:	8b 40 48             	mov    0x48(%eax),%eax
}
  8024f6:	5d                   	pop    %ebp
  8024f7:	c3                   	ret    

008024f8 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8024f8:	55                   	push   %ebp
  8024f9:	89 e5                	mov    %esp,%ebp
  8024fb:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8024fe:	89 d0                	mov    %edx,%eax
  802500:	c1 e8 16             	shr    $0x16,%eax
  802503:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80250a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80250f:	f6 c1 01             	test   $0x1,%cl
  802512:	74 1d                	je     802531 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802514:	c1 ea 0c             	shr    $0xc,%edx
  802517:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80251e:	f6 c2 01             	test   $0x1,%dl
  802521:	74 0e                	je     802531 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802523:	c1 ea 0c             	shr    $0xc,%edx
  802526:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80252d:	ef 
  80252e:	0f b7 c0             	movzwl %ax,%eax
}
  802531:	5d                   	pop    %ebp
  802532:	c3                   	ret    
  802533:	66 90                	xchg   %ax,%ax
  802535:	66 90                	xchg   %ax,%ax
  802537:	66 90                	xchg   %ax,%ax
  802539:	66 90                	xchg   %ax,%ax
  80253b:	66 90                	xchg   %ax,%ax
  80253d:	66 90                	xchg   %ax,%ax
  80253f:	90                   	nop

00802540 <__udivdi3>:
  802540:	55                   	push   %ebp
  802541:	57                   	push   %edi
  802542:	56                   	push   %esi
  802543:	53                   	push   %ebx
  802544:	83 ec 1c             	sub    $0x1c,%esp
  802547:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80254b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80254f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802553:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802557:	85 d2                	test   %edx,%edx
  802559:	75 4d                	jne    8025a8 <__udivdi3+0x68>
  80255b:	39 f3                	cmp    %esi,%ebx
  80255d:	76 19                	jbe    802578 <__udivdi3+0x38>
  80255f:	31 ff                	xor    %edi,%edi
  802561:	89 e8                	mov    %ebp,%eax
  802563:	89 f2                	mov    %esi,%edx
  802565:	f7 f3                	div    %ebx
  802567:	89 fa                	mov    %edi,%edx
  802569:	83 c4 1c             	add    $0x1c,%esp
  80256c:	5b                   	pop    %ebx
  80256d:	5e                   	pop    %esi
  80256e:	5f                   	pop    %edi
  80256f:	5d                   	pop    %ebp
  802570:	c3                   	ret    
  802571:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802578:	89 d9                	mov    %ebx,%ecx
  80257a:	85 db                	test   %ebx,%ebx
  80257c:	75 0b                	jne    802589 <__udivdi3+0x49>
  80257e:	b8 01 00 00 00       	mov    $0x1,%eax
  802583:	31 d2                	xor    %edx,%edx
  802585:	f7 f3                	div    %ebx
  802587:	89 c1                	mov    %eax,%ecx
  802589:	31 d2                	xor    %edx,%edx
  80258b:	89 f0                	mov    %esi,%eax
  80258d:	f7 f1                	div    %ecx
  80258f:	89 c6                	mov    %eax,%esi
  802591:	89 e8                	mov    %ebp,%eax
  802593:	89 f7                	mov    %esi,%edi
  802595:	f7 f1                	div    %ecx
  802597:	89 fa                	mov    %edi,%edx
  802599:	83 c4 1c             	add    $0x1c,%esp
  80259c:	5b                   	pop    %ebx
  80259d:	5e                   	pop    %esi
  80259e:	5f                   	pop    %edi
  80259f:	5d                   	pop    %ebp
  8025a0:	c3                   	ret    
  8025a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025a8:	39 f2                	cmp    %esi,%edx
  8025aa:	77 1c                	ja     8025c8 <__udivdi3+0x88>
  8025ac:	0f bd fa             	bsr    %edx,%edi
  8025af:	83 f7 1f             	xor    $0x1f,%edi
  8025b2:	75 2c                	jne    8025e0 <__udivdi3+0xa0>
  8025b4:	39 f2                	cmp    %esi,%edx
  8025b6:	72 06                	jb     8025be <__udivdi3+0x7e>
  8025b8:	31 c0                	xor    %eax,%eax
  8025ba:	39 eb                	cmp    %ebp,%ebx
  8025bc:	77 a9                	ja     802567 <__udivdi3+0x27>
  8025be:	b8 01 00 00 00       	mov    $0x1,%eax
  8025c3:	eb a2                	jmp    802567 <__udivdi3+0x27>
  8025c5:	8d 76 00             	lea    0x0(%esi),%esi
  8025c8:	31 ff                	xor    %edi,%edi
  8025ca:	31 c0                	xor    %eax,%eax
  8025cc:	89 fa                	mov    %edi,%edx
  8025ce:	83 c4 1c             	add    $0x1c,%esp
  8025d1:	5b                   	pop    %ebx
  8025d2:	5e                   	pop    %esi
  8025d3:	5f                   	pop    %edi
  8025d4:	5d                   	pop    %ebp
  8025d5:	c3                   	ret    
  8025d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025dd:	8d 76 00             	lea    0x0(%esi),%esi
  8025e0:	89 f9                	mov    %edi,%ecx
  8025e2:	b8 20 00 00 00       	mov    $0x20,%eax
  8025e7:	29 f8                	sub    %edi,%eax
  8025e9:	d3 e2                	shl    %cl,%edx
  8025eb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8025ef:	89 c1                	mov    %eax,%ecx
  8025f1:	89 da                	mov    %ebx,%edx
  8025f3:	d3 ea                	shr    %cl,%edx
  8025f5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8025f9:	09 d1                	or     %edx,%ecx
  8025fb:	89 f2                	mov    %esi,%edx
  8025fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802601:	89 f9                	mov    %edi,%ecx
  802603:	d3 e3                	shl    %cl,%ebx
  802605:	89 c1                	mov    %eax,%ecx
  802607:	d3 ea                	shr    %cl,%edx
  802609:	89 f9                	mov    %edi,%ecx
  80260b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80260f:	89 eb                	mov    %ebp,%ebx
  802611:	d3 e6                	shl    %cl,%esi
  802613:	89 c1                	mov    %eax,%ecx
  802615:	d3 eb                	shr    %cl,%ebx
  802617:	09 de                	or     %ebx,%esi
  802619:	89 f0                	mov    %esi,%eax
  80261b:	f7 74 24 08          	divl   0x8(%esp)
  80261f:	89 d6                	mov    %edx,%esi
  802621:	89 c3                	mov    %eax,%ebx
  802623:	f7 64 24 0c          	mull   0xc(%esp)
  802627:	39 d6                	cmp    %edx,%esi
  802629:	72 15                	jb     802640 <__udivdi3+0x100>
  80262b:	89 f9                	mov    %edi,%ecx
  80262d:	d3 e5                	shl    %cl,%ebp
  80262f:	39 c5                	cmp    %eax,%ebp
  802631:	73 04                	jae    802637 <__udivdi3+0xf7>
  802633:	39 d6                	cmp    %edx,%esi
  802635:	74 09                	je     802640 <__udivdi3+0x100>
  802637:	89 d8                	mov    %ebx,%eax
  802639:	31 ff                	xor    %edi,%edi
  80263b:	e9 27 ff ff ff       	jmp    802567 <__udivdi3+0x27>
  802640:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802643:	31 ff                	xor    %edi,%edi
  802645:	e9 1d ff ff ff       	jmp    802567 <__udivdi3+0x27>
  80264a:	66 90                	xchg   %ax,%ax
  80264c:	66 90                	xchg   %ax,%ax
  80264e:	66 90                	xchg   %ax,%ax

00802650 <__umoddi3>:
  802650:	55                   	push   %ebp
  802651:	57                   	push   %edi
  802652:	56                   	push   %esi
  802653:	53                   	push   %ebx
  802654:	83 ec 1c             	sub    $0x1c,%esp
  802657:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80265b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80265f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802663:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802667:	89 da                	mov    %ebx,%edx
  802669:	85 c0                	test   %eax,%eax
  80266b:	75 43                	jne    8026b0 <__umoddi3+0x60>
  80266d:	39 df                	cmp    %ebx,%edi
  80266f:	76 17                	jbe    802688 <__umoddi3+0x38>
  802671:	89 f0                	mov    %esi,%eax
  802673:	f7 f7                	div    %edi
  802675:	89 d0                	mov    %edx,%eax
  802677:	31 d2                	xor    %edx,%edx
  802679:	83 c4 1c             	add    $0x1c,%esp
  80267c:	5b                   	pop    %ebx
  80267d:	5e                   	pop    %esi
  80267e:	5f                   	pop    %edi
  80267f:	5d                   	pop    %ebp
  802680:	c3                   	ret    
  802681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802688:	89 fd                	mov    %edi,%ebp
  80268a:	85 ff                	test   %edi,%edi
  80268c:	75 0b                	jne    802699 <__umoddi3+0x49>
  80268e:	b8 01 00 00 00       	mov    $0x1,%eax
  802693:	31 d2                	xor    %edx,%edx
  802695:	f7 f7                	div    %edi
  802697:	89 c5                	mov    %eax,%ebp
  802699:	89 d8                	mov    %ebx,%eax
  80269b:	31 d2                	xor    %edx,%edx
  80269d:	f7 f5                	div    %ebp
  80269f:	89 f0                	mov    %esi,%eax
  8026a1:	f7 f5                	div    %ebp
  8026a3:	89 d0                	mov    %edx,%eax
  8026a5:	eb d0                	jmp    802677 <__umoddi3+0x27>
  8026a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026ae:	66 90                	xchg   %ax,%ax
  8026b0:	89 f1                	mov    %esi,%ecx
  8026b2:	39 d8                	cmp    %ebx,%eax
  8026b4:	76 0a                	jbe    8026c0 <__umoddi3+0x70>
  8026b6:	89 f0                	mov    %esi,%eax
  8026b8:	83 c4 1c             	add    $0x1c,%esp
  8026bb:	5b                   	pop    %ebx
  8026bc:	5e                   	pop    %esi
  8026bd:	5f                   	pop    %edi
  8026be:	5d                   	pop    %ebp
  8026bf:	c3                   	ret    
  8026c0:	0f bd e8             	bsr    %eax,%ebp
  8026c3:	83 f5 1f             	xor    $0x1f,%ebp
  8026c6:	75 20                	jne    8026e8 <__umoddi3+0x98>
  8026c8:	39 d8                	cmp    %ebx,%eax
  8026ca:	0f 82 b0 00 00 00    	jb     802780 <__umoddi3+0x130>
  8026d0:	39 f7                	cmp    %esi,%edi
  8026d2:	0f 86 a8 00 00 00    	jbe    802780 <__umoddi3+0x130>
  8026d8:	89 c8                	mov    %ecx,%eax
  8026da:	83 c4 1c             	add    $0x1c,%esp
  8026dd:	5b                   	pop    %ebx
  8026de:	5e                   	pop    %esi
  8026df:	5f                   	pop    %edi
  8026e0:	5d                   	pop    %ebp
  8026e1:	c3                   	ret    
  8026e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8026e8:	89 e9                	mov    %ebp,%ecx
  8026ea:	ba 20 00 00 00       	mov    $0x20,%edx
  8026ef:	29 ea                	sub    %ebp,%edx
  8026f1:	d3 e0                	shl    %cl,%eax
  8026f3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8026f7:	89 d1                	mov    %edx,%ecx
  8026f9:	89 f8                	mov    %edi,%eax
  8026fb:	d3 e8                	shr    %cl,%eax
  8026fd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802701:	89 54 24 04          	mov    %edx,0x4(%esp)
  802705:	8b 54 24 04          	mov    0x4(%esp),%edx
  802709:	09 c1                	or     %eax,%ecx
  80270b:	89 d8                	mov    %ebx,%eax
  80270d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802711:	89 e9                	mov    %ebp,%ecx
  802713:	d3 e7                	shl    %cl,%edi
  802715:	89 d1                	mov    %edx,%ecx
  802717:	d3 e8                	shr    %cl,%eax
  802719:	89 e9                	mov    %ebp,%ecx
  80271b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80271f:	d3 e3                	shl    %cl,%ebx
  802721:	89 c7                	mov    %eax,%edi
  802723:	89 d1                	mov    %edx,%ecx
  802725:	89 f0                	mov    %esi,%eax
  802727:	d3 e8                	shr    %cl,%eax
  802729:	89 e9                	mov    %ebp,%ecx
  80272b:	89 fa                	mov    %edi,%edx
  80272d:	d3 e6                	shl    %cl,%esi
  80272f:	09 d8                	or     %ebx,%eax
  802731:	f7 74 24 08          	divl   0x8(%esp)
  802735:	89 d1                	mov    %edx,%ecx
  802737:	89 f3                	mov    %esi,%ebx
  802739:	f7 64 24 0c          	mull   0xc(%esp)
  80273d:	89 c6                	mov    %eax,%esi
  80273f:	89 d7                	mov    %edx,%edi
  802741:	39 d1                	cmp    %edx,%ecx
  802743:	72 06                	jb     80274b <__umoddi3+0xfb>
  802745:	75 10                	jne    802757 <__umoddi3+0x107>
  802747:	39 c3                	cmp    %eax,%ebx
  802749:	73 0c                	jae    802757 <__umoddi3+0x107>
  80274b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80274f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802753:	89 d7                	mov    %edx,%edi
  802755:	89 c6                	mov    %eax,%esi
  802757:	89 ca                	mov    %ecx,%edx
  802759:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80275e:	29 f3                	sub    %esi,%ebx
  802760:	19 fa                	sbb    %edi,%edx
  802762:	89 d0                	mov    %edx,%eax
  802764:	d3 e0                	shl    %cl,%eax
  802766:	89 e9                	mov    %ebp,%ecx
  802768:	d3 eb                	shr    %cl,%ebx
  80276a:	d3 ea                	shr    %cl,%edx
  80276c:	09 d8                	or     %ebx,%eax
  80276e:	83 c4 1c             	add    $0x1c,%esp
  802771:	5b                   	pop    %ebx
  802772:	5e                   	pop    %esi
  802773:	5f                   	pop    %edi
  802774:	5d                   	pop    %ebp
  802775:	c3                   	ret    
  802776:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80277d:	8d 76 00             	lea    0x0(%esi),%esi
  802780:	89 da                	mov    %ebx,%edx
  802782:	29 fe                	sub    %edi,%esi
  802784:	19 c2                	sbb    %eax,%edx
  802786:	89 f1                	mov    %esi,%ecx
  802788:	89 c8                	mov    %ecx,%eax
  80278a:	e9 4b ff ff ff       	jmp    8026da <__umoddi3+0x8a>
