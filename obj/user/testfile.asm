
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
  800042:	e8 d1 0f 00 00       	call   801018 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800047:	89 1d 00 64 80 00    	mov    %ebx,0x806400

	fsenv = ipc_find_env(ENV_TYPE_FS);
  80004d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800054:	e8 67 17 00 00       	call   8017c0 <ipc_find_env>
	ipc_send(fsenv, FSREQ_OPEN, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800059:	6a 07                	push   $0x7
  80005b:	68 00 60 80 00       	push   $0x806000
  800060:	6a 01                	push   $0x1
  800062:	50                   	push   %eax
  800063:	e8 00 17 00 00       	call   801768 <ipc_send>
	return ipc_recv(NULL, FVA, NULL);
  800068:	83 c4 1c             	add    $0x1c,%esp
  80006b:	6a 00                	push   $0x0
  80006d:	68 00 c0 cc cc       	push   $0xccccc000
  800072:	6a 00                	push   $0x0
  800074:	e8 86 16 00 00       	call   8016ff <ipc_recv>
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
  80008f:	b8 e0 2b 80 00       	mov    $0x802be0,%eax
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
  8000b3:	b8 15 2c 80 00       	mov    $0x802c15,%eax
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
  8000ef:	68 36 2c 80 00       	push   $0x802c36
  8000f4:	e8 c0 07 00 00       	call   8008b9 <cprintf>

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
  800122:	e8 b8 0e 00 00       	call   800fdf <strlen>
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  80012d:	0f 85 d2 03 00 00    	jne    800505 <umain+0x487>
		panic("file_stat returned size %d wanted %d\n", st.st_size, strlen(msg));
	cprintf("file_stat is good\n");
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	68 58 2c 80 00       	push   $0x802c58
  80013b:	e8 79 07 00 00       	call   8008b9 <cprintf>

	memset(buf, 0, sizeof buf);
  800140:	83 c4 0c             	add    $0xc,%esp
  800143:	68 00 02 00 00       	push   $0x200
  800148:	6a 00                	push   $0x0
  80014a:	8d 9d 4c fd ff ff    	lea    -0x2b4(%ebp),%ebx
  800150:	53                   	push   %ebx
  800151:	e8 08 10 00 00       	call   80115e <memset>
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
  800185:	e8 39 0f 00 00       	call   8010c3 <strcmp>
  80018a:	83 c4 10             	add    $0x10,%esp
  80018d:	85 c0                	test   %eax,%eax
  80018f:	0f 85 a7 03 00 00    	jne    80053c <umain+0x4be>
		panic("file_read returned wrong data");
	cprintf("file_read is good\n");
  800195:	83 ec 0c             	sub    $0xc,%esp
  800198:	68 97 2c 80 00       	push   $0x802c97
  80019d:	e8 17 07 00 00       	call   8008b9 <cprintf>

	if ((r = devfile.dev_close(FVA)) < 0)
  8001a2:	c7 04 24 00 c0 cc cc 	movl   $0xccccc000,(%esp)
  8001a9:	ff 15 18 40 80 00    	call   *0x804018
  8001af:	83 c4 10             	add    $0x10,%esp
  8001b2:	85 c0                	test   %eax,%eax
  8001b4:	0f 88 96 03 00 00    	js     800550 <umain+0x4d2>
		panic("file_close: %e", r);
	cprintf("file_close is good\n");
  8001ba:	83 ec 0c             	sub    $0xc,%esp
  8001bd:	68 b9 2c 80 00       	push   $0x802cb9
  8001c2:	e8 f2 06 00 00       	call   8008b9 <cprintf>

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
  8001f1:	e8 99 12 00 00       	call   80148f <sys_page_unmap>

	cprintf("%d: before dev_read!!\n", thisenv->env_id);
  8001f6:	a1 08 50 80 00       	mov    0x805008,%eax
  8001fb:	8b 40 48             	mov    0x48(%eax),%eax
  8001fe:	83 c4 08             	add    $0x8,%esp
  800201:	50                   	push   %eax
  800202:	68 cd 2c 80 00       	push   $0x802ccd
  800207:	e8 ad 06 00 00       	call   8008b9 <cprintf>
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
  800236:	68 e4 2c 80 00       	push   $0x802ce4
  80023b:	e8 79 06 00 00       	call   8008b9 <cprintf>

	// Try writing
	if ((r = xopen("/new-file", O_RDWR|O_CREAT)) < 0)
  800240:	ba 02 01 00 00       	mov    $0x102,%edx
  800245:	b8 fa 2c 80 00       	mov    $0x802cfa,%eax
  80024a:	e8 e4 fd ff ff       	call   800033 <xopen>
  80024f:	83 c4 10             	add    $0x10,%esp
  800252:	85 c0                	test   %eax,%eax
  800254:	0f 88 31 03 00 00    	js     80058b <umain+0x50d>
		panic("serve_open /new-file: %e", r);

	if ((r = devfile.dev_write(FVA, msg, strlen(msg))) != strlen(msg))
  80025a:	8b 1d 14 40 80 00    	mov    0x804014,%ebx
  800260:	83 ec 0c             	sub    $0xc,%esp
  800263:	ff 35 00 40 80 00    	pushl  0x804000
  800269:	e8 71 0d 00 00       	call   800fdf <strlen>
  80026e:	83 c4 0c             	add    $0xc,%esp
  800271:	50                   	push   %eax
  800272:	ff 35 00 40 80 00    	pushl  0x804000
  800278:	68 00 c0 cc cc       	push   $0xccccc000
  80027d:	ff d3                	call   *%ebx
  80027f:	89 c3                	mov    %eax,%ebx
  800281:	83 c4 04             	add    $0x4,%esp
  800284:	ff 35 00 40 80 00    	pushl  0x804000
  80028a:	e8 50 0d 00 00       	call   800fdf <strlen>
  80028f:	83 c4 10             	add    $0x10,%esp
  800292:	39 d8                	cmp    %ebx,%eax
  800294:	0f 85 03 03 00 00    	jne    80059d <umain+0x51f>
		panic("file_write: %e", r);
	cprintf("file_write is good\n");
  80029a:	83 ec 0c             	sub    $0xc,%esp
  80029d:	68 2c 2d 80 00       	push   $0x802d2c
  8002a2:	e8 12 06 00 00       	call   8008b9 <cprintf>

	FVA->fd_offset = 0;
  8002a7:	c7 05 04 c0 cc cc 00 	movl   $0x0,0xccccc004
  8002ae:	00 00 00 
	memset(buf, 0, sizeof buf);
  8002b1:	83 c4 0c             	add    $0xc,%esp
  8002b4:	68 00 02 00 00       	push   $0x200
  8002b9:	6a 00                	push   $0x0
  8002bb:	8d 9d 4c fd ff ff    	lea    -0x2b4(%ebp),%ebx
  8002c1:	53                   	push   %ebx
  8002c2:	e8 97 0e 00 00       	call   80115e <memset>
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
  8002f1:	e8 e9 0c 00 00       	call   800fdf <strlen>
  8002f6:	83 c4 10             	add    $0x10,%esp
  8002f9:	39 d8                	cmp    %ebx,%eax
  8002fb:	0f 85 c0 02 00 00    	jne    8005c1 <umain+0x543>
		panic("file_read after file_write returned wrong length: %d", r);
	if (strcmp(buf, msg) != 0)
  800301:	83 ec 08             	sub    $0x8,%esp
  800304:	ff 35 00 40 80 00    	pushl  0x804000
  80030a:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  800310:	50                   	push   %eax
  800311:	e8 ad 0d 00 00       	call   8010c3 <strcmp>
  800316:	83 c4 10             	add    $0x10,%esp
  800319:	85 c0                	test   %eax,%eax
  80031b:	0f 85 b2 02 00 00    	jne    8005d3 <umain+0x555>
		panic("file_read after file_write returned wrong data");
	cprintf("file_read after file_write is good\n");
  800321:	83 ec 0c             	sub    $0xc,%esp
  800324:	68 10 2f 80 00       	push   $0x802f10
  800329:	e8 8b 05 00 00       	call   8008b9 <cprintf>

	// Now we'll try out open
	if ((r = open("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  80032e:	83 c4 08             	add    $0x8,%esp
  800331:	6a 00                	push   $0x0
  800333:	68 e0 2b 80 00       	push   $0x802be0
  800338:	e8 49 1c 00 00       	call   801f86 <open>
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
  80035a:	68 15 2c 80 00       	push   $0x802c15
  80035f:	e8 22 1c 00 00       	call   801f86 <open>
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
  80039d:	68 3c 2c 80 00       	push   $0x802c3c
  8003a2:	e8 12 05 00 00       	call   8008b9 <cprintf>

	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
  8003a7:	83 c4 08             	add    $0x8,%esp
  8003aa:	68 01 01 00 00       	push   $0x101
  8003af:	68 5b 2d 80 00       	push   $0x802d5b
  8003b4:	e8 cd 1b 00 00       	call   801f86 <open>
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
  8003d7:	e8 82 0d 00 00       	call   80115e <memset>
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
  8003f7:	e8 b8 17 00 00       	call   801bb4 <write>
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
  800419:	e8 8c 15 00 00       	call   8019aa <close>

	if ((f = open("/big", O_RDONLY)) < 0)
  80041e:	83 c4 08             	add    $0x8,%esp
  800421:	6a 00                	push   $0x0
  800423:	68 5b 2d 80 00       	push   $0x802d5b
  800428:	e8 59 1b 00 00       	call   801f86 <open>
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
  800450:	e8 1a 17 00 00       	call   801b6f <readn>
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
  80048b:	e8 1a 15 00 00       	call   8019aa <close>
	cprintf("large file is good\n");
  800490:	c7 04 24 a0 2d 80 00 	movl   $0x802da0,(%esp)
  800497:	e8 1d 04 00 00       	call   8008b9 <cprintf>
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
  8004a8:	68 eb 2b 80 00       	push   $0x802beb
  8004ad:	6a 20                	push   $0x20
  8004af:	68 05 2c 80 00       	push   $0x802c05
  8004b4:	e8 0a 03 00 00       	call   8007c3 <_panic>
		panic("serve_open /not-found succeeded!");
  8004b9:	83 ec 04             	sub    $0x4,%esp
  8004bc:	68 b4 2d 80 00       	push   $0x802db4
  8004c1:	6a 22                	push   $0x22
  8004c3:	68 05 2c 80 00       	push   $0x802c05
  8004c8:	e8 f6 02 00 00       	call   8007c3 <_panic>
		panic("serve_open /newmotd: %e", r);
  8004cd:	50                   	push   %eax
  8004ce:	68 1e 2c 80 00       	push   $0x802c1e
  8004d3:	6a 25                	push   $0x25
  8004d5:	68 05 2c 80 00       	push   $0x802c05
  8004da:	e8 e4 02 00 00       	call   8007c3 <_panic>
		panic("serve_open did not fill struct Fd correctly\n");
  8004df:	83 ec 04             	sub    $0x4,%esp
  8004e2:	68 d8 2d 80 00       	push   $0x802dd8
  8004e7:	6a 27                	push   $0x27
  8004e9:	68 05 2c 80 00       	push   $0x802c05
  8004ee:	e8 d0 02 00 00       	call   8007c3 <_panic>
		panic("file_stat: %e", r);
  8004f3:	50                   	push   %eax
  8004f4:	68 4a 2c 80 00       	push   $0x802c4a
  8004f9:	6a 2b                	push   $0x2b
  8004fb:	68 05 2c 80 00       	push   $0x802c05
  800500:	e8 be 02 00 00       	call   8007c3 <_panic>
		panic("file_stat returned size %d wanted %d\n", st.st_size, strlen(msg));
  800505:	83 ec 0c             	sub    $0xc,%esp
  800508:	ff 35 00 40 80 00    	pushl  0x804000
  80050e:	e8 cc 0a 00 00       	call   800fdf <strlen>
  800513:	89 04 24             	mov    %eax,(%esp)
  800516:	ff 75 cc             	pushl  -0x34(%ebp)
  800519:	68 08 2e 80 00       	push   $0x802e08
  80051e:	6a 2d                	push   $0x2d
  800520:	68 05 2c 80 00       	push   $0x802c05
  800525:	e8 99 02 00 00       	call   8007c3 <_panic>
		panic("file_read: %e", r);
  80052a:	50                   	push   %eax
  80052b:	68 6b 2c 80 00       	push   $0x802c6b
  800530:	6a 32                	push   $0x32
  800532:	68 05 2c 80 00       	push   $0x802c05
  800537:	e8 87 02 00 00       	call   8007c3 <_panic>
		panic("file_read returned wrong data");
  80053c:	83 ec 04             	sub    $0x4,%esp
  80053f:	68 79 2c 80 00       	push   $0x802c79
  800544:	6a 34                	push   $0x34
  800546:	68 05 2c 80 00       	push   $0x802c05
  80054b:	e8 73 02 00 00       	call   8007c3 <_panic>
		panic("file_close: %e", r);
  800550:	50                   	push   %eax
  800551:	68 aa 2c 80 00       	push   $0x802caa
  800556:	6a 38                	push   $0x38
  800558:	68 05 2c 80 00       	push   $0x802c05
  80055d:	e8 61 02 00 00       	call   8007c3 <_panic>
		cprintf("%d: after dev_read!! the r: %d\n", thisenv->env_id, r);
  800562:	a1 08 50 80 00       	mov    0x805008,%eax
  800567:	8b 40 48             	mov    0x48(%eax),%eax
  80056a:	83 ec 04             	sub    $0x4,%esp
  80056d:	53                   	push   %ebx
  80056e:	50                   	push   %eax
  80056f:	68 30 2e 80 00       	push   $0x802e30
  800574:	e8 40 03 00 00       	call   8008b9 <cprintf>
		panic("serve_read does not handle stale fileids correctly: %e", r);
  800579:	53                   	push   %ebx
  80057a:	68 50 2e 80 00       	push   $0x802e50
  80057f:	6a 45                	push   $0x45
  800581:	68 05 2c 80 00       	push   $0x802c05
  800586:	e8 38 02 00 00       	call   8007c3 <_panic>
		panic("serve_open /new-file: %e", r);
  80058b:	50                   	push   %eax
  80058c:	68 04 2d 80 00       	push   $0x802d04
  800591:	6a 4b                	push   $0x4b
  800593:	68 05 2c 80 00       	push   $0x802c05
  800598:	e8 26 02 00 00       	call   8007c3 <_panic>
		panic("file_write: %e", r);
  80059d:	53                   	push   %ebx
  80059e:	68 1d 2d 80 00       	push   $0x802d1d
  8005a3:	6a 4e                	push   $0x4e
  8005a5:	68 05 2c 80 00       	push   $0x802c05
  8005aa:	e8 14 02 00 00       	call   8007c3 <_panic>
		panic("file_read after file_write: %e", r);
  8005af:	50                   	push   %eax
  8005b0:	68 88 2e 80 00       	push   $0x802e88
  8005b5:	6a 54                	push   $0x54
  8005b7:	68 05 2c 80 00       	push   $0x802c05
  8005bc:	e8 02 02 00 00       	call   8007c3 <_panic>
		panic("file_read after file_write returned wrong length: %d", r);
  8005c1:	53                   	push   %ebx
  8005c2:	68 a8 2e 80 00       	push   $0x802ea8
  8005c7:	6a 56                	push   $0x56
  8005c9:	68 05 2c 80 00       	push   $0x802c05
  8005ce:	e8 f0 01 00 00       	call   8007c3 <_panic>
		panic("file_read after file_write returned wrong data");
  8005d3:	83 ec 04             	sub    $0x4,%esp
  8005d6:	68 e0 2e 80 00       	push   $0x802ee0
  8005db:	6a 58                	push   $0x58
  8005dd:	68 05 2c 80 00       	push   $0x802c05
  8005e2:	e8 dc 01 00 00       	call   8007c3 <_panic>
		panic("open /not-found: %e", r);
  8005e7:	50                   	push   %eax
  8005e8:	68 f1 2b 80 00       	push   $0x802bf1
  8005ed:	6a 5d                	push   $0x5d
  8005ef:	68 05 2c 80 00       	push   $0x802c05
  8005f4:	e8 ca 01 00 00       	call   8007c3 <_panic>
		panic("open /not-found succeeded!");
  8005f9:	83 ec 04             	sub    $0x4,%esp
  8005fc:	68 40 2d 80 00       	push   $0x802d40
  800601:	6a 5f                	push   $0x5f
  800603:	68 05 2c 80 00       	push   $0x802c05
  800608:	e8 b6 01 00 00       	call   8007c3 <_panic>
		panic("open /newmotd: %e", r);
  80060d:	50                   	push   %eax
  80060e:	68 24 2c 80 00       	push   $0x802c24
  800613:	6a 62                	push   $0x62
  800615:	68 05 2c 80 00       	push   $0x802c05
  80061a:	e8 a4 01 00 00       	call   8007c3 <_panic>
		panic("open did not fill struct Fd correctly\n");
  80061f:	83 ec 04             	sub    $0x4,%esp
  800622:	68 34 2f 80 00       	push   $0x802f34
  800627:	6a 65                	push   $0x65
  800629:	68 05 2c 80 00       	push   $0x802c05
  80062e:	e8 90 01 00 00       	call   8007c3 <_panic>
		panic("creat /big: %e", f);
  800633:	50                   	push   %eax
  800634:	68 60 2d 80 00       	push   $0x802d60
  800639:	6a 6a                	push   $0x6a
  80063b:	68 05 2c 80 00       	push   $0x802c05
  800640:	e8 7e 01 00 00       	call   8007c3 <_panic>
			panic("write /big@%d: %e", i, r);
  800645:	83 ec 0c             	sub    $0xc,%esp
  800648:	50                   	push   %eax
  800649:	56                   	push   %esi
  80064a:	68 6f 2d 80 00       	push   $0x802d6f
  80064f:	6a 6f                	push   $0x6f
  800651:	68 05 2c 80 00       	push   $0x802c05
  800656:	e8 68 01 00 00       	call   8007c3 <_panic>
		panic("open /big: %e", f);
  80065b:	50                   	push   %eax
  80065c:	68 81 2d 80 00       	push   $0x802d81
  800661:	6a 74                	push   $0x74
  800663:	68 05 2c 80 00       	push   $0x802c05
  800668:	e8 56 01 00 00       	call   8007c3 <_panic>
			panic("read /big@%d: %e", i, r);
  80066d:	83 ec 0c             	sub    $0xc,%esp
  800670:	50                   	push   %eax
  800671:	53                   	push   %ebx
  800672:	68 8f 2d 80 00       	push   $0x802d8f
  800677:	6a 78                	push   $0x78
  800679:	68 05 2c 80 00       	push   $0x802c05
  80067e:	e8 40 01 00 00       	call   8007c3 <_panic>
			panic("read /big from %d returned %d < %d bytes",
  800683:	83 ec 08             	sub    $0x8,%esp
  800686:	68 00 02 00 00       	push   $0x200
  80068b:	50                   	push   %eax
  80068c:	53                   	push   %ebx
  80068d:	68 5c 2f 80 00       	push   $0x802f5c
  800692:	6a 7b                	push   $0x7b
  800694:	68 05 2c 80 00       	push   $0x802c05
  800699:	e8 25 01 00 00       	call   8007c3 <_panic>
			panic("read /big from %d returned bad data %d",
  80069e:	83 ec 0c             	sub    $0xc,%esp
  8006a1:	50                   	push   %eax
  8006a2:	53                   	push   %ebx
  8006a3:	68 88 2f 80 00       	push   $0x802f88
  8006a8:	6a 7e                	push   $0x7e
  8006aa:	68 05 2c 80 00       	push   $0x802c05
  8006af:	e8 0f 01 00 00       	call   8007c3 <_panic>

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
  8006c7:	e8 00 0d 00 00       	call   8013cc <sys_getenvid>
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
  8006ec:	74 23                	je     800711 <libmain+0x5d>
		if(envs[i].env_id == find)
  8006ee:	69 ca 84 00 00 00    	imul   $0x84,%edx,%ecx
  8006f4:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  8006fa:	8b 49 48             	mov    0x48(%ecx),%ecx
  8006fd:	39 c1                	cmp    %eax,%ecx
  8006ff:	75 e2                	jne    8006e3 <libmain+0x2f>
  800701:	69 da 84 00 00 00    	imul   $0x84,%edx,%ebx
  800707:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80070d:	89 fe                	mov    %edi,%esi
  80070f:	eb d2                	jmp    8006e3 <libmain+0x2f>
  800711:	89 f0                	mov    %esi,%eax
  800713:	84 c0                	test   %al,%al
  800715:	74 06                	je     80071d <libmain+0x69>
  800717:	89 1d 08 50 80 00    	mov    %ebx,0x805008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80071d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800721:	7e 0a                	jle    80072d <libmain+0x79>
		binaryname = argv[0];
  800723:	8b 45 0c             	mov    0xc(%ebp),%eax
  800726:	8b 00                	mov    (%eax),%eax
  800728:	a3 04 40 80 00       	mov    %eax,0x804004

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  80072d:	a1 08 50 80 00       	mov    0x805008,%eax
  800732:	8b 40 48             	mov    0x48(%eax),%eax
  800735:	83 ec 08             	sub    $0x8,%esp
  800738:	50                   	push   %eax
  800739:	68 d6 2f 80 00       	push   $0x802fd6
  80073e:	e8 76 01 00 00       	call   8008b9 <cprintf>
	cprintf("before umain\n");
  800743:	c7 04 24 f4 2f 80 00 	movl   $0x802ff4,(%esp)
  80074a:	e8 6a 01 00 00       	call   8008b9 <cprintf>
	// call user main routine
	umain(argc, argv);
  80074f:	83 c4 08             	add    $0x8,%esp
  800752:	ff 75 0c             	pushl  0xc(%ebp)
  800755:	ff 75 08             	pushl  0x8(%ebp)
  800758:	e8 21 f9 ff ff       	call   80007e <umain>
	cprintf("after umain\n");
  80075d:	c7 04 24 02 30 80 00 	movl   $0x803002,(%esp)
  800764:	e8 50 01 00 00       	call   8008b9 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800769:	a1 08 50 80 00       	mov    0x805008,%eax
  80076e:	8b 40 48             	mov    0x48(%eax),%eax
  800771:	83 c4 08             	add    $0x8,%esp
  800774:	50                   	push   %eax
  800775:	68 0f 30 80 00       	push   $0x80300f
  80077a:	e8 3a 01 00 00       	call   8008b9 <cprintf>
	// exit gracefully
	exit();
  80077f:	e8 0b 00 00 00       	call   80078f <exit>
}
  800784:	83 c4 10             	add    $0x10,%esp
  800787:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80078a:	5b                   	pop    %ebx
  80078b:	5e                   	pop    %esi
  80078c:	5f                   	pop    %edi
  80078d:	5d                   	pop    %ebp
  80078e:	c3                   	ret    

0080078f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80078f:	55                   	push   %ebp
  800790:	89 e5                	mov    %esp,%ebp
  800792:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800795:	a1 08 50 80 00       	mov    0x805008,%eax
  80079a:	8b 40 48             	mov    0x48(%eax),%eax
  80079d:	68 3c 30 80 00       	push   $0x80303c
  8007a2:	50                   	push   %eax
  8007a3:	68 2e 30 80 00       	push   $0x80302e
  8007a8:	e8 0c 01 00 00       	call   8008b9 <cprintf>
	close_all();
  8007ad:	e8 25 12 00 00       	call   8019d7 <close_all>
	sys_env_destroy(0);
  8007b2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8007b9:	e8 cd 0b 00 00       	call   80138b <sys_env_destroy>
}
  8007be:	83 c4 10             	add    $0x10,%esp
  8007c1:	c9                   	leave  
  8007c2:	c3                   	ret    

008007c3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8007c3:	55                   	push   %ebp
  8007c4:	89 e5                	mov    %esp,%ebp
  8007c6:	56                   	push   %esi
  8007c7:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8007c8:	a1 08 50 80 00       	mov    0x805008,%eax
  8007cd:	8b 40 48             	mov    0x48(%eax),%eax
  8007d0:	83 ec 04             	sub    $0x4,%esp
  8007d3:	68 68 30 80 00       	push   $0x803068
  8007d8:	50                   	push   %eax
  8007d9:	68 2e 30 80 00       	push   $0x80302e
  8007de:	e8 d6 00 00 00       	call   8008b9 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8007e3:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8007e6:	8b 35 04 40 80 00    	mov    0x804004,%esi
  8007ec:	e8 db 0b 00 00       	call   8013cc <sys_getenvid>
  8007f1:	83 c4 04             	add    $0x4,%esp
  8007f4:	ff 75 0c             	pushl  0xc(%ebp)
  8007f7:	ff 75 08             	pushl  0x8(%ebp)
  8007fa:	56                   	push   %esi
  8007fb:	50                   	push   %eax
  8007fc:	68 44 30 80 00       	push   $0x803044
  800801:	e8 b3 00 00 00       	call   8008b9 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800806:	83 c4 18             	add    $0x18,%esp
  800809:	53                   	push   %ebx
  80080a:	ff 75 10             	pushl  0x10(%ebp)
  80080d:	e8 56 00 00 00       	call   800868 <vcprintf>
	cprintf("\n");
  800812:	c7 04 24 e2 2c 80 00 	movl   $0x802ce2,(%esp)
  800819:	e8 9b 00 00 00       	call   8008b9 <cprintf>
  80081e:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800821:	cc                   	int3   
  800822:	eb fd                	jmp    800821 <_panic+0x5e>

00800824 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800824:	55                   	push   %ebp
  800825:	89 e5                	mov    %esp,%ebp
  800827:	53                   	push   %ebx
  800828:	83 ec 04             	sub    $0x4,%esp
  80082b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80082e:	8b 13                	mov    (%ebx),%edx
  800830:	8d 42 01             	lea    0x1(%edx),%eax
  800833:	89 03                	mov    %eax,(%ebx)
  800835:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800838:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80083c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800841:	74 09                	je     80084c <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800843:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800847:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80084a:	c9                   	leave  
  80084b:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80084c:	83 ec 08             	sub    $0x8,%esp
  80084f:	68 ff 00 00 00       	push   $0xff
  800854:	8d 43 08             	lea    0x8(%ebx),%eax
  800857:	50                   	push   %eax
  800858:	e8 f1 0a 00 00       	call   80134e <sys_cputs>
		b->idx = 0;
  80085d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800863:	83 c4 10             	add    $0x10,%esp
  800866:	eb db                	jmp    800843 <putch+0x1f>

00800868 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800868:	55                   	push   %ebp
  800869:	89 e5                	mov    %esp,%ebp
  80086b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800871:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800878:	00 00 00 
	b.cnt = 0;
  80087b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800882:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800885:	ff 75 0c             	pushl  0xc(%ebp)
  800888:	ff 75 08             	pushl  0x8(%ebp)
  80088b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800891:	50                   	push   %eax
  800892:	68 24 08 80 00       	push   $0x800824
  800897:	e8 4a 01 00 00       	call   8009e6 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80089c:	83 c4 08             	add    $0x8,%esp
  80089f:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8008a5:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8008ab:	50                   	push   %eax
  8008ac:	e8 9d 0a 00 00       	call   80134e <sys_cputs>

	return b.cnt;
}
  8008b1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8008b7:	c9                   	leave  
  8008b8:	c3                   	ret    

008008b9 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8008b9:	55                   	push   %ebp
  8008ba:	89 e5                	mov    %esp,%ebp
  8008bc:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8008bf:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8008c2:	50                   	push   %eax
  8008c3:	ff 75 08             	pushl  0x8(%ebp)
  8008c6:	e8 9d ff ff ff       	call   800868 <vcprintf>
	va_end(ap);

	return cnt;
}
  8008cb:	c9                   	leave  
  8008cc:	c3                   	ret    

008008cd <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8008cd:	55                   	push   %ebp
  8008ce:	89 e5                	mov    %esp,%ebp
  8008d0:	57                   	push   %edi
  8008d1:	56                   	push   %esi
  8008d2:	53                   	push   %ebx
  8008d3:	83 ec 1c             	sub    $0x1c,%esp
  8008d6:	89 c6                	mov    %eax,%esi
  8008d8:	89 d7                	mov    %edx,%edi
  8008da:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8008e3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8008e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8008e9:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8008ec:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8008f0:	74 2c                	je     80091e <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8008f2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008f5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8008fc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008ff:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800902:	39 c2                	cmp    %eax,%edx
  800904:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800907:	73 43                	jae    80094c <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800909:	83 eb 01             	sub    $0x1,%ebx
  80090c:	85 db                	test   %ebx,%ebx
  80090e:	7e 6c                	jle    80097c <printnum+0xaf>
				putch(padc, putdat);
  800910:	83 ec 08             	sub    $0x8,%esp
  800913:	57                   	push   %edi
  800914:	ff 75 18             	pushl  0x18(%ebp)
  800917:	ff d6                	call   *%esi
  800919:	83 c4 10             	add    $0x10,%esp
  80091c:	eb eb                	jmp    800909 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80091e:	83 ec 0c             	sub    $0xc,%esp
  800921:	6a 20                	push   $0x20
  800923:	6a 00                	push   $0x0
  800925:	50                   	push   %eax
  800926:	ff 75 e4             	pushl  -0x1c(%ebp)
  800929:	ff 75 e0             	pushl  -0x20(%ebp)
  80092c:	89 fa                	mov    %edi,%edx
  80092e:	89 f0                	mov    %esi,%eax
  800930:	e8 98 ff ff ff       	call   8008cd <printnum>
		while (--width > 0)
  800935:	83 c4 20             	add    $0x20,%esp
  800938:	83 eb 01             	sub    $0x1,%ebx
  80093b:	85 db                	test   %ebx,%ebx
  80093d:	7e 65                	jle    8009a4 <printnum+0xd7>
			putch(padc, putdat);
  80093f:	83 ec 08             	sub    $0x8,%esp
  800942:	57                   	push   %edi
  800943:	6a 20                	push   $0x20
  800945:	ff d6                	call   *%esi
  800947:	83 c4 10             	add    $0x10,%esp
  80094a:	eb ec                	jmp    800938 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80094c:	83 ec 0c             	sub    $0xc,%esp
  80094f:	ff 75 18             	pushl  0x18(%ebp)
  800952:	83 eb 01             	sub    $0x1,%ebx
  800955:	53                   	push   %ebx
  800956:	50                   	push   %eax
  800957:	83 ec 08             	sub    $0x8,%esp
  80095a:	ff 75 dc             	pushl  -0x24(%ebp)
  80095d:	ff 75 d8             	pushl  -0x28(%ebp)
  800960:	ff 75 e4             	pushl  -0x1c(%ebp)
  800963:	ff 75 e0             	pushl  -0x20(%ebp)
  800966:	e8 25 20 00 00       	call   802990 <__udivdi3>
  80096b:	83 c4 18             	add    $0x18,%esp
  80096e:	52                   	push   %edx
  80096f:	50                   	push   %eax
  800970:	89 fa                	mov    %edi,%edx
  800972:	89 f0                	mov    %esi,%eax
  800974:	e8 54 ff ff ff       	call   8008cd <printnum>
  800979:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80097c:	83 ec 08             	sub    $0x8,%esp
  80097f:	57                   	push   %edi
  800980:	83 ec 04             	sub    $0x4,%esp
  800983:	ff 75 dc             	pushl  -0x24(%ebp)
  800986:	ff 75 d8             	pushl  -0x28(%ebp)
  800989:	ff 75 e4             	pushl  -0x1c(%ebp)
  80098c:	ff 75 e0             	pushl  -0x20(%ebp)
  80098f:	e8 0c 21 00 00       	call   802aa0 <__umoddi3>
  800994:	83 c4 14             	add    $0x14,%esp
  800997:	0f be 80 6f 30 80 00 	movsbl 0x80306f(%eax),%eax
  80099e:	50                   	push   %eax
  80099f:	ff d6                	call   *%esi
  8009a1:	83 c4 10             	add    $0x10,%esp
	}
}
  8009a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009a7:	5b                   	pop    %ebx
  8009a8:	5e                   	pop    %esi
  8009a9:	5f                   	pop    %edi
  8009aa:	5d                   	pop    %ebp
  8009ab:	c3                   	ret    

008009ac <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8009ac:	55                   	push   %ebp
  8009ad:	89 e5                	mov    %esp,%ebp
  8009af:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8009b2:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8009b6:	8b 10                	mov    (%eax),%edx
  8009b8:	3b 50 04             	cmp    0x4(%eax),%edx
  8009bb:	73 0a                	jae    8009c7 <sprintputch+0x1b>
		*b->buf++ = ch;
  8009bd:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009c0:	89 08                	mov    %ecx,(%eax)
  8009c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c5:	88 02                	mov    %al,(%edx)
}
  8009c7:	5d                   	pop    %ebp
  8009c8:	c3                   	ret    

008009c9 <printfmt>:
{
  8009c9:	55                   	push   %ebp
  8009ca:	89 e5                	mov    %esp,%ebp
  8009cc:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8009cf:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8009d2:	50                   	push   %eax
  8009d3:	ff 75 10             	pushl  0x10(%ebp)
  8009d6:	ff 75 0c             	pushl  0xc(%ebp)
  8009d9:	ff 75 08             	pushl  0x8(%ebp)
  8009dc:	e8 05 00 00 00       	call   8009e6 <vprintfmt>
}
  8009e1:	83 c4 10             	add    $0x10,%esp
  8009e4:	c9                   	leave  
  8009e5:	c3                   	ret    

008009e6 <vprintfmt>:
{
  8009e6:	55                   	push   %ebp
  8009e7:	89 e5                	mov    %esp,%ebp
  8009e9:	57                   	push   %edi
  8009ea:	56                   	push   %esi
  8009eb:	53                   	push   %ebx
  8009ec:	83 ec 3c             	sub    $0x3c,%esp
  8009ef:	8b 75 08             	mov    0x8(%ebp),%esi
  8009f2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8009f5:	8b 7d 10             	mov    0x10(%ebp),%edi
  8009f8:	e9 32 04 00 00       	jmp    800e2f <vprintfmt+0x449>
		padc = ' ';
  8009fd:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800a01:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800a08:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800a0f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800a16:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a1d:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800a24:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800a29:	8d 47 01             	lea    0x1(%edi),%eax
  800a2c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a2f:	0f b6 17             	movzbl (%edi),%edx
  800a32:	8d 42 dd             	lea    -0x23(%edx),%eax
  800a35:	3c 55                	cmp    $0x55,%al
  800a37:	0f 87 12 05 00 00    	ja     800f4f <vprintfmt+0x569>
  800a3d:	0f b6 c0             	movzbl %al,%eax
  800a40:	ff 24 85 40 32 80 00 	jmp    *0x803240(,%eax,4)
  800a47:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800a4a:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800a4e:	eb d9                	jmp    800a29 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800a50:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800a53:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800a57:	eb d0                	jmp    800a29 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800a59:	0f b6 d2             	movzbl %dl,%edx
  800a5c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800a5f:	b8 00 00 00 00       	mov    $0x0,%eax
  800a64:	89 75 08             	mov    %esi,0x8(%ebp)
  800a67:	eb 03                	jmp    800a6c <vprintfmt+0x86>
  800a69:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800a6c:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800a6f:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800a73:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800a76:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a79:	83 fe 09             	cmp    $0x9,%esi
  800a7c:	76 eb                	jbe    800a69 <vprintfmt+0x83>
  800a7e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a81:	8b 75 08             	mov    0x8(%ebp),%esi
  800a84:	eb 14                	jmp    800a9a <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800a86:	8b 45 14             	mov    0x14(%ebp),%eax
  800a89:	8b 00                	mov    (%eax),%eax
  800a8b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a8e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a91:	8d 40 04             	lea    0x4(%eax),%eax
  800a94:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800a97:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800a9a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a9e:	79 89                	jns    800a29 <vprintfmt+0x43>
				width = precision, precision = -1;
  800aa0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800aa3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800aa6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800aad:	e9 77 ff ff ff       	jmp    800a29 <vprintfmt+0x43>
  800ab2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ab5:	85 c0                	test   %eax,%eax
  800ab7:	0f 48 c1             	cmovs  %ecx,%eax
  800aba:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800abd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800ac0:	e9 64 ff ff ff       	jmp    800a29 <vprintfmt+0x43>
  800ac5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800ac8:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800acf:	e9 55 ff ff ff       	jmp    800a29 <vprintfmt+0x43>
			lflag++;
  800ad4:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800ad8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800adb:	e9 49 ff ff ff       	jmp    800a29 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800ae0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae3:	8d 78 04             	lea    0x4(%eax),%edi
  800ae6:	83 ec 08             	sub    $0x8,%esp
  800ae9:	53                   	push   %ebx
  800aea:	ff 30                	pushl  (%eax)
  800aec:	ff d6                	call   *%esi
			break;
  800aee:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800af1:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800af4:	e9 33 03 00 00       	jmp    800e2c <vprintfmt+0x446>
			err = va_arg(ap, int);
  800af9:	8b 45 14             	mov    0x14(%ebp),%eax
  800afc:	8d 78 04             	lea    0x4(%eax),%edi
  800aff:	8b 00                	mov    (%eax),%eax
  800b01:	99                   	cltd   
  800b02:	31 d0                	xor    %edx,%eax
  800b04:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800b06:	83 f8 11             	cmp    $0x11,%eax
  800b09:	7f 23                	jg     800b2e <vprintfmt+0x148>
  800b0b:	8b 14 85 a0 33 80 00 	mov    0x8033a0(,%eax,4),%edx
  800b12:	85 d2                	test   %edx,%edx
  800b14:	74 18                	je     800b2e <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800b16:	52                   	push   %edx
  800b17:	68 e1 34 80 00       	push   $0x8034e1
  800b1c:	53                   	push   %ebx
  800b1d:	56                   	push   %esi
  800b1e:	e8 a6 fe ff ff       	call   8009c9 <printfmt>
  800b23:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800b26:	89 7d 14             	mov    %edi,0x14(%ebp)
  800b29:	e9 fe 02 00 00       	jmp    800e2c <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800b2e:	50                   	push   %eax
  800b2f:	68 87 30 80 00       	push   $0x803087
  800b34:	53                   	push   %ebx
  800b35:	56                   	push   %esi
  800b36:	e8 8e fe ff ff       	call   8009c9 <printfmt>
  800b3b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800b3e:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800b41:	e9 e6 02 00 00       	jmp    800e2c <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800b46:	8b 45 14             	mov    0x14(%ebp),%eax
  800b49:	83 c0 04             	add    $0x4,%eax
  800b4c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800b4f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b52:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800b54:	85 c9                	test   %ecx,%ecx
  800b56:	b8 80 30 80 00       	mov    $0x803080,%eax
  800b5b:	0f 45 c1             	cmovne %ecx,%eax
  800b5e:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800b61:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b65:	7e 06                	jle    800b6d <vprintfmt+0x187>
  800b67:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800b6b:	75 0d                	jne    800b7a <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b6d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800b70:	89 c7                	mov    %eax,%edi
  800b72:	03 45 e0             	add    -0x20(%ebp),%eax
  800b75:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800b78:	eb 53                	jmp    800bcd <vprintfmt+0x1e7>
  800b7a:	83 ec 08             	sub    $0x8,%esp
  800b7d:	ff 75 d8             	pushl  -0x28(%ebp)
  800b80:	50                   	push   %eax
  800b81:	e8 71 04 00 00       	call   800ff7 <strnlen>
  800b86:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800b89:	29 c1                	sub    %eax,%ecx
  800b8b:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800b8e:	83 c4 10             	add    $0x10,%esp
  800b91:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800b93:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800b97:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800b9a:	eb 0f                	jmp    800bab <vprintfmt+0x1c5>
					putch(padc, putdat);
  800b9c:	83 ec 08             	sub    $0x8,%esp
  800b9f:	53                   	push   %ebx
  800ba0:	ff 75 e0             	pushl  -0x20(%ebp)
  800ba3:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800ba5:	83 ef 01             	sub    $0x1,%edi
  800ba8:	83 c4 10             	add    $0x10,%esp
  800bab:	85 ff                	test   %edi,%edi
  800bad:	7f ed                	jg     800b9c <vprintfmt+0x1b6>
  800baf:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800bb2:	85 c9                	test   %ecx,%ecx
  800bb4:	b8 00 00 00 00       	mov    $0x0,%eax
  800bb9:	0f 49 c1             	cmovns %ecx,%eax
  800bbc:	29 c1                	sub    %eax,%ecx
  800bbe:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800bc1:	eb aa                	jmp    800b6d <vprintfmt+0x187>
					putch(ch, putdat);
  800bc3:	83 ec 08             	sub    $0x8,%esp
  800bc6:	53                   	push   %ebx
  800bc7:	52                   	push   %edx
  800bc8:	ff d6                	call   *%esi
  800bca:	83 c4 10             	add    $0x10,%esp
  800bcd:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800bd0:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bd2:	83 c7 01             	add    $0x1,%edi
  800bd5:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800bd9:	0f be d0             	movsbl %al,%edx
  800bdc:	85 d2                	test   %edx,%edx
  800bde:	74 4b                	je     800c2b <vprintfmt+0x245>
  800be0:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800be4:	78 06                	js     800bec <vprintfmt+0x206>
  800be6:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800bea:	78 1e                	js     800c0a <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800bec:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800bf0:	74 d1                	je     800bc3 <vprintfmt+0x1dd>
  800bf2:	0f be c0             	movsbl %al,%eax
  800bf5:	83 e8 20             	sub    $0x20,%eax
  800bf8:	83 f8 5e             	cmp    $0x5e,%eax
  800bfb:	76 c6                	jbe    800bc3 <vprintfmt+0x1dd>
					putch('?', putdat);
  800bfd:	83 ec 08             	sub    $0x8,%esp
  800c00:	53                   	push   %ebx
  800c01:	6a 3f                	push   $0x3f
  800c03:	ff d6                	call   *%esi
  800c05:	83 c4 10             	add    $0x10,%esp
  800c08:	eb c3                	jmp    800bcd <vprintfmt+0x1e7>
  800c0a:	89 cf                	mov    %ecx,%edi
  800c0c:	eb 0e                	jmp    800c1c <vprintfmt+0x236>
				putch(' ', putdat);
  800c0e:	83 ec 08             	sub    $0x8,%esp
  800c11:	53                   	push   %ebx
  800c12:	6a 20                	push   $0x20
  800c14:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800c16:	83 ef 01             	sub    $0x1,%edi
  800c19:	83 c4 10             	add    $0x10,%esp
  800c1c:	85 ff                	test   %edi,%edi
  800c1e:	7f ee                	jg     800c0e <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800c20:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800c23:	89 45 14             	mov    %eax,0x14(%ebp)
  800c26:	e9 01 02 00 00       	jmp    800e2c <vprintfmt+0x446>
  800c2b:	89 cf                	mov    %ecx,%edi
  800c2d:	eb ed                	jmp    800c1c <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800c2f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800c32:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800c39:	e9 eb fd ff ff       	jmp    800a29 <vprintfmt+0x43>
	if (lflag >= 2)
  800c3e:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800c42:	7f 21                	jg     800c65 <vprintfmt+0x27f>
	else if (lflag)
  800c44:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800c48:	74 68                	je     800cb2 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800c4a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c4d:	8b 00                	mov    (%eax),%eax
  800c4f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800c52:	89 c1                	mov    %eax,%ecx
  800c54:	c1 f9 1f             	sar    $0x1f,%ecx
  800c57:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800c5a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c5d:	8d 40 04             	lea    0x4(%eax),%eax
  800c60:	89 45 14             	mov    %eax,0x14(%ebp)
  800c63:	eb 17                	jmp    800c7c <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800c65:	8b 45 14             	mov    0x14(%ebp),%eax
  800c68:	8b 50 04             	mov    0x4(%eax),%edx
  800c6b:	8b 00                	mov    (%eax),%eax
  800c6d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800c70:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800c73:	8b 45 14             	mov    0x14(%ebp),%eax
  800c76:	8d 40 08             	lea    0x8(%eax),%eax
  800c79:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800c7c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800c7f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800c82:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c85:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800c88:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800c8c:	78 3f                	js     800ccd <vprintfmt+0x2e7>
			base = 10;
  800c8e:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800c93:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800c97:	0f 84 71 01 00 00    	je     800e0e <vprintfmt+0x428>
				putch('+', putdat);
  800c9d:	83 ec 08             	sub    $0x8,%esp
  800ca0:	53                   	push   %ebx
  800ca1:	6a 2b                	push   $0x2b
  800ca3:	ff d6                	call   *%esi
  800ca5:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800ca8:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cad:	e9 5c 01 00 00       	jmp    800e0e <vprintfmt+0x428>
		return va_arg(*ap, int);
  800cb2:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb5:	8b 00                	mov    (%eax),%eax
  800cb7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800cba:	89 c1                	mov    %eax,%ecx
  800cbc:	c1 f9 1f             	sar    $0x1f,%ecx
  800cbf:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800cc2:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc5:	8d 40 04             	lea    0x4(%eax),%eax
  800cc8:	89 45 14             	mov    %eax,0x14(%ebp)
  800ccb:	eb af                	jmp    800c7c <vprintfmt+0x296>
				putch('-', putdat);
  800ccd:	83 ec 08             	sub    $0x8,%esp
  800cd0:	53                   	push   %ebx
  800cd1:	6a 2d                	push   $0x2d
  800cd3:	ff d6                	call   *%esi
				num = -(long long) num;
  800cd5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800cd8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800cdb:	f7 d8                	neg    %eax
  800cdd:	83 d2 00             	adc    $0x0,%edx
  800ce0:	f7 da                	neg    %edx
  800ce2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ce5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ce8:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800ceb:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cf0:	e9 19 01 00 00       	jmp    800e0e <vprintfmt+0x428>
	if (lflag >= 2)
  800cf5:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800cf9:	7f 29                	jg     800d24 <vprintfmt+0x33e>
	else if (lflag)
  800cfb:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800cff:	74 44                	je     800d45 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800d01:	8b 45 14             	mov    0x14(%ebp),%eax
  800d04:	8b 00                	mov    (%eax),%eax
  800d06:	ba 00 00 00 00       	mov    $0x0,%edx
  800d0b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d0e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800d11:	8b 45 14             	mov    0x14(%ebp),%eax
  800d14:	8d 40 04             	lea    0x4(%eax),%eax
  800d17:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800d1a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d1f:	e9 ea 00 00 00       	jmp    800e0e <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800d24:	8b 45 14             	mov    0x14(%ebp),%eax
  800d27:	8b 50 04             	mov    0x4(%eax),%edx
  800d2a:	8b 00                	mov    (%eax),%eax
  800d2c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d2f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800d32:	8b 45 14             	mov    0x14(%ebp),%eax
  800d35:	8d 40 08             	lea    0x8(%eax),%eax
  800d38:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800d3b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d40:	e9 c9 00 00 00       	jmp    800e0e <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800d45:	8b 45 14             	mov    0x14(%ebp),%eax
  800d48:	8b 00                	mov    (%eax),%eax
  800d4a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d4f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d52:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800d55:	8b 45 14             	mov    0x14(%ebp),%eax
  800d58:	8d 40 04             	lea    0x4(%eax),%eax
  800d5b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800d5e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d63:	e9 a6 00 00 00       	jmp    800e0e <vprintfmt+0x428>
			putch('0', putdat);
  800d68:	83 ec 08             	sub    $0x8,%esp
  800d6b:	53                   	push   %ebx
  800d6c:	6a 30                	push   $0x30
  800d6e:	ff d6                	call   *%esi
	if (lflag >= 2)
  800d70:	83 c4 10             	add    $0x10,%esp
  800d73:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800d77:	7f 26                	jg     800d9f <vprintfmt+0x3b9>
	else if (lflag)
  800d79:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800d7d:	74 3e                	je     800dbd <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800d7f:	8b 45 14             	mov    0x14(%ebp),%eax
  800d82:	8b 00                	mov    (%eax),%eax
  800d84:	ba 00 00 00 00       	mov    $0x0,%edx
  800d89:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d8c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800d8f:	8b 45 14             	mov    0x14(%ebp),%eax
  800d92:	8d 40 04             	lea    0x4(%eax),%eax
  800d95:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800d98:	b8 08 00 00 00       	mov    $0x8,%eax
  800d9d:	eb 6f                	jmp    800e0e <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800d9f:	8b 45 14             	mov    0x14(%ebp),%eax
  800da2:	8b 50 04             	mov    0x4(%eax),%edx
  800da5:	8b 00                	mov    (%eax),%eax
  800da7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800daa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800dad:	8b 45 14             	mov    0x14(%ebp),%eax
  800db0:	8d 40 08             	lea    0x8(%eax),%eax
  800db3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800db6:	b8 08 00 00 00       	mov    $0x8,%eax
  800dbb:	eb 51                	jmp    800e0e <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800dbd:	8b 45 14             	mov    0x14(%ebp),%eax
  800dc0:	8b 00                	mov    (%eax),%eax
  800dc2:	ba 00 00 00 00       	mov    $0x0,%edx
  800dc7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800dca:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800dcd:	8b 45 14             	mov    0x14(%ebp),%eax
  800dd0:	8d 40 04             	lea    0x4(%eax),%eax
  800dd3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800dd6:	b8 08 00 00 00       	mov    $0x8,%eax
  800ddb:	eb 31                	jmp    800e0e <vprintfmt+0x428>
			putch('0', putdat);
  800ddd:	83 ec 08             	sub    $0x8,%esp
  800de0:	53                   	push   %ebx
  800de1:	6a 30                	push   $0x30
  800de3:	ff d6                	call   *%esi
			putch('x', putdat);
  800de5:	83 c4 08             	add    $0x8,%esp
  800de8:	53                   	push   %ebx
  800de9:	6a 78                	push   $0x78
  800deb:	ff d6                	call   *%esi
			num = (unsigned long long)
  800ded:	8b 45 14             	mov    0x14(%ebp),%eax
  800df0:	8b 00                	mov    (%eax),%eax
  800df2:	ba 00 00 00 00       	mov    $0x0,%edx
  800df7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800dfa:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800dfd:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800e00:	8b 45 14             	mov    0x14(%ebp),%eax
  800e03:	8d 40 04             	lea    0x4(%eax),%eax
  800e06:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800e09:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800e0e:	83 ec 0c             	sub    $0xc,%esp
  800e11:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800e15:	52                   	push   %edx
  800e16:	ff 75 e0             	pushl  -0x20(%ebp)
  800e19:	50                   	push   %eax
  800e1a:	ff 75 dc             	pushl  -0x24(%ebp)
  800e1d:	ff 75 d8             	pushl  -0x28(%ebp)
  800e20:	89 da                	mov    %ebx,%edx
  800e22:	89 f0                	mov    %esi,%eax
  800e24:	e8 a4 fa ff ff       	call   8008cd <printnum>
			break;
  800e29:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800e2c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e2f:	83 c7 01             	add    $0x1,%edi
  800e32:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800e36:	83 f8 25             	cmp    $0x25,%eax
  800e39:	0f 84 be fb ff ff    	je     8009fd <vprintfmt+0x17>
			if (ch == '\0')
  800e3f:	85 c0                	test   %eax,%eax
  800e41:	0f 84 28 01 00 00    	je     800f6f <vprintfmt+0x589>
			putch(ch, putdat);
  800e47:	83 ec 08             	sub    $0x8,%esp
  800e4a:	53                   	push   %ebx
  800e4b:	50                   	push   %eax
  800e4c:	ff d6                	call   *%esi
  800e4e:	83 c4 10             	add    $0x10,%esp
  800e51:	eb dc                	jmp    800e2f <vprintfmt+0x449>
	if (lflag >= 2)
  800e53:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800e57:	7f 26                	jg     800e7f <vprintfmt+0x499>
	else if (lflag)
  800e59:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800e5d:	74 41                	je     800ea0 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800e5f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e62:	8b 00                	mov    (%eax),%eax
  800e64:	ba 00 00 00 00       	mov    $0x0,%edx
  800e69:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800e6c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800e6f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e72:	8d 40 04             	lea    0x4(%eax),%eax
  800e75:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800e78:	b8 10 00 00 00       	mov    $0x10,%eax
  800e7d:	eb 8f                	jmp    800e0e <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800e7f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e82:	8b 50 04             	mov    0x4(%eax),%edx
  800e85:	8b 00                	mov    (%eax),%eax
  800e87:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800e8a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800e8d:	8b 45 14             	mov    0x14(%ebp),%eax
  800e90:	8d 40 08             	lea    0x8(%eax),%eax
  800e93:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800e96:	b8 10 00 00 00       	mov    $0x10,%eax
  800e9b:	e9 6e ff ff ff       	jmp    800e0e <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800ea0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ea3:	8b 00                	mov    (%eax),%eax
  800ea5:	ba 00 00 00 00       	mov    $0x0,%edx
  800eaa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ead:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800eb0:	8b 45 14             	mov    0x14(%ebp),%eax
  800eb3:	8d 40 04             	lea    0x4(%eax),%eax
  800eb6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800eb9:	b8 10 00 00 00       	mov    $0x10,%eax
  800ebe:	e9 4b ff ff ff       	jmp    800e0e <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800ec3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec6:	83 c0 04             	add    $0x4,%eax
  800ec9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ecc:	8b 45 14             	mov    0x14(%ebp),%eax
  800ecf:	8b 00                	mov    (%eax),%eax
  800ed1:	85 c0                	test   %eax,%eax
  800ed3:	74 14                	je     800ee9 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800ed5:	8b 13                	mov    (%ebx),%edx
  800ed7:	83 fa 7f             	cmp    $0x7f,%edx
  800eda:	7f 37                	jg     800f13 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800edc:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800ede:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800ee1:	89 45 14             	mov    %eax,0x14(%ebp)
  800ee4:	e9 43 ff ff ff       	jmp    800e2c <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800ee9:	b8 0a 00 00 00       	mov    $0xa,%eax
  800eee:	bf a5 31 80 00       	mov    $0x8031a5,%edi
							putch(ch, putdat);
  800ef3:	83 ec 08             	sub    $0x8,%esp
  800ef6:	53                   	push   %ebx
  800ef7:	50                   	push   %eax
  800ef8:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800efa:	83 c7 01             	add    $0x1,%edi
  800efd:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800f01:	83 c4 10             	add    $0x10,%esp
  800f04:	85 c0                	test   %eax,%eax
  800f06:	75 eb                	jne    800ef3 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800f08:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800f0b:	89 45 14             	mov    %eax,0x14(%ebp)
  800f0e:	e9 19 ff ff ff       	jmp    800e2c <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800f13:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800f15:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f1a:	bf dd 31 80 00       	mov    $0x8031dd,%edi
							putch(ch, putdat);
  800f1f:	83 ec 08             	sub    $0x8,%esp
  800f22:	53                   	push   %ebx
  800f23:	50                   	push   %eax
  800f24:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800f26:	83 c7 01             	add    $0x1,%edi
  800f29:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800f2d:	83 c4 10             	add    $0x10,%esp
  800f30:	85 c0                	test   %eax,%eax
  800f32:	75 eb                	jne    800f1f <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800f34:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800f37:	89 45 14             	mov    %eax,0x14(%ebp)
  800f3a:	e9 ed fe ff ff       	jmp    800e2c <vprintfmt+0x446>
			putch(ch, putdat);
  800f3f:	83 ec 08             	sub    $0x8,%esp
  800f42:	53                   	push   %ebx
  800f43:	6a 25                	push   $0x25
  800f45:	ff d6                	call   *%esi
			break;
  800f47:	83 c4 10             	add    $0x10,%esp
  800f4a:	e9 dd fe ff ff       	jmp    800e2c <vprintfmt+0x446>
			putch('%', putdat);
  800f4f:	83 ec 08             	sub    $0x8,%esp
  800f52:	53                   	push   %ebx
  800f53:	6a 25                	push   $0x25
  800f55:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f57:	83 c4 10             	add    $0x10,%esp
  800f5a:	89 f8                	mov    %edi,%eax
  800f5c:	eb 03                	jmp    800f61 <vprintfmt+0x57b>
  800f5e:	83 e8 01             	sub    $0x1,%eax
  800f61:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800f65:	75 f7                	jne    800f5e <vprintfmt+0x578>
  800f67:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800f6a:	e9 bd fe ff ff       	jmp    800e2c <vprintfmt+0x446>
}
  800f6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f72:	5b                   	pop    %ebx
  800f73:	5e                   	pop    %esi
  800f74:	5f                   	pop    %edi
  800f75:	5d                   	pop    %ebp
  800f76:	c3                   	ret    

00800f77 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f77:	55                   	push   %ebp
  800f78:	89 e5                	mov    %esp,%ebp
  800f7a:	83 ec 18             	sub    $0x18,%esp
  800f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f80:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f83:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800f86:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800f8a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800f8d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800f94:	85 c0                	test   %eax,%eax
  800f96:	74 26                	je     800fbe <vsnprintf+0x47>
  800f98:	85 d2                	test   %edx,%edx
  800f9a:	7e 22                	jle    800fbe <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800f9c:	ff 75 14             	pushl  0x14(%ebp)
  800f9f:	ff 75 10             	pushl  0x10(%ebp)
  800fa2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800fa5:	50                   	push   %eax
  800fa6:	68 ac 09 80 00       	push   $0x8009ac
  800fab:	e8 36 fa ff ff       	call   8009e6 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800fb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fb3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800fb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fb9:	83 c4 10             	add    $0x10,%esp
}
  800fbc:	c9                   	leave  
  800fbd:	c3                   	ret    
		return -E_INVAL;
  800fbe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fc3:	eb f7                	jmp    800fbc <vsnprintf+0x45>

00800fc5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fc5:	55                   	push   %ebp
  800fc6:	89 e5                	mov    %esp,%ebp
  800fc8:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800fcb:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800fce:	50                   	push   %eax
  800fcf:	ff 75 10             	pushl  0x10(%ebp)
  800fd2:	ff 75 0c             	pushl  0xc(%ebp)
  800fd5:	ff 75 08             	pushl  0x8(%ebp)
  800fd8:	e8 9a ff ff ff       	call   800f77 <vsnprintf>
	va_end(ap);

	return rc;
}
  800fdd:	c9                   	leave  
  800fde:	c3                   	ret    

00800fdf <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800fdf:	55                   	push   %ebp
  800fe0:	89 e5                	mov    %esp,%ebp
  800fe2:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800fe5:	b8 00 00 00 00       	mov    $0x0,%eax
  800fea:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800fee:	74 05                	je     800ff5 <strlen+0x16>
		n++;
  800ff0:	83 c0 01             	add    $0x1,%eax
  800ff3:	eb f5                	jmp    800fea <strlen+0xb>
	return n;
}
  800ff5:	5d                   	pop    %ebp
  800ff6:	c3                   	ret    

00800ff7 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ff7:	55                   	push   %ebp
  800ff8:	89 e5                	mov    %esp,%ebp
  800ffa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ffd:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801000:	ba 00 00 00 00       	mov    $0x0,%edx
  801005:	39 c2                	cmp    %eax,%edx
  801007:	74 0d                	je     801016 <strnlen+0x1f>
  801009:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80100d:	74 05                	je     801014 <strnlen+0x1d>
		n++;
  80100f:	83 c2 01             	add    $0x1,%edx
  801012:	eb f1                	jmp    801005 <strnlen+0xe>
  801014:	89 d0                	mov    %edx,%eax
	return n;
}
  801016:	5d                   	pop    %ebp
  801017:	c3                   	ret    

00801018 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801018:	55                   	push   %ebp
  801019:	89 e5                	mov    %esp,%ebp
  80101b:	53                   	push   %ebx
  80101c:	8b 45 08             	mov    0x8(%ebp),%eax
  80101f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801022:	ba 00 00 00 00       	mov    $0x0,%edx
  801027:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80102b:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80102e:	83 c2 01             	add    $0x1,%edx
  801031:	84 c9                	test   %cl,%cl
  801033:	75 f2                	jne    801027 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  801035:	5b                   	pop    %ebx
  801036:	5d                   	pop    %ebp
  801037:	c3                   	ret    

00801038 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801038:	55                   	push   %ebp
  801039:	89 e5                	mov    %esp,%ebp
  80103b:	53                   	push   %ebx
  80103c:	83 ec 10             	sub    $0x10,%esp
  80103f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801042:	53                   	push   %ebx
  801043:	e8 97 ff ff ff       	call   800fdf <strlen>
  801048:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80104b:	ff 75 0c             	pushl  0xc(%ebp)
  80104e:	01 d8                	add    %ebx,%eax
  801050:	50                   	push   %eax
  801051:	e8 c2 ff ff ff       	call   801018 <strcpy>
	return dst;
}
  801056:	89 d8                	mov    %ebx,%eax
  801058:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80105b:	c9                   	leave  
  80105c:	c3                   	ret    

0080105d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80105d:	55                   	push   %ebp
  80105e:	89 e5                	mov    %esp,%ebp
  801060:	56                   	push   %esi
  801061:	53                   	push   %ebx
  801062:	8b 45 08             	mov    0x8(%ebp),%eax
  801065:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801068:	89 c6                	mov    %eax,%esi
  80106a:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80106d:	89 c2                	mov    %eax,%edx
  80106f:	39 f2                	cmp    %esi,%edx
  801071:	74 11                	je     801084 <strncpy+0x27>
		*dst++ = *src;
  801073:	83 c2 01             	add    $0x1,%edx
  801076:	0f b6 19             	movzbl (%ecx),%ebx
  801079:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80107c:	80 fb 01             	cmp    $0x1,%bl
  80107f:	83 d9 ff             	sbb    $0xffffffff,%ecx
  801082:	eb eb                	jmp    80106f <strncpy+0x12>
	}
	return ret;
}
  801084:	5b                   	pop    %ebx
  801085:	5e                   	pop    %esi
  801086:	5d                   	pop    %ebp
  801087:	c3                   	ret    

00801088 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801088:	55                   	push   %ebp
  801089:	89 e5                	mov    %esp,%ebp
  80108b:	56                   	push   %esi
  80108c:	53                   	push   %ebx
  80108d:	8b 75 08             	mov    0x8(%ebp),%esi
  801090:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801093:	8b 55 10             	mov    0x10(%ebp),%edx
  801096:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801098:	85 d2                	test   %edx,%edx
  80109a:	74 21                	je     8010bd <strlcpy+0x35>
  80109c:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8010a0:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8010a2:	39 c2                	cmp    %eax,%edx
  8010a4:	74 14                	je     8010ba <strlcpy+0x32>
  8010a6:	0f b6 19             	movzbl (%ecx),%ebx
  8010a9:	84 db                	test   %bl,%bl
  8010ab:	74 0b                	je     8010b8 <strlcpy+0x30>
			*dst++ = *src++;
  8010ad:	83 c1 01             	add    $0x1,%ecx
  8010b0:	83 c2 01             	add    $0x1,%edx
  8010b3:	88 5a ff             	mov    %bl,-0x1(%edx)
  8010b6:	eb ea                	jmp    8010a2 <strlcpy+0x1a>
  8010b8:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8010ba:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8010bd:	29 f0                	sub    %esi,%eax
}
  8010bf:	5b                   	pop    %ebx
  8010c0:	5e                   	pop    %esi
  8010c1:	5d                   	pop    %ebp
  8010c2:	c3                   	ret    

008010c3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8010c3:	55                   	push   %ebp
  8010c4:	89 e5                	mov    %esp,%ebp
  8010c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010c9:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8010cc:	0f b6 01             	movzbl (%ecx),%eax
  8010cf:	84 c0                	test   %al,%al
  8010d1:	74 0c                	je     8010df <strcmp+0x1c>
  8010d3:	3a 02                	cmp    (%edx),%al
  8010d5:	75 08                	jne    8010df <strcmp+0x1c>
		p++, q++;
  8010d7:	83 c1 01             	add    $0x1,%ecx
  8010da:	83 c2 01             	add    $0x1,%edx
  8010dd:	eb ed                	jmp    8010cc <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8010df:	0f b6 c0             	movzbl %al,%eax
  8010e2:	0f b6 12             	movzbl (%edx),%edx
  8010e5:	29 d0                	sub    %edx,%eax
}
  8010e7:	5d                   	pop    %ebp
  8010e8:	c3                   	ret    

008010e9 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8010e9:	55                   	push   %ebp
  8010ea:	89 e5                	mov    %esp,%ebp
  8010ec:	53                   	push   %ebx
  8010ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f3:	89 c3                	mov    %eax,%ebx
  8010f5:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8010f8:	eb 06                	jmp    801100 <strncmp+0x17>
		n--, p++, q++;
  8010fa:	83 c0 01             	add    $0x1,%eax
  8010fd:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801100:	39 d8                	cmp    %ebx,%eax
  801102:	74 16                	je     80111a <strncmp+0x31>
  801104:	0f b6 08             	movzbl (%eax),%ecx
  801107:	84 c9                	test   %cl,%cl
  801109:	74 04                	je     80110f <strncmp+0x26>
  80110b:	3a 0a                	cmp    (%edx),%cl
  80110d:	74 eb                	je     8010fa <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80110f:	0f b6 00             	movzbl (%eax),%eax
  801112:	0f b6 12             	movzbl (%edx),%edx
  801115:	29 d0                	sub    %edx,%eax
}
  801117:	5b                   	pop    %ebx
  801118:	5d                   	pop    %ebp
  801119:	c3                   	ret    
		return 0;
  80111a:	b8 00 00 00 00       	mov    $0x0,%eax
  80111f:	eb f6                	jmp    801117 <strncmp+0x2e>

00801121 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801121:	55                   	push   %ebp
  801122:	89 e5                	mov    %esp,%ebp
  801124:	8b 45 08             	mov    0x8(%ebp),%eax
  801127:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80112b:	0f b6 10             	movzbl (%eax),%edx
  80112e:	84 d2                	test   %dl,%dl
  801130:	74 09                	je     80113b <strchr+0x1a>
		if (*s == c)
  801132:	38 ca                	cmp    %cl,%dl
  801134:	74 0a                	je     801140 <strchr+0x1f>
	for (; *s; s++)
  801136:	83 c0 01             	add    $0x1,%eax
  801139:	eb f0                	jmp    80112b <strchr+0xa>
			return (char *) s;
	return 0;
  80113b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801140:	5d                   	pop    %ebp
  801141:	c3                   	ret    

00801142 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801142:	55                   	push   %ebp
  801143:	89 e5                	mov    %esp,%ebp
  801145:	8b 45 08             	mov    0x8(%ebp),%eax
  801148:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80114c:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80114f:	38 ca                	cmp    %cl,%dl
  801151:	74 09                	je     80115c <strfind+0x1a>
  801153:	84 d2                	test   %dl,%dl
  801155:	74 05                	je     80115c <strfind+0x1a>
	for (; *s; s++)
  801157:	83 c0 01             	add    $0x1,%eax
  80115a:	eb f0                	jmp    80114c <strfind+0xa>
			break;
	return (char *) s;
}
  80115c:	5d                   	pop    %ebp
  80115d:	c3                   	ret    

0080115e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80115e:	55                   	push   %ebp
  80115f:	89 e5                	mov    %esp,%ebp
  801161:	57                   	push   %edi
  801162:	56                   	push   %esi
  801163:	53                   	push   %ebx
  801164:	8b 7d 08             	mov    0x8(%ebp),%edi
  801167:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80116a:	85 c9                	test   %ecx,%ecx
  80116c:	74 31                	je     80119f <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80116e:	89 f8                	mov    %edi,%eax
  801170:	09 c8                	or     %ecx,%eax
  801172:	a8 03                	test   $0x3,%al
  801174:	75 23                	jne    801199 <memset+0x3b>
		c &= 0xFF;
  801176:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80117a:	89 d3                	mov    %edx,%ebx
  80117c:	c1 e3 08             	shl    $0x8,%ebx
  80117f:	89 d0                	mov    %edx,%eax
  801181:	c1 e0 18             	shl    $0x18,%eax
  801184:	89 d6                	mov    %edx,%esi
  801186:	c1 e6 10             	shl    $0x10,%esi
  801189:	09 f0                	or     %esi,%eax
  80118b:	09 c2                	or     %eax,%edx
  80118d:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80118f:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801192:	89 d0                	mov    %edx,%eax
  801194:	fc                   	cld    
  801195:	f3 ab                	rep stos %eax,%es:(%edi)
  801197:	eb 06                	jmp    80119f <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801199:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119c:	fc                   	cld    
  80119d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80119f:	89 f8                	mov    %edi,%eax
  8011a1:	5b                   	pop    %ebx
  8011a2:	5e                   	pop    %esi
  8011a3:	5f                   	pop    %edi
  8011a4:	5d                   	pop    %ebp
  8011a5:	c3                   	ret    

008011a6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8011a6:	55                   	push   %ebp
  8011a7:	89 e5                	mov    %esp,%ebp
  8011a9:	57                   	push   %edi
  8011aa:	56                   	push   %esi
  8011ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ae:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011b1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8011b4:	39 c6                	cmp    %eax,%esi
  8011b6:	73 32                	jae    8011ea <memmove+0x44>
  8011b8:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8011bb:	39 c2                	cmp    %eax,%edx
  8011bd:	76 2b                	jbe    8011ea <memmove+0x44>
		s += n;
		d += n;
  8011bf:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8011c2:	89 fe                	mov    %edi,%esi
  8011c4:	09 ce                	or     %ecx,%esi
  8011c6:	09 d6                	or     %edx,%esi
  8011c8:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8011ce:	75 0e                	jne    8011de <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8011d0:	83 ef 04             	sub    $0x4,%edi
  8011d3:	8d 72 fc             	lea    -0x4(%edx),%esi
  8011d6:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8011d9:	fd                   	std    
  8011da:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8011dc:	eb 09                	jmp    8011e7 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8011de:	83 ef 01             	sub    $0x1,%edi
  8011e1:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8011e4:	fd                   	std    
  8011e5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8011e7:	fc                   	cld    
  8011e8:	eb 1a                	jmp    801204 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8011ea:	89 c2                	mov    %eax,%edx
  8011ec:	09 ca                	or     %ecx,%edx
  8011ee:	09 f2                	or     %esi,%edx
  8011f0:	f6 c2 03             	test   $0x3,%dl
  8011f3:	75 0a                	jne    8011ff <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8011f5:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8011f8:	89 c7                	mov    %eax,%edi
  8011fa:	fc                   	cld    
  8011fb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8011fd:	eb 05                	jmp    801204 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  8011ff:	89 c7                	mov    %eax,%edi
  801201:	fc                   	cld    
  801202:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801204:	5e                   	pop    %esi
  801205:	5f                   	pop    %edi
  801206:	5d                   	pop    %ebp
  801207:	c3                   	ret    

00801208 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801208:	55                   	push   %ebp
  801209:	89 e5                	mov    %esp,%ebp
  80120b:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  80120e:	ff 75 10             	pushl  0x10(%ebp)
  801211:	ff 75 0c             	pushl  0xc(%ebp)
  801214:	ff 75 08             	pushl  0x8(%ebp)
  801217:	e8 8a ff ff ff       	call   8011a6 <memmove>
}
  80121c:	c9                   	leave  
  80121d:	c3                   	ret    

0080121e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80121e:	55                   	push   %ebp
  80121f:	89 e5                	mov    %esp,%ebp
  801221:	56                   	push   %esi
  801222:	53                   	push   %ebx
  801223:	8b 45 08             	mov    0x8(%ebp),%eax
  801226:	8b 55 0c             	mov    0xc(%ebp),%edx
  801229:	89 c6                	mov    %eax,%esi
  80122b:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80122e:	39 f0                	cmp    %esi,%eax
  801230:	74 1c                	je     80124e <memcmp+0x30>
		if (*s1 != *s2)
  801232:	0f b6 08             	movzbl (%eax),%ecx
  801235:	0f b6 1a             	movzbl (%edx),%ebx
  801238:	38 d9                	cmp    %bl,%cl
  80123a:	75 08                	jne    801244 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  80123c:	83 c0 01             	add    $0x1,%eax
  80123f:	83 c2 01             	add    $0x1,%edx
  801242:	eb ea                	jmp    80122e <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801244:	0f b6 c1             	movzbl %cl,%eax
  801247:	0f b6 db             	movzbl %bl,%ebx
  80124a:	29 d8                	sub    %ebx,%eax
  80124c:	eb 05                	jmp    801253 <memcmp+0x35>
	}

	return 0;
  80124e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801253:	5b                   	pop    %ebx
  801254:	5e                   	pop    %esi
  801255:	5d                   	pop    %ebp
  801256:	c3                   	ret    

00801257 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801257:	55                   	push   %ebp
  801258:	89 e5                	mov    %esp,%ebp
  80125a:	8b 45 08             	mov    0x8(%ebp),%eax
  80125d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801260:	89 c2                	mov    %eax,%edx
  801262:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801265:	39 d0                	cmp    %edx,%eax
  801267:	73 09                	jae    801272 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  801269:	38 08                	cmp    %cl,(%eax)
  80126b:	74 05                	je     801272 <memfind+0x1b>
	for (; s < ends; s++)
  80126d:	83 c0 01             	add    $0x1,%eax
  801270:	eb f3                	jmp    801265 <memfind+0xe>
			break;
	return (void *) s;
}
  801272:	5d                   	pop    %ebp
  801273:	c3                   	ret    

00801274 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801274:	55                   	push   %ebp
  801275:	89 e5                	mov    %esp,%ebp
  801277:	57                   	push   %edi
  801278:	56                   	push   %esi
  801279:	53                   	push   %ebx
  80127a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80127d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801280:	eb 03                	jmp    801285 <strtol+0x11>
		s++;
  801282:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801285:	0f b6 01             	movzbl (%ecx),%eax
  801288:	3c 20                	cmp    $0x20,%al
  80128a:	74 f6                	je     801282 <strtol+0xe>
  80128c:	3c 09                	cmp    $0x9,%al
  80128e:	74 f2                	je     801282 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801290:	3c 2b                	cmp    $0x2b,%al
  801292:	74 2a                	je     8012be <strtol+0x4a>
	int neg = 0;
  801294:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801299:	3c 2d                	cmp    $0x2d,%al
  80129b:	74 2b                	je     8012c8 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80129d:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8012a3:	75 0f                	jne    8012b4 <strtol+0x40>
  8012a5:	80 39 30             	cmpb   $0x30,(%ecx)
  8012a8:	74 28                	je     8012d2 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8012aa:	85 db                	test   %ebx,%ebx
  8012ac:	b8 0a 00 00 00       	mov    $0xa,%eax
  8012b1:	0f 44 d8             	cmove  %eax,%ebx
  8012b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8012b9:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8012bc:	eb 50                	jmp    80130e <strtol+0x9a>
		s++;
  8012be:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  8012c1:	bf 00 00 00 00       	mov    $0x0,%edi
  8012c6:	eb d5                	jmp    80129d <strtol+0x29>
		s++, neg = 1;
  8012c8:	83 c1 01             	add    $0x1,%ecx
  8012cb:	bf 01 00 00 00       	mov    $0x1,%edi
  8012d0:	eb cb                	jmp    80129d <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8012d2:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8012d6:	74 0e                	je     8012e6 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  8012d8:	85 db                	test   %ebx,%ebx
  8012da:	75 d8                	jne    8012b4 <strtol+0x40>
		s++, base = 8;
  8012dc:	83 c1 01             	add    $0x1,%ecx
  8012df:	bb 08 00 00 00       	mov    $0x8,%ebx
  8012e4:	eb ce                	jmp    8012b4 <strtol+0x40>
		s += 2, base = 16;
  8012e6:	83 c1 02             	add    $0x2,%ecx
  8012e9:	bb 10 00 00 00       	mov    $0x10,%ebx
  8012ee:	eb c4                	jmp    8012b4 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  8012f0:	8d 72 9f             	lea    -0x61(%edx),%esi
  8012f3:	89 f3                	mov    %esi,%ebx
  8012f5:	80 fb 19             	cmp    $0x19,%bl
  8012f8:	77 29                	ja     801323 <strtol+0xaf>
			dig = *s - 'a' + 10;
  8012fa:	0f be d2             	movsbl %dl,%edx
  8012fd:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801300:	3b 55 10             	cmp    0x10(%ebp),%edx
  801303:	7d 30                	jge    801335 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  801305:	83 c1 01             	add    $0x1,%ecx
  801308:	0f af 45 10          	imul   0x10(%ebp),%eax
  80130c:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  80130e:	0f b6 11             	movzbl (%ecx),%edx
  801311:	8d 72 d0             	lea    -0x30(%edx),%esi
  801314:	89 f3                	mov    %esi,%ebx
  801316:	80 fb 09             	cmp    $0x9,%bl
  801319:	77 d5                	ja     8012f0 <strtol+0x7c>
			dig = *s - '0';
  80131b:	0f be d2             	movsbl %dl,%edx
  80131e:	83 ea 30             	sub    $0x30,%edx
  801321:	eb dd                	jmp    801300 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  801323:	8d 72 bf             	lea    -0x41(%edx),%esi
  801326:	89 f3                	mov    %esi,%ebx
  801328:	80 fb 19             	cmp    $0x19,%bl
  80132b:	77 08                	ja     801335 <strtol+0xc1>
			dig = *s - 'A' + 10;
  80132d:	0f be d2             	movsbl %dl,%edx
  801330:	83 ea 37             	sub    $0x37,%edx
  801333:	eb cb                	jmp    801300 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  801335:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801339:	74 05                	je     801340 <strtol+0xcc>
		*endptr = (char *) s;
  80133b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80133e:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801340:	89 c2                	mov    %eax,%edx
  801342:	f7 da                	neg    %edx
  801344:	85 ff                	test   %edi,%edi
  801346:	0f 45 c2             	cmovne %edx,%eax
}
  801349:	5b                   	pop    %ebx
  80134a:	5e                   	pop    %esi
  80134b:	5f                   	pop    %edi
  80134c:	5d                   	pop    %ebp
  80134d:	c3                   	ret    

0080134e <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  80134e:	55                   	push   %ebp
  80134f:	89 e5                	mov    %esp,%ebp
  801351:	57                   	push   %edi
  801352:	56                   	push   %esi
  801353:	53                   	push   %ebx
	asm volatile("int %1\n"
  801354:	b8 00 00 00 00       	mov    $0x0,%eax
  801359:	8b 55 08             	mov    0x8(%ebp),%edx
  80135c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80135f:	89 c3                	mov    %eax,%ebx
  801361:	89 c7                	mov    %eax,%edi
  801363:	89 c6                	mov    %eax,%esi
  801365:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801367:	5b                   	pop    %ebx
  801368:	5e                   	pop    %esi
  801369:	5f                   	pop    %edi
  80136a:	5d                   	pop    %ebp
  80136b:	c3                   	ret    

0080136c <sys_cgetc>:

int
sys_cgetc(void)
{
  80136c:	55                   	push   %ebp
  80136d:	89 e5                	mov    %esp,%ebp
  80136f:	57                   	push   %edi
  801370:	56                   	push   %esi
  801371:	53                   	push   %ebx
	asm volatile("int %1\n"
  801372:	ba 00 00 00 00       	mov    $0x0,%edx
  801377:	b8 01 00 00 00       	mov    $0x1,%eax
  80137c:	89 d1                	mov    %edx,%ecx
  80137e:	89 d3                	mov    %edx,%ebx
  801380:	89 d7                	mov    %edx,%edi
  801382:	89 d6                	mov    %edx,%esi
  801384:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801386:	5b                   	pop    %ebx
  801387:	5e                   	pop    %esi
  801388:	5f                   	pop    %edi
  801389:	5d                   	pop    %ebp
  80138a:	c3                   	ret    

0080138b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80138b:	55                   	push   %ebp
  80138c:	89 e5                	mov    %esp,%ebp
  80138e:	57                   	push   %edi
  80138f:	56                   	push   %esi
  801390:	53                   	push   %ebx
  801391:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801394:	b9 00 00 00 00       	mov    $0x0,%ecx
  801399:	8b 55 08             	mov    0x8(%ebp),%edx
  80139c:	b8 03 00 00 00       	mov    $0x3,%eax
  8013a1:	89 cb                	mov    %ecx,%ebx
  8013a3:	89 cf                	mov    %ecx,%edi
  8013a5:	89 ce                	mov    %ecx,%esi
  8013a7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8013a9:	85 c0                	test   %eax,%eax
  8013ab:	7f 08                	jg     8013b5 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8013ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013b0:	5b                   	pop    %ebx
  8013b1:	5e                   	pop    %esi
  8013b2:	5f                   	pop    %edi
  8013b3:	5d                   	pop    %ebp
  8013b4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8013b5:	83 ec 0c             	sub    $0xc,%esp
  8013b8:	50                   	push   %eax
  8013b9:	6a 03                	push   $0x3
  8013bb:	68 e8 33 80 00       	push   $0x8033e8
  8013c0:	6a 43                	push   $0x43
  8013c2:	68 05 34 80 00       	push   $0x803405
  8013c7:	e8 f7 f3 ff ff       	call   8007c3 <_panic>

008013cc <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8013cc:	55                   	push   %ebp
  8013cd:	89 e5                	mov    %esp,%ebp
  8013cf:	57                   	push   %edi
  8013d0:	56                   	push   %esi
  8013d1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8013d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8013d7:	b8 02 00 00 00       	mov    $0x2,%eax
  8013dc:	89 d1                	mov    %edx,%ecx
  8013de:	89 d3                	mov    %edx,%ebx
  8013e0:	89 d7                	mov    %edx,%edi
  8013e2:	89 d6                	mov    %edx,%esi
  8013e4:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8013e6:	5b                   	pop    %ebx
  8013e7:	5e                   	pop    %esi
  8013e8:	5f                   	pop    %edi
  8013e9:	5d                   	pop    %ebp
  8013ea:	c3                   	ret    

008013eb <sys_yield>:

void
sys_yield(void)
{
  8013eb:	55                   	push   %ebp
  8013ec:	89 e5                	mov    %esp,%ebp
  8013ee:	57                   	push   %edi
  8013ef:	56                   	push   %esi
  8013f0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8013f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8013f6:	b8 0b 00 00 00       	mov    $0xb,%eax
  8013fb:	89 d1                	mov    %edx,%ecx
  8013fd:	89 d3                	mov    %edx,%ebx
  8013ff:	89 d7                	mov    %edx,%edi
  801401:	89 d6                	mov    %edx,%esi
  801403:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801405:	5b                   	pop    %ebx
  801406:	5e                   	pop    %esi
  801407:	5f                   	pop    %edi
  801408:	5d                   	pop    %ebp
  801409:	c3                   	ret    

0080140a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80140a:	55                   	push   %ebp
  80140b:	89 e5                	mov    %esp,%ebp
  80140d:	57                   	push   %edi
  80140e:	56                   	push   %esi
  80140f:	53                   	push   %ebx
  801410:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801413:	be 00 00 00 00       	mov    $0x0,%esi
  801418:	8b 55 08             	mov    0x8(%ebp),%edx
  80141b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80141e:	b8 04 00 00 00       	mov    $0x4,%eax
  801423:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801426:	89 f7                	mov    %esi,%edi
  801428:	cd 30                	int    $0x30
	if(check && ret > 0)
  80142a:	85 c0                	test   %eax,%eax
  80142c:	7f 08                	jg     801436 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80142e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801431:	5b                   	pop    %ebx
  801432:	5e                   	pop    %esi
  801433:	5f                   	pop    %edi
  801434:	5d                   	pop    %ebp
  801435:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801436:	83 ec 0c             	sub    $0xc,%esp
  801439:	50                   	push   %eax
  80143a:	6a 04                	push   $0x4
  80143c:	68 e8 33 80 00       	push   $0x8033e8
  801441:	6a 43                	push   $0x43
  801443:	68 05 34 80 00       	push   $0x803405
  801448:	e8 76 f3 ff ff       	call   8007c3 <_panic>

0080144d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80144d:	55                   	push   %ebp
  80144e:	89 e5                	mov    %esp,%ebp
  801450:	57                   	push   %edi
  801451:	56                   	push   %esi
  801452:	53                   	push   %ebx
  801453:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801456:	8b 55 08             	mov    0x8(%ebp),%edx
  801459:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80145c:	b8 05 00 00 00       	mov    $0x5,%eax
  801461:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801464:	8b 7d 14             	mov    0x14(%ebp),%edi
  801467:	8b 75 18             	mov    0x18(%ebp),%esi
  80146a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80146c:	85 c0                	test   %eax,%eax
  80146e:	7f 08                	jg     801478 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801470:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801473:	5b                   	pop    %ebx
  801474:	5e                   	pop    %esi
  801475:	5f                   	pop    %edi
  801476:	5d                   	pop    %ebp
  801477:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801478:	83 ec 0c             	sub    $0xc,%esp
  80147b:	50                   	push   %eax
  80147c:	6a 05                	push   $0x5
  80147e:	68 e8 33 80 00       	push   $0x8033e8
  801483:	6a 43                	push   $0x43
  801485:	68 05 34 80 00       	push   $0x803405
  80148a:	e8 34 f3 ff ff       	call   8007c3 <_panic>

0080148f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80148f:	55                   	push   %ebp
  801490:	89 e5                	mov    %esp,%ebp
  801492:	57                   	push   %edi
  801493:	56                   	push   %esi
  801494:	53                   	push   %ebx
  801495:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801498:	bb 00 00 00 00       	mov    $0x0,%ebx
  80149d:	8b 55 08             	mov    0x8(%ebp),%edx
  8014a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014a3:	b8 06 00 00 00       	mov    $0x6,%eax
  8014a8:	89 df                	mov    %ebx,%edi
  8014aa:	89 de                	mov    %ebx,%esi
  8014ac:	cd 30                	int    $0x30
	if(check && ret > 0)
  8014ae:	85 c0                	test   %eax,%eax
  8014b0:	7f 08                	jg     8014ba <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8014b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014b5:	5b                   	pop    %ebx
  8014b6:	5e                   	pop    %esi
  8014b7:	5f                   	pop    %edi
  8014b8:	5d                   	pop    %ebp
  8014b9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8014ba:	83 ec 0c             	sub    $0xc,%esp
  8014bd:	50                   	push   %eax
  8014be:	6a 06                	push   $0x6
  8014c0:	68 e8 33 80 00       	push   $0x8033e8
  8014c5:	6a 43                	push   $0x43
  8014c7:	68 05 34 80 00       	push   $0x803405
  8014cc:	e8 f2 f2 ff ff       	call   8007c3 <_panic>

008014d1 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8014d1:	55                   	push   %ebp
  8014d2:	89 e5                	mov    %esp,%ebp
  8014d4:	57                   	push   %edi
  8014d5:	56                   	push   %esi
  8014d6:	53                   	push   %ebx
  8014d7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8014da:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014df:	8b 55 08             	mov    0x8(%ebp),%edx
  8014e2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014e5:	b8 08 00 00 00       	mov    $0x8,%eax
  8014ea:	89 df                	mov    %ebx,%edi
  8014ec:	89 de                	mov    %ebx,%esi
  8014ee:	cd 30                	int    $0x30
	if(check && ret > 0)
  8014f0:	85 c0                	test   %eax,%eax
  8014f2:	7f 08                	jg     8014fc <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8014f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014f7:	5b                   	pop    %ebx
  8014f8:	5e                   	pop    %esi
  8014f9:	5f                   	pop    %edi
  8014fa:	5d                   	pop    %ebp
  8014fb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8014fc:	83 ec 0c             	sub    $0xc,%esp
  8014ff:	50                   	push   %eax
  801500:	6a 08                	push   $0x8
  801502:	68 e8 33 80 00       	push   $0x8033e8
  801507:	6a 43                	push   $0x43
  801509:	68 05 34 80 00       	push   $0x803405
  80150e:	e8 b0 f2 ff ff       	call   8007c3 <_panic>

00801513 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801513:	55                   	push   %ebp
  801514:	89 e5                	mov    %esp,%ebp
  801516:	57                   	push   %edi
  801517:	56                   	push   %esi
  801518:	53                   	push   %ebx
  801519:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80151c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801521:	8b 55 08             	mov    0x8(%ebp),%edx
  801524:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801527:	b8 09 00 00 00       	mov    $0x9,%eax
  80152c:	89 df                	mov    %ebx,%edi
  80152e:	89 de                	mov    %ebx,%esi
  801530:	cd 30                	int    $0x30
	if(check && ret > 0)
  801532:	85 c0                	test   %eax,%eax
  801534:	7f 08                	jg     80153e <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801536:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801539:	5b                   	pop    %ebx
  80153a:	5e                   	pop    %esi
  80153b:	5f                   	pop    %edi
  80153c:	5d                   	pop    %ebp
  80153d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80153e:	83 ec 0c             	sub    $0xc,%esp
  801541:	50                   	push   %eax
  801542:	6a 09                	push   $0x9
  801544:	68 e8 33 80 00       	push   $0x8033e8
  801549:	6a 43                	push   $0x43
  80154b:	68 05 34 80 00       	push   $0x803405
  801550:	e8 6e f2 ff ff       	call   8007c3 <_panic>

00801555 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801555:	55                   	push   %ebp
  801556:	89 e5                	mov    %esp,%ebp
  801558:	57                   	push   %edi
  801559:	56                   	push   %esi
  80155a:	53                   	push   %ebx
  80155b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80155e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801563:	8b 55 08             	mov    0x8(%ebp),%edx
  801566:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801569:	b8 0a 00 00 00       	mov    $0xa,%eax
  80156e:	89 df                	mov    %ebx,%edi
  801570:	89 de                	mov    %ebx,%esi
  801572:	cd 30                	int    $0x30
	if(check && ret > 0)
  801574:	85 c0                	test   %eax,%eax
  801576:	7f 08                	jg     801580 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801578:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80157b:	5b                   	pop    %ebx
  80157c:	5e                   	pop    %esi
  80157d:	5f                   	pop    %edi
  80157e:	5d                   	pop    %ebp
  80157f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801580:	83 ec 0c             	sub    $0xc,%esp
  801583:	50                   	push   %eax
  801584:	6a 0a                	push   $0xa
  801586:	68 e8 33 80 00       	push   $0x8033e8
  80158b:	6a 43                	push   $0x43
  80158d:	68 05 34 80 00       	push   $0x803405
  801592:	e8 2c f2 ff ff       	call   8007c3 <_panic>

00801597 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801597:	55                   	push   %ebp
  801598:	89 e5                	mov    %esp,%ebp
  80159a:	57                   	push   %edi
  80159b:	56                   	push   %esi
  80159c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80159d:	8b 55 08             	mov    0x8(%ebp),%edx
  8015a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015a3:	b8 0c 00 00 00       	mov    $0xc,%eax
  8015a8:	be 00 00 00 00       	mov    $0x0,%esi
  8015ad:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8015b0:	8b 7d 14             	mov    0x14(%ebp),%edi
  8015b3:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8015b5:	5b                   	pop    %ebx
  8015b6:	5e                   	pop    %esi
  8015b7:	5f                   	pop    %edi
  8015b8:	5d                   	pop    %ebp
  8015b9:	c3                   	ret    

008015ba <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8015ba:	55                   	push   %ebp
  8015bb:	89 e5                	mov    %esp,%ebp
  8015bd:	57                   	push   %edi
  8015be:	56                   	push   %esi
  8015bf:	53                   	push   %ebx
  8015c0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8015c3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8015c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8015cb:	b8 0d 00 00 00       	mov    $0xd,%eax
  8015d0:	89 cb                	mov    %ecx,%ebx
  8015d2:	89 cf                	mov    %ecx,%edi
  8015d4:	89 ce                	mov    %ecx,%esi
  8015d6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8015d8:	85 c0                	test   %eax,%eax
  8015da:	7f 08                	jg     8015e4 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8015dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015df:	5b                   	pop    %ebx
  8015e0:	5e                   	pop    %esi
  8015e1:	5f                   	pop    %edi
  8015e2:	5d                   	pop    %ebp
  8015e3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8015e4:	83 ec 0c             	sub    $0xc,%esp
  8015e7:	50                   	push   %eax
  8015e8:	6a 0d                	push   $0xd
  8015ea:	68 e8 33 80 00       	push   $0x8033e8
  8015ef:	6a 43                	push   $0x43
  8015f1:	68 05 34 80 00       	push   $0x803405
  8015f6:	e8 c8 f1 ff ff       	call   8007c3 <_panic>

008015fb <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  8015fb:	55                   	push   %ebp
  8015fc:	89 e5                	mov    %esp,%ebp
  8015fe:	57                   	push   %edi
  8015ff:	56                   	push   %esi
  801600:	53                   	push   %ebx
	asm volatile("int %1\n"
  801601:	bb 00 00 00 00       	mov    $0x0,%ebx
  801606:	8b 55 08             	mov    0x8(%ebp),%edx
  801609:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80160c:	b8 0e 00 00 00       	mov    $0xe,%eax
  801611:	89 df                	mov    %ebx,%edi
  801613:	89 de                	mov    %ebx,%esi
  801615:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801617:	5b                   	pop    %ebx
  801618:	5e                   	pop    %esi
  801619:	5f                   	pop    %edi
  80161a:	5d                   	pop    %ebp
  80161b:	c3                   	ret    

0080161c <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  80161c:	55                   	push   %ebp
  80161d:	89 e5                	mov    %esp,%ebp
  80161f:	57                   	push   %edi
  801620:	56                   	push   %esi
  801621:	53                   	push   %ebx
	asm volatile("int %1\n"
  801622:	b9 00 00 00 00       	mov    $0x0,%ecx
  801627:	8b 55 08             	mov    0x8(%ebp),%edx
  80162a:	b8 0f 00 00 00       	mov    $0xf,%eax
  80162f:	89 cb                	mov    %ecx,%ebx
  801631:	89 cf                	mov    %ecx,%edi
  801633:	89 ce                	mov    %ecx,%esi
  801635:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801637:	5b                   	pop    %ebx
  801638:	5e                   	pop    %esi
  801639:	5f                   	pop    %edi
  80163a:	5d                   	pop    %ebp
  80163b:	c3                   	ret    

0080163c <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80163c:	55                   	push   %ebp
  80163d:	89 e5                	mov    %esp,%ebp
  80163f:	57                   	push   %edi
  801640:	56                   	push   %esi
  801641:	53                   	push   %ebx
	asm volatile("int %1\n"
  801642:	ba 00 00 00 00       	mov    $0x0,%edx
  801647:	b8 10 00 00 00       	mov    $0x10,%eax
  80164c:	89 d1                	mov    %edx,%ecx
  80164e:	89 d3                	mov    %edx,%ebx
  801650:	89 d7                	mov    %edx,%edi
  801652:	89 d6                	mov    %edx,%esi
  801654:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801656:	5b                   	pop    %ebx
  801657:	5e                   	pop    %esi
  801658:	5f                   	pop    %edi
  801659:	5d                   	pop    %ebp
  80165a:	c3                   	ret    

0080165b <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  80165b:	55                   	push   %ebp
  80165c:	89 e5                	mov    %esp,%ebp
  80165e:	57                   	push   %edi
  80165f:	56                   	push   %esi
  801660:	53                   	push   %ebx
	asm volatile("int %1\n"
  801661:	bb 00 00 00 00       	mov    $0x0,%ebx
  801666:	8b 55 08             	mov    0x8(%ebp),%edx
  801669:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80166c:	b8 11 00 00 00       	mov    $0x11,%eax
  801671:	89 df                	mov    %ebx,%edi
  801673:	89 de                	mov    %ebx,%esi
  801675:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801677:	5b                   	pop    %ebx
  801678:	5e                   	pop    %esi
  801679:	5f                   	pop    %edi
  80167a:	5d                   	pop    %ebp
  80167b:	c3                   	ret    

0080167c <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  80167c:	55                   	push   %ebp
  80167d:	89 e5                	mov    %esp,%ebp
  80167f:	57                   	push   %edi
  801680:	56                   	push   %esi
  801681:	53                   	push   %ebx
	asm volatile("int %1\n"
  801682:	bb 00 00 00 00       	mov    $0x0,%ebx
  801687:	8b 55 08             	mov    0x8(%ebp),%edx
  80168a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80168d:	b8 12 00 00 00       	mov    $0x12,%eax
  801692:	89 df                	mov    %ebx,%edi
  801694:	89 de                	mov    %ebx,%esi
  801696:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801698:	5b                   	pop    %ebx
  801699:	5e                   	pop    %esi
  80169a:	5f                   	pop    %edi
  80169b:	5d                   	pop    %ebp
  80169c:	c3                   	ret    

0080169d <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  80169d:	55                   	push   %ebp
  80169e:	89 e5                	mov    %esp,%ebp
  8016a0:	57                   	push   %edi
  8016a1:	56                   	push   %esi
  8016a2:	53                   	push   %ebx
  8016a3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8016a6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8016ae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016b1:	b8 13 00 00 00       	mov    $0x13,%eax
  8016b6:	89 df                	mov    %ebx,%edi
  8016b8:	89 de                	mov    %ebx,%esi
  8016ba:	cd 30                	int    $0x30
	if(check && ret > 0)
  8016bc:	85 c0                	test   %eax,%eax
  8016be:	7f 08                	jg     8016c8 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8016c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016c3:	5b                   	pop    %ebx
  8016c4:	5e                   	pop    %esi
  8016c5:	5f                   	pop    %edi
  8016c6:	5d                   	pop    %ebp
  8016c7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8016c8:	83 ec 0c             	sub    $0xc,%esp
  8016cb:	50                   	push   %eax
  8016cc:	6a 13                	push   $0x13
  8016ce:	68 e8 33 80 00       	push   $0x8033e8
  8016d3:	6a 43                	push   $0x43
  8016d5:	68 05 34 80 00       	push   $0x803405
  8016da:	e8 e4 f0 ff ff       	call   8007c3 <_panic>

008016df <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  8016df:	55                   	push   %ebp
  8016e0:	89 e5                	mov    %esp,%ebp
  8016e2:	57                   	push   %edi
  8016e3:	56                   	push   %esi
  8016e4:	53                   	push   %ebx
	asm volatile("int %1\n"
  8016e5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8016ed:	b8 14 00 00 00       	mov    $0x14,%eax
  8016f2:	89 cb                	mov    %ecx,%ebx
  8016f4:	89 cf                	mov    %ecx,%edi
  8016f6:	89 ce                	mov    %ecx,%esi
  8016f8:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  8016fa:	5b                   	pop    %ebx
  8016fb:	5e                   	pop    %esi
  8016fc:	5f                   	pop    %edi
  8016fd:	5d                   	pop    %ebp
  8016fe:	c3                   	ret    

008016ff <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8016ff:	55                   	push   %ebp
  801700:	89 e5                	mov    %esp,%ebp
  801702:	56                   	push   %esi
  801703:	53                   	push   %ebx
  801704:	8b 75 08             	mov    0x8(%ebp),%esi
  801707:	8b 45 0c             	mov    0xc(%ebp),%eax
  80170a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  80170d:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80170f:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801714:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  801717:	83 ec 0c             	sub    $0xc,%esp
  80171a:	50                   	push   %eax
  80171b:	e8 9a fe ff ff       	call   8015ba <sys_ipc_recv>
	if(ret < 0){
  801720:	83 c4 10             	add    $0x10,%esp
  801723:	85 c0                	test   %eax,%eax
  801725:	78 2b                	js     801752 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  801727:	85 f6                	test   %esi,%esi
  801729:	74 0a                	je     801735 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  80172b:	a1 08 50 80 00       	mov    0x805008,%eax
  801730:	8b 40 78             	mov    0x78(%eax),%eax
  801733:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  801735:	85 db                	test   %ebx,%ebx
  801737:	74 0a                	je     801743 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  801739:	a1 08 50 80 00       	mov    0x805008,%eax
  80173e:	8b 40 7c             	mov    0x7c(%eax),%eax
  801741:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801743:	a1 08 50 80 00       	mov    0x805008,%eax
  801748:	8b 40 74             	mov    0x74(%eax),%eax
}
  80174b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80174e:	5b                   	pop    %ebx
  80174f:	5e                   	pop    %esi
  801750:	5d                   	pop    %ebp
  801751:	c3                   	ret    
		if(from_env_store)
  801752:	85 f6                	test   %esi,%esi
  801754:	74 06                	je     80175c <ipc_recv+0x5d>
			*from_env_store = 0;
  801756:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80175c:	85 db                	test   %ebx,%ebx
  80175e:	74 eb                	je     80174b <ipc_recv+0x4c>
			*perm_store = 0;
  801760:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801766:	eb e3                	jmp    80174b <ipc_recv+0x4c>

00801768 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  801768:	55                   	push   %ebp
  801769:	89 e5                	mov    %esp,%ebp
  80176b:	57                   	push   %edi
  80176c:	56                   	push   %esi
  80176d:	53                   	push   %ebx
  80176e:	83 ec 0c             	sub    $0xc,%esp
  801771:	8b 7d 08             	mov    0x8(%ebp),%edi
  801774:	8b 75 0c             	mov    0xc(%ebp),%esi
  801777:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80177a:	85 db                	test   %ebx,%ebx
  80177c:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801781:	0f 44 d8             	cmove  %eax,%ebx
  801784:	eb 05                	jmp    80178b <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  801786:	e8 60 fc ff ff       	call   8013eb <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80178b:	ff 75 14             	pushl  0x14(%ebp)
  80178e:	53                   	push   %ebx
  80178f:	56                   	push   %esi
  801790:	57                   	push   %edi
  801791:	e8 01 fe ff ff       	call   801597 <sys_ipc_try_send>
  801796:	83 c4 10             	add    $0x10,%esp
  801799:	85 c0                	test   %eax,%eax
  80179b:	74 1b                	je     8017b8 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80179d:	79 e7                	jns    801786 <ipc_send+0x1e>
  80179f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8017a2:	74 e2                	je     801786 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8017a4:	83 ec 04             	sub    $0x4,%esp
  8017a7:	68 13 34 80 00       	push   $0x803413
  8017ac:	6a 46                	push   $0x46
  8017ae:	68 28 34 80 00       	push   $0x803428
  8017b3:	e8 0b f0 ff ff       	call   8007c3 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8017b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017bb:	5b                   	pop    %ebx
  8017bc:	5e                   	pop    %esi
  8017bd:	5f                   	pop    %edi
  8017be:	5d                   	pop    %ebp
  8017bf:	c3                   	ret    

008017c0 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8017c0:	55                   	push   %ebp
  8017c1:	89 e5                	mov    %esp,%ebp
  8017c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8017c6:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8017cb:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  8017d1:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8017d7:	8b 52 50             	mov    0x50(%edx),%edx
  8017da:	39 ca                	cmp    %ecx,%edx
  8017dc:	74 11                	je     8017ef <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8017de:	83 c0 01             	add    $0x1,%eax
  8017e1:	3d 00 04 00 00       	cmp    $0x400,%eax
  8017e6:	75 e3                	jne    8017cb <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8017e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ed:	eb 0e                	jmp    8017fd <ipc_find_env+0x3d>
			return envs[i].env_id;
  8017ef:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8017f5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8017fa:	8b 40 48             	mov    0x48(%eax),%eax
}
  8017fd:	5d                   	pop    %ebp
  8017fe:	c3                   	ret    

008017ff <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8017ff:	55                   	push   %ebp
  801800:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801802:	8b 45 08             	mov    0x8(%ebp),%eax
  801805:	05 00 00 00 30       	add    $0x30000000,%eax
  80180a:	c1 e8 0c             	shr    $0xc,%eax
}
  80180d:	5d                   	pop    %ebp
  80180e:	c3                   	ret    

0080180f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80180f:	55                   	push   %ebp
  801810:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801812:	8b 45 08             	mov    0x8(%ebp),%eax
  801815:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80181a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80181f:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801824:	5d                   	pop    %ebp
  801825:	c3                   	ret    

00801826 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801826:	55                   	push   %ebp
  801827:	89 e5                	mov    %esp,%ebp
  801829:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80182e:	89 c2                	mov    %eax,%edx
  801830:	c1 ea 16             	shr    $0x16,%edx
  801833:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80183a:	f6 c2 01             	test   $0x1,%dl
  80183d:	74 2d                	je     80186c <fd_alloc+0x46>
  80183f:	89 c2                	mov    %eax,%edx
  801841:	c1 ea 0c             	shr    $0xc,%edx
  801844:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80184b:	f6 c2 01             	test   $0x1,%dl
  80184e:	74 1c                	je     80186c <fd_alloc+0x46>
  801850:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801855:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80185a:	75 d2                	jne    80182e <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80185c:	8b 45 08             	mov    0x8(%ebp),%eax
  80185f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801865:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80186a:	eb 0a                	jmp    801876 <fd_alloc+0x50>
			*fd_store = fd;
  80186c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80186f:	89 01                	mov    %eax,(%ecx)
			return 0;
  801871:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801876:	5d                   	pop    %ebp
  801877:	c3                   	ret    

00801878 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801878:	55                   	push   %ebp
  801879:	89 e5                	mov    %esp,%ebp
  80187b:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80187e:	83 f8 1f             	cmp    $0x1f,%eax
  801881:	77 30                	ja     8018b3 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801883:	c1 e0 0c             	shl    $0xc,%eax
  801886:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80188b:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801891:	f6 c2 01             	test   $0x1,%dl
  801894:	74 24                	je     8018ba <fd_lookup+0x42>
  801896:	89 c2                	mov    %eax,%edx
  801898:	c1 ea 0c             	shr    $0xc,%edx
  80189b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8018a2:	f6 c2 01             	test   $0x1,%dl
  8018a5:	74 1a                	je     8018c1 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8018a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018aa:	89 02                	mov    %eax,(%edx)
	return 0;
  8018ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018b1:	5d                   	pop    %ebp
  8018b2:	c3                   	ret    
		return -E_INVAL;
  8018b3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018b8:	eb f7                	jmp    8018b1 <fd_lookup+0x39>
		return -E_INVAL;
  8018ba:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018bf:	eb f0                	jmp    8018b1 <fd_lookup+0x39>
  8018c1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018c6:	eb e9                	jmp    8018b1 <fd_lookup+0x39>

008018c8 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8018c8:	55                   	push   %ebp
  8018c9:	89 e5                	mov    %esp,%ebp
  8018cb:	83 ec 08             	sub    $0x8,%esp
  8018ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8018d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d6:	b8 08 40 80 00       	mov    $0x804008,%eax
		if (devtab[i]->dev_id == dev_id) {
  8018db:	39 08                	cmp    %ecx,(%eax)
  8018dd:	74 38                	je     801917 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8018df:	83 c2 01             	add    $0x1,%edx
  8018e2:	8b 04 95 b4 34 80 00 	mov    0x8034b4(,%edx,4),%eax
  8018e9:	85 c0                	test   %eax,%eax
  8018eb:	75 ee                	jne    8018db <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8018ed:	a1 08 50 80 00       	mov    0x805008,%eax
  8018f2:	8b 40 48             	mov    0x48(%eax),%eax
  8018f5:	83 ec 04             	sub    $0x4,%esp
  8018f8:	51                   	push   %ecx
  8018f9:	50                   	push   %eax
  8018fa:	68 34 34 80 00       	push   $0x803434
  8018ff:	e8 b5 ef ff ff       	call   8008b9 <cprintf>
	*dev = 0;
  801904:	8b 45 0c             	mov    0xc(%ebp),%eax
  801907:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80190d:	83 c4 10             	add    $0x10,%esp
  801910:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801915:	c9                   	leave  
  801916:	c3                   	ret    
			*dev = devtab[i];
  801917:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80191a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80191c:	b8 00 00 00 00       	mov    $0x0,%eax
  801921:	eb f2                	jmp    801915 <dev_lookup+0x4d>

00801923 <fd_close>:
{
  801923:	55                   	push   %ebp
  801924:	89 e5                	mov    %esp,%ebp
  801926:	57                   	push   %edi
  801927:	56                   	push   %esi
  801928:	53                   	push   %ebx
  801929:	83 ec 24             	sub    $0x24,%esp
  80192c:	8b 75 08             	mov    0x8(%ebp),%esi
  80192f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801932:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801935:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801936:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80193c:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80193f:	50                   	push   %eax
  801940:	e8 33 ff ff ff       	call   801878 <fd_lookup>
  801945:	89 c3                	mov    %eax,%ebx
  801947:	83 c4 10             	add    $0x10,%esp
  80194a:	85 c0                	test   %eax,%eax
  80194c:	78 05                	js     801953 <fd_close+0x30>
	    || fd != fd2)
  80194e:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801951:	74 16                	je     801969 <fd_close+0x46>
		return (must_exist ? r : 0);
  801953:	89 f8                	mov    %edi,%eax
  801955:	84 c0                	test   %al,%al
  801957:	b8 00 00 00 00       	mov    $0x0,%eax
  80195c:	0f 44 d8             	cmove  %eax,%ebx
}
  80195f:	89 d8                	mov    %ebx,%eax
  801961:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801964:	5b                   	pop    %ebx
  801965:	5e                   	pop    %esi
  801966:	5f                   	pop    %edi
  801967:	5d                   	pop    %ebp
  801968:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801969:	83 ec 08             	sub    $0x8,%esp
  80196c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80196f:	50                   	push   %eax
  801970:	ff 36                	pushl  (%esi)
  801972:	e8 51 ff ff ff       	call   8018c8 <dev_lookup>
  801977:	89 c3                	mov    %eax,%ebx
  801979:	83 c4 10             	add    $0x10,%esp
  80197c:	85 c0                	test   %eax,%eax
  80197e:	78 1a                	js     80199a <fd_close+0x77>
		if (dev->dev_close)
  801980:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801983:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801986:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80198b:	85 c0                	test   %eax,%eax
  80198d:	74 0b                	je     80199a <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80198f:	83 ec 0c             	sub    $0xc,%esp
  801992:	56                   	push   %esi
  801993:	ff d0                	call   *%eax
  801995:	89 c3                	mov    %eax,%ebx
  801997:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80199a:	83 ec 08             	sub    $0x8,%esp
  80199d:	56                   	push   %esi
  80199e:	6a 00                	push   $0x0
  8019a0:	e8 ea fa ff ff       	call   80148f <sys_page_unmap>
	return r;
  8019a5:	83 c4 10             	add    $0x10,%esp
  8019a8:	eb b5                	jmp    80195f <fd_close+0x3c>

008019aa <close>:

int
close(int fdnum)
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
  8019ad:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019b0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019b3:	50                   	push   %eax
  8019b4:	ff 75 08             	pushl  0x8(%ebp)
  8019b7:	e8 bc fe ff ff       	call   801878 <fd_lookup>
  8019bc:	83 c4 10             	add    $0x10,%esp
  8019bf:	85 c0                	test   %eax,%eax
  8019c1:	79 02                	jns    8019c5 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8019c3:	c9                   	leave  
  8019c4:	c3                   	ret    
		return fd_close(fd, 1);
  8019c5:	83 ec 08             	sub    $0x8,%esp
  8019c8:	6a 01                	push   $0x1
  8019ca:	ff 75 f4             	pushl  -0xc(%ebp)
  8019cd:	e8 51 ff ff ff       	call   801923 <fd_close>
  8019d2:	83 c4 10             	add    $0x10,%esp
  8019d5:	eb ec                	jmp    8019c3 <close+0x19>

008019d7 <close_all>:

void
close_all(void)
{
  8019d7:	55                   	push   %ebp
  8019d8:	89 e5                	mov    %esp,%ebp
  8019da:	53                   	push   %ebx
  8019db:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8019de:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8019e3:	83 ec 0c             	sub    $0xc,%esp
  8019e6:	53                   	push   %ebx
  8019e7:	e8 be ff ff ff       	call   8019aa <close>
	for (i = 0; i < MAXFD; i++)
  8019ec:	83 c3 01             	add    $0x1,%ebx
  8019ef:	83 c4 10             	add    $0x10,%esp
  8019f2:	83 fb 20             	cmp    $0x20,%ebx
  8019f5:	75 ec                	jne    8019e3 <close_all+0xc>
}
  8019f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019fa:	c9                   	leave  
  8019fb:	c3                   	ret    

008019fc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8019fc:	55                   	push   %ebp
  8019fd:	89 e5                	mov    %esp,%ebp
  8019ff:	57                   	push   %edi
  801a00:	56                   	push   %esi
  801a01:	53                   	push   %ebx
  801a02:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801a05:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801a08:	50                   	push   %eax
  801a09:	ff 75 08             	pushl  0x8(%ebp)
  801a0c:	e8 67 fe ff ff       	call   801878 <fd_lookup>
  801a11:	89 c3                	mov    %eax,%ebx
  801a13:	83 c4 10             	add    $0x10,%esp
  801a16:	85 c0                	test   %eax,%eax
  801a18:	0f 88 81 00 00 00    	js     801a9f <dup+0xa3>
		return r;
	close(newfdnum);
  801a1e:	83 ec 0c             	sub    $0xc,%esp
  801a21:	ff 75 0c             	pushl  0xc(%ebp)
  801a24:	e8 81 ff ff ff       	call   8019aa <close>

	newfd = INDEX2FD(newfdnum);
  801a29:	8b 75 0c             	mov    0xc(%ebp),%esi
  801a2c:	c1 e6 0c             	shl    $0xc,%esi
  801a2f:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801a35:	83 c4 04             	add    $0x4,%esp
  801a38:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a3b:	e8 cf fd ff ff       	call   80180f <fd2data>
  801a40:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801a42:	89 34 24             	mov    %esi,(%esp)
  801a45:	e8 c5 fd ff ff       	call   80180f <fd2data>
  801a4a:	83 c4 10             	add    $0x10,%esp
  801a4d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801a4f:	89 d8                	mov    %ebx,%eax
  801a51:	c1 e8 16             	shr    $0x16,%eax
  801a54:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801a5b:	a8 01                	test   $0x1,%al
  801a5d:	74 11                	je     801a70 <dup+0x74>
  801a5f:	89 d8                	mov    %ebx,%eax
  801a61:	c1 e8 0c             	shr    $0xc,%eax
  801a64:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801a6b:	f6 c2 01             	test   $0x1,%dl
  801a6e:	75 39                	jne    801aa9 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801a70:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a73:	89 d0                	mov    %edx,%eax
  801a75:	c1 e8 0c             	shr    $0xc,%eax
  801a78:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a7f:	83 ec 0c             	sub    $0xc,%esp
  801a82:	25 07 0e 00 00       	and    $0xe07,%eax
  801a87:	50                   	push   %eax
  801a88:	56                   	push   %esi
  801a89:	6a 00                	push   $0x0
  801a8b:	52                   	push   %edx
  801a8c:	6a 00                	push   $0x0
  801a8e:	e8 ba f9 ff ff       	call   80144d <sys_page_map>
  801a93:	89 c3                	mov    %eax,%ebx
  801a95:	83 c4 20             	add    $0x20,%esp
  801a98:	85 c0                	test   %eax,%eax
  801a9a:	78 31                	js     801acd <dup+0xd1>
		goto err;

	return newfdnum;
  801a9c:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801a9f:	89 d8                	mov    %ebx,%eax
  801aa1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801aa4:	5b                   	pop    %ebx
  801aa5:	5e                   	pop    %esi
  801aa6:	5f                   	pop    %edi
  801aa7:	5d                   	pop    %ebp
  801aa8:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801aa9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801ab0:	83 ec 0c             	sub    $0xc,%esp
  801ab3:	25 07 0e 00 00       	and    $0xe07,%eax
  801ab8:	50                   	push   %eax
  801ab9:	57                   	push   %edi
  801aba:	6a 00                	push   $0x0
  801abc:	53                   	push   %ebx
  801abd:	6a 00                	push   $0x0
  801abf:	e8 89 f9 ff ff       	call   80144d <sys_page_map>
  801ac4:	89 c3                	mov    %eax,%ebx
  801ac6:	83 c4 20             	add    $0x20,%esp
  801ac9:	85 c0                	test   %eax,%eax
  801acb:	79 a3                	jns    801a70 <dup+0x74>
	sys_page_unmap(0, newfd);
  801acd:	83 ec 08             	sub    $0x8,%esp
  801ad0:	56                   	push   %esi
  801ad1:	6a 00                	push   $0x0
  801ad3:	e8 b7 f9 ff ff       	call   80148f <sys_page_unmap>
	sys_page_unmap(0, nva);
  801ad8:	83 c4 08             	add    $0x8,%esp
  801adb:	57                   	push   %edi
  801adc:	6a 00                	push   $0x0
  801ade:	e8 ac f9 ff ff       	call   80148f <sys_page_unmap>
	return r;
  801ae3:	83 c4 10             	add    $0x10,%esp
  801ae6:	eb b7                	jmp    801a9f <dup+0xa3>

00801ae8 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801ae8:	55                   	push   %ebp
  801ae9:	89 e5                	mov    %esp,%ebp
  801aeb:	53                   	push   %ebx
  801aec:	83 ec 1c             	sub    $0x1c,%esp
  801aef:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801af2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801af5:	50                   	push   %eax
  801af6:	53                   	push   %ebx
  801af7:	e8 7c fd ff ff       	call   801878 <fd_lookup>
  801afc:	83 c4 10             	add    $0x10,%esp
  801aff:	85 c0                	test   %eax,%eax
  801b01:	78 3f                	js     801b42 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b03:	83 ec 08             	sub    $0x8,%esp
  801b06:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b09:	50                   	push   %eax
  801b0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b0d:	ff 30                	pushl  (%eax)
  801b0f:	e8 b4 fd ff ff       	call   8018c8 <dev_lookup>
  801b14:	83 c4 10             	add    $0x10,%esp
  801b17:	85 c0                	test   %eax,%eax
  801b19:	78 27                	js     801b42 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801b1b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b1e:	8b 42 08             	mov    0x8(%edx),%eax
  801b21:	83 e0 03             	and    $0x3,%eax
  801b24:	83 f8 01             	cmp    $0x1,%eax
  801b27:	74 1e                	je     801b47 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b2c:	8b 40 08             	mov    0x8(%eax),%eax
  801b2f:	85 c0                	test   %eax,%eax
  801b31:	74 35                	je     801b68 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801b33:	83 ec 04             	sub    $0x4,%esp
  801b36:	ff 75 10             	pushl  0x10(%ebp)
  801b39:	ff 75 0c             	pushl  0xc(%ebp)
  801b3c:	52                   	push   %edx
  801b3d:	ff d0                	call   *%eax
  801b3f:	83 c4 10             	add    $0x10,%esp
}
  801b42:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b45:	c9                   	leave  
  801b46:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801b47:	a1 08 50 80 00       	mov    0x805008,%eax
  801b4c:	8b 40 48             	mov    0x48(%eax),%eax
  801b4f:	83 ec 04             	sub    $0x4,%esp
  801b52:	53                   	push   %ebx
  801b53:	50                   	push   %eax
  801b54:	68 78 34 80 00       	push   $0x803478
  801b59:	e8 5b ed ff ff       	call   8008b9 <cprintf>
		return -E_INVAL;
  801b5e:	83 c4 10             	add    $0x10,%esp
  801b61:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b66:	eb da                	jmp    801b42 <read+0x5a>
		return -E_NOT_SUPP;
  801b68:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b6d:	eb d3                	jmp    801b42 <read+0x5a>

00801b6f <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801b6f:	55                   	push   %ebp
  801b70:	89 e5                	mov    %esp,%ebp
  801b72:	57                   	push   %edi
  801b73:	56                   	push   %esi
  801b74:	53                   	push   %ebx
  801b75:	83 ec 0c             	sub    $0xc,%esp
  801b78:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b7b:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801b7e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b83:	39 f3                	cmp    %esi,%ebx
  801b85:	73 23                	jae    801baa <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801b87:	83 ec 04             	sub    $0x4,%esp
  801b8a:	89 f0                	mov    %esi,%eax
  801b8c:	29 d8                	sub    %ebx,%eax
  801b8e:	50                   	push   %eax
  801b8f:	89 d8                	mov    %ebx,%eax
  801b91:	03 45 0c             	add    0xc(%ebp),%eax
  801b94:	50                   	push   %eax
  801b95:	57                   	push   %edi
  801b96:	e8 4d ff ff ff       	call   801ae8 <read>
		if (m < 0)
  801b9b:	83 c4 10             	add    $0x10,%esp
  801b9e:	85 c0                	test   %eax,%eax
  801ba0:	78 06                	js     801ba8 <readn+0x39>
			return m;
		if (m == 0)
  801ba2:	74 06                	je     801baa <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801ba4:	01 c3                	add    %eax,%ebx
  801ba6:	eb db                	jmp    801b83 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801ba8:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801baa:	89 d8                	mov    %ebx,%eax
  801bac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801baf:	5b                   	pop    %ebx
  801bb0:	5e                   	pop    %esi
  801bb1:	5f                   	pop    %edi
  801bb2:	5d                   	pop    %ebp
  801bb3:	c3                   	ret    

00801bb4 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801bb4:	55                   	push   %ebp
  801bb5:	89 e5                	mov    %esp,%ebp
  801bb7:	53                   	push   %ebx
  801bb8:	83 ec 1c             	sub    $0x1c,%esp
  801bbb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801bbe:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bc1:	50                   	push   %eax
  801bc2:	53                   	push   %ebx
  801bc3:	e8 b0 fc ff ff       	call   801878 <fd_lookup>
  801bc8:	83 c4 10             	add    $0x10,%esp
  801bcb:	85 c0                	test   %eax,%eax
  801bcd:	78 3a                	js     801c09 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801bcf:	83 ec 08             	sub    $0x8,%esp
  801bd2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bd5:	50                   	push   %eax
  801bd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bd9:	ff 30                	pushl  (%eax)
  801bdb:	e8 e8 fc ff ff       	call   8018c8 <dev_lookup>
  801be0:	83 c4 10             	add    $0x10,%esp
  801be3:	85 c0                	test   %eax,%eax
  801be5:	78 22                	js     801c09 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801be7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bea:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801bee:	74 1e                	je     801c0e <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801bf0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bf3:	8b 52 0c             	mov    0xc(%edx),%edx
  801bf6:	85 d2                	test   %edx,%edx
  801bf8:	74 35                	je     801c2f <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801bfa:	83 ec 04             	sub    $0x4,%esp
  801bfd:	ff 75 10             	pushl  0x10(%ebp)
  801c00:	ff 75 0c             	pushl  0xc(%ebp)
  801c03:	50                   	push   %eax
  801c04:	ff d2                	call   *%edx
  801c06:	83 c4 10             	add    $0x10,%esp
}
  801c09:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c0c:	c9                   	leave  
  801c0d:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801c0e:	a1 08 50 80 00       	mov    0x805008,%eax
  801c13:	8b 40 48             	mov    0x48(%eax),%eax
  801c16:	83 ec 04             	sub    $0x4,%esp
  801c19:	53                   	push   %ebx
  801c1a:	50                   	push   %eax
  801c1b:	68 94 34 80 00       	push   $0x803494
  801c20:	e8 94 ec ff ff       	call   8008b9 <cprintf>
		return -E_INVAL;
  801c25:	83 c4 10             	add    $0x10,%esp
  801c28:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c2d:	eb da                	jmp    801c09 <write+0x55>
		return -E_NOT_SUPP;
  801c2f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c34:	eb d3                	jmp    801c09 <write+0x55>

00801c36 <seek>:

int
seek(int fdnum, off_t offset)
{
  801c36:	55                   	push   %ebp
  801c37:	89 e5                	mov    %esp,%ebp
  801c39:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c3c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c3f:	50                   	push   %eax
  801c40:	ff 75 08             	pushl  0x8(%ebp)
  801c43:	e8 30 fc ff ff       	call   801878 <fd_lookup>
  801c48:	83 c4 10             	add    $0x10,%esp
  801c4b:	85 c0                	test   %eax,%eax
  801c4d:	78 0e                	js     801c5d <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801c4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c55:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801c58:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c5d:	c9                   	leave  
  801c5e:	c3                   	ret    

00801c5f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801c5f:	55                   	push   %ebp
  801c60:	89 e5                	mov    %esp,%ebp
  801c62:	53                   	push   %ebx
  801c63:	83 ec 1c             	sub    $0x1c,%esp
  801c66:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c69:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c6c:	50                   	push   %eax
  801c6d:	53                   	push   %ebx
  801c6e:	e8 05 fc ff ff       	call   801878 <fd_lookup>
  801c73:	83 c4 10             	add    $0x10,%esp
  801c76:	85 c0                	test   %eax,%eax
  801c78:	78 37                	js     801cb1 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c7a:	83 ec 08             	sub    $0x8,%esp
  801c7d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c80:	50                   	push   %eax
  801c81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c84:	ff 30                	pushl  (%eax)
  801c86:	e8 3d fc ff ff       	call   8018c8 <dev_lookup>
  801c8b:	83 c4 10             	add    $0x10,%esp
  801c8e:	85 c0                	test   %eax,%eax
  801c90:	78 1f                	js     801cb1 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c95:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801c99:	74 1b                	je     801cb6 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801c9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c9e:	8b 52 18             	mov    0x18(%edx),%edx
  801ca1:	85 d2                	test   %edx,%edx
  801ca3:	74 32                	je     801cd7 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801ca5:	83 ec 08             	sub    $0x8,%esp
  801ca8:	ff 75 0c             	pushl  0xc(%ebp)
  801cab:	50                   	push   %eax
  801cac:	ff d2                	call   *%edx
  801cae:	83 c4 10             	add    $0x10,%esp
}
  801cb1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cb4:	c9                   	leave  
  801cb5:	c3                   	ret    
			thisenv->env_id, fdnum);
  801cb6:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801cbb:	8b 40 48             	mov    0x48(%eax),%eax
  801cbe:	83 ec 04             	sub    $0x4,%esp
  801cc1:	53                   	push   %ebx
  801cc2:	50                   	push   %eax
  801cc3:	68 54 34 80 00       	push   $0x803454
  801cc8:	e8 ec eb ff ff       	call   8008b9 <cprintf>
		return -E_INVAL;
  801ccd:	83 c4 10             	add    $0x10,%esp
  801cd0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801cd5:	eb da                	jmp    801cb1 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801cd7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801cdc:	eb d3                	jmp    801cb1 <ftruncate+0x52>

00801cde <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801cde:	55                   	push   %ebp
  801cdf:	89 e5                	mov    %esp,%ebp
  801ce1:	53                   	push   %ebx
  801ce2:	83 ec 1c             	sub    $0x1c,%esp
  801ce5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ce8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ceb:	50                   	push   %eax
  801cec:	ff 75 08             	pushl  0x8(%ebp)
  801cef:	e8 84 fb ff ff       	call   801878 <fd_lookup>
  801cf4:	83 c4 10             	add    $0x10,%esp
  801cf7:	85 c0                	test   %eax,%eax
  801cf9:	78 4b                	js     801d46 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801cfb:	83 ec 08             	sub    $0x8,%esp
  801cfe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d01:	50                   	push   %eax
  801d02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d05:	ff 30                	pushl  (%eax)
  801d07:	e8 bc fb ff ff       	call   8018c8 <dev_lookup>
  801d0c:	83 c4 10             	add    $0x10,%esp
  801d0f:	85 c0                	test   %eax,%eax
  801d11:	78 33                	js     801d46 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801d13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d16:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801d1a:	74 2f                	je     801d4b <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801d1c:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801d1f:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801d26:	00 00 00 
	stat->st_isdir = 0;
  801d29:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d30:	00 00 00 
	stat->st_dev = dev;
  801d33:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801d39:	83 ec 08             	sub    $0x8,%esp
  801d3c:	53                   	push   %ebx
  801d3d:	ff 75 f0             	pushl  -0x10(%ebp)
  801d40:	ff 50 14             	call   *0x14(%eax)
  801d43:	83 c4 10             	add    $0x10,%esp
}
  801d46:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d49:	c9                   	leave  
  801d4a:	c3                   	ret    
		return -E_NOT_SUPP;
  801d4b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d50:	eb f4                	jmp    801d46 <fstat+0x68>

00801d52 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801d52:	55                   	push   %ebp
  801d53:	89 e5                	mov    %esp,%ebp
  801d55:	56                   	push   %esi
  801d56:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801d57:	83 ec 08             	sub    $0x8,%esp
  801d5a:	6a 00                	push   $0x0
  801d5c:	ff 75 08             	pushl  0x8(%ebp)
  801d5f:	e8 22 02 00 00       	call   801f86 <open>
  801d64:	89 c3                	mov    %eax,%ebx
  801d66:	83 c4 10             	add    $0x10,%esp
  801d69:	85 c0                	test   %eax,%eax
  801d6b:	78 1b                	js     801d88 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801d6d:	83 ec 08             	sub    $0x8,%esp
  801d70:	ff 75 0c             	pushl  0xc(%ebp)
  801d73:	50                   	push   %eax
  801d74:	e8 65 ff ff ff       	call   801cde <fstat>
  801d79:	89 c6                	mov    %eax,%esi
	close(fd);
  801d7b:	89 1c 24             	mov    %ebx,(%esp)
  801d7e:	e8 27 fc ff ff       	call   8019aa <close>
	return r;
  801d83:	83 c4 10             	add    $0x10,%esp
  801d86:	89 f3                	mov    %esi,%ebx
}
  801d88:	89 d8                	mov    %ebx,%eax
  801d8a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d8d:	5b                   	pop    %ebx
  801d8e:	5e                   	pop    %esi
  801d8f:	5d                   	pop    %ebp
  801d90:	c3                   	ret    

00801d91 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801d91:	55                   	push   %ebp
  801d92:	89 e5                	mov    %esp,%ebp
  801d94:	56                   	push   %esi
  801d95:	53                   	push   %ebx
  801d96:	89 c6                	mov    %eax,%esi
  801d98:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801d9a:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801da1:	74 27                	je     801dca <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801da3:	6a 07                	push   $0x7
  801da5:	68 00 60 80 00       	push   $0x806000
  801daa:	56                   	push   %esi
  801dab:	ff 35 00 50 80 00    	pushl  0x805000
  801db1:	e8 b2 f9 ff ff       	call   801768 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801db6:	83 c4 0c             	add    $0xc,%esp
  801db9:	6a 00                	push   $0x0
  801dbb:	53                   	push   %ebx
  801dbc:	6a 00                	push   $0x0
  801dbe:	e8 3c f9 ff ff       	call   8016ff <ipc_recv>
}
  801dc3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dc6:	5b                   	pop    %ebx
  801dc7:	5e                   	pop    %esi
  801dc8:	5d                   	pop    %ebp
  801dc9:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801dca:	83 ec 0c             	sub    $0xc,%esp
  801dcd:	6a 01                	push   $0x1
  801dcf:	e8 ec f9 ff ff       	call   8017c0 <ipc_find_env>
  801dd4:	a3 00 50 80 00       	mov    %eax,0x805000
  801dd9:	83 c4 10             	add    $0x10,%esp
  801ddc:	eb c5                	jmp    801da3 <fsipc+0x12>

00801dde <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801dde:	55                   	push   %ebp
  801ddf:	89 e5                	mov    %esp,%ebp
  801de1:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801de4:	8b 45 08             	mov    0x8(%ebp),%eax
  801de7:	8b 40 0c             	mov    0xc(%eax),%eax
  801dea:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801def:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df2:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801df7:	ba 00 00 00 00       	mov    $0x0,%edx
  801dfc:	b8 02 00 00 00       	mov    $0x2,%eax
  801e01:	e8 8b ff ff ff       	call   801d91 <fsipc>
}
  801e06:	c9                   	leave  
  801e07:	c3                   	ret    

00801e08 <devfile_flush>:
{
  801e08:	55                   	push   %ebp
  801e09:	89 e5                	mov    %esp,%ebp
  801e0b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e11:	8b 40 0c             	mov    0xc(%eax),%eax
  801e14:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801e19:	ba 00 00 00 00       	mov    $0x0,%edx
  801e1e:	b8 06 00 00 00       	mov    $0x6,%eax
  801e23:	e8 69 ff ff ff       	call   801d91 <fsipc>
}
  801e28:	c9                   	leave  
  801e29:	c3                   	ret    

00801e2a <devfile_stat>:
{
  801e2a:	55                   	push   %ebp
  801e2b:	89 e5                	mov    %esp,%ebp
  801e2d:	53                   	push   %ebx
  801e2e:	83 ec 04             	sub    $0x4,%esp
  801e31:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801e34:	8b 45 08             	mov    0x8(%ebp),%eax
  801e37:	8b 40 0c             	mov    0xc(%eax),%eax
  801e3a:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801e3f:	ba 00 00 00 00       	mov    $0x0,%edx
  801e44:	b8 05 00 00 00       	mov    $0x5,%eax
  801e49:	e8 43 ff ff ff       	call   801d91 <fsipc>
  801e4e:	85 c0                	test   %eax,%eax
  801e50:	78 2c                	js     801e7e <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801e52:	83 ec 08             	sub    $0x8,%esp
  801e55:	68 00 60 80 00       	push   $0x806000
  801e5a:	53                   	push   %ebx
  801e5b:	e8 b8 f1 ff ff       	call   801018 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801e60:	a1 80 60 80 00       	mov    0x806080,%eax
  801e65:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801e6b:	a1 84 60 80 00       	mov    0x806084,%eax
  801e70:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801e76:	83 c4 10             	add    $0x10,%esp
  801e79:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e7e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e81:	c9                   	leave  
  801e82:	c3                   	ret    

00801e83 <devfile_write>:
{
  801e83:	55                   	push   %ebp
  801e84:	89 e5                	mov    %esp,%ebp
  801e86:	53                   	push   %ebx
  801e87:	83 ec 08             	sub    $0x8,%esp
  801e8a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e90:	8b 40 0c             	mov    0xc(%eax),%eax
  801e93:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801e98:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801e9e:	53                   	push   %ebx
  801e9f:	ff 75 0c             	pushl  0xc(%ebp)
  801ea2:	68 08 60 80 00       	push   $0x806008
  801ea7:	e8 5c f3 ff ff       	call   801208 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801eac:	ba 00 00 00 00       	mov    $0x0,%edx
  801eb1:	b8 04 00 00 00       	mov    $0x4,%eax
  801eb6:	e8 d6 fe ff ff       	call   801d91 <fsipc>
  801ebb:	83 c4 10             	add    $0x10,%esp
  801ebe:	85 c0                	test   %eax,%eax
  801ec0:	78 0b                	js     801ecd <devfile_write+0x4a>
	assert(r <= n);
  801ec2:	39 d8                	cmp    %ebx,%eax
  801ec4:	77 0c                	ja     801ed2 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801ec6:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ecb:	7f 1e                	jg     801eeb <devfile_write+0x68>
}
  801ecd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ed0:	c9                   	leave  
  801ed1:	c3                   	ret    
	assert(r <= n);
  801ed2:	68 c8 34 80 00       	push   $0x8034c8
  801ed7:	68 cf 34 80 00       	push   $0x8034cf
  801edc:	68 98 00 00 00       	push   $0x98
  801ee1:	68 e4 34 80 00       	push   $0x8034e4
  801ee6:	e8 d8 e8 ff ff       	call   8007c3 <_panic>
	assert(r <= PGSIZE);
  801eeb:	68 ef 34 80 00       	push   $0x8034ef
  801ef0:	68 cf 34 80 00       	push   $0x8034cf
  801ef5:	68 99 00 00 00       	push   $0x99
  801efa:	68 e4 34 80 00       	push   $0x8034e4
  801eff:	e8 bf e8 ff ff       	call   8007c3 <_panic>

00801f04 <devfile_read>:
{
  801f04:	55                   	push   %ebp
  801f05:	89 e5                	mov    %esp,%ebp
  801f07:	56                   	push   %esi
  801f08:	53                   	push   %ebx
  801f09:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0f:	8b 40 0c             	mov    0xc(%eax),%eax
  801f12:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801f17:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801f1d:	ba 00 00 00 00       	mov    $0x0,%edx
  801f22:	b8 03 00 00 00       	mov    $0x3,%eax
  801f27:	e8 65 fe ff ff       	call   801d91 <fsipc>
  801f2c:	89 c3                	mov    %eax,%ebx
  801f2e:	85 c0                	test   %eax,%eax
  801f30:	78 1f                	js     801f51 <devfile_read+0x4d>
	assert(r <= n);
  801f32:	39 f0                	cmp    %esi,%eax
  801f34:	77 24                	ja     801f5a <devfile_read+0x56>
	assert(r <= PGSIZE);
  801f36:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801f3b:	7f 33                	jg     801f70 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801f3d:	83 ec 04             	sub    $0x4,%esp
  801f40:	50                   	push   %eax
  801f41:	68 00 60 80 00       	push   $0x806000
  801f46:	ff 75 0c             	pushl  0xc(%ebp)
  801f49:	e8 58 f2 ff ff       	call   8011a6 <memmove>
	return r;
  801f4e:	83 c4 10             	add    $0x10,%esp
}
  801f51:	89 d8                	mov    %ebx,%eax
  801f53:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f56:	5b                   	pop    %ebx
  801f57:	5e                   	pop    %esi
  801f58:	5d                   	pop    %ebp
  801f59:	c3                   	ret    
	assert(r <= n);
  801f5a:	68 c8 34 80 00       	push   $0x8034c8
  801f5f:	68 cf 34 80 00       	push   $0x8034cf
  801f64:	6a 7c                	push   $0x7c
  801f66:	68 e4 34 80 00       	push   $0x8034e4
  801f6b:	e8 53 e8 ff ff       	call   8007c3 <_panic>
	assert(r <= PGSIZE);
  801f70:	68 ef 34 80 00       	push   $0x8034ef
  801f75:	68 cf 34 80 00       	push   $0x8034cf
  801f7a:	6a 7d                	push   $0x7d
  801f7c:	68 e4 34 80 00       	push   $0x8034e4
  801f81:	e8 3d e8 ff ff       	call   8007c3 <_panic>

00801f86 <open>:
{
  801f86:	55                   	push   %ebp
  801f87:	89 e5                	mov    %esp,%ebp
  801f89:	56                   	push   %esi
  801f8a:	53                   	push   %ebx
  801f8b:	83 ec 1c             	sub    $0x1c,%esp
  801f8e:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801f91:	56                   	push   %esi
  801f92:	e8 48 f0 ff ff       	call   800fdf <strlen>
  801f97:	83 c4 10             	add    $0x10,%esp
  801f9a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801f9f:	7f 6c                	jg     80200d <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801fa1:	83 ec 0c             	sub    $0xc,%esp
  801fa4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fa7:	50                   	push   %eax
  801fa8:	e8 79 f8 ff ff       	call   801826 <fd_alloc>
  801fad:	89 c3                	mov    %eax,%ebx
  801faf:	83 c4 10             	add    $0x10,%esp
  801fb2:	85 c0                	test   %eax,%eax
  801fb4:	78 3c                	js     801ff2 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801fb6:	83 ec 08             	sub    $0x8,%esp
  801fb9:	56                   	push   %esi
  801fba:	68 00 60 80 00       	push   $0x806000
  801fbf:	e8 54 f0 ff ff       	call   801018 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801fc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fc7:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801fcc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fcf:	b8 01 00 00 00       	mov    $0x1,%eax
  801fd4:	e8 b8 fd ff ff       	call   801d91 <fsipc>
  801fd9:	89 c3                	mov    %eax,%ebx
  801fdb:	83 c4 10             	add    $0x10,%esp
  801fde:	85 c0                	test   %eax,%eax
  801fe0:	78 19                	js     801ffb <open+0x75>
	return fd2num(fd);
  801fe2:	83 ec 0c             	sub    $0xc,%esp
  801fe5:	ff 75 f4             	pushl  -0xc(%ebp)
  801fe8:	e8 12 f8 ff ff       	call   8017ff <fd2num>
  801fed:	89 c3                	mov    %eax,%ebx
  801fef:	83 c4 10             	add    $0x10,%esp
}
  801ff2:	89 d8                	mov    %ebx,%eax
  801ff4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ff7:	5b                   	pop    %ebx
  801ff8:	5e                   	pop    %esi
  801ff9:	5d                   	pop    %ebp
  801ffa:	c3                   	ret    
		fd_close(fd, 0);
  801ffb:	83 ec 08             	sub    $0x8,%esp
  801ffe:	6a 00                	push   $0x0
  802000:	ff 75 f4             	pushl  -0xc(%ebp)
  802003:	e8 1b f9 ff ff       	call   801923 <fd_close>
		return r;
  802008:	83 c4 10             	add    $0x10,%esp
  80200b:	eb e5                	jmp    801ff2 <open+0x6c>
		return -E_BAD_PATH;
  80200d:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  802012:	eb de                	jmp    801ff2 <open+0x6c>

00802014 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  802014:	55                   	push   %ebp
  802015:	89 e5                	mov    %esp,%ebp
  802017:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80201a:	ba 00 00 00 00       	mov    $0x0,%edx
  80201f:	b8 08 00 00 00       	mov    $0x8,%eax
  802024:	e8 68 fd ff ff       	call   801d91 <fsipc>
}
  802029:	c9                   	leave  
  80202a:	c3                   	ret    

0080202b <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80202b:	55                   	push   %ebp
  80202c:	89 e5                	mov    %esp,%ebp
  80202e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  802031:	68 fb 34 80 00       	push   $0x8034fb
  802036:	ff 75 0c             	pushl  0xc(%ebp)
  802039:	e8 da ef ff ff       	call   801018 <strcpy>
	return 0;
}
  80203e:	b8 00 00 00 00       	mov    $0x0,%eax
  802043:	c9                   	leave  
  802044:	c3                   	ret    

00802045 <devsock_close>:
{
  802045:	55                   	push   %ebp
  802046:	89 e5                	mov    %esp,%ebp
  802048:	53                   	push   %ebx
  802049:	83 ec 10             	sub    $0x10,%esp
  80204c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80204f:	53                   	push   %ebx
  802050:	e8 00 09 00 00       	call   802955 <pageref>
  802055:	83 c4 10             	add    $0x10,%esp
		return 0;
  802058:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  80205d:	83 f8 01             	cmp    $0x1,%eax
  802060:	74 07                	je     802069 <devsock_close+0x24>
}
  802062:	89 d0                	mov    %edx,%eax
  802064:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802067:	c9                   	leave  
  802068:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  802069:	83 ec 0c             	sub    $0xc,%esp
  80206c:	ff 73 0c             	pushl  0xc(%ebx)
  80206f:	e8 b9 02 00 00       	call   80232d <nsipc_close>
  802074:	89 c2                	mov    %eax,%edx
  802076:	83 c4 10             	add    $0x10,%esp
  802079:	eb e7                	jmp    802062 <devsock_close+0x1d>

0080207b <devsock_write>:
{
  80207b:	55                   	push   %ebp
  80207c:	89 e5                	mov    %esp,%ebp
  80207e:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802081:	6a 00                	push   $0x0
  802083:	ff 75 10             	pushl  0x10(%ebp)
  802086:	ff 75 0c             	pushl  0xc(%ebp)
  802089:	8b 45 08             	mov    0x8(%ebp),%eax
  80208c:	ff 70 0c             	pushl  0xc(%eax)
  80208f:	e8 76 03 00 00       	call   80240a <nsipc_send>
}
  802094:	c9                   	leave  
  802095:	c3                   	ret    

00802096 <devsock_read>:
{
  802096:	55                   	push   %ebp
  802097:	89 e5                	mov    %esp,%ebp
  802099:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80209c:	6a 00                	push   $0x0
  80209e:	ff 75 10             	pushl  0x10(%ebp)
  8020a1:	ff 75 0c             	pushl  0xc(%ebp)
  8020a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a7:	ff 70 0c             	pushl  0xc(%eax)
  8020aa:	e8 ef 02 00 00       	call   80239e <nsipc_recv>
}
  8020af:	c9                   	leave  
  8020b0:	c3                   	ret    

008020b1 <fd2sockid>:
{
  8020b1:	55                   	push   %ebp
  8020b2:	89 e5                	mov    %esp,%ebp
  8020b4:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8020b7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8020ba:	52                   	push   %edx
  8020bb:	50                   	push   %eax
  8020bc:	e8 b7 f7 ff ff       	call   801878 <fd_lookup>
  8020c1:	83 c4 10             	add    $0x10,%esp
  8020c4:	85 c0                	test   %eax,%eax
  8020c6:	78 10                	js     8020d8 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8020c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020cb:	8b 0d 24 40 80 00    	mov    0x804024,%ecx
  8020d1:	39 08                	cmp    %ecx,(%eax)
  8020d3:	75 05                	jne    8020da <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8020d5:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8020d8:	c9                   	leave  
  8020d9:	c3                   	ret    
		return -E_NOT_SUPP;
  8020da:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8020df:	eb f7                	jmp    8020d8 <fd2sockid+0x27>

008020e1 <alloc_sockfd>:
{
  8020e1:	55                   	push   %ebp
  8020e2:	89 e5                	mov    %esp,%ebp
  8020e4:	56                   	push   %esi
  8020e5:	53                   	push   %ebx
  8020e6:	83 ec 1c             	sub    $0x1c,%esp
  8020e9:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8020eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020ee:	50                   	push   %eax
  8020ef:	e8 32 f7 ff ff       	call   801826 <fd_alloc>
  8020f4:	89 c3                	mov    %eax,%ebx
  8020f6:	83 c4 10             	add    $0x10,%esp
  8020f9:	85 c0                	test   %eax,%eax
  8020fb:	78 43                	js     802140 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8020fd:	83 ec 04             	sub    $0x4,%esp
  802100:	68 07 04 00 00       	push   $0x407
  802105:	ff 75 f4             	pushl  -0xc(%ebp)
  802108:	6a 00                	push   $0x0
  80210a:	e8 fb f2 ff ff       	call   80140a <sys_page_alloc>
  80210f:	89 c3                	mov    %eax,%ebx
  802111:	83 c4 10             	add    $0x10,%esp
  802114:	85 c0                	test   %eax,%eax
  802116:	78 28                	js     802140 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802118:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211b:	8b 15 24 40 80 00    	mov    0x804024,%edx
  802121:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802123:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802126:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80212d:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802130:	83 ec 0c             	sub    $0xc,%esp
  802133:	50                   	push   %eax
  802134:	e8 c6 f6 ff ff       	call   8017ff <fd2num>
  802139:	89 c3                	mov    %eax,%ebx
  80213b:	83 c4 10             	add    $0x10,%esp
  80213e:	eb 0c                	jmp    80214c <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  802140:	83 ec 0c             	sub    $0xc,%esp
  802143:	56                   	push   %esi
  802144:	e8 e4 01 00 00       	call   80232d <nsipc_close>
		return r;
  802149:	83 c4 10             	add    $0x10,%esp
}
  80214c:	89 d8                	mov    %ebx,%eax
  80214e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802151:	5b                   	pop    %ebx
  802152:	5e                   	pop    %esi
  802153:	5d                   	pop    %ebp
  802154:	c3                   	ret    

00802155 <accept>:
{
  802155:	55                   	push   %ebp
  802156:	89 e5                	mov    %esp,%ebp
  802158:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80215b:	8b 45 08             	mov    0x8(%ebp),%eax
  80215e:	e8 4e ff ff ff       	call   8020b1 <fd2sockid>
  802163:	85 c0                	test   %eax,%eax
  802165:	78 1b                	js     802182 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802167:	83 ec 04             	sub    $0x4,%esp
  80216a:	ff 75 10             	pushl  0x10(%ebp)
  80216d:	ff 75 0c             	pushl  0xc(%ebp)
  802170:	50                   	push   %eax
  802171:	e8 0e 01 00 00       	call   802284 <nsipc_accept>
  802176:	83 c4 10             	add    $0x10,%esp
  802179:	85 c0                	test   %eax,%eax
  80217b:	78 05                	js     802182 <accept+0x2d>
	return alloc_sockfd(r);
  80217d:	e8 5f ff ff ff       	call   8020e1 <alloc_sockfd>
}
  802182:	c9                   	leave  
  802183:	c3                   	ret    

00802184 <bind>:
{
  802184:	55                   	push   %ebp
  802185:	89 e5                	mov    %esp,%ebp
  802187:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80218a:	8b 45 08             	mov    0x8(%ebp),%eax
  80218d:	e8 1f ff ff ff       	call   8020b1 <fd2sockid>
  802192:	85 c0                	test   %eax,%eax
  802194:	78 12                	js     8021a8 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802196:	83 ec 04             	sub    $0x4,%esp
  802199:	ff 75 10             	pushl  0x10(%ebp)
  80219c:	ff 75 0c             	pushl  0xc(%ebp)
  80219f:	50                   	push   %eax
  8021a0:	e8 31 01 00 00       	call   8022d6 <nsipc_bind>
  8021a5:	83 c4 10             	add    $0x10,%esp
}
  8021a8:	c9                   	leave  
  8021a9:	c3                   	ret    

008021aa <shutdown>:
{
  8021aa:	55                   	push   %ebp
  8021ab:	89 e5                	mov    %esp,%ebp
  8021ad:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8021b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b3:	e8 f9 fe ff ff       	call   8020b1 <fd2sockid>
  8021b8:	85 c0                	test   %eax,%eax
  8021ba:	78 0f                	js     8021cb <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8021bc:	83 ec 08             	sub    $0x8,%esp
  8021bf:	ff 75 0c             	pushl  0xc(%ebp)
  8021c2:	50                   	push   %eax
  8021c3:	e8 43 01 00 00       	call   80230b <nsipc_shutdown>
  8021c8:	83 c4 10             	add    $0x10,%esp
}
  8021cb:	c9                   	leave  
  8021cc:	c3                   	ret    

008021cd <connect>:
{
  8021cd:	55                   	push   %ebp
  8021ce:	89 e5                	mov    %esp,%ebp
  8021d0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8021d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d6:	e8 d6 fe ff ff       	call   8020b1 <fd2sockid>
  8021db:	85 c0                	test   %eax,%eax
  8021dd:	78 12                	js     8021f1 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8021df:	83 ec 04             	sub    $0x4,%esp
  8021e2:	ff 75 10             	pushl  0x10(%ebp)
  8021e5:	ff 75 0c             	pushl  0xc(%ebp)
  8021e8:	50                   	push   %eax
  8021e9:	e8 59 01 00 00       	call   802347 <nsipc_connect>
  8021ee:	83 c4 10             	add    $0x10,%esp
}
  8021f1:	c9                   	leave  
  8021f2:	c3                   	ret    

008021f3 <listen>:
{
  8021f3:	55                   	push   %ebp
  8021f4:	89 e5                	mov    %esp,%ebp
  8021f6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8021f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fc:	e8 b0 fe ff ff       	call   8020b1 <fd2sockid>
  802201:	85 c0                	test   %eax,%eax
  802203:	78 0f                	js     802214 <listen+0x21>
	return nsipc_listen(r, backlog);
  802205:	83 ec 08             	sub    $0x8,%esp
  802208:	ff 75 0c             	pushl  0xc(%ebp)
  80220b:	50                   	push   %eax
  80220c:	e8 6b 01 00 00       	call   80237c <nsipc_listen>
  802211:	83 c4 10             	add    $0x10,%esp
}
  802214:	c9                   	leave  
  802215:	c3                   	ret    

00802216 <socket>:

int
socket(int domain, int type, int protocol)
{
  802216:	55                   	push   %ebp
  802217:	89 e5                	mov    %esp,%ebp
  802219:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80221c:	ff 75 10             	pushl  0x10(%ebp)
  80221f:	ff 75 0c             	pushl  0xc(%ebp)
  802222:	ff 75 08             	pushl  0x8(%ebp)
  802225:	e8 3e 02 00 00       	call   802468 <nsipc_socket>
  80222a:	83 c4 10             	add    $0x10,%esp
  80222d:	85 c0                	test   %eax,%eax
  80222f:	78 05                	js     802236 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802231:	e8 ab fe ff ff       	call   8020e1 <alloc_sockfd>
}
  802236:	c9                   	leave  
  802237:	c3                   	ret    

00802238 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802238:	55                   	push   %ebp
  802239:	89 e5                	mov    %esp,%ebp
  80223b:	53                   	push   %ebx
  80223c:	83 ec 04             	sub    $0x4,%esp
  80223f:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802241:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802248:	74 26                	je     802270 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80224a:	6a 07                	push   $0x7
  80224c:	68 00 70 80 00       	push   $0x807000
  802251:	53                   	push   %ebx
  802252:	ff 35 04 50 80 00    	pushl  0x805004
  802258:	e8 0b f5 ff ff       	call   801768 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80225d:	83 c4 0c             	add    $0xc,%esp
  802260:	6a 00                	push   $0x0
  802262:	6a 00                	push   $0x0
  802264:	6a 00                	push   $0x0
  802266:	e8 94 f4 ff ff       	call   8016ff <ipc_recv>
}
  80226b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80226e:	c9                   	leave  
  80226f:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802270:	83 ec 0c             	sub    $0xc,%esp
  802273:	6a 02                	push   $0x2
  802275:	e8 46 f5 ff ff       	call   8017c0 <ipc_find_env>
  80227a:	a3 04 50 80 00       	mov    %eax,0x805004
  80227f:	83 c4 10             	add    $0x10,%esp
  802282:	eb c6                	jmp    80224a <nsipc+0x12>

00802284 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802284:	55                   	push   %ebp
  802285:	89 e5                	mov    %esp,%ebp
  802287:	56                   	push   %esi
  802288:	53                   	push   %ebx
  802289:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80228c:	8b 45 08             	mov    0x8(%ebp),%eax
  80228f:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802294:	8b 06                	mov    (%esi),%eax
  802296:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80229b:	b8 01 00 00 00       	mov    $0x1,%eax
  8022a0:	e8 93 ff ff ff       	call   802238 <nsipc>
  8022a5:	89 c3                	mov    %eax,%ebx
  8022a7:	85 c0                	test   %eax,%eax
  8022a9:	79 09                	jns    8022b4 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8022ab:	89 d8                	mov    %ebx,%eax
  8022ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022b0:	5b                   	pop    %ebx
  8022b1:	5e                   	pop    %esi
  8022b2:	5d                   	pop    %ebp
  8022b3:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8022b4:	83 ec 04             	sub    $0x4,%esp
  8022b7:	ff 35 10 70 80 00    	pushl  0x807010
  8022bd:	68 00 70 80 00       	push   $0x807000
  8022c2:	ff 75 0c             	pushl  0xc(%ebp)
  8022c5:	e8 dc ee ff ff       	call   8011a6 <memmove>
		*addrlen = ret->ret_addrlen;
  8022ca:	a1 10 70 80 00       	mov    0x807010,%eax
  8022cf:	89 06                	mov    %eax,(%esi)
  8022d1:	83 c4 10             	add    $0x10,%esp
	return r;
  8022d4:	eb d5                	jmp    8022ab <nsipc_accept+0x27>

008022d6 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8022d6:	55                   	push   %ebp
  8022d7:	89 e5                	mov    %esp,%ebp
  8022d9:	53                   	push   %ebx
  8022da:	83 ec 08             	sub    $0x8,%esp
  8022dd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8022e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e3:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8022e8:	53                   	push   %ebx
  8022e9:	ff 75 0c             	pushl  0xc(%ebp)
  8022ec:	68 04 70 80 00       	push   $0x807004
  8022f1:	e8 b0 ee ff ff       	call   8011a6 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8022f6:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8022fc:	b8 02 00 00 00       	mov    $0x2,%eax
  802301:	e8 32 ff ff ff       	call   802238 <nsipc>
}
  802306:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802309:	c9                   	leave  
  80230a:	c3                   	ret    

0080230b <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80230b:	55                   	push   %ebp
  80230c:	89 e5                	mov    %esp,%ebp
  80230e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802311:	8b 45 08             	mov    0x8(%ebp),%eax
  802314:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802319:	8b 45 0c             	mov    0xc(%ebp),%eax
  80231c:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802321:	b8 03 00 00 00       	mov    $0x3,%eax
  802326:	e8 0d ff ff ff       	call   802238 <nsipc>
}
  80232b:	c9                   	leave  
  80232c:	c3                   	ret    

0080232d <nsipc_close>:

int
nsipc_close(int s)
{
  80232d:	55                   	push   %ebp
  80232e:	89 e5                	mov    %esp,%ebp
  802330:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802333:	8b 45 08             	mov    0x8(%ebp),%eax
  802336:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80233b:	b8 04 00 00 00       	mov    $0x4,%eax
  802340:	e8 f3 fe ff ff       	call   802238 <nsipc>
}
  802345:	c9                   	leave  
  802346:	c3                   	ret    

00802347 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802347:	55                   	push   %ebp
  802348:	89 e5                	mov    %esp,%ebp
  80234a:	53                   	push   %ebx
  80234b:	83 ec 08             	sub    $0x8,%esp
  80234e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802351:	8b 45 08             	mov    0x8(%ebp),%eax
  802354:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802359:	53                   	push   %ebx
  80235a:	ff 75 0c             	pushl  0xc(%ebp)
  80235d:	68 04 70 80 00       	push   $0x807004
  802362:	e8 3f ee ff ff       	call   8011a6 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802367:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  80236d:	b8 05 00 00 00       	mov    $0x5,%eax
  802372:	e8 c1 fe ff ff       	call   802238 <nsipc>
}
  802377:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80237a:	c9                   	leave  
  80237b:	c3                   	ret    

0080237c <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80237c:	55                   	push   %ebp
  80237d:	89 e5                	mov    %esp,%ebp
  80237f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802382:	8b 45 08             	mov    0x8(%ebp),%eax
  802385:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  80238a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80238d:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802392:	b8 06 00 00 00       	mov    $0x6,%eax
  802397:	e8 9c fe ff ff       	call   802238 <nsipc>
}
  80239c:	c9                   	leave  
  80239d:	c3                   	ret    

0080239e <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80239e:	55                   	push   %ebp
  80239f:	89 e5                	mov    %esp,%ebp
  8023a1:	56                   	push   %esi
  8023a2:	53                   	push   %ebx
  8023a3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8023a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a9:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8023ae:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8023b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8023b7:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8023bc:	b8 07 00 00 00       	mov    $0x7,%eax
  8023c1:	e8 72 fe ff ff       	call   802238 <nsipc>
  8023c6:	89 c3                	mov    %eax,%ebx
  8023c8:	85 c0                	test   %eax,%eax
  8023ca:	78 1f                	js     8023eb <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8023cc:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8023d1:	7f 21                	jg     8023f4 <nsipc_recv+0x56>
  8023d3:	39 c6                	cmp    %eax,%esi
  8023d5:	7c 1d                	jl     8023f4 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8023d7:	83 ec 04             	sub    $0x4,%esp
  8023da:	50                   	push   %eax
  8023db:	68 00 70 80 00       	push   $0x807000
  8023e0:	ff 75 0c             	pushl  0xc(%ebp)
  8023e3:	e8 be ed ff ff       	call   8011a6 <memmove>
  8023e8:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8023eb:	89 d8                	mov    %ebx,%eax
  8023ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023f0:	5b                   	pop    %ebx
  8023f1:	5e                   	pop    %esi
  8023f2:	5d                   	pop    %ebp
  8023f3:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8023f4:	68 07 35 80 00       	push   $0x803507
  8023f9:	68 cf 34 80 00       	push   $0x8034cf
  8023fe:	6a 62                	push   $0x62
  802400:	68 1c 35 80 00       	push   $0x80351c
  802405:	e8 b9 e3 ff ff       	call   8007c3 <_panic>

0080240a <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80240a:	55                   	push   %ebp
  80240b:	89 e5                	mov    %esp,%ebp
  80240d:	53                   	push   %ebx
  80240e:	83 ec 04             	sub    $0x4,%esp
  802411:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802414:	8b 45 08             	mov    0x8(%ebp),%eax
  802417:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80241c:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802422:	7f 2e                	jg     802452 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802424:	83 ec 04             	sub    $0x4,%esp
  802427:	53                   	push   %ebx
  802428:	ff 75 0c             	pushl  0xc(%ebp)
  80242b:	68 0c 70 80 00       	push   $0x80700c
  802430:	e8 71 ed ff ff       	call   8011a6 <memmove>
	nsipcbuf.send.req_size = size;
  802435:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  80243b:	8b 45 14             	mov    0x14(%ebp),%eax
  80243e:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802443:	b8 08 00 00 00       	mov    $0x8,%eax
  802448:	e8 eb fd ff ff       	call   802238 <nsipc>
}
  80244d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802450:	c9                   	leave  
  802451:	c3                   	ret    
	assert(size < 1600);
  802452:	68 28 35 80 00       	push   $0x803528
  802457:	68 cf 34 80 00       	push   $0x8034cf
  80245c:	6a 6d                	push   $0x6d
  80245e:	68 1c 35 80 00       	push   $0x80351c
  802463:	e8 5b e3 ff ff       	call   8007c3 <_panic>

00802468 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802468:	55                   	push   %ebp
  802469:	89 e5                	mov    %esp,%ebp
  80246b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80246e:	8b 45 08             	mov    0x8(%ebp),%eax
  802471:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802476:	8b 45 0c             	mov    0xc(%ebp),%eax
  802479:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  80247e:	8b 45 10             	mov    0x10(%ebp),%eax
  802481:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802486:	b8 09 00 00 00       	mov    $0x9,%eax
  80248b:	e8 a8 fd ff ff       	call   802238 <nsipc>
}
  802490:	c9                   	leave  
  802491:	c3                   	ret    

00802492 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802492:	55                   	push   %ebp
  802493:	89 e5                	mov    %esp,%ebp
  802495:	56                   	push   %esi
  802496:	53                   	push   %ebx
  802497:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80249a:	83 ec 0c             	sub    $0xc,%esp
  80249d:	ff 75 08             	pushl  0x8(%ebp)
  8024a0:	e8 6a f3 ff ff       	call   80180f <fd2data>
  8024a5:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8024a7:	83 c4 08             	add    $0x8,%esp
  8024aa:	68 34 35 80 00       	push   $0x803534
  8024af:	53                   	push   %ebx
  8024b0:	e8 63 eb ff ff       	call   801018 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8024b5:	8b 46 04             	mov    0x4(%esi),%eax
  8024b8:	2b 06                	sub    (%esi),%eax
  8024ba:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8024c0:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8024c7:	00 00 00 
	stat->st_dev = &devpipe;
  8024ca:	c7 83 88 00 00 00 40 	movl   $0x804040,0x88(%ebx)
  8024d1:	40 80 00 
	return 0;
}
  8024d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024dc:	5b                   	pop    %ebx
  8024dd:	5e                   	pop    %esi
  8024de:	5d                   	pop    %ebp
  8024df:	c3                   	ret    

008024e0 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8024e0:	55                   	push   %ebp
  8024e1:	89 e5                	mov    %esp,%ebp
  8024e3:	53                   	push   %ebx
  8024e4:	83 ec 0c             	sub    $0xc,%esp
  8024e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8024ea:	53                   	push   %ebx
  8024eb:	6a 00                	push   $0x0
  8024ed:	e8 9d ef ff ff       	call   80148f <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8024f2:	89 1c 24             	mov    %ebx,(%esp)
  8024f5:	e8 15 f3 ff ff       	call   80180f <fd2data>
  8024fa:	83 c4 08             	add    $0x8,%esp
  8024fd:	50                   	push   %eax
  8024fe:	6a 00                	push   $0x0
  802500:	e8 8a ef ff ff       	call   80148f <sys_page_unmap>
}
  802505:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802508:	c9                   	leave  
  802509:	c3                   	ret    

0080250a <_pipeisclosed>:
{
  80250a:	55                   	push   %ebp
  80250b:	89 e5                	mov    %esp,%ebp
  80250d:	57                   	push   %edi
  80250e:	56                   	push   %esi
  80250f:	53                   	push   %ebx
  802510:	83 ec 1c             	sub    $0x1c,%esp
  802513:	89 c7                	mov    %eax,%edi
  802515:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802517:	a1 08 50 80 00       	mov    0x805008,%eax
  80251c:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80251f:	83 ec 0c             	sub    $0xc,%esp
  802522:	57                   	push   %edi
  802523:	e8 2d 04 00 00       	call   802955 <pageref>
  802528:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80252b:	89 34 24             	mov    %esi,(%esp)
  80252e:	e8 22 04 00 00       	call   802955 <pageref>
		nn = thisenv->env_runs;
  802533:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802539:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80253c:	83 c4 10             	add    $0x10,%esp
  80253f:	39 cb                	cmp    %ecx,%ebx
  802541:	74 1b                	je     80255e <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802543:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802546:	75 cf                	jne    802517 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802548:	8b 42 58             	mov    0x58(%edx),%eax
  80254b:	6a 01                	push   $0x1
  80254d:	50                   	push   %eax
  80254e:	53                   	push   %ebx
  80254f:	68 3b 35 80 00       	push   $0x80353b
  802554:	e8 60 e3 ff ff       	call   8008b9 <cprintf>
  802559:	83 c4 10             	add    $0x10,%esp
  80255c:	eb b9                	jmp    802517 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80255e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802561:	0f 94 c0             	sete   %al
  802564:	0f b6 c0             	movzbl %al,%eax
}
  802567:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80256a:	5b                   	pop    %ebx
  80256b:	5e                   	pop    %esi
  80256c:	5f                   	pop    %edi
  80256d:	5d                   	pop    %ebp
  80256e:	c3                   	ret    

0080256f <devpipe_write>:
{
  80256f:	55                   	push   %ebp
  802570:	89 e5                	mov    %esp,%ebp
  802572:	57                   	push   %edi
  802573:	56                   	push   %esi
  802574:	53                   	push   %ebx
  802575:	83 ec 28             	sub    $0x28,%esp
  802578:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80257b:	56                   	push   %esi
  80257c:	e8 8e f2 ff ff       	call   80180f <fd2data>
  802581:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802583:	83 c4 10             	add    $0x10,%esp
  802586:	bf 00 00 00 00       	mov    $0x0,%edi
  80258b:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80258e:	74 4f                	je     8025df <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802590:	8b 43 04             	mov    0x4(%ebx),%eax
  802593:	8b 0b                	mov    (%ebx),%ecx
  802595:	8d 51 20             	lea    0x20(%ecx),%edx
  802598:	39 d0                	cmp    %edx,%eax
  80259a:	72 14                	jb     8025b0 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80259c:	89 da                	mov    %ebx,%edx
  80259e:	89 f0                	mov    %esi,%eax
  8025a0:	e8 65 ff ff ff       	call   80250a <_pipeisclosed>
  8025a5:	85 c0                	test   %eax,%eax
  8025a7:	75 3b                	jne    8025e4 <devpipe_write+0x75>
			sys_yield();
  8025a9:	e8 3d ee ff ff       	call   8013eb <sys_yield>
  8025ae:	eb e0                	jmp    802590 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8025b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8025b3:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8025b7:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8025ba:	89 c2                	mov    %eax,%edx
  8025bc:	c1 fa 1f             	sar    $0x1f,%edx
  8025bf:	89 d1                	mov    %edx,%ecx
  8025c1:	c1 e9 1b             	shr    $0x1b,%ecx
  8025c4:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8025c7:	83 e2 1f             	and    $0x1f,%edx
  8025ca:	29 ca                	sub    %ecx,%edx
  8025cc:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8025d0:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8025d4:	83 c0 01             	add    $0x1,%eax
  8025d7:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8025da:	83 c7 01             	add    $0x1,%edi
  8025dd:	eb ac                	jmp    80258b <devpipe_write+0x1c>
	return i;
  8025df:	8b 45 10             	mov    0x10(%ebp),%eax
  8025e2:	eb 05                	jmp    8025e9 <devpipe_write+0x7a>
				return 0;
  8025e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025ec:	5b                   	pop    %ebx
  8025ed:	5e                   	pop    %esi
  8025ee:	5f                   	pop    %edi
  8025ef:	5d                   	pop    %ebp
  8025f0:	c3                   	ret    

008025f1 <devpipe_read>:
{
  8025f1:	55                   	push   %ebp
  8025f2:	89 e5                	mov    %esp,%ebp
  8025f4:	57                   	push   %edi
  8025f5:	56                   	push   %esi
  8025f6:	53                   	push   %ebx
  8025f7:	83 ec 18             	sub    $0x18,%esp
  8025fa:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8025fd:	57                   	push   %edi
  8025fe:	e8 0c f2 ff ff       	call   80180f <fd2data>
  802603:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802605:	83 c4 10             	add    $0x10,%esp
  802608:	be 00 00 00 00       	mov    $0x0,%esi
  80260d:	3b 75 10             	cmp    0x10(%ebp),%esi
  802610:	75 14                	jne    802626 <devpipe_read+0x35>
	return i;
  802612:	8b 45 10             	mov    0x10(%ebp),%eax
  802615:	eb 02                	jmp    802619 <devpipe_read+0x28>
				return i;
  802617:	89 f0                	mov    %esi,%eax
}
  802619:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80261c:	5b                   	pop    %ebx
  80261d:	5e                   	pop    %esi
  80261e:	5f                   	pop    %edi
  80261f:	5d                   	pop    %ebp
  802620:	c3                   	ret    
			sys_yield();
  802621:	e8 c5 ed ff ff       	call   8013eb <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802626:	8b 03                	mov    (%ebx),%eax
  802628:	3b 43 04             	cmp    0x4(%ebx),%eax
  80262b:	75 18                	jne    802645 <devpipe_read+0x54>
			if (i > 0)
  80262d:	85 f6                	test   %esi,%esi
  80262f:	75 e6                	jne    802617 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802631:	89 da                	mov    %ebx,%edx
  802633:	89 f8                	mov    %edi,%eax
  802635:	e8 d0 fe ff ff       	call   80250a <_pipeisclosed>
  80263a:	85 c0                	test   %eax,%eax
  80263c:	74 e3                	je     802621 <devpipe_read+0x30>
				return 0;
  80263e:	b8 00 00 00 00       	mov    $0x0,%eax
  802643:	eb d4                	jmp    802619 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802645:	99                   	cltd   
  802646:	c1 ea 1b             	shr    $0x1b,%edx
  802649:	01 d0                	add    %edx,%eax
  80264b:	83 e0 1f             	and    $0x1f,%eax
  80264e:	29 d0                	sub    %edx,%eax
  802650:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802655:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802658:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80265b:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80265e:	83 c6 01             	add    $0x1,%esi
  802661:	eb aa                	jmp    80260d <devpipe_read+0x1c>

00802663 <pipe>:
{
  802663:	55                   	push   %ebp
  802664:	89 e5                	mov    %esp,%ebp
  802666:	56                   	push   %esi
  802667:	53                   	push   %ebx
  802668:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80266b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80266e:	50                   	push   %eax
  80266f:	e8 b2 f1 ff ff       	call   801826 <fd_alloc>
  802674:	89 c3                	mov    %eax,%ebx
  802676:	83 c4 10             	add    $0x10,%esp
  802679:	85 c0                	test   %eax,%eax
  80267b:	0f 88 23 01 00 00    	js     8027a4 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802681:	83 ec 04             	sub    $0x4,%esp
  802684:	68 07 04 00 00       	push   $0x407
  802689:	ff 75 f4             	pushl  -0xc(%ebp)
  80268c:	6a 00                	push   $0x0
  80268e:	e8 77 ed ff ff       	call   80140a <sys_page_alloc>
  802693:	89 c3                	mov    %eax,%ebx
  802695:	83 c4 10             	add    $0x10,%esp
  802698:	85 c0                	test   %eax,%eax
  80269a:	0f 88 04 01 00 00    	js     8027a4 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8026a0:	83 ec 0c             	sub    $0xc,%esp
  8026a3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8026a6:	50                   	push   %eax
  8026a7:	e8 7a f1 ff ff       	call   801826 <fd_alloc>
  8026ac:	89 c3                	mov    %eax,%ebx
  8026ae:	83 c4 10             	add    $0x10,%esp
  8026b1:	85 c0                	test   %eax,%eax
  8026b3:	0f 88 db 00 00 00    	js     802794 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026b9:	83 ec 04             	sub    $0x4,%esp
  8026bc:	68 07 04 00 00       	push   $0x407
  8026c1:	ff 75 f0             	pushl  -0x10(%ebp)
  8026c4:	6a 00                	push   $0x0
  8026c6:	e8 3f ed ff ff       	call   80140a <sys_page_alloc>
  8026cb:	89 c3                	mov    %eax,%ebx
  8026cd:	83 c4 10             	add    $0x10,%esp
  8026d0:	85 c0                	test   %eax,%eax
  8026d2:	0f 88 bc 00 00 00    	js     802794 <pipe+0x131>
	va = fd2data(fd0);
  8026d8:	83 ec 0c             	sub    $0xc,%esp
  8026db:	ff 75 f4             	pushl  -0xc(%ebp)
  8026de:	e8 2c f1 ff ff       	call   80180f <fd2data>
  8026e3:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026e5:	83 c4 0c             	add    $0xc,%esp
  8026e8:	68 07 04 00 00       	push   $0x407
  8026ed:	50                   	push   %eax
  8026ee:	6a 00                	push   $0x0
  8026f0:	e8 15 ed ff ff       	call   80140a <sys_page_alloc>
  8026f5:	89 c3                	mov    %eax,%ebx
  8026f7:	83 c4 10             	add    $0x10,%esp
  8026fa:	85 c0                	test   %eax,%eax
  8026fc:	0f 88 82 00 00 00    	js     802784 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802702:	83 ec 0c             	sub    $0xc,%esp
  802705:	ff 75 f0             	pushl  -0x10(%ebp)
  802708:	e8 02 f1 ff ff       	call   80180f <fd2data>
  80270d:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802714:	50                   	push   %eax
  802715:	6a 00                	push   $0x0
  802717:	56                   	push   %esi
  802718:	6a 00                	push   $0x0
  80271a:	e8 2e ed ff ff       	call   80144d <sys_page_map>
  80271f:	89 c3                	mov    %eax,%ebx
  802721:	83 c4 20             	add    $0x20,%esp
  802724:	85 c0                	test   %eax,%eax
  802726:	78 4e                	js     802776 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802728:	a1 40 40 80 00       	mov    0x804040,%eax
  80272d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802730:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802732:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802735:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80273c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80273f:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802741:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802744:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80274b:	83 ec 0c             	sub    $0xc,%esp
  80274e:	ff 75 f4             	pushl  -0xc(%ebp)
  802751:	e8 a9 f0 ff ff       	call   8017ff <fd2num>
  802756:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802759:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80275b:	83 c4 04             	add    $0x4,%esp
  80275e:	ff 75 f0             	pushl  -0x10(%ebp)
  802761:	e8 99 f0 ff ff       	call   8017ff <fd2num>
  802766:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802769:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80276c:	83 c4 10             	add    $0x10,%esp
  80276f:	bb 00 00 00 00       	mov    $0x0,%ebx
  802774:	eb 2e                	jmp    8027a4 <pipe+0x141>
	sys_page_unmap(0, va);
  802776:	83 ec 08             	sub    $0x8,%esp
  802779:	56                   	push   %esi
  80277a:	6a 00                	push   $0x0
  80277c:	e8 0e ed ff ff       	call   80148f <sys_page_unmap>
  802781:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802784:	83 ec 08             	sub    $0x8,%esp
  802787:	ff 75 f0             	pushl  -0x10(%ebp)
  80278a:	6a 00                	push   $0x0
  80278c:	e8 fe ec ff ff       	call   80148f <sys_page_unmap>
  802791:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802794:	83 ec 08             	sub    $0x8,%esp
  802797:	ff 75 f4             	pushl  -0xc(%ebp)
  80279a:	6a 00                	push   $0x0
  80279c:	e8 ee ec ff ff       	call   80148f <sys_page_unmap>
  8027a1:	83 c4 10             	add    $0x10,%esp
}
  8027a4:	89 d8                	mov    %ebx,%eax
  8027a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8027a9:	5b                   	pop    %ebx
  8027aa:	5e                   	pop    %esi
  8027ab:	5d                   	pop    %ebp
  8027ac:	c3                   	ret    

008027ad <pipeisclosed>:
{
  8027ad:	55                   	push   %ebp
  8027ae:	89 e5                	mov    %esp,%ebp
  8027b0:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027b3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027b6:	50                   	push   %eax
  8027b7:	ff 75 08             	pushl  0x8(%ebp)
  8027ba:	e8 b9 f0 ff ff       	call   801878 <fd_lookup>
  8027bf:	83 c4 10             	add    $0x10,%esp
  8027c2:	85 c0                	test   %eax,%eax
  8027c4:	78 18                	js     8027de <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8027c6:	83 ec 0c             	sub    $0xc,%esp
  8027c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8027cc:	e8 3e f0 ff ff       	call   80180f <fd2data>
	return _pipeisclosed(fd, p);
  8027d1:	89 c2                	mov    %eax,%edx
  8027d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d6:	e8 2f fd ff ff       	call   80250a <_pipeisclosed>
  8027db:	83 c4 10             	add    $0x10,%esp
}
  8027de:	c9                   	leave  
  8027df:	c3                   	ret    

008027e0 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8027e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8027e5:	c3                   	ret    

008027e6 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8027e6:	55                   	push   %ebp
  8027e7:	89 e5                	mov    %esp,%ebp
  8027e9:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8027ec:	68 53 35 80 00       	push   $0x803553
  8027f1:	ff 75 0c             	pushl  0xc(%ebp)
  8027f4:	e8 1f e8 ff ff       	call   801018 <strcpy>
	return 0;
}
  8027f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8027fe:	c9                   	leave  
  8027ff:	c3                   	ret    

00802800 <devcons_write>:
{
  802800:	55                   	push   %ebp
  802801:	89 e5                	mov    %esp,%ebp
  802803:	57                   	push   %edi
  802804:	56                   	push   %esi
  802805:	53                   	push   %ebx
  802806:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80280c:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802811:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802817:	3b 75 10             	cmp    0x10(%ebp),%esi
  80281a:	73 31                	jae    80284d <devcons_write+0x4d>
		m = n - tot;
  80281c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80281f:	29 f3                	sub    %esi,%ebx
  802821:	83 fb 7f             	cmp    $0x7f,%ebx
  802824:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802829:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80282c:	83 ec 04             	sub    $0x4,%esp
  80282f:	53                   	push   %ebx
  802830:	89 f0                	mov    %esi,%eax
  802832:	03 45 0c             	add    0xc(%ebp),%eax
  802835:	50                   	push   %eax
  802836:	57                   	push   %edi
  802837:	e8 6a e9 ff ff       	call   8011a6 <memmove>
		sys_cputs(buf, m);
  80283c:	83 c4 08             	add    $0x8,%esp
  80283f:	53                   	push   %ebx
  802840:	57                   	push   %edi
  802841:	e8 08 eb ff ff       	call   80134e <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802846:	01 de                	add    %ebx,%esi
  802848:	83 c4 10             	add    $0x10,%esp
  80284b:	eb ca                	jmp    802817 <devcons_write+0x17>
}
  80284d:	89 f0                	mov    %esi,%eax
  80284f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802852:	5b                   	pop    %ebx
  802853:	5e                   	pop    %esi
  802854:	5f                   	pop    %edi
  802855:	5d                   	pop    %ebp
  802856:	c3                   	ret    

00802857 <devcons_read>:
{
  802857:	55                   	push   %ebp
  802858:	89 e5                	mov    %esp,%ebp
  80285a:	83 ec 08             	sub    $0x8,%esp
  80285d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802862:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802866:	74 21                	je     802889 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802868:	e8 ff ea ff ff       	call   80136c <sys_cgetc>
  80286d:	85 c0                	test   %eax,%eax
  80286f:	75 07                	jne    802878 <devcons_read+0x21>
		sys_yield();
  802871:	e8 75 eb ff ff       	call   8013eb <sys_yield>
  802876:	eb f0                	jmp    802868 <devcons_read+0x11>
	if (c < 0)
  802878:	78 0f                	js     802889 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80287a:	83 f8 04             	cmp    $0x4,%eax
  80287d:	74 0c                	je     80288b <devcons_read+0x34>
	*(char*)vbuf = c;
  80287f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802882:	88 02                	mov    %al,(%edx)
	return 1;
  802884:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802889:	c9                   	leave  
  80288a:	c3                   	ret    
		return 0;
  80288b:	b8 00 00 00 00       	mov    $0x0,%eax
  802890:	eb f7                	jmp    802889 <devcons_read+0x32>

00802892 <cputchar>:
{
  802892:	55                   	push   %ebp
  802893:	89 e5                	mov    %esp,%ebp
  802895:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802898:	8b 45 08             	mov    0x8(%ebp),%eax
  80289b:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80289e:	6a 01                	push   $0x1
  8028a0:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8028a3:	50                   	push   %eax
  8028a4:	e8 a5 ea ff ff       	call   80134e <sys_cputs>
}
  8028a9:	83 c4 10             	add    $0x10,%esp
  8028ac:	c9                   	leave  
  8028ad:	c3                   	ret    

008028ae <getchar>:
{
  8028ae:	55                   	push   %ebp
  8028af:	89 e5                	mov    %esp,%ebp
  8028b1:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8028b4:	6a 01                	push   $0x1
  8028b6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8028b9:	50                   	push   %eax
  8028ba:	6a 00                	push   $0x0
  8028bc:	e8 27 f2 ff ff       	call   801ae8 <read>
	if (r < 0)
  8028c1:	83 c4 10             	add    $0x10,%esp
  8028c4:	85 c0                	test   %eax,%eax
  8028c6:	78 06                	js     8028ce <getchar+0x20>
	if (r < 1)
  8028c8:	74 06                	je     8028d0 <getchar+0x22>
	return c;
  8028ca:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8028ce:	c9                   	leave  
  8028cf:	c3                   	ret    
		return -E_EOF;
  8028d0:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8028d5:	eb f7                	jmp    8028ce <getchar+0x20>

008028d7 <iscons>:
{
  8028d7:	55                   	push   %ebp
  8028d8:	89 e5                	mov    %esp,%ebp
  8028da:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8028dd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028e0:	50                   	push   %eax
  8028e1:	ff 75 08             	pushl  0x8(%ebp)
  8028e4:	e8 8f ef ff ff       	call   801878 <fd_lookup>
  8028e9:	83 c4 10             	add    $0x10,%esp
  8028ec:	85 c0                	test   %eax,%eax
  8028ee:	78 11                	js     802901 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8028f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f3:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  8028f9:	39 10                	cmp    %edx,(%eax)
  8028fb:	0f 94 c0             	sete   %al
  8028fe:	0f b6 c0             	movzbl %al,%eax
}
  802901:	c9                   	leave  
  802902:	c3                   	ret    

00802903 <opencons>:
{
  802903:	55                   	push   %ebp
  802904:	89 e5                	mov    %esp,%ebp
  802906:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802909:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80290c:	50                   	push   %eax
  80290d:	e8 14 ef ff ff       	call   801826 <fd_alloc>
  802912:	83 c4 10             	add    $0x10,%esp
  802915:	85 c0                	test   %eax,%eax
  802917:	78 3a                	js     802953 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802919:	83 ec 04             	sub    $0x4,%esp
  80291c:	68 07 04 00 00       	push   $0x407
  802921:	ff 75 f4             	pushl  -0xc(%ebp)
  802924:	6a 00                	push   $0x0
  802926:	e8 df ea ff ff       	call   80140a <sys_page_alloc>
  80292b:	83 c4 10             	add    $0x10,%esp
  80292e:	85 c0                	test   %eax,%eax
  802930:	78 21                	js     802953 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802932:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802935:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  80293b:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80293d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802940:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802947:	83 ec 0c             	sub    $0xc,%esp
  80294a:	50                   	push   %eax
  80294b:	e8 af ee ff ff       	call   8017ff <fd2num>
  802950:	83 c4 10             	add    $0x10,%esp
}
  802953:	c9                   	leave  
  802954:	c3                   	ret    

00802955 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802955:	55                   	push   %ebp
  802956:	89 e5                	mov    %esp,%ebp
  802958:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80295b:	89 d0                	mov    %edx,%eax
  80295d:	c1 e8 16             	shr    $0x16,%eax
  802960:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802967:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80296c:	f6 c1 01             	test   $0x1,%cl
  80296f:	74 1d                	je     80298e <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802971:	c1 ea 0c             	shr    $0xc,%edx
  802974:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80297b:	f6 c2 01             	test   $0x1,%dl
  80297e:	74 0e                	je     80298e <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802980:	c1 ea 0c             	shr    $0xc,%edx
  802983:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80298a:	ef 
  80298b:	0f b7 c0             	movzwl %ax,%eax
}
  80298e:	5d                   	pop    %ebp
  80298f:	c3                   	ret    

00802990 <__udivdi3>:
  802990:	55                   	push   %ebp
  802991:	57                   	push   %edi
  802992:	56                   	push   %esi
  802993:	53                   	push   %ebx
  802994:	83 ec 1c             	sub    $0x1c,%esp
  802997:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80299b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80299f:	8b 74 24 34          	mov    0x34(%esp),%esi
  8029a3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8029a7:	85 d2                	test   %edx,%edx
  8029a9:	75 4d                	jne    8029f8 <__udivdi3+0x68>
  8029ab:	39 f3                	cmp    %esi,%ebx
  8029ad:	76 19                	jbe    8029c8 <__udivdi3+0x38>
  8029af:	31 ff                	xor    %edi,%edi
  8029b1:	89 e8                	mov    %ebp,%eax
  8029b3:	89 f2                	mov    %esi,%edx
  8029b5:	f7 f3                	div    %ebx
  8029b7:	89 fa                	mov    %edi,%edx
  8029b9:	83 c4 1c             	add    $0x1c,%esp
  8029bc:	5b                   	pop    %ebx
  8029bd:	5e                   	pop    %esi
  8029be:	5f                   	pop    %edi
  8029bf:	5d                   	pop    %ebp
  8029c0:	c3                   	ret    
  8029c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029c8:	89 d9                	mov    %ebx,%ecx
  8029ca:	85 db                	test   %ebx,%ebx
  8029cc:	75 0b                	jne    8029d9 <__udivdi3+0x49>
  8029ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8029d3:	31 d2                	xor    %edx,%edx
  8029d5:	f7 f3                	div    %ebx
  8029d7:	89 c1                	mov    %eax,%ecx
  8029d9:	31 d2                	xor    %edx,%edx
  8029db:	89 f0                	mov    %esi,%eax
  8029dd:	f7 f1                	div    %ecx
  8029df:	89 c6                	mov    %eax,%esi
  8029e1:	89 e8                	mov    %ebp,%eax
  8029e3:	89 f7                	mov    %esi,%edi
  8029e5:	f7 f1                	div    %ecx
  8029e7:	89 fa                	mov    %edi,%edx
  8029e9:	83 c4 1c             	add    $0x1c,%esp
  8029ec:	5b                   	pop    %ebx
  8029ed:	5e                   	pop    %esi
  8029ee:	5f                   	pop    %edi
  8029ef:	5d                   	pop    %ebp
  8029f0:	c3                   	ret    
  8029f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029f8:	39 f2                	cmp    %esi,%edx
  8029fa:	77 1c                	ja     802a18 <__udivdi3+0x88>
  8029fc:	0f bd fa             	bsr    %edx,%edi
  8029ff:	83 f7 1f             	xor    $0x1f,%edi
  802a02:	75 2c                	jne    802a30 <__udivdi3+0xa0>
  802a04:	39 f2                	cmp    %esi,%edx
  802a06:	72 06                	jb     802a0e <__udivdi3+0x7e>
  802a08:	31 c0                	xor    %eax,%eax
  802a0a:	39 eb                	cmp    %ebp,%ebx
  802a0c:	77 a9                	ja     8029b7 <__udivdi3+0x27>
  802a0e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a13:	eb a2                	jmp    8029b7 <__udivdi3+0x27>
  802a15:	8d 76 00             	lea    0x0(%esi),%esi
  802a18:	31 ff                	xor    %edi,%edi
  802a1a:	31 c0                	xor    %eax,%eax
  802a1c:	89 fa                	mov    %edi,%edx
  802a1e:	83 c4 1c             	add    $0x1c,%esp
  802a21:	5b                   	pop    %ebx
  802a22:	5e                   	pop    %esi
  802a23:	5f                   	pop    %edi
  802a24:	5d                   	pop    %ebp
  802a25:	c3                   	ret    
  802a26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a2d:	8d 76 00             	lea    0x0(%esi),%esi
  802a30:	89 f9                	mov    %edi,%ecx
  802a32:	b8 20 00 00 00       	mov    $0x20,%eax
  802a37:	29 f8                	sub    %edi,%eax
  802a39:	d3 e2                	shl    %cl,%edx
  802a3b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802a3f:	89 c1                	mov    %eax,%ecx
  802a41:	89 da                	mov    %ebx,%edx
  802a43:	d3 ea                	shr    %cl,%edx
  802a45:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802a49:	09 d1                	or     %edx,%ecx
  802a4b:	89 f2                	mov    %esi,%edx
  802a4d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a51:	89 f9                	mov    %edi,%ecx
  802a53:	d3 e3                	shl    %cl,%ebx
  802a55:	89 c1                	mov    %eax,%ecx
  802a57:	d3 ea                	shr    %cl,%edx
  802a59:	89 f9                	mov    %edi,%ecx
  802a5b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802a5f:	89 eb                	mov    %ebp,%ebx
  802a61:	d3 e6                	shl    %cl,%esi
  802a63:	89 c1                	mov    %eax,%ecx
  802a65:	d3 eb                	shr    %cl,%ebx
  802a67:	09 de                	or     %ebx,%esi
  802a69:	89 f0                	mov    %esi,%eax
  802a6b:	f7 74 24 08          	divl   0x8(%esp)
  802a6f:	89 d6                	mov    %edx,%esi
  802a71:	89 c3                	mov    %eax,%ebx
  802a73:	f7 64 24 0c          	mull   0xc(%esp)
  802a77:	39 d6                	cmp    %edx,%esi
  802a79:	72 15                	jb     802a90 <__udivdi3+0x100>
  802a7b:	89 f9                	mov    %edi,%ecx
  802a7d:	d3 e5                	shl    %cl,%ebp
  802a7f:	39 c5                	cmp    %eax,%ebp
  802a81:	73 04                	jae    802a87 <__udivdi3+0xf7>
  802a83:	39 d6                	cmp    %edx,%esi
  802a85:	74 09                	je     802a90 <__udivdi3+0x100>
  802a87:	89 d8                	mov    %ebx,%eax
  802a89:	31 ff                	xor    %edi,%edi
  802a8b:	e9 27 ff ff ff       	jmp    8029b7 <__udivdi3+0x27>
  802a90:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802a93:	31 ff                	xor    %edi,%edi
  802a95:	e9 1d ff ff ff       	jmp    8029b7 <__udivdi3+0x27>
  802a9a:	66 90                	xchg   %ax,%ax
  802a9c:	66 90                	xchg   %ax,%ax
  802a9e:	66 90                	xchg   %ax,%ax

00802aa0 <__umoddi3>:
  802aa0:	55                   	push   %ebp
  802aa1:	57                   	push   %edi
  802aa2:	56                   	push   %esi
  802aa3:	53                   	push   %ebx
  802aa4:	83 ec 1c             	sub    $0x1c,%esp
  802aa7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802aab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802aaf:	8b 74 24 30          	mov    0x30(%esp),%esi
  802ab3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802ab7:	89 da                	mov    %ebx,%edx
  802ab9:	85 c0                	test   %eax,%eax
  802abb:	75 43                	jne    802b00 <__umoddi3+0x60>
  802abd:	39 df                	cmp    %ebx,%edi
  802abf:	76 17                	jbe    802ad8 <__umoddi3+0x38>
  802ac1:	89 f0                	mov    %esi,%eax
  802ac3:	f7 f7                	div    %edi
  802ac5:	89 d0                	mov    %edx,%eax
  802ac7:	31 d2                	xor    %edx,%edx
  802ac9:	83 c4 1c             	add    $0x1c,%esp
  802acc:	5b                   	pop    %ebx
  802acd:	5e                   	pop    %esi
  802ace:	5f                   	pop    %edi
  802acf:	5d                   	pop    %ebp
  802ad0:	c3                   	ret    
  802ad1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ad8:	89 fd                	mov    %edi,%ebp
  802ada:	85 ff                	test   %edi,%edi
  802adc:	75 0b                	jne    802ae9 <__umoddi3+0x49>
  802ade:	b8 01 00 00 00       	mov    $0x1,%eax
  802ae3:	31 d2                	xor    %edx,%edx
  802ae5:	f7 f7                	div    %edi
  802ae7:	89 c5                	mov    %eax,%ebp
  802ae9:	89 d8                	mov    %ebx,%eax
  802aeb:	31 d2                	xor    %edx,%edx
  802aed:	f7 f5                	div    %ebp
  802aef:	89 f0                	mov    %esi,%eax
  802af1:	f7 f5                	div    %ebp
  802af3:	89 d0                	mov    %edx,%eax
  802af5:	eb d0                	jmp    802ac7 <__umoddi3+0x27>
  802af7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802afe:	66 90                	xchg   %ax,%ax
  802b00:	89 f1                	mov    %esi,%ecx
  802b02:	39 d8                	cmp    %ebx,%eax
  802b04:	76 0a                	jbe    802b10 <__umoddi3+0x70>
  802b06:	89 f0                	mov    %esi,%eax
  802b08:	83 c4 1c             	add    $0x1c,%esp
  802b0b:	5b                   	pop    %ebx
  802b0c:	5e                   	pop    %esi
  802b0d:	5f                   	pop    %edi
  802b0e:	5d                   	pop    %ebp
  802b0f:	c3                   	ret    
  802b10:	0f bd e8             	bsr    %eax,%ebp
  802b13:	83 f5 1f             	xor    $0x1f,%ebp
  802b16:	75 20                	jne    802b38 <__umoddi3+0x98>
  802b18:	39 d8                	cmp    %ebx,%eax
  802b1a:	0f 82 b0 00 00 00    	jb     802bd0 <__umoddi3+0x130>
  802b20:	39 f7                	cmp    %esi,%edi
  802b22:	0f 86 a8 00 00 00    	jbe    802bd0 <__umoddi3+0x130>
  802b28:	89 c8                	mov    %ecx,%eax
  802b2a:	83 c4 1c             	add    $0x1c,%esp
  802b2d:	5b                   	pop    %ebx
  802b2e:	5e                   	pop    %esi
  802b2f:	5f                   	pop    %edi
  802b30:	5d                   	pop    %ebp
  802b31:	c3                   	ret    
  802b32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802b38:	89 e9                	mov    %ebp,%ecx
  802b3a:	ba 20 00 00 00       	mov    $0x20,%edx
  802b3f:	29 ea                	sub    %ebp,%edx
  802b41:	d3 e0                	shl    %cl,%eax
  802b43:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b47:	89 d1                	mov    %edx,%ecx
  802b49:	89 f8                	mov    %edi,%eax
  802b4b:	d3 e8                	shr    %cl,%eax
  802b4d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802b51:	89 54 24 04          	mov    %edx,0x4(%esp)
  802b55:	8b 54 24 04          	mov    0x4(%esp),%edx
  802b59:	09 c1                	or     %eax,%ecx
  802b5b:	89 d8                	mov    %ebx,%eax
  802b5d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b61:	89 e9                	mov    %ebp,%ecx
  802b63:	d3 e7                	shl    %cl,%edi
  802b65:	89 d1                	mov    %edx,%ecx
  802b67:	d3 e8                	shr    %cl,%eax
  802b69:	89 e9                	mov    %ebp,%ecx
  802b6b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b6f:	d3 e3                	shl    %cl,%ebx
  802b71:	89 c7                	mov    %eax,%edi
  802b73:	89 d1                	mov    %edx,%ecx
  802b75:	89 f0                	mov    %esi,%eax
  802b77:	d3 e8                	shr    %cl,%eax
  802b79:	89 e9                	mov    %ebp,%ecx
  802b7b:	89 fa                	mov    %edi,%edx
  802b7d:	d3 e6                	shl    %cl,%esi
  802b7f:	09 d8                	or     %ebx,%eax
  802b81:	f7 74 24 08          	divl   0x8(%esp)
  802b85:	89 d1                	mov    %edx,%ecx
  802b87:	89 f3                	mov    %esi,%ebx
  802b89:	f7 64 24 0c          	mull   0xc(%esp)
  802b8d:	89 c6                	mov    %eax,%esi
  802b8f:	89 d7                	mov    %edx,%edi
  802b91:	39 d1                	cmp    %edx,%ecx
  802b93:	72 06                	jb     802b9b <__umoddi3+0xfb>
  802b95:	75 10                	jne    802ba7 <__umoddi3+0x107>
  802b97:	39 c3                	cmp    %eax,%ebx
  802b99:	73 0c                	jae    802ba7 <__umoddi3+0x107>
  802b9b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802b9f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802ba3:	89 d7                	mov    %edx,%edi
  802ba5:	89 c6                	mov    %eax,%esi
  802ba7:	89 ca                	mov    %ecx,%edx
  802ba9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802bae:	29 f3                	sub    %esi,%ebx
  802bb0:	19 fa                	sbb    %edi,%edx
  802bb2:	89 d0                	mov    %edx,%eax
  802bb4:	d3 e0                	shl    %cl,%eax
  802bb6:	89 e9                	mov    %ebp,%ecx
  802bb8:	d3 eb                	shr    %cl,%ebx
  802bba:	d3 ea                	shr    %cl,%edx
  802bbc:	09 d8                	or     %ebx,%eax
  802bbe:	83 c4 1c             	add    $0x1c,%esp
  802bc1:	5b                   	pop    %ebx
  802bc2:	5e                   	pop    %esi
  802bc3:	5f                   	pop    %edi
  802bc4:	5d                   	pop    %ebp
  802bc5:	c3                   	ret    
  802bc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802bcd:	8d 76 00             	lea    0x0(%esi),%esi
  802bd0:	89 da                	mov    %ebx,%edx
  802bd2:	29 fe                	sub    %edi,%esi
  802bd4:	19 c2                	sbb    %eax,%edx
  802bd6:	89 f1                	mov    %esi,%ecx
  802bd8:	89 c8                	mov    %ecx,%eax
  802bda:	e9 4b ff ff ff       	jmp    802b2a <__umoddi3+0x8a>
