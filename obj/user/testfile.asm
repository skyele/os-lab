
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
  80002c:	e8 54 06 00 00       	call   800685 <libmain>
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
  80003d:	68 00 50 80 00       	push   $0x805000
  800042:	e8 3a 0f 00 00       	call   800f81 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800047:	89 1d 00 54 80 00    	mov    %ebx,0x805400

	fsenv = ipc_find_env(ENV_TYPE_FS);
  80004d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800054:	e8 0d 16 00 00       	call   801666 <ipc_find_env>
	ipc_send(fsenv, FSREQ_OPEN, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800059:	6a 07                	push   $0x7
  80005b:	68 00 50 80 00       	push   $0x805000
  800060:	6a 01                	push   $0x1
  800062:	50                   	push   %eax
  800063:	e8 a6 15 00 00       	call   80160e <ipc_send>
	return ipc_recv(NULL, FVA, NULL);
  800068:	83 c4 1c             	add    $0x1c,%esp
  80006b:	6a 00                	push   $0x0
  80006d:	68 00 c0 cc cc       	push   $0xccccc000
  800072:	6a 00                	push   $0x0
  800074:	e8 2c 15 00 00       	call   8015a5 <ipc_recv>
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
  80008f:	b8 c0 25 80 00       	mov    $0x8025c0,%eax
  800094:	e8 9a ff ff ff       	call   800033 <xopen>
  800099:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80009c:	74 08                	je     8000a6 <umain+0x28>
  80009e:	85 c0                	test   %eax,%eax
  8000a0:	0f 88 e9 03 00 00    	js     80048f <umain+0x411>
		panic("serve_open /not-found: %e", r);
	else if (r >= 0)
  8000a6:	85 c0                	test   %eax,%eax
  8000a8:	0f 89 f3 03 00 00    	jns    8004a1 <umain+0x423>
		panic("serve_open /not-found succeeded!");

	if ((r = xopen("/newmotd", O_RDONLY)) < 0)
  8000ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8000b3:	b8 f5 25 80 00       	mov    $0x8025f5,%eax
  8000b8:	e8 76 ff ff ff       	call   800033 <xopen>
  8000bd:	85 c0                	test   %eax,%eax
  8000bf:	0f 88 f0 03 00 00    	js     8004b5 <umain+0x437>
		panic("serve_open /newmotd: %e", r);
	if (FVA->fd_dev_id != 'f' || FVA->fd_offset != 0 || FVA->fd_omode != O_RDONLY)
  8000c5:	83 3d 00 c0 cc cc 66 	cmpl   $0x66,0xccccc000
  8000cc:	0f 85 f5 03 00 00    	jne    8004c7 <umain+0x449>
  8000d2:	83 3d 04 c0 cc cc 00 	cmpl   $0x0,0xccccc004
  8000d9:	0f 85 e8 03 00 00    	jne    8004c7 <umain+0x449>
  8000df:	83 3d 08 c0 cc cc 00 	cmpl   $0x0,0xccccc008
  8000e6:	0f 85 db 03 00 00    	jne    8004c7 <umain+0x449>
		panic("serve_open did not fill struct Fd correctly\n");
	cprintf("serve_open is good\n");
  8000ec:	83 ec 0c             	sub    $0xc,%esp
  8000ef:	68 16 26 80 00       	push   $0x802616
  8000f4:	e8 29 07 00 00       	call   800822 <cprintf>

	if ((r = devfile.dev_stat(FVA, &st)) < 0)
  8000f9:	83 c4 08             	add    $0x8,%esp
  8000fc:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  800102:	50                   	push   %eax
  800103:	68 00 c0 cc cc       	push   $0xccccc000
  800108:	ff 15 1c 30 80 00    	call   *0x80301c
  80010e:	83 c4 10             	add    $0x10,%esp
  800111:	85 c0                	test   %eax,%eax
  800113:	0f 88 c2 03 00 00    	js     8004db <umain+0x45d>
		panic("file_stat: %e", r);
	if (strlen(msg) != st.st_size)
  800119:	83 ec 0c             	sub    $0xc,%esp
  80011c:	ff 35 00 30 80 00    	pushl  0x803000
  800122:	e8 21 0e 00 00       	call   800f48 <strlen>
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  80012d:	0f 85 ba 03 00 00    	jne    8004ed <umain+0x46f>
		panic("file_stat returned size %d wanted %d\n", st.st_size, strlen(msg));
	cprintf("file_stat is good\n");
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	68 38 26 80 00       	push   $0x802638
  80013b:	e8 e2 06 00 00       	call   800822 <cprintf>

	memset(buf, 0, sizeof buf);
  800140:	83 c4 0c             	add    $0xc,%esp
  800143:	68 00 02 00 00       	push   $0x200
  800148:	6a 00                	push   $0x0
  80014a:	8d 9d 4c fd ff ff    	lea    -0x2b4(%ebp),%ebx
  800150:	53                   	push   %ebx
  800151:	e8 71 0f 00 00       	call   8010c7 <memset>
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  800156:	83 c4 0c             	add    $0xc,%esp
  800159:	68 00 02 00 00       	push   $0x200
  80015e:	53                   	push   %ebx
  80015f:	68 00 c0 cc cc       	push   $0xccccc000
  800164:	ff 15 10 30 80 00    	call   *0x803010
  80016a:	83 c4 10             	add    $0x10,%esp
  80016d:	85 c0                	test   %eax,%eax
  80016f:	0f 88 9d 03 00 00    	js     800512 <umain+0x494>
		panic("file_read: %e", r);
	if (strcmp(buf, msg) != 0)
  800175:	83 ec 08             	sub    $0x8,%esp
  800178:	ff 35 00 30 80 00    	pushl  0x803000
  80017e:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  800184:	50                   	push   %eax
  800185:	e8 a2 0e 00 00       	call   80102c <strcmp>
  80018a:	83 c4 10             	add    $0x10,%esp
  80018d:	85 c0                	test   %eax,%eax
  80018f:	0f 85 8f 03 00 00    	jne    800524 <umain+0x4a6>
		panic("file_read returned wrong data");
	cprintf("file_read is good\n");
  800195:	83 ec 0c             	sub    $0xc,%esp
  800198:	68 77 26 80 00       	push   $0x802677
  80019d:	e8 80 06 00 00       	call   800822 <cprintf>

	if ((r = devfile.dev_close(FVA)) < 0)
  8001a2:	c7 04 24 00 c0 cc cc 	movl   $0xccccc000,(%esp)
  8001a9:	ff 15 18 30 80 00    	call   *0x803018
  8001af:	83 c4 10             	add    $0x10,%esp
  8001b2:	85 c0                	test   %eax,%eax
  8001b4:	0f 88 7e 03 00 00    	js     800538 <umain+0x4ba>
		panic("file_close: %e", r);
	cprintf("file_close is good\n");
  8001ba:	83 ec 0c             	sub    $0xc,%esp
  8001bd:	68 99 26 80 00       	push   $0x802699
  8001c2:	e8 5b 06 00 00       	call   800822 <cprintf>

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
  8001f1:	e8 02 12 00 00       	call   8013f8 <sys_page_unmap>

	if ((r = devfile.dev_read(&fdcopy, buf, sizeof buf)) != -E_INVAL)
  8001f6:	83 c4 0c             	add    $0xc,%esp
  8001f9:	68 00 02 00 00       	push   $0x200
  8001fe:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  800204:	50                   	push   %eax
  800205:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800208:	50                   	push   %eax
  800209:	ff 15 10 30 80 00    	call   *0x803010
  80020f:	83 c4 10             	add    $0x10,%esp
  800212:	83 f8 fd             	cmp    $0xfffffffd,%eax
  800215:	0f 85 2f 03 00 00    	jne    80054a <umain+0x4cc>
		panic("serve_read does not handle stale fileids correctly: %e", r);
	cprintf("stale fileid is good\n");
  80021b:	83 ec 0c             	sub    $0xc,%esp
  80021e:	68 ad 26 80 00       	push   $0x8026ad
  800223:	e8 fa 05 00 00       	call   800822 <cprintf>

	// Try writing
	if ((r = xopen("/new-file", O_RDWR|O_CREAT)) < 0)
  800228:	ba 02 01 00 00       	mov    $0x102,%edx
  80022d:	b8 c3 26 80 00       	mov    $0x8026c3,%eax
  800232:	e8 fc fd ff ff       	call   800033 <xopen>
  800237:	83 c4 10             	add    $0x10,%esp
  80023a:	85 c0                	test   %eax,%eax
  80023c:	0f 88 1a 03 00 00    	js     80055c <umain+0x4de>
		panic("serve_open /new-file: %e", r);

	if ((r = devfile.dev_write(FVA, msg, strlen(msg))) != strlen(msg))
  800242:	8b 1d 14 30 80 00    	mov    0x803014,%ebx
  800248:	83 ec 0c             	sub    $0xc,%esp
  80024b:	ff 35 00 30 80 00    	pushl  0x803000
  800251:	e8 f2 0c 00 00       	call   800f48 <strlen>
  800256:	83 c4 0c             	add    $0xc,%esp
  800259:	50                   	push   %eax
  80025a:	ff 35 00 30 80 00    	pushl  0x803000
  800260:	68 00 c0 cc cc       	push   $0xccccc000
  800265:	ff d3                	call   *%ebx
  800267:	89 c3                	mov    %eax,%ebx
  800269:	83 c4 04             	add    $0x4,%esp
  80026c:	ff 35 00 30 80 00    	pushl  0x803000
  800272:	e8 d1 0c 00 00       	call   800f48 <strlen>
  800277:	83 c4 10             	add    $0x10,%esp
  80027a:	39 d8                	cmp    %ebx,%eax
  80027c:	0f 85 ec 02 00 00    	jne    80056e <umain+0x4f0>
		panic("file_write: %e", r);
	cprintf("file_write is good\n");
  800282:	83 ec 0c             	sub    $0xc,%esp
  800285:	68 f5 26 80 00       	push   $0x8026f5
  80028a:	e8 93 05 00 00       	call   800822 <cprintf>

	FVA->fd_offset = 0;
  80028f:	c7 05 04 c0 cc cc 00 	movl   $0x0,0xccccc004
  800296:	00 00 00 
	memset(buf, 0, sizeof buf);
  800299:	83 c4 0c             	add    $0xc,%esp
  80029c:	68 00 02 00 00       	push   $0x200
  8002a1:	6a 00                	push   $0x0
  8002a3:	8d 9d 4c fd ff ff    	lea    -0x2b4(%ebp),%ebx
  8002a9:	53                   	push   %ebx
  8002aa:	e8 18 0e 00 00       	call   8010c7 <memset>
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  8002af:	83 c4 0c             	add    $0xc,%esp
  8002b2:	68 00 02 00 00       	push   $0x200
  8002b7:	53                   	push   %ebx
  8002b8:	68 00 c0 cc cc       	push   $0xccccc000
  8002bd:	ff 15 10 30 80 00    	call   *0x803010
  8002c3:	89 c3                	mov    %eax,%ebx
  8002c5:	83 c4 10             	add    $0x10,%esp
  8002c8:	85 c0                	test   %eax,%eax
  8002ca:	0f 88 b0 02 00 00    	js     800580 <umain+0x502>
		panic("file_read after file_write: %e", r);
	if (r != strlen(msg))
  8002d0:	83 ec 0c             	sub    $0xc,%esp
  8002d3:	ff 35 00 30 80 00    	pushl  0x803000
  8002d9:	e8 6a 0c 00 00       	call   800f48 <strlen>
  8002de:	83 c4 10             	add    $0x10,%esp
  8002e1:	39 d8                	cmp    %ebx,%eax
  8002e3:	0f 85 a9 02 00 00    	jne    800592 <umain+0x514>
		panic("file_read after file_write returned wrong length: %d", r);
	if (strcmp(buf, msg) != 0)
  8002e9:	83 ec 08             	sub    $0x8,%esp
  8002ec:	ff 35 00 30 80 00    	pushl  0x803000
  8002f2:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  8002f8:	50                   	push   %eax
  8002f9:	e8 2e 0d 00 00       	call   80102c <strcmp>
  8002fe:	83 c4 10             	add    $0x10,%esp
  800301:	85 c0                	test   %eax,%eax
  800303:	0f 85 9b 02 00 00    	jne    8005a4 <umain+0x526>
		panic("file_read after file_write returned wrong data");
	cprintf("file_read after file_write is good\n");
  800309:	83 ec 0c             	sub    $0xc,%esp
  80030c:	68 bc 28 80 00       	push   $0x8028bc
  800311:	e8 0c 05 00 00       	call   800822 <cprintf>

	// Now we'll try out open
	if ((r = open("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  800316:	83 c4 08             	add    $0x8,%esp
  800319:	6a 00                	push   $0x0
  80031b:	68 c0 25 80 00       	push   $0x8025c0
  800320:	e8 97 1a 00 00       	call   801dbc <open>
  800325:	83 c4 10             	add    $0x10,%esp
  800328:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80032b:	74 08                	je     800335 <umain+0x2b7>
  80032d:	85 c0                	test   %eax,%eax
  80032f:	0f 88 83 02 00 00    	js     8005b8 <umain+0x53a>
		panic("open /not-found: %e", r);
	else if (r >= 0)
  800335:	85 c0                	test   %eax,%eax
  800337:	0f 89 8d 02 00 00    	jns    8005ca <umain+0x54c>
		panic("open /not-found succeeded!");

	if ((r = open("/newmotd", O_RDONLY)) < 0)
  80033d:	83 ec 08             	sub    $0x8,%esp
  800340:	6a 00                	push   $0x0
  800342:	68 f5 25 80 00       	push   $0x8025f5
  800347:	e8 70 1a 00 00       	call   801dbc <open>
  80034c:	83 c4 10             	add    $0x10,%esp
  80034f:	85 c0                	test   %eax,%eax
  800351:	0f 88 87 02 00 00    	js     8005de <umain+0x560>
		panic("open /newmotd: %e", r);
	fd = (struct Fd*) (0xD0000000 + r*PGSIZE);
  800357:	c1 e0 0c             	shl    $0xc,%eax
	if (fd->fd_dev_id != 'f' || fd->fd_offset != 0 || fd->fd_omode != O_RDONLY)
  80035a:	83 b8 00 00 00 d0 66 	cmpl   $0x66,-0x30000000(%eax)
  800361:	0f 85 89 02 00 00    	jne    8005f0 <umain+0x572>
  800367:	83 b8 04 00 00 d0 00 	cmpl   $0x0,-0x2ffffffc(%eax)
  80036e:	0f 85 7c 02 00 00    	jne    8005f0 <umain+0x572>
  800374:	8b 98 08 00 00 d0    	mov    -0x2ffffff8(%eax),%ebx
  80037a:	85 db                	test   %ebx,%ebx
  80037c:	0f 85 6e 02 00 00    	jne    8005f0 <umain+0x572>
		panic("open did not fill struct Fd correctly\n");
	cprintf("open is good\n");
  800382:	83 ec 0c             	sub    $0xc,%esp
  800385:	68 1c 26 80 00       	push   $0x80261c
  80038a:	e8 93 04 00 00       	call   800822 <cprintf>

	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
  80038f:	83 c4 08             	add    $0x8,%esp
  800392:	68 01 01 00 00       	push   $0x101
  800397:	68 24 27 80 00       	push   $0x802724
  80039c:	e8 1b 1a 00 00       	call   801dbc <open>
  8003a1:	89 c7                	mov    %eax,%edi
  8003a3:	83 c4 10             	add    $0x10,%esp
  8003a6:	85 c0                	test   %eax,%eax
  8003a8:	0f 88 56 02 00 00    	js     800604 <umain+0x586>
		panic("creat /big: %e", f);
	memset(buf, 0, sizeof(buf));
  8003ae:	83 ec 04             	sub    $0x4,%esp
  8003b1:	68 00 02 00 00       	push   $0x200
  8003b6:	6a 00                	push   $0x0
  8003b8:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  8003be:	50                   	push   %eax
  8003bf:	e8 03 0d 00 00       	call   8010c7 <memset>
  8003c4:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  8003c7:	89 de                	mov    %ebx,%esi
		*(int*)buf = i;
  8003c9:	89 b5 4c fd ff ff    	mov    %esi,-0x2b4(%ebp)
		if ((r = write(f, buf, sizeof(buf))) < 0)
  8003cf:	83 ec 04             	sub    $0x4,%esp
  8003d2:	68 00 02 00 00       	push   $0x200
  8003d7:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  8003dd:	50                   	push   %eax
  8003de:	57                   	push   %edi
  8003df:	e8 6d 16 00 00       	call   801a51 <write>
  8003e4:	83 c4 10             	add    $0x10,%esp
  8003e7:	85 c0                	test   %eax,%eax
  8003e9:	0f 88 27 02 00 00    	js     800616 <umain+0x598>
  8003ef:	81 c6 00 02 00 00    	add    $0x200,%esi
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  8003f5:	81 fe 00 e0 01 00    	cmp    $0x1e000,%esi
  8003fb:	75 cc                	jne    8003c9 <umain+0x34b>
			panic("write /big@%d: %e", i, r);
	}
	close(f);
  8003fd:	83 ec 0c             	sub    $0xc,%esp
  800400:	57                   	push   %edi
  800401:	e8 41 14 00 00       	call   801847 <close>

	if ((f = open("/big", O_RDONLY)) < 0)
  800406:	83 c4 08             	add    $0x8,%esp
  800409:	6a 00                	push   $0x0
  80040b:	68 24 27 80 00       	push   $0x802724
  800410:	e8 a7 19 00 00       	call   801dbc <open>
  800415:	89 c6                	mov    %eax,%esi
  800417:	83 c4 10             	add    $0x10,%esp
  80041a:	85 c0                	test   %eax,%eax
  80041c:	0f 88 0a 02 00 00    	js     80062c <umain+0x5ae>
		panic("open /big: %e", f);
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
		*(int*)buf = i;
		if ((r = readn(f, buf, sizeof(buf))) < 0)
  800422:	8d bd 4c fd ff ff    	lea    -0x2b4(%ebp),%edi
		*(int*)buf = i;
  800428:	89 9d 4c fd ff ff    	mov    %ebx,-0x2b4(%ebp)
		if ((r = readn(f, buf, sizeof(buf))) < 0)
  80042e:	83 ec 04             	sub    $0x4,%esp
  800431:	68 00 02 00 00       	push   $0x200
  800436:	57                   	push   %edi
  800437:	56                   	push   %esi
  800438:	e8 cf 15 00 00       	call   801a0c <readn>
  80043d:	83 c4 10             	add    $0x10,%esp
  800440:	85 c0                	test   %eax,%eax
  800442:	0f 88 f6 01 00 00    	js     80063e <umain+0x5c0>
			panic("read /big@%d: %e", i, r);
		if (r != sizeof(buf))
  800448:	3d 00 02 00 00       	cmp    $0x200,%eax
  80044d:	0f 85 01 02 00 00    	jne    800654 <umain+0x5d6>
			panic("read /big from %d returned %d < %d bytes",
			      i, r, sizeof(buf));
		if (*(int*)buf != i)
  800453:	8b 85 4c fd ff ff    	mov    -0x2b4(%ebp),%eax
  800459:	39 d8                	cmp    %ebx,%eax
  80045b:	0f 85 0e 02 00 00    	jne    80066f <umain+0x5f1>
  800461:	81 c3 00 02 00 00    	add    $0x200,%ebx
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800467:	81 fb 00 e0 01 00    	cmp    $0x1e000,%ebx
  80046d:	75 b9                	jne    800428 <umain+0x3aa>
			panic("read /big from %d returned bad data %d",
			      i, *(int*)buf);
	}
	close(f);
  80046f:	83 ec 0c             	sub    $0xc,%esp
  800472:	56                   	push   %esi
  800473:	e8 cf 13 00 00       	call   801847 <close>
	cprintf("large file is good\n");
  800478:	c7 04 24 69 27 80 00 	movl   $0x802769,(%esp)
  80047f:	e8 9e 03 00 00       	call   800822 <cprintf>
}
  800484:	83 c4 10             	add    $0x10,%esp
  800487:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80048a:	5b                   	pop    %ebx
  80048b:	5e                   	pop    %esi
  80048c:	5f                   	pop    %edi
  80048d:	5d                   	pop    %ebp
  80048e:	c3                   	ret    
		panic("serve_open /not-found: %e", r);
  80048f:	50                   	push   %eax
  800490:	68 cb 25 80 00       	push   $0x8025cb
  800495:	6a 20                	push   $0x20
  800497:	68 e5 25 80 00       	push   $0x8025e5
  80049c:	e8 8b 02 00 00       	call   80072c <_panic>
		panic("serve_open /not-found succeeded!");
  8004a1:	83 ec 04             	sub    $0x4,%esp
  8004a4:	68 80 27 80 00       	push   $0x802780
  8004a9:	6a 22                	push   $0x22
  8004ab:	68 e5 25 80 00       	push   $0x8025e5
  8004b0:	e8 77 02 00 00       	call   80072c <_panic>
		panic("serve_open /newmotd: %e", r);
  8004b5:	50                   	push   %eax
  8004b6:	68 fe 25 80 00       	push   $0x8025fe
  8004bb:	6a 25                	push   $0x25
  8004bd:	68 e5 25 80 00       	push   $0x8025e5
  8004c2:	e8 65 02 00 00       	call   80072c <_panic>
		panic("serve_open did not fill struct Fd correctly\n");
  8004c7:	83 ec 04             	sub    $0x4,%esp
  8004ca:	68 a4 27 80 00       	push   $0x8027a4
  8004cf:	6a 27                	push   $0x27
  8004d1:	68 e5 25 80 00       	push   $0x8025e5
  8004d6:	e8 51 02 00 00       	call   80072c <_panic>
		panic("file_stat: %e", r);
  8004db:	50                   	push   %eax
  8004dc:	68 2a 26 80 00       	push   $0x80262a
  8004e1:	6a 2b                	push   $0x2b
  8004e3:	68 e5 25 80 00       	push   $0x8025e5
  8004e8:	e8 3f 02 00 00       	call   80072c <_panic>
		panic("file_stat returned size %d wanted %d\n", st.st_size, strlen(msg));
  8004ed:	83 ec 0c             	sub    $0xc,%esp
  8004f0:	ff 35 00 30 80 00    	pushl  0x803000
  8004f6:	e8 4d 0a 00 00       	call   800f48 <strlen>
  8004fb:	89 04 24             	mov    %eax,(%esp)
  8004fe:	ff 75 cc             	pushl  -0x34(%ebp)
  800501:	68 d4 27 80 00       	push   $0x8027d4
  800506:	6a 2d                	push   $0x2d
  800508:	68 e5 25 80 00       	push   $0x8025e5
  80050d:	e8 1a 02 00 00       	call   80072c <_panic>
		panic("file_read: %e", r);
  800512:	50                   	push   %eax
  800513:	68 4b 26 80 00       	push   $0x80264b
  800518:	6a 32                	push   $0x32
  80051a:	68 e5 25 80 00       	push   $0x8025e5
  80051f:	e8 08 02 00 00       	call   80072c <_panic>
		panic("file_read returned wrong data");
  800524:	83 ec 04             	sub    $0x4,%esp
  800527:	68 59 26 80 00       	push   $0x802659
  80052c:	6a 34                	push   $0x34
  80052e:	68 e5 25 80 00       	push   $0x8025e5
  800533:	e8 f4 01 00 00       	call   80072c <_panic>
		panic("file_close: %e", r);
  800538:	50                   	push   %eax
  800539:	68 8a 26 80 00       	push   $0x80268a
  80053e:	6a 38                	push   $0x38
  800540:	68 e5 25 80 00       	push   $0x8025e5
  800545:	e8 e2 01 00 00       	call   80072c <_panic>
		panic("serve_read does not handle stale fileids correctly: %e", r);
  80054a:	50                   	push   %eax
  80054b:	68 fc 27 80 00       	push   $0x8027fc
  800550:	6a 43                	push   $0x43
  800552:	68 e5 25 80 00       	push   $0x8025e5
  800557:	e8 d0 01 00 00       	call   80072c <_panic>
		panic("serve_open /new-file: %e", r);
  80055c:	50                   	push   %eax
  80055d:	68 cd 26 80 00       	push   $0x8026cd
  800562:	6a 48                	push   $0x48
  800564:	68 e5 25 80 00       	push   $0x8025e5
  800569:	e8 be 01 00 00       	call   80072c <_panic>
		panic("file_write: %e", r);
  80056e:	53                   	push   %ebx
  80056f:	68 e6 26 80 00       	push   $0x8026e6
  800574:	6a 4b                	push   $0x4b
  800576:	68 e5 25 80 00       	push   $0x8025e5
  80057b:	e8 ac 01 00 00       	call   80072c <_panic>
		panic("file_read after file_write: %e", r);
  800580:	50                   	push   %eax
  800581:	68 34 28 80 00       	push   $0x802834
  800586:	6a 51                	push   $0x51
  800588:	68 e5 25 80 00       	push   $0x8025e5
  80058d:	e8 9a 01 00 00       	call   80072c <_panic>
		panic("file_read after file_write returned wrong length: %d", r);
  800592:	53                   	push   %ebx
  800593:	68 54 28 80 00       	push   $0x802854
  800598:	6a 53                	push   $0x53
  80059a:	68 e5 25 80 00       	push   $0x8025e5
  80059f:	e8 88 01 00 00       	call   80072c <_panic>
		panic("file_read after file_write returned wrong data");
  8005a4:	83 ec 04             	sub    $0x4,%esp
  8005a7:	68 8c 28 80 00       	push   $0x80288c
  8005ac:	6a 55                	push   $0x55
  8005ae:	68 e5 25 80 00       	push   $0x8025e5
  8005b3:	e8 74 01 00 00       	call   80072c <_panic>
		panic("open /not-found: %e", r);
  8005b8:	50                   	push   %eax
  8005b9:	68 d1 25 80 00       	push   $0x8025d1
  8005be:	6a 5a                	push   $0x5a
  8005c0:	68 e5 25 80 00       	push   $0x8025e5
  8005c5:	e8 62 01 00 00       	call   80072c <_panic>
		panic("open /not-found succeeded!");
  8005ca:	83 ec 04             	sub    $0x4,%esp
  8005cd:	68 09 27 80 00       	push   $0x802709
  8005d2:	6a 5c                	push   $0x5c
  8005d4:	68 e5 25 80 00       	push   $0x8025e5
  8005d9:	e8 4e 01 00 00       	call   80072c <_panic>
		panic("open /newmotd: %e", r);
  8005de:	50                   	push   %eax
  8005df:	68 04 26 80 00       	push   $0x802604
  8005e4:	6a 5f                	push   $0x5f
  8005e6:	68 e5 25 80 00       	push   $0x8025e5
  8005eb:	e8 3c 01 00 00       	call   80072c <_panic>
		panic("open did not fill struct Fd correctly\n");
  8005f0:	83 ec 04             	sub    $0x4,%esp
  8005f3:	68 e0 28 80 00       	push   $0x8028e0
  8005f8:	6a 62                	push   $0x62
  8005fa:	68 e5 25 80 00       	push   $0x8025e5
  8005ff:	e8 28 01 00 00       	call   80072c <_panic>
		panic("creat /big: %e", f);
  800604:	50                   	push   %eax
  800605:	68 29 27 80 00       	push   $0x802729
  80060a:	6a 67                	push   $0x67
  80060c:	68 e5 25 80 00       	push   $0x8025e5
  800611:	e8 16 01 00 00       	call   80072c <_panic>
			panic("write /big@%d: %e", i, r);
  800616:	83 ec 0c             	sub    $0xc,%esp
  800619:	50                   	push   %eax
  80061a:	56                   	push   %esi
  80061b:	68 38 27 80 00       	push   $0x802738
  800620:	6a 6c                	push   $0x6c
  800622:	68 e5 25 80 00       	push   $0x8025e5
  800627:	e8 00 01 00 00       	call   80072c <_panic>
		panic("open /big: %e", f);
  80062c:	50                   	push   %eax
  80062d:	68 4a 27 80 00       	push   $0x80274a
  800632:	6a 71                	push   $0x71
  800634:	68 e5 25 80 00       	push   $0x8025e5
  800639:	e8 ee 00 00 00       	call   80072c <_panic>
			panic("read /big@%d: %e", i, r);
  80063e:	83 ec 0c             	sub    $0xc,%esp
  800641:	50                   	push   %eax
  800642:	53                   	push   %ebx
  800643:	68 58 27 80 00       	push   $0x802758
  800648:	6a 75                	push   $0x75
  80064a:	68 e5 25 80 00       	push   $0x8025e5
  80064f:	e8 d8 00 00 00       	call   80072c <_panic>
			panic("read /big from %d returned %d < %d bytes",
  800654:	83 ec 08             	sub    $0x8,%esp
  800657:	68 00 02 00 00       	push   $0x200
  80065c:	50                   	push   %eax
  80065d:	53                   	push   %ebx
  80065e:	68 08 29 80 00       	push   $0x802908
  800663:	6a 78                	push   $0x78
  800665:	68 e5 25 80 00       	push   $0x8025e5
  80066a:	e8 bd 00 00 00       	call   80072c <_panic>
			panic("read /big from %d returned bad data %d",
  80066f:	83 ec 0c             	sub    $0xc,%esp
  800672:	50                   	push   %eax
  800673:	53                   	push   %ebx
  800674:	68 34 29 80 00       	push   $0x802934
  800679:	6a 7b                	push   $0x7b
  80067b:	68 e5 25 80 00       	push   $0x8025e5
  800680:	e8 a7 00 00 00       	call   80072c <_panic>

00800685 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  800685:	55                   	push   %ebp
  800686:	89 e5                	mov    %esp,%ebp
  800688:	57                   	push   %edi
  800689:	56                   	push   %esi
  80068a:	53                   	push   %ebx
  80068b:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  80068e:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  800695:	00 00 00 
	envid_t find = sys_getenvid();
  800698:	e8 98 0c 00 00       	call   801335 <sys_getenvid>
  80069d:	8b 1d 04 40 80 00    	mov    0x804004,%ebx
  8006a3:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  8006a8:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  8006ad:	bf 01 00 00 00       	mov    $0x1,%edi
  8006b2:	eb 0b                	jmp    8006bf <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  8006b4:	83 c2 01             	add    $0x1,%edx
  8006b7:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8006bd:	74 21                	je     8006e0 <libmain+0x5b>
		if(envs[i].env_id == find)
  8006bf:	89 d1                	mov    %edx,%ecx
  8006c1:	c1 e1 07             	shl    $0x7,%ecx
  8006c4:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  8006ca:	8b 49 48             	mov    0x48(%ecx),%ecx
  8006cd:	39 c1                	cmp    %eax,%ecx
  8006cf:	75 e3                	jne    8006b4 <libmain+0x2f>
  8006d1:	89 d3                	mov    %edx,%ebx
  8006d3:	c1 e3 07             	shl    $0x7,%ebx
  8006d6:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8006dc:	89 fe                	mov    %edi,%esi
  8006de:	eb d4                	jmp    8006b4 <libmain+0x2f>
  8006e0:	89 f0                	mov    %esi,%eax
  8006e2:	84 c0                	test   %al,%al
  8006e4:	74 06                	je     8006ec <libmain+0x67>
  8006e6:	89 1d 04 40 80 00    	mov    %ebx,0x804004
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006ec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006f0:	7e 0a                	jle    8006fc <libmain+0x77>
		binaryname = argv[0];
  8006f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f5:	8b 00                	mov    (%eax),%eax
  8006f7:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  8006fc:	83 ec 08             	sub    $0x8,%esp
  8006ff:	ff 75 0c             	pushl  0xc(%ebp)
  800702:	ff 75 08             	pushl  0x8(%ebp)
  800705:	e8 74 f9 ff ff       	call   80007e <umain>

	// exit gracefully
	exit();
  80070a:	e8 0b 00 00 00       	call   80071a <exit>
}
  80070f:	83 c4 10             	add    $0x10,%esp
  800712:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800715:	5b                   	pop    %ebx
  800716:	5e                   	pop    %esi
  800717:	5f                   	pop    %edi
  800718:	5d                   	pop    %ebp
  800719:	c3                   	ret    

0080071a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80071a:	55                   	push   %ebp
  80071b:	89 e5                	mov    %esp,%ebp
  80071d:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800720:	6a 00                	push   $0x0
  800722:	e8 cd 0b 00 00       	call   8012f4 <sys_env_destroy>
}
  800727:	83 c4 10             	add    $0x10,%esp
  80072a:	c9                   	leave  
  80072b:	c3                   	ret    

0080072c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80072c:	55                   	push   %ebp
  80072d:	89 e5                	mov    %esp,%ebp
  80072f:	56                   	push   %esi
  800730:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800731:	a1 04 40 80 00       	mov    0x804004,%eax
  800736:	8b 40 48             	mov    0x48(%eax),%eax
  800739:	83 ec 04             	sub    $0x4,%esp
  80073c:	68 bc 29 80 00       	push   $0x8029bc
  800741:	50                   	push   %eax
  800742:	68 8c 29 80 00       	push   $0x80298c
  800747:	e8 d6 00 00 00       	call   800822 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80074c:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80074f:	8b 35 04 30 80 00    	mov    0x803004,%esi
  800755:	e8 db 0b 00 00       	call   801335 <sys_getenvid>
  80075a:	83 c4 04             	add    $0x4,%esp
  80075d:	ff 75 0c             	pushl  0xc(%ebp)
  800760:	ff 75 08             	pushl  0x8(%ebp)
  800763:	56                   	push   %esi
  800764:	50                   	push   %eax
  800765:	68 98 29 80 00       	push   $0x802998
  80076a:	e8 b3 00 00 00       	call   800822 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80076f:	83 c4 18             	add    $0x18,%esp
  800772:	53                   	push   %ebx
  800773:	ff 75 10             	pushl  0x10(%ebp)
  800776:	e8 56 00 00 00       	call   8007d1 <vcprintf>
	cprintf("\n");
  80077b:	c7 04 24 7e 2d 80 00 	movl   $0x802d7e,(%esp)
  800782:	e8 9b 00 00 00       	call   800822 <cprintf>
  800787:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80078a:	cc                   	int3   
  80078b:	eb fd                	jmp    80078a <_panic+0x5e>

0080078d <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80078d:	55                   	push   %ebp
  80078e:	89 e5                	mov    %esp,%ebp
  800790:	53                   	push   %ebx
  800791:	83 ec 04             	sub    $0x4,%esp
  800794:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800797:	8b 13                	mov    (%ebx),%edx
  800799:	8d 42 01             	lea    0x1(%edx),%eax
  80079c:	89 03                	mov    %eax,(%ebx)
  80079e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007a1:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8007a5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8007aa:	74 09                	je     8007b5 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8007ac:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8007b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007b3:	c9                   	leave  
  8007b4:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8007b5:	83 ec 08             	sub    $0x8,%esp
  8007b8:	68 ff 00 00 00       	push   $0xff
  8007bd:	8d 43 08             	lea    0x8(%ebx),%eax
  8007c0:	50                   	push   %eax
  8007c1:	e8 f1 0a 00 00       	call   8012b7 <sys_cputs>
		b->idx = 0;
  8007c6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8007cc:	83 c4 10             	add    $0x10,%esp
  8007cf:	eb db                	jmp    8007ac <putch+0x1f>

008007d1 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8007d1:	55                   	push   %ebp
  8007d2:	89 e5                	mov    %esp,%ebp
  8007d4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8007da:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8007e1:	00 00 00 
	b.cnt = 0;
  8007e4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8007eb:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8007ee:	ff 75 0c             	pushl  0xc(%ebp)
  8007f1:	ff 75 08             	pushl  0x8(%ebp)
  8007f4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007fa:	50                   	push   %eax
  8007fb:	68 8d 07 80 00       	push   $0x80078d
  800800:	e8 4a 01 00 00       	call   80094f <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800805:	83 c4 08             	add    $0x8,%esp
  800808:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80080e:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800814:	50                   	push   %eax
  800815:	e8 9d 0a 00 00       	call   8012b7 <sys_cputs>

	return b.cnt;
}
  80081a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800820:	c9                   	leave  
  800821:	c3                   	ret    

00800822 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800822:	55                   	push   %ebp
  800823:	89 e5                	mov    %esp,%ebp
  800825:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800828:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80082b:	50                   	push   %eax
  80082c:	ff 75 08             	pushl  0x8(%ebp)
  80082f:	e8 9d ff ff ff       	call   8007d1 <vcprintf>
	va_end(ap);

	return cnt;
}
  800834:	c9                   	leave  
  800835:	c3                   	ret    

00800836 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800836:	55                   	push   %ebp
  800837:	89 e5                	mov    %esp,%ebp
  800839:	57                   	push   %edi
  80083a:	56                   	push   %esi
  80083b:	53                   	push   %ebx
  80083c:	83 ec 1c             	sub    $0x1c,%esp
  80083f:	89 c6                	mov    %eax,%esi
  800841:	89 d7                	mov    %edx,%edi
  800843:	8b 45 08             	mov    0x8(%ebp),%eax
  800846:	8b 55 0c             	mov    0xc(%ebp),%edx
  800849:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80084c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80084f:	8b 45 10             	mov    0x10(%ebp),%eax
  800852:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800855:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800859:	74 2c                	je     800887 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80085b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80085e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800865:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800868:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80086b:	39 c2                	cmp    %eax,%edx
  80086d:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800870:	73 43                	jae    8008b5 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800872:	83 eb 01             	sub    $0x1,%ebx
  800875:	85 db                	test   %ebx,%ebx
  800877:	7e 6c                	jle    8008e5 <printnum+0xaf>
				putch(padc, putdat);
  800879:	83 ec 08             	sub    $0x8,%esp
  80087c:	57                   	push   %edi
  80087d:	ff 75 18             	pushl  0x18(%ebp)
  800880:	ff d6                	call   *%esi
  800882:	83 c4 10             	add    $0x10,%esp
  800885:	eb eb                	jmp    800872 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800887:	83 ec 0c             	sub    $0xc,%esp
  80088a:	6a 20                	push   $0x20
  80088c:	6a 00                	push   $0x0
  80088e:	50                   	push   %eax
  80088f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800892:	ff 75 e0             	pushl  -0x20(%ebp)
  800895:	89 fa                	mov    %edi,%edx
  800897:	89 f0                	mov    %esi,%eax
  800899:	e8 98 ff ff ff       	call   800836 <printnum>
		while (--width > 0)
  80089e:	83 c4 20             	add    $0x20,%esp
  8008a1:	83 eb 01             	sub    $0x1,%ebx
  8008a4:	85 db                	test   %ebx,%ebx
  8008a6:	7e 65                	jle    80090d <printnum+0xd7>
			putch(padc, putdat);
  8008a8:	83 ec 08             	sub    $0x8,%esp
  8008ab:	57                   	push   %edi
  8008ac:	6a 20                	push   $0x20
  8008ae:	ff d6                	call   *%esi
  8008b0:	83 c4 10             	add    $0x10,%esp
  8008b3:	eb ec                	jmp    8008a1 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8008b5:	83 ec 0c             	sub    $0xc,%esp
  8008b8:	ff 75 18             	pushl  0x18(%ebp)
  8008bb:	83 eb 01             	sub    $0x1,%ebx
  8008be:	53                   	push   %ebx
  8008bf:	50                   	push   %eax
  8008c0:	83 ec 08             	sub    $0x8,%esp
  8008c3:	ff 75 dc             	pushl  -0x24(%ebp)
  8008c6:	ff 75 d8             	pushl  -0x28(%ebp)
  8008c9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8008cc:	ff 75 e0             	pushl  -0x20(%ebp)
  8008cf:	e8 8c 1a 00 00       	call   802360 <__udivdi3>
  8008d4:	83 c4 18             	add    $0x18,%esp
  8008d7:	52                   	push   %edx
  8008d8:	50                   	push   %eax
  8008d9:	89 fa                	mov    %edi,%edx
  8008db:	89 f0                	mov    %esi,%eax
  8008dd:	e8 54 ff ff ff       	call   800836 <printnum>
  8008e2:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8008e5:	83 ec 08             	sub    $0x8,%esp
  8008e8:	57                   	push   %edi
  8008e9:	83 ec 04             	sub    $0x4,%esp
  8008ec:	ff 75 dc             	pushl  -0x24(%ebp)
  8008ef:	ff 75 d8             	pushl  -0x28(%ebp)
  8008f2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8008f5:	ff 75 e0             	pushl  -0x20(%ebp)
  8008f8:	e8 73 1b 00 00       	call   802470 <__umoddi3>
  8008fd:	83 c4 14             	add    $0x14,%esp
  800900:	0f be 80 c3 29 80 00 	movsbl 0x8029c3(%eax),%eax
  800907:	50                   	push   %eax
  800908:	ff d6                	call   *%esi
  80090a:	83 c4 10             	add    $0x10,%esp
	}
}
  80090d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800910:	5b                   	pop    %ebx
  800911:	5e                   	pop    %esi
  800912:	5f                   	pop    %edi
  800913:	5d                   	pop    %ebp
  800914:	c3                   	ret    

00800915 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800915:	55                   	push   %ebp
  800916:	89 e5                	mov    %esp,%ebp
  800918:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80091b:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80091f:	8b 10                	mov    (%eax),%edx
  800921:	3b 50 04             	cmp    0x4(%eax),%edx
  800924:	73 0a                	jae    800930 <sprintputch+0x1b>
		*b->buf++ = ch;
  800926:	8d 4a 01             	lea    0x1(%edx),%ecx
  800929:	89 08                	mov    %ecx,(%eax)
  80092b:	8b 45 08             	mov    0x8(%ebp),%eax
  80092e:	88 02                	mov    %al,(%edx)
}
  800930:	5d                   	pop    %ebp
  800931:	c3                   	ret    

00800932 <printfmt>:
{
  800932:	55                   	push   %ebp
  800933:	89 e5                	mov    %esp,%ebp
  800935:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800938:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80093b:	50                   	push   %eax
  80093c:	ff 75 10             	pushl  0x10(%ebp)
  80093f:	ff 75 0c             	pushl  0xc(%ebp)
  800942:	ff 75 08             	pushl  0x8(%ebp)
  800945:	e8 05 00 00 00       	call   80094f <vprintfmt>
}
  80094a:	83 c4 10             	add    $0x10,%esp
  80094d:	c9                   	leave  
  80094e:	c3                   	ret    

0080094f <vprintfmt>:
{
  80094f:	55                   	push   %ebp
  800950:	89 e5                	mov    %esp,%ebp
  800952:	57                   	push   %edi
  800953:	56                   	push   %esi
  800954:	53                   	push   %ebx
  800955:	83 ec 3c             	sub    $0x3c,%esp
  800958:	8b 75 08             	mov    0x8(%ebp),%esi
  80095b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80095e:	8b 7d 10             	mov    0x10(%ebp),%edi
  800961:	e9 32 04 00 00       	jmp    800d98 <vprintfmt+0x449>
		padc = ' ';
  800966:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80096a:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800971:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800978:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80097f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800986:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80098d:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800992:	8d 47 01             	lea    0x1(%edi),%eax
  800995:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800998:	0f b6 17             	movzbl (%edi),%edx
  80099b:	8d 42 dd             	lea    -0x23(%edx),%eax
  80099e:	3c 55                	cmp    $0x55,%al
  8009a0:	0f 87 12 05 00 00    	ja     800eb8 <vprintfmt+0x569>
  8009a6:	0f b6 c0             	movzbl %al,%eax
  8009a9:	ff 24 85 a0 2b 80 00 	jmp    *0x802ba0(,%eax,4)
  8009b0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8009b3:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8009b7:	eb d9                	jmp    800992 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8009b9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8009bc:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8009c0:	eb d0                	jmp    800992 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8009c2:	0f b6 d2             	movzbl %dl,%edx
  8009c5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8009c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8009cd:	89 75 08             	mov    %esi,0x8(%ebp)
  8009d0:	eb 03                	jmp    8009d5 <vprintfmt+0x86>
  8009d2:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8009d5:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8009d8:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8009dc:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8009df:	8d 72 d0             	lea    -0x30(%edx),%esi
  8009e2:	83 fe 09             	cmp    $0x9,%esi
  8009e5:	76 eb                	jbe    8009d2 <vprintfmt+0x83>
  8009e7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009ea:	8b 75 08             	mov    0x8(%ebp),%esi
  8009ed:	eb 14                	jmp    800a03 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8009ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f2:	8b 00                	mov    (%eax),%eax
  8009f4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009fa:	8d 40 04             	lea    0x4(%eax),%eax
  8009fd:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800a00:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800a03:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a07:	79 89                	jns    800992 <vprintfmt+0x43>
				width = precision, precision = -1;
  800a09:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a0c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a0f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800a16:	e9 77 ff ff ff       	jmp    800992 <vprintfmt+0x43>
  800a1b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a1e:	85 c0                	test   %eax,%eax
  800a20:	0f 48 c1             	cmovs  %ecx,%eax
  800a23:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800a26:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800a29:	e9 64 ff ff ff       	jmp    800992 <vprintfmt+0x43>
  800a2e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800a31:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800a38:	e9 55 ff ff ff       	jmp    800992 <vprintfmt+0x43>
			lflag++;
  800a3d:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800a41:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800a44:	e9 49 ff ff ff       	jmp    800992 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800a49:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4c:	8d 78 04             	lea    0x4(%eax),%edi
  800a4f:	83 ec 08             	sub    $0x8,%esp
  800a52:	53                   	push   %ebx
  800a53:	ff 30                	pushl  (%eax)
  800a55:	ff d6                	call   *%esi
			break;
  800a57:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800a5a:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800a5d:	e9 33 03 00 00       	jmp    800d95 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800a62:	8b 45 14             	mov    0x14(%ebp),%eax
  800a65:	8d 78 04             	lea    0x4(%eax),%edi
  800a68:	8b 00                	mov    (%eax),%eax
  800a6a:	99                   	cltd   
  800a6b:	31 d0                	xor    %edx,%eax
  800a6d:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a6f:	83 f8 0f             	cmp    $0xf,%eax
  800a72:	7f 23                	jg     800a97 <vprintfmt+0x148>
  800a74:	8b 14 85 00 2d 80 00 	mov    0x802d00(,%eax,4),%edx
  800a7b:	85 d2                	test   %edx,%edx
  800a7d:	74 18                	je     800a97 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800a7f:	52                   	push   %edx
  800a80:	68 5e 2e 80 00       	push   $0x802e5e
  800a85:	53                   	push   %ebx
  800a86:	56                   	push   %esi
  800a87:	e8 a6 fe ff ff       	call   800932 <printfmt>
  800a8c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800a8f:	89 7d 14             	mov    %edi,0x14(%ebp)
  800a92:	e9 fe 02 00 00       	jmp    800d95 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800a97:	50                   	push   %eax
  800a98:	68 db 29 80 00       	push   $0x8029db
  800a9d:	53                   	push   %ebx
  800a9e:	56                   	push   %esi
  800a9f:	e8 8e fe ff ff       	call   800932 <printfmt>
  800aa4:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800aa7:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800aaa:	e9 e6 02 00 00       	jmp    800d95 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800aaf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab2:	83 c0 04             	add    $0x4,%eax
  800ab5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800ab8:	8b 45 14             	mov    0x14(%ebp),%eax
  800abb:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800abd:	85 c9                	test   %ecx,%ecx
  800abf:	b8 d4 29 80 00       	mov    $0x8029d4,%eax
  800ac4:	0f 45 c1             	cmovne %ecx,%eax
  800ac7:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800aca:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ace:	7e 06                	jle    800ad6 <vprintfmt+0x187>
  800ad0:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800ad4:	75 0d                	jne    800ae3 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ad6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800ad9:	89 c7                	mov    %eax,%edi
  800adb:	03 45 e0             	add    -0x20(%ebp),%eax
  800ade:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800ae1:	eb 53                	jmp    800b36 <vprintfmt+0x1e7>
  800ae3:	83 ec 08             	sub    $0x8,%esp
  800ae6:	ff 75 d8             	pushl  -0x28(%ebp)
  800ae9:	50                   	push   %eax
  800aea:	e8 71 04 00 00       	call   800f60 <strnlen>
  800aef:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800af2:	29 c1                	sub    %eax,%ecx
  800af4:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800af7:	83 c4 10             	add    $0x10,%esp
  800afa:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800afc:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800b00:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800b03:	eb 0f                	jmp    800b14 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800b05:	83 ec 08             	sub    $0x8,%esp
  800b08:	53                   	push   %ebx
  800b09:	ff 75 e0             	pushl  -0x20(%ebp)
  800b0c:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800b0e:	83 ef 01             	sub    $0x1,%edi
  800b11:	83 c4 10             	add    $0x10,%esp
  800b14:	85 ff                	test   %edi,%edi
  800b16:	7f ed                	jg     800b05 <vprintfmt+0x1b6>
  800b18:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800b1b:	85 c9                	test   %ecx,%ecx
  800b1d:	b8 00 00 00 00       	mov    $0x0,%eax
  800b22:	0f 49 c1             	cmovns %ecx,%eax
  800b25:	29 c1                	sub    %eax,%ecx
  800b27:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800b2a:	eb aa                	jmp    800ad6 <vprintfmt+0x187>
					putch(ch, putdat);
  800b2c:	83 ec 08             	sub    $0x8,%esp
  800b2f:	53                   	push   %ebx
  800b30:	52                   	push   %edx
  800b31:	ff d6                	call   *%esi
  800b33:	83 c4 10             	add    $0x10,%esp
  800b36:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800b39:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b3b:	83 c7 01             	add    $0x1,%edi
  800b3e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800b42:	0f be d0             	movsbl %al,%edx
  800b45:	85 d2                	test   %edx,%edx
  800b47:	74 4b                	je     800b94 <vprintfmt+0x245>
  800b49:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800b4d:	78 06                	js     800b55 <vprintfmt+0x206>
  800b4f:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800b53:	78 1e                	js     800b73 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800b55:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800b59:	74 d1                	je     800b2c <vprintfmt+0x1dd>
  800b5b:	0f be c0             	movsbl %al,%eax
  800b5e:	83 e8 20             	sub    $0x20,%eax
  800b61:	83 f8 5e             	cmp    $0x5e,%eax
  800b64:	76 c6                	jbe    800b2c <vprintfmt+0x1dd>
					putch('?', putdat);
  800b66:	83 ec 08             	sub    $0x8,%esp
  800b69:	53                   	push   %ebx
  800b6a:	6a 3f                	push   $0x3f
  800b6c:	ff d6                	call   *%esi
  800b6e:	83 c4 10             	add    $0x10,%esp
  800b71:	eb c3                	jmp    800b36 <vprintfmt+0x1e7>
  800b73:	89 cf                	mov    %ecx,%edi
  800b75:	eb 0e                	jmp    800b85 <vprintfmt+0x236>
				putch(' ', putdat);
  800b77:	83 ec 08             	sub    $0x8,%esp
  800b7a:	53                   	push   %ebx
  800b7b:	6a 20                	push   $0x20
  800b7d:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800b7f:	83 ef 01             	sub    $0x1,%edi
  800b82:	83 c4 10             	add    $0x10,%esp
  800b85:	85 ff                	test   %edi,%edi
  800b87:	7f ee                	jg     800b77 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800b89:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800b8c:	89 45 14             	mov    %eax,0x14(%ebp)
  800b8f:	e9 01 02 00 00       	jmp    800d95 <vprintfmt+0x446>
  800b94:	89 cf                	mov    %ecx,%edi
  800b96:	eb ed                	jmp    800b85 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800b98:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800b9b:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800ba2:	e9 eb fd ff ff       	jmp    800992 <vprintfmt+0x43>
	if (lflag >= 2)
  800ba7:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800bab:	7f 21                	jg     800bce <vprintfmt+0x27f>
	else if (lflag)
  800bad:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800bb1:	74 68                	je     800c1b <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800bb3:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb6:	8b 00                	mov    (%eax),%eax
  800bb8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800bbb:	89 c1                	mov    %eax,%ecx
  800bbd:	c1 f9 1f             	sar    $0x1f,%ecx
  800bc0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800bc3:	8b 45 14             	mov    0x14(%ebp),%eax
  800bc6:	8d 40 04             	lea    0x4(%eax),%eax
  800bc9:	89 45 14             	mov    %eax,0x14(%ebp)
  800bcc:	eb 17                	jmp    800be5 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800bce:	8b 45 14             	mov    0x14(%ebp),%eax
  800bd1:	8b 50 04             	mov    0x4(%eax),%edx
  800bd4:	8b 00                	mov    (%eax),%eax
  800bd6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800bd9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800bdc:	8b 45 14             	mov    0x14(%ebp),%eax
  800bdf:	8d 40 08             	lea    0x8(%eax),%eax
  800be2:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800be5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800be8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800beb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bee:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800bf1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800bf5:	78 3f                	js     800c36 <vprintfmt+0x2e7>
			base = 10;
  800bf7:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800bfc:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800c00:	0f 84 71 01 00 00    	je     800d77 <vprintfmt+0x428>
				putch('+', putdat);
  800c06:	83 ec 08             	sub    $0x8,%esp
  800c09:	53                   	push   %ebx
  800c0a:	6a 2b                	push   $0x2b
  800c0c:	ff d6                	call   *%esi
  800c0e:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800c11:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c16:	e9 5c 01 00 00       	jmp    800d77 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800c1b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c1e:	8b 00                	mov    (%eax),%eax
  800c20:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800c23:	89 c1                	mov    %eax,%ecx
  800c25:	c1 f9 1f             	sar    $0x1f,%ecx
  800c28:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800c2b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c2e:	8d 40 04             	lea    0x4(%eax),%eax
  800c31:	89 45 14             	mov    %eax,0x14(%ebp)
  800c34:	eb af                	jmp    800be5 <vprintfmt+0x296>
				putch('-', putdat);
  800c36:	83 ec 08             	sub    $0x8,%esp
  800c39:	53                   	push   %ebx
  800c3a:	6a 2d                	push   $0x2d
  800c3c:	ff d6                	call   *%esi
				num = -(long long) num;
  800c3e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800c41:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800c44:	f7 d8                	neg    %eax
  800c46:	83 d2 00             	adc    $0x0,%edx
  800c49:	f7 da                	neg    %edx
  800c4b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c4e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c51:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800c54:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c59:	e9 19 01 00 00       	jmp    800d77 <vprintfmt+0x428>
	if (lflag >= 2)
  800c5e:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800c62:	7f 29                	jg     800c8d <vprintfmt+0x33e>
	else if (lflag)
  800c64:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800c68:	74 44                	je     800cae <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800c6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6d:	8b 00                	mov    (%eax),%eax
  800c6f:	ba 00 00 00 00       	mov    $0x0,%edx
  800c74:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c77:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c7a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c7d:	8d 40 04             	lea    0x4(%eax),%eax
  800c80:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800c83:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c88:	e9 ea 00 00 00       	jmp    800d77 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800c8d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c90:	8b 50 04             	mov    0x4(%eax),%edx
  800c93:	8b 00                	mov    (%eax),%eax
  800c95:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c98:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c9b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c9e:	8d 40 08             	lea    0x8(%eax),%eax
  800ca1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800ca4:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ca9:	e9 c9 00 00 00       	jmp    800d77 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800cae:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb1:	8b 00                	mov    (%eax),%eax
  800cb3:	ba 00 00 00 00       	mov    $0x0,%edx
  800cb8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800cbb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800cbe:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc1:	8d 40 04             	lea    0x4(%eax),%eax
  800cc4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800cc7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ccc:	e9 a6 00 00 00       	jmp    800d77 <vprintfmt+0x428>
			putch('0', putdat);
  800cd1:	83 ec 08             	sub    $0x8,%esp
  800cd4:	53                   	push   %ebx
  800cd5:	6a 30                	push   $0x30
  800cd7:	ff d6                	call   *%esi
	if (lflag >= 2)
  800cd9:	83 c4 10             	add    $0x10,%esp
  800cdc:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800ce0:	7f 26                	jg     800d08 <vprintfmt+0x3b9>
	else if (lflag)
  800ce2:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800ce6:	74 3e                	je     800d26 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800ce8:	8b 45 14             	mov    0x14(%ebp),%eax
  800ceb:	8b 00                	mov    (%eax),%eax
  800ced:	ba 00 00 00 00       	mov    $0x0,%edx
  800cf2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800cf5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800cf8:	8b 45 14             	mov    0x14(%ebp),%eax
  800cfb:	8d 40 04             	lea    0x4(%eax),%eax
  800cfe:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800d01:	b8 08 00 00 00       	mov    $0x8,%eax
  800d06:	eb 6f                	jmp    800d77 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800d08:	8b 45 14             	mov    0x14(%ebp),%eax
  800d0b:	8b 50 04             	mov    0x4(%eax),%edx
  800d0e:	8b 00                	mov    (%eax),%eax
  800d10:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d13:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800d16:	8b 45 14             	mov    0x14(%ebp),%eax
  800d19:	8d 40 08             	lea    0x8(%eax),%eax
  800d1c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800d1f:	b8 08 00 00 00       	mov    $0x8,%eax
  800d24:	eb 51                	jmp    800d77 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800d26:	8b 45 14             	mov    0x14(%ebp),%eax
  800d29:	8b 00                	mov    (%eax),%eax
  800d2b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d30:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d33:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800d36:	8b 45 14             	mov    0x14(%ebp),%eax
  800d39:	8d 40 04             	lea    0x4(%eax),%eax
  800d3c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800d3f:	b8 08 00 00 00       	mov    $0x8,%eax
  800d44:	eb 31                	jmp    800d77 <vprintfmt+0x428>
			putch('0', putdat);
  800d46:	83 ec 08             	sub    $0x8,%esp
  800d49:	53                   	push   %ebx
  800d4a:	6a 30                	push   $0x30
  800d4c:	ff d6                	call   *%esi
			putch('x', putdat);
  800d4e:	83 c4 08             	add    $0x8,%esp
  800d51:	53                   	push   %ebx
  800d52:	6a 78                	push   $0x78
  800d54:	ff d6                	call   *%esi
			num = (unsigned long long)
  800d56:	8b 45 14             	mov    0x14(%ebp),%eax
  800d59:	8b 00                	mov    (%eax),%eax
  800d5b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d60:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d63:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800d66:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800d69:	8b 45 14             	mov    0x14(%ebp),%eax
  800d6c:	8d 40 04             	lea    0x4(%eax),%eax
  800d6f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800d72:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800d77:	83 ec 0c             	sub    $0xc,%esp
  800d7a:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800d7e:	52                   	push   %edx
  800d7f:	ff 75 e0             	pushl  -0x20(%ebp)
  800d82:	50                   	push   %eax
  800d83:	ff 75 dc             	pushl  -0x24(%ebp)
  800d86:	ff 75 d8             	pushl  -0x28(%ebp)
  800d89:	89 da                	mov    %ebx,%edx
  800d8b:	89 f0                	mov    %esi,%eax
  800d8d:	e8 a4 fa ff ff       	call   800836 <printnum>
			break;
  800d92:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800d95:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d98:	83 c7 01             	add    $0x1,%edi
  800d9b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800d9f:	83 f8 25             	cmp    $0x25,%eax
  800da2:	0f 84 be fb ff ff    	je     800966 <vprintfmt+0x17>
			if (ch == '\0')
  800da8:	85 c0                	test   %eax,%eax
  800daa:	0f 84 28 01 00 00    	je     800ed8 <vprintfmt+0x589>
			putch(ch, putdat);
  800db0:	83 ec 08             	sub    $0x8,%esp
  800db3:	53                   	push   %ebx
  800db4:	50                   	push   %eax
  800db5:	ff d6                	call   *%esi
  800db7:	83 c4 10             	add    $0x10,%esp
  800dba:	eb dc                	jmp    800d98 <vprintfmt+0x449>
	if (lflag >= 2)
  800dbc:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800dc0:	7f 26                	jg     800de8 <vprintfmt+0x499>
	else if (lflag)
  800dc2:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800dc6:	74 41                	je     800e09 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800dc8:	8b 45 14             	mov    0x14(%ebp),%eax
  800dcb:	8b 00                	mov    (%eax),%eax
  800dcd:	ba 00 00 00 00       	mov    $0x0,%edx
  800dd2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800dd5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800dd8:	8b 45 14             	mov    0x14(%ebp),%eax
  800ddb:	8d 40 04             	lea    0x4(%eax),%eax
  800dde:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800de1:	b8 10 00 00 00       	mov    $0x10,%eax
  800de6:	eb 8f                	jmp    800d77 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800de8:	8b 45 14             	mov    0x14(%ebp),%eax
  800deb:	8b 50 04             	mov    0x4(%eax),%edx
  800dee:	8b 00                	mov    (%eax),%eax
  800df0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800df3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800df6:	8b 45 14             	mov    0x14(%ebp),%eax
  800df9:	8d 40 08             	lea    0x8(%eax),%eax
  800dfc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800dff:	b8 10 00 00 00       	mov    $0x10,%eax
  800e04:	e9 6e ff ff ff       	jmp    800d77 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800e09:	8b 45 14             	mov    0x14(%ebp),%eax
  800e0c:	8b 00                	mov    (%eax),%eax
  800e0e:	ba 00 00 00 00       	mov    $0x0,%edx
  800e13:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800e16:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800e19:	8b 45 14             	mov    0x14(%ebp),%eax
  800e1c:	8d 40 04             	lea    0x4(%eax),%eax
  800e1f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800e22:	b8 10 00 00 00       	mov    $0x10,%eax
  800e27:	e9 4b ff ff ff       	jmp    800d77 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800e2c:	8b 45 14             	mov    0x14(%ebp),%eax
  800e2f:	83 c0 04             	add    $0x4,%eax
  800e32:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800e35:	8b 45 14             	mov    0x14(%ebp),%eax
  800e38:	8b 00                	mov    (%eax),%eax
  800e3a:	85 c0                	test   %eax,%eax
  800e3c:	74 14                	je     800e52 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800e3e:	8b 13                	mov    (%ebx),%edx
  800e40:	83 fa 7f             	cmp    $0x7f,%edx
  800e43:	7f 37                	jg     800e7c <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800e45:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800e47:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800e4a:	89 45 14             	mov    %eax,0x14(%ebp)
  800e4d:	e9 43 ff ff ff       	jmp    800d95 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800e52:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e57:	bf f9 2a 80 00       	mov    $0x802af9,%edi
							putch(ch, putdat);
  800e5c:	83 ec 08             	sub    $0x8,%esp
  800e5f:	53                   	push   %ebx
  800e60:	50                   	push   %eax
  800e61:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800e63:	83 c7 01             	add    $0x1,%edi
  800e66:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800e6a:	83 c4 10             	add    $0x10,%esp
  800e6d:	85 c0                	test   %eax,%eax
  800e6f:	75 eb                	jne    800e5c <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800e71:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800e74:	89 45 14             	mov    %eax,0x14(%ebp)
  800e77:	e9 19 ff ff ff       	jmp    800d95 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800e7c:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800e7e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e83:	bf 31 2b 80 00       	mov    $0x802b31,%edi
							putch(ch, putdat);
  800e88:	83 ec 08             	sub    $0x8,%esp
  800e8b:	53                   	push   %ebx
  800e8c:	50                   	push   %eax
  800e8d:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800e8f:	83 c7 01             	add    $0x1,%edi
  800e92:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800e96:	83 c4 10             	add    $0x10,%esp
  800e99:	85 c0                	test   %eax,%eax
  800e9b:	75 eb                	jne    800e88 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800e9d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800ea0:	89 45 14             	mov    %eax,0x14(%ebp)
  800ea3:	e9 ed fe ff ff       	jmp    800d95 <vprintfmt+0x446>
			putch(ch, putdat);
  800ea8:	83 ec 08             	sub    $0x8,%esp
  800eab:	53                   	push   %ebx
  800eac:	6a 25                	push   $0x25
  800eae:	ff d6                	call   *%esi
			break;
  800eb0:	83 c4 10             	add    $0x10,%esp
  800eb3:	e9 dd fe ff ff       	jmp    800d95 <vprintfmt+0x446>
			putch('%', putdat);
  800eb8:	83 ec 08             	sub    $0x8,%esp
  800ebb:	53                   	push   %ebx
  800ebc:	6a 25                	push   $0x25
  800ebe:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ec0:	83 c4 10             	add    $0x10,%esp
  800ec3:	89 f8                	mov    %edi,%eax
  800ec5:	eb 03                	jmp    800eca <vprintfmt+0x57b>
  800ec7:	83 e8 01             	sub    $0x1,%eax
  800eca:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800ece:	75 f7                	jne    800ec7 <vprintfmt+0x578>
  800ed0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ed3:	e9 bd fe ff ff       	jmp    800d95 <vprintfmt+0x446>
}
  800ed8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800edb:	5b                   	pop    %ebx
  800edc:	5e                   	pop    %esi
  800edd:	5f                   	pop    %edi
  800ede:	5d                   	pop    %ebp
  800edf:	c3                   	ret    

00800ee0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ee0:	55                   	push   %ebp
  800ee1:	89 e5                	mov    %esp,%ebp
  800ee3:	83 ec 18             	sub    $0x18,%esp
  800ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee9:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800eec:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800eef:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800ef3:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800ef6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800efd:	85 c0                	test   %eax,%eax
  800eff:	74 26                	je     800f27 <vsnprintf+0x47>
  800f01:	85 d2                	test   %edx,%edx
  800f03:	7e 22                	jle    800f27 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800f05:	ff 75 14             	pushl  0x14(%ebp)
  800f08:	ff 75 10             	pushl  0x10(%ebp)
  800f0b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800f0e:	50                   	push   %eax
  800f0f:	68 15 09 80 00       	push   $0x800915
  800f14:	e8 36 fa ff ff       	call   80094f <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800f19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f1c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800f1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f22:	83 c4 10             	add    $0x10,%esp
}
  800f25:	c9                   	leave  
  800f26:	c3                   	ret    
		return -E_INVAL;
  800f27:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f2c:	eb f7                	jmp    800f25 <vsnprintf+0x45>

00800f2e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f2e:	55                   	push   %ebp
  800f2f:	89 e5                	mov    %esp,%ebp
  800f31:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800f34:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800f37:	50                   	push   %eax
  800f38:	ff 75 10             	pushl  0x10(%ebp)
  800f3b:	ff 75 0c             	pushl  0xc(%ebp)
  800f3e:	ff 75 08             	pushl  0x8(%ebp)
  800f41:	e8 9a ff ff ff       	call   800ee0 <vsnprintf>
	va_end(ap);

	return rc;
}
  800f46:	c9                   	leave  
  800f47:	c3                   	ret    

00800f48 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800f48:	55                   	push   %ebp
  800f49:	89 e5                	mov    %esp,%ebp
  800f4b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800f4e:	b8 00 00 00 00       	mov    $0x0,%eax
  800f53:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800f57:	74 05                	je     800f5e <strlen+0x16>
		n++;
  800f59:	83 c0 01             	add    $0x1,%eax
  800f5c:	eb f5                	jmp    800f53 <strlen+0xb>
	return n;
}
  800f5e:	5d                   	pop    %ebp
  800f5f:	c3                   	ret    

00800f60 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800f60:	55                   	push   %ebp
  800f61:	89 e5                	mov    %esp,%ebp
  800f63:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f66:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f69:	ba 00 00 00 00       	mov    $0x0,%edx
  800f6e:	39 c2                	cmp    %eax,%edx
  800f70:	74 0d                	je     800f7f <strnlen+0x1f>
  800f72:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800f76:	74 05                	je     800f7d <strnlen+0x1d>
		n++;
  800f78:	83 c2 01             	add    $0x1,%edx
  800f7b:	eb f1                	jmp    800f6e <strnlen+0xe>
  800f7d:	89 d0                	mov    %edx,%eax
	return n;
}
  800f7f:	5d                   	pop    %ebp
  800f80:	c3                   	ret    

00800f81 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f81:	55                   	push   %ebp
  800f82:	89 e5                	mov    %esp,%ebp
  800f84:	53                   	push   %ebx
  800f85:	8b 45 08             	mov    0x8(%ebp),%eax
  800f88:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800f8b:	ba 00 00 00 00       	mov    $0x0,%edx
  800f90:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800f94:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800f97:	83 c2 01             	add    $0x1,%edx
  800f9a:	84 c9                	test   %cl,%cl
  800f9c:	75 f2                	jne    800f90 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800f9e:	5b                   	pop    %ebx
  800f9f:	5d                   	pop    %ebp
  800fa0:	c3                   	ret    

00800fa1 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800fa1:	55                   	push   %ebp
  800fa2:	89 e5                	mov    %esp,%ebp
  800fa4:	53                   	push   %ebx
  800fa5:	83 ec 10             	sub    $0x10,%esp
  800fa8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800fab:	53                   	push   %ebx
  800fac:	e8 97 ff ff ff       	call   800f48 <strlen>
  800fb1:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800fb4:	ff 75 0c             	pushl  0xc(%ebp)
  800fb7:	01 d8                	add    %ebx,%eax
  800fb9:	50                   	push   %eax
  800fba:	e8 c2 ff ff ff       	call   800f81 <strcpy>
	return dst;
}
  800fbf:	89 d8                	mov    %ebx,%eax
  800fc1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fc4:	c9                   	leave  
  800fc5:	c3                   	ret    

00800fc6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800fc6:	55                   	push   %ebp
  800fc7:	89 e5                	mov    %esp,%ebp
  800fc9:	56                   	push   %esi
  800fca:	53                   	push   %ebx
  800fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd1:	89 c6                	mov    %eax,%esi
  800fd3:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800fd6:	89 c2                	mov    %eax,%edx
  800fd8:	39 f2                	cmp    %esi,%edx
  800fda:	74 11                	je     800fed <strncpy+0x27>
		*dst++ = *src;
  800fdc:	83 c2 01             	add    $0x1,%edx
  800fdf:	0f b6 19             	movzbl (%ecx),%ebx
  800fe2:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800fe5:	80 fb 01             	cmp    $0x1,%bl
  800fe8:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800feb:	eb eb                	jmp    800fd8 <strncpy+0x12>
	}
	return ret;
}
  800fed:	5b                   	pop    %ebx
  800fee:	5e                   	pop    %esi
  800fef:	5d                   	pop    %ebp
  800ff0:	c3                   	ret    

00800ff1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ff1:	55                   	push   %ebp
  800ff2:	89 e5                	mov    %esp,%ebp
  800ff4:	56                   	push   %esi
  800ff5:	53                   	push   %ebx
  800ff6:	8b 75 08             	mov    0x8(%ebp),%esi
  800ff9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ffc:	8b 55 10             	mov    0x10(%ebp),%edx
  800fff:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801001:	85 d2                	test   %edx,%edx
  801003:	74 21                	je     801026 <strlcpy+0x35>
  801005:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  801009:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80100b:	39 c2                	cmp    %eax,%edx
  80100d:	74 14                	je     801023 <strlcpy+0x32>
  80100f:	0f b6 19             	movzbl (%ecx),%ebx
  801012:	84 db                	test   %bl,%bl
  801014:	74 0b                	je     801021 <strlcpy+0x30>
			*dst++ = *src++;
  801016:	83 c1 01             	add    $0x1,%ecx
  801019:	83 c2 01             	add    $0x1,%edx
  80101c:	88 5a ff             	mov    %bl,-0x1(%edx)
  80101f:	eb ea                	jmp    80100b <strlcpy+0x1a>
  801021:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801023:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801026:	29 f0                	sub    %esi,%eax
}
  801028:	5b                   	pop    %ebx
  801029:	5e                   	pop    %esi
  80102a:	5d                   	pop    %ebp
  80102b:	c3                   	ret    

0080102c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80102c:	55                   	push   %ebp
  80102d:	89 e5                	mov    %esp,%ebp
  80102f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801032:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801035:	0f b6 01             	movzbl (%ecx),%eax
  801038:	84 c0                	test   %al,%al
  80103a:	74 0c                	je     801048 <strcmp+0x1c>
  80103c:	3a 02                	cmp    (%edx),%al
  80103e:	75 08                	jne    801048 <strcmp+0x1c>
		p++, q++;
  801040:	83 c1 01             	add    $0x1,%ecx
  801043:	83 c2 01             	add    $0x1,%edx
  801046:	eb ed                	jmp    801035 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801048:	0f b6 c0             	movzbl %al,%eax
  80104b:	0f b6 12             	movzbl (%edx),%edx
  80104e:	29 d0                	sub    %edx,%eax
}
  801050:	5d                   	pop    %ebp
  801051:	c3                   	ret    

00801052 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801052:	55                   	push   %ebp
  801053:	89 e5                	mov    %esp,%ebp
  801055:	53                   	push   %ebx
  801056:	8b 45 08             	mov    0x8(%ebp),%eax
  801059:	8b 55 0c             	mov    0xc(%ebp),%edx
  80105c:	89 c3                	mov    %eax,%ebx
  80105e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801061:	eb 06                	jmp    801069 <strncmp+0x17>
		n--, p++, q++;
  801063:	83 c0 01             	add    $0x1,%eax
  801066:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801069:	39 d8                	cmp    %ebx,%eax
  80106b:	74 16                	je     801083 <strncmp+0x31>
  80106d:	0f b6 08             	movzbl (%eax),%ecx
  801070:	84 c9                	test   %cl,%cl
  801072:	74 04                	je     801078 <strncmp+0x26>
  801074:	3a 0a                	cmp    (%edx),%cl
  801076:	74 eb                	je     801063 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801078:	0f b6 00             	movzbl (%eax),%eax
  80107b:	0f b6 12             	movzbl (%edx),%edx
  80107e:	29 d0                	sub    %edx,%eax
}
  801080:	5b                   	pop    %ebx
  801081:	5d                   	pop    %ebp
  801082:	c3                   	ret    
		return 0;
  801083:	b8 00 00 00 00       	mov    $0x0,%eax
  801088:	eb f6                	jmp    801080 <strncmp+0x2e>

0080108a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80108a:	55                   	push   %ebp
  80108b:	89 e5                	mov    %esp,%ebp
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
  801090:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801094:	0f b6 10             	movzbl (%eax),%edx
  801097:	84 d2                	test   %dl,%dl
  801099:	74 09                	je     8010a4 <strchr+0x1a>
		if (*s == c)
  80109b:	38 ca                	cmp    %cl,%dl
  80109d:	74 0a                	je     8010a9 <strchr+0x1f>
	for (; *s; s++)
  80109f:	83 c0 01             	add    $0x1,%eax
  8010a2:	eb f0                	jmp    801094 <strchr+0xa>
			return (char *) s;
	return 0;
  8010a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010a9:	5d                   	pop    %ebp
  8010aa:	c3                   	ret    

008010ab <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8010ab:	55                   	push   %ebp
  8010ac:	89 e5                	mov    %esp,%ebp
  8010ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8010b5:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8010b8:	38 ca                	cmp    %cl,%dl
  8010ba:	74 09                	je     8010c5 <strfind+0x1a>
  8010bc:	84 d2                	test   %dl,%dl
  8010be:	74 05                	je     8010c5 <strfind+0x1a>
	for (; *s; s++)
  8010c0:	83 c0 01             	add    $0x1,%eax
  8010c3:	eb f0                	jmp    8010b5 <strfind+0xa>
			break;
	return (char *) s;
}
  8010c5:	5d                   	pop    %ebp
  8010c6:	c3                   	ret    

008010c7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8010c7:	55                   	push   %ebp
  8010c8:	89 e5                	mov    %esp,%ebp
  8010ca:	57                   	push   %edi
  8010cb:	56                   	push   %esi
  8010cc:	53                   	push   %ebx
  8010cd:	8b 7d 08             	mov    0x8(%ebp),%edi
  8010d0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8010d3:	85 c9                	test   %ecx,%ecx
  8010d5:	74 31                	je     801108 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8010d7:	89 f8                	mov    %edi,%eax
  8010d9:	09 c8                	or     %ecx,%eax
  8010db:	a8 03                	test   $0x3,%al
  8010dd:	75 23                	jne    801102 <memset+0x3b>
		c &= 0xFF;
  8010df:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8010e3:	89 d3                	mov    %edx,%ebx
  8010e5:	c1 e3 08             	shl    $0x8,%ebx
  8010e8:	89 d0                	mov    %edx,%eax
  8010ea:	c1 e0 18             	shl    $0x18,%eax
  8010ed:	89 d6                	mov    %edx,%esi
  8010ef:	c1 e6 10             	shl    $0x10,%esi
  8010f2:	09 f0                	or     %esi,%eax
  8010f4:	09 c2                	or     %eax,%edx
  8010f6:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8010f8:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8010fb:	89 d0                	mov    %edx,%eax
  8010fd:	fc                   	cld    
  8010fe:	f3 ab                	rep stos %eax,%es:(%edi)
  801100:	eb 06                	jmp    801108 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801102:	8b 45 0c             	mov    0xc(%ebp),%eax
  801105:	fc                   	cld    
  801106:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801108:	89 f8                	mov    %edi,%eax
  80110a:	5b                   	pop    %ebx
  80110b:	5e                   	pop    %esi
  80110c:	5f                   	pop    %edi
  80110d:	5d                   	pop    %ebp
  80110e:	c3                   	ret    

0080110f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80110f:	55                   	push   %ebp
  801110:	89 e5                	mov    %esp,%ebp
  801112:	57                   	push   %edi
  801113:	56                   	push   %esi
  801114:	8b 45 08             	mov    0x8(%ebp),%eax
  801117:	8b 75 0c             	mov    0xc(%ebp),%esi
  80111a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80111d:	39 c6                	cmp    %eax,%esi
  80111f:	73 32                	jae    801153 <memmove+0x44>
  801121:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801124:	39 c2                	cmp    %eax,%edx
  801126:	76 2b                	jbe    801153 <memmove+0x44>
		s += n;
		d += n;
  801128:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80112b:	89 fe                	mov    %edi,%esi
  80112d:	09 ce                	or     %ecx,%esi
  80112f:	09 d6                	or     %edx,%esi
  801131:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801137:	75 0e                	jne    801147 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801139:	83 ef 04             	sub    $0x4,%edi
  80113c:	8d 72 fc             	lea    -0x4(%edx),%esi
  80113f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801142:	fd                   	std    
  801143:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801145:	eb 09                	jmp    801150 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801147:	83 ef 01             	sub    $0x1,%edi
  80114a:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  80114d:	fd                   	std    
  80114e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801150:	fc                   	cld    
  801151:	eb 1a                	jmp    80116d <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801153:	89 c2                	mov    %eax,%edx
  801155:	09 ca                	or     %ecx,%edx
  801157:	09 f2                	or     %esi,%edx
  801159:	f6 c2 03             	test   $0x3,%dl
  80115c:	75 0a                	jne    801168 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80115e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801161:	89 c7                	mov    %eax,%edi
  801163:	fc                   	cld    
  801164:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801166:	eb 05                	jmp    80116d <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  801168:	89 c7                	mov    %eax,%edi
  80116a:	fc                   	cld    
  80116b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80116d:	5e                   	pop    %esi
  80116e:	5f                   	pop    %edi
  80116f:	5d                   	pop    %ebp
  801170:	c3                   	ret    

00801171 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801171:	55                   	push   %ebp
  801172:	89 e5                	mov    %esp,%ebp
  801174:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801177:	ff 75 10             	pushl  0x10(%ebp)
  80117a:	ff 75 0c             	pushl  0xc(%ebp)
  80117d:	ff 75 08             	pushl  0x8(%ebp)
  801180:	e8 8a ff ff ff       	call   80110f <memmove>
}
  801185:	c9                   	leave  
  801186:	c3                   	ret    

00801187 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801187:	55                   	push   %ebp
  801188:	89 e5                	mov    %esp,%ebp
  80118a:	56                   	push   %esi
  80118b:	53                   	push   %ebx
  80118c:	8b 45 08             	mov    0x8(%ebp),%eax
  80118f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801192:	89 c6                	mov    %eax,%esi
  801194:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801197:	39 f0                	cmp    %esi,%eax
  801199:	74 1c                	je     8011b7 <memcmp+0x30>
		if (*s1 != *s2)
  80119b:	0f b6 08             	movzbl (%eax),%ecx
  80119e:	0f b6 1a             	movzbl (%edx),%ebx
  8011a1:	38 d9                	cmp    %bl,%cl
  8011a3:	75 08                	jne    8011ad <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8011a5:	83 c0 01             	add    $0x1,%eax
  8011a8:	83 c2 01             	add    $0x1,%edx
  8011ab:	eb ea                	jmp    801197 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8011ad:	0f b6 c1             	movzbl %cl,%eax
  8011b0:	0f b6 db             	movzbl %bl,%ebx
  8011b3:	29 d8                	sub    %ebx,%eax
  8011b5:	eb 05                	jmp    8011bc <memcmp+0x35>
	}

	return 0;
  8011b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011bc:	5b                   	pop    %ebx
  8011bd:	5e                   	pop    %esi
  8011be:	5d                   	pop    %ebp
  8011bf:	c3                   	ret    

008011c0 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8011c0:	55                   	push   %ebp
  8011c1:	89 e5                	mov    %esp,%ebp
  8011c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8011c9:	89 c2                	mov    %eax,%edx
  8011cb:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8011ce:	39 d0                	cmp    %edx,%eax
  8011d0:	73 09                	jae    8011db <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011d2:	38 08                	cmp    %cl,(%eax)
  8011d4:	74 05                	je     8011db <memfind+0x1b>
	for (; s < ends; s++)
  8011d6:	83 c0 01             	add    $0x1,%eax
  8011d9:	eb f3                	jmp    8011ce <memfind+0xe>
			break;
	return (void *) s;
}
  8011db:	5d                   	pop    %ebp
  8011dc:	c3                   	ret    

008011dd <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011dd:	55                   	push   %ebp
  8011de:	89 e5                	mov    %esp,%ebp
  8011e0:	57                   	push   %edi
  8011e1:	56                   	push   %esi
  8011e2:	53                   	push   %ebx
  8011e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011e6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011e9:	eb 03                	jmp    8011ee <strtol+0x11>
		s++;
  8011eb:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8011ee:	0f b6 01             	movzbl (%ecx),%eax
  8011f1:	3c 20                	cmp    $0x20,%al
  8011f3:	74 f6                	je     8011eb <strtol+0xe>
  8011f5:	3c 09                	cmp    $0x9,%al
  8011f7:	74 f2                	je     8011eb <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  8011f9:	3c 2b                	cmp    $0x2b,%al
  8011fb:	74 2a                	je     801227 <strtol+0x4a>
	int neg = 0;
  8011fd:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801202:	3c 2d                	cmp    $0x2d,%al
  801204:	74 2b                	je     801231 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801206:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  80120c:	75 0f                	jne    80121d <strtol+0x40>
  80120e:	80 39 30             	cmpb   $0x30,(%ecx)
  801211:	74 28                	je     80123b <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801213:	85 db                	test   %ebx,%ebx
  801215:	b8 0a 00 00 00       	mov    $0xa,%eax
  80121a:	0f 44 d8             	cmove  %eax,%ebx
  80121d:	b8 00 00 00 00       	mov    $0x0,%eax
  801222:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801225:	eb 50                	jmp    801277 <strtol+0x9a>
		s++;
  801227:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  80122a:	bf 00 00 00 00       	mov    $0x0,%edi
  80122f:	eb d5                	jmp    801206 <strtol+0x29>
		s++, neg = 1;
  801231:	83 c1 01             	add    $0x1,%ecx
  801234:	bf 01 00 00 00       	mov    $0x1,%edi
  801239:	eb cb                	jmp    801206 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80123b:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  80123f:	74 0e                	je     80124f <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  801241:	85 db                	test   %ebx,%ebx
  801243:	75 d8                	jne    80121d <strtol+0x40>
		s++, base = 8;
  801245:	83 c1 01             	add    $0x1,%ecx
  801248:	bb 08 00 00 00       	mov    $0x8,%ebx
  80124d:	eb ce                	jmp    80121d <strtol+0x40>
		s += 2, base = 16;
  80124f:	83 c1 02             	add    $0x2,%ecx
  801252:	bb 10 00 00 00       	mov    $0x10,%ebx
  801257:	eb c4                	jmp    80121d <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801259:	8d 72 9f             	lea    -0x61(%edx),%esi
  80125c:	89 f3                	mov    %esi,%ebx
  80125e:	80 fb 19             	cmp    $0x19,%bl
  801261:	77 29                	ja     80128c <strtol+0xaf>
			dig = *s - 'a' + 10;
  801263:	0f be d2             	movsbl %dl,%edx
  801266:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801269:	3b 55 10             	cmp    0x10(%ebp),%edx
  80126c:	7d 30                	jge    80129e <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  80126e:	83 c1 01             	add    $0x1,%ecx
  801271:	0f af 45 10          	imul   0x10(%ebp),%eax
  801275:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801277:	0f b6 11             	movzbl (%ecx),%edx
  80127a:	8d 72 d0             	lea    -0x30(%edx),%esi
  80127d:	89 f3                	mov    %esi,%ebx
  80127f:	80 fb 09             	cmp    $0x9,%bl
  801282:	77 d5                	ja     801259 <strtol+0x7c>
			dig = *s - '0';
  801284:	0f be d2             	movsbl %dl,%edx
  801287:	83 ea 30             	sub    $0x30,%edx
  80128a:	eb dd                	jmp    801269 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  80128c:	8d 72 bf             	lea    -0x41(%edx),%esi
  80128f:	89 f3                	mov    %esi,%ebx
  801291:	80 fb 19             	cmp    $0x19,%bl
  801294:	77 08                	ja     80129e <strtol+0xc1>
			dig = *s - 'A' + 10;
  801296:	0f be d2             	movsbl %dl,%edx
  801299:	83 ea 37             	sub    $0x37,%edx
  80129c:	eb cb                	jmp    801269 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  80129e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012a2:	74 05                	je     8012a9 <strtol+0xcc>
		*endptr = (char *) s;
  8012a4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012a7:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  8012a9:	89 c2                	mov    %eax,%edx
  8012ab:	f7 da                	neg    %edx
  8012ad:	85 ff                	test   %edi,%edi
  8012af:	0f 45 c2             	cmovne %edx,%eax
}
  8012b2:	5b                   	pop    %ebx
  8012b3:	5e                   	pop    %esi
  8012b4:	5f                   	pop    %edi
  8012b5:	5d                   	pop    %ebp
  8012b6:	c3                   	ret    

008012b7 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8012b7:	55                   	push   %ebp
  8012b8:	89 e5                	mov    %esp,%ebp
  8012ba:	57                   	push   %edi
  8012bb:	56                   	push   %esi
  8012bc:	53                   	push   %ebx
	asm volatile("int %1\n"
  8012bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8012c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8012c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012c8:	89 c3                	mov    %eax,%ebx
  8012ca:	89 c7                	mov    %eax,%edi
  8012cc:	89 c6                	mov    %eax,%esi
  8012ce:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8012d0:	5b                   	pop    %ebx
  8012d1:	5e                   	pop    %esi
  8012d2:	5f                   	pop    %edi
  8012d3:	5d                   	pop    %ebp
  8012d4:	c3                   	ret    

008012d5 <sys_cgetc>:

int
sys_cgetc(void)
{
  8012d5:	55                   	push   %ebp
  8012d6:	89 e5                	mov    %esp,%ebp
  8012d8:	57                   	push   %edi
  8012d9:	56                   	push   %esi
  8012da:	53                   	push   %ebx
	asm volatile("int %1\n"
  8012db:	ba 00 00 00 00       	mov    $0x0,%edx
  8012e0:	b8 01 00 00 00       	mov    $0x1,%eax
  8012e5:	89 d1                	mov    %edx,%ecx
  8012e7:	89 d3                	mov    %edx,%ebx
  8012e9:	89 d7                	mov    %edx,%edi
  8012eb:	89 d6                	mov    %edx,%esi
  8012ed:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8012ef:	5b                   	pop    %ebx
  8012f0:	5e                   	pop    %esi
  8012f1:	5f                   	pop    %edi
  8012f2:	5d                   	pop    %ebp
  8012f3:	c3                   	ret    

008012f4 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8012f4:	55                   	push   %ebp
  8012f5:	89 e5                	mov    %esp,%ebp
  8012f7:	57                   	push   %edi
  8012f8:	56                   	push   %esi
  8012f9:	53                   	push   %ebx
  8012fa:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012fd:	b9 00 00 00 00       	mov    $0x0,%ecx
  801302:	8b 55 08             	mov    0x8(%ebp),%edx
  801305:	b8 03 00 00 00       	mov    $0x3,%eax
  80130a:	89 cb                	mov    %ecx,%ebx
  80130c:	89 cf                	mov    %ecx,%edi
  80130e:	89 ce                	mov    %ecx,%esi
  801310:	cd 30                	int    $0x30
	if(check && ret > 0)
  801312:	85 c0                	test   %eax,%eax
  801314:	7f 08                	jg     80131e <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801316:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801319:	5b                   	pop    %ebx
  80131a:	5e                   	pop    %esi
  80131b:	5f                   	pop    %edi
  80131c:	5d                   	pop    %ebp
  80131d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80131e:	83 ec 0c             	sub    $0xc,%esp
  801321:	50                   	push   %eax
  801322:	6a 03                	push   $0x3
  801324:	68 40 2d 80 00       	push   $0x802d40
  801329:	6a 43                	push   $0x43
  80132b:	68 5d 2d 80 00       	push   $0x802d5d
  801330:	e8 f7 f3 ff ff       	call   80072c <_panic>

00801335 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801335:	55                   	push   %ebp
  801336:	89 e5                	mov    %esp,%ebp
  801338:	57                   	push   %edi
  801339:	56                   	push   %esi
  80133a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80133b:	ba 00 00 00 00       	mov    $0x0,%edx
  801340:	b8 02 00 00 00       	mov    $0x2,%eax
  801345:	89 d1                	mov    %edx,%ecx
  801347:	89 d3                	mov    %edx,%ebx
  801349:	89 d7                	mov    %edx,%edi
  80134b:	89 d6                	mov    %edx,%esi
  80134d:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80134f:	5b                   	pop    %ebx
  801350:	5e                   	pop    %esi
  801351:	5f                   	pop    %edi
  801352:	5d                   	pop    %ebp
  801353:	c3                   	ret    

00801354 <sys_yield>:

void
sys_yield(void)
{
  801354:	55                   	push   %ebp
  801355:	89 e5                	mov    %esp,%ebp
  801357:	57                   	push   %edi
  801358:	56                   	push   %esi
  801359:	53                   	push   %ebx
	asm volatile("int %1\n"
  80135a:	ba 00 00 00 00       	mov    $0x0,%edx
  80135f:	b8 0b 00 00 00       	mov    $0xb,%eax
  801364:	89 d1                	mov    %edx,%ecx
  801366:	89 d3                	mov    %edx,%ebx
  801368:	89 d7                	mov    %edx,%edi
  80136a:	89 d6                	mov    %edx,%esi
  80136c:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80136e:	5b                   	pop    %ebx
  80136f:	5e                   	pop    %esi
  801370:	5f                   	pop    %edi
  801371:	5d                   	pop    %ebp
  801372:	c3                   	ret    

00801373 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801373:	55                   	push   %ebp
  801374:	89 e5                	mov    %esp,%ebp
  801376:	57                   	push   %edi
  801377:	56                   	push   %esi
  801378:	53                   	push   %ebx
  801379:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80137c:	be 00 00 00 00       	mov    $0x0,%esi
  801381:	8b 55 08             	mov    0x8(%ebp),%edx
  801384:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801387:	b8 04 00 00 00       	mov    $0x4,%eax
  80138c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80138f:	89 f7                	mov    %esi,%edi
  801391:	cd 30                	int    $0x30
	if(check && ret > 0)
  801393:	85 c0                	test   %eax,%eax
  801395:	7f 08                	jg     80139f <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801397:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80139a:	5b                   	pop    %ebx
  80139b:	5e                   	pop    %esi
  80139c:	5f                   	pop    %edi
  80139d:	5d                   	pop    %ebp
  80139e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80139f:	83 ec 0c             	sub    $0xc,%esp
  8013a2:	50                   	push   %eax
  8013a3:	6a 04                	push   $0x4
  8013a5:	68 40 2d 80 00       	push   $0x802d40
  8013aa:	6a 43                	push   $0x43
  8013ac:	68 5d 2d 80 00       	push   $0x802d5d
  8013b1:	e8 76 f3 ff ff       	call   80072c <_panic>

008013b6 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8013b6:	55                   	push   %ebp
  8013b7:	89 e5                	mov    %esp,%ebp
  8013b9:	57                   	push   %edi
  8013ba:	56                   	push   %esi
  8013bb:	53                   	push   %ebx
  8013bc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8013bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8013c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013c5:	b8 05 00 00 00       	mov    $0x5,%eax
  8013ca:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8013cd:	8b 7d 14             	mov    0x14(%ebp),%edi
  8013d0:	8b 75 18             	mov    0x18(%ebp),%esi
  8013d3:	cd 30                	int    $0x30
	if(check && ret > 0)
  8013d5:	85 c0                	test   %eax,%eax
  8013d7:	7f 08                	jg     8013e1 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8013d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013dc:	5b                   	pop    %ebx
  8013dd:	5e                   	pop    %esi
  8013de:	5f                   	pop    %edi
  8013df:	5d                   	pop    %ebp
  8013e0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8013e1:	83 ec 0c             	sub    $0xc,%esp
  8013e4:	50                   	push   %eax
  8013e5:	6a 05                	push   $0x5
  8013e7:	68 40 2d 80 00       	push   $0x802d40
  8013ec:	6a 43                	push   $0x43
  8013ee:	68 5d 2d 80 00       	push   $0x802d5d
  8013f3:	e8 34 f3 ff ff       	call   80072c <_panic>

008013f8 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8013f8:	55                   	push   %ebp
  8013f9:	89 e5                	mov    %esp,%ebp
  8013fb:	57                   	push   %edi
  8013fc:	56                   	push   %esi
  8013fd:	53                   	push   %ebx
  8013fe:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801401:	bb 00 00 00 00       	mov    $0x0,%ebx
  801406:	8b 55 08             	mov    0x8(%ebp),%edx
  801409:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80140c:	b8 06 00 00 00       	mov    $0x6,%eax
  801411:	89 df                	mov    %ebx,%edi
  801413:	89 de                	mov    %ebx,%esi
  801415:	cd 30                	int    $0x30
	if(check && ret > 0)
  801417:	85 c0                	test   %eax,%eax
  801419:	7f 08                	jg     801423 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80141b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80141e:	5b                   	pop    %ebx
  80141f:	5e                   	pop    %esi
  801420:	5f                   	pop    %edi
  801421:	5d                   	pop    %ebp
  801422:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801423:	83 ec 0c             	sub    $0xc,%esp
  801426:	50                   	push   %eax
  801427:	6a 06                	push   $0x6
  801429:	68 40 2d 80 00       	push   $0x802d40
  80142e:	6a 43                	push   $0x43
  801430:	68 5d 2d 80 00       	push   $0x802d5d
  801435:	e8 f2 f2 ff ff       	call   80072c <_panic>

0080143a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
  80143d:	57                   	push   %edi
  80143e:	56                   	push   %esi
  80143f:	53                   	push   %ebx
  801440:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801443:	bb 00 00 00 00       	mov    $0x0,%ebx
  801448:	8b 55 08             	mov    0x8(%ebp),%edx
  80144b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80144e:	b8 08 00 00 00       	mov    $0x8,%eax
  801453:	89 df                	mov    %ebx,%edi
  801455:	89 de                	mov    %ebx,%esi
  801457:	cd 30                	int    $0x30
	if(check && ret > 0)
  801459:	85 c0                	test   %eax,%eax
  80145b:	7f 08                	jg     801465 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80145d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801460:	5b                   	pop    %ebx
  801461:	5e                   	pop    %esi
  801462:	5f                   	pop    %edi
  801463:	5d                   	pop    %ebp
  801464:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801465:	83 ec 0c             	sub    $0xc,%esp
  801468:	50                   	push   %eax
  801469:	6a 08                	push   $0x8
  80146b:	68 40 2d 80 00       	push   $0x802d40
  801470:	6a 43                	push   $0x43
  801472:	68 5d 2d 80 00       	push   $0x802d5d
  801477:	e8 b0 f2 ff ff       	call   80072c <_panic>

0080147c <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80147c:	55                   	push   %ebp
  80147d:	89 e5                	mov    %esp,%ebp
  80147f:	57                   	push   %edi
  801480:	56                   	push   %esi
  801481:	53                   	push   %ebx
  801482:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801485:	bb 00 00 00 00       	mov    $0x0,%ebx
  80148a:	8b 55 08             	mov    0x8(%ebp),%edx
  80148d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801490:	b8 09 00 00 00       	mov    $0x9,%eax
  801495:	89 df                	mov    %ebx,%edi
  801497:	89 de                	mov    %ebx,%esi
  801499:	cd 30                	int    $0x30
	if(check && ret > 0)
  80149b:	85 c0                	test   %eax,%eax
  80149d:	7f 08                	jg     8014a7 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80149f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014a2:	5b                   	pop    %ebx
  8014a3:	5e                   	pop    %esi
  8014a4:	5f                   	pop    %edi
  8014a5:	5d                   	pop    %ebp
  8014a6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8014a7:	83 ec 0c             	sub    $0xc,%esp
  8014aa:	50                   	push   %eax
  8014ab:	6a 09                	push   $0x9
  8014ad:	68 40 2d 80 00       	push   $0x802d40
  8014b2:	6a 43                	push   $0x43
  8014b4:	68 5d 2d 80 00       	push   $0x802d5d
  8014b9:	e8 6e f2 ff ff       	call   80072c <_panic>

008014be <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8014be:	55                   	push   %ebp
  8014bf:	89 e5                	mov    %esp,%ebp
  8014c1:	57                   	push   %edi
  8014c2:	56                   	push   %esi
  8014c3:	53                   	push   %ebx
  8014c4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8014c7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8014cf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014d2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8014d7:	89 df                	mov    %ebx,%edi
  8014d9:	89 de                	mov    %ebx,%esi
  8014db:	cd 30                	int    $0x30
	if(check && ret > 0)
  8014dd:	85 c0                	test   %eax,%eax
  8014df:	7f 08                	jg     8014e9 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8014e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014e4:	5b                   	pop    %ebx
  8014e5:	5e                   	pop    %esi
  8014e6:	5f                   	pop    %edi
  8014e7:	5d                   	pop    %ebp
  8014e8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8014e9:	83 ec 0c             	sub    $0xc,%esp
  8014ec:	50                   	push   %eax
  8014ed:	6a 0a                	push   $0xa
  8014ef:	68 40 2d 80 00       	push   $0x802d40
  8014f4:	6a 43                	push   $0x43
  8014f6:	68 5d 2d 80 00       	push   $0x802d5d
  8014fb:	e8 2c f2 ff ff       	call   80072c <_panic>

00801500 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801500:	55                   	push   %ebp
  801501:	89 e5                	mov    %esp,%ebp
  801503:	57                   	push   %edi
  801504:	56                   	push   %esi
  801505:	53                   	push   %ebx
	asm volatile("int %1\n"
  801506:	8b 55 08             	mov    0x8(%ebp),%edx
  801509:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80150c:	b8 0c 00 00 00       	mov    $0xc,%eax
  801511:	be 00 00 00 00       	mov    $0x0,%esi
  801516:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801519:	8b 7d 14             	mov    0x14(%ebp),%edi
  80151c:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80151e:	5b                   	pop    %ebx
  80151f:	5e                   	pop    %esi
  801520:	5f                   	pop    %edi
  801521:	5d                   	pop    %ebp
  801522:	c3                   	ret    

00801523 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801523:	55                   	push   %ebp
  801524:	89 e5                	mov    %esp,%ebp
  801526:	57                   	push   %edi
  801527:	56                   	push   %esi
  801528:	53                   	push   %ebx
  801529:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80152c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801531:	8b 55 08             	mov    0x8(%ebp),%edx
  801534:	b8 0d 00 00 00       	mov    $0xd,%eax
  801539:	89 cb                	mov    %ecx,%ebx
  80153b:	89 cf                	mov    %ecx,%edi
  80153d:	89 ce                	mov    %ecx,%esi
  80153f:	cd 30                	int    $0x30
	if(check && ret > 0)
  801541:	85 c0                	test   %eax,%eax
  801543:	7f 08                	jg     80154d <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801545:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801548:	5b                   	pop    %ebx
  801549:	5e                   	pop    %esi
  80154a:	5f                   	pop    %edi
  80154b:	5d                   	pop    %ebp
  80154c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80154d:	83 ec 0c             	sub    $0xc,%esp
  801550:	50                   	push   %eax
  801551:	6a 0d                	push   $0xd
  801553:	68 40 2d 80 00       	push   $0x802d40
  801558:	6a 43                	push   $0x43
  80155a:	68 5d 2d 80 00       	push   $0x802d5d
  80155f:	e8 c8 f1 ff ff       	call   80072c <_panic>

00801564 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801564:	55                   	push   %ebp
  801565:	89 e5                	mov    %esp,%ebp
  801567:	57                   	push   %edi
  801568:	56                   	push   %esi
  801569:	53                   	push   %ebx
	asm volatile("int %1\n"
  80156a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80156f:	8b 55 08             	mov    0x8(%ebp),%edx
  801572:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801575:	b8 0e 00 00 00       	mov    $0xe,%eax
  80157a:	89 df                	mov    %ebx,%edi
  80157c:	89 de                	mov    %ebx,%esi
  80157e:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801580:	5b                   	pop    %ebx
  801581:	5e                   	pop    %esi
  801582:	5f                   	pop    %edi
  801583:	5d                   	pop    %ebp
  801584:	c3                   	ret    

00801585 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801585:	55                   	push   %ebp
  801586:	89 e5                	mov    %esp,%ebp
  801588:	57                   	push   %edi
  801589:	56                   	push   %esi
  80158a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80158b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801590:	8b 55 08             	mov    0x8(%ebp),%edx
  801593:	b8 0f 00 00 00       	mov    $0xf,%eax
  801598:	89 cb                	mov    %ecx,%ebx
  80159a:	89 cf                	mov    %ecx,%edi
  80159c:	89 ce                	mov    %ecx,%esi
  80159e:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8015a0:	5b                   	pop    %ebx
  8015a1:	5e                   	pop    %esi
  8015a2:	5f                   	pop    %edi
  8015a3:	5d                   	pop    %ebp
  8015a4:	c3                   	ret    

008015a5 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8015a5:	55                   	push   %ebp
  8015a6:	89 e5                	mov    %esp,%ebp
  8015a8:	56                   	push   %esi
  8015a9:	53                   	push   %ebx
  8015aa:	8b 75 08             	mov    0x8(%ebp),%esi
  8015ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// cprintf("in %s\n", __FUNCTION__);
	int ret;
	if(!pg)
  8015b3:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8015b5:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8015ba:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8015bd:	83 ec 0c             	sub    $0xc,%esp
  8015c0:	50                   	push   %eax
  8015c1:	e8 5d ff ff ff       	call   801523 <sys_ipc_recv>
	if(ret < 0){
  8015c6:	83 c4 10             	add    $0x10,%esp
  8015c9:	85 c0                	test   %eax,%eax
  8015cb:	78 2b                	js     8015f8 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8015cd:	85 f6                	test   %esi,%esi
  8015cf:	74 0a                	je     8015db <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  8015d1:	a1 04 40 80 00       	mov    0x804004,%eax
  8015d6:	8b 40 74             	mov    0x74(%eax),%eax
  8015d9:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8015db:	85 db                	test   %ebx,%ebx
  8015dd:	74 0a                	je     8015e9 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  8015df:	a1 04 40 80 00       	mov    0x804004,%eax
  8015e4:	8b 40 78             	mov    0x78(%eax),%eax
  8015e7:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  8015e9:	a1 04 40 80 00       	mov    0x804004,%eax
  8015ee:	8b 40 70             	mov    0x70(%eax),%eax
}
  8015f1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015f4:	5b                   	pop    %ebx
  8015f5:	5e                   	pop    %esi
  8015f6:	5d                   	pop    %ebp
  8015f7:	c3                   	ret    
		if(from_env_store)
  8015f8:	85 f6                	test   %esi,%esi
  8015fa:	74 06                	je     801602 <ipc_recv+0x5d>
			*from_env_store = 0;
  8015fc:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  801602:	85 db                	test   %ebx,%ebx
  801604:	74 eb                	je     8015f1 <ipc_recv+0x4c>
			*perm_store = 0;
  801606:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80160c:	eb e3                	jmp    8015f1 <ipc_recv+0x4c>

0080160e <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80160e:	55                   	push   %ebp
  80160f:	89 e5                	mov    %esp,%ebp
  801611:	57                   	push   %edi
  801612:	56                   	push   %esi
  801613:	53                   	push   %ebx
  801614:	83 ec 0c             	sub    $0xc,%esp
  801617:	8b 7d 08             	mov    0x8(%ebp),%edi
  80161a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80161d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  801620:	85 db                	test   %ebx,%ebx
  801622:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801627:	0f 44 d8             	cmove  %eax,%ebx
  80162a:	eb 05                	jmp    801631 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80162c:	e8 23 fd ff ff       	call   801354 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  801631:	ff 75 14             	pushl  0x14(%ebp)
  801634:	53                   	push   %ebx
  801635:	56                   	push   %esi
  801636:	57                   	push   %edi
  801637:	e8 c4 fe ff ff       	call   801500 <sys_ipc_try_send>
  80163c:	83 c4 10             	add    $0x10,%esp
  80163f:	85 c0                	test   %eax,%eax
  801641:	74 1b                	je     80165e <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  801643:	79 e7                	jns    80162c <ipc_send+0x1e>
  801645:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801648:	74 e2                	je     80162c <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80164a:	83 ec 04             	sub    $0x4,%esp
  80164d:	68 6b 2d 80 00       	push   $0x802d6b
  801652:	6a 49                	push   $0x49
  801654:	68 80 2d 80 00       	push   $0x802d80
  801659:	e8 ce f0 ff ff       	call   80072c <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80165e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801661:	5b                   	pop    %ebx
  801662:	5e                   	pop    %esi
  801663:	5f                   	pop    %edi
  801664:	5d                   	pop    %ebp
  801665:	c3                   	ret    

00801666 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801666:	55                   	push   %ebp
  801667:	89 e5                	mov    %esp,%ebp
  801669:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80166c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801671:	89 c2                	mov    %eax,%edx
  801673:	c1 e2 07             	shl    $0x7,%edx
  801676:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80167c:	8b 52 50             	mov    0x50(%edx),%edx
  80167f:	39 ca                	cmp    %ecx,%edx
  801681:	74 11                	je     801694 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  801683:	83 c0 01             	add    $0x1,%eax
  801686:	3d 00 04 00 00       	cmp    $0x400,%eax
  80168b:	75 e4                	jne    801671 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80168d:	b8 00 00 00 00       	mov    $0x0,%eax
  801692:	eb 0b                	jmp    80169f <ipc_find_env+0x39>
			return envs[i].env_id;
  801694:	c1 e0 07             	shl    $0x7,%eax
  801697:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80169c:	8b 40 48             	mov    0x48(%eax),%eax
}
  80169f:	5d                   	pop    %ebp
  8016a0:	c3                   	ret    

008016a1 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8016a1:	55                   	push   %ebp
  8016a2:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a7:	05 00 00 00 30       	add    $0x30000000,%eax
  8016ac:	c1 e8 0c             	shr    $0xc,%eax
}
  8016af:	5d                   	pop    %ebp
  8016b0:	c3                   	ret    

008016b1 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8016b1:	55                   	push   %ebp
  8016b2:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b7:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8016bc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016c1:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8016c6:	5d                   	pop    %ebp
  8016c7:	c3                   	ret    

008016c8 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8016c8:	55                   	push   %ebp
  8016c9:	89 e5                	mov    %esp,%ebp
  8016cb:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8016d0:	89 c2                	mov    %eax,%edx
  8016d2:	c1 ea 16             	shr    $0x16,%edx
  8016d5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8016dc:	f6 c2 01             	test   $0x1,%dl
  8016df:	74 2d                	je     80170e <fd_alloc+0x46>
  8016e1:	89 c2                	mov    %eax,%edx
  8016e3:	c1 ea 0c             	shr    $0xc,%edx
  8016e6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016ed:	f6 c2 01             	test   $0x1,%dl
  8016f0:	74 1c                	je     80170e <fd_alloc+0x46>
  8016f2:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8016f7:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8016fc:	75 d2                	jne    8016d0 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8016fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801701:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801707:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80170c:	eb 0a                	jmp    801718 <fd_alloc+0x50>
			*fd_store = fd;
  80170e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801711:	89 01                	mov    %eax,(%ecx)
			return 0;
  801713:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801718:	5d                   	pop    %ebp
  801719:	c3                   	ret    

0080171a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80171a:	55                   	push   %ebp
  80171b:	89 e5                	mov    %esp,%ebp
  80171d:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801720:	83 f8 1f             	cmp    $0x1f,%eax
  801723:	77 30                	ja     801755 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801725:	c1 e0 0c             	shl    $0xc,%eax
  801728:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80172d:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801733:	f6 c2 01             	test   $0x1,%dl
  801736:	74 24                	je     80175c <fd_lookup+0x42>
  801738:	89 c2                	mov    %eax,%edx
  80173a:	c1 ea 0c             	shr    $0xc,%edx
  80173d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801744:	f6 c2 01             	test   $0x1,%dl
  801747:	74 1a                	je     801763 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801749:	8b 55 0c             	mov    0xc(%ebp),%edx
  80174c:	89 02                	mov    %eax,(%edx)
	return 0;
  80174e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801753:	5d                   	pop    %ebp
  801754:	c3                   	ret    
		return -E_INVAL;
  801755:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80175a:	eb f7                	jmp    801753 <fd_lookup+0x39>
		return -E_INVAL;
  80175c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801761:	eb f0                	jmp    801753 <fd_lookup+0x39>
  801763:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801768:	eb e9                	jmp    801753 <fd_lookup+0x39>

0080176a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80176a:	55                   	push   %ebp
  80176b:	89 e5                	mov    %esp,%ebp
  80176d:	83 ec 08             	sub    $0x8,%esp
  801770:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801773:	ba 0c 2e 80 00       	mov    $0x802e0c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801778:	b8 08 30 80 00       	mov    $0x803008,%eax
		if (devtab[i]->dev_id == dev_id) {
  80177d:	39 08                	cmp    %ecx,(%eax)
  80177f:	74 33                	je     8017b4 <dev_lookup+0x4a>
  801781:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801784:	8b 02                	mov    (%edx),%eax
  801786:	85 c0                	test   %eax,%eax
  801788:	75 f3                	jne    80177d <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80178a:	a1 04 40 80 00       	mov    0x804004,%eax
  80178f:	8b 40 48             	mov    0x48(%eax),%eax
  801792:	83 ec 04             	sub    $0x4,%esp
  801795:	51                   	push   %ecx
  801796:	50                   	push   %eax
  801797:	68 8c 2d 80 00       	push   $0x802d8c
  80179c:	e8 81 f0 ff ff       	call   800822 <cprintf>
	*dev = 0;
  8017a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8017aa:	83 c4 10             	add    $0x10,%esp
  8017ad:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8017b2:	c9                   	leave  
  8017b3:	c3                   	ret    
			*dev = devtab[i];
  8017b4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017b7:	89 01                	mov    %eax,(%ecx)
			return 0;
  8017b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8017be:	eb f2                	jmp    8017b2 <dev_lookup+0x48>

008017c0 <fd_close>:
{
  8017c0:	55                   	push   %ebp
  8017c1:	89 e5                	mov    %esp,%ebp
  8017c3:	57                   	push   %edi
  8017c4:	56                   	push   %esi
  8017c5:	53                   	push   %ebx
  8017c6:	83 ec 24             	sub    $0x24,%esp
  8017c9:	8b 75 08             	mov    0x8(%ebp),%esi
  8017cc:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8017cf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8017d2:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017d3:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8017d9:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8017dc:	50                   	push   %eax
  8017dd:	e8 38 ff ff ff       	call   80171a <fd_lookup>
  8017e2:	89 c3                	mov    %eax,%ebx
  8017e4:	83 c4 10             	add    $0x10,%esp
  8017e7:	85 c0                	test   %eax,%eax
  8017e9:	78 05                	js     8017f0 <fd_close+0x30>
	    || fd != fd2)
  8017eb:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8017ee:	74 16                	je     801806 <fd_close+0x46>
		return (must_exist ? r : 0);
  8017f0:	89 f8                	mov    %edi,%eax
  8017f2:	84 c0                	test   %al,%al
  8017f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f9:	0f 44 d8             	cmove  %eax,%ebx
}
  8017fc:	89 d8                	mov    %ebx,%eax
  8017fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801801:	5b                   	pop    %ebx
  801802:	5e                   	pop    %esi
  801803:	5f                   	pop    %edi
  801804:	5d                   	pop    %ebp
  801805:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801806:	83 ec 08             	sub    $0x8,%esp
  801809:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80180c:	50                   	push   %eax
  80180d:	ff 36                	pushl  (%esi)
  80180f:	e8 56 ff ff ff       	call   80176a <dev_lookup>
  801814:	89 c3                	mov    %eax,%ebx
  801816:	83 c4 10             	add    $0x10,%esp
  801819:	85 c0                	test   %eax,%eax
  80181b:	78 1a                	js     801837 <fd_close+0x77>
		if (dev->dev_close)
  80181d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801820:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801823:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801828:	85 c0                	test   %eax,%eax
  80182a:	74 0b                	je     801837 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80182c:	83 ec 0c             	sub    $0xc,%esp
  80182f:	56                   	push   %esi
  801830:	ff d0                	call   *%eax
  801832:	89 c3                	mov    %eax,%ebx
  801834:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801837:	83 ec 08             	sub    $0x8,%esp
  80183a:	56                   	push   %esi
  80183b:	6a 00                	push   $0x0
  80183d:	e8 b6 fb ff ff       	call   8013f8 <sys_page_unmap>
	return r;
  801842:	83 c4 10             	add    $0x10,%esp
  801845:	eb b5                	jmp    8017fc <fd_close+0x3c>

00801847 <close>:

int
close(int fdnum)
{
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
  80184a:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80184d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801850:	50                   	push   %eax
  801851:	ff 75 08             	pushl  0x8(%ebp)
  801854:	e8 c1 fe ff ff       	call   80171a <fd_lookup>
  801859:	83 c4 10             	add    $0x10,%esp
  80185c:	85 c0                	test   %eax,%eax
  80185e:	79 02                	jns    801862 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801860:	c9                   	leave  
  801861:	c3                   	ret    
		return fd_close(fd, 1);
  801862:	83 ec 08             	sub    $0x8,%esp
  801865:	6a 01                	push   $0x1
  801867:	ff 75 f4             	pushl  -0xc(%ebp)
  80186a:	e8 51 ff ff ff       	call   8017c0 <fd_close>
  80186f:	83 c4 10             	add    $0x10,%esp
  801872:	eb ec                	jmp    801860 <close+0x19>

00801874 <close_all>:

void
close_all(void)
{
  801874:	55                   	push   %ebp
  801875:	89 e5                	mov    %esp,%ebp
  801877:	53                   	push   %ebx
  801878:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80187b:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801880:	83 ec 0c             	sub    $0xc,%esp
  801883:	53                   	push   %ebx
  801884:	e8 be ff ff ff       	call   801847 <close>
	for (i = 0; i < MAXFD; i++)
  801889:	83 c3 01             	add    $0x1,%ebx
  80188c:	83 c4 10             	add    $0x10,%esp
  80188f:	83 fb 20             	cmp    $0x20,%ebx
  801892:	75 ec                	jne    801880 <close_all+0xc>
}
  801894:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801897:	c9                   	leave  
  801898:	c3                   	ret    

00801899 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801899:	55                   	push   %ebp
  80189a:	89 e5                	mov    %esp,%ebp
  80189c:	57                   	push   %edi
  80189d:	56                   	push   %esi
  80189e:	53                   	push   %ebx
  80189f:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8018a2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8018a5:	50                   	push   %eax
  8018a6:	ff 75 08             	pushl  0x8(%ebp)
  8018a9:	e8 6c fe ff ff       	call   80171a <fd_lookup>
  8018ae:	89 c3                	mov    %eax,%ebx
  8018b0:	83 c4 10             	add    $0x10,%esp
  8018b3:	85 c0                	test   %eax,%eax
  8018b5:	0f 88 81 00 00 00    	js     80193c <dup+0xa3>
		return r;
	close(newfdnum);
  8018bb:	83 ec 0c             	sub    $0xc,%esp
  8018be:	ff 75 0c             	pushl  0xc(%ebp)
  8018c1:	e8 81 ff ff ff       	call   801847 <close>

	newfd = INDEX2FD(newfdnum);
  8018c6:	8b 75 0c             	mov    0xc(%ebp),%esi
  8018c9:	c1 e6 0c             	shl    $0xc,%esi
  8018cc:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8018d2:	83 c4 04             	add    $0x4,%esp
  8018d5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8018d8:	e8 d4 fd ff ff       	call   8016b1 <fd2data>
  8018dd:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8018df:	89 34 24             	mov    %esi,(%esp)
  8018e2:	e8 ca fd ff ff       	call   8016b1 <fd2data>
  8018e7:	83 c4 10             	add    $0x10,%esp
  8018ea:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8018ec:	89 d8                	mov    %ebx,%eax
  8018ee:	c1 e8 16             	shr    $0x16,%eax
  8018f1:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8018f8:	a8 01                	test   $0x1,%al
  8018fa:	74 11                	je     80190d <dup+0x74>
  8018fc:	89 d8                	mov    %ebx,%eax
  8018fe:	c1 e8 0c             	shr    $0xc,%eax
  801901:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801908:	f6 c2 01             	test   $0x1,%dl
  80190b:	75 39                	jne    801946 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80190d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801910:	89 d0                	mov    %edx,%eax
  801912:	c1 e8 0c             	shr    $0xc,%eax
  801915:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80191c:	83 ec 0c             	sub    $0xc,%esp
  80191f:	25 07 0e 00 00       	and    $0xe07,%eax
  801924:	50                   	push   %eax
  801925:	56                   	push   %esi
  801926:	6a 00                	push   $0x0
  801928:	52                   	push   %edx
  801929:	6a 00                	push   $0x0
  80192b:	e8 86 fa ff ff       	call   8013b6 <sys_page_map>
  801930:	89 c3                	mov    %eax,%ebx
  801932:	83 c4 20             	add    $0x20,%esp
  801935:	85 c0                	test   %eax,%eax
  801937:	78 31                	js     80196a <dup+0xd1>
		goto err;

	return newfdnum;
  801939:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80193c:	89 d8                	mov    %ebx,%eax
  80193e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801941:	5b                   	pop    %ebx
  801942:	5e                   	pop    %esi
  801943:	5f                   	pop    %edi
  801944:	5d                   	pop    %ebp
  801945:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801946:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80194d:	83 ec 0c             	sub    $0xc,%esp
  801950:	25 07 0e 00 00       	and    $0xe07,%eax
  801955:	50                   	push   %eax
  801956:	57                   	push   %edi
  801957:	6a 00                	push   $0x0
  801959:	53                   	push   %ebx
  80195a:	6a 00                	push   $0x0
  80195c:	e8 55 fa ff ff       	call   8013b6 <sys_page_map>
  801961:	89 c3                	mov    %eax,%ebx
  801963:	83 c4 20             	add    $0x20,%esp
  801966:	85 c0                	test   %eax,%eax
  801968:	79 a3                	jns    80190d <dup+0x74>
	sys_page_unmap(0, newfd);
  80196a:	83 ec 08             	sub    $0x8,%esp
  80196d:	56                   	push   %esi
  80196e:	6a 00                	push   $0x0
  801970:	e8 83 fa ff ff       	call   8013f8 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801975:	83 c4 08             	add    $0x8,%esp
  801978:	57                   	push   %edi
  801979:	6a 00                	push   $0x0
  80197b:	e8 78 fa ff ff       	call   8013f8 <sys_page_unmap>
	return r;
  801980:	83 c4 10             	add    $0x10,%esp
  801983:	eb b7                	jmp    80193c <dup+0xa3>

00801985 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801985:	55                   	push   %ebp
  801986:	89 e5                	mov    %esp,%ebp
  801988:	53                   	push   %ebx
  801989:	83 ec 1c             	sub    $0x1c,%esp
  80198c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80198f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801992:	50                   	push   %eax
  801993:	53                   	push   %ebx
  801994:	e8 81 fd ff ff       	call   80171a <fd_lookup>
  801999:	83 c4 10             	add    $0x10,%esp
  80199c:	85 c0                	test   %eax,%eax
  80199e:	78 3f                	js     8019df <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019a0:	83 ec 08             	sub    $0x8,%esp
  8019a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019a6:	50                   	push   %eax
  8019a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019aa:	ff 30                	pushl  (%eax)
  8019ac:	e8 b9 fd ff ff       	call   80176a <dev_lookup>
  8019b1:	83 c4 10             	add    $0x10,%esp
  8019b4:	85 c0                	test   %eax,%eax
  8019b6:	78 27                	js     8019df <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8019b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019bb:	8b 42 08             	mov    0x8(%edx),%eax
  8019be:	83 e0 03             	and    $0x3,%eax
  8019c1:	83 f8 01             	cmp    $0x1,%eax
  8019c4:	74 1e                	je     8019e4 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8019c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c9:	8b 40 08             	mov    0x8(%eax),%eax
  8019cc:	85 c0                	test   %eax,%eax
  8019ce:	74 35                	je     801a05 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8019d0:	83 ec 04             	sub    $0x4,%esp
  8019d3:	ff 75 10             	pushl  0x10(%ebp)
  8019d6:	ff 75 0c             	pushl  0xc(%ebp)
  8019d9:	52                   	push   %edx
  8019da:	ff d0                	call   *%eax
  8019dc:	83 c4 10             	add    $0x10,%esp
}
  8019df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019e2:	c9                   	leave  
  8019e3:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8019e4:	a1 04 40 80 00       	mov    0x804004,%eax
  8019e9:	8b 40 48             	mov    0x48(%eax),%eax
  8019ec:	83 ec 04             	sub    $0x4,%esp
  8019ef:	53                   	push   %ebx
  8019f0:	50                   	push   %eax
  8019f1:	68 d0 2d 80 00       	push   $0x802dd0
  8019f6:	e8 27 ee ff ff       	call   800822 <cprintf>
		return -E_INVAL;
  8019fb:	83 c4 10             	add    $0x10,%esp
  8019fe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a03:	eb da                	jmp    8019df <read+0x5a>
		return -E_NOT_SUPP;
  801a05:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a0a:	eb d3                	jmp    8019df <read+0x5a>

00801a0c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801a0c:	55                   	push   %ebp
  801a0d:	89 e5                	mov    %esp,%ebp
  801a0f:	57                   	push   %edi
  801a10:	56                   	push   %esi
  801a11:	53                   	push   %ebx
  801a12:	83 ec 0c             	sub    $0xc,%esp
  801a15:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a18:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a1b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a20:	39 f3                	cmp    %esi,%ebx
  801a22:	73 23                	jae    801a47 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a24:	83 ec 04             	sub    $0x4,%esp
  801a27:	89 f0                	mov    %esi,%eax
  801a29:	29 d8                	sub    %ebx,%eax
  801a2b:	50                   	push   %eax
  801a2c:	89 d8                	mov    %ebx,%eax
  801a2e:	03 45 0c             	add    0xc(%ebp),%eax
  801a31:	50                   	push   %eax
  801a32:	57                   	push   %edi
  801a33:	e8 4d ff ff ff       	call   801985 <read>
		if (m < 0)
  801a38:	83 c4 10             	add    $0x10,%esp
  801a3b:	85 c0                	test   %eax,%eax
  801a3d:	78 06                	js     801a45 <readn+0x39>
			return m;
		if (m == 0)
  801a3f:	74 06                	je     801a47 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801a41:	01 c3                	add    %eax,%ebx
  801a43:	eb db                	jmp    801a20 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a45:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801a47:	89 d8                	mov    %ebx,%eax
  801a49:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a4c:	5b                   	pop    %ebx
  801a4d:	5e                   	pop    %esi
  801a4e:	5f                   	pop    %edi
  801a4f:	5d                   	pop    %ebp
  801a50:	c3                   	ret    

00801a51 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
  801a54:	53                   	push   %ebx
  801a55:	83 ec 1c             	sub    $0x1c,%esp
  801a58:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a5b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a5e:	50                   	push   %eax
  801a5f:	53                   	push   %ebx
  801a60:	e8 b5 fc ff ff       	call   80171a <fd_lookup>
  801a65:	83 c4 10             	add    $0x10,%esp
  801a68:	85 c0                	test   %eax,%eax
  801a6a:	78 3a                	js     801aa6 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a6c:	83 ec 08             	sub    $0x8,%esp
  801a6f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a72:	50                   	push   %eax
  801a73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a76:	ff 30                	pushl  (%eax)
  801a78:	e8 ed fc ff ff       	call   80176a <dev_lookup>
  801a7d:	83 c4 10             	add    $0x10,%esp
  801a80:	85 c0                	test   %eax,%eax
  801a82:	78 22                	js     801aa6 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a87:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a8b:	74 1e                	je     801aab <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801a8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a90:	8b 52 0c             	mov    0xc(%edx),%edx
  801a93:	85 d2                	test   %edx,%edx
  801a95:	74 35                	je     801acc <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801a97:	83 ec 04             	sub    $0x4,%esp
  801a9a:	ff 75 10             	pushl  0x10(%ebp)
  801a9d:	ff 75 0c             	pushl  0xc(%ebp)
  801aa0:	50                   	push   %eax
  801aa1:	ff d2                	call   *%edx
  801aa3:	83 c4 10             	add    $0x10,%esp
}
  801aa6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aa9:	c9                   	leave  
  801aaa:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801aab:	a1 04 40 80 00       	mov    0x804004,%eax
  801ab0:	8b 40 48             	mov    0x48(%eax),%eax
  801ab3:	83 ec 04             	sub    $0x4,%esp
  801ab6:	53                   	push   %ebx
  801ab7:	50                   	push   %eax
  801ab8:	68 ec 2d 80 00       	push   $0x802dec
  801abd:	e8 60 ed ff ff       	call   800822 <cprintf>
		return -E_INVAL;
  801ac2:	83 c4 10             	add    $0x10,%esp
  801ac5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801aca:	eb da                	jmp    801aa6 <write+0x55>
		return -E_NOT_SUPP;
  801acc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ad1:	eb d3                	jmp    801aa6 <write+0x55>

00801ad3 <seek>:

int
seek(int fdnum, off_t offset)
{
  801ad3:	55                   	push   %ebp
  801ad4:	89 e5                	mov    %esp,%ebp
  801ad6:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ad9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801adc:	50                   	push   %eax
  801add:	ff 75 08             	pushl  0x8(%ebp)
  801ae0:	e8 35 fc ff ff       	call   80171a <fd_lookup>
  801ae5:	83 c4 10             	add    $0x10,%esp
  801ae8:	85 c0                	test   %eax,%eax
  801aea:	78 0e                	js     801afa <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801aec:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801af2:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801af5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801afa:	c9                   	leave  
  801afb:	c3                   	ret    

00801afc <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801afc:	55                   	push   %ebp
  801afd:	89 e5                	mov    %esp,%ebp
  801aff:	53                   	push   %ebx
  801b00:	83 ec 1c             	sub    $0x1c,%esp
  801b03:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b06:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b09:	50                   	push   %eax
  801b0a:	53                   	push   %ebx
  801b0b:	e8 0a fc ff ff       	call   80171a <fd_lookup>
  801b10:	83 c4 10             	add    $0x10,%esp
  801b13:	85 c0                	test   %eax,%eax
  801b15:	78 37                	js     801b4e <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b17:	83 ec 08             	sub    $0x8,%esp
  801b1a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b1d:	50                   	push   %eax
  801b1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b21:	ff 30                	pushl  (%eax)
  801b23:	e8 42 fc ff ff       	call   80176a <dev_lookup>
  801b28:	83 c4 10             	add    $0x10,%esp
  801b2b:	85 c0                	test   %eax,%eax
  801b2d:	78 1f                	js     801b4e <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b32:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b36:	74 1b                	je     801b53 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801b38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b3b:	8b 52 18             	mov    0x18(%edx),%edx
  801b3e:	85 d2                	test   %edx,%edx
  801b40:	74 32                	je     801b74 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801b42:	83 ec 08             	sub    $0x8,%esp
  801b45:	ff 75 0c             	pushl  0xc(%ebp)
  801b48:	50                   	push   %eax
  801b49:	ff d2                	call   *%edx
  801b4b:	83 c4 10             	add    $0x10,%esp
}
  801b4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b51:	c9                   	leave  
  801b52:	c3                   	ret    
			thisenv->env_id, fdnum);
  801b53:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801b58:	8b 40 48             	mov    0x48(%eax),%eax
  801b5b:	83 ec 04             	sub    $0x4,%esp
  801b5e:	53                   	push   %ebx
  801b5f:	50                   	push   %eax
  801b60:	68 ac 2d 80 00       	push   $0x802dac
  801b65:	e8 b8 ec ff ff       	call   800822 <cprintf>
		return -E_INVAL;
  801b6a:	83 c4 10             	add    $0x10,%esp
  801b6d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b72:	eb da                	jmp    801b4e <ftruncate+0x52>
		return -E_NOT_SUPP;
  801b74:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b79:	eb d3                	jmp    801b4e <ftruncate+0x52>

00801b7b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801b7b:	55                   	push   %ebp
  801b7c:	89 e5                	mov    %esp,%ebp
  801b7e:	53                   	push   %ebx
  801b7f:	83 ec 1c             	sub    $0x1c,%esp
  801b82:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b85:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b88:	50                   	push   %eax
  801b89:	ff 75 08             	pushl  0x8(%ebp)
  801b8c:	e8 89 fb ff ff       	call   80171a <fd_lookup>
  801b91:	83 c4 10             	add    $0x10,%esp
  801b94:	85 c0                	test   %eax,%eax
  801b96:	78 4b                	js     801be3 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b98:	83 ec 08             	sub    $0x8,%esp
  801b9b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b9e:	50                   	push   %eax
  801b9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ba2:	ff 30                	pushl  (%eax)
  801ba4:	e8 c1 fb ff ff       	call   80176a <dev_lookup>
  801ba9:	83 c4 10             	add    $0x10,%esp
  801bac:	85 c0                	test   %eax,%eax
  801bae:	78 33                	js     801be3 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801bb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801bb7:	74 2f                	je     801be8 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801bb9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801bbc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801bc3:	00 00 00 
	stat->st_isdir = 0;
  801bc6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801bcd:	00 00 00 
	stat->st_dev = dev;
  801bd0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801bd6:	83 ec 08             	sub    $0x8,%esp
  801bd9:	53                   	push   %ebx
  801bda:	ff 75 f0             	pushl  -0x10(%ebp)
  801bdd:	ff 50 14             	call   *0x14(%eax)
  801be0:	83 c4 10             	add    $0x10,%esp
}
  801be3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801be6:	c9                   	leave  
  801be7:	c3                   	ret    
		return -E_NOT_SUPP;
  801be8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bed:	eb f4                	jmp    801be3 <fstat+0x68>

00801bef <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801bef:	55                   	push   %ebp
  801bf0:	89 e5                	mov    %esp,%ebp
  801bf2:	56                   	push   %esi
  801bf3:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801bf4:	83 ec 08             	sub    $0x8,%esp
  801bf7:	6a 00                	push   $0x0
  801bf9:	ff 75 08             	pushl  0x8(%ebp)
  801bfc:	e8 bb 01 00 00       	call   801dbc <open>
  801c01:	89 c3                	mov    %eax,%ebx
  801c03:	83 c4 10             	add    $0x10,%esp
  801c06:	85 c0                	test   %eax,%eax
  801c08:	78 1b                	js     801c25 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801c0a:	83 ec 08             	sub    $0x8,%esp
  801c0d:	ff 75 0c             	pushl  0xc(%ebp)
  801c10:	50                   	push   %eax
  801c11:	e8 65 ff ff ff       	call   801b7b <fstat>
  801c16:	89 c6                	mov    %eax,%esi
	close(fd);
  801c18:	89 1c 24             	mov    %ebx,(%esp)
  801c1b:	e8 27 fc ff ff       	call   801847 <close>
	return r;
  801c20:	83 c4 10             	add    $0x10,%esp
  801c23:	89 f3                	mov    %esi,%ebx
}
  801c25:	89 d8                	mov    %ebx,%eax
  801c27:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c2a:	5b                   	pop    %ebx
  801c2b:	5e                   	pop    %esi
  801c2c:	5d                   	pop    %ebp
  801c2d:	c3                   	ret    

00801c2e <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801c2e:	55                   	push   %ebp
  801c2f:	89 e5                	mov    %esp,%ebp
  801c31:	56                   	push   %esi
  801c32:	53                   	push   %ebx
  801c33:	89 c6                	mov    %eax,%esi
  801c35:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801c37:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801c3e:	74 27                	je     801c67 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801c40:	6a 07                	push   $0x7
  801c42:	68 00 50 80 00       	push   $0x805000
  801c47:	56                   	push   %esi
  801c48:	ff 35 00 40 80 00    	pushl  0x804000
  801c4e:	e8 bb f9 ff ff       	call   80160e <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801c53:	83 c4 0c             	add    $0xc,%esp
  801c56:	6a 00                	push   $0x0
  801c58:	53                   	push   %ebx
  801c59:	6a 00                	push   $0x0
  801c5b:	e8 45 f9 ff ff       	call   8015a5 <ipc_recv>
}
  801c60:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c63:	5b                   	pop    %ebx
  801c64:	5e                   	pop    %esi
  801c65:	5d                   	pop    %ebp
  801c66:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801c67:	83 ec 0c             	sub    $0xc,%esp
  801c6a:	6a 01                	push   $0x1
  801c6c:	e8 f5 f9 ff ff       	call   801666 <ipc_find_env>
  801c71:	a3 00 40 80 00       	mov    %eax,0x804000
  801c76:	83 c4 10             	add    $0x10,%esp
  801c79:	eb c5                	jmp    801c40 <fsipc+0x12>

00801c7b <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801c7b:	55                   	push   %ebp
  801c7c:	89 e5                	mov    %esp,%ebp
  801c7e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801c81:	8b 45 08             	mov    0x8(%ebp),%eax
  801c84:	8b 40 0c             	mov    0xc(%eax),%eax
  801c87:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801c8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c8f:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801c94:	ba 00 00 00 00       	mov    $0x0,%edx
  801c99:	b8 02 00 00 00       	mov    $0x2,%eax
  801c9e:	e8 8b ff ff ff       	call   801c2e <fsipc>
}
  801ca3:	c9                   	leave  
  801ca4:	c3                   	ret    

00801ca5 <devfile_flush>:
{
  801ca5:	55                   	push   %ebp
  801ca6:	89 e5                	mov    %esp,%ebp
  801ca8:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801cab:	8b 45 08             	mov    0x8(%ebp),%eax
  801cae:	8b 40 0c             	mov    0xc(%eax),%eax
  801cb1:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801cb6:	ba 00 00 00 00       	mov    $0x0,%edx
  801cbb:	b8 06 00 00 00       	mov    $0x6,%eax
  801cc0:	e8 69 ff ff ff       	call   801c2e <fsipc>
}
  801cc5:	c9                   	leave  
  801cc6:	c3                   	ret    

00801cc7 <devfile_stat>:
{
  801cc7:	55                   	push   %ebp
  801cc8:	89 e5                	mov    %esp,%ebp
  801cca:	53                   	push   %ebx
  801ccb:	83 ec 04             	sub    $0x4,%esp
  801cce:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd4:	8b 40 0c             	mov    0xc(%eax),%eax
  801cd7:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801cdc:	ba 00 00 00 00       	mov    $0x0,%edx
  801ce1:	b8 05 00 00 00       	mov    $0x5,%eax
  801ce6:	e8 43 ff ff ff       	call   801c2e <fsipc>
  801ceb:	85 c0                	test   %eax,%eax
  801ced:	78 2c                	js     801d1b <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801cef:	83 ec 08             	sub    $0x8,%esp
  801cf2:	68 00 50 80 00       	push   $0x805000
  801cf7:	53                   	push   %ebx
  801cf8:	e8 84 f2 ff ff       	call   800f81 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801cfd:	a1 80 50 80 00       	mov    0x805080,%eax
  801d02:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801d08:	a1 84 50 80 00       	mov    0x805084,%eax
  801d0d:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801d13:	83 c4 10             	add    $0x10,%esp
  801d16:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d1b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d1e:	c9                   	leave  
  801d1f:	c3                   	ret    

00801d20 <devfile_write>:
{
  801d20:	55                   	push   %ebp
  801d21:	89 e5                	mov    %esp,%ebp
  801d23:	83 ec 0c             	sub    $0xc,%esp
	panic("devfile_write not implemented");
  801d26:	68 1c 2e 80 00       	push   $0x802e1c
  801d2b:	68 90 00 00 00       	push   $0x90
  801d30:	68 3a 2e 80 00       	push   $0x802e3a
  801d35:	e8 f2 e9 ff ff       	call   80072c <_panic>

00801d3a <devfile_read>:
{
  801d3a:	55                   	push   %ebp
  801d3b:	89 e5                	mov    %esp,%ebp
  801d3d:	56                   	push   %esi
  801d3e:	53                   	push   %ebx
  801d3f:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801d42:	8b 45 08             	mov    0x8(%ebp),%eax
  801d45:	8b 40 0c             	mov    0xc(%eax),%eax
  801d48:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801d4d:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801d53:	ba 00 00 00 00       	mov    $0x0,%edx
  801d58:	b8 03 00 00 00       	mov    $0x3,%eax
  801d5d:	e8 cc fe ff ff       	call   801c2e <fsipc>
  801d62:	89 c3                	mov    %eax,%ebx
  801d64:	85 c0                	test   %eax,%eax
  801d66:	78 1f                	js     801d87 <devfile_read+0x4d>
	assert(r <= n);
  801d68:	39 f0                	cmp    %esi,%eax
  801d6a:	77 24                	ja     801d90 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801d6c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d71:	7f 33                	jg     801da6 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801d73:	83 ec 04             	sub    $0x4,%esp
  801d76:	50                   	push   %eax
  801d77:	68 00 50 80 00       	push   $0x805000
  801d7c:	ff 75 0c             	pushl  0xc(%ebp)
  801d7f:	e8 8b f3 ff ff       	call   80110f <memmove>
	return r;
  801d84:	83 c4 10             	add    $0x10,%esp
}
  801d87:	89 d8                	mov    %ebx,%eax
  801d89:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d8c:	5b                   	pop    %ebx
  801d8d:	5e                   	pop    %esi
  801d8e:	5d                   	pop    %ebp
  801d8f:	c3                   	ret    
	assert(r <= n);
  801d90:	68 45 2e 80 00       	push   $0x802e45
  801d95:	68 4c 2e 80 00       	push   $0x802e4c
  801d9a:	6a 7c                	push   $0x7c
  801d9c:	68 3a 2e 80 00       	push   $0x802e3a
  801da1:	e8 86 e9 ff ff       	call   80072c <_panic>
	assert(r <= PGSIZE);
  801da6:	68 61 2e 80 00       	push   $0x802e61
  801dab:	68 4c 2e 80 00       	push   $0x802e4c
  801db0:	6a 7d                	push   $0x7d
  801db2:	68 3a 2e 80 00       	push   $0x802e3a
  801db7:	e8 70 e9 ff ff       	call   80072c <_panic>

00801dbc <open>:
{
  801dbc:	55                   	push   %ebp
  801dbd:	89 e5                	mov    %esp,%ebp
  801dbf:	56                   	push   %esi
  801dc0:	53                   	push   %ebx
  801dc1:	83 ec 1c             	sub    $0x1c,%esp
  801dc4:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801dc7:	56                   	push   %esi
  801dc8:	e8 7b f1 ff ff       	call   800f48 <strlen>
  801dcd:	83 c4 10             	add    $0x10,%esp
  801dd0:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801dd5:	7f 6c                	jg     801e43 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801dd7:	83 ec 0c             	sub    $0xc,%esp
  801dda:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ddd:	50                   	push   %eax
  801dde:	e8 e5 f8 ff ff       	call   8016c8 <fd_alloc>
  801de3:	89 c3                	mov    %eax,%ebx
  801de5:	83 c4 10             	add    $0x10,%esp
  801de8:	85 c0                	test   %eax,%eax
  801dea:	78 3c                	js     801e28 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801dec:	83 ec 08             	sub    $0x8,%esp
  801def:	56                   	push   %esi
  801df0:	68 00 50 80 00       	push   $0x805000
  801df5:	e8 87 f1 ff ff       	call   800f81 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801dfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dfd:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801e02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e05:	b8 01 00 00 00       	mov    $0x1,%eax
  801e0a:	e8 1f fe ff ff       	call   801c2e <fsipc>
  801e0f:	89 c3                	mov    %eax,%ebx
  801e11:	83 c4 10             	add    $0x10,%esp
  801e14:	85 c0                	test   %eax,%eax
  801e16:	78 19                	js     801e31 <open+0x75>
	return fd2num(fd);
  801e18:	83 ec 0c             	sub    $0xc,%esp
  801e1b:	ff 75 f4             	pushl  -0xc(%ebp)
  801e1e:	e8 7e f8 ff ff       	call   8016a1 <fd2num>
  801e23:	89 c3                	mov    %eax,%ebx
  801e25:	83 c4 10             	add    $0x10,%esp
}
  801e28:	89 d8                	mov    %ebx,%eax
  801e2a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e2d:	5b                   	pop    %ebx
  801e2e:	5e                   	pop    %esi
  801e2f:	5d                   	pop    %ebp
  801e30:	c3                   	ret    
		fd_close(fd, 0);
  801e31:	83 ec 08             	sub    $0x8,%esp
  801e34:	6a 00                	push   $0x0
  801e36:	ff 75 f4             	pushl  -0xc(%ebp)
  801e39:	e8 82 f9 ff ff       	call   8017c0 <fd_close>
		return r;
  801e3e:	83 c4 10             	add    $0x10,%esp
  801e41:	eb e5                	jmp    801e28 <open+0x6c>
		return -E_BAD_PATH;
  801e43:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801e48:	eb de                	jmp    801e28 <open+0x6c>

00801e4a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801e4a:	55                   	push   %ebp
  801e4b:	89 e5                	mov    %esp,%ebp
  801e4d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801e50:	ba 00 00 00 00       	mov    $0x0,%edx
  801e55:	b8 08 00 00 00       	mov    $0x8,%eax
  801e5a:	e8 cf fd ff ff       	call   801c2e <fsipc>
}
  801e5f:	c9                   	leave  
  801e60:	c3                   	ret    

00801e61 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801e61:	55                   	push   %ebp
  801e62:	89 e5                	mov    %esp,%ebp
  801e64:	56                   	push   %esi
  801e65:	53                   	push   %ebx
  801e66:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801e69:	83 ec 0c             	sub    $0xc,%esp
  801e6c:	ff 75 08             	pushl  0x8(%ebp)
  801e6f:	e8 3d f8 ff ff       	call   8016b1 <fd2data>
  801e74:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801e76:	83 c4 08             	add    $0x8,%esp
  801e79:	68 6d 2e 80 00       	push   $0x802e6d
  801e7e:	53                   	push   %ebx
  801e7f:	e8 fd f0 ff ff       	call   800f81 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801e84:	8b 46 04             	mov    0x4(%esi),%eax
  801e87:	2b 06                	sub    (%esi),%eax
  801e89:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801e8f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801e96:	00 00 00 
	stat->st_dev = &devpipe;
  801e99:	c7 83 88 00 00 00 24 	movl   $0x803024,0x88(%ebx)
  801ea0:	30 80 00 
	return 0;
}
  801ea3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801eab:	5b                   	pop    %ebx
  801eac:	5e                   	pop    %esi
  801ead:	5d                   	pop    %ebp
  801eae:	c3                   	ret    

00801eaf <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801eaf:	55                   	push   %ebp
  801eb0:	89 e5                	mov    %esp,%ebp
  801eb2:	53                   	push   %ebx
  801eb3:	83 ec 0c             	sub    $0xc,%esp
  801eb6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801eb9:	53                   	push   %ebx
  801eba:	6a 00                	push   $0x0
  801ebc:	e8 37 f5 ff ff       	call   8013f8 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ec1:	89 1c 24             	mov    %ebx,(%esp)
  801ec4:	e8 e8 f7 ff ff       	call   8016b1 <fd2data>
  801ec9:	83 c4 08             	add    $0x8,%esp
  801ecc:	50                   	push   %eax
  801ecd:	6a 00                	push   $0x0
  801ecf:	e8 24 f5 ff ff       	call   8013f8 <sys_page_unmap>
}
  801ed4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ed7:	c9                   	leave  
  801ed8:	c3                   	ret    

00801ed9 <_pipeisclosed>:
{
  801ed9:	55                   	push   %ebp
  801eda:	89 e5                	mov    %esp,%ebp
  801edc:	57                   	push   %edi
  801edd:	56                   	push   %esi
  801ede:	53                   	push   %ebx
  801edf:	83 ec 1c             	sub    $0x1c,%esp
  801ee2:	89 c7                	mov    %eax,%edi
  801ee4:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801ee6:	a1 04 40 80 00       	mov    0x804004,%eax
  801eeb:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801eee:	83 ec 0c             	sub    $0xc,%esp
  801ef1:	57                   	push   %edi
  801ef2:	e8 2d 04 00 00       	call   802324 <pageref>
  801ef7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801efa:	89 34 24             	mov    %esi,(%esp)
  801efd:	e8 22 04 00 00       	call   802324 <pageref>
		nn = thisenv->env_runs;
  801f02:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801f08:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801f0b:	83 c4 10             	add    $0x10,%esp
  801f0e:	39 cb                	cmp    %ecx,%ebx
  801f10:	74 1b                	je     801f2d <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801f12:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801f15:	75 cf                	jne    801ee6 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801f17:	8b 42 58             	mov    0x58(%edx),%eax
  801f1a:	6a 01                	push   $0x1
  801f1c:	50                   	push   %eax
  801f1d:	53                   	push   %ebx
  801f1e:	68 74 2e 80 00       	push   $0x802e74
  801f23:	e8 fa e8 ff ff       	call   800822 <cprintf>
  801f28:	83 c4 10             	add    $0x10,%esp
  801f2b:	eb b9                	jmp    801ee6 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801f2d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801f30:	0f 94 c0             	sete   %al
  801f33:	0f b6 c0             	movzbl %al,%eax
}
  801f36:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f39:	5b                   	pop    %ebx
  801f3a:	5e                   	pop    %esi
  801f3b:	5f                   	pop    %edi
  801f3c:	5d                   	pop    %ebp
  801f3d:	c3                   	ret    

00801f3e <devpipe_write>:
{
  801f3e:	55                   	push   %ebp
  801f3f:	89 e5                	mov    %esp,%ebp
  801f41:	57                   	push   %edi
  801f42:	56                   	push   %esi
  801f43:	53                   	push   %ebx
  801f44:	83 ec 28             	sub    $0x28,%esp
  801f47:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801f4a:	56                   	push   %esi
  801f4b:	e8 61 f7 ff ff       	call   8016b1 <fd2data>
  801f50:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f52:	83 c4 10             	add    $0x10,%esp
  801f55:	bf 00 00 00 00       	mov    $0x0,%edi
  801f5a:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801f5d:	74 4f                	je     801fae <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801f5f:	8b 43 04             	mov    0x4(%ebx),%eax
  801f62:	8b 0b                	mov    (%ebx),%ecx
  801f64:	8d 51 20             	lea    0x20(%ecx),%edx
  801f67:	39 d0                	cmp    %edx,%eax
  801f69:	72 14                	jb     801f7f <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801f6b:	89 da                	mov    %ebx,%edx
  801f6d:	89 f0                	mov    %esi,%eax
  801f6f:	e8 65 ff ff ff       	call   801ed9 <_pipeisclosed>
  801f74:	85 c0                	test   %eax,%eax
  801f76:	75 3b                	jne    801fb3 <devpipe_write+0x75>
			sys_yield();
  801f78:	e8 d7 f3 ff ff       	call   801354 <sys_yield>
  801f7d:	eb e0                	jmp    801f5f <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801f7f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f82:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801f86:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801f89:	89 c2                	mov    %eax,%edx
  801f8b:	c1 fa 1f             	sar    $0x1f,%edx
  801f8e:	89 d1                	mov    %edx,%ecx
  801f90:	c1 e9 1b             	shr    $0x1b,%ecx
  801f93:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801f96:	83 e2 1f             	and    $0x1f,%edx
  801f99:	29 ca                	sub    %ecx,%edx
  801f9b:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801f9f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801fa3:	83 c0 01             	add    $0x1,%eax
  801fa6:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801fa9:	83 c7 01             	add    $0x1,%edi
  801fac:	eb ac                	jmp    801f5a <devpipe_write+0x1c>
	return i;
  801fae:	8b 45 10             	mov    0x10(%ebp),%eax
  801fb1:	eb 05                	jmp    801fb8 <devpipe_write+0x7a>
				return 0;
  801fb3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fbb:	5b                   	pop    %ebx
  801fbc:	5e                   	pop    %esi
  801fbd:	5f                   	pop    %edi
  801fbe:	5d                   	pop    %ebp
  801fbf:	c3                   	ret    

00801fc0 <devpipe_read>:
{
  801fc0:	55                   	push   %ebp
  801fc1:	89 e5                	mov    %esp,%ebp
  801fc3:	57                   	push   %edi
  801fc4:	56                   	push   %esi
  801fc5:	53                   	push   %ebx
  801fc6:	83 ec 18             	sub    $0x18,%esp
  801fc9:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801fcc:	57                   	push   %edi
  801fcd:	e8 df f6 ff ff       	call   8016b1 <fd2data>
  801fd2:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801fd4:	83 c4 10             	add    $0x10,%esp
  801fd7:	be 00 00 00 00       	mov    $0x0,%esi
  801fdc:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fdf:	75 14                	jne    801ff5 <devpipe_read+0x35>
	return i;
  801fe1:	8b 45 10             	mov    0x10(%ebp),%eax
  801fe4:	eb 02                	jmp    801fe8 <devpipe_read+0x28>
				return i;
  801fe6:	89 f0                	mov    %esi,%eax
}
  801fe8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801feb:	5b                   	pop    %ebx
  801fec:	5e                   	pop    %esi
  801fed:	5f                   	pop    %edi
  801fee:	5d                   	pop    %ebp
  801fef:	c3                   	ret    
			sys_yield();
  801ff0:	e8 5f f3 ff ff       	call   801354 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801ff5:	8b 03                	mov    (%ebx),%eax
  801ff7:	3b 43 04             	cmp    0x4(%ebx),%eax
  801ffa:	75 18                	jne    802014 <devpipe_read+0x54>
			if (i > 0)
  801ffc:	85 f6                	test   %esi,%esi
  801ffe:	75 e6                	jne    801fe6 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802000:	89 da                	mov    %ebx,%edx
  802002:	89 f8                	mov    %edi,%eax
  802004:	e8 d0 fe ff ff       	call   801ed9 <_pipeisclosed>
  802009:	85 c0                	test   %eax,%eax
  80200b:	74 e3                	je     801ff0 <devpipe_read+0x30>
				return 0;
  80200d:	b8 00 00 00 00       	mov    $0x0,%eax
  802012:	eb d4                	jmp    801fe8 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802014:	99                   	cltd   
  802015:	c1 ea 1b             	shr    $0x1b,%edx
  802018:	01 d0                	add    %edx,%eax
  80201a:	83 e0 1f             	and    $0x1f,%eax
  80201d:	29 d0                	sub    %edx,%eax
  80201f:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802024:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802027:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80202a:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80202d:	83 c6 01             	add    $0x1,%esi
  802030:	eb aa                	jmp    801fdc <devpipe_read+0x1c>

00802032 <pipe>:
{
  802032:	55                   	push   %ebp
  802033:	89 e5                	mov    %esp,%ebp
  802035:	56                   	push   %esi
  802036:	53                   	push   %ebx
  802037:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80203a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80203d:	50                   	push   %eax
  80203e:	e8 85 f6 ff ff       	call   8016c8 <fd_alloc>
  802043:	89 c3                	mov    %eax,%ebx
  802045:	83 c4 10             	add    $0x10,%esp
  802048:	85 c0                	test   %eax,%eax
  80204a:	0f 88 23 01 00 00    	js     802173 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802050:	83 ec 04             	sub    $0x4,%esp
  802053:	68 07 04 00 00       	push   $0x407
  802058:	ff 75 f4             	pushl  -0xc(%ebp)
  80205b:	6a 00                	push   $0x0
  80205d:	e8 11 f3 ff ff       	call   801373 <sys_page_alloc>
  802062:	89 c3                	mov    %eax,%ebx
  802064:	83 c4 10             	add    $0x10,%esp
  802067:	85 c0                	test   %eax,%eax
  802069:	0f 88 04 01 00 00    	js     802173 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80206f:	83 ec 0c             	sub    $0xc,%esp
  802072:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802075:	50                   	push   %eax
  802076:	e8 4d f6 ff ff       	call   8016c8 <fd_alloc>
  80207b:	89 c3                	mov    %eax,%ebx
  80207d:	83 c4 10             	add    $0x10,%esp
  802080:	85 c0                	test   %eax,%eax
  802082:	0f 88 db 00 00 00    	js     802163 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802088:	83 ec 04             	sub    $0x4,%esp
  80208b:	68 07 04 00 00       	push   $0x407
  802090:	ff 75 f0             	pushl  -0x10(%ebp)
  802093:	6a 00                	push   $0x0
  802095:	e8 d9 f2 ff ff       	call   801373 <sys_page_alloc>
  80209a:	89 c3                	mov    %eax,%ebx
  80209c:	83 c4 10             	add    $0x10,%esp
  80209f:	85 c0                	test   %eax,%eax
  8020a1:	0f 88 bc 00 00 00    	js     802163 <pipe+0x131>
	va = fd2data(fd0);
  8020a7:	83 ec 0c             	sub    $0xc,%esp
  8020aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8020ad:	e8 ff f5 ff ff       	call   8016b1 <fd2data>
  8020b2:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020b4:	83 c4 0c             	add    $0xc,%esp
  8020b7:	68 07 04 00 00       	push   $0x407
  8020bc:	50                   	push   %eax
  8020bd:	6a 00                	push   $0x0
  8020bf:	e8 af f2 ff ff       	call   801373 <sys_page_alloc>
  8020c4:	89 c3                	mov    %eax,%ebx
  8020c6:	83 c4 10             	add    $0x10,%esp
  8020c9:	85 c0                	test   %eax,%eax
  8020cb:	0f 88 82 00 00 00    	js     802153 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020d1:	83 ec 0c             	sub    $0xc,%esp
  8020d4:	ff 75 f0             	pushl  -0x10(%ebp)
  8020d7:	e8 d5 f5 ff ff       	call   8016b1 <fd2data>
  8020dc:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8020e3:	50                   	push   %eax
  8020e4:	6a 00                	push   $0x0
  8020e6:	56                   	push   %esi
  8020e7:	6a 00                	push   $0x0
  8020e9:	e8 c8 f2 ff ff       	call   8013b6 <sys_page_map>
  8020ee:	89 c3                	mov    %eax,%ebx
  8020f0:	83 c4 20             	add    $0x20,%esp
  8020f3:	85 c0                	test   %eax,%eax
  8020f5:	78 4e                	js     802145 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8020f7:	a1 24 30 80 00       	mov    0x803024,%eax
  8020fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020ff:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802101:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802104:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80210b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80210e:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802110:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802113:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80211a:	83 ec 0c             	sub    $0xc,%esp
  80211d:	ff 75 f4             	pushl  -0xc(%ebp)
  802120:	e8 7c f5 ff ff       	call   8016a1 <fd2num>
  802125:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802128:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80212a:	83 c4 04             	add    $0x4,%esp
  80212d:	ff 75 f0             	pushl  -0x10(%ebp)
  802130:	e8 6c f5 ff ff       	call   8016a1 <fd2num>
  802135:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802138:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80213b:	83 c4 10             	add    $0x10,%esp
  80213e:	bb 00 00 00 00       	mov    $0x0,%ebx
  802143:	eb 2e                	jmp    802173 <pipe+0x141>
	sys_page_unmap(0, va);
  802145:	83 ec 08             	sub    $0x8,%esp
  802148:	56                   	push   %esi
  802149:	6a 00                	push   $0x0
  80214b:	e8 a8 f2 ff ff       	call   8013f8 <sys_page_unmap>
  802150:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802153:	83 ec 08             	sub    $0x8,%esp
  802156:	ff 75 f0             	pushl  -0x10(%ebp)
  802159:	6a 00                	push   $0x0
  80215b:	e8 98 f2 ff ff       	call   8013f8 <sys_page_unmap>
  802160:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802163:	83 ec 08             	sub    $0x8,%esp
  802166:	ff 75 f4             	pushl  -0xc(%ebp)
  802169:	6a 00                	push   $0x0
  80216b:	e8 88 f2 ff ff       	call   8013f8 <sys_page_unmap>
  802170:	83 c4 10             	add    $0x10,%esp
}
  802173:	89 d8                	mov    %ebx,%eax
  802175:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802178:	5b                   	pop    %ebx
  802179:	5e                   	pop    %esi
  80217a:	5d                   	pop    %ebp
  80217b:	c3                   	ret    

0080217c <pipeisclosed>:
{
  80217c:	55                   	push   %ebp
  80217d:	89 e5                	mov    %esp,%ebp
  80217f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802182:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802185:	50                   	push   %eax
  802186:	ff 75 08             	pushl  0x8(%ebp)
  802189:	e8 8c f5 ff ff       	call   80171a <fd_lookup>
  80218e:	83 c4 10             	add    $0x10,%esp
  802191:	85 c0                	test   %eax,%eax
  802193:	78 18                	js     8021ad <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802195:	83 ec 0c             	sub    $0xc,%esp
  802198:	ff 75 f4             	pushl  -0xc(%ebp)
  80219b:	e8 11 f5 ff ff       	call   8016b1 <fd2data>
	return _pipeisclosed(fd, p);
  8021a0:	89 c2                	mov    %eax,%edx
  8021a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a5:	e8 2f fd ff ff       	call   801ed9 <_pipeisclosed>
  8021aa:	83 c4 10             	add    $0x10,%esp
}
  8021ad:	c9                   	leave  
  8021ae:	c3                   	ret    

008021af <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8021af:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b4:	c3                   	ret    

008021b5 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8021b5:	55                   	push   %ebp
  8021b6:	89 e5                	mov    %esp,%ebp
  8021b8:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8021bb:	68 8c 2e 80 00       	push   $0x802e8c
  8021c0:	ff 75 0c             	pushl  0xc(%ebp)
  8021c3:	e8 b9 ed ff ff       	call   800f81 <strcpy>
	return 0;
}
  8021c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8021cd:	c9                   	leave  
  8021ce:	c3                   	ret    

008021cf <devcons_write>:
{
  8021cf:	55                   	push   %ebp
  8021d0:	89 e5                	mov    %esp,%ebp
  8021d2:	57                   	push   %edi
  8021d3:	56                   	push   %esi
  8021d4:	53                   	push   %ebx
  8021d5:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8021db:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8021e0:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8021e6:	3b 75 10             	cmp    0x10(%ebp),%esi
  8021e9:	73 31                	jae    80221c <devcons_write+0x4d>
		m = n - tot;
  8021eb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8021ee:	29 f3                	sub    %esi,%ebx
  8021f0:	83 fb 7f             	cmp    $0x7f,%ebx
  8021f3:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8021f8:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8021fb:	83 ec 04             	sub    $0x4,%esp
  8021fe:	53                   	push   %ebx
  8021ff:	89 f0                	mov    %esi,%eax
  802201:	03 45 0c             	add    0xc(%ebp),%eax
  802204:	50                   	push   %eax
  802205:	57                   	push   %edi
  802206:	e8 04 ef ff ff       	call   80110f <memmove>
		sys_cputs(buf, m);
  80220b:	83 c4 08             	add    $0x8,%esp
  80220e:	53                   	push   %ebx
  80220f:	57                   	push   %edi
  802210:	e8 a2 f0 ff ff       	call   8012b7 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802215:	01 de                	add    %ebx,%esi
  802217:	83 c4 10             	add    $0x10,%esp
  80221a:	eb ca                	jmp    8021e6 <devcons_write+0x17>
}
  80221c:	89 f0                	mov    %esi,%eax
  80221e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802221:	5b                   	pop    %ebx
  802222:	5e                   	pop    %esi
  802223:	5f                   	pop    %edi
  802224:	5d                   	pop    %ebp
  802225:	c3                   	ret    

00802226 <devcons_read>:
{
  802226:	55                   	push   %ebp
  802227:	89 e5                	mov    %esp,%ebp
  802229:	83 ec 08             	sub    $0x8,%esp
  80222c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802231:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802235:	74 21                	je     802258 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802237:	e8 99 f0 ff ff       	call   8012d5 <sys_cgetc>
  80223c:	85 c0                	test   %eax,%eax
  80223e:	75 07                	jne    802247 <devcons_read+0x21>
		sys_yield();
  802240:	e8 0f f1 ff ff       	call   801354 <sys_yield>
  802245:	eb f0                	jmp    802237 <devcons_read+0x11>
	if (c < 0)
  802247:	78 0f                	js     802258 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802249:	83 f8 04             	cmp    $0x4,%eax
  80224c:	74 0c                	je     80225a <devcons_read+0x34>
	*(char*)vbuf = c;
  80224e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802251:	88 02                	mov    %al,(%edx)
	return 1;
  802253:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802258:	c9                   	leave  
  802259:	c3                   	ret    
		return 0;
  80225a:	b8 00 00 00 00       	mov    $0x0,%eax
  80225f:	eb f7                	jmp    802258 <devcons_read+0x32>

00802261 <cputchar>:
{
  802261:	55                   	push   %ebp
  802262:	89 e5                	mov    %esp,%ebp
  802264:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802267:	8b 45 08             	mov    0x8(%ebp),%eax
  80226a:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80226d:	6a 01                	push   $0x1
  80226f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802272:	50                   	push   %eax
  802273:	e8 3f f0 ff ff       	call   8012b7 <sys_cputs>
}
  802278:	83 c4 10             	add    $0x10,%esp
  80227b:	c9                   	leave  
  80227c:	c3                   	ret    

0080227d <getchar>:
{
  80227d:	55                   	push   %ebp
  80227e:	89 e5                	mov    %esp,%ebp
  802280:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802283:	6a 01                	push   $0x1
  802285:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802288:	50                   	push   %eax
  802289:	6a 00                	push   $0x0
  80228b:	e8 f5 f6 ff ff       	call   801985 <read>
	if (r < 0)
  802290:	83 c4 10             	add    $0x10,%esp
  802293:	85 c0                	test   %eax,%eax
  802295:	78 06                	js     80229d <getchar+0x20>
	if (r < 1)
  802297:	74 06                	je     80229f <getchar+0x22>
	return c;
  802299:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80229d:	c9                   	leave  
  80229e:	c3                   	ret    
		return -E_EOF;
  80229f:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8022a4:	eb f7                	jmp    80229d <getchar+0x20>

008022a6 <iscons>:
{
  8022a6:	55                   	push   %ebp
  8022a7:	89 e5                	mov    %esp,%ebp
  8022a9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022af:	50                   	push   %eax
  8022b0:	ff 75 08             	pushl  0x8(%ebp)
  8022b3:	e8 62 f4 ff ff       	call   80171a <fd_lookup>
  8022b8:	83 c4 10             	add    $0x10,%esp
  8022bb:	85 c0                	test   %eax,%eax
  8022bd:	78 11                	js     8022d0 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8022bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c2:	8b 15 40 30 80 00    	mov    0x803040,%edx
  8022c8:	39 10                	cmp    %edx,(%eax)
  8022ca:	0f 94 c0             	sete   %al
  8022cd:	0f b6 c0             	movzbl %al,%eax
}
  8022d0:	c9                   	leave  
  8022d1:	c3                   	ret    

008022d2 <opencons>:
{
  8022d2:	55                   	push   %ebp
  8022d3:	89 e5                	mov    %esp,%ebp
  8022d5:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8022d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022db:	50                   	push   %eax
  8022dc:	e8 e7 f3 ff ff       	call   8016c8 <fd_alloc>
  8022e1:	83 c4 10             	add    $0x10,%esp
  8022e4:	85 c0                	test   %eax,%eax
  8022e6:	78 3a                	js     802322 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8022e8:	83 ec 04             	sub    $0x4,%esp
  8022eb:	68 07 04 00 00       	push   $0x407
  8022f0:	ff 75 f4             	pushl  -0xc(%ebp)
  8022f3:	6a 00                	push   $0x0
  8022f5:	e8 79 f0 ff ff       	call   801373 <sys_page_alloc>
  8022fa:	83 c4 10             	add    $0x10,%esp
  8022fd:	85 c0                	test   %eax,%eax
  8022ff:	78 21                	js     802322 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802301:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802304:	8b 15 40 30 80 00    	mov    0x803040,%edx
  80230a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80230c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802316:	83 ec 0c             	sub    $0xc,%esp
  802319:	50                   	push   %eax
  80231a:	e8 82 f3 ff ff       	call   8016a1 <fd2num>
  80231f:	83 c4 10             	add    $0x10,%esp
}
  802322:	c9                   	leave  
  802323:	c3                   	ret    

00802324 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802324:	55                   	push   %ebp
  802325:	89 e5                	mov    %esp,%ebp
  802327:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80232a:	89 d0                	mov    %edx,%eax
  80232c:	c1 e8 16             	shr    $0x16,%eax
  80232f:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802336:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80233b:	f6 c1 01             	test   $0x1,%cl
  80233e:	74 1d                	je     80235d <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802340:	c1 ea 0c             	shr    $0xc,%edx
  802343:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80234a:	f6 c2 01             	test   $0x1,%dl
  80234d:	74 0e                	je     80235d <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80234f:	c1 ea 0c             	shr    $0xc,%edx
  802352:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802359:	ef 
  80235a:	0f b7 c0             	movzwl %ax,%eax
}
  80235d:	5d                   	pop    %ebp
  80235e:	c3                   	ret    
  80235f:	90                   	nop

00802360 <__udivdi3>:
  802360:	55                   	push   %ebp
  802361:	57                   	push   %edi
  802362:	56                   	push   %esi
  802363:	53                   	push   %ebx
  802364:	83 ec 1c             	sub    $0x1c,%esp
  802367:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80236b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80236f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802373:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802377:	85 d2                	test   %edx,%edx
  802379:	75 4d                	jne    8023c8 <__udivdi3+0x68>
  80237b:	39 f3                	cmp    %esi,%ebx
  80237d:	76 19                	jbe    802398 <__udivdi3+0x38>
  80237f:	31 ff                	xor    %edi,%edi
  802381:	89 e8                	mov    %ebp,%eax
  802383:	89 f2                	mov    %esi,%edx
  802385:	f7 f3                	div    %ebx
  802387:	89 fa                	mov    %edi,%edx
  802389:	83 c4 1c             	add    $0x1c,%esp
  80238c:	5b                   	pop    %ebx
  80238d:	5e                   	pop    %esi
  80238e:	5f                   	pop    %edi
  80238f:	5d                   	pop    %ebp
  802390:	c3                   	ret    
  802391:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802398:	89 d9                	mov    %ebx,%ecx
  80239a:	85 db                	test   %ebx,%ebx
  80239c:	75 0b                	jne    8023a9 <__udivdi3+0x49>
  80239e:	b8 01 00 00 00       	mov    $0x1,%eax
  8023a3:	31 d2                	xor    %edx,%edx
  8023a5:	f7 f3                	div    %ebx
  8023a7:	89 c1                	mov    %eax,%ecx
  8023a9:	31 d2                	xor    %edx,%edx
  8023ab:	89 f0                	mov    %esi,%eax
  8023ad:	f7 f1                	div    %ecx
  8023af:	89 c6                	mov    %eax,%esi
  8023b1:	89 e8                	mov    %ebp,%eax
  8023b3:	89 f7                	mov    %esi,%edi
  8023b5:	f7 f1                	div    %ecx
  8023b7:	89 fa                	mov    %edi,%edx
  8023b9:	83 c4 1c             	add    $0x1c,%esp
  8023bc:	5b                   	pop    %ebx
  8023bd:	5e                   	pop    %esi
  8023be:	5f                   	pop    %edi
  8023bf:	5d                   	pop    %ebp
  8023c0:	c3                   	ret    
  8023c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023c8:	39 f2                	cmp    %esi,%edx
  8023ca:	77 1c                	ja     8023e8 <__udivdi3+0x88>
  8023cc:	0f bd fa             	bsr    %edx,%edi
  8023cf:	83 f7 1f             	xor    $0x1f,%edi
  8023d2:	75 2c                	jne    802400 <__udivdi3+0xa0>
  8023d4:	39 f2                	cmp    %esi,%edx
  8023d6:	72 06                	jb     8023de <__udivdi3+0x7e>
  8023d8:	31 c0                	xor    %eax,%eax
  8023da:	39 eb                	cmp    %ebp,%ebx
  8023dc:	77 a9                	ja     802387 <__udivdi3+0x27>
  8023de:	b8 01 00 00 00       	mov    $0x1,%eax
  8023e3:	eb a2                	jmp    802387 <__udivdi3+0x27>
  8023e5:	8d 76 00             	lea    0x0(%esi),%esi
  8023e8:	31 ff                	xor    %edi,%edi
  8023ea:	31 c0                	xor    %eax,%eax
  8023ec:	89 fa                	mov    %edi,%edx
  8023ee:	83 c4 1c             	add    $0x1c,%esp
  8023f1:	5b                   	pop    %ebx
  8023f2:	5e                   	pop    %esi
  8023f3:	5f                   	pop    %edi
  8023f4:	5d                   	pop    %ebp
  8023f5:	c3                   	ret    
  8023f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023fd:	8d 76 00             	lea    0x0(%esi),%esi
  802400:	89 f9                	mov    %edi,%ecx
  802402:	b8 20 00 00 00       	mov    $0x20,%eax
  802407:	29 f8                	sub    %edi,%eax
  802409:	d3 e2                	shl    %cl,%edx
  80240b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80240f:	89 c1                	mov    %eax,%ecx
  802411:	89 da                	mov    %ebx,%edx
  802413:	d3 ea                	shr    %cl,%edx
  802415:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802419:	09 d1                	or     %edx,%ecx
  80241b:	89 f2                	mov    %esi,%edx
  80241d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802421:	89 f9                	mov    %edi,%ecx
  802423:	d3 e3                	shl    %cl,%ebx
  802425:	89 c1                	mov    %eax,%ecx
  802427:	d3 ea                	shr    %cl,%edx
  802429:	89 f9                	mov    %edi,%ecx
  80242b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80242f:	89 eb                	mov    %ebp,%ebx
  802431:	d3 e6                	shl    %cl,%esi
  802433:	89 c1                	mov    %eax,%ecx
  802435:	d3 eb                	shr    %cl,%ebx
  802437:	09 de                	or     %ebx,%esi
  802439:	89 f0                	mov    %esi,%eax
  80243b:	f7 74 24 08          	divl   0x8(%esp)
  80243f:	89 d6                	mov    %edx,%esi
  802441:	89 c3                	mov    %eax,%ebx
  802443:	f7 64 24 0c          	mull   0xc(%esp)
  802447:	39 d6                	cmp    %edx,%esi
  802449:	72 15                	jb     802460 <__udivdi3+0x100>
  80244b:	89 f9                	mov    %edi,%ecx
  80244d:	d3 e5                	shl    %cl,%ebp
  80244f:	39 c5                	cmp    %eax,%ebp
  802451:	73 04                	jae    802457 <__udivdi3+0xf7>
  802453:	39 d6                	cmp    %edx,%esi
  802455:	74 09                	je     802460 <__udivdi3+0x100>
  802457:	89 d8                	mov    %ebx,%eax
  802459:	31 ff                	xor    %edi,%edi
  80245b:	e9 27 ff ff ff       	jmp    802387 <__udivdi3+0x27>
  802460:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802463:	31 ff                	xor    %edi,%edi
  802465:	e9 1d ff ff ff       	jmp    802387 <__udivdi3+0x27>
  80246a:	66 90                	xchg   %ax,%ax
  80246c:	66 90                	xchg   %ax,%ax
  80246e:	66 90                	xchg   %ax,%ax

00802470 <__umoddi3>:
  802470:	55                   	push   %ebp
  802471:	57                   	push   %edi
  802472:	56                   	push   %esi
  802473:	53                   	push   %ebx
  802474:	83 ec 1c             	sub    $0x1c,%esp
  802477:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80247b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80247f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802483:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802487:	89 da                	mov    %ebx,%edx
  802489:	85 c0                	test   %eax,%eax
  80248b:	75 43                	jne    8024d0 <__umoddi3+0x60>
  80248d:	39 df                	cmp    %ebx,%edi
  80248f:	76 17                	jbe    8024a8 <__umoddi3+0x38>
  802491:	89 f0                	mov    %esi,%eax
  802493:	f7 f7                	div    %edi
  802495:	89 d0                	mov    %edx,%eax
  802497:	31 d2                	xor    %edx,%edx
  802499:	83 c4 1c             	add    $0x1c,%esp
  80249c:	5b                   	pop    %ebx
  80249d:	5e                   	pop    %esi
  80249e:	5f                   	pop    %edi
  80249f:	5d                   	pop    %ebp
  8024a0:	c3                   	ret    
  8024a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024a8:	89 fd                	mov    %edi,%ebp
  8024aa:	85 ff                	test   %edi,%edi
  8024ac:	75 0b                	jne    8024b9 <__umoddi3+0x49>
  8024ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8024b3:	31 d2                	xor    %edx,%edx
  8024b5:	f7 f7                	div    %edi
  8024b7:	89 c5                	mov    %eax,%ebp
  8024b9:	89 d8                	mov    %ebx,%eax
  8024bb:	31 d2                	xor    %edx,%edx
  8024bd:	f7 f5                	div    %ebp
  8024bf:	89 f0                	mov    %esi,%eax
  8024c1:	f7 f5                	div    %ebp
  8024c3:	89 d0                	mov    %edx,%eax
  8024c5:	eb d0                	jmp    802497 <__umoddi3+0x27>
  8024c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024ce:	66 90                	xchg   %ax,%ax
  8024d0:	89 f1                	mov    %esi,%ecx
  8024d2:	39 d8                	cmp    %ebx,%eax
  8024d4:	76 0a                	jbe    8024e0 <__umoddi3+0x70>
  8024d6:	89 f0                	mov    %esi,%eax
  8024d8:	83 c4 1c             	add    $0x1c,%esp
  8024db:	5b                   	pop    %ebx
  8024dc:	5e                   	pop    %esi
  8024dd:	5f                   	pop    %edi
  8024de:	5d                   	pop    %ebp
  8024df:	c3                   	ret    
  8024e0:	0f bd e8             	bsr    %eax,%ebp
  8024e3:	83 f5 1f             	xor    $0x1f,%ebp
  8024e6:	75 20                	jne    802508 <__umoddi3+0x98>
  8024e8:	39 d8                	cmp    %ebx,%eax
  8024ea:	0f 82 b0 00 00 00    	jb     8025a0 <__umoddi3+0x130>
  8024f0:	39 f7                	cmp    %esi,%edi
  8024f2:	0f 86 a8 00 00 00    	jbe    8025a0 <__umoddi3+0x130>
  8024f8:	89 c8                	mov    %ecx,%eax
  8024fa:	83 c4 1c             	add    $0x1c,%esp
  8024fd:	5b                   	pop    %ebx
  8024fe:	5e                   	pop    %esi
  8024ff:	5f                   	pop    %edi
  802500:	5d                   	pop    %ebp
  802501:	c3                   	ret    
  802502:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802508:	89 e9                	mov    %ebp,%ecx
  80250a:	ba 20 00 00 00       	mov    $0x20,%edx
  80250f:	29 ea                	sub    %ebp,%edx
  802511:	d3 e0                	shl    %cl,%eax
  802513:	89 44 24 08          	mov    %eax,0x8(%esp)
  802517:	89 d1                	mov    %edx,%ecx
  802519:	89 f8                	mov    %edi,%eax
  80251b:	d3 e8                	shr    %cl,%eax
  80251d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802521:	89 54 24 04          	mov    %edx,0x4(%esp)
  802525:	8b 54 24 04          	mov    0x4(%esp),%edx
  802529:	09 c1                	or     %eax,%ecx
  80252b:	89 d8                	mov    %ebx,%eax
  80252d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802531:	89 e9                	mov    %ebp,%ecx
  802533:	d3 e7                	shl    %cl,%edi
  802535:	89 d1                	mov    %edx,%ecx
  802537:	d3 e8                	shr    %cl,%eax
  802539:	89 e9                	mov    %ebp,%ecx
  80253b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80253f:	d3 e3                	shl    %cl,%ebx
  802541:	89 c7                	mov    %eax,%edi
  802543:	89 d1                	mov    %edx,%ecx
  802545:	89 f0                	mov    %esi,%eax
  802547:	d3 e8                	shr    %cl,%eax
  802549:	89 e9                	mov    %ebp,%ecx
  80254b:	89 fa                	mov    %edi,%edx
  80254d:	d3 e6                	shl    %cl,%esi
  80254f:	09 d8                	or     %ebx,%eax
  802551:	f7 74 24 08          	divl   0x8(%esp)
  802555:	89 d1                	mov    %edx,%ecx
  802557:	89 f3                	mov    %esi,%ebx
  802559:	f7 64 24 0c          	mull   0xc(%esp)
  80255d:	89 c6                	mov    %eax,%esi
  80255f:	89 d7                	mov    %edx,%edi
  802561:	39 d1                	cmp    %edx,%ecx
  802563:	72 06                	jb     80256b <__umoddi3+0xfb>
  802565:	75 10                	jne    802577 <__umoddi3+0x107>
  802567:	39 c3                	cmp    %eax,%ebx
  802569:	73 0c                	jae    802577 <__umoddi3+0x107>
  80256b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80256f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802573:	89 d7                	mov    %edx,%edi
  802575:	89 c6                	mov    %eax,%esi
  802577:	89 ca                	mov    %ecx,%edx
  802579:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80257e:	29 f3                	sub    %esi,%ebx
  802580:	19 fa                	sbb    %edi,%edx
  802582:	89 d0                	mov    %edx,%eax
  802584:	d3 e0                	shl    %cl,%eax
  802586:	89 e9                	mov    %ebp,%ecx
  802588:	d3 eb                	shr    %cl,%ebx
  80258a:	d3 ea                	shr    %cl,%edx
  80258c:	09 d8                	or     %ebx,%eax
  80258e:	83 c4 1c             	add    $0x1c,%esp
  802591:	5b                   	pop    %ebx
  802592:	5e                   	pop    %esi
  802593:	5f                   	pop    %edi
  802594:	5d                   	pop    %ebp
  802595:	c3                   	ret    
  802596:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80259d:	8d 76 00             	lea    0x0(%esi),%esi
  8025a0:	89 da                	mov    %ebx,%edx
  8025a2:	29 fe                	sub    %edi,%esi
  8025a4:	19 c2                	sbb    %eax,%edx
  8025a6:	89 f1                	mov    %esi,%ecx
  8025a8:	89 c8                	mov    %ecx,%eax
  8025aa:	e9 4b ff ff ff       	jmp    8024fa <__umoddi3+0x8a>
