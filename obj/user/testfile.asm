
obj/user/testfile.debug:     file format elf32-i386


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
  80002c:	e8 83 06 00 00       	call   8006b4 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <xopen>:

#define FVA ((struct Fd*)0xCCCCC000)

static int
xopen(const char *path, int mode)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 0c             	sub    $0xc,%esp
  80003a:	89 d3                	mov    %edx,%ebx
	extern union Fsipc fsipcbuf;
	envid_t fsenv;
	
	strcpy(fsipcbuf.open.req_path, path);
  80003c:	50                   	push   %eax
  80003d:	68 00 60 80 00       	push   $0x806000
  800042:	e8 cf 0f 00 00       	call   801016 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800047:	89 1d 00 64 80 00    	mov    %ebx,0x806400

	fsenv = ipc_find_env(ENV_TYPE_FS);
  80004d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800054:	e8 45 17 00 00       	call   80179e <ipc_find_env>
	ipc_send(fsenv, FSREQ_OPEN, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800059:	6a 07                	push   $0x7
  80005b:	68 00 60 80 00       	push   $0x806000
  800060:	6a 01                	push   $0x1
  800062:	50                   	push   %eax
  800063:	e8 de 16 00 00       	call   801746 <ipc_send>
	return ipc_recv(NULL, FVA, NULL);
  800068:	83 c4 1c             	add    $0x1c,%esp
  80006b:	6a 00                	push   $0x0
  80006d:	68 00 c0 cc cc       	push   $0xccccc000
  800072:	6a 00                	push   $0x0
  800074:	e8 64 16 00 00       	call   8016dd <ipc_recv>
}
  800079:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80007c:	c9                   	leave  
  80007d:	c3                   	ret    

0080007e <umain>:

void
umain(int argc, char **argv)
{
  80007e:	55                   	push   %ebp
  80007f:	89 e5                	mov    %esp,%ebp
  800081:	57                   	push   %edi
  800082:	56                   	push   %esi
  800083:	53                   	push   %ebx
  800084:	81 ec ac 02 00 00    	sub    $0x2ac,%esp
	struct Fd fdcopy;
	struct Stat st;
	char buf[512];

	// We open files manually first, to avoid the FD layer
	if ((r = xopen("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  80008a:	ba 00 00 00 00       	mov    $0x0,%edx
  80008f:	b8 c0 2b 80 00       	mov    $0x802bc0,%eax
  800094:	e8 9a ff ff ff       	call   800033 <xopen>
  800099:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80009c:	74 08                	je     8000a6 <umain+0x28>
  80009e:	85 c0                	test   %eax,%eax
  8000a0:	0f 88 01 04 00 00    	js     8004a7 <umain+0x429>
		panic("serve_open /not-found: %e", r);
	else if (r >= 0)
  8000a6:	85 c0                	test   %eax,%eax
  8000a8:	0f 89 0b 04 00 00    	jns    8004b9 <umain+0x43b>
		panic("serve_open /not-found succeeded!");

	if ((r = xopen("/newmotd", O_RDONLY)) < 0)
  8000ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8000b3:	b8 f5 2b 80 00       	mov    $0x802bf5,%eax
  8000b8:	e8 76 ff ff ff       	call   800033 <xopen>
  8000bd:	85 c0                	test   %eax,%eax
  8000bf:	0f 88 08 04 00 00    	js     8004cd <umain+0x44f>
		panic("serve_open /newmotd: %e", r);
	if (FVA->fd_dev_id != 'f' || FVA->fd_offset != 0 || FVA->fd_omode != O_RDONLY)
  8000c5:	83 3d 00 c0 cc cc 66 	cmpl   $0x66,0xccccc000
  8000cc:	0f 85 0d 04 00 00    	jne    8004df <umain+0x461>
  8000d2:	83 3d 04 c0 cc cc 00 	cmpl   $0x0,0xccccc004
  8000d9:	0f 85 00 04 00 00    	jne    8004df <umain+0x461>
  8000df:	83 3d 08 c0 cc cc 00 	cmpl   $0x0,0xccccc008
  8000e6:	0f 85 f3 03 00 00    	jne    8004df <umain+0x461>
		panic("serve_open did not fill struct Fd correctly\n");
	cprintf("serve_open is good\n");
  8000ec:	83 ec 0c             	sub    $0xc,%esp
  8000ef:	68 16 2c 80 00       	push   $0x802c16
  8000f4:	e8 be 07 00 00       	call   8008b7 <cprintf>

	if ((r = devfile.dev_stat(FVA, &st)) < 0)
  8000f9:	83 c4 08             	add    $0x8,%esp
  8000fc:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  800102:	50                   	push   %eax
  800103:	68 00 c0 cc cc       	push   $0xccccc000
  800108:	ff 15 1c 40 80 00    	call   *0x80401c
  80010e:	83 c4 10             	add    $0x10,%esp
  800111:	85 c0                	test   %eax,%eax
  800113:	0f 88 da 03 00 00    	js     8004f3 <umain+0x475>
		panic("file_stat: %e", r);
	if (strlen(msg) != st.st_size)
  800119:	83 ec 0c             	sub    $0xc,%esp
  80011c:	ff 35 00 40 80 00    	pushl  0x804000
  800122:	e8 b6 0e 00 00       	call   800fdd <strlen>
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  80012d:	0f 85 d2 03 00 00    	jne    800505 <umain+0x487>
		panic("file_stat returned size %d wanted %d\n", st.st_size, strlen(msg));
	cprintf("file_stat is good\n");
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	68 38 2c 80 00       	push   $0x802c38
  80013b:	e8 77 07 00 00       	call   8008b7 <cprintf>

	memset(buf, 0, sizeof buf);
  800140:	83 c4 0c             	add    $0xc,%esp
  800143:	68 00 02 00 00       	push   $0x200
  800148:	6a 00                	push   $0x0
  80014a:	8d 9d 4c fd ff ff    	lea    -0x2b4(%ebp),%ebx
  800150:	53                   	push   %ebx
  800151:	e8 06 10 00 00       	call   80115c <memset>
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  800156:	83 c4 0c             	add    $0xc,%esp
  800159:	68 00 02 00 00       	push   $0x200
  80015e:	53                   	push   %ebx
  80015f:	68 00 c0 cc cc       	push   $0xccccc000
  800164:	ff 15 10 40 80 00    	call   *0x804010
  80016a:	83 c4 10             	add    $0x10,%esp
  80016d:	85 c0                	test   %eax,%eax
  80016f:	0f 88 b5 03 00 00    	js     80052a <umain+0x4ac>
		panic("file_read: %e", r);
	if (strcmp(buf, msg) != 0)
  800175:	83 ec 08             	sub    $0x8,%esp
  800178:	ff 35 00 40 80 00    	pushl  0x804000
  80017e:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  800184:	50                   	push   %eax
  800185:	e8 37 0f 00 00       	call   8010c1 <strcmp>
  80018a:	83 c4 10             	add    $0x10,%esp
  80018d:	85 c0                	test   %eax,%eax
  80018f:	0f 85 a7 03 00 00    	jne    80053c <umain+0x4be>
		panic("file_read returned wrong data");
	cprintf("file_read is good\n");
  800195:	83 ec 0c             	sub    $0xc,%esp
  800198:	68 77 2c 80 00       	push   $0x802c77
  80019d:	e8 15 07 00 00       	call   8008b7 <cprintf>

	if ((r = devfile.dev_close(FVA)) < 0)
  8001a2:	c7 04 24 00 c0 cc cc 	movl   $0xccccc000,(%esp)
  8001a9:	ff 15 18 40 80 00    	call   *0x804018
  8001af:	83 c4 10             	add    $0x10,%esp
  8001b2:	85 c0                	test   %eax,%eax
  8001b4:	0f 88 96 03 00 00    	js     800550 <umain+0x4d2>
		panic("file_close: %e", r);
	cprintf("file_close is good\n");
  8001ba:	83 ec 0c             	sub    $0xc,%esp
  8001bd:	68 99 2c 80 00       	push   $0x802c99
  8001c2:	e8 f0 06 00 00       	call   8008b7 <cprintf>

	// We're about to unmap the FD, but still need a way to get
	// the stale filenum to serve_read, so we make a local copy.
	// The file server won't think it's stale until we unmap the
	// FD page.
	fdcopy = *FVA;
  8001c7:	a1 00 c0 cc cc       	mov    0xccccc000,%eax
  8001cc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001cf:	a1 04 c0 cc cc       	mov    0xccccc004,%eax
  8001d4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8001d7:	a1 08 c0 cc cc       	mov    0xccccc008,%eax
  8001dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001df:	a1 0c c0 cc cc       	mov    0xccccc00c,%eax
  8001e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	sys_page_unmap(0, FVA);
  8001e7:	83 c4 08             	add    $0x8,%esp
  8001ea:	68 00 c0 cc cc       	push   $0xccccc000
  8001ef:	6a 00                	push   $0x0
  8001f1:	e8 97 12 00 00       	call   80148d <sys_page_unmap>

	cprintf("%d: before dev_read!!\n", thisenv->env_id);
  8001f6:	a1 08 50 80 00       	mov    0x805008,%eax
  8001fb:	8b 40 48             	mov    0x48(%eax),%eax
  8001fe:	83 c4 08             	add    $0x8,%esp
  800201:	50                   	push   %eax
  800202:	68 ad 2c 80 00       	push   $0x802cad
  800207:	e8 ab 06 00 00       	call   8008b7 <cprintf>
	if ((r = devfile.dev_read(&fdcopy, buf, sizeof buf)) != -E_INVAL){
  80020c:	83 c4 0c             	add    $0xc,%esp
  80020f:	68 00 02 00 00       	push   $0x200
  800214:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  80021a:	50                   	push   %eax
  80021b:	8d 45 d8             	lea    -0x28(%ebp),%eax
  80021e:	50                   	push   %eax
  80021f:	ff 15 10 40 80 00    	call   *0x804010
  800225:	89 c3                	mov    %eax,%ebx
  800227:	83 c4 10             	add    $0x10,%esp
  80022a:	83 f8 fd             	cmp    $0xfffffffd,%eax
  80022d:	0f 85 2f 03 00 00    	jne    800562 <umain+0x4e4>
		cprintf("%d: after dev_read!! the r: %d\n", thisenv->env_id, r);
		panic("serve_read does not handle stale fileids correctly: %e", r);
	}
	cprintf("stale fileid is good\n");
  800233:	83 ec 0c             	sub    $0xc,%esp
  800236:	68 c4 2c 80 00       	push   $0x802cc4
  80023b:	e8 77 06 00 00       	call   8008b7 <cprintf>

	// Try writing
	if ((r = xopen("/new-file", O_RDWR|O_CREAT)) < 0)
  800240:	ba 02 01 00 00       	mov    $0x102,%edx
  800245:	b8 da 2c 80 00       	mov    $0x802cda,%eax
  80024a:	e8 e4 fd ff ff       	call   800033 <xopen>
  80024f:	83 c4 10             	add    $0x10,%esp
  800252:	85 c0                	test   %eax,%eax
  800254:	0f 88 31 03 00 00    	js     80058b <umain+0x50d>
		panic("serve_open /new-file: %e", r);

	if ((r = devfile.dev_write(FVA, msg, strlen(msg))) != strlen(msg))
  80025a:	8b 1d 14 40 80 00    	mov    0x804014,%ebx
  800260:	83 ec 0c             	sub    $0xc,%esp
  800263:	ff 35 00 40 80 00    	pushl  0x804000
  800269:	e8 6f 0d 00 00       	call   800fdd <strlen>
  80026e:	83 c4 0c             	add    $0xc,%esp
  800271:	50                   	push   %eax
  800272:	ff 35 00 40 80 00    	pushl  0x804000
  800278:	68 00 c0 cc cc       	push   $0xccccc000
  80027d:	ff d3                	call   *%ebx
  80027f:	89 c3                	mov    %eax,%ebx
  800281:	83 c4 04             	add    $0x4,%esp
  800284:	ff 35 00 40 80 00    	pushl  0x804000
  80028a:	e8 4e 0d 00 00       	call   800fdd <strlen>
  80028f:	83 c4 10             	add    $0x10,%esp
  800292:	39 d8                	cmp    %ebx,%eax
  800294:	0f 85 03 03 00 00    	jne    80059d <umain+0x51f>
		panic("file_write: %e", r);
	cprintf("file_write is good\n");
  80029a:	83 ec 0c             	sub    $0xc,%esp
  80029d:	68 0c 2d 80 00       	push   $0x802d0c
  8002a2:	e8 10 06 00 00       	call   8008b7 <cprintf>

	FVA->fd_offset = 0;
  8002a7:	c7 05 04 c0 cc cc 00 	movl   $0x0,0xccccc004
  8002ae:	00 00 00 
	memset(buf, 0, sizeof buf);
  8002b1:	83 c4 0c             	add    $0xc,%esp
  8002b4:	68 00 02 00 00       	push   $0x200
  8002b9:	6a 00                	push   $0x0
  8002bb:	8d 9d 4c fd ff ff    	lea    -0x2b4(%ebp),%ebx
  8002c1:	53                   	push   %ebx
  8002c2:	e8 95 0e 00 00       	call   80115c <memset>
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  8002c7:	83 c4 0c             	add    $0xc,%esp
  8002ca:	68 00 02 00 00       	push   $0x200
  8002cf:	53                   	push   %ebx
  8002d0:	68 00 c0 cc cc       	push   $0xccccc000
  8002d5:	ff 15 10 40 80 00    	call   *0x804010
  8002db:	89 c3                	mov    %eax,%ebx
  8002dd:	83 c4 10             	add    $0x10,%esp
  8002e0:	85 c0                	test   %eax,%eax
  8002e2:	0f 88 c7 02 00 00    	js     8005af <umain+0x531>
		panic("file_read after file_write: %e", r);
	if (r != strlen(msg))
  8002e8:	83 ec 0c             	sub    $0xc,%esp
  8002eb:	ff 35 00 40 80 00    	pushl  0x804000
  8002f1:	e8 e7 0c 00 00       	call   800fdd <strlen>
  8002f6:	83 c4 10             	add    $0x10,%esp
  8002f9:	39 d8                	cmp    %ebx,%eax
  8002fb:	0f 85 c0 02 00 00    	jne    8005c1 <umain+0x543>
		panic("file_read after file_write returned wrong length: %d", r);
	if (strcmp(buf, msg) != 0)
  800301:	83 ec 08             	sub    $0x8,%esp
  800304:	ff 35 00 40 80 00    	pushl  0x804000
  80030a:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  800310:	50                   	push   %eax
  800311:	e8 ab 0d 00 00       	call   8010c1 <strcmp>
  800316:	83 c4 10             	add    $0x10,%esp
  800319:	85 c0                	test   %eax,%eax
  80031b:	0f 85 b2 02 00 00    	jne    8005d3 <umain+0x555>
		panic("file_read after file_write returned wrong data");
	cprintf("file_read after file_write is good\n");
  800321:	83 ec 0c             	sub    $0xc,%esp
  800324:	68 f0 2e 80 00       	push   $0x802ef0
  800329:	e8 89 05 00 00       	call   8008b7 <cprintf>

	// Now we'll try out open
	if ((r = open("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  80032e:	83 c4 08             	add    $0x8,%esp
  800331:	6a 00                	push   $0x0
  800333:	68 c0 2b 80 00       	push   $0x802bc0
  800338:	e8 23 1c 00 00       	call   801f60 <open>
  80033d:	83 c4 10             	add    $0x10,%esp
  800340:	83 f8 f5             	cmp    $0xfffffff5,%eax
  800343:	74 08                	je     80034d <umain+0x2cf>
  800345:	85 c0                	test   %eax,%eax
  800347:	0f 88 9a 02 00 00    	js     8005e7 <umain+0x569>
		panic("open /not-found: %e", r);
	else if (r >= 0)
  80034d:	85 c0                	test   %eax,%eax
  80034f:	0f 89 a4 02 00 00    	jns    8005f9 <umain+0x57b>
		panic("open /not-found succeeded!");

	if ((r = open("/newmotd", O_RDONLY)) < 0)
  800355:	83 ec 08             	sub    $0x8,%esp
  800358:	6a 00                	push   $0x0
  80035a:	68 f5 2b 80 00       	push   $0x802bf5
  80035f:	e8 fc 1b 00 00       	call   801f60 <open>
  800364:	83 c4 10             	add    $0x10,%esp
  800367:	85 c0                	test   %eax,%eax
  800369:	0f 88 9e 02 00 00    	js     80060d <umain+0x58f>
		panic("open /newmotd: %e", r);
	fd = (struct Fd*) (0xD0000000 + r*PGSIZE);
  80036f:	c1 e0 0c             	shl    $0xc,%eax
	if (fd->fd_dev_id != 'f' || fd->fd_offset != 0 || fd->fd_omode != O_RDONLY)
  800372:	83 b8 00 00 00 d0 66 	cmpl   $0x66,-0x30000000(%eax)
  800379:	0f 85 a0 02 00 00    	jne    80061f <umain+0x5a1>
  80037f:	83 b8 04 00 00 d0 00 	cmpl   $0x0,-0x2ffffffc(%eax)
  800386:	0f 85 93 02 00 00    	jne    80061f <umain+0x5a1>
  80038c:	8b 98 08 00 00 d0    	mov    -0x2ffffff8(%eax),%ebx
  800392:	85 db                	test   %ebx,%ebx
  800394:	0f 85 85 02 00 00    	jne    80061f <umain+0x5a1>
		panic("open did not fill struct Fd correctly\n");
	cprintf("open is good\n");
  80039a:	83 ec 0c             	sub    $0xc,%esp
  80039d:	68 1c 2c 80 00       	push   $0x802c1c
  8003a2:	e8 10 05 00 00       	call   8008b7 <cprintf>

	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
  8003a7:	83 c4 08             	add    $0x8,%esp
  8003aa:	68 01 01 00 00       	push   $0x101
  8003af:	68 3b 2d 80 00       	push   $0x802d3b
  8003b4:	e8 a7 1b 00 00       	call   801f60 <open>
  8003b9:	89 c7                	mov    %eax,%edi
  8003bb:	83 c4 10             	add    $0x10,%esp
  8003be:	85 c0                	test   %eax,%eax
  8003c0:	0f 88 6d 02 00 00    	js     800633 <umain+0x5b5>
		panic("creat /big: %e", f);
	memset(buf, 0, sizeof(buf));
  8003c6:	83 ec 04             	sub    $0x4,%esp
  8003c9:	68 00 02 00 00       	push   $0x200
  8003ce:	6a 00                	push   $0x0
  8003d0:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  8003d6:	50                   	push   %eax
  8003d7:	e8 80 0d 00 00       	call   80115c <memset>
  8003dc:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  8003df:	89 de                	mov    %ebx,%esi
		*(int*)buf = i;
  8003e1:	89 b5 4c fd ff ff    	mov    %esi,-0x2b4(%ebp)
		if ((r = write(f, buf, sizeof(buf))) < 0)
  8003e7:	83 ec 04             	sub    $0x4,%esp
  8003ea:	68 00 02 00 00       	push   $0x200
  8003ef:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  8003f5:	50                   	push   %eax
  8003f6:	57                   	push   %edi
  8003f7:	e8 92 17 00 00       	call   801b8e <write>
  8003fc:	83 c4 10             	add    $0x10,%esp
  8003ff:	85 c0                	test   %eax,%eax
  800401:	0f 88 3e 02 00 00    	js     800645 <umain+0x5c7>
  800407:	81 c6 00 02 00 00    	add    $0x200,%esi
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  80040d:	81 fe 00 e0 01 00    	cmp    $0x1e000,%esi
  800413:	75 cc                	jne    8003e1 <umain+0x363>
			panic("write /big@%d: %e", i, r);
	}
	close(f);
  800415:	83 ec 0c             	sub    $0xc,%esp
  800418:	57                   	push   %edi
  800419:	e8 66 15 00 00       	call   801984 <close>

	if ((f = open("/big", O_RDONLY)) < 0)
  80041e:	83 c4 08             	add    $0x8,%esp
  800421:	6a 00                	push   $0x0
  800423:	68 3b 2d 80 00       	push   $0x802d3b
  800428:	e8 33 1b 00 00       	call   801f60 <open>
  80042d:	89 c6                	mov    %eax,%esi
  80042f:	83 c4 10             	add    $0x10,%esp
  800432:	85 c0                	test   %eax,%eax
  800434:	0f 88 21 02 00 00    	js     80065b <umain+0x5dd>
		panic("open /big: %e", f);
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
		*(int*)buf = i;
		if ((r = readn(f, buf, sizeof(buf))) < 0)
  80043a:	8d bd 4c fd ff ff    	lea    -0x2b4(%ebp),%edi
		*(int*)buf = i;
  800440:	89 9d 4c fd ff ff    	mov    %ebx,-0x2b4(%ebp)
		if ((r = readn(f, buf, sizeof(buf))) < 0)
  800446:	83 ec 04             	sub    $0x4,%esp
  800449:	68 00 02 00 00       	push   $0x200
  80044e:	57                   	push   %edi
  80044f:	56                   	push   %esi
  800450:	e8 f4 16 00 00       	call   801b49 <readn>
  800455:	83 c4 10             	add    $0x10,%esp
  800458:	85 c0                	test   %eax,%eax
  80045a:	0f 88 0d 02 00 00    	js     80066d <umain+0x5ef>
			panic("read /big@%d: %e", i, r);
		if (r != sizeof(buf))
  800460:	3d 00 02 00 00       	cmp    $0x200,%eax
  800465:	0f 85 18 02 00 00    	jne    800683 <umain+0x605>
			panic("read /big from %d returned %d < %d bytes",
			      i, r, sizeof(buf));
		if (*(int*)buf != i)
  80046b:	8b 85 4c fd ff ff    	mov    -0x2b4(%ebp),%eax
  800471:	39 d8                	cmp    %ebx,%eax
  800473:	0f 85 25 02 00 00    	jne    80069e <umain+0x620>
  800479:	81 c3 00 02 00 00    	add    $0x200,%ebx
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  80047f:	81 fb 00 e0 01 00    	cmp    $0x1e000,%ebx
  800485:	75 b9                	jne    800440 <umain+0x3c2>
			panic("read /big from %d returned bad data %d",
			      i, *(int*)buf);
	}
	close(f);
  800487:	83 ec 0c             	sub    $0xc,%esp
  80048a:	56                   	push   %esi
  80048b:	e8 f4 14 00 00       	call   801984 <close>
	cprintf("large file is good\n");
  800490:	c7 04 24 80 2d 80 00 	movl   $0x802d80,(%esp)
  800497:	e8 1b 04 00 00       	call   8008b7 <cprintf>
}
  80049c:	83 c4 10             	add    $0x10,%esp
  80049f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004a2:	5b                   	pop    %ebx
  8004a3:	5e                   	pop    %esi
  8004a4:	5f                   	pop    %edi
  8004a5:	5d                   	pop    %ebp
  8004a6:	c3                   	ret    
		panic("serve_open /not-found: %e", r);
  8004a7:	50                   	push   %eax
  8004a8:	68 cb 2b 80 00       	push   $0x802bcb
  8004ad:	6a 20                	push   $0x20
  8004af:	68 e5 2b 80 00       	push   $0x802be5
  8004b4:	e8 08 03 00 00       	call   8007c1 <_panic>
		panic("serve_open /not-found succeeded!");
  8004b9:	83 ec 04             	sub    $0x4,%esp
  8004bc:	68 94 2d 80 00       	push   $0x802d94
  8004c1:	6a 22                	push   $0x22
  8004c3:	68 e5 2b 80 00       	push   $0x802be5
  8004c8:	e8 f4 02 00 00       	call   8007c1 <_panic>
		panic("serve_open /newmotd: %e", r);
  8004cd:	50                   	push   %eax
  8004ce:	68 fe 2b 80 00       	push   $0x802bfe
  8004d3:	6a 25                	push   $0x25
  8004d5:	68 e5 2b 80 00       	push   $0x802be5
  8004da:	e8 e2 02 00 00       	call   8007c1 <_panic>
		panic("serve_open did not fill struct Fd correctly\n");
  8004df:	83 ec 04             	sub    $0x4,%esp
  8004e2:	68 b8 2d 80 00       	push   $0x802db8
  8004e7:	6a 27                	push   $0x27
  8004e9:	68 e5 2b 80 00       	push   $0x802be5
  8004ee:	e8 ce 02 00 00       	call   8007c1 <_panic>
		panic("file_stat: %e", r);
  8004f3:	50                   	push   %eax
  8004f4:	68 2a 2c 80 00       	push   $0x802c2a
  8004f9:	6a 2b                	push   $0x2b
  8004fb:	68 e5 2b 80 00       	push   $0x802be5
  800500:	e8 bc 02 00 00       	call   8007c1 <_panic>
		panic("file_stat returned size %d wanted %d\n", st.st_size, strlen(msg));
  800505:	83 ec 0c             	sub    $0xc,%esp
  800508:	ff 35 00 40 80 00    	pushl  0x804000
  80050e:	e8 ca 0a 00 00       	call   800fdd <strlen>
  800513:	89 04 24             	mov    %eax,(%esp)
  800516:	ff 75 cc             	pushl  -0x34(%ebp)
  800519:	68 e8 2d 80 00       	push   $0x802de8
  80051e:	6a 2d                	push   $0x2d
  800520:	68 e5 2b 80 00       	push   $0x802be5
  800525:	e8 97 02 00 00       	call   8007c1 <_panic>
		panic("file_read: %e", r);
  80052a:	50                   	push   %eax
  80052b:	68 4b 2c 80 00       	push   $0x802c4b
  800530:	6a 32                	push   $0x32
  800532:	68 e5 2b 80 00       	push   $0x802be5
  800537:	e8 85 02 00 00       	call   8007c1 <_panic>
		panic("file_read returned wrong data");
  80053c:	83 ec 04             	sub    $0x4,%esp
  80053f:	68 59 2c 80 00       	push   $0x802c59
  800544:	6a 34                	push   $0x34
  800546:	68 e5 2b 80 00       	push   $0x802be5
  80054b:	e8 71 02 00 00       	call   8007c1 <_panic>
		panic("file_close: %e", r);
  800550:	50                   	push   %eax
  800551:	68 8a 2c 80 00       	push   $0x802c8a
  800556:	6a 38                	push   $0x38
  800558:	68 e5 2b 80 00       	push   $0x802be5
  80055d:	e8 5f 02 00 00       	call   8007c1 <_panic>
		cprintf("%d: after dev_read!! the r: %d\n", thisenv->env_id, r);
  800562:	a1 08 50 80 00       	mov    0x805008,%eax
  800567:	8b 40 48             	mov    0x48(%eax),%eax
  80056a:	83 ec 04             	sub    $0x4,%esp
  80056d:	53                   	push   %ebx
  80056e:	50                   	push   %eax
  80056f:	68 10 2e 80 00       	push   $0x802e10
  800574:	e8 3e 03 00 00       	call   8008b7 <cprintf>
		panic("serve_read does not handle stale fileids correctly: %e", r);
  800579:	53                   	push   %ebx
  80057a:	68 30 2e 80 00       	push   $0x802e30
  80057f:	6a 45                	push   $0x45
  800581:	68 e5 2b 80 00       	push   $0x802be5
  800586:	e8 36 02 00 00       	call   8007c1 <_panic>
		panic("serve_open /new-file: %e", r);
  80058b:	50                   	push   %eax
  80058c:	68 e4 2c 80 00       	push   $0x802ce4
  800591:	6a 4b                	push   $0x4b
  800593:	68 e5 2b 80 00       	push   $0x802be5
  800598:	e8 24 02 00 00       	call   8007c1 <_panic>
		panic("file_write: %e", r);
  80059d:	53                   	push   %ebx
  80059e:	68 fd 2c 80 00       	push   $0x802cfd
  8005a3:	6a 4e                	push   $0x4e
  8005a5:	68 e5 2b 80 00       	push   $0x802be5
  8005aa:	e8 12 02 00 00       	call   8007c1 <_panic>
		panic("file_read after file_write: %e", r);
  8005af:	50                   	push   %eax
  8005b0:	68 68 2e 80 00       	push   $0x802e68
  8005b5:	6a 54                	push   $0x54
  8005b7:	68 e5 2b 80 00       	push   $0x802be5
  8005bc:	e8 00 02 00 00       	call   8007c1 <_panic>
		panic("file_read after file_write returned wrong length: %d", r);
  8005c1:	53                   	push   %ebx
  8005c2:	68 88 2e 80 00       	push   $0x802e88
  8005c7:	6a 56                	push   $0x56
  8005c9:	68 e5 2b 80 00       	push   $0x802be5
  8005ce:	e8 ee 01 00 00       	call   8007c1 <_panic>
		panic("file_read after file_write returned wrong data");
  8005d3:	83 ec 04             	sub    $0x4,%esp
  8005d6:	68 c0 2e 80 00       	push   $0x802ec0
  8005db:	6a 58                	push   $0x58
  8005dd:	68 e5 2b 80 00       	push   $0x802be5
  8005e2:	e8 da 01 00 00       	call   8007c1 <_panic>
		panic("open /not-found: %e", r);
  8005e7:	50                   	push   %eax
  8005e8:	68 d1 2b 80 00       	push   $0x802bd1
  8005ed:	6a 5d                	push   $0x5d
  8005ef:	68 e5 2b 80 00       	push   $0x802be5
  8005f4:	e8 c8 01 00 00       	call   8007c1 <_panic>
		panic("open /not-found succeeded!");
  8005f9:	83 ec 04             	sub    $0x4,%esp
  8005fc:	68 20 2d 80 00       	push   $0x802d20
  800601:	6a 5f                	push   $0x5f
  800603:	68 e5 2b 80 00       	push   $0x802be5
  800608:	e8 b4 01 00 00       	call   8007c1 <_panic>
		panic("open /newmotd: %e", r);
  80060d:	50                   	push   %eax
  80060e:	68 04 2c 80 00       	push   $0x802c04
  800613:	6a 62                	push   $0x62
  800615:	68 e5 2b 80 00       	push   $0x802be5
  80061a:	e8 a2 01 00 00       	call   8007c1 <_panic>
		panic("open did not fill struct Fd correctly\n");
  80061f:	83 ec 04             	sub    $0x4,%esp
  800622:	68 14 2f 80 00       	push   $0x802f14
  800627:	6a 65                	push   $0x65
  800629:	68 e5 2b 80 00       	push   $0x802be5
  80062e:	e8 8e 01 00 00       	call   8007c1 <_panic>
		panic("creat /big: %e", f);
  800633:	50                   	push   %eax
  800634:	68 40 2d 80 00       	push   $0x802d40
  800639:	6a 6a                	push   $0x6a
  80063b:	68 e5 2b 80 00       	push   $0x802be5
  800640:	e8 7c 01 00 00       	call   8007c1 <_panic>
			panic("write /big@%d: %e", i, r);
  800645:	83 ec 0c             	sub    $0xc,%esp
  800648:	50                   	push   %eax
  800649:	56                   	push   %esi
  80064a:	68 4f 2d 80 00       	push   $0x802d4f
  80064f:	6a 6f                	push   $0x6f
  800651:	68 e5 2b 80 00       	push   $0x802be5
  800656:	e8 66 01 00 00       	call   8007c1 <_panic>
		panic("open /big: %e", f);
  80065b:	50                   	push   %eax
  80065c:	68 61 2d 80 00       	push   $0x802d61
  800661:	6a 74                	push   $0x74
  800663:	68 e5 2b 80 00       	push   $0x802be5
  800668:	e8 54 01 00 00       	call   8007c1 <_panic>
			panic("read /big@%d: %e", i, r);
  80066d:	83 ec 0c             	sub    $0xc,%esp
  800670:	50                   	push   %eax
  800671:	53                   	push   %ebx
  800672:	68 6f 2d 80 00       	push   $0x802d6f
  800677:	6a 78                	push   $0x78
  800679:	68 e5 2b 80 00       	push   $0x802be5
  80067e:	e8 3e 01 00 00       	call   8007c1 <_panic>
			panic("read /big from %d returned %d < %d bytes",
  800683:	83 ec 08             	sub    $0x8,%esp
  800686:	68 00 02 00 00       	push   $0x200
  80068b:	50                   	push   %eax
  80068c:	53                   	push   %ebx
  80068d:	68 3c 2f 80 00       	push   $0x802f3c
  800692:	6a 7b                	push   $0x7b
  800694:	68 e5 2b 80 00       	push   $0x802be5
  800699:	e8 23 01 00 00       	call   8007c1 <_panic>
			panic("read /big from %d returned bad data %d",
  80069e:	83 ec 0c             	sub    $0xc,%esp
  8006a1:	50                   	push   %eax
  8006a2:	53                   	push   %ebx
  8006a3:	68 68 2f 80 00       	push   $0x802f68
  8006a8:	6a 7e                	push   $0x7e
  8006aa:	68 e5 2b 80 00       	push   $0x802be5
  8006af:	e8 0d 01 00 00       	call   8007c1 <_panic>

008006b4 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  8006b4:	55                   	push   %ebp
  8006b5:	89 e5                	mov    %esp,%ebp
  8006b7:	57                   	push   %edi
  8006b8:	56                   	push   %esi
  8006b9:	53                   	push   %ebx
  8006ba:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  8006bd:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  8006c4:	00 00 00 
	envid_t find = sys_getenvid();
  8006c7:	e8 fe 0c 00 00       	call   8013ca <sys_getenvid>
  8006cc:	8b 1d 08 50 80 00    	mov    0x805008,%ebx
  8006d2:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  8006d7:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  8006dc:	bf 01 00 00 00       	mov    $0x1,%edi
  8006e1:	eb 0b                	jmp    8006ee <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  8006e3:	83 c2 01             	add    $0x1,%edx
  8006e6:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8006ec:	74 21                	je     80070f <libmain+0x5b>
		if(envs[i].env_id == find)
  8006ee:	89 d1                	mov    %edx,%ecx
  8006f0:	c1 e1 07             	shl    $0x7,%ecx
  8006f3:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  8006f9:	8b 49 48             	mov    0x48(%ecx),%ecx
  8006fc:	39 c1                	cmp    %eax,%ecx
  8006fe:	75 e3                	jne    8006e3 <libmain+0x2f>
  800700:	89 d3                	mov    %edx,%ebx
  800702:	c1 e3 07             	shl    $0x7,%ebx
  800705:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80070b:	89 fe                	mov    %edi,%esi
  80070d:	eb d4                	jmp    8006e3 <libmain+0x2f>
  80070f:	89 f0                	mov    %esi,%eax
  800711:	84 c0                	test   %al,%al
  800713:	74 06                	je     80071b <libmain+0x67>
  800715:	89 1d 08 50 80 00    	mov    %ebx,0x805008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80071b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80071f:	7e 0a                	jle    80072b <libmain+0x77>
		binaryname = argv[0];
  800721:	8b 45 0c             	mov    0xc(%ebp),%eax
  800724:	8b 00                	mov    (%eax),%eax
  800726:	a3 04 40 80 00       	mov    %eax,0x804004

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  80072b:	a1 08 50 80 00       	mov    0x805008,%eax
  800730:	8b 40 48             	mov    0x48(%eax),%eax
  800733:	83 ec 08             	sub    $0x8,%esp
  800736:	50                   	push   %eax
  800737:	68 b6 2f 80 00       	push   $0x802fb6
  80073c:	e8 76 01 00 00       	call   8008b7 <cprintf>
	cprintf("before umain\n");
  800741:	c7 04 24 d4 2f 80 00 	movl   $0x802fd4,(%esp)
  800748:	e8 6a 01 00 00       	call   8008b7 <cprintf>
	// call user main routine
	umain(argc, argv);
  80074d:	83 c4 08             	add    $0x8,%esp
  800750:	ff 75 0c             	pushl  0xc(%ebp)
  800753:	ff 75 08             	pushl  0x8(%ebp)
  800756:	e8 23 f9 ff ff       	call   80007e <umain>
	cprintf("after umain\n");
  80075b:	c7 04 24 e2 2f 80 00 	movl   $0x802fe2,(%esp)
  800762:	e8 50 01 00 00       	call   8008b7 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800767:	a1 08 50 80 00       	mov    0x805008,%eax
  80076c:	8b 40 48             	mov    0x48(%eax),%eax
  80076f:	83 c4 08             	add    $0x8,%esp
  800772:	50                   	push   %eax
  800773:	68 ef 2f 80 00       	push   $0x802fef
  800778:	e8 3a 01 00 00       	call   8008b7 <cprintf>
	// exit gracefully
	exit();
  80077d:	e8 0b 00 00 00       	call   80078d <exit>
}
  800782:	83 c4 10             	add    $0x10,%esp
  800785:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800788:	5b                   	pop    %ebx
  800789:	5e                   	pop    %esi
  80078a:	5f                   	pop    %edi
  80078b:	5d                   	pop    %ebp
  80078c:	c3                   	ret    

0080078d <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80078d:	55                   	push   %ebp
  80078e:	89 e5                	mov    %esp,%ebp
  800790:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800793:	a1 08 50 80 00       	mov    0x805008,%eax
  800798:	8b 40 48             	mov    0x48(%eax),%eax
  80079b:	68 1c 30 80 00       	push   $0x80301c
  8007a0:	50                   	push   %eax
  8007a1:	68 0e 30 80 00       	push   $0x80300e
  8007a6:	e8 0c 01 00 00       	call   8008b7 <cprintf>
	close_all();
  8007ab:	e8 01 12 00 00       	call   8019b1 <close_all>
	sys_env_destroy(0);
  8007b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8007b7:	e8 cd 0b 00 00       	call   801389 <sys_env_destroy>
}
  8007bc:	83 c4 10             	add    $0x10,%esp
  8007bf:	c9                   	leave  
  8007c0:	c3                   	ret    

008007c1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8007c1:	55                   	push   %ebp
  8007c2:	89 e5                	mov    %esp,%ebp
  8007c4:	56                   	push   %esi
  8007c5:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8007c6:	a1 08 50 80 00       	mov    0x805008,%eax
  8007cb:	8b 40 48             	mov    0x48(%eax),%eax
  8007ce:	83 ec 04             	sub    $0x4,%esp
  8007d1:	68 48 30 80 00       	push   $0x803048
  8007d6:	50                   	push   %eax
  8007d7:	68 0e 30 80 00       	push   $0x80300e
  8007dc:	e8 d6 00 00 00       	call   8008b7 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8007e1:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8007e4:	8b 35 04 40 80 00    	mov    0x804004,%esi
  8007ea:	e8 db 0b 00 00       	call   8013ca <sys_getenvid>
  8007ef:	83 c4 04             	add    $0x4,%esp
  8007f2:	ff 75 0c             	pushl  0xc(%ebp)
  8007f5:	ff 75 08             	pushl  0x8(%ebp)
  8007f8:	56                   	push   %esi
  8007f9:	50                   	push   %eax
  8007fa:	68 24 30 80 00       	push   $0x803024
  8007ff:	e8 b3 00 00 00       	call   8008b7 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800804:	83 c4 18             	add    $0x18,%esp
  800807:	53                   	push   %ebx
  800808:	ff 75 10             	pushl  0x10(%ebp)
  80080b:	e8 56 00 00 00       	call   800866 <vcprintf>
	cprintf("\n");
  800810:	c7 04 24 c2 2c 80 00 	movl   $0x802cc2,(%esp)
  800817:	e8 9b 00 00 00       	call   8008b7 <cprintf>
  80081c:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80081f:	cc                   	int3   
  800820:	eb fd                	jmp    80081f <_panic+0x5e>

00800822 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800822:	55                   	push   %ebp
  800823:	89 e5                	mov    %esp,%ebp
  800825:	53                   	push   %ebx
  800826:	83 ec 04             	sub    $0x4,%esp
  800829:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80082c:	8b 13                	mov    (%ebx),%edx
  80082e:	8d 42 01             	lea    0x1(%edx),%eax
  800831:	89 03                	mov    %eax,(%ebx)
  800833:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800836:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80083a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80083f:	74 09                	je     80084a <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800841:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800845:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800848:	c9                   	leave  
  800849:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80084a:	83 ec 08             	sub    $0x8,%esp
  80084d:	68 ff 00 00 00       	push   $0xff
  800852:	8d 43 08             	lea    0x8(%ebx),%eax
  800855:	50                   	push   %eax
  800856:	e8 f1 0a 00 00       	call   80134c <sys_cputs>
		b->idx = 0;
  80085b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800861:	83 c4 10             	add    $0x10,%esp
  800864:	eb db                	jmp    800841 <putch+0x1f>

00800866 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800866:	55                   	push   %ebp
  800867:	89 e5                	mov    %esp,%ebp
  800869:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80086f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800876:	00 00 00 
	b.cnt = 0;
  800879:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800880:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800883:	ff 75 0c             	pushl  0xc(%ebp)
  800886:	ff 75 08             	pushl  0x8(%ebp)
  800889:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80088f:	50                   	push   %eax
  800890:	68 22 08 80 00       	push   $0x800822
  800895:	e8 4a 01 00 00       	call   8009e4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80089a:	83 c4 08             	add    $0x8,%esp
  80089d:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8008a3:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8008a9:	50                   	push   %eax
  8008aa:	e8 9d 0a 00 00       	call   80134c <sys_cputs>

	return b.cnt;
}
  8008af:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8008b5:	c9                   	leave  
  8008b6:	c3                   	ret    

008008b7 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8008b7:	55                   	push   %ebp
  8008b8:	89 e5                	mov    %esp,%ebp
  8008ba:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8008bd:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8008c0:	50                   	push   %eax
  8008c1:	ff 75 08             	pushl  0x8(%ebp)
  8008c4:	e8 9d ff ff ff       	call   800866 <vcprintf>
	va_end(ap);

	return cnt;
}
  8008c9:	c9                   	leave  
  8008ca:	c3                   	ret    

008008cb <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8008cb:	55                   	push   %ebp
  8008cc:	89 e5                	mov    %esp,%ebp
  8008ce:	57                   	push   %edi
  8008cf:	56                   	push   %esi
  8008d0:	53                   	push   %ebx
  8008d1:	83 ec 1c             	sub    $0x1c,%esp
  8008d4:	89 c6                	mov    %eax,%esi
  8008d6:	89 d7                	mov    %edx,%edi
  8008d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008de:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8008e1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8008e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8008e7:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8008ea:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8008ee:	74 2c                	je     80091c <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8008f0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008f3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8008fa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008fd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800900:	39 c2                	cmp    %eax,%edx
  800902:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800905:	73 43                	jae    80094a <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800907:	83 eb 01             	sub    $0x1,%ebx
  80090a:	85 db                	test   %ebx,%ebx
  80090c:	7e 6c                	jle    80097a <printnum+0xaf>
				putch(padc, putdat);
  80090e:	83 ec 08             	sub    $0x8,%esp
  800911:	57                   	push   %edi
  800912:	ff 75 18             	pushl  0x18(%ebp)
  800915:	ff d6                	call   *%esi
  800917:	83 c4 10             	add    $0x10,%esp
  80091a:	eb eb                	jmp    800907 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80091c:	83 ec 0c             	sub    $0xc,%esp
  80091f:	6a 20                	push   $0x20
  800921:	6a 00                	push   $0x0
  800923:	50                   	push   %eax
  800924:	ff 75 e4             	pushl  -0x1c(%ebp)
  800927:	ff 75 e0             	pushl  -0x20(%ebp)
  80092a:	89 fa                	mov    %edi,%edx
  80092c:	89 f0                	mov    %esi,%eax
  80092e:	e8 98 ff ff ff       	call   8008cb <printnum>
		while (--width > 0)
  800933:	83 c4 20             	add    $0x20,%esp
  800936:	83 eb 01             	sub    $0x1,%ebx
  800939:	85 db                	test   %ebx,%ebx
  80093b:	7e 65                	jle    8009a2 <printnum+0xd7>
			putch(padc, putdat);
  80093d:	83 ec 08             	sub    $0x8,%esp
  800940:	57                   	push   %edi
  800941:	6a 20                	push   $0x20
  800943:	ff d6                	call   *%esi
  800945:	83 c4 10             	add    $0x10,%esp
  800948:	eb ec                	jmp    800936 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80094a:	83 ec 0c             	sub    $0xc,%esp
  80094d:	ff 75 18             	pushl  0x18(%ebp)
  800950:	83 eb 01             	sub    $0x1,%ebx
  800953:	53                   	push   %ebx
  800954:	50                   	push   %eax
  800955:	83 ec 08             	sub    $0x8,%esp
  800958:	ff 75 dc             	pushl  -0x24(%ebp)
  80095b:	ff 75 d8             	pushl  -0x28(%ebp)
  80095e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800961:	ff 75 e0             	pushl  -0x20(%ebp)
  800964:	e8 07 20 00 00       	call   802970 <__udivdi3>
  800969:	83 c4 18             	add    $0x18,%esp
  80096c:	52                   	push   %edx
  80096d:	50                   	push   %eax
  80096e:	89 fa                	mov    %edi,%edx
  800970:	89 f0                	mov    %esi,%eax
  800972:	e8 54 ff ff ff       	call   8008cb <printnum>
  800977:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80097a:	83 ec 08             	sub    $0x8,%esp
  80097d:	57                   	push   %edi
  80097e:	83 ec 04             	sub    $0x4,%esp
  800981:	ff 75 dc             	pushl  -0x24(%ebp)
  800984:	ff 75 d8             	pushl  -0x28(%ebp)
  800987:	ff 75 e4             	pushl  -0x1c(%ebp)
  80098a:	ff 75 e0             	pushl  -0x20(%ebp)
  80098d:	e8 ee 20 00 00       	call   802a80 <__umoddi3>
  800992:	83 c4 14             	add    $0x14,%esp
  800995:	0f be 80 4f 30 80 00 	movsbl 0x80304f(%eax),%eax
  80099c:	50                   	push   %eax
  80099d:	ff d6                	call   *%esi
  80099f:	83 c4 10             	add    $0x10,%esp
	}
}
  8009a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009a5:	5b                   	pop    %ebx
  8009a6:	5e                   	pop    %esi
  8009a7:	5f                   	pop    %edi
  8009a8:	5d                   	pop    %ebp
  8009a9:	c3                   	ret    

008009aa <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8009aa:	55                   	push   %ebp
  8009ab:	89 e5                	mov    %esp,%ebp
  8009ad:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8009b0:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8009b4:	8b 10                	mov    (%eax),%edx
  8009b6:	3b 50 04             	cmp    0x4(%eax),%edx
  8009b9:	73 0a                	jae    8009c5 <sprintputch+0x1b>
		*b->buf++ = ch;
  8009bb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009be:	89 08                	mov    %ecx,(%eax)
  8009c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c3:	88 02                	mov    %al,(%edx)
}
  8009c5:	5d                   	pop    %ebp
  8009c6:	c3                   	ret    

008009c7 <printfmt>:
{
  8009c7:	55                   	push   %ebp
  8009c8:	89 e5                	mov    %esp,%ebp
  8009ca:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8009cd:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8009d0:	50                   	push   %eax
  8009d1:	ff 75 10             	pushl  0x10(%ebp)
  8009d4:	ff 75 0c             	pushl  0xc(%ebp)
  8009d7:	ff 75 08             	pushl  0x8(%ebp)
  8009da:	e8 05 00 00 00       	call   8009e4 <vprintfmt>
}
  8009df:	83 c4 10             	add    $0x10,%esp
  8009e2:	c9                   	leave  
  8009e3:	c3                   	ret    

008009e4 <vprintfmt>:
{
  8009e4:	55                   	push   %ebp
  8009e5:	89 e5                	mov    %esp,%ebp
  8009e7:	57                   	push   %edi
  8009e8:	56                   	push   %esi
  8009e9:	53                   	push   %ebx
  8009ea:	83 ec 3c             	sub    $0x3c,%esp
  8009ed:	8b 75 08             	mov    0x8(%ebp),%esi
  8009f0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8009f3:	8b 7d 10             	mov    0x10(%ebp),%edi
  8009f6:	e9 32 04 00 00       	jmp    800e2d <vprintfmt+0x449>
		padc = ' ';
  8009fb:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8009ff:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800a06:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800a0d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800a14:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a1b:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800a22:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800a27:	8d 47 01             	lea    0x1(%edi),%eax
  800a2a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a2d:	0f b6 17             	movzbl (%edi),%edx
  800a30:	8d 42 dd             	lea    -0x23(%edx),%eax
  800a33:	3c 55                	cmp    $0x55,%al
  800a35:	0f 87 12 05 00 00    	ja     800f4d <vprintfmt+0x569>
  800a3b:	0f b6 c0             	movzbl %al,%eax
  800a3e:	ff 24 85 20 32 80 00 	jmp    *0x803220(,%eax,4)
  800a45:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800a48:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800a4c:	eb d9                	jmp    800a27 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800a4e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800a51:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800a55:	eb d0                	jmp    800a27 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800a57:	0f b6 d2             	movzbl %dl,%edx
  800a5a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800a5d:	b8 00 00 00 00       	mov    $0x0,%eax
  800a62:	89 75 08             	mov    %esi,0x8(%ebp)
  800a65:	eb 03                	jmp    800a6a <vprintfmt+0x86>
  800a67:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800a6a:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800a6d:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800a71:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800a74:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a77:	83 fe 09             	cmp    $0x9,%esi
  800a7a:	76 eb                	jbe    800a67 <vprintfmt+0x83>
  800a7c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a7f:	8b 75 08             	mov    0x8(%ebp),%esi
  800a82:	eb 14                	jmp    800a98 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800a84:	8b 45 14             	mov    0x14(%ebp),%eax
  800a87:	8b 00                	mov    (%eax),%eax
  800a89:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a8c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8f:	8d 40 04             	lea    0x4(%eax),%eax
  800a92:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800a95:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800a98:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a9c:	79 89                	jns    800a27 <vprintfmt+0x43>
				width = precision, precision = -1;
  800a9e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800aa1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800aa4:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800aab:	e9 77 ff ff ff       	jmp    800a27 <vprintfmt+0x43>
  800ab0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ab3:	85 c0                	test   %eax,%eax
  800ab5:	0f 48 c1             	cmovs  %ecx,%eax
  800ab8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800abb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800abe:	e9 64 ff ff ff       	jmp    800a27 <vprintfmt+0x43>
  800ac3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800ac6:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800acd:	e9 55 ff ff ff       	jmp    800a27 <vprintfmt+0x43>
			lflag++;
  800ad2:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800ad6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800ad9:	e9 49 ff ff ff       	jmp    800a27 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800ade:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae1:	8d 78 04             	lea    0x4(%eax),%edi
  800ae4:	83 ec 08             	sub    $0x8,%esp
  800ae7:	53                   	push   %ebx
  800ae8:	ff 30                	pushl  (%eax)
  800aea:	ff d6                	call   *%esi
			break;
  800aec:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800aef:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800af2:	e9 33 03 00 00       	jmp    800e2a <vprintfmt+0x446>
			err = va_arg(ap, int);
  800af7:	8b 45 14             	mov    0x14(%ebp),%eax
  800afa:	8d 78 04             	lea    0x4(%eax),%edi
  800afd:	8b 00                	mov    (%eax),%eax
  800aff:	99                   	cltd   
  800b00:	31 d0                	xor    %edx,%eax
  800b02:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800b04:	83 f8 11             	cmp    $0x11,%eax
  800b07:	7f 23                	jg     800b2c <vprintfmt+0x148>
  800b09:	8b 14 85 80 33 80 00 	mov    0x803380(,%eax,4),%edx
  800b10:	85 d2                	test   %edx,%edx
  800b12:	74 18                	je     800b2c <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800b14:	52                   	push   %edx
  800b15:	68 c1 34 80 00       	push   $0x8034c1
  800b1a:	53                   	push   %ebx
  800b1b:	56                   	push   %esi
  800b1c:	e8 a6 fe ff ff       	call   8009c7 <printfmt>
  800b21:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800b24:	89 7d 14             	mov    %edi,0x14(%ebp)
  800b27:	e9 fe 02 00 00       	jmp    800e2a <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800b2c:	50                   	push   %eax
  800b2d:	68 67 30 80 00       	push   $0x803067
  800b32:	53                   	push   %ebx
  800b33:	56                   	push   %esi
  800b34:	e8 8e fe ff ff       	call   8009c7 <printfmt>
  800b39:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800b3c:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800b3f:	e9 e6 02 00 00       	jmp    800e2a <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800b44:	8b 45 14             	mov    0x14(%ebp),%eax
  800b47:	83 c0 04             	add    $0x4,%eax
  800b4a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800b4d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b50:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800b52:	85 c9                	test   %ecx,%ecx
  800b54:	b8 60 30 80 00       	mov    $0x803060,%eax
  800b59:	0f 45 c1             	cmovne %ecx,%eax
  800b5c:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800b5f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b63:	7e 06                	jle    800b6b <vprintfmt+0x187>
  800b65:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800b69:	75 0d                	jne    800b78 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b6b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800b6e:	89 c7                	mov    %eax,%edi
  800b70:	03 45 e0             	add    -0x20(%ebp),%eax
  800b73:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800b76:	eb 53                	jmp    800bcb <vprintfmt+0x1e7>
  800b78:	83 ec 08             	sub    $0x8,%esp
  800b7b:	ff 75 d8             	pushl  -0x28(%ebp)
  800b7e:	50                   	push   %eax
  800b7f:	e8 71 04 00 00       	call   800ff5 <strnlen>
  800b84:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800b87:	29 c1                	sub    %eax,%ecx
  800b89:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800b8c:	83 c4 10             	add    $0x10,%esp
  800b8f:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800b91:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800b95:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800b98:	eb 0f                	jmp    800ba9 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800b9a:	83 ec 08             	sub    $0x8,%esp
  800b9d:	53                   	push   %ebx
  800b9e:	ff 75 e0             	pushl  -0x20(%ebp)
  800ba1:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800ba3:	83 ef 01             	sub    $0x1,%edi
  800ba6:	83 c4 10             	add    $0x10,%esp
  800ba9:	85 ff                	test   %edi,%edi
  800bab:	7f ed                	jg     800b9a <vprintfmt+0x1b6>
  800bad:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800bb0:	85 c9                	test   %ecx,%ecx
  800bb2:	b8 00 00 00 00       	mov    $0x0,%eax
  800bb7:	0f 49 c1             	cmovns %ecx,%eax
  800bba:	29 c1                	sub    %eax,%ecx
  800bbc:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800bbf:	eb aa                	jmp    800b6b <vprintfmt+0x187>
					putch(ch, putdat);
  800bc1:	83 ec 08             	sub    $0x8,%esp
  800bc4:	53                   	push   %ebx
  800bc5:	52                   	push   %edx
  800bc6:	ff d6                	call   *%esi
  800bc8:	83 c4 10             	add    $0x10,%esp
  800bcb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800bce:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bd0:	83 c7 01             	add    $0x1,%edi
  800bd3:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800bd7:	0f be d0             	movsbl %al,%edx
  800bda:	85 d2                	test   %edx,%edx
  800bdc:	74 4b                	je     800c29 <vprintfmt+0x245>
  800bde:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800be2:	78 06                	js     800bea <vprintfmt+0x206>
  800be4:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800be8:	78 1e                	js     800c08 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800bea:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800bee:	74 d1                	je     800bc1 <vprintfmt+0x1dd>
  800bf0:	0f be c0             	movsbl %al,%eax
  800bf3:	83 e8 20             	sub    $0x20,%eax
  800bf6:	83 f8 5e             	cmp    $0x5e,%eax
  800bf9:	76 c6                	jbe    800bc1 <vprintfmt+0x1dd>
					putch('?', putdat);
  800bfb:	83 ec 08             	sub    $0x8,%esp
  800bfe:	53                   	push   %ebx
  800bff:	6a 3f                	push   $0x3f
  800c01:	ff d6                	call   *%esi
  800c03:	83 c4 10             	add    $0x10,%esp
  800c06:	eb c3                	jmp    800bcb <vprintfmt+0x1e7>
  800c08:	89 cf                	mov    %ecx,%edi
  800c0a:	eb 0e                	jmp    800c1a <vprintfmt+0x236>
				putch(' ', putdat);
  800c0c:	83 ec 08             	sub    $0x8,%esp
  800c0f:	53                   	push   %ebx
  800c10:	6a 20                	push   $0x20
  800c12:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800c14:	83 ef 01             	sub    $0x1,%edi
  800c17:	83 c4 10             	add    $0x10,%esp
  800c1a:	85 ff                	test   %edi,%edi
  800c1c:	7f ee                	jg     800c0c <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800c1e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800c21:	89 45 14             	mov    %eax,0x14(%ebp)
  800c24:	e9 01 02 00 00       	jmp    800e2a <vprintfmt+0x446>
  800c29:	89 cf                	mov    %ecx,%edi
  800c2b:	eb ed                	jmp    800c1a <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800c2d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800c30:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800c37:	e9 eb fd ff ff       	jmp    800a27 <vprintfmt+0x43>
	if (lflag >= 2)
  800c3c:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800c40:	7f 21                	jg     800c63 <vprintfmt+0x27f>
	else if (lflag)
  800c42:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800c46:	74 68                	je     800cb0 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800c48:	8b 45 14             	mov    0x14(%ebp),%eax
  800c4b:	8b 00                	mov    (%eax),%eax
  800c4d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800c50:	89 c1                	mov    %eax,%ecx
  800c52:	c1 f9 1f             	sar    $0x1f,%ecx
  800c55:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800c58:	8b 45 14             	mov    0x14(%ebp),%eax
  800c5b:	8d 40 04             	lea    0x4(%eax),%eax
  800c5e:	89 45 14             	mov    %eax,0x14(%ebp)
  800c61:	eb 17                	jmp    800c7a <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800c63:	8b 45 14             	mov    0x14(%ebp),%eax
  800c66:	8b 50 04             	mov    0x4(%eax),%edx
  800c69:	8b 00                	mov    (%eax),%eax
  800c6b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800c6e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800c71:	8b 45 14             	mov    0x14(%ebp),%eax
  800c74:	8d 40 08             	lea    0x8(%eax),%eax
  800c77:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800c7a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800c7d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800c80:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c83:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800c86:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800c8a:	78 3f                	js     800ccb <vprintfmt+0x2e7>
			base = 10;
  800c8c:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800c91:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800c95:	0f 84 71 01 00 00    	je     800e0c <vprintfmt+0x428>
				putch('+', putdat);
  800c9b:	83 ec 08             	sub    $0x8,%esp
  800c9e:	53                   	push   %ebx
  800c9f:	6a 2b                	push   $0x2b
  800ca1:	ff d6                	call   *%esi
  800ca3:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800ca6:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cab:	e9 5c 01 00 00       	jmp    800e0c <vprintfmt+0x428>
		return va_arg(*ap, int);
  800cb0:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb3:	8b 00                	mov    (%eax),%eax
  800cb5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800cb8:	89 c1                	mov    %eax,%ecx
  800cba:	c1 f9 1f             	sar    $0x1f,%ecx
  800cbd:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800cc0:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc3:	8d 40 04             	lea    0x4(%eax),%eax
  800cc6:	89 45 14             	mov    %eax,0x14(%ebp)
  800cc9:	eb af                	jmp    800c7a <vprintfmt+0x296>
				putch('-', putdat);
  800ccb:	83 ec 08             	sub    $0x8,%esp
  800cce:	53                   	push   %ebx
  800ccf:	6a 2d                	push   $0x2d
  800cd1:	ff d6                	call   *%esi
				num = -(long long) num;
  800cd3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800cd6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800cd9:	f7 d8                	neg    %eax
  800cdb:	83 d2 00             	adc    $0x0,%edx
  800cde:	f7 da                	neg    %edx
  800ce0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ce3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ce6:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800ce9:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cee:	e9 19 01 00 00       	jmp    800e0c <vprintfmt+0x428>
	if (lflag >= 2)
  800cf3:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800cf7:	7f 29                	jg     800d22 <vprintfmt+0x33e>
	else if (lflag)
  800cf9:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800cfd:	74 44                	je     800d43 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800cff:	8b 45 14             	mov    0x14(%ebp),%eax
  800d02:	8b 00                	mov    (%eax),%eax
  800d04:	ba 00 00 00 00       	mov    $0x0,%edx
  800d09:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d0c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800d0f:	8b 45 14             	mov    0x14(%ebp),%eax
  800d12:	8d 40 04             	lea    0x4(%eax),%eax
  800d15:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800d18:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d1d:	e9 ea 00 00 00       	jmp    800e0c <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800d22:	8b 45 14             	mov    0x14(%ebp),%eax
  800d25:	8b 50 04             	mov    0x4(%eax),%edx
  800d28:	8b 00                	mov    (%eax),%eax
  800d2a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d2d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800d30:	8b 45 14             	mov    0x14(%ebp),%eax
  800d33:	8d 40 08             	lea    0x8(%eax),%eax
  800d36:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800d39:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d3e:	e9 c9 00 00 00       	jmp    800e0c <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800d43:	8b 45 14             	mov    0x14(%ebp),%eax
  800d46:	8b 00                	mov    (%eax),%eax
  800d48:	ba 00 00 00 00       	mov    $0x0,%edx
  800d4d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d50:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800d53:	8b 45 14             	mov    0x14(%ebp),%eax
  800d56:	8d 40 04             	lea    0x4(%eax),%eax
  800d59:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800d5c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d61:	e9 a6 00 00 00       	jmp    800e0c <vprintfmt+0x428>
			putch('0', putdat);
  800d66:	83 ec 08             	sub    $0x8,%esp
  800d69:	53                   	push   %ebx
  800d6a:	6a 30                	push   $0x30
  800d6c:	ff d6                	call   *%esi
	if (lflag >= 2)
  800d6e:	83 c4 10             	add    $0x10,%esp
  800d71:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800d75:	7f 26                	jg     800d9d <vprintfmt+0x3b9>
	else if (lflag)
  800d77:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800d7b:	74 3e                	je     800dbb <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800d7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d80:	8b 00                	mov    (%eax),%eax
  800d82:	ba 00 00 00 00       	mov    $0x0,%edx
  800d87:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d8a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800d8d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d90:	8d 40 04             	lea    0x4(%eax),%eax
  800d93:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800d96:	b8 08 00 00 00       	mov    $0x8,%eax
  800d9b:	eb 6f                	jmp    800e0c <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800d9d:	8b 45 14             	mov    0x14(%ebp),%eax
  800da0:	8b 50 04             	mov    0x4(%eax),%edx
  800da3:	8b 00                	mov    (%eax),%eax
  800da5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800da8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800dab:	8b 45 14             	mov    0x14(%ebp),%eax
  800dae:	8d 40 08             	lea    0x8(%eax),%eax
  800db1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800db4:	b8 08 00 00 00       	mov    $0x8,%eax
  800db9:	eb 51                	jmp    800e0c <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800dbb:	8b 45 14             	mov    0x14(%ebp),%eax
  800dbe:	8b 00                	mov    (%eax),%eax
  800dc0:	ba 00 00 00 00       	mov    $0x0,%edx
  800dc5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800dc8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800dcb:	8b 45 14             	mov    0x14(%ebp),%eax
  800dce:	8d 40 04             	lea    0x4(%eax),%eax
  800dd1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800dd4:	b8 08 00 00 00       	mov    $0x8,%eax
  800dd9:	eb 31                	jmp    800e0c <vprintfmt+0x428>
			putch('0', putdat);
  800ddb:	83 ec 08             	sub    $0x8,%esp
  800dde:	53                   	push   %ebx
  800ddf:	6a 30                	push   $0x30
  800de1:	ff d6                	call   *%esi
			putch('x', putdat);
  800de3:	83 c4 08             	add    $0x8,%esp
  800de6:	53                   	push   %ebx
  800de7:	6a 78                	push   $0x78
  800de9:	ff d6                	call   *%esi
			num = (unsigned long long)
  800deb:	8b 45 14             	mov    0x14(%ebp),%eax
  800dee:	8b 00                	mov    (%eax),%eax
  800df0:	ba 00 00 00 00       	mov    $0x0,%edx
  800df5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800df8:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800dfb:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800dfe:	8b 45 14             	mov    0x14(%ebp),%eax
  800e01:	8d 40 04             	lea    0x4(%eax),%eax
  800e04:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800e07:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800e0c:	83 ec 0c             	sub    $0xc,%esp
  800e0f:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800e13:	52                   	push   %edx
  800e14:	ff 75 e0             	pushl  -0x20(%ebp)
  800e17:	50                   	push   %eax
  800e18:	ff 75 dc             	pushl  -0x24(%ebp)
  800e1b:	ff 75 d8             	pushl  -0x28(%ebp)
  800e1e:	89 da                	mov    %ebx,%edx
  800e20:	89 f0                	mov    %esi,%eax
  800e22:	e8 a4 fa ff ff       	call   8008cb <printnum>
			break;
  800e27:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800e2a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e2d:	83 c7 01             	add    $0x1,%edi
  800e30:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800e34:	83 f8 25             	cmp    $0x25,%eax
  800e37:	0f 84 be fb ff ff    	je     8009fb <vprintfmt+0x17>
			if (ch == '\0')
  800e3d:	85 c0                	test   %eax,%eax
  800e3f:	0f 84 28 01 00 00    	je     800f6d <vprintfmt+0x589>
			putch(ch, putdat);
  800e45:	83 ec 08             	sub    $0x8,%esp
  800e48:	53                   	push   %ebx
  800e49:	50                   	push   %eax
  800e4a:	ff d6                	call   *%esi
  800e4c:	83 c4 10             	add    $0x10,%esp
  800e4f:	eb dc                	jmp    800e2d <vprintfmt+0x449>
	if (lflag >= 2)
  800e51:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800e55:	7f 26                	jg     800e7d <vprintfmt+0x499>
	else if (lflag)
  800e57:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800e5b:	74 41                	je     800e9e <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800e5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800e60:	8b 00                	mov    (%eax),%eax
  800e62:	ba 00 00 00 00       	mov    $0x0,%edx
  800e67:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800e6a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800e6d:	8b 45 14             	mov    0x14(%ebp),%eax
  800e70:	8d 40 04             	lea    0x4(%eax),%eax
  800e73:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800e76:	b8 10 00 00 00       	mov    $0x10,%eax
  800e7b:	eb 8f                	jmp    800e0c <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800e7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800e80:	8b 50 04             	mov    0x4(%eax),%edx
  800e83:	8b 00                	mov    (%eax),%eax
  800e85:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800e88:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800e8b:	8b 45 14             	mov    0x14(%ebp),%eax
  800e8e:	8d 40 08             	lea    0x8(%eax),%eax
  800e91:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800e94:	b8 10 00 00 00       	mov    $0x10,%eax
  800e99:	e9 6e ff ff ff       	jmp    800e0c <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800e9e:	8b 45 14             	mov    0x14(%ebp),%eax
  800ea1:	8b 00                	mov    (%eax),%eax
  800ea3:	ba 00 00 00 00       	mov    $0x0,%edx
  800ea8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800eab:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800eae:	8b 45 14             	mov    0x14(%ebp),%eax
  800eb1:	8d 40 04             	lea    0x4(%eax),%eax
  800eb4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800eb7:	b8 10 00 00 00       	mov    $0x10,%eax
  800ebc:	e9 4b ff ff ff       	jmp    800e0c <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800ec1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec4:	83 c0 04             	add    $0x4,%eax
  800ec7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800eca:	8b 45 14             	mov    0x14(%ebp),%eax
  800ecd:	8b 00                	mov    (%eax),%eax
  800ecf:	85 c0                	test   %eax,%eax
  800ed1:	74 14                	je     800ee7 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800ed3:	8b 13                	mov    (%ebx),%edx
  800ed5:	83 fa 7f             	cmp    $0x7f,%edx
  800ed8:	7f 37                	jg     800f11 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800eda:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800edc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800edf:	89 45 14             	mov    %eax,0x14(%ebp)
  800ee2:	e9 43 ff ff ff       	jmp    800e2a <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800ee7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800eec:	bf 85 31 80 00       	mov    $0x803185,%edi
							putch(ch, putdat);
  800ef1:	83 ec 08             	sub    $0x8,%esp
  800ef4:	53                   	push   %ebx
  800ef5:	50                   	push   %eax
  800ef6:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800ef8:	83 c7 01             	add    $0x1,%edi
  800efb:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800eff:	83 c4 10             	add    $0x10,%esp
  800f02:	85 c0                	test   %eax,%eax
  800f04:	75 eb                	jne    800ef1 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800f06:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800f09:	89 45 14             	mov    %eax,0x14(%ebp)
  800f0c:	e9 19 ff ff ff       	jmp    800e2a <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800f11:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800f13:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f18:	bf bd 31 80 00       	mov    $0x8031bd,%edi
							putch(ch, putdat);
  800f1d:	83 ec 08             	sub    $0x8,%esp
  800f20:	53                   	push   %ebx
  800f21:	50                   	push   %eax
  800f22:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800f24:	83 c7 01             	add    $0x1,%edi
  800f27:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800f2b:	83 c4 10             	add    $0x10,%esp
  800f2e:	85 c0                	test   %eax,%eax
  800f30:	75 eb                	jne    800f1d <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800f32:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800f35:	89 45 14             	mov    %eax,0x14(%ebp)
  800f38:	e9 ed fe ff ff       	jmp    800e2a <vprintfmt+0x446>
			putch(ch, putdat);
  800f3d:	83 ec 08             	sub    $0x8,%esp
  800f40:	53                   	push   %ebx
  800f41:	6a 25                	push   $0x25
  800f43:	ff d6                	call   *%esi
			break;
  800f45:	83 c4 10             	add    $0x10,%esp
  800f48:	e9 dd fe ff ff       	jmp    800e2a <vprintfmt+0x446>
			putch('%', putdat);
  800f4d:	83 ec 08             	sub    $0x8,%esp
  800f50:	53                   	push   %ebx
  800f51:	6a 25                	push   $0x25
  800f53:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f55:	83 c4 10             	add    $0x10,%esp
  800f58:	89 f8                	mov    %edi,%eax
  800f5a:	eb 03                	jmp    800f5f <vprintfmt+0x57b>
  800f5c:	83 e8 01             	sub    $0x1,%eax
  800f5f:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800f63:	75 f7                	jne    800f5c <vprintfmt+0x578>
  800f65:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800f68:	e9 bd fe ff ff       	jmp    800e2a <vprintfmt+0x446>
}
  800f6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f70:	5b                   	pop    %ebx
  800f71:	5e                   	pop    %esi
  800f72:	5f                   	pop    %edi
  800f73:	5d                   	pop    %ebp
  800f74:	c3                   	ret    

00800f75 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f75:	55                   	push   %ebp
  800f76:	89 e5                	mov    %esp,%ebp
  800f78:	83 ec 18             	sub    $0x18,%esp
  800f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7e:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f81:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800f84:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800f88:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800f8b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800f92:	85 c0                	test   %eax,%eax
  800f94:	74 26                	je     800fbc <vsnprintf+0x47>
  800f96:	85 d2                	test   %edx,%edx
  800f98:	7e 22                	jle    800fbc <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800f9a:	ff 75 14             	pushl  0x14(%ebp)
  800f9d:	ff 75 10             	pushl  0x10(%ebp)
  800fa0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800fa3:	50                   	push   %eax
  800fa4:	68 aa 09 80 00       	push   $0x8009aa
  800fa9:	e8 36 fa ff ff       	call   8009e4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800fae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fb1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fb7:	83 c4 10             	add    $0x10,%esp
}
  800fba:	c9                   	leave  
  800fbb:	c3                   	ret    
		return -E_INVAL;
  800fbc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fc1:	eb f7                	jmp    800fba <vsnprintf+0x45>

00800fc3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fc3:	55                   	push   %ebp
  800fc4:	89 e5                	mov    %esp,%ebp
  800fc6:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800fc9:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800fcc:	50                   	push   %eax
  800fcd:	ff 75 10             	pushl  0x10(%ebp)
  800fd0:	ff 75 0c             	pushl  0xc(%ebp)
  800fd3:	ff 75 08             	pushl  0x8(%ebp)
  800fd6:	e8 9a ff ff ff       	call   800f75 <vsnprintf>
	va_end(ap);

	return rc;
}
  800fdb:	c9                   	leave  
  800fdc:	c3                   	ret    

00800fdd <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800fdd:	55                   	push   %ebp
  800fde:	89 e5                	mov    %esp,%ebp
  800fe0:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800fe3:	b8 00 00 00 00       	mov    $0x0,%eax
  800fe8:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800fec:	74 05                	je     800ff3 <strlen+0x16>
		n++;
  800fee:	83 c0 01             	add    $0x1,%eax
  800ff1:	eb f5                	jmp    800fe8 <strlen+0xb>
	return n;
}
  800ff3:	5d                   	pop    %ebp
  800ff4:	c3                   	ret    

00800ff5 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ff5:	55                   	push   %ebp
  800ff6:	89 e5                	mov    %esp,%ebp
  800ff8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ffb:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ffe:	ba 00 00 00 00       	mov    $0x0,%edx
  801003:	39 c2                	cmp    %eax,%edx
  801005:	74 0d                	je     801014 <strnlen+0x1f>
  801007:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80100b:	74 05                	je     801012 <strnlen+0x1d>
		n++;
  80100d:	83 c2 01             	add    $0x1,%edx
  801010:	eb f1                	jmp    801003 <strnlen+0xe>
  801012:	89 d0                	mov    %edx,%eax
	return n;
}
  801014:	5d                   	pop    %ebp
  801015:	c3                   	ret    

00801016 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801016:	55                   	push   %ebp
  801017:	89 e5                	mov    %esp,%ebp
  801019:	53                   	push   %ebx
  80101a:	8b 45 08             	mov    0x8(%ebp),%eax
  80101d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801020:	ba 00 00 00 00       	mov    $0x0,%edx
  801025:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  801029:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80102c:	83 c2 01             	add    $0x1,%edx
  80102f:	84 c9                	test   %cl,%cl
  801031:	75 f2                	jne    801025 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  801033:	5b                   	pop    %ebx
  801034:	5d                   	pop    %ebp
  801035:	c3                   	ret    

00801036 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801036:	55                   	push   %ebp
  801037:	89 e5                	mov    %esp,%ebp
  801039:	53                   	push   %ebx
  80103a:	83 ec 10             	sub    $0x10,%esp
  80103d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801040:	53                   	push   %ebx
  801041:	e8 97 ff ff ff       	call   800fdd <strlen>
  801046:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  801049:	ff 75 0c             	pushl  0xc(%ebp)
  80104c:	01 d8                	add    %ebx,%eax
  80104e:	50                   	push   %eax
  80104f:	e8 c2 ff ff ff       	call   801016 <strcpy>
	return dst;
}
  801054:	89 d8                	mov    %ebx,%eax
  801056:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801059:	c9                   	leave  
  80105a:	c3                   	ret    

0080105b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80105b:	55                   	push   %ebp
  80105c:	89 e5                	mov    %esp,%ebp
  80105e:	56                   	push   %esi
  80105f:	53                   	push   %ebx
  801060:	8b 45 08             	mov    0x8(%ebp),%eax
  801063:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801066:	89 c6                	mov    %eax,%esi
  801068:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80106b:	89 c2                	mov    %eax,%edx
  80106d:	39 f2                	cmp    %esi,%edx
  80106f:	74 11                	je     801082 <strncpy+0x27>
		*dst++ = *src;
  801071:	83 c2 01             	add    $0x1,%edx
  801074:	0f b6 19             	movzbl (%ecx),%ebx
  801077:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80107a:	80 fb 01             	cmp    $0x1,%bl
  80107d:	83 d9 ff             	sbb    $0xffffffff,%ecx
  801080:	eb eb                	jmp    80106d <strncpy+0x12>
	}
	return ret;
}
  801082:	5b                   	pop    %ebx
  801083:	5e                   	pop    %esi
  801084:	5d                   	pop    %ebp
  801085:	c3                   	ret    

00801086 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801086:	55                   	push   %ebp
  801087:	89 e5                	mov    %esp,%ebp
  801089:	56                   	push   %esi
  80108a:	53                   	push   %ebx
  80108b:	8b 75 08             	mov    0x8(%ebp),%esi
  80108e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801091:	8b 55 10             	mov    0x10(%ebp),%edx
  801094:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801096:	85 d2                	test   %edx,%edx
  801098:	74 21                	je     8010bb <strlcpy+0x35>
  80109a:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80109e:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8010a0:	39 c2                	cmp    %eax,%edx
  8010a2:	74 14                	je     8010b8 <strlcpy+0x32>
  8010a4:	0f b6 19             	movzbl (%ecx),%ebx
  8010a7:	84 db                	test   %bl,%bl
  8010a9:	74 0b                	je     8010b6 <strlcpy+0x30>
			*dst++ = *src++;
  8010ab:	83 c1 01             	add    $0x1,%ecx
  8010ae:	83 c2 01             	add    $0x1,%edx
  8010b1:	88 5a ff             	mov    %bl,-0x1(%edx)
  8010b4:	eb ea                	jmp    8010a0 <strlcpy+0x1a>
  8010b6:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8010b8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8010bb:	29 f0                	sub    %esi,%eax
}
  8010bd:	5b                   	pop    %ebx
  8010be:	5e                   	pop    %esi
  8010bf:	5d                   	pop    %ebp
  8010c0:	c3                   	ret    

008010c1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8010c1:	55                   	push   %ebp
  8010c2:	89 e5                	mov    %esp,%ebp
  8010c4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010c7:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8010ca:	0f b6 01             	movzbl (%ecx),%eax
  8010cd:	84 c0                	test   %al,%al
  8010cf:	74 0c                	je     8010dd <strcmp+0x1c>
  8010d1:	3a 02                	cmp    (%edx),%al
  8010d3:	75 08                	jne    8010dd <strcmp+0x1c>
		p++, q++;
  8010d5:	83 c1 01             	add    $0x1,%ecx
  8010d8:	83 c2 01             	add    $0x1,%edx
  8010db:	eb ed                	jmp    8010ca <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8010dd:	0f b6 c0             	movzbl %al,%eax
  8010e0:	0f b6 12             	movzbl (%edx),%edx
  8010e3:	29 d0                	sub    %edx,%eax
}
  8010e5:	5d                   	pop    %ebp
  8010e6:	c3                   	ret    

008010e7 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8010e7:	55                   	push   %ebp
  8010e8:	89 e5                	mov    %esp,%ebp
  8010ea:	53                   	push   %ebx
  8010eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f1:	89 c3                	mov    %eax,%ebx
  8010f3:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8010f6:	eb 06                	jmp    8010fe <strncmp+0x17>
		n--, p++, q++;
  8010f8:	83 c0 01             	add    $0x1,%eax
  8010fb:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8010fe:	39 d8                	cmp    %ebx,%eax
  801100:	74 16                	je     801118 <strncmp+0x31>
  801102:	0f b6 08             	movzbl (%eax),%ecx
  801105:	84 c9                	test   %cl,%cl
  801107:	74 04                	je     80110d <strncmp+0x26>
  801109:	3a 0a                	cmp    (%edx),%cl
  80110b:	74 eb                	je     8010f8 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80110d:	0f b6 00             	movzbl (%eax),%eax
  801110:	0f b6 12             	movzbl (%edx),%edx
  801113:	29 d0                	sub    %edx,%eax
}
  801115:	5b                   	pop    %ebx
  801116:	5d                   	pop    %ebp
  801117:	c3                   	ret    
		return 0;
  801118:	b8 00 00 00 00       	mov    $0x0,%eax
  80111d:	eb f6                	jmp    801115 <strncmp+0x2e>

0080111f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80111f:	55                   	push   %ebp
  801120:	89 e5                	mov    %esp,%ebp
  801122:	8b 45 08             	mov    0x8(%ebp),%eax
  801125:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801129:	0f b6 10             	movzbl (%eax),%edx
  80112c:	84 d2                	test   %dl,%dl
  80112e:	74 09                	je     801139 <strchr+0x1a>
		if (*s == c)
  801130:	38 ca                	cmp    %cl,%dl
  801132:	74 0a                	je     80113e <strchr+0x1f>
	for (; *s; s++)
  801134:	83 c0 01             	add    $0x1,%eax
  801137:	eb f0                	jmp    801129 <strchr+0xa>
			return (char *) s;
	return 0;
  801139:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80113e:	5d                   	pop    %ebp
  80113f:	c3                   	ret    

00801140 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801140:	55                   	push   %ebp
  801141:	89 e5                	mov    %esp,%ebp
  801143:	8b 45 08             	mov    0x8(%ebp),%eax
  801146:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80114a:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80114d:	38 ca                	cmp    %cl,%dl
  80114f:	74 09                	je     80115a <strfind+0x1a>
  801151:	84 d2                	test   %dl,%dl
  801153:	74 05                	je     80115a <strfind+0x1a>
	for (; *s; s++)
  801155:	83 c0 01             	add    $0x1,%eax
  801158:	eb f0                	jmp    80114a <strfind+0xa>
			break;
	return (char *) s;
}
  80115a:	5d                   	pop    %ebp
  80115b:	c3                   	ret    

0080115c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80115c:	55                   	push   %ebp
  80115d:	89 e5                	mov    %esp,%ebp
  80115f:	57                   	push   %edi
  801160:	56                   	push   %esi
  801161:	53                   	push   %ebx
  801162:	8b 7d 08             	mov    0x8(%ebp),%edi
  801165:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801168:	85 c9                	test   %ecx,%ecx
  80116a:	74 31                	je     80119d <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80116c:	89 f8                	mov    %edi,%eax
  80116e:	09 c8                	or     %ecx,%eax
  801170:	a8 03                	test   $0x3,%al
  801172:	75 23                	jne    801197 <memset+0x3b>
		c &= 0xFF;
  801174:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801178:	89 d3                	mov    %edx,%ebx
  80117a:	c1 e3 08             	shl    $0x8,%ebx
  80117d:	89 d0                	mov    %edx,%eax
  80117f:	c1 e0 18             	shl    $0x18,%eax
  801182:	89 d6                	mov    %edx,%esi
  801184:	c1 e6 10             	shl    $0x10,%esi
  801187:	09 f0                	or     %esi,%eax
  801189:	09 c2                	or     %eax,%edx
  80118b:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80118d:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801190:	89 d0                	mov    %edx,%eax
  801192:	fc                   	cld    
  801193:	f3 ab                	rep stos %eax,%es:(%edi)
  801195:	eb 06                	jmp    80119d <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801197:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119a:	fc                   	cld    
  80119b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80119d:	89 f8                	mov    %edi,%eax
  80119f:	5b                   	pop    %ebx
  8011a0:	5e                   	pop    %esi
  8011a1:	5f                   	pop    %edi
  8011a2:	5d                   	pop    %ebp
  8011a3:	c3                   	ret    

008011a4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8011a4:	55                   	push   %ebp
  8011a5:	89 e5                	mov    %esp,%ebp
  8011a7:	57                   	push   %edi
  8011a8:	56                   	push   %esi
  8011a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ac:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011af:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8011b2:	39 c6                	cmp    %eax,%esi
  8011b4:	73 32                	jae    8011e8 <memmove+0x44>
  8011b6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8011b9:	39 c2                	cmp    %eax,%edx
  8011bb:	76 2b                	jbe    8011e8 <memmove+0x44>
		s += n;
		d += n;
  8011bd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8011c0:	89 fe                	mov    %edi,%esi
  8011c2:	09 ce                	or     %ecx,%esi
  8011c4:	09 d6                	or     %edx,%esi
  8011c6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8011cc:	75 0e                	jne    8011dc <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8011ce:	83 ef 04             	sub    $0x4,%edi
  8011d1:	8d 72 fc             	lea    -0x4(%edx),%esi
  8011d4:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8011d7:	fd                   	std    
  8011d8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8011da:	eb 09                	jmp    8011e5 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8011dc:	83 ef 01             	sub    $0x1,%edi
  8011df:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8011e2:	fd                   	std    
  8011e3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8011e5:	fc                   	cld    
  8011e6:	eb 1a                	jmp    801202 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8011e8:	89 c2                	mov    %eax,%edx
  8011ea:	09 ca                	or     %ecx,%edx
  8011ec:	09 f2                	or     %esi,%edx
  8011ee:	f6 c2 03             	test   $0x3,%dl
  8011f1:	75 0a                	jne    8011fd <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8011f3:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8011f6:	89 c7                	mov    %eax,%edi
  8011f8:	fc                   	cld    
  8011f9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8011fb:	eb 05                	jmp    801202 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  8011fd:	89 c7                	mov    %eax,%edi
  8011ff:	fc                   	cld    
  801200:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801202:	5e                   	pop    %esi
  801203:	5f                   	pop    %edi
  801204:	5d                   	pop    %ebp
  801205:	c3                   	ret    

00801206 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801206:	55                   	push   %ebp
  801207:	89 e5                	mov    %esp,%ebp
  801209:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  80120c:	ff 75 10             	pushl  0x10(%ebp)
  80120f:	ff 75 0c             	pushl  0xc(%ebp)
  801212:	ff 75 08             	pushl  0x8(%ebp)
  801215:	e8 8a ff ff ff       	call   8011a4 <memmove>
}
  80121a:	c9                   	leave  
  80121b:	c3                   	ret    

0080121c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80121c:	55                   	push   %ebp
  80121d:	89 e5                	mov    %esp,%ebp
  80121f:	56                   	push   %esi
  801220:	53                   	push   %ebx
  801221:	8b 45 08             	mov    0x8(%ebp),%eax
  801224:	8b 55 0c             	mov    0xc(%ebp),%edx
  801227:	89 c6                	mov    %eax,%esi
  801229:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80122c:	39 f0                	cmp    %esi,%eax
  80122e:	74 1c                	je     80124c <memcmp+0x30>
		if (*s1 != *s2)
  801230:	0f b6 08             	movzbl (%eax),%ecx
  801233:	0f b6 1a             	movzbl (%edx),%ebx
  801236:	38 d9                	cmp    %bl,%cl
  801238:	75 08                	jne    801242 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  80123a:	83 c0 01             	add    $0x1,%eax
  80123d:	83 c2 01             	add    $0x1,%edx
  801240:	eb ea                	jmp    80122c <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801242:	0f b6 c1             	movzbl %cl,%eax
  801245:	0f b6 db             	movzbl %bl,%ebx
  801248:	29 d8                	sub    %ebx,%eax
  80124a:	eb 05                	jmp    801251 <memcmp+0x35>
	}

	return 0;
  80124c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801251:	5b                   	pop    %ebx
  801252:	5e                   	pop    %esi
  801253:	5d                   	pop    %ebp
  801254:	c3                   	ret    

00801255 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801255:	55                   	push   %ebp
  801256:	89 e5                	mov    %esp,%ebp
  801258:	8b 45 08             	mov    0x8(%ebp),%eax
  80125b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  80125e:	89 c2                	mov    %eax,%edx
  801260:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801263:	39 d0                	cmp    %edx,%eax
  801265:	73 09                	jae    801270 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  801267:	38 08                	cmp    %cl,(%eax)
  801269:	74 05                	je     801270 <memfind+0x1b>
	for (; s < ends; s++)
  80126b:	83 c0 01             	add    $0x1,%eax
  80126e:	eb f3                	jmp    801263 <memfind+0xe>
			break;
	return (void *) s;
}
  801270:	5d                   	pop    %ebp
  801271:	c3                   	ret    

00801272 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801272:	55                   	push   %ebp
  801273:	89 e5                	mov    %esp,%ebp
  801275:	57                   	push   %edi
  801276:	56                   	push   %esi
  801277:	53                   	push   %ebx
  801278:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80127b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80127e:	eb 03                	jmp    801283 <strtol+0x11>
		s++;
  801280:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801283:	0f b6 01             	movzbl (%ecx),%eax
  801286:	3c 20                	cmp    $0x20,%al
  801288:	74 f6                	je     801280 <strtol+0xe>
  80128a:	3c 09                	cmp    $0x9,%al
  80128c:	74 f2                	je     801280 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  80128e:	3c 2b                	cmp    $0x2b,%al
  801290:	74 2a                	je     8012bc <strtol+0x4a>
	int neg = 0;
  801292:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801297:	3c 2d                	cmp    $0x2d,%al
  801299:	74 2b                	je     8012c6 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80129b:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8012a1:	75 0f                	jne    8012b2 <strtol+0x40>
  8012a3:	80 39 30             	cmpb   $0x30,(%ecx)
  8012a6:	74 28                	je     8012d0 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8012a8:	85 db                	test   %ebx,%ebx
  8012aa:	b8 0a 00 00 00       	mov    $0xa,%eax
  8012af:	0f 44 d8             	cmove  %eax,%ebx
  8012b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8012b7:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8012ba:	eb 50                	jmp    80130c <strtol+0x9a>
		s++;
  8012bc:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  8012bf:	bf 00 00 00 00       	mov    $0x0,%edi
  8012c4:	eb d5                	jmp    80129b <strtol+0x29>
		s++, neg = 1;
  8012c6:	83 c1 01             	add    $0x1,%ecx
  8012c9:	bf 01 00 00 00       	mov    $0x1,%edi
  8012ce:	eb cb                	jmp    80129b <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8012d0:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8012d4:	74 0e                	je     8012e4 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  8012d6:	85 db                	test   %ebx,%ebx
  8012d8:	75 d8                	jne    8012b2 <strtol+0x40>
		s++, base = 8;
  8012da:	83 c1 01             	add    $0x1,%ecx
  8012dd:	bb 08 00 00 00       	mov    $0x8,%ebx
  8012e2:	eb ce                	jmp    8012b2 <strtol+0x40>
		s += 2, base = 16;
  8012e4:	83 c1 02             	add    $0x2,%ecx
  8012e7:	bb 10 00 00 00       	mov    $0x10,%ebx
  8012ec:	eb c4                	jmp    8012b2 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  8012ee:	8d 72 9f             	lea    -0x61(%edx),%esi
  8012f1:	89 f3                	mov    %esi,%ebx
  8012f3:	80 fb 19             	cmp    $0x19,%bl
  8012f6:	77 29                	ja     801321 <strtol+0xaf>
			dig = *s - 'a' + 10;
  8012f8:	0f be d2             	movsbl %dl,%edx
  8012fb:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8012fe:	3b 55 10             	cmp    0x10(%ebp),%edx
  801301:	7d 30                	jge    801333 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  801303:	83 c1 01             	add    $0x1,%ecx
  801306:	0f af 45 10          	imul   0x10(%ebp),%eax
  80130a:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  80130c:	0f b6 11             	movzbl (%ecx),%edx
  80130f:	8d 72 d0             	lea    -0x30(%edx),%esi
  801312:	89 f3                	mov    %esi,%ebx
  801314:	80 fb 09             	cmp    $0x9,%bl
  801317:	77 d5                	ja     8012ee <strtol+0x7c>
			dig = *s - '0';
  801319:	0f be d2             	movsbl %dl,%edx
  80131c:	83 ea 30             	sub    $0x30,%edx
  80131f:	eb dd                	jmp    8012fe <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  801321:	8d 72 bf             	lea    -0x41(%edx),%esi
  801324:	89 f3                	mov    %esi,%ebx
  801326:	80 fb 19             	cmp    $0x19,%bl
  801329:	77 08                	ja     801333 <strtol+0xc1>
			dig = *s - 'A' + 10;
  80132b:	0f be d2             	movsbl %dl,%edx
  80132e:	83 ea 37             	sub    $0x37,%edx
  801331:	eb cb                	jmp    8012fe <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  801333:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801337:	74 05                	je     80133e <strtol+0xcc>
		*endptr = (char *) s;
  801339:	8b 75 0c             	mov    0xc(%ebp),%esi
  80133c:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  80133e:	89 c2                	mov    %eax,%edx
  801340:	f7 da                	neg    %edx
  801342:	85 ff                	test   %edi,%edi
  801344:	0f 45 c2             	cmovne %edx,%eax
}
  801347:	5b                   	pop    %ebx
  801348:	5e                   	pop    %esi
  801349:	5f                   	pop    %edi
  80134a:	5d                   	pop    %ebp
  80134b:	c3                   	ret    

0080134c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  80134c:	55                   	push   %ebp
  80134d:	89 e5                	mov    %esp,%ebp
  80134f:	57                   	push   %edi
  801350:	56                   	push   %esi
  801351:	53                   	push   %ebx
	asm volatile("int %1\n"
  801352:	b8 00 00 00 00       	mov    $0x0,%eax
  801357:	8b 55 08             	mov    0x8(%ebp),%edx
  80135a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80135d:	89 c3                	mov    %eax,%ebx
  80135f:	89 c7                	mov    %eax,%edi
  801361:	89 c6                	mov    %eax,%esi
  801363:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801365:	5b                   	pop    %ebx
  801366:	5e                   	pop    %esi
  801367:	5f                   	pop    %edi
  801368:	5d                   	pop    %ebp
  801369:	c3                   	ret    

0080136a <sys_cgetc>:

int
sys_cgetc(void)
{
  80136a:	55                   	push   %ebp
  80136b:	89 e5                	mov    %esp,%ebp
  80136d:	57                   	push   %edi
  80136e:	56                   	push   %esi
  80136f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801370:	ba 00 00 00 00       	mov    $0x0,%edx
  801375:	b8 01 00 00 00       	mov    $0x1,%eax
  80137a:	89 d1                	mov    %edx,%ecx
  80137c:	89 d3                	mov    %edx,%ebx
  80137e:	89 d7                	mov    %edx,%edi
  801380:	89 d6                	mov    %edx,%esi
  801382:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801384:	5b                   	pop    %ebx
  801385:	5e                   	pop    %esi
  801386:	5f                   	pop    %edi
  801387:	5d                   	pop    %ebp
  801388:	c3                   	ret    

00801389 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801389:	55                   	push   %ebp
  80138a:	89 e5                	mov    %esp,%ebp
  80138c:	57                   	push   %edi
  80138d:	56                   	push   %esi
  80138e:	53                   	push   %ebx
  80138f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801392:	b9 00 00 00 00       	mov    $0x0,%ecx
  801397:	8b 55 08             	mov    0x8(%ebp),%edx
  80139a:	b8 03 00 00 00       	mov    $0x3,%eax
  80139f:	89 cb                	mov    %ecx,%ebx
  8013a1:	89 cf                	mov    %ecx,%edi
  8013a3:	89 ce                	mov    %ecx,%esi
  8013a5:	cd 30                	int    $0x30
	if(check && ret > 0)
  8013a7:	85 c0                	test   %eax,%eax
  8013a9:	7f 08                	jg     8013b3 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8013ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013ae:	5b                   	pop    %ebx
  8013af:	5e                   	pop    %esi
  8013b0:	5f                   	pop    %edi
  8013b1:	5d                   	pop    %ebp
  8013b2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8013b3:	83 ec 0c             	sub    $0xc,%esp
  8013b6:	50                   	push   %eax
  8013b7:	6a 03                	push   $0x3
  8013b9:	68 c8 33 80 00       	push   $0x8033c8
  8013be:	6a 43                	push   $0x43
  8013c0:	68 e5 33 80 00       	push   $0x8033e5
  8013c5:	e8 f7 f3 ff ff       	call   8007c1 <_panic>

008013ca <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8013ca:	55                   	push   %ebp
  8013cb:	89 e5                	mov    %esp,%ebp
  8013cd:	57                   	push   %edi
  8013ce:	56                   	push   %esi
  8013cf:	53                   	push   %ebx
	asm volatile("int %1\n"
  8013d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8013d5:	b8 02 00 00 00       	mov    $0x2,%eax
  8013da:	89 d1                	mov    %edx,%ecx
  8013dc:	89 d3                	mov    %edx,%ebx
  8013de:	89 d7                	mov    %edx,%edi
  8013e0:	89 d6                	mov    %edx,%esi
  8013e2:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8013e4:	5b                   	pop    %ebx
  8013e5:	5e                   	pop    %esi
  8013e6:	5f                   	pop    %edi
  8013e7:	5d                   	pop    %ebp
  8013e8:	c3                   	ret    

008013e9 <sys_yield>:

void
sys_yield(void)
{
  8013e9:	55                   	push   %ebp
  8013ea:	89 e5                	mov    %esp,%ebp
  8013ec:	57                   	push   %edi
  8013ed:	56                   	push   %esi
  8013ee:	53                   	push   %ebx
	asm volatile("int %1\n"
  8013ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8013f4:	b8 0b 00 00 00       	mov    $0xb,%eax
  8013f9:	89 d1                	mov    %edx,%ecx
  8013fb:	89 d3                	mov    %edx,%ebx
  8013fd:	89 d7                	mov    %edx,%edi
  8013ff:	89 d6                	mov    %edx,%esi
  801401:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801403:	5b                   	pop    %ebx
  801404:	5e                   	pop    %esi
  801405:	5f                   	pop    %edi
  801406:	5d                   	pop    %ebp
  801407:	c3                   	ret    

00801408 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801408:	55                   	push   %ebp
  801409:	89 e5                	mov    %esp,%ebp
  80140b:	57                   	push   %edi
  80140c:	56                   	push   %esi
  80140d:	53                   	push   %ebx
  80140e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801411:	be 00 00 00 00       	mov    $0x0,%esi
  801416:	8b 55 08             	mov    0x8(%ebp),%edx
  801419:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80141c:	b8 04 00 00 00       	mov    $0x4,%eax
  801421:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801424:	89 f7                	mov    %esi,%edi
  801426:	cd 30                	int    $0x30
	if(check && ret > 0)
  801428:	85 c0                	test   %eax,%eax
  80142a:	7f 08                	jg     801434 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80142c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80142f:	5b                   	pop    %ebx
  801430:	5e                   	pop    %esi
  801431:	5f                   	pop    %edi
  801432:	5d                   	pop    %ebp
  801433:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801434:	83 ec 0c             	sub    $0xc,%esp
  801437:	50                   	push   %eax
  801438:	6a 04                	push   $0x4
  80143a:	68 c8 33 80 00       	push   $0x8033c8
  80143f:	6a 43                	push   $0x43
  801441:	68 e5 33 80 00       	push   $0x8033e5
  801446:	e8 76 f3 ff ff       	call   8007c1 <_panic>

0080144b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80144b:	55                   	push   %ebp
  80144c:	89 e5                	mov    %esp,%ebp
  80144e:	57                   	push   %edi
  80144f:	56                   	push   %esi
  801450:	53                   	push   %ebx
  801451:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801454:	8b 55 08             	mov    0x8(%ebp),%edx
  801457:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80145a:	b8 05 00 00 00       	mov    $0x5,%eax
  80145f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801462:	8b 7d 14             	mov    0x14(%ebp),%edi
  801465:	8b 75 18             	mov    0x18(%ebp),%esi
  801468:	cd 30                	int    $0x30
	if(check && ret > 0)
  80146a:	85 c0                	test   %eax,%eax
  80146c:	7f 08                	jg     801476 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80146e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801471:	5b                   	pop    %ebx
  801472:	5e                   	pop    %esi
  801473:	5f                   	pop    %edi
  801474:	5d                   	pop    %ebp
  801475:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801476:	83 ec 0c             	sub    $0xc,%esp
  801479:	50                   	push   %eax
  80147a:	6a 05                	push   $0x5
  80147c:	68 c8 33 80 00       	push   $0x8033c8
  801481:	6a 43                	push   $0x43
  801483:	68 e5 33 80 00       	push   $0x8033e5
  801488:	e8 34 f3 ff ff       	call   8007c1 <_panic>

0080148d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80148d:	55                   	push   %ebp
  80148e:	89 e5                	mov    %esp,%ebp
  801490:	57                   	push   %edi
  801491:	56                   	push   %esi
  801492:	53                   	push   %ebx
  801493:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801496:	bb 00 00 00 00       	mov    $0x0,%ebx
  80149b:	8b 55 08             	mov    0x8(%ebp),%edx
  80149e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014a1:	b8 06 00 00 00       	mov    $0x6,%eax
  8014a6:	89 df                	mov    %ebx,%edi
  8014a8:	89 de                	mov    %ebx,%esi
  8014aa:	cd 30                	int    $0x30
	if(check && ret > 0)
  8014ac:	85 c0                	test   %eax,%eax
  8014ae:	7f 08                	jg     8014b8 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8014b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014b3:	5b                   	pop    %ebx
  8014b4:	5e                   	pop    %esi
  8014b5:	5f                   	pop    %edi
  8014b6:	5d                   	pop    %ebp
  8014b7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8014b8:	83 ec 0c             	sub    $0xc,%esp
  8014bb:	50                   	push   %eax
  8014bc:	6a 06                	push   $0x6
  8014be:	68 c8 33 80 00       	push   $0x8033c8
  8014c3:	6a 43                	push   $0x43
  8014c5:	68 e5 33 80 00       	push   $0x8033e5
  8014ca:	e8 f2 f2 ff ff       	call   8007c1 <_panic>

008014cf <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8014cf:	55                   	push   %ebp
  8014d0:	89 e5                	mov    %esp,%ebp
  8014d2:	57                   	push   %edi
  8014d3:	56                   	push   %esi
  8014d4:	53                   	push   %ebx
  8014d5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8014d8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8014e0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014e3:	b8 08 00 00 00       	mov    $0x8,%eax
  8014e8:	89 df                	mov    %ebx,%edi
  8014ea:	89 de                	mov    %ebx,%esi
  8014ec:	cd 30                	int    $0x30
	if(check && ret > 0)
  8014ee:	85 c0                	test   %eax,%eax
  8014f0:	7f 08                	jg     8014fa <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8014f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014f5:	5b                   	pop    %ebx
  8014f6:	5e                   	pop    %esi
  8014f7:	5f                   	pop    %edi
  8014f8:	5d                   	pop    %ebp
  8014f9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8014fa:	83 ec 0c             	sub    $0xc,%esp
  8014fd:	50                   	push   %eax
  8014fe:	6a 08                	push   $0x8
  801500:	68 c8 33 80 00       	push   $0x8033c8
  801505:	6a 43                	push   $0x43
  801507:	68 e5 33 80 00       	push   $0x8033e5
  80150c:	e8 b0 f2 ff ff       	call   8007c1 <_panic>

00801511 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801511:	55                   	push   %ebp
  801512:	89 e5                	mov    %esp,%ebp
  801514:	57                   	push   %edi
  801515:	56                   	push   %esi
  801516:	53                   	push   %ebx
  801517:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80151a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80151f:	8b 55 08             	mov    0x8(%ebp),%edx
  801522:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801525:	b8 09 00 00 00       	mov    $0x9,%eax
  80152a:	89 df                	mov    %ebx,%edi
  80152c:	89 de                	mov    %ebx,%esi
  80152e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801530:	85 c0                	test   %eax,%eax
  801532:	7f 08                	jg     80153c <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801534:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801537:	5b                   	pop    %ebx
  801538:	5e                   	pop    %esi
  801539:	5f                   	pop    %edi
  80153a:	5d                   	pop    %ebp
  80153b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80153c:	83 ec 0c             	sub    $0xc,%esp
  80153f:	50                   	push   %eax
  801540:	6a 09                	push   $0x9
  801542:	68 c8 33 80 00       	push   $0x8033c8
  801547:	6a 43                	push   $0x43
  801549:	68 e5 33 80 00       	push   $0x8033e5
  80154e:	e8 6e f2 ff ff       	call   8007c1 <_panic>

00801553 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801553:	55                   	push   %ebp
  801554:	89 e5                	mov    %esp,%ebp
  801556:	57                   	push   %edi
  801557:	56                   	push   %esi
  801558:	53                   	push   %ebx
  801559:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80155c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801561:	8b 55 08             	mov    0x8(%ebp),%edx
  801564:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801567:	b8 0a 00 00 00       	mov    $0xa,%eax
  80156c:	89 df                	mov    %ebx,%edi
  80156e:	89 de                	mov    %ebx,%esi
  801570:	cd 30                	int    $0x30
	if(check && ret > 0)
  801572:	85 c0                	test   %eax,%eax
  801574:	7f 08                	jg     80157e <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801576:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801579:	5b                   	pop    %ebx
  80157a:	5e                   	pop    %esi
  80157b:	5f                   	pop    %edi
  80157c:	5d                   	pop    %ebp
  80157d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80157e:	83 ec 0c             	sub    $0xc,%esp
  801581:	50                   	push   %eax
  801582:	6a 0a                	push   $0xa
  801584:	68 c8 33 80 00       	push   $0x8033c8
  801589:	6a 43                	push   $0x43
  80158b:	68 e5 33 80 00       	push   $0x8033e5
  801590:	e8 2c f2 ff ff       	call   8007c1 <_panic>

00801595 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801595:	55                   	push   %ebp
  801596:	89 e5                	mov    %esp,%ebp
  801598:	57                   	push   %edi
  801599:	56                   	push   %esi
  80159a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80159b:	8b 55 08             	mov    0x8(%ebp),%edx
  80159e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015a1:	b8 0c 00 00 00       	mov    $0xc,%eax
  8015a6:	be 00 00 00 00       	mov    $0x0,%esi
  8015ab:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8015ae:	8b 7d 14             	mov    0x14(%ebp),%edi
  8015b1:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8015b3:	5b                   	pop    %ebx
  8015b4:	5e                   	pop    %esi
  8015b5:	5f                   	pop    %edi
  8015b6:	5d                   	pop    %ebp
  8015b7:	c3                   	ret    

008015b8 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8015b8:	55                   	push   %ebp
  8015b9:	89 e5                	mov    %esp,%ebp
  8015bb:	57                   	push   %edi
  8015bc:	56                   	push   %esi
  8015bd:	53                   	push   %ebx
  8015be:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8015c1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8015c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8015c9:	b8 0d 00 00 00       	mov    $0xd,%eax
  8015ce:	89 cb                	mov    %ecx,%ebx
  8015d0:	89 cf                	mov    %ecx,%edi
  8015d2:	89 ce                	mov    %ecx,%esi
  8015d4:	cd 30                	int    $0x30
	if(check && ret > 0)
  8015d6:	85 c0                	test   %eax,%eax
  8015d8:	7f 08                	jg     8015e2 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8015da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015dd:	5b                   	pop    %ebx
  8015de:	5e                   	pop    %esi
  8015df:	5f                   	pop    %edi
  8015e0:	5d                   	pop    %ebp
  8015e1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8015e2:	83 ec 0c             	sub    $0xc,%esp
  8015e5:	50                   	push   %eax
  8015e6:	6a 0d                	push   $0xd
  8015e8:	68 c8 33 80 00       	push   $0x8033c8
  8015ed:	6a 43                	push   $0x43
  8015ef:	68 e5 33 80 00       	push   $0x8033e5
  8015f4:	e8 c8 f1 ff ff       	call   8007c1 <_panic>

008015f9 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  8015f9:	55                   	push   %ebp
  8015fa:	89 e5                	mov    %esp,%ebp
  8015fc:	57                   	push   %edi
  8015fd:	56                   	push   %esi
  8015fe:	53                   	push   %ebx
	asm volatile("int %1\n"
  8015ff:	bb 00 00 00 00       	mov    $0x0,%ebx
  801604:	8b 55 08             	mov    0x8(%ebp),%edx
  801607:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80160a:	b8 0e 00 00 00       	mov    $0xe,%eax
  80160f:	89 df                	mov    %ebx,%edi
  801611:	89 de                	mov    %ebx,%esi
  801613:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801615:	5b                   	pop    %ebx
  801616:	5e                   	pop    %esi
  801617:	5f                   	pop    %edi
  801618:	5d                   	pop    %ebp
  801619:	c3                   	ret    

0080161a <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  80161a:	55                   	push   %ebp
  80161b:	89 e5                	mov    %esp,%ebp
  80161d:	57                   	push   %edi
  80161e:	56                   	push   %esi
  80161f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801620:	b9 00 00 00 00       	mov    $0x0,%ecx
  801625:	8b 55 08             	mov    0x8(%ebp),%edx
  801628:	b8 0f 00 00 00       	mov    $0xf,%eax
  80162d:	89 cb                	mov    %ecx,%ebx
  80162f:	89 cf                	mov    %ecx,%edi
  801631:	89 ce                	mov    %ecx,%esi
  801633:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801635:	5b                   	pop    %ebx
  801636:	5e                   	pop    %esi
  801637:	5f                   	pop    %edi
  801638:	5d                   	pop    %ebp
  801639:	c3                   	ret    

0080163a <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80163a:	55                   	push   %ebp
  80163b:	89 e5                	mov    %esp,%ebp
  80163d:	57                   	push   %edi
  80163e:	56                   	push   %esi
  80163f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801640:	ba 00 00 00 00       	mov    $0x0,%edx
  801645:	b8 10 00 00 00       	mov    $0x10,%eax
  80164a:	89 d1                	mov    %edx,%ecx
  80164c:	89 d3                	mov    %edx,%ebx
  80164e:	89 d7                	mov    %edx,%edi
  801650:	89 d6                	mov    %edx,%esi
  801652:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801654:	5b                   	pop    %ebx
  801655:	5e                   	pop    %esi
  801656:	5f                   	pop    %edi
  801657:	5d                   	pop    %ebp
  801658:	c3                   	ret    

00801659 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801659:	55                   	push   %ebp
  80165a:	89 e5                	mov    %esp,%ebp
  80165c:	57                   	push   %edi
  80165d:	56                   	push   %esi
  80165e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80165f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801664:	8b 55 08             	mov    0x8(%ebp),%edx
  801667:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80166a:	b8 11 00 00 00       	mov    $0x11,%eax
  80166f:	89 df                	mov    %ebx,%edi
  801671:	89 de                	mov    %ebx,%esi
  801673:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801675:	5b                   	pop    %ebx
  801676:	5e                   	pop    %esi
  801677:	5f                   	pop    %edi
  801678:	5d                   	pop    %ebp
  801679:	c3                   	ret    

0080167a <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  80167a:	55                   	push   %ebp
  80167b:	89 e5                	mov    %esp,%ebp
  80167d:	57                   	push   %edi
  80167e:	56                   	push   %esi
  80167f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801680:	bb 00 00 00 00       	mov    $0x0,%ebx
  801685:	8b 55 08             	mov    0x8(%ebp),%edx
  801688:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80168b:	b8 12 00 00 00       	mov    $0x12,%eax
  801690:	89 df                	mov    %ebx,%edi
  801692:	89 de                	mov    %ebx,%esi
  801694:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801696:	5b                   	pop    %ebx
  801697:	5e                   	pop    %esi
  801698:	5f                   	pop    %edi
  801699:	5d                   	pop    %ebp
  80169a:	c3                   	ret    

0080169b <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  80169b:	55                   	push   %ebp
  80169c:	89 e5                	mov    %esp,%ebp
  80169e:	57                   	push   %edi
  80169f:	56                   	push   %esi
  8016a0:	53                   	push   %ebx
  8016a1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8016a4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8016ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016af:	b8 13 00 00 00       	mov    $0x13,%eax
  8016b4:	89 df                	mov    %ebx,%edi
  8016b6:	89 de                	mov    %ebx,%esi
  8016b8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8016ba:	85 c0                	test   %eax,%eax
  8016bc:	7f 08                	jg     8016c6 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8016be:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016c1:	5b                   	pop    %ebx
  8016c2:	5e                   	pop    %esi
  8016c3:	5f                   	pop    %edi
  8016c4:	5d                   	pop    %ebp
  8016c5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8016c6:	83 ec 0c             	sub    $0xc,%esp
  8016c9:	50                   	push   %eax
  8016ca:	6a 13                	push   $0x13
  8016cc:	68 c8 33 80 00       	push   $0x8033c8
  8016d1:	6a 43                	push   $0x43
  8016d3:	68 e5 33 80 00       	push   $0x8033e5
  8016d8:	e8 e4 f0 ff ff       	call   8007c1 <_panic>

008016dd <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8016dd:	55                   	push   %ebp
  8016de:	89 e5                	mov    %esp,%ebp
  8016e0:	56                   	push   %esi
  8016e1:	53                   	push   %ebx
  8016e2:	8b 75 08             	mov    0x8(%ebp),%esi
  8016e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// cprintf("in %s\n", __FUNCTION__);
	int ret;
	if(!pg)
  8016eb:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8016ed:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8016f2:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8016f5:	83 ec 0c             	sub    $0xc,%esp
  8016f8:	50                   	push   %eax
  8016f9:	e8 ba fe ff ff       	call   8015b8 <sys_ipc_recv>
	if(ret < 0){
  8016fe:	83 c4 10             	add    $0x10,%esp
  801701:	85 c0                	test   %eax,%eax
  801703:	78 2b                	js     801730 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  801705:	85 f6                	test   %esi,%esi
  801707:	74 0a                	je     801713 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  801709:	a1 08 50 80 00       	mov    0x805008,%eax
  80170e:	8b 40 74             	mov    0x74(%eax),%eax
  801711:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  801713:	85 db                	test   %ebx,%ebx
  801715:	74 0a                	je     801721 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  801717:	a1 08 50 80 00       	mov    0x805008,%eax
  80171c:	8b 40 78             	mov    0x78(%eax),%eax
  80171f:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  801721:	a1 08 50 80 00       	mov    0x805008,%eax
  801726:	8b 40 70             	mov    0x70(%eax),%eax
}
  801729:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80172c:	5b                   	pop    %ebx
  80172d:	5e                   	pop    %esi
  80172e:	5d                   	pop    %ebp
  80172f:	c3                   	ret    
		if(from_env_store)
  801730:	85 f6                	test   %esi,%esi
  801732:	74 06                	je     80173a <ipc_recv+0x5d>
			*from_env_store = 0;
  801734:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80173a:	85 db                	test   %ebx,%ebx
  80173c:	74 eb                	je     801729 <ipc_recv+0x4c>
			*perm_store = 0;
  80173e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801744:	eb e3                	jmp    801729 <ipc_recv+0x4c>

00801746 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  801746:	55                   	push   %ebp
  801747:	89 e5                	mov    %esp,%ebp
  801749:	57                   	push   %edi
  80174a:	56                   	push   %esi
  80174b:	53                   	push   %ebx
  80174c:	83 ec 0c             	sub    $0xc,%esp
  80174f:	8b 7d 08             	mov    0x8(%ebp),%edi
  801752:	8b 75 0c             	mov    0xc(%ebp),%esi
  801755:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  801758:	85 db                	test   %ebx,%ebx
  80175a:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80175f:	0f 44 d8             	cmove  %eax,%ebx
  801762:	eb 05                	jmp    801769 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  801764:	e8 80 fc ff ff       	call   8013e9 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  801769:	ff 75 14             	pushl  0x14(%ebp)
  80176c:	53                   	push   %ebx
  80176d:	56                   	push   %esi
  80176e:	57                   	push   %edi
  80176f:	e8 21 fe ff ff       	call   801595 <sys_ipc_try_send>
  801774:	83 c4 10             	add    $0x10,%esp
  801777:	85 c0                	test   %eax,%eax
  801779:	74 1b                	je     801796 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80177b:	79 e7                	jns    801764 <ipc_send+0x1e>
  80177d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801780:	74 e2                	je     801764 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  801782:	83 ec 04             	sub    $0x4,%esp
  801785:	68 f3 33 80 00       	push   $0x8033f3
  80178a:	6a 4a                	push   $0x4a
  80178c:	68 08 34 80 00       	push   $0x803408
  801791:	e8 2b f0 ff ff       	call   8007c1 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  801796:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801799:	5b                   	pop    %ebx
  80179a:	5e                   	pop    %esi
  80179b:	5f                   	pop    %edi
  80179c:	5d                   	pop    %ebp
  80179d:	c3                   	ret    

0080179e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80179e:	55                   	push   %ebp
  80179f:	89 e5                	mov    %esp,%ebp
  8017a1:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8017a4:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8017a9:	89 c2                	mov    %eax,%edx
  8017ab:	c1 e2 07             	shl    $0x7,%edx
  8017ae:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8017b4:	8b 52 50             	mov    0x50(%edx),%edx
  8017b7:	39 ca                	cmp    %ecx,%edx
  8017b9:	74 11                	je     8017cc <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8017bb:	83 c0 01             	add    $0x1,%eax
  8017be:	3d 00 04 00 00       	cmp    $0x400,%eax
  8017c3:	75 e4                	jne    8017a9 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8017c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ca:	eb 0b                	jmp    8017d7 <ipc_find_env+0x39>
			return envs[i].env_id;
  8017cc:	c1 e0 07             	shl    $0x7,%eax
  8017cf:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8017d4:	8b 40 48             	mov    0x48(%eax),%eax
}
  8017d7:	5d                   	pop    %ebp
  8017d8:	c3                   	ret    

008017d9 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8017d9:	55                   	push   %ebp
  8017da:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017df:	05 00 00 00 30       	add    $0x30000000,%eax
  8017e4:	c1 e8 0c             	shr    $0xc,%eax
}
  8017e7:	5d                   	pop    %ebp
  8017e8:	c3                   	ret    

008017e9 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8017e9:	55                   	push   %ebp
  8017ea:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ef:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8017f4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017f9:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8017fe:	5d                   	pop    %ebp
  8017ff:	c3                   	ret    

00801800 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
  801803:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801808:	89 c2                	mov    %eax,%edx
  80180a:	c1 ea 16             	shr    $0x16,%edx
  80180d:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801814:	f6 c2 01             	test   $0x1,%dl
  801817:	74 2d                	je     801846 <fd_alloc+0x46>
  801819:	89 c2                	mov    %eax,%edx
  80181b:	c1 ea 0c             	shr    $0xc,%edx
  80181e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801825:	f6 c2 01             	test   $0x1,%dl
  801828:	74 1c                	je     801846 <fd_alloc+0x46>
  80182a:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80182f:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801834:	75 d2                	jne    801808 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801836:	8b 45 08             	mov    0x8(%ebp),%eax
  801839:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80183f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801844:	eb 0a                	jmp    801850 <fd_alloc+0x50>
			*fd_store = fd;
  801846:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801849:	89 01                	mov    %eax,(%ecx)
			return 0;
  80184b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801850:	5d                   	pop    %ebp
  801851:	c3                   	ret    

00801852 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801852:	55                   	push   %ebp
  801853:	89 e5                	mov    %esp,%ebp
  801855:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801858:	83 f8 1f             	cmp    $0x1f,%eax
  80185b:	77 30                	ja     80188d <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80185d:	c1 e0 0c             	shl    $0xc,%eax
  801860:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801865:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80186b:	f6 c2 01             	test   $0x1,%dl
  80186e:	74 24                	je     801894 <fd_lookup+0x42>
  801870:	89 c2                	mov    %eax,%edx
  801872:	c1 ea 0c             	shr    $0xc,%edx
  801875:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80187c:	f6 c2 01             	test   $0x1,%dl
  80187f:	74 1a                	je     80189b <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801881:	8b 55 0c             	mov    0xc(%ebp),%edx
  801884:	89 02                	mov    %eax,(%edx)
	return 0;
  801886:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80188b:	5d                   	pop    %ebp
  80188c:	c3                   	ret    
		return -E_INVAL;
  80188d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801892:	eb f7                	jmp    80188b <fd_lookup+0x39>
		return -E_INVAL;
  801894:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801899:	eb f0                	jmp    80188b <fd_lookup+0x39>
  80189b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018a0:	eb e9                	jmp    80188b <fd_lookup+0x39>

008018a2 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
  8018a5:	83 ec 08             	sub    $0x8,%esp
  8018a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8018ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8018b0:	b8 08 40 80 00       	mov    $0x804008,%eax
		if (devtab[i]->dev_id == dev_id) {
  8018b5:	39 08                	cmp    %ecx,(%eax)
  8018b7:	74 38                	je     8018f1 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8018b9:	83 c2 01             	add    $0x1,%edx
  8018bc:	8b 04 95 94 34 80 00 	mov    0x803494(,%edx,4),%eax
  8018c3:	85 c0                	test   %eax,%eax
  8018c5:	75 ee                	jne    8018b5 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8018c7:	a1 08 50 80 00       	mov    0x805008,%eax
  8018cc:	8b 40 48             	mov    0x48(%eax),%eax
  8018cf:	83 ec 04             	sub    $0x4,%esp
  8018d2:	51                   	push   %ecx
  8018d3:	50                   	push   %eax
  8018d4:	68 14 34 80 00       	push   $0x803414
  8018d9:	e8 d9 ef ff ff       	call   8008b7 <cprintf>
	*dev = 0;
  8018de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8018e7:	83 c4 10             	add    $0x10,%esp
  8018ea:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8018ef:	c9                   	leave  
  8018f0:	c3                   	ret    
			*dev = devtab[i];
  8018f1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018f4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8018f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8018fb:	eb f2                	jmp    8018ef <dev_lookup+0x4d>

008018fd <fd_close>:
{
  8018fd:	55                   	push   %ebp
  8018fe:	89 e5                	mov    %esp,%ebp
  801900:	57                   	push   %edi
  801901:	56                   	push   %esi
  801902:	53                   	push   %ebx
  801903:	83 ec 24             	sub    $0x24,%esp
  801906:	8b 75 08             	mov    0x8(%ebp),%esi
  801909:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80190c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80190f:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801910:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801916:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801919:	50                   	push   %eax
  80191a:	e8 33 ff ff ff       	call   801852 <fd_lookup>
  80191f:	89 c3                	mov    %eax,%ebx
  801921:	83 c4 10             	add    $0x10,%esp
  801924:	85 c0                	test   %eax,%eax
  801926:	78 05                	js     80192d <fd_close+0x30>
	    || fd != fd2)
  801928:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80192b:	74 16                	je     801943 <fd_close+0x46>
		return (must_exist ? r : 0);
  80192d:	89 f8                	mov    %edi,%eax
  80192f:	84 c0                	test   %al,%al
  801931:	b8 00 00 00 00       	mov    $0x0,%eax
  801936:	0f 44 d8             	cmove  %eax,%ebx
}
  801939:	89 d8                	mov    %ebx,%eax
  80193b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80193e:	5b                   	pop    %ebx
  80193f:	5e                   	pop    %esi
  801940:	5f                   	pop    %edi
  801941:	5d                   	pop    %ebp
  801942:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801943:	83 ec 08             	sub    $0x8,%esp
  801946:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801949:	50                   	push   %eax
  80194a:	ff 36                	pushl  (%esi)
  80194c:	e8 51 ff ff ff       	call   8018a2 <dev_lookup>
  801951:	89 c3                	mov    %eax,%ebx
  801953:	83 c4 10             	add    $0x10,%esp
  801956:	85 c0                	test   %eax,%eax
  801958:	78 1a                	js     801974 <fd_close+0x77>
		if (dev->dev_close)
  80195a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80195d:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801960:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801965:	85 c0                	test   %eax,%eax
  801967:	74 0b                	je     801974 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801969:	83 ec 0c             	sub    $0xc,%esp
  80196c:	56                   	push   %esi
  80196d:	ff d0                	call   *%eax
  80196f:	89 c3                	mov    %eax,%ebx
  801971:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801974:	83 ec 08             	sub    $0x8,%esp
  801977:	56                   	push   %esi
  801978:	6a 00                	push   $0x0
  80197a:	e8 0e fb ff ff       	call   80148d <sys_page_unmap>
	return r;
  80197f:	83 c4 10             	add    $0x10,%esp
  801982:	eb b5                	jmp    801939 <fd_close+0x3c>

00801984 <close>:

int
close(int fdnum)
{
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
  801987:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80198a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80198d:	50                   	push   %eax
  80198e:	ff 75 08             	pushl  0x8(%ebp)
  801991:	e8 bc fe ff ff       	call   801852 <fd_lookup>
  801996:	83 c4 10             	add    $0x10,%esp
  801999:	85 c0                	test   %eax,%eax
  80199b:	79 02                	jns    80199f <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80199d:	c9                   	leave  
  80199e:	c3                   	ret    
		return fd_close(fd, 1);
  80199f:	83 ec 08             	sub    $0x8,%esp
  8019a2:	6a 01                	push   $0x1
  8019a4:	ff 75 f4             	pushl  -0xc(%ebp)
  8019a7:	e8 51 ff ff ff       	call   8018fd <fd_close>
  8019ac:	83 c4 10             	add    $0x10,%esp
  8019af:	eb ec                	jmp    80199d <close+0x19>

008019b1 <close_all>:

void
close_all(void)
{
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
  8019b4:	53                   	push   %ebx
  8019b5:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8019b8:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8019bd:	83 ec 0c             	sub    $0xc,%esp
  8019c0:	53                   	push   %ebx
  8019c1:	e8 be ff ff ff       	call   801984 <close>
	for (i = 0; i < MAXFD; i++)
  8019c6:	83 c3 01             	add    $0x1,%ebx
  8019c9:	83 c4 10             	add    $0x10,%esp
  8019cc:	83 fb 20             	cmp    $0x20,%ebx
  8019cf:	75 ec                	jne    8019bd <close_all+0xc>
}
  8019d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019d4:	c9                   	leave  
  8019d5:	c3                   	ret    

008019d6 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8019d6:	55                   	push   %ebp
  8019d7:	89 e5                	mov    %esp,%ebp
  8019d9:	57                   	push   %edi
  8019da:	56                   	push   %esi
  8019db:	53                   	push   %ebx
  8019dc:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8019df:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8019e2:	50                   	push   %eax
  8019e3:	ff 75 08             	pushl  0x8(%ebp)
  8019e6:	e8 67 fe ff ff       	call   801852 <fd_lookup>
  8019eb:	89 c3                	mov    %eax,%ebx
  8019ed:	83 c4 10             	add    $0x10,%esp
  8019f0:	85 c0                	test   %eax,%eax
  8019f2:	0f 88 81 00 00 00    	js     801a79 <dup+0xa3>
		return r;
	close(newfdnum);
  8019f8:	83 ec 0c             	sub    $0xc,%esp
  8019fb:	ff 75 0c             	pushl  0xc(%ebp)
  8019fe:	e8 81 ff ff ff       	call   801984 <close>

	newfd = INDEX2FD(newfdnum);
  801a03:	8b 75 0c             	mov    0xc(%ebp),%esi
  801a06:	c1 e6 0c             	shl    $0xc,%esi
  801a09:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801a0f:	83 c4 04             	add    $0x4,%esp
  801a12:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a15:	e8 cf fd ff ff       	call   8017e9 <fd2data>
  801a1a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801a1c:	89 34 24             	mov    %esi,(%esp)
  801a1f:	e8 c5 fd ff ff       	call   8017e9 <fd2data>
  801a24:	83 c4 10             	add    $0x10,%esp
  801a27:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801a29:	89 d8                	mov    %ebx,%eax
  801a2b:	c1 e8 16             	shr    $0x16,%eax
  801a2e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801a35:	a8 01                	test   $0x1,%al
  801a37:	74 11                	je     801a4a <dup+0x74>
  801a39:	89 d8                	mov    %ebx,%eax
  801a3b:	c1 e8 0c             	shr    $0xc,%eax
  801a3e:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801a45:	f6 c2 01             	test   $0x1,%dl
  801a48:	75 39                	jne    801a83 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801a4a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a4d:	89 d0                	mov    %edx,%eax
  801a4f:	c1 e8 0c             	shr    $0xc,%eax
  801a52:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a59:	83 ec 0c             	sub    $0xc,%esp
  801a5c:	25 07 0e 00 00       	and    $0xe07,%eax
  801a61:	50                   	push   %eax
  801a62:	56                   	push   %esi
  801a63:	6a 00                	push   $0x0
  801a65:	52                   	push   %edx
  801a66:	6a 00                	push   $0x0
  801a68:	e8 de f9 ff ff       	call   80144b <sys_page_map>
  801a6d:	89 c3                	mov    %eax,%ebx
  801a6f:	83 c4 20             	add    $0x20,%esp
  801a72:	85 c0                	test   %eax,%eax
  801a74:	78 31                	js     801aa7 <dup+0xd1>
		goto err;

	return newfdnum;
  801a76:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801a79:	89 d8                	mov    %ebx,%eax
  801a7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a7e:	5b                   	pop    %ebx
  801a7f:	5e                   	pop    %esi
  801a80:	5f                   	pop    %edi
  801a81:	5d                   	pop    %ebp
  801a82:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801a83:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a8a:	83 ec 0c             	sub    $0xc,%esp
  801a8d:	25 07 0e 00 00       	and    $0xe07,%eax
  801a92:	50                   	push   %eax
  801a93:	57                   	push   %edi
  801a94:	6a 00                	push   $0x0
  801a96:	53                   	push   %ebx
  801a97:	6a 00                	push   $0x0
  801a99:	e8 ad f9 ff ff       	call   80144b <sys_page_map>
  801a9e:	89 c3                	mov    %eax,%ebx
  801aa0:	83 c4 20             	add    $0x20,%esp
  801aa3:	85 c0                	test   %eax,%eax
  801aa5:	79 a3                	jns    801a4a <dup+0x74>
	sys_page_unmap(0, newfd);
  801aa7:	83 ec 08             	sub    $0x8,%esp
  801aaa:	56                   	push   %esi
  801aab:	6a 00                	push   $0x0
  801aad:	e8 db f9 ff ff       	call   80148d <sys_page_unmap>
	sys_page_unmap(0, nva);
  801ab2:	83 c4 08             	add    $0x8,%esp
  801ab5:	57                   	push   %edi
  801ab6:	6a 00                	push   $0x0
  801ab8:	e8 d0 f9 ff ff       	call   80148d <sys_page_unmap>
	return r;
  801abd:	83 c4 10             	add    $0x10,%esp
  801ac0:	eb b7                	jmp    801a79 <dup+0xa3>

00801ac2 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801ac2:	55                   	push   %ebp
  801ac3:	89 e5                	mov    %esp,%ebp
  801ac5:	53                   	push   %ebx
  801ac6:	83 ec 1c             	sub    $0x1c,%esp
  801ac9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801acc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801acf:	50                   	push   %eax
  801ad0:	53                   	push   %ebx
  801ad1:	e8 7c fd ff ff       	call   801852 <fd_lookup>
  801ad6:	83 c4 10             	add    $0x10,%esp
  801ad9:	85 c0                	test   %eax,%eax
  801adb:	78 3f                	js     801b1c <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801add:	83 ec 08             	sub    $0x8,%esp
  801ae0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ae3:	50                   	push   %eax
  801ae4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ae7:	ff 30                	pushl  (%eax)
  801ae9:	e8 b4 fd ff ff       	call   8018a2 <dev_lookup>
  801aee:	83 c4 10             	add    $0x10,%esp
  801af1:	85 c0                	test   %eax,%eax
  801af3:	78 27                	js     801b1c <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801af5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801af8:	8b 42 08             	mov    0x8(%edx),%eax
  801afb:	83 e0 03             	and    $0x3,%eax
  801afe:	83 f8 01             	cmp    $0x1,%eax
  801b01:	74 1e                	je     801b21 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b06:	8b 40 08             	mov    0x8(%eax),%eax
  801b09:	85 c0                	test   %eax,%eax
  801b0b:	74 35                	je     801b42 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801b0d:	83 ec 04             	sub    $0x4,%esp
  801b10:	ff 75 10             	pushl  0x10(%ebp)
  801b13:	ff 75 0c             	pushl  0xc(%ebp)
  801b16:	52                   	push   %edx
  801b17:	ff d0                	call   *%eax
  801b19:	83 c4 10             	add    $0x10,%esp
}
  801b1c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b1f:	c9                   	leave  
  801b20:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801b21:	a1 08 50 80 00       	mov    0x805008,%eax
  801b26:	8b 40 48             	mov    0x48(%eax),%eax
  801b29:	83 ec 04             	sub    $0x4,%esp
  801b2c:	53                   	push   %ebx
  801b2d:	50                   	push   %eax
  801b2e:	68 58 34 80 00       	push   $0x803458
  801b33:	e8 7f ed ff ff       	call   8008b7 <cprintf>
		return -E_INVAL;
  801b38:	83 c4 10             	add    $0x10,%esp
  801b3b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b40:	eb da                	jmp    801b1c <read+0x5a>
		return -E_NOT_SUPP;
  801b42:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b47:	eb d3                	jmp    801b1c <read+0x5a>

00801b49 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801b49:	55                   	push   %ebp
  801b4a:	89 e5                	mov    %esp,%ebp
  801b4c:	57                   	push   %edi
  801b4d:	56                   	push   %esi
  801b4e:	53                   	push   %ebx
  801b4f:	83 ec 0c             	sub    $0xc,%esp
  801b52:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b55:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801b58:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b5d:	39 f3                	cmp    %esi,%ebx
  801b5f:	73 23                	jae    801b84 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801b61:	83 ec 04             	sub    $0x4,%esp
  801b64:	89 f0                	mov    %esi,%eax
  801b66:	29 d8                	sub    %ebx,%eax
  801b68:	50                   	push   %eax
  801b69:	89 d8                	mov    %ebx,%eax
  801b6b:	03 45 0c             	add    0xc(%ebp),%eax
  801b6e:	50                   	push   %eax
  801b6f:	57                   	push   %edi
  801b70:	e8 4d ff ff ff       	call   801ac2 <read>
		if (m < 0)
  801b75:	83 c4 10             	add    $0x10,%esp
  801b78:	85 c0                	test   %eax,%eax
  801b7a:	78 06                	js     801b82 <readn+0x39>
			return m;
		if (m == 0)
  801b7c:	74 06                	je     801b84 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801b7e:	01 c3                	add    %eax,%ebx
  801b80:	eb db                	jmp    801b5d <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801b82:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801b84:	89 d8                	mov    %ebx,%eax
  801b86:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b89:	5b                   	pop    %ebx
  801b8a:	5e                   	pop    %esi
  801b8b:	5f                   	pop    %edi
  801b8c:	5d                   	pop    %ebp
  801b8d:	c3                   	ret    

00801b8e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801b8e:	55                   	push   %ebp
  801b8f:	89 e5                	mov    %esp,%ebp
  801b91:	53                   	push   %ebx
  801b92:	83 ec 1c             	sub    $0x1c,%esp
  801b95:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b98:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b9b:	50                   	push   %eax
  801b9c:	53                   	push   %ebx
  801b9d:	e8 b0 fc ff ff       	call   801852 <fd_lookup>
  801ba2:	83 c4 10             	add    $0x10,%esp
  801ba5:	85 c0                	test   %eax,%eax
  801ba7:	78 3a                	js     801be3 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ba9:	83 ec 08             	sub    $0x8,%esp
  801bac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801baf:	50                   	push   %eax
  801bb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bb3:	ff 30                	pushl  (%eax)
  801bb5:	e8 e8 fc ff ff       	call   8018a2 <dev_lookup>
  801bba:	83 c4 10             	add    $0x10,%esp
  801bbd:	85 c0                	test   %eax,%eax
  801bbf:	78 22                	js     801be3 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801bc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bc4:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801bc8:	74 1e                	je     801be8 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801bca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bcd:	8b 52 0c             	mov    0xc(%edx),%edx
  801bd0:	85 d2                	test   %edx,%edx
  801bd2:	74 35                	je     801c09 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801bd4:	83 ec 04             	sub    $0x4,%esp
  801bd7:	ff 75 10             	pushl  0x10(%ebp)
  801bda:	ff 75 0c             	pushl  0xc(%ebp)
  801bdd:	50                   	push   %eax
  801bde:	ff d2                	call   *%edx
  801be0:	83 c4 10             	add    $0x10,%esp
}
  801be3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801be6:	c9                   	leave  
  801be7:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801be8:	a1 08 50 80 00       	mov    0x805008,%eax
  801bed:	8b 40 48             	mov    0x48(%eax),%eax
  801bf0:	83 ec 04             	sub    $0x4,%esp
  801bf3:	53                   	push   %ebx
  801bf4:	50                   	push   %eax
  801bf5:	68 74 34 80 00       	push   $0x803474
  801bfa:	e8 b8 ec ff ff       	call   8008b7 <cprintf>
		return -E_INVAL;
  801bff:	83 c4 10             	add    $0x10,%esp
  801c02:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c07:	eb da                	jmp    801be3 <write+0x55>
		return -E_NOT_SUPP;
  801c09:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c0e:	eb d3                	jmp    801be3 <write+0x55>

00801c10 <seek>:

int
seek(int fdnum, off_t offset)
{
  801c10:	55                   	push   %ebp
  801c11:	89 e5                	mov    %esp,%ebp
  801c13:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c16:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c19:	50                   	push   %eax
  801c1a:	ff 75 08             	pushl  0x8(%ebp)
  801c1d:	e8 30 fc ff ff       	call   801852 <fd_lookup>
  801c22:	83 c4 10             	add    $0x10,%esp
  801c25:	85 c0                	test   %eax,%eax
  801c27:	78 0e                	js     801c37 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801c29:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c2f:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801c32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c37:	c9                   	leave  
  801c38:	c3                   	ret    

00801c39 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801c39:	55                   	push   %ebp
  801c3a:	89 e5                	mov    %esp,%ebp
  801c3c:	53                   	push   %ebx
  801c3d:	83 ec 1c             	sub    $0x1c,%esp
  801c40:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c43:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c46:	50                   	push   %eax
  801c47:	53                   	push   %ebx
  801c48:	e8 05 fc ff ff       	call   801852 <fd_lookup>
  801c4d:	83 c4 10             	add    $0x10,%esp
  801c50:	85 c0                	test   %eax,%eax
  801c52:	78 37                	js     801c8b <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c54:	83 ec 08             	sub    $0x8,%esp
  801c57:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c5a:	50                   	push   %eax
  801c5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c5e:	ff 30                	pushl  (%eax)
  801c60:	e8 3d fc ff ff       	call   8018a2 <dev_lookup>
  801c65:	83 c4 10             	add    $0x10,%esp
  801c68:	85 c0                	test   %eax,%eax
  801c6a:	78 1f                	js     801c8b <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c6f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801c73:	74 1b                	je     801c90 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801c75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c78:	8b 52 18             	mov    0x18(%edx),%edx
  801c7b:	85 d2                	test   %edx,%edx
  801c7d:	74 32                	je     801cb1 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801c7f:	83 ec 08             	sub    $0x8,%esp
  801c82:	ff 75 0c             	pushl  0xc(%ebp)
  801c85:	50                   	push   %eax
  801c86:	ff d2                	call   *%edx
  801c88:	83 c4 10             	add    $0x10,%esp
}
  801c8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c8e:	c9                   	leave  
  801c8f:	c3                   	ret    
			thisenv->env_id, fdnum);
  801c90:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801c95:	8b 40 48             	mov    0x48(%eax),%eax
  801c98:	83 ec 04             	sub    $0x4,%esp
  801c9b:	53                   	push   %ebx
  801c9c:	50                   	push   %eax
  801c9d:	68 34 34 80 00       	push   $0x803434
  801ca2:	e8 10 ec ff ff       	call   8008b7 <cprintf>
		return -E_INVAL;
  801ca7:	83 c4 10             	add    $0x10,%esp
  801caa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801caf:	eb da                	jmp    801c8b <ftruncate+0x52>
		return -E_NOT_SUPP;
  801cb1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801cb6:	eb d3                	jmp    801c8b <ftruncate+0x52>

00801cb8 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
  801cbb:	53                   	push   %ebx
  801cbc:	83 ec 1c             	sub    $0x1c,%esp
  801cbf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801cc2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cc5:	50                   	push   %eax
  801cc6:	ff 75 08             	pushl  0x8(%ebp)
  801cc9:	e8 84 fb ff ff       	call   801852 <fd_lookup>
  801cce:	83 c4 10             	add    $0x10,%esp
  801cd1:	85 c0                	test   %eax,%eax
  801cd3:	78 4b                	js     801d20 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801cd5:	83 ec 08             	sub    $0x8,%esp
  801cd8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cdb:	50                   	push   %eax
  801cdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cdf:	ff 30                	pushl  (%eax)
  801ce1:	e8 bc fb ff ff       	call   8018a2 <dev_lookup>
  801ce6:	83 c4 10             	add    $0x10,%esp
  801ce9:	85 c0                	test   %eax,%eax
  801ceb:	78 33                	js     801d20 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801ced:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf0:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801cf4:	74 2f                	je     801d25 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801cf6:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801cf9:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801d00:	00 00 00 
	stat->st_isdir = 0;
  801d03:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d0a:	00 00 00 
	stat->st_dev = dev;
  801d0d:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801d13:	83 ec 08             	sub    $0x8,%esp
  801d16:	53                   	push   %ebx
  801d17:	ff 75 f0             	pushl  -0x10(%ebp)
  801d1a:	ff 50 14             	call   *0x14(%eax)
  801d1d:	83 c4 10             	add    $0x10,%esp
}
  801d20:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d23:	c9                   	leave  
  801d24:	c3                   	ret    
		return -E_NOT_SUPP;
  801d25:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d2a:	eb f4                	jmp    801d20 <fstat+0x68>

00801d2c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801d2c:	55                   	push   %ebp
  801d2d:	89 e5                	mov    %esp,%ebp
  801d2f:	56                   	push   %esi
  801d30:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801d31:	83 ec 08             	sub    $0x8,%esp
  801d34:	6a 00                	push   $0x0
  801d36:	ff 75 08             	pushl  0x8(%ebp)
  801d39:	e8 22 02 00 00       	call   801f60 <open>
  801d3e:	89 c3                	mov    %eax,%ebx
  801d40:	83 c4 10             	add    $0x10,%esp
  801d43:	85 c0                	test   %eax,%eax
  801d45:	78 1b                	js     801d62 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801d47:	83 ec 08             	sub    $0x8,%esp
  801d4a:	ff 75 0c             	pushl  0xc(%ebp)
  801d4d:	50                   	push   %eax
  801d4e:	e8 65 ff ff ff       	call   801cb8 <fstat>
  801d53:	89 c6                	mov    %eax,%esi
	close(fd);
  801d55:	89 1c 24             	mov    %ebx,(%esp)
  801d58:	e8 27 fc ff ff       	call   801984 <close>
	return r;
  801d5d:	83 c4 10             	add    $0x10,%esp
  801d60:	89 f3                	mov    %esi,%ebx
}
  801d62:	89 d8                	mov    %ebx,%eax
  801d64:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d67:	5b                   	pop    %ebx
  801d68:	5e                   	pop    %esi
  801d69:	5d                   	pop    %ebp
  801d6a:	c3                   	ret    

00801d6b <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801d6b:	55                   	push   %ebp
  801d6c:	89 e5                	mov    %esp,%ebp
  801d6e:	56                   	push   %esi
  801d6f:	53                   	push   %ebx
  801d70:	89 c6                	mov    %eax,%esi
  801d72:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801d74:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801d7b:	74 27                	je     801da4 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801d7d:	6a 07                	push   $0x7
  801d7f:	68 00 60 80 00       	push   $0x806000
  801d84:	56                   	push   %esi
  801d85:	ff 35 00 50 80 00    	pushl  0x805000
  801d8b:	e8 b6 f9 ff ff       	call   801746 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801d90:	83 c4 0c             	add    $0xc,%esp
  801d93:	6a 00                	push   $0x0
  801d95:	53                   	push   %ebx
  801d96:	6a 00                	push   $0x0
  801d98:	e8 40 f9 ff ff       	call   8016dd <ipc_recv>
}
  801d9d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801da0:	5b                   	pop    %ebx
  801da1:	5e                   	pop    %esi
  801da2:	5d                   	pop    %ebp
  801da3:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801da4:	83 ec 0c             	sub    $0xc,%esp
  801da7:	6a 01                	push   $0x1
  801da9:	e8 f0 f9 ff ff       	call   80179e <ipc_find_env>
  801dae:	a3 00 50 80 00       	mov    %eax,0x805000
  801db3:	83 c4 10             	add    $0x10,%esp
  801db6:	eb c5                	jmp    801d7d <fsipc+0x12>

00801db8 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801db8:	55                   	push   %ebp
  801db9:	89 e5                	mov    %esp,%ebp
  801dbb:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc1:	8b 40 0c             	mov    0xc(%eax),%eax
  801dc4:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801dc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dcc:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801dd1:	ba 00 00 00 00       	mov    $0x0,%edx
  801dd6:	b8 02 00 00 00       	mov    $0x2,%eax
  801ddb:	e8 8b ff ff ff       	call   801d6b <fsipc>
}
  801de0:	c9                   	leave  
  801de1:	c3                   	ret    

00801de2 <devfile_flush>:
{
  801de2:	55                   	push   %ebp
  801de3:	89 e5                	mov    %esp,%ebp
  801de5:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801de8:	8b 45 08             	mov    0x8(%ebp),%eax
  801deb:	8b 40 0c             	mov    0xc(%eax),%eax
  801dee:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801df3:	ba 00 00 00 00       	mov    $0x0,%edx
  801df8:	b8 06 00 00 00       	mov    $0x6,%eax
  801dfd:	e8 69 ff ff ff       	call   801d6b <fsipc>
}
  801e02:	c9                   	leave  
  801e03:	c3                   	ret    

00801e04 <devfile_stat>:
{
  801e04:	55                   	push   %ebp
  801e05:	89 e5                	mov    %esp,%ebp
  801e07:	53                   	push   %ebx
  801e08:	83 ec 04             	sub    $0x4,%esp
  801e0b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e11:	8b 40 0c             	mov    0xc(%eax),%eax
  801e14:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801e19:	ba 00 00 00 00       	mov    $0x0,%edx
  801e1e:	b8 05 00 00 00       	mov    $0x5,%eax
  801e23:	e8 43 ff ff ff       	call   801d6b <fsipc>
  801e28:	85 c0                	test   %eax,%eax
  801e2a:	78 2c                	js     801e58 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801e2c:	83 ec 08             	sub    $0x8,%esp
  801e2f:	68 00 60 80 00       	push   $0x806000
  801e34:	53                   	push   %ebx
  801e35:	e8 dc f1 ff ff       	call   801016 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801e3a:	a1 80 60 80 00       	mov    0x806080,%eax
  801e3f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801e45:	a1 84 60 80 00       	mov    0x806084,%eax
  801e4a:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801e50:	83 c4 10             	add    $0x10,%esp
  801e53:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e58:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e5b:	c9                   	leave  
  801e5c:	c3                   	ret    

00801e5d <devfile_write>:
{
  801e5d:	55                   	push   %ebp
  801e5e:	89 e5                	mov    %esp,%ebp
  801e60:	53                   	push   %ebx
  801e61:	83 ec 08             	sub    $0x8,%esp
  801e64:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801e67:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6a:	8b 40 0c             	mov    0xc(%eax),%eax
  801e6d:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801e72:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801e78:	53                   	push   %ebx
  801e79:	ff 75 0c             	pushl  0xc(%ebp)
  801e7c:	68 08 60 80 00       	push   $0x806008
  801e81:	e8 80 f3 ff ff       	call   801206 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801e86:	ba 00 00 00 00       	mov    $0x0,%edx
  801e8b:	b8 04 00 00 00       	mov    $0x4,%eax
  801e90:	e8 d6 fe ff ff       	call   801d6b <fsipc>
  801e95:	83 c4 10             	add    $0x10,%esp
  801e98:	85 c0                	test   %eax,%eax
  801e9a:	78 0b                	js     801ea7 <devfile_write+0x4a>
	assert(r <= n);
  801e9c:	39 d8                	cmp    %ebx,%eax
  801e9e:	77 0c                	ja     801eac <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801ea0:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ea5:	7f 1e                	jg     801ec5 <devfile_write+0x68>
}
  801ea7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801eaa:	c9                   	leave  
  801eab:	c3                   	ret    
	assert(r <= n);
  801eac:	68 a8 34 80 00       	push   $0x8034a8
  801eb1:	68 af 34 80 00       	push   $0x8034af
  801eb6:	68 98 00 00 00       	push   $0x98
  801ebb:	68 c4 34 80 00       	push   $0x8034c4
  801ec0:	e8 fc e8 ff ff       	call   8007c1 <_panic>
	assert(r <= PGSIZE);
  801ec5:	68 cf 34 80 00       	push   $0x8034cf
  801eca:	68 af 34 80 00       	push   $0x8034af
  801ecf:	68 99 00 00 00       	push   $0x99
  801ed4:	68 c4 34 80 00       	push   $0x8034c4
  801ed9:	e8 e3 e8 ff ff       	call   8007c1 <_panic>

00801ede <devfile_read>:
{
  801ede:	55                   	push   %ebp
  801edf:	89 e5                	mov    %esp,%ebp
  801ee1:	56                   	push   %esi
  801ee2:	53                   	push   %ebx
  801ee3:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee9:	8b 40 0c             	mov    0xc(%eax),%eax
  801eec:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801ef1:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801ef7:	ba 00 00 00 00       	mov    $0x0,%edx
  801efc:	b8 03 00 00 00       	mov    $0x3,%eax
  801f01:	e8 65 fe ff ff       	call   801d6b <fsipc>
  801f06:	89 c3                	mov    %eax,%ebx
  801f08:	85 c0                	test   %eax,%eax
  801f0a:	78 1f                	js     801f2b <devfile_read+0x4d>
	assert(r <= n);
  801f0c:	39 f0                	cmp    %esi,%eax
  801f0e:	77 24                	ja     801f34 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801f10:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801f15:	7f 33                	jg     801f4a <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801f17:	83 ec 04             	sub    $0x4,%esp
  801f1a:	50                   	push   %eax
  801f1b:	68 00 60 80 00       	push   $0x806000
  801f20:	ff 75 0c             	pushl  0xc(%ebp)
  801f23:	e8 7c f2 ff ff       	call   8011a4 <memmove>
	return r;
  801f28:	83 c4 10             	add    $0x10,%esp
}
  801f2b:	89 d8                	mov    %ebx,%eax
  801f2d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f30:	5b                   	pop    %ebx
  801f31:	5e                   	pop    %esi
  801f32:	5d                   	pop    %ebp
  801f33:	c3                   	ret    
	assert(r <= n);
  801f34:	68 a8 34 80 00       	push   $0x8034a8
  801f39:	68 af 34 80 00       	push   $0x8034af
  801f3e:	6a 7c                	push   $0x7c
  801f40:	68 c4 34 80 00       	push   $0x8034c4
  801f45:	e8 77 e8 ff ff       	call   8007c1 <_panic>
	assert(r <= PGSIZE);
  801f4a:	68 cf 34 80 00       	push   $0x8034cf
  801f4f:	68 af 34 80 00       	push   $0x8034af
  801f54:	6a 7d                	push   $0x7d
  801f56:	68 c4 34 80 00       	push   $0x8034c4
  801f5b:	e8 61 e8 ff ff       	call   8007c1 <_panic>

00801f60 <open>:
{
  801f60:	55                   	push   %ebp
  801f61:	89 e5                	mov    %esp,%ebp
  801f63:	56                   	push   %esi
  801f64:	53                   	push   %ebx
  801f65:	83 ec 1c             	sub    $0x1c,%esp
  801f68:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801f6b:	56                   	push   %esi
  801f6c:	e8 6c f0 ff ff       	call   800fdd <strlen>
  801f71:	83 c4 10             	add    $0x10,%esp
  801f74:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801f79:	7f 6c                	jg     801fe7 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801f7b:	83 ec 0c             	sub    $0xc,%esp
  801f7e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f81:	50                   	push   %eax
  801f82:	e8 79 f8 ff ff       	call   801800 <fd_alloc>
  801f87:	89 c3                	mov    %eax,%ebx
  801f89:	83 c4 10             	add    $0x10,%esp
  801f8c:	85 c0                	test   %eax,%eax
  801f8e:	78 3c                	js     801fcc <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801f90:	83 ec 08             	sub    $0x8,%esp
  801f93:	56                   	push   %esi
  801f94:	68 00 60 80 00       	push   $0x806000
  801f99:	e8 78 f0 ff ff       	call   801016 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801f9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fa1:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801fa6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fa9:	b8 01 00 00 00       	mov    $0x1,%eax
  801fae:	e8 b8 fd ff ff       	call   801d6b <fsipc>
  801fb3:	89 c3                	mov    %eax,%ebx
  801fb5:	83 c4 10             	add    $0x10,%esp
  801fb8:	85 c0                	test   %eax,%eax
  801fba:	78 19                	js     801fd5 <open+0x75>
	return fd2num(fd);
  801fbc:	83 ec 0c             	sub    $0xc,%esp
  801fbf:	ff 75 f4             	pushl  -0xc(%ebp)
  801fc2:	e8 12 f8 ff ff       	call   8017d9 <fd2num>
  801fc7:	89 c3                	mov    %eax,%ebx
  801fc9:	83 c4 10             	add    $0x10,%esp
}
  801fcc:	89 d8                	mov    %ebx,%eax
  801fce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fd1:	5b                   	pop    %ebx
  801fd2:	5e                   	pop    %esi
  801fd3:	5d                   	pop    %ebp
  801fd4:	c3                   	ret    
		fd_close(fd, 0);
  801fd5:	83 ec 08             	sub    $0x8,%esp
  801fd8:	6a 00                	push   $0x0
  801fda:	ff 75 f4             	pushl  -0xc(%ebp)
  801fdd:	e8 1b f9 ff ff       	call   8018fd <fd_close>
		return r;
  801fe2:	83 c4 10             	add    $0x10,%esp
  801fe5:	eb e5                	jmp    801fcc <open+0x6c>
		return -E_BAD_PATH;
  801fe7:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801fec:	eb de                	jmp    801fcc <open+0x6c>

00801fee <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801fee:	55                   	push   %ebp
  801fef:	89 e5                	mov    %esp,%ebp
  801ff1:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ff4:	ba 00 00 00 00       	mov    $0x0,%edx
  801ff9:	b8 08 00 00 00       	mov    $0x8,%eax
  801ffe:	e8 68 fd ff ff       	call   801d6b <fsipc>
}
  802003:	c9                   	leave  
  802004:	c3                   	ret    

00802005 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802005:	55                   	push   %ebp
  802006:	89 e5                	mov    %esp,%ebp
  802008:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80200b:	68 db 34 80 00       	push   $0x8034db
  802010:	ff 75 0c             	pushl  0xc(%ebp)
  802013:	e8 fe ef ff ff       	call   801016 <strcpy>
	return 0;
}
  802018:	b8 00 00 00 00       	mov    $0x0,%eax
  80201d:	c9                   	leave  
  80201e:	c3                   	ret    

0080201f <devsock_close>:
{
  80201f:	55                   	push   %ebp
  802020:	89 e5                	mov    %esp,%ebp
  802022:	53                   	push   %ebx
  802023:	83 ec 10             	sub    $0x10,%esp
  802026:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  802029:	53                   	push   %ebx
  80202a:	e8 00 09 00 00       	call   80292f <pageref>
  80202f:	83 c4 10             	add    $0x10,%esp
		return 0;
  802032:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  802037:	83 f8 01             	cmp    $0x1,%eax
  80203a:	74 07                	je     802043 <devsock_close+0x24>
}
  80203c:	89 d0                	mov    %edx,%eax
  80203e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802041:	c9                   	leave  
  802042:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  802043:	83 ec 0c             	sub    $0xc,%esp
  802046:	ff 73 0c             	pushl  0xc(%ebx)
  802049:	e8 b9 02 00 00       	call   802307 <nsipc_close>
  80204e:	89 c2                	mov    %eax,%edx
  802050:	83 c4 10             	add    $0x10,%esp
  802053:	eb e7                	jmp    80203c <devsock_close+0x1d>

00802055 <devsock_write>:
{
  802055:	55                   	push   %ebp
  802056:	89 e5                	mov    %esp,%ebp
  802058:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80205b:	6a 00                	push   $0x0
  80205d:	ff 75 10             	pushl  0x10(%ebp)
  802060:	ff 75 0c             	pushl  0xc(%ebp)
  802063:	8b 45 08             	mov    0x8(%ebp),%eax
  802066:	ff 70 0c             	pushl  0xc(%eax)
  802069:	e8 76 03 00 00       	call   8023e4 <nsipc_send>
}
  80206e:	c9                   	leave  
  80206f:	c3                   	ret    

00802070 <devsock_read>:
{
  802070:	55                   	push   %ebp
  802071:	89 e5                	mov    %esp,%ebp
  802073:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802076:	6a 00                	push   $0x0
  802078:	ff 75 10             	pushl  0x10(%ebp)
  80207b:	ff 75 0c             	pushl  0xc(%ebp)
  80207e:	8b 45 08             	mov    0x8(%ebp),%eax
  802081:	ff 70 0c             	pushl  0xc(%eax)
  802084:	e8 ef 02 00 00       	call   802378 <nsipc_recv>
}
  802089:	c9                   	leave  
  80208a:	c3                   	ret    

0080208b <fd2sockid>:
{
  80208b:	55                   	push   %ebp
  80208c:	89 e5                	mov    %esp,%ebp
  80208e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  802091:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802094:	52                   	push   %edx
  802095:	50                   	push   %eax
  802096:	e8 b7 f7 ff ff       	call   801852 <fd_lookup>
  80209b:	83 c4 10             	add    $0x10,%esp
  80209e:	85 c0                	test   %eax,%eax
  8020a0:	78 10                	js     8020b2 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8020a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a5:	8b 0d 24 40 80 00    	mov    0x804024,%ecx
  8020ab:	39 08                	cmp    %ecx,(%eax)
  8020ad:	75 05                	jne    8020b4 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8020af:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8020b2:	c9                   	leave  
  8020b3:	c3                   	ret    
		return -E_NOT_SUPP;
  8020b4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8020b9:	eb f7                	jmp    8020b2 <fd2sockid+0x27>

008020bb <alloc_sockfd>:
{
  8020bb:	55                   	push   %ebp
  8020bc:	89 e5                	mov    %esp,%ebp
  8020be:	56                   	push   %esi
  8020bf:	53                   	push   %ebx
  8020c0:	83 ec 1c             	sub    $0x1c,%esp
  8020c3:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8020c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020c8:	50                   	push   %eax
  8020c9:	e8 32 f7 ff ff       	call   801800 <fd_alloc>
  8020ce:	89 c3                	mov    %eax,%ebx
  8020d0:	83 c4 10             	add    $0x10,%esp
  8020d3:	85 c0                	test   %eax,%eax
  8020d5:	78 43                	js     80211a <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8020d7:	83 ec 04             	sub    $0x4,%esp
  8020da:	68 07 04 00 00       	push   $0x407
  8020df:	ff 75 f4             	pushl  -0xc(%ebp)
  8020e2:	6a 00                	push   $0x0
  8020e4:	e8 1f f3 ff ff       	call   801408 <sys_page_alloc>
  8020e9:	89 c3                	mov    %eax,%ebx
  8020eb:	83 c4 10             	add    $0x10,%esp
  8020ee:	85 c0                	test   %eax,%eax
  8020f0:	78 28                	js     80211a <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8020f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f5:	8b 15 24 40 80 00    	mov    0x804024,%edx
  8020fb:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8020fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802100:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802107:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80210a:	83 ec 0c             	sub    $0xc,%esp
  80210d:	50                   	push   %eax
  80210e:	e8 c6 f6 ff ff       	call   8017d9 <fd2num>
  802113:	89 c3                	mov    %eax,%ebx
  802115:	83 c4 10             	add    $0x10,%esp
  802118:	eb 0c                	jmp    802126 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80211a:	83 ec 0c             	sub    $0xc,%esp
  80211d:	56                   	push   %esi
  80211e:	e8 e4 01 00 00       	call   802307 <nsipc_close>
		return r;
  802123:	83 c4 10             	add    $0x10,%esp
}
  802126:	89 d8                	mov    %ebx,%eax
  802128:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80212b:	5b                   	pop    %ebx
  80212c:	5e                   	pop    %esi
  80212d:	5d                   	pop    %ebp
  80212e:	c3                   	ret    

0080212f <accept>:
{
  80212f:	55                   	push   %ebp
  802130:	89 e5                	mov    %esp,%ebp
  802132:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802135:	8b 45 08             	mov    0x8(%ebp),%eax
  802138:	e8 4e ff ff ff       	call   80208b <fd2sockid>
  80213d:	85 c0                	test   %eax,%eax
  80213f:	78 1b                	js     80215c <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802141:	83 ec 04             	sub    $0x4,%esp
  802144:	ff 75 10             	pushl  0x10(%ebp)
  802147:	ff 75 0c             	pushl  0xc(%ebp)
  80214a:	50                   	push   %eax
  80214b:	e8 0e 01 00 00       	call   80225e <nsipc_accept>
  802150:	83 c4 10             	add    $0x10,%esp
  802153:	85 c0                	test   %eax,%eax
  802155:	78 05                	js     80215c <accept+0x2d>
	return alloc_sockfd(r);
  802157:	e8 5f ff ff ff       	call   8020bb <alloc_sockfd>
}
  80215c:	c9                   	leave  
  80215d:	c3                   	ret    

0080215e <bind>:
{
  80215e:	55                   	push   %ebp
  80215f:	89 e5                	mov    %esp,%ebp
  802161:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802164:	8b 45 08             	mov    0x8(%ebp),%eax
  802167:	e8 1f ff ff ff       	call   80208b <fd2sockid>
  80216c:	85 c0                	test   %eax,%eax
  80216e:	78 12                	js     802182 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802170:	83 ec 04             	sub    $0x4,%esp
  802173:	ff 75 10             	pushl  0x10(%ebp)
  802176:	ff 75 0c             	pushl  0xc(%ebp)
  802179:	50                   	push   %eax
  80217a:	e8 31 01 00 00       	call   8022b0 <nsipc_bind>
  80217f:	83 c4 10             	add    $0x10,%esp
}
  802182:	c9                   	leave  
  802183:	c3                   	ret    

00802184 <shutdown>:
{
  802184:	55                   	push   %ebp
  802185:	89 e5                	mov    %esp,%ebp
  802187:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80218a:	8b 45 08             	mov    0x8(%ebp),%eax
  80218d:	e8 f9 fe ff ff       	call   80208b <fd2sockid>
  802192:	85 c0                	test   %eax,%eax
  802194:	78 0f                	js     8021a5 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  802196:	83 ec 08             	sub    $0x8,%esp
  802199:	ff 75 0c             	pushl  0xc(%ebp)
  80219c:	50                   	push   %eax
  80219d:	e8 43 01 00 00       	call   8022e5 <nsipc_shutdown>
  8021a2:	83 c4 10             	add    $0x10,%esp
}
  8021a5:	c9                   	leave  
  8021a6:	c3                   	ret    

008021a7 <connect>:
{
  8021a7:	55                   	push   %ebp
  8021a8:	89 e5                	mov    %esp,%ebp
  8021aa:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8021ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b0:	e8 d6 fe ff ff       	call   80208b <fd2sockid>
  8021b5:	85 c0                	test   %eax,%eax
  8021b7:	78 12                	js     8021cb <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8021b9:	83 ec 04             	sub    $0x4,%esp
  8021bc:	ff 75 10             	pushl  0x10(%ebp)
  8021bf:	ff 75 0c             	pushl  0xc(%ebp)
  8021c2:	50                   	push   %eax
  8021c3:	e8 59 01 00 00       	call   802321 <nsipc_connect>
  8021c8:	83 c4 10             	add    $0x10,%esp
}
  8021cb:	c9                   	leave  
  8021cc:	c3                   	ret    

008021cd <listen>:
{
  8021cd:	55                   	push   %ebp
  8021ce:	89 e5                	mov    %esp,%ebp
  8021d0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8021d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d6:	e8 b0 fe ff ff       	call   80208b <fd2sockid>
  8021db:	85 c0                	test   %eax,%eax
  8021dd:	78 0f                	js     8021ee <listen+0x21>
	return nsipc_listen(r, backlog);
  8021df:	83 ec 08             	sub    $0x8,%esp
  8021e2:	ff 75 0c             	pushl  0xc(%ebp)
  8021e5:	50                   	push   %eax
  8021e6:	e8 6b 01 00 00       	call   802356 <nsipc_listen>
  8021eb:	83 c4 10             	add    $0x10,%esp
}
  8021ee:	c9                   	leave  
  8021ef:	c3                   	ret    

008021f0 <socket>:

int
socket(int domain, int type, int protocol)
{
  8021f0:	55                   	push   %ebp
  8021f1:	89 e5                	mov    %esp,%ebp
  8021f3:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8021f6:	ff 75 10             	pushl  0x10(%ebp)
  8021f9:	ff 75 0c             	pushl  0xc(%ebp)
  8021fc:	ff 75 08             	pushl  0x8(%ebp)
  8021ff:	e8 3e 02 00 00       	call   802442 <nsipc_socket>
  802204:	83 c4 10             	add    $0x10,%esp
  802207:	85 c0                	test   %eax,%eax
  802209:	78 05                	js     802210 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  80220b:	e8 ab fe ff ff       	call   8020bb <alloc_sockfd>
}
  802210:	c9                   	leave  
  802211:	c3                   	ret    

00802212 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802212:	55                   	push   %ebp
  802213:	89 e5                	mov    %esp,%ebp
  802215:	53                   	push   %ebx
  802216:	83 ec 04             	sub    $0x4,%esp
  802219:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80221b:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802222:	74 26                	je     80224a <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802224:	6a 07                	push   $0x7
  802226:	68 00 70 80 00       	push   $0x807000
  80222b:	53                   	push   %ebx
  80222c:	ff 35 04 50 80 00    	pushl  0x805004
  802232:	e8 0f f5 ff ff       	call   801746 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802237:	83 c4 0c             	add    $0xc,%esp
  80223a:	6a 00                	push   $0x0
  80223c:	6a 00                	push   $0x0
  80223e:	6a 00                	push   $0x0
  802240:	e8 98 f4 ff ff       	call   8016dd <ipc_recv>
}
  802245:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802248:	c9                   	leave  
  802249:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80224a:	83 ec 0c             	sub    $0xc,%esp
  80224d:	6a 02                	push   $0x2
  80224f:	e8 4a f5 ff ff       	call   80179e <ipc_find_env>
  802254:	a3 04 50 80 00       	mov    %eax,0x805004
  802259:	83 c4 10             	add    $0x10,%esp
  80225c:	eb c6                	jmp    802224 <nsipc+0x12>

0080225e <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80225e:	55                   	push   %ebp
  80225f:	89 e5                	mov    %esp,%ebp
  802261:	56                   	push   %esi
  802262:	53                   	push   %ebx
  802263:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802266:	8b 45 08             	mov    0x8(%ebp),%eax
  802269:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80226e:	8b 06                	mov    (%esi),%eax
  802270:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802275:	b8 01 00 00 00       	mov    $0x1,%eax
  80227a:	e8 93 ff ff ff       	call   802212 <nsipc>
  80227f:	89 c3                	mov    %eax,%ebx
  802281:	85 c0                	test   %eax,%eax
  802283:	79 09                	jns    80228e <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802285:	89 d8                	mov    %ebx,%eax
  802287:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80228a:	5b                   	pop    %ebx
  80228b:	5e                   	pop    %esi
  80228c:	5d                   	pop    %ebp
  80228d:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80228e:	83 ec 04             	sub    $0x4,%esp
  802291:	ff 35 10 70 80 00    	pushl  0x807010
  802297:	68 00 70 80 00       	push   $0x807000
  80229c:	ff 75 0c             	pushl  0xc(%ebp)
  80229f:	e8 00 ef ff ff       	call   8011a4 <memmove>
		*addrlen = ret->ret_addrlen;
  8022a4:	a1 10 70 80 00       	mov    0x807010,%eax
  8022a9:	89 06                	mov    %eax,(%esi)
  8022ab:	83 c4 10             	add    $0x10,%esp
	return r;
  8022ae:	eb d5                	jmp    802285 <nsipc_accept+0x27>

008022b0 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8022b0:	55                   	push   %ebp
  8022b1:	89 e5                	mov    %esp,%ebp
  8022b3:	53                   	push   %ebx
  8022b4:	83 ec 08             	sub    $0x8,%esp
  8022b7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8022ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bd:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8022c2:	53                   	push   %ebx
  8022c3:	ff 75 0c             	pushl  0xc(%ebp)
  8022c6:	68 04 70 80 00       	push   $0x807004
  8022cb:	e8 d4 ee ff ff       	call   8011a4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8022d0:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8022d6:	b8 02 00 00 00       	mov    $0x2,%eax
  8022db:	e8 32 ff ff ff       	call   802212 <nsipc>
}
  8022e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022e3:	c9                   	leave  
  8022e4:	c3                   	ret    

008022e5 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8022e5:	55                   	push   %ebp
  8022e6:	89 e5                	mov    %esp,%ebp
  8022e8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8022eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ee:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8022f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022f6:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8022fb:	b8 03 00 00 00       	mov    $0x3,%eax
  802300:	e8 0d ff ff ff       	call   802212 <nsipc>
}
  802305:	c9                   	leave  
  802306:	c3                   	ret    

00802307 <nsipc_close>:

int
nsipc_close(int s)
{
  802307:	55                   	push   %ebp
  802308:	89 e5                	mov    %esp,%ebp
  80230a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80230d:	8b 45 08             	mov    0x8(%ebp),%eax
  802310:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802315:	b8 04 00 00 00       	mov    $0x4,%eax
  80231a:	e8 f3 fe ff ff       	call   802212 <nsipc>
}
  80231f:	c9                   	leave  
  802320:	c3                   	ret    

00802321 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802321:	55                   	push   %ebp
  802322:	89 e5                	mov    %esp,%ebp
  802324:	53                   	push   %ebx
  802325:	83 ec 08             	sub    $0x8,%esp
  802328:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80232b:	8b 45 08             	mov    0x8(%ebp),%eax
  80232e:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802333:	53                   	push   %ebx
  802334:	ff 75 0c             	pushl  0xc(%ebp)
  802337:	68 04 70 80 00       	push   $0x807004
  80233c:	e8 63 ee ff ff       	call   8011a4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802341:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802347:	b8 05 00 00 00       	mov    $0x5,%eax
  80234c:	e8 c1 fe ff ff       	call   802212 <nsipc>
}
  802351:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802354:	c9                   	leave  
  802355:	c3                   	ret    

00802356 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802356:	55                   	push   %ebp
  802357:	89 e5                	mov    %esp,%ebp
  802359:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80235c:	8b 45 08             	mov    0x8(%ebp),%eax
  80235f:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802364:	8b 45 0c             	mov    0xc(%ebp),%eax
  802367:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80236c:	b8 06 00 00 00       	mov    $0x6,%eax
  802371:	e8 9c fe ff ff       	call   802212 <nsipc>
}
  802376:	c9                   	leave  
  802377:	c3                   	ret    

00802378 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802378:	55                   	push   %ebp
  802379:	89 e5                	mov    %esp,%ebp
  80237b:	56                   	push   %esi
  80237c:	53                   	push   %ebx
  80237d:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802380:	8b 45 08             	mov    0x8(%ebp),%eax
  802383:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802388:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  80238e:	8b 45 14             	mov    0x14(%ebp),%eax
  802391:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802396:	b8 07 00 00 00       	mov    $0x7,%eax
  80239b:	e8 72 fe ff ff       	call   802212 <nsipc>
  8023a0:	89 c3                	mov    %eax,%ebx
  8023a2:	85 c0                	test   %eax,%eax
  8023a4:	78 1f                	js     8023c5 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8023a6:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8023ab:	7f 21                	jg     8023ce <nsipc_recv+0x56>
  8023ad:	39 c6                	cmp    %eax,%esi
  8023af:	7c 1d                	jl     8023ce <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8023b1:	83 ec 04             	sub    $0x4,%esp
  8023b4:	50                   	push   %eax
  8023b5:	68 00 70 80 00       	push   $0x807000
  8023ba:	ff 75 0c             	pushl  0xc(%ebp)
  8023bd:	e8 e2 ed ff ff       	call   8011a4 <memmove>
  8023c2:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8023c5:	89 d8                	mov    %ebx,%eax
  8023c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023ca:	5b                   	pop    %ebx
  8023cb:	5e                   	pop    %esi
  8023cc:	5d                   	pop    %ebp
  8023cd:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8023ce:	68 e7 34 80 00       	push   $0x8034e7
  8023d3:	68 af 34 80 00       	push   $0x8034af
  8023d8:	6a 62                	push   $0x62
  8023da:	68 fc 34 80 00       	push   $0x8034fc
  8023df:	e8 dd e3 ff ff       	call   8007c1 <_panic>

008023e4 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8023e4:	55                   	push   %ebp
  8023e5:	89 e5                	mov    %esp,%ebp
  8023e7:	53                   	push   %ebx
  8023e8:	83 ec 04             	sub    $0x4,%esp
  8023eb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8023ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f1:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8023f6:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8023fc:	7f 2e                	jg     80242c <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8023fe:	83 ec 04             	sub    $0x4,%esp
  802401:	53                   	push   %ebx
  802402:	ff 75 0c             	pushl  0xc(%ebp)
  802405:	68 0c 70 80 00       	push   $0x80700c
  80240a:	e8 95 ed ff ff       	call   8011a4 <memmove>
	nsipcbuf.send.req_size = size;
  80240f:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802415:	8b 45 14             	mov    0x14(%ebp),%eax
  802418:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80241d:	b8 08 00 00 00       	mov    $0x8,%eax
  802422:	e8 eb fd ff ff       	call   802212 <nsipc>
}
  802427:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80242a:	c9                   	leave  
  80242b:	c3                   	ret    
	assert(size < 1600);
  80242c:	68 08 35 80 00       	push   $0x803508
  802431:	68 af 34 80 00       	push   $0x8034af
  802436:	6a 6d                	push   $0x6d
  802438:	68 fc 34 80 00       	push   $0x8034fc
  80243d:	e8 7f e3 ff ff       	call   8007c1 <_panic>

00802442 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802442:	55                   	push   %ebp
  802443:	89 e5                	mov    %esp,%ebp
  802445:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802448:	8b 45 08             	mov    0x8(%ebp),%eax
  80244b:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802450:	8b 45 0c             	mov    0xc(%ebp),%eax
  802453:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802458:	8b 45 10             	mov    0x10(%ebp),%eax
  80245b:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802460:	b8 09 00 00 00       	mov    $0x9,%eax
  802465:	e8 a8 fd ff ff       	call   802212 <nsipc>
}
  80246a:	c9                   	leave  
  80246b:	c3                   	ret    

0080246c <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80246c:	55                   	push   %ebp
  80246d:	89 e5                	mov    %esp,%ebp
  80246f:	56                   	push   %esi
  802470:	53                   	push   %ebx
  802471:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802474:	83 ec 0c             	sub    $0xc,%esp
  802477:	ff 75 08             	pushl  0x8(%ebp)
  80247a:	e8 6a f3 ff ff       	call   8017e9 <fd2data>
  80247f:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802481:	83 c4 08             	add    $0x8,%esp
  802484:	68 14 35 80 00       	push   $0x803514
  802489:	53                   	push   %ebx
  80248a:	e8 87 eb ff ff       	call   801016 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80248f:	8b 46 04             	mov    0x4(%esi),%eax
  802492:	2b 06                	sub    (%esi),%eax
  802494:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80249a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8024a1:	00 00 00 
	stat->st_dev = &devpipe;
  8024a4:	c7 83 88 00 00 00 40 	movl   $0x804040,0x88(%ebx)
  8024ab:	40 80 00 
	return 0;
}
  8024ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8024b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024b6:	5b                   	pop    %ebx
  8024b7:	5e                   	pop    %esi
  8024b8:	5d                   	pop    %ebp
  8024b9:	c3                   	ret    

008024ba <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8024ba:	55                   	push   %ebp
  8024bb:	89 e5                	mov    %esp,%ebp
  8024bd:	53                   	push   %ebx
  8024be:	83 ec 0c             	sub    $0xc,%esp
  8024c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8024c4:	53                   	push   %ebx
  8024c5:	6a 00                	push   $0x0
  8024c7:	e8 c1 ef ff ff       	call   80148d <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8024cc:	89 1c 24             	mov    %ebx,(%esp)
  8024cf:	e8 15 f3 ff ff       	call   8017e9 <fd2data>
  8024d4:	83 c4 08             	add    $0x8,%esp
  8024d7:	50                   	push   %eax
  8024d8:	6a 00                	push   $0x0
  8024da:	e8 ae ef ff ff       	call   80148d <sys_page_unmap>
}
  8024df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024e2:	c9                   	leave  
  8024e3:	c3                   	ret    

008024e4 <_pipeisclosed>:
{
  8024e4:	55                   	push   %ebp
  8024e5:	89 e5                	mov    %esp,%ebp
  8024e7:	57                   	push   %edi
  8024e8:	56                   	push   %esi
  8024e9:	53                   	push   %ebx
  8024ea:	83 ec 1c             	sub    $0x1c,%esp
  8024ed:	89 c7                	mov    %eax,%edi
  8024ef:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8024f1:	a1 08 50 80 00       	mov    0x805008,%eax
  8024f6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8024f9:	83 ec 0c             	sub    $0xc,%esp
  8024fc:	57                   	push   %edi
  8024fd:	e8 2d 04 00 00       	call   80292f <pageref>
  802502:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802505:	89 34 24             	mov    %esi,(%esp)
  802508:	e8 22 04 00 00       	call   80292f <pageref>
		nn = thisenv->env_runs;
  80250d:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802513:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802516:	83 c4 10             	add    $0x10,%esp
  802519:	39 cb                	cmp    %ecx,%ebx
  80251b:	74 1b                	je     802538 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80251d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802520:	75 cf                	jne    8024f1 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802522:	8b 42 58             	mov    0x58(%edx),%eax
  802525:	6a 01                	push   $0x1
  802527:	50                   	push   %eax
  802528:	53                   	push   %ebx
  802529:	68 1b 35 80 00       	push   $0x80351b
  80252e:	e8 84 e3 ff ff       	call   8008b7 <cprintf>
  802533:	83 c4 10             	add    $0x10,%esp
  802536:	eb b9                	jmp    8024f1 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802538:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80253b:	0f 94 c0             	sete   %al
  80253e:	0f b6 c0             	movzbl %al,%eax
}
  802541:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802544:	5b                   	pop    %ebx
  802545:	5e                   	pop    %esi
  802546:	5f                   	pop    %edi
  802547:	5d                   	pop    %ebp
  802548:	c3                   	ret    

00802549 <devpipe_write>:
{
  802549:	55                   	push   %ebp
  80254a:	89 e5                	mov    %esp,%ebp
  80254c:	57                   	push   %edi
  80254d:	56                   	push   %esi
  80254e:	53                   	push   %ebx
  80254f:	83 ec 28             	sub    $0x28,%esp
  802552:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802555:	56                   	push   %esi
  802556:	e8 8e f2 ff ff       	call   8017e9 <fd2data>
  80255b:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80255d:	83 c4 10             	add    $0x10,%esp
  802560:	bf 00 00 00 00       	mov    $0x0,%edi
  802565:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802568:	74 4f                	je     8025b9 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80256a:	8b 43 04             	mov    0x4(%ebx),%eax
  80256d:	8b 0b                	mov    (%ebx),%ecx
  80256f:	8d 51 20             	lea    0x20(%ecx),%edx
  802572:	39 d0                	cmp    %edx,%eax
  802574:	72 14                	jb     80258a <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802576:	89 da                	mov    %ebx,%edx
  802578:	89 f0                	mov    %esi,%eax
  80257a:	e8 65 ff ff ff       	call   8024e4 <_pipeisclosed>
  80257f:	85 c0                	test   %eax,%eax
  802581:	75 3b                	jne    8025be <devpipe_write+0x75>
			sys_yield();
  802583:	e8 61 ee ff ff       	call   8013e9 <sys_yield>
  802588:	eb e0                	jmp    80256a <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80258a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80258d:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802591:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802594:	89 c2                	mov    %eax,%edx
  802596:	c1 fa 1f             	sar    $0x1f,%edx
  802599:	89 d1                	mov    %edx,%ecx
  80259b:	c1 e9 1b             	shr    $0x1b,%ecx
  80259e:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8025a1:	83 e2 1f             	and    $0x1f,%edx
  8025a4:	29 ca                	sub    %ecx,%edx
  8025a6:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8025aa:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8025ae:	83 c0 01             	add    $0x1,%eax
  8025b1:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8025b4:	83 c7 01             	add    $0x1,%edi
  8025b7:	eb ac                	jmp    802565 <devpipe_write+0x1c>
	return i;
  8025b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8025bc:	eb 05                	jmp    8025c3 <devpipe_write+0x7a>
				return 0;
  8025be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025c6:	5b                   	pop    %ebx
  8025c7:	5e                   	pop    %esi
  8025c8:	5f                   	pop    %edi
  8025c9:	5d                   	pop    %ebp
  8025ca:	c3                   	ret    

008025cb <devpipe_read>:
{
  8025cb:	55                   	push   %ebp
  8025cc:	89 e5                	mov    %esp,%ebp
  8025ce:	57                   	push   %edi
  8025cf:	56                   	push   %esi
  8025d0:	53                   	push   %ebx
  8025d1:	83 ec 18             	sub    $0x18,%esp
  8025d4:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8025d7:	57                   	push   %edi
  8025d8:	e8 0c f2 ff ff       	call   8017e9 <fd2data>
  8025dd:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8025df:	83 c4 10             	add    $0x10,%esp
  8025e2:	be 00 00 00 00       	mov    $0x0,%esi
  8025e7:	3b 75 10             	cmp    0x10(%ebp),%esi
  8025ea:	75 14                	jne    802600 <devpipe_read+0x35>
	return i;
  8025ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8025ef:	eb 02                	jmp    8025f3 <devpipe_read+0x28>
				return i;
  8025f1:	89 f0                	mov    %esi,%eax
}
  8025f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025f6:	5b                   	pop    %ebx
  8025f7:	5e                   	pop    %esi
  8025f8:	5f                   	pop    %edi
  8025f9:	5d                   	pop    %ebp
  8025fa:	c3                   	ret    
			sys_yield();
  8025fb:	e8 e9 ed ff ff       	call   8013e9 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802600:	8b 03                	mov    (%ebx),%eax
  802602:	3b 43 04             	cmp    0x4(%ebx),%eax
  802605:	75 18                	jne    80261f <devpipe_read+0x54>
			if (i > 0)
  802607:	85 f6                	test   %esi,%esi
  802609:	75 e6                	jne    8025f1 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  80260b:	89 da                	mov    %ebx,%edx
  80260d:	89 f8                	mov    %edi,%eax
  80260f:	e8 d0 fe ff ff       	call   8024e4 <_pipeisclosed>
  802614:	85 c0                	test   %eax,%eax
  802616:	74 e3                	je     8025fb <devpipe_read+0x30>
				return 0;
  802618:	b8 00 00 00 00       	mov    $0x0,%eax
  80261d:	eb d4                	jmp    8025f3 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80261f:	99                   	cltd   
  802620:	c1 ea 1b             	shr    $0x1b,%edx
  802623:	01 d0                	add    %edx,%eax
  802625:	83 e0 1f             	and    $0x1f,%eax
  802628:	29 d0                	sub    %edx,%eax
  80262a:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80262f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802632:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802635:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802638:	83 c6 01             	add    $0x1,%esi
  80263b:	eb aa                	jmp    8025e7 <devpipe_read+0x1c>

0080263d <pipe>:
{
  80263d:	55                   	push   %ebp
  80263e:	89 e5                	mov    %esp,%ebp
  802640:	56                   	push   %esi
  802641:	53                   	push   %ebx
  802642:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802645:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802648:	50                   	push   %eax
  802649:	e8 b2 f1 ff ff       	call   801800 <fd_alloc>
  80264e:	89 c3                	mov    %eax,%ebx
  802650:	83 c4 10             	add    $0x10,%esp
  802653:	85 c0                	test   %eax,%eax
  802655:	0f 88 23 01 00 00    	js     80277e <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80265b:	83 ec 04             	sub    $0x4,%esp
  80265e:	68 07 04 00 00       	push   $0x407
  802663:	ff 75 f4             	pushl  -0xc(%ebp)
  802666:	6a 00                	push   $0x0
  802668:	e8 9b ed ff ff       	call   801408 <sys_page_alloc>
  80266d:	89 c3                	mov    %eax,%ebx
  80266f:	83 c4 10             	add    $0x10,%esp
  802672:	85 c0                	test   %eax,%eax
  802674:	0f 88 04 01 00 00    	js     80277e <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80267a:	83 ec 0c             	sub    $0xc,%esp
  80267d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802680:	50                   	push   %eax
  802681:	e8 7a f1 ff ff       	call   801800 <fd_alloc>
  802686:	89 c3                	mov    %eax,%ebx
  802688:	83 c4 10             	add    $0x10,%esp
  80268b:	85 c0                	test   %eax,%eax
  80268d:	0f 88 db 00 00 00    	js     80276e <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802693:	83 ec 04             	sub    $0x4,%esp
  802696:	68 07 04 00 00       	push   $0x407
  80269b:	ff 75 f0             	pushl  -0x10(%ebp)
  80269e:	6a 00                	push   $0x0
  8026a0:	e8 63 ed ff ff       	call   801408 <sys_page_alloc>
  8026a5:	89 c3                	mov    %eax,%ebx
  8026a7:	83 c4 10             	add    $0x10,%esp
  8026aa:	85 c0                	test   %eax,%eax
  8026ac:	0f 88 bc 00 00 00    	js     80276e <pipe+0x131>
	va = fd2data(fd0);
  8026b2:	83 ec 0c             	sub    $0xc,%esp
  8026b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8026b8:	e8 2c f1 ff ff       	call   8017e9 <fd2data>
  8026bd:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026bf:	83 c4 0c             	add    $0xc,%esp
  8026c2:	68 07 04 00 00       	push   $0x407
  8026c7:	50                   	push   %eax
  8026c8:	6a 00                	push   $0x0
  8026ca:	e8 39 ed ff ff       	call   801408 <sys_page_alloc>
  8026cf:	89 c3                	mov    %eax,%ebx
  8026d1:	83 c4 10             	add    $0x10,%esp
  8026d4:	85 c0                	test   %eax,%eax
  8026d6:	0f 88 82 00 00 00    	js     80275e <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026dc:	83 ec 0c             	sub    $0xc,%esp
  8026df:	ff 75 f0             	pushl  -0x10(%ebp)
  8026e2:	e8 02 f1 ff ff       	call   8017e9 <fd2data>
  8026e7:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8026ee:	50                   	push   %eax
  8026ef:	6a 00                	push   $0x0
  8026f1:	56                   	push   %esi
  8026f2:	6a 00                	push   $0x0
  8026f4:	e8 52 ed ff ff       	call   80144b <sys_page_map>
  8026f9:	89 c3                	mov    %eax,%ebx
  8026fb:	83 c4 20             	add    $0x20,%esp
  8026fe:	85 c0                	test   %eax,%eax
  802700:	78 4e                	js     802750 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802702:	a1 40 40 80 00       	mov    0x804040,%eax
  802707:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80270a:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80270c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80270f:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802716:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802719:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80271b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80271e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802725:	83 ec 0c             	sub    $0xc,%esp
  802728:	ff 75 f4             	pushl  -0xc(%ebp)
  80272b:	e8 a9 f0 ff ff       	call   8017d9 <fd2num>
  802730:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802733:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802735:	83 c4 04             	add    $0x4,%esp
  802738:	ff 75 f0             	pushl  -0x10(%ebp)
  80273b:	e8 99 f0 ff ff       	call   8017d9 <fd2num>
  802740:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802743:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802746:	83 c4 10             	add    $0x10,%esp
  802749:	bb 00 00 00 00       	mov    $0x0,%ebx
  80274e:	eb 2e                	jmp    80277e <pipe+0x141>
	sys_page_unmap(0, va);
  802750:	83 ec 08             	sub    $0x8,%esp
  802753:	56                   	push   %esi
  802754:	6a 00                	push   $0x0
  802756:	e8 32 ed ff ff       	call   80148d <sys_page_unmap>
  80275b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80275e:	83 ec 08             	sub    $0x8,%esp
  802761:	ff 75 f0             	pushl  -0x10(%ebp)
  802764:	6a 00                	push   $0x0
  802766:	e8 22 ed ff ff       	call   80148d <sys_page_unmap>
  80276b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80276e:	83 ec 08             	sub    $0x8,%esp
  802771:	ff 75 f4             	pushl  -0xc(%ebp)
  802774:	6a 00                	push   $0x0
  802776:	e8 12 ed ff ff       	call   80148d <sys_page_unmap>
  80277b:	83 c4 10             	add    $0x10,%esp
}
  80277e:	89 d8                	mov    %ebx,%eax
  802780:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802783:	5b                   	pop    %ebx
  802784:	5e                   	pop    %esi
  802785:	5d                   	pop    %ebp
  802786:	c3                   	ret    

00802787 <pipeisclosed>:
{
  802787:	55                   	push   %ebp
  802788:	89 e5                	mov    %esp,%ebp
  80278a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80278d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802790:	50                   	push   %eax
  802791:	ff 75 08             	pushl  0x8(%ebp)
  802794:	e8 b9 f0 ff ff       	call   801852 <fd_lookup>
  802799:	83 c4 10             	add    $0x10,%esp
  80279c:	85 c0                	test   %eax,%eax
  80279e:	78 18                	js     8027b8 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8027a0:	83 ec 0c             	sub    $0xc,%esp
  8027a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8027a6:	e8 3e f0 ff ff       	call   8017e9 <fd2data>
	return _pipeisclosed(fd, p);
  8027ab:	89 c2                	mov    %eax,%edx
  8027ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b0:	e8 2f fd ff ff       	call   8024e4 <_pipeisclosed>
  8027b5:	83 c4 10             	add    $0x10,%esp
}
  8027b8:	c9                   	leave  
  8027b9:	c3                   	ret    

008027ba <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8027ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8027bf:	c3                   	ret    

008027c0 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8027c0:	55                   	push   %ebp
  8027c1:	89 e5                	mov    %esp,%ebp
  8027c3:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8027c6:	68 33 35 80 00       	push   $0x803533
  8027cb:	ff 75 0c             	pushl  0xc(%ebp)
  8027ce:	e8 43 e8 ff ff       	call   801016 <strcpy>
	return 0;
}
  8027d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d8:	c9                   	leave  
  8027d9:	c3                   	ret    

008027da <devcons_write>:
{
  8027da:	55                   	push   %ebp
  8027db:	89 e5                	mov    %esp,%ebp
  8027dd:	57                   	push   %edi
  8027de:	56                   	push   %esi
  8027df:	53                   	push   %ebx
  8027e0:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8027e6:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8027eb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8027f1:	3b 75 10             	cmp    0x10(%ebp),%esi
  8027f4:	73 31                	jae    802827 <devcons_write+0x4d>
		m = n - tot;
  8027f6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8027f9:	29 f3                	sub    %esi,%ebx
  8027fb:	83 fb 7f             	cmp    $0x7f,%ebx
  8027fe:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802803:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802806:	83 ec 04             	sub    $0x4,%esp
  802809:	53                   	push   %ebx
  80280a:	89 f0                	mov    %esi,%eax
  80280c:	03 45 0c             	add    0xc(%ebp),%eax
  80280f:	50                   	push   %eax
  802810:	57                   	push   %edi
  802811:	e8 8e e9 ff ff       	call   8011a4 <memmove>
		sys_cputs(buf, m);
  802816:	83 c4 08             	add    $0x8,%esp
  802819:	53                   	push   %ebx
  80281a:	57                   	push   %edi
  80281b:	e8 2c eb ff ff       	call   80134c <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802820:	01 de                	add    %ebx,%esi
  802822:	83 c4 10             	add    $0x10,%esp
  802825:	eb ca                	jmp    8027f1 <devcons_write+0x17>
}
  802827:	89 f0                	mov    %esi,%eax
  802829:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80282c:	5b                   	pop    %ebx
  80282d:	5e                   	pop    %esi
  80282e:	5f                   	pop    %edi
  80282f:	5d                   	pop    %ebp
  802830:	c3                   	ret    

00802831 <devcons_read>:
{
  802831:	55                   	push   %ebp
  802832:	89 e5                	mov    %esp,%ebp
  802834:	83 ec 08             	sub    $0x8,%esp
  802837:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80283c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802840:	74 21                	je     802863 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802842:	e8 23 eb ff ff       	call   80136a <sys_cgetc>
  802847:	85 c0                	test   %eax,%eax
  802849:	75 07                	jne    802852 <devcons_read+0x21>
		sys_yield();
  80284b:	e8 99 eb ff ff       	call   8013e9 <sys_yield>
  802850:	eb f0                	jmp    802842 <devcons_read+0x11>
	if (c < 0)
  802852:	78 0f                	js     802863 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802854:	83 f8 04             	cmp    $0x4,%eax
  802857:	74 0c                	je     802865 <devcons_read+0x34>
	*(char*)vbuf = c;
  802859:	8b 55 0c             	mov    0xc(%ebp),%edx
  80285c:	88 02                	mov    %al,(%edx)
	return 1;
  80285e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802863:	c9                   	leave  
  802864:	c3                   	ret    
		return 0;
  802865:	b8 00 00 00 00       	mov    $0x0,%eax
  80286a:	eb f7                	jmp    802863 <devcons_read+0x32>

0080286c <cputchar>:
{
  80286c:	55                   	push   %ebp
  80286d:	89 e5                	mov    %esp,%ebp
  80286f:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802872:	8b 45 08             	mov    0x8(%ebp),%eax
  802875:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802878:	6a 01                	push   $0x1
  80287a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80287d:	50                   	push   %eax
  80287e:	e8 c9 ea ff ff       	call   80134c <sys_cputs>
}
  802883:	83 c4 10             	add    $0x10,%esp
  802886:	c9                   	leave  
  802887:	c3                   	ret    

00802888 <getchar>:
{
  802888:	55                   	push   %ebp
  802889:	89 e5                	mov    %esp,%ebp
  80288b:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80288e:	6a 01                	push   $0x1
  802890:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802893:	50                   	push   %eax
  802894:	6a 00                	push   $0x0
  802896:	e8 27 f2 ff ff       	call   801ac2 <read>
	if (r < 0)
  80289b:	83 c4 10             	add    $0x10,%esp
  80289e:	85 c0                	test   %eax,%eax
  8028a0:	78 06                	js     8028a8 <getchar+0x20>
	if (r < 1)
  8028a2:	74 06                	je     8028aa <getchar+0x22>
	return c;
  8028a4:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8028a8:	c9                   	leave  
  8028a9:	c3                   	ret    
		return -E_EOF;
  8028aa:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8028af:	eb f7                	jmp    8028a8 <getchar+0x20>

008028b1 <iscons>:
{
  8028b1:	55                   	push   %ebp
  8028b2:	89 e5                	mov    %esp,%ebp
  8028b4:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8028b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028ba:	50                   	push   %eax
  8028bb:	ff 75 08             	pushl  0x8(%ebp)
  8028be:	e8 8f ef ff ff       	call   801852 <fd_lookup>
  8028c3:	83 c4 10             	add    $0x10,%esp
  8028c6:	85 c0                	test   %eax,%eax
  8028c8:	78 11                	js     8028db <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8028ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cd:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  8028d3:	39 10                	cmp    %edx,(%eax)
  8028d5:	0f 94 c0             	sete   %al
  8028d8:	0f b6 c0             	movzbl %al,%eax
}
  8028db:	c9                   	leave  
  8028dc:	c3                   	ret    

008028dd <opencons>:
{
  8028dd:	55                   	push   %ebp
  8028de:	89 e5                	mov    %esp,%ebp
  8028e0:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8028e3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028e6:	50                   	push   %eax
  8028e7:	e8 14 ef ff ff       	call   801800 <fd_alloc>
  8028ec:	83 c4 10             	add    $0x10,%esp
  8028ef:	85 c0                	test   %eax,%eax
  8028f1:	78 3a                	js     80292d <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8028f3:	83 ec 04             	sub    $0x4,%esp
  8028f6:	68 07 04 00 00       	push   $0x407
  8028fb:	ff 75 f4             	pushl  -0xc(%ebp)
  8028fe:	6a 00                	push   $0x0
  802900:	e8 03 eb ff ff       	call   801408 <sys_page_alloc>
  802905:	83 c4 10             	add    $0x10,%esp
  802908:	85 c0                	test   %eax,%eax
  80290a:	78 21                	js     80292d <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80290c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290f:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  802915:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802917:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802921:	83 ec 0c             	sub    $0xc,%esp
  802924:	50                   	push   %eax
  802925:	e8 af ee ff ff       	call   8017d9 <fd2num>
  80292a:	83 c4 10             	add    $0x10,%esp
}
  80292d:	c9                   	leave  
  80292e:	c3                   	ret    

0080292f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80292f:	55                   	push   %ebp
  802930:	89 e5                	mov    %esp,%ebp
  802932:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802935:	89 d0                	mov    %edx,%eax
  802937:	c1 e8 16             	shr    $0x16,%eax
  80293a:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802941:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802946:	f6 c1 01             	test   $0x1,%cl
  802949:	74 1d                	je     802968 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80294b:	c1 ea 0c             	shr    $0xc,%edx
  80294e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802955:	f6 c2 01             	test   $0x1,%dl
  802958:	74 0e                	je     802968 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80295a:	c1 ea 0c             	shr    $0xc,%edx
  80295d:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802964:	ef 
  802965:	0f b7 c0             	movzwl %ax,%eax
}
  802968:	5d                   	pop    %ebp
  802969:	c3                   	ret    
  80296a:	66 90                	xchg   %ax,%ax
  80296c:	66 90                	xchg   %ax,%ax
  80296e:	66 90                	xchg   %ax,%ax

00802970 <__udivdi3>:
  802970:	55                   	push   %ebp
  802971:	57                   	push   %edi
  802972:	56                   	push   %esi
  802973:	53                   	push   %ebx
  802974:	83 ec 1c             	sub    $0x1c,%esp
  802977:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80297b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80297f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802983:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802987:	85 d2                	test   %edx,%edx
  802989:	75 4d                	jne    8029d8 <__udivdi3+0x68>
  80298b:	39 f3                	cmp    %esi,%ebx
  80298d:	76 19                	jbe    8029a8 <__udivdi3+0x38>
  80298f:	31 ff                	xor    %edi,%edi
  802991:	89 e8                	mov    %ebp,%eax
  802993:	89 f2                	mov    %esi,%edx
  802995:	f7 f3                	div    %ebx
  802997:	89 fa                	mov    %edi,%edx
  802999:	83 c4 1c             	add    $0x1c,%esp
  80299c:	5b                   	pop    %ebx
  80299d:	5e                   	pop    %esi
  80299e:	5f                   	pop    %edi
  80299f:	5d                   	pop    %ebp
  8029a0:	c3                   	ret    
  8029a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029a8:	89 d9                	mov    %ebx,%ecx
  8029aa:	85 db                	test   %ebx,%ebx
  8029ac:	75 0b                	jne    8029b9 <__udivdi3+0x49>
  8029ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8029b3:	31 d2                	xor    %edx,%edx
  8029b5:	f7 f3                	div    %ebx
  8029b7:	89 c1                	mov    %eax,%ecx
  8029b9:	31 d2                	xor    %edx,%edx
  8029bb:	89 f0                	mov    %esi,%eax
  8029bd:	f7 f1                	div    %ecx
  8029bf:	89 c6                	mov    %eax,%esi
  8029c1:	89 e8                	mov    %ebp,%eax
  8029c3:	89 f7                	mov    %esi,%edi
  8029c5:	f7 f1                	div    %ecx
  8029c7:	89 fa                	mov    %edi,%edx
  8029c9:	83 c4 1c             	add    $0x1c,%esp
  8029cc:	5b                   	pop    %ebx
  8029cd:	5e                   	pop    %esi
  8029ce:	5f                   	pop    %edi
  8029cf:	5d                   	pop    %ebp
  8029d0:	c3                   	ret    
  8029d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029d8:	39 f2                	cmp    %esi,%edx
  8029da:	77 1c                	ja     8029f8 <__udivdi3+0x88>
  8029dc:	0f bd fa             	bsr    %edx,%edi
  8029df:	83 f7 1f             	xor    $0x1f,%edi
  8029e2:	75 2c                	jne    802a10 <__udivdi3+0xa0>
  8029e4:	39 f2                	cmp    %esi,%edx
  8029e6:	72 06                	jb     8029ee <__udivdi3+0x7e>
  8029e8:	31 c0                	xor    %eax,%eax
  8029ea:	39 eb                	cmp    %ebp,%ebx
  8029ec:	77 a9                	ja     802997 <__udivdi3+0x27>
  8029ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8029f3:	eb a2                	jmp    802997 <__udivdi3+0x27>
  8029f5:	8d 76 00             	lea    0x0(%esi),%esi
  8029f8:	31 ff                	xor    %edi,%edi
  8029fa:	31 c0                	xor    %eax,%eax
  8029fc:	89 fa                	mov    %edi,%edx
  8029fe:	83 c4 1c             	add    $0x1c,%esp
  802a01:	5b                   	pop    %ebx
  802a02:	5e                   	pop    %esi
  802a03:	5f                   	pop    %edi
  802a04:	5d                   	pop    %ebp
  802a05:	c3                   	ret    
  802a06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a0d:	8d 76 00             	lea    0x0(%esi),%esi
  802a10:	89 f9                	mov    %edi,%ecx
  802a12:	b8 20 00 00 00       	mov    $0x20,%eax
  802a17:	29 f8                	sub    %edi,%eax
  802a19:	d3 e2                	shl    %cl,%edx
  802a1b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802a1f:	89 c1                	mov    %eax,%ecx
  802a21:	89 da                	mov    %ebx,%edx
  802a23:	d3 ea                	shr    %cl,%edx
  802a25:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802a29:	09 d1                	or     %edx,%ecx
  802a2b:	89 f2                	mov    %esi,%edx
  802a2d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a31:	89 f9                	mov    %edi,%ecx
  802a33:	d3 e3                	shl    %cl,%ebx
  802a35:	89 c1                	mov    %eax,%ecx
  802a37:	d3 ea                	shr    %cl,%edx
  802a39:	89 f9                	mov    %edi,%ecx
  802a3b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802a3f:	89 eb                	mov    %ebp,%ebx
  802a41:	d3 e6                	shl    %cl,%esi
  802a43:	89 c1                	mov    %eax,%ecx
  802a45:	d3 eb                	shr    %cl,%ebx
  802a47:	09 de                	or     %ebx,%esi
  802a49:	89 f0                	mov    %esi,%eax
  802a4b:	f7 74 24 08          	divl   0x8(%esp)
  802a4f:	89 d6                	mov    %edx,%esi
  802a51:	89 c3                	mov    %eax,%ebx
  802a53:	f7 64 24 0c          	mull   0xc(%esp)
  802a57:	39 d6                	cmp    %edx,%esi
  802a59:	72 15                	jb     802a70 <__udivdi3+0x100>
  802a5b:	89 f9                	mov    %edi,%ecx
  802a5d:	d3 e5                	shl    %cl,%ebp
  802a5f:	39 c5                	cmp    %eax,%ebp
  802a61:	73 04                	jae    802a67 <__udivdi3+0xf7>
  802a63:	39 d6                	cmp    %edx,%esi
  802a65:	74 09                	je     802a70 <__udivdi3+0x100>
  802a67:	89 d8                	mov    %ebx,%eax
  802a69:	31 ff                	xor    %edi,%edi
  802a6b:	e9 27 ff ff ff       	jmp    802997 <__udivdi3+0x27>
  802a70:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802a73:	31 ff                	xor    %edi,%edi
  802a75:	e9 1d ff ff ff       	jmp    802997 <__udivdi3+0x27>
  802a7a:	66 90                	xchg   %ax,%ax
  802a7c:	66 90                	xchg   %ax,%ax
  802a7e:	66 90                	xchg   %ax,%ax

00802a80 <__umoddi3>:
  802a80:	55                   	push   %ebp
  802a81:	57                   	push   %edi
  802a82:	56                   	push   %esi
  802a83:	53                   	push   %ebx
  802a84:	83 ec 1c             	sub    $0x1c,%esp
  802a87:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802a8b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802a8f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802a93:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a97:	89 da                	mov    %ebx,%edx
  802a99:	85 c0                	test   %eax,%eax
  802a9b:	75 43                	jne    802ae0 <__umoddi3+0x60>
  802a9d:	39 df                	cmp    %ebx,%edi
  802a9f:	76 17                	jbe    802ab8 <__umoddi3+0x38>
  802aa1:	89 f0                	mov    %esi,%eax
  802aa3:	f7 f7                	div    %edi
  802aa5:	89 d0                	mov    %edx,%eax
  802aa7:	31 d2                	xor    %edx,%edx
  802aa9:	83 c4 1c             	add    $0x1c,%esp
  802aac:	5b                   	pop    %ebx
  802aad:	5e                   	pop    %esi
  802aae:	5f                   	pop    %edi
  802aaf:	5d                   	pop    %ebp
  802ab0:	c3                   	ret    
  802ab1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ab8:	89 fd                	mov    %edi,%ebp
  802aba:	85 ff                	test   %edi,%edi
  802abc:	75 0b                	jne    802ac9 <__umoddi3+0x49>
  802abe:	b8 01 00 00 00       	mov    $0x1,%eax
  802ac3:	31 d2                	xor    %edx,%edx
  802ac5:	f7 f7                	div    %edi
  802ac7:	89 c5                	mov    %eax,%ebp
  802ac9:	89 d8                	mov    %ebx,%eax
  802acb:	31 d2                	xor    %edx,%edx
  802acd:	f7 f5                	div    %ebp
  802acf:	89 f0                	mov    %esi,%eax
  802ad1:	f7 f5                	div    %ebp
  802ad3:	89 d0                	mov    %edx,%eax
  802ad5:	eb d0                	jmp    802aa7 <__umoddi3+0x27>
  802ad7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ade:	66 90                	xchg   %ax,%ax
  802ae0:	89 f1                	mov    %esi,%ecx
  802ae2:	39 d8                	cmp    %ebx,%eax
  802ae4:	76 0a                	jbe    802af0 <__umoddi3+0x70>
  802ae6:	89 f0                	mov    %esi,%eax
  802ae8:	83 c4 1c             	add    $0x1c,%esp
  802aeb:	5b                   	pop    %ebx
  802aec:	5e                   	pop    %esi
  802aed:	5f                   	pop    %edi
  802aee:	5d                   	pop    %ebp
  802aef:	c3                   	ret    
  802af0:	0f bd e8             	bsr    %eax,%ebp
  802af3:	83 f5 1f             	xor    $0x1f,%ebp
  802af6:	75 20                	jne    802b18 <__umoddi3+0x98>
  802af8:	39 d8                	cmp    %ebx,%eax
  802afa:	0f 82 b0 00 00 00    	jb     802bb0 <__umoddi3+0x130>
  802b00:	39 f7                	cmp    %esi,%edi
  802b02:	0f 86 a8 00 00 00    	jbe    802bb0 <__umoddi3+0x130>
  802b08:	89 c8                	mov    %ecx,%eax
  802b0a:	83 c4 1c             	add    $0x1c,%esp
  802b0d:	5b                   	pop    %ebx
  802b0e:	5e                   	pop    %esi
  802b0f:	5f                   	pop    %edi
  802b10:	5d                   	pop    %ebp
  802b11:	c3                   	ret    
  802b12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802b18:	89 e9                	mov    %ebp,%ecx
  802b1a:	ba 20 00 00 00       	mov    $0x20,%edx
  802b1f:	29 ea                	sub    %ebp,%edx
  802b21:	d3 e0                	shl    %cl,%eax
  802b23:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b27:	89 d1                	mov    %edx,%ecx
  802b29:	89 f8                	mov    %edi,%eax
  802b2b:	d3 e8                	shr    %cl,%eax
  802b2d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802b31:	89 54 24 04          	mov    %edx,0x4(%esp)
  802b35:	8b 54 24 04          	mov    0x4(%esp),%edx
  802b39:	09 c1                	or     %eax,%ecx
  802b3b:	89 d8                	mov    %ebx,%eax
  802b3d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b41:	89 e9                	mov    %ebp,%ecx
  802b43:	d3 e7                	shl    %cl,%edi
  802b45:	89 d1                	mov    %edx,%ecx
  802b47:	d3 e8                	shr    %cl,%eax
  802b49:	89 e9                	mov    %ebp,%ecx
  802b4b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b4f:	d3 e3                	shl    %cl,%ebx
  802b51:	89 c7                	mov    %eax,%edi
  802b53:	89 d1                	mov    %edx,%ecx
  802b55:	89 f0                	mov    %esi,%eax
  802b57:	d3 e8                	shr    %cl,%eax
  802b59:	89 e9                	mov    %ebp,%ecx
  802b5b:	89 fa                	mov    %edi,%edx
  802b5d:	d3 e6                	shl    %cl,%esi
  802b5f:	09 d8                	or     %ebx,%eax
  802b61:	f7 74 24 08          	divl   0x8(%esp)
  802b65:	89 d1                	mov    %edx,%ecx
  802b67:	89 f3                	mov    %esi,%ebx
  802b69:	f7 64 24 0c          	mull   0xc(%esp)
  802b6d:	89 c6                	mov    %eax,%esi
  802b6f:	89 d7                	mov    %edx,%edi
  802b71:	39 d1                	cmp    %edx,%ecx
  802b73:	72 06                	jb     802b7b <__umoddi3+0xfb>
  802b75:	75 10                	jne    802b87 <__umoddi3+0x107>
  802b77:	39 c3                	cmp    %eax,%ebx
  802b79:	73 0c                	jae    802b87 <__umoddi3+0x107>
  802b7b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802b7f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802b83:	89 d7                	mov    %edx,%edi
  802b85:	89 c6                	mov    %eax,%esi
  802b87:	89 ca                	mov    %ecx,%edx
  802b89:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802b8e:	29 f3                	sub    %esi,%ebx
  802b90:	19 fa                	sbb    %edi,%edx
  802b92:	89 d0                	mov    %edx,%eax
  802b94:	d3 e0                	shl    %cl,%eax
  802b96:	89 e9                	mov    %ebp,%ecx
  802b98:	d3 eb                	shr    %cl,%ebx
  802b9a:	d3 ea                	shr    %cl,%edx
  802b9c:	09 d8                	or     %ebx,%eax
  802b9e:	83 c4 1c             	add    $0x1c,%esp
  802ba1:	5b                   	pop    %ebx
  802ba2:	5e                   	pop    %esi
  802ba3:	5f                   	pop    %edi
  802ba4:	5d                   	pop    %ebp
  802ba5:	c3                   	ret    
  802ba6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802bad:	8d 76 00             	lea    0x0(%esi),%esi
  802bb0:	89 da                	mov    %ebx,%edx
  802bb2:	29 fe                	sub    %edi,%esi
  802bb4:	19 c2                	sbb    %eax,%edx
  802bb6:	89 f1                	mov    %esi,%ecx
  802bb8:	89 c8                	mov    %ecx,%eax
  802bba:	e9 4b ff ff ff       	jmp    802b0a <__umoddi3+0x8a>
