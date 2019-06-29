
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
  800042:	e8 3f 0f 00 00       	call   800f86 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800047:	89 1d 00 64 80 00    	mov    %ebx,0x806400

	fsenv = ipc_find_env(ENV_TYPE_FS);
  80004d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800054:	e8 d5 16 00 00       	call   80172e <ipc_find_env>
	ipc_send(fsenv, FSREQ_OPEN, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800059:	6a 07                	push   $0x7
  80005b:	68 00 60 80 00       	push   $0x806000
  800060:	6a 01                	push   $0x1
  800062:	50                   	push   %eax
  800063:	e8 6e 16 00 00       	call   8016d6 <ipc_send>
	return ipc_recv(NULL, FVA, NULL);
  800068:	83 c4 1c             	add    $0x1c,%esp
  80006b:	6a 00                	push   $0x0
  80006d:	68 00 c0 cc cc       	push   $0xccccc000
  800072:	6a 00                	push   $0x0
  800074:	e8 f4 15 00 00       	call   80166d <ipc_recv>
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
  80008f:	b8 60 2b 80 00       	mov    $0x802b60,%eax
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
  8000b3:	b8 95 2b 80 00       	mov    $0x802b95,%eax
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
  8000ef:	68 b6 2b 80 00       	push   $0x802bb6
  8000f4:	e8 2e 07 00 00       	call   800827 <cprintf>

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
  800122:	e8 26 0e 00 00       	call   800f4d <strlen>
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  80012d:	0f 85 d2 03 00 00    	jne    800505 <umain+0x487>
		panic("file_stat returned size %d wanted %d\n", st.st_size, strlen(msg));
	cprintf("file_stat is good\n");
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	68 d8 2b 80 00       	push   $0x802bd8
  80013b:	e8 e7 06 00 00       	call   800827 <cprintf>

	memset(buf, 0, sizeof buf);
  800140:	83 c4 0c             	add    $0xc,%esp
  800143:	68 00 02 00 00       	push   $0x200
  800148:	6a 00                	push   $0x0
  80014a:	8d 9d 4c fd ff ff    	lea    -0x2b4(%ebp),%ebx
  800150:	53                   	push   %ebx
  800151:	e8 76 0f 00 00       	call   8010cc <memset>
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
  800185:	e8 a7 0e 00 00       	call   801031 <strcmp>
  80018a:	83 c4 10             	add    $0x10,%esp
  80018d:	85 c0                	test   %eax,%eax
  80018f:	0f 85 a7 03 00 00    	jne    80053c <umain+0x4be>
		panic("file_read returned wrong data");
	cprintf("file_read is good\n");
  800195:	83 ec 0c             	sub    $0xc,%esp
  800198:	68 17 2c 80 00       	push   $0x802c17
  80019d:	e8 85 06 00 00       	call   800827 <cprintf>

	if ((r = devfile.dev_close(FVA)) < 0)
  8001a2:	c7 04 24 00 c0 cc cc 	movl   $0xccccc000,(%esp)
  8001a9:	ff 15 18 40 80 00    	call   *0x804018
  8001af:	83 c4 10             	add    $0x10,%esp
  8001b2:	85 c0                	test   %eax,%eax
  8001b4:	0f 88 96 03 00 00    	js     800550 <umain+0x4d2>
		panic("file_close: %e", r);
	cprintf("file_close is good\n");
  8001ba:	83 ec 0c             	sub    $0xc,%esp
  8001bd:	68 39 2c 80 00       	push   $0x802c39
  8001c2:	e8 60 06 00 00       	call   800827 <cprintf>

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
  8001f1:	e8 07 12 00 00       	call   8013fd <sys_page_unmap>

	cprintf("%d: before dev_read!!\n", thisenv->env_id);
  8001f6:	a1 08 50 80 00       	mov    0x805008,%eax
  8001fb:	8b 40 48             	mov    0x48(%eax),%eax
  8001fe:	83 c4 08             	add    $0x8,%esp
  800201:	50                   	push   %eax
  800202:	68 4d 2c 80 00       	push   $0x802c4d
  800207:	e8 1b 06 00 00       	call   800827 <cprintf>
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
  800236:	68 64 2c 80 00       	push   $0x802c64
  80023b:	e8 e7 05 00 00       	call   800827 <cprintf>

	// Try writing
	if ((r = xopen("/new-file", O_RDWR|O_CREAT)) < 0)
  800240:	ba 02 01 00 00       	mov    $0x102,%edx
  800245:	b8 7a 2c 80 00       	mov    $0x802c7a,%eax
  80024a:	e8 e4 fd ff ff       	call   800033 <xopen>
  80024f:	83 c4 10             	add    $0x10,%esp
  800252:	85 c0                	test   %eax,%eax
  800254:	0f 88 31 03 00 00    	js     80058b <umain+0x50d>
		panic("serve_open /new-file: %e", r);

	if ((r = devfile.dev_write(FVA, msg, strlen(msg))) != strlen(msg))
  80025a:	8b 1d 14 40 80 00    	mov    0x804014,%ebx
  800260:	83 ec 0c             	sub    $0xc,%esp
  800263:	ff 35 00 40 80 00    	pushl  0x804000
  800269:	e8 df 0c 00 00       	call   800f4d <strlen>
  80026e:	83 c4 0c             	add    $0xc,%esp
  800271:	50                   	push   %eax
  800272:	ff 35 00 40 80 00    	pushl  0x804000
  800278:	68 00 c0 cc cc       	push   $0xccccc000
  80027d:	ff d3                	call   *%ebx
  80027f:	89 c3                	mov    %eax,%ebx
  800281:	83 c4 04             	add    $0x4,%esp
  800284:	ff 35 00 40 80 00    	pushl  0x804000
  80028a:	e8 be 0c 00 00       	call   800f4d <strlen>
  80028f:	83 c4 10             	add    $0x10,%esp
  800292:	39 d8                	cmp    %ebx,%eax
  800294:	0f 85 03 03 00 00    	jne    80059d <umain+0x51f>
		panic("file_write: %e", r);
	cprintf("file_write is good\n");
  80029a:	83 ec 0c             	sub    $0xc,%esp
  80029d:	68 ac 2c 80 00       	push   $0x802cac
  8002a2:	e8 80 05 00 00       	call   800827 <cprintf>

	FVA->fd_offset = 0;
  8002a7:	c7 05 04 c0 cc cc 00 	movl   $0x0,0xccccc004
  8002ae:	00 00 00 
	memset(buf, 0, sizeof buf);
  8002b1:	83 c4 0c             	add    $0xc,%esp
  8002b4:	68 00 02 00 00       	push   $0x200
  8002b9:	6a 00                	push   $0x0
  8002bb:	8d 9d 4c fd ff ff    	lea    -0x2b4(%ebp),%ebx
  8002c1:	53                   	push   %ebx
  8002c2:	e8 05 0e 00 00       	call   8010cc <memset>
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
  8002f1:	e8 57 0c 00 00       	call   800f4d <strlen>
  8002f6:	83 c4 10             	add    $0x10,%esp
  8002f9:	39 d8                	cmp    %ebx,%eax
  8002fb:	0f 85 c0 02 00 00    	jne    8005c1 <umain+0x543>
		panic("file_read after file_write returned wrong length: %d", r);
	if (strcmp(buf, msg) != 0)
  800301:	83 ec 08             	sub    $0x8,%esp
  800304:	ff 35 00 40 80 00    	pushl  0x804000
  80030a:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  800310:	50                   	push   %eax
  800311:	e8 1b 0d 00 00       	call   801031 <strcmp>
  800316:	83 c4 10             	add    $0x10,%esp
  800319:	85 c0                	test   %eax,%eax
  80031b:	0f 85 b2 02 00 00    	jne    8005d3 <umain+0x555>
		panic("file_read after file_write returned wrong data");
	cprintf("file_read after file_write is good\n");
  800321:	83 ec 0c             	sub    $0xc,%esp
  800324:	68 90 2e 80 00       	push   $0x802e90
  800329:	e8 f9 04 00 00       	call   800827 <cprintf>

	// Now we'll try out open
	if ((r = open("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  80032e:	83 c4 08             	add    $0x8,%esp
  800331:	6a 00                	push   $0x0
  800333:	68 60 2b 80 00       	push   $0x802b60
  800338:	e8 b7 1b 00 00       	call   801ef4 <open>
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
  80035a:	68 95 2b 80 00       	push   $0x802b95
  80035f:	e8 90 1b 00 00       	call   801ef4 <open>
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
  80039d:	68 bc 2b 80 00       	push   $0x802bbc
  8003a2:	e8 80 04 00 00       	call   800827 <cprintf>

	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
  8003a7:	83 c4 08             	add    $0x8,%esp
  8003aa:	68 01 01 00 00       	push   $0x101
  8003af:	68 db 2c 80 00       	push   $0x802cdb
  8003b4:	e8 3b 1b 00 00       	call   801ef4 <open>
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
  8003d7:	e8 f0 0c 00 00       	call   8010cc <memset>
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
  8003f7:	e8 26 17 00 00       	call   801b22 <write>
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
  800419:	e8 fa 14 00 00       	call   801918 <close>

	if ((f = open("/big", O_RDONLY)) < 0)
  80041e:	83 c4 08             	add    $0x8,%esp
  800421:	6a 00                	push   $0x0
  800423:	68 db 2c 80 00       	push   $0x802cdb
  800428:	e8 c7 1a 00 00       	call   801ef4 <open>
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
  800450:	e8 88 16 00 00       	call   801add <readn>
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
  80048b:	e8 88 14 00 00       	call   801918 <close>
	cprintf("large file is good\n");
  800490:	c7 04 24 20 2d 80 00 	movl   $0x802d20,(%esp)
  800497:	e8 8b 03 00 00       	call   800827 <cprintf>
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
  8004a8:	68 6b 2b 80 00       	push   $0x802b6b
  8004ad:	6a 20                	push   $0x20
  8004af:	68 85 2b 80 00       	push   $0x802b85
  8004b4:	e8 78 02 00 00       	call   800731 <_panic>
		panic("serve_open /not-found succeeded!");
  8004b9:	83 ec 04             	sub    $0x4,%esp
  8004bc:	68 34 2d 80 00       	push   $0x802d34
  8004c1:	6a 22                	push   $0x22
  8004c3:	68 85 2b 80 00       	push   $0x802b85
  8004c8:	e8 64 02 00 00       	call   800731 <_panic>
		panic("serve_open /newmotd: %e", r);
  8004cd:	50                   	push   %eax
  8004ce:	68 9e 2b 80 00       	push   $0x802b9e
  8004d3:	6a 25                	push   $0x25
  8004d5:	68 85 2b 80 00       	push   $0x802b85
  8004da:	e8 52 02 00 00       	call   800731 <_panic>
		panic("serve_open did not fill struct Fd correctly\n");
  8004df:	83 ec 04             	sub    $0x4,%esp
  8004e2:	68 58 2d 80 00       	push   $0x802d58
  8004e7:	6a 27                	push   $0x27
  8004e9:	68 85 2b 80 00       	push   $0x802b85
  8004ee:	e8 3e 02 00 00       	call   800731 <_panic>
		panic("file_stat: %e", r);
  8004f3:	50                   	push   %eax
  8004f4:	68 ca 2b 80 00       	push   $0x802bca
  8004f9:	6a 2b                	push   $0x2b
  8004fb:	68 85 2b 80 00       	push   $0x802b85
  800500:	e8 2c 02 00 00       	call   800731 <_panic>
		panic("file_stat returned size %d wanted %d\n", st.st_size, strlen(msg));
  800505:	83 ec 0c             	sub    $0xc,%esp
  800508:	ff 35 00 40 80 00    	pushl  0x804000
  80050e:	e8 3a 0a 00 00       	call   800f4d <strlen>
  800513:	89 04 24             	mov    %eax,(%esp)
  800516:	ff 75 cc             	pushl  -0x34(%ebp)
  800519:	68 88 2d 80 00       	push   $0x802d88
  80051e:	6a 2d                	push   $0x2d
  800520:	68 85 2b 80 00       	push   $0x802b85
  800525:	e8 07 02 00 00       	call   800731 <_panic>
		panic("file_read: %e", r);
  80052a:	50                   	push   %eax
  80052b:	68 eb 2b 80 00       	push   $0x802beb
  800530:	6a 32                	push   $0x32
  800532:	68 85 2b 80 00       	push   $0x802b85
  800537:	e8 f5 01 00 00       	call   800731 <_panic>
		panic("file_read returned wrong data");
  80053c:	83 ec 04             	sub    $0x4,%esp
  80053f:	68 f9 2b 80 00       	push   $0x802bf9
  800544:	6a 34                	push   $0x34
  800546:	68 85 2b 80 00       	push   $0x802b85
  80054b:	e8 e1 01 00 00       	call   800731 <_panic>
		panic("file_close: %e", r);
  800550:	50                   	push   %eax
  800551:	68 2a 2c 80 00       	push   $0x802c2a
  800556:	6a 38                	push   $0x38
  800558:	68 85 2b 80 00       	push   $0x802b85
  80055d:	e8 cf 01 00 00       	call   800731 <_panic>
		cprintf("%d: after dev_read!! the r: %d\n", thisenv->env_id, r);
  800562:	a1 08 50 80 00       	mov    0x805008,%eax
  800567:	8b 40 48             	mov    0x48(%eax),%eax
  80056a:	83 ec 04             	sub    $0x4,%esp
  80056d:	53                   	push   %ebx
  80056e:	50                   	push   %eax
  80056f:	68 b0 2d 80 00       	push   $0x802db0
  800574:	e8 ae 02 00 00       	call   800827 <cprintf>
		panic("serve_read does not handle stale fileids correctly: %e", r);
  800579:	53                   	push   %ebx
  80057a:	68 d0 2d 80 00       	push   $0x802dd0
  80057f:	6a 45                	push   $0x45
  800581:	68 85 2b 80 00       	push   $0x802b85
  800586:	e8 a6 01 00 00       	call   800731 <_panic>
		panic("serve_open /new-file: %e", r);
  80058b:	50                   	push   %eax
  80058c:	68 84 2c 80 00       	push   $0x802c84
  800591:	6a 4b                	push   $0x4b
  800593:	68 85 2b 80 00       	push   $0x802b85
  800598:	e8 94 01 00 00       	call   800731 <_panic>
		panic("file_write: %e", r);
  80059d:	53                   	push   %ebx
  80059e:	68 9d 2c 80 00       	push   $0x802c9d
  8005a3:	6a 4e                	push   $0x4e
  8005a5:	68 85 2b 80 00       	push   $0x802b85
  8005aa:	e8 82 01 00 00       	call   800731 <_panic>
		panic("file_read after file_write: %e", r);
  8005af:	50                   	push   %eax
  8005b0:	68 08 2e 80 00       	push   $0x802e08
  8005b5:	6a 54                	push   $0x54
  8005b7:	68 85 2b 80 00       	push   $0x802b85
  8005bc:	e8 70 01 00 00       	call   800731 <_panic>
		panic("file_read after file_write returned wrong length: %d", r);
  8005c1:	53                   	push   %ebx
  8005c2:	68 28 2e 80 00       	push   $0x802e28
  8005c7:	6a 56                	push   $0x56
  8005c9:	68 85 2b 80 00       	push   $0x802b85
  8005ce:	e8 5e 01 00 00       	call   800731 <_panic>
		panic("file_read after file_write returned wrong data");
  8005d3:	83 ec 04             	sub    $0x4,%esp
  8005d6:	68 60 2e 80 00       	push   $0x802e60
  8005db:	6a 58                	push   $0x58
  8005dd:	68 85 2b 80 00       	push   $0x802b85
  8005e2:	e8 4a 01 00 00       	call   800731 <_panic>
		panic("open /not-found: %e", r);
  8005e7:	50                   	push   %eax
  8005e8:	68 71 2b 80 00       	push   $0x802b71
  8005ed:	6a 5d                	push   $0x5d
  8005ef:	68 85 2b 80 00       	push   $0x802b85
  8005f4:	e8 38 01 00 00       	call   800731 <_panic>
		panic("open /not-found succeeded!");
  8005f9:	83 ec 04             	sub    $0x4,%esp
  8005fc:	68 c0 2c 80 00       	push   $0x802cc0
  800601:	6a 5f                	push   $0x5f
  800603:	68 85 2b 80 00       	push   $0x802b85
  800608:	e8 24 01 00 00       	call   800731 <_panic>
		panic("open /newmotd: %e", r);
  80060d:	50                   	push   %eax
  80060e:	68 a4 2b 80 00       	push   $0x802ba4
  800613:	6a 62                	push   $0x62
  800615:	68 85 2b 80 00       	push   $0x802b85
  80061a:	e8 12 01 00 00       	call   800731 <_panic>
		panic("open did not fill struct Fd correctly\n");
  80061f:	83 ec 04             	sub    $0x4,%esp
  800622:	68 b4 2e 80 00       	push   $0x802eb4
  800627:	6a 65                	push   $0x65
  800629:	68 85 2b 80 00       	push   $0x802b85
  80062e:	e8 fe 00 00 00       	call   800731 <_panic>
		panic("creat /big: %e", f);
  800633:	50                   	push   %eax
  800634:	68 e0 2c 80 00       	push   $0x802ce0
  800639:	6a 6a                	push   $0x6a
  80063b:	68 85 2b 80 00       	push   $0x802b85
  800640:	e8 ec 00 00 00       	call   800731 <_panic>
			panic("write /big@%d: %e", i, r);
  800645:	83 ec 0c             	sub    $0xc,%esp
  800648:	50                   	push   %eax
  800649:	56                   	push   %esi
  80064a:	68 ef 2c 80 00       	push   $0x802cef
  80064f:	6a 6f                	push   $0x6f
  800651:	68 85 2b 80 00       	push   $0x802b85
  800656:	e8 d6 00 00 00       	call   800731 <_panic>
		panic("open /big: %e", f);
  80065b:	50                   	push   %eax
  80065c:	68 01 2d 80 00       	push   $0x802d01
  800661:	6a 74                	push   $0x74
  800663:	68 85 2b 80 00       	push   $0x802b85
  800668:	e8 c4 00 00 00       	call   800731 <_panic>
			panic("read /big@%d: %e", i, r);
  80066d:	83 ec 0c             	sub    $0xc,%esp
  800670:	50                   	push   %eax
  800671:	53                   	push   %ebx
  800672:	68 0f 2d 80 00       	push   $0x802d0f
  800677:	6a 78                	push   $0x78
  800679:	68 85 2b 80 00       	push   $0x802b85
  80067e:	e8 ae 00 00 00       	call   800731 <_panic>
			panic("read /big from %d returned %d < %d bytes",
  800683:	83 ec 08             	sub    $0x8,%esp
  800686:	68 00 02 00 00       	push   $0x200
  80068b:	50                   	push   %eax
  80068c:	53                   	push   %ebx
  80068d:	68 dc 2e 80 00       	push   $0x802edc
  800692:	6a 7b                	push   $0x7b
  800694:	68 85 2b 80 00       	push   $0x802b85
  800699:	e8 93 00 00 00       	call   800731 <_panic>
			panic("read /big from %d returned bad data %d",
  80069e:	83 ec 0c             	sub    $0xc,%esp
  8006a1:	50                   	push   %eax
  8006a2:	53                   	push   %ebx
  8006a3:	68 08 2f 80 00       	push   $0x802f08
  8006a8:	6a 7e                	push   $0x7e
  8006aa:	68 85 2b 80 00       	push   $0x802b85
  8006af:	e8 7d 00 00 00       	call   800731 <_panic>

008006b4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8006b4:	55                   	push   %ebp
  8006b5:	89 e5                	mov    %esp,%ebp
  8006b7:	56                   	push   %esi
  8006b8:	53                   	push   %ebx
  8006b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8006bc:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	envid_t curenv = sys_getenvid();
  8006bf:	e8 76 0c 00 00       	call   80133a <sys_getenvid>
	thisenv = envs + ENVX(curenv);
  8006c4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8006c9:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8006cf:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8006d4:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006d9:	85 db                	test   %ebx,%ebx
  8006db:	7e 07                	jle    8006e4 <libmain+0x30>
		binaryname = argv[0];
  8006dd:	8b 06                	mov    (%esi),%eax
  8006df:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	umain(argc, argv);
  8006e4:	83 ec 08             	sub    $0x8,%esp
  8006e7:	56                   	push   %esi
  8006e8:	53                   	push   %ebx
  8006e9:	e8 90 f9 ff ff       	call   80007e <umain>

	// exit gracefully
	exit();
  8006ee:	e8 0a 00 00 00       	call   8006fd <exit>
}
  8006f3:	83 c4 10             	add    $0x10,%esp
  8006f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8006f9:	5b                   	pop    %ebx
  8006fa:	5e                   	pop    %esi
  8006fb:	5d                   	pop    %ebp
  8006fc:	c3                   	ret    

008006fd <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8006fd:	55                   	push   %ebp
  8006fe:	89 e5                	mov    %esp,%ebp
  800700:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800703:	a1 08 50 80 00       	mov    0x805008,%eax
  800708:	8b 40 48             	mov    0x48(%eax),%eax
  80070b:	68 6c 2f 80 00       	push   $0x802f6c
  800710:	50                   	push   %eax
  800711:	68 60 2f 80 00       	push   $0x802f60
  800716:	e8 0c 01 00 00       	call   800827 <cprintf>
	close_all();
  80071b:	e8 25 12 00 00       	call   801945 <close_all>
	sys_env_destroy(0);
  800720:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800727:	e8 cd 0b 00 00       	call   8012f9 <sys_env_destroy>
}
  80072c:	83 c4 10             	add    $0x10,%esp
  80072f:	c9                   	leave  
  800730:	c3                   	ret    

00800731 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800731:	55                   	push   %ebp
  800732:	89 e5                	mov    %esp,%ebp
  800734:	56                   	push   %esi
  800735:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800736:	a1 08 50 80 00       	mov    0x805008,%eax
  80073b:	8b 40 48             	mov    0x48(%eax),%eax
  80073e:	83 ec 04             	sub    $0x4,%esp
  800741:	68 98 2f 80 00       	push   $0x802f98
  800746:	50                   	push   %eax
  800747:	68 60 2f 80 00       	push   $0x802f60
  80074c:	e8 d6 00 00 00       	call   800827 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800751:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800754:	8b 35 04 40 80 00    	mov    0x804004,%esi
  80075a:	e8 db 0b 00 00       	call   80133a <sys_getenvid>
  80075f:	83 c4 04             	add    $0x4,%esp
  800762:	ff 75 0c             	pushl  0xc(%ebp)
  800765:	ff 75 08             	pushl  0x8(%ebp)
  800768:	56                   	push   %esi
  800769:	50                   	push   %eax
  80076a:	68 74 2f 80 00       	push   $0x802f74
  80076f:	e8 b3 00 00 00       	call   800827 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800774:	83 c4 18             	add    $0x18,%esp
  800777:	53                   	push   %ebx
  800778:	ff 75 10             	pushl  0x10(%ebp)
  80077b:	e8 56 00 00 00       	call   8007d6 <vcprintf>
	cprintf("\n");
  800780:	c7 04 24 62 2c 80 00 	movl   $0x802c62,(%esp)
  800787:	e8 9b 00 00 00       	call   800827 <cprintf>
  80078c:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80078f:	cc                   	int3   
  800790:	eb fd                	jmp    80078f <_panic+0x5e>

00800792 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800792:	55                   	push   %ebp
  800793:	89 e5                	mov    %esp,%ebp
  800795:	53                   	push   %ebx
  800796:	83 ec 04             	sub    $0x4,%esp
  800799:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80079c:	8b 13                	mov    (%ebx),%edx
  80079e:	8d 42 01             	lea    0x1(%edx),%eax
  8007a1:	89 03                	mov    %eax,(%ebx)
  8007a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007a6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8007aa:	3d ff 00 00 00       	cmp    $0xff,%eax
  8007af:	74 09                	je     8007ba <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8007b1:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8007b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007b8:	c9                   	leave  
  8007b9:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8007ba:	83 ec 08             	sub    $0x8,%esp
  8007bd:	68 ff 00 00 00       	push   $0xff
  8007c2:	8d 43 08             	lea    0x8(%ebx),%eax
  8007c5:	50                   	push   %eax
  8007c6:	e8 f1 0a 00 00       	call   8012bc <sys_cputs>
		b->idx = 0;
  8007cb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8007d1:	83 c4 10             	add    $0x10,%esp
  8007d4:	eb db                	jmp    8007b1 <putch+0x1f>

008007d6 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8007d6:	55                   	push   %ebp
  8007d7:	89 e5                	mov    %esp,%ebp
  8007d9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8007df:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8007e6:	00 00 00 
	b.cnt = 0;
  8007e9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8007f0:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8007f3:	ff 75 0c             	pushl  0xc(%ebp)
  8007f6:	ff 75 08             	pushl  0x8(%ebp)
  8007f9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007ff:	50                   	push   %eax
  800800:	68 92 07 80 00       	push   $0x800792
  800805:	e8 4a 01 00 00       	call   800954 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80080a:	83 c4 08             	add    $0x8,%esp
  80080d:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800813:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800819:	50                   	push   %eax
  80081a:	e8 9d 0a 00 00       	call   8012bc <sys_cputs>

	return b.cnt;
}
  80081f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800825:	c9                   	leave  
  800826:	c3                   	ret    

00800827 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800827:	55                   	push   %ebp
  800828:	89 e5                	mov    %esp,%ebp
  80082a:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80082d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800830:	50                   	push   %eax
  800831:	ff 75 08             	pushl  0x8(%ebp)
  800834:	e8 9d ff ff ff       	call   8007d6 <vcprintf>
	va_end(ap);

	return cnt;
}
  800839:	c9                   	leave  
  80083a:	c3                   	ret    

0080083b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80083b:	55                   	push   %ebp
  80083c:	89 e5                	mov    %esp,%ebp
  80083e:	57                   	push   %edi
  80083f:	56                   	push   %esi
  800840:	53                   	push   %ebx
  800841:	83 ec 1c             	sub    $0x1c,%esp
  800844:	89 c6                	mov    %eax,%esi
  800846:	89 d7                	mov    %edx,%edi
  800848:	8b 45 08             	mov    0x8(%ebp),%eax
  80084b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80084e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800851:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800854:	8b 45 10             	mov    0x10(%ebp),%eax
  800857:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80085a:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80085e:	74 2c                	je     80088c <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800860:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800863:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80086a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80086d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800870:	39 c2                	cmp    %eax,%edx
  800872:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800875:	73 43                	jae    8008ba <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800877:	83 eb 01             	sub    $0x1,%ebx
  80087a:	85 db                	test   %ebx,%ebx
  80087c:	7e 6c                	jle    8008ea <printnum+0xaf>
				putch(padc, putdat);
  80087e:	83 ec 08             	sub    $0x8,%esp
  800881:	57                   	push   %edi
  800882:	ff 75 18             	pushl  0x18(%ebp)
  800885:	ff d6                	call   *%esi
  800887:	83 c4 10             	add    $0x10,%esp
  80088a:	eb eb                	jmp    800877 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80088c:	83 ec 0c             	sub    $0xc,%esp
  80088f:	6a 20                	push   $0x20
  800891:	6a 00                	push   $0x0
  800893:	50                   	push   %eax
  800894:	ff 75 e4             	pushl  -0x1c(%ebp)
  800897:	ff 75 e0             	pushl  -0x20(%ebp)
  80089a:	89 fa                	mov    %edi,%edx
  80089c:	89 f0                	mov    %esi,%eax
  80089e:	e8 98 ff ff ff       	call   80083b <printnum>
		while (--width > 0)
  8008a3:	83 c4 20             	add    $0x20,%esp
  8008a6:	83 eb 01             	sub    $0x1,%ebx
  8008a9:	85 db                	test   %ebx,%ebx
  8008ab:	7e 65                	jle    800912 <printnum+0xd7>
			putch(padc, putdat);
  8008ad:	83 ec 08             	sub    $0x8,%esp
  8008b0:	57                   	push   %edi
  8008b1:	6a 20                	push   $0x20
  8008b3:	ff d6                	call   *%esi
  8008b5:	83 c4 10             	add    $0x10,%esp
  8008b8:	eb ec                	jmp    8008a6 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8008ba:	83 ec 0c             	sub    $0xc,%esp
  8008bd:	ff 75 18             	pushl  0x18(%ebp)
  8008c0:	83 eb 01             	sub    $0x1,%ebx
  8008c3:	53                   	push   %ebx
  8008c4:	50                   	push   %eax
  8008c5:	83 ec 08             	sub    $0x8,%esp
  8008c8:	ff 75 dc             	pushl  -0x24(%ebp)
  8008cb:	ff 75 d8             	pushl  -0x28(%ebp)
  8008ce:	ff 75 e4             	pushl  -0x1c(%ebp)
  8008d1:	ff 75 e0             	pushl  -0x20(%ebp)
  8008d4:	e8 27 20 00 00       	call   802900 <__udivdi3>
  8008d9:	83 c4 18             	add    $0x18,%esp
  8008dc:	52                   	push   %edx
  8008dd:	50                   	push   %eax
  8008de:	89 fa                	mov    %edi,%edx
  8008e0:	89 f0                	mov    %esi,%eax
  8008e2:	e8 54 ff ff ff       	call   80083b <printnum>
  8008e7:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8008ea:	83 ec 08             	sub    $0x8,%esp
  8008ed:	57                   	push   %edi
  8008ee:	83 ec 04             	sub    $0x4,%esp
  8008f1:	ff 75 dc             	pushl  -0x24(%ebp)
  8008f4:	ff 75 d8             	pushl  -0x28(%ebp)
  8008f7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8008fa:	ff 75 e0             	pushl  -0x20(%ebp)
  8008fd:	e8 0e 21 00 00       	call   802a10 <__umoddi3>
  800902:	83 c4 14             	add    $0x14,%esp
  800905:	0f be 80 9f 2f 80 00 	movsbl 0x802f9f(%eax),%eax
  80090c:	50                   	push   %eax
  80090d:	ff d6                	call   *%esi
  80090f:	83 c4 10             	add    $0x10,%esp
	}
}
  800912:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800915:	5b                   	pop    %ebx
  800916:	5e                   	pop    %esi
  800917:	5f                   	pop    %edi
  800918:	5d                   	pop    %ebp
  800919:	c3                   	ret    

0080091a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80091a:	55                   	push   %ebp
  80091b:	89 e5                	mov    %esp,%ebp
  80091d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800920:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800924:	8b 10                	mov    (%eax),%edx
  800926:	3b 50 04             	cmp    0x4(%eax),%edx
  800929:	73 0a                	jae    800935 <sprintputch+0x1b>
		*b->buf++ = ch;
  80092b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80092e:	89 08                	mov    %ecx,(%eax)
  800930:	8b 45 08             	mov    0x8(%ebp),%eax
  800933:	88 02                	mov    %al,(%edx)
}
  800935:	5d                   	pop    %ebp
  800936:	c3                   	ret    

00800937 <printfmt>:
{
  800937:	55                   	push   %ebp
  800938:	89 e5                	mov    %esp,%ebp
  80093a:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80093d:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800940:	50                   	push   %eax
  800941:	ff 75 10             	pushl  0x10(%ebp)
  800944:	ff 75 0c             	pushl  0xc(%ebp)
  800947:	ff 75 08             	pushl  0x8(%ebp)
  80094a:	e8 05 00 00 00       	call   800954 <vprintfmt>
}
  80094f:	83 c4 10             	add    $0x10,%esp
  800952:	c9                   	leave  
  800953:	c3                   	ret    

00800954 <vprintfmt>:
{
  800954:	55                   	push   %ebp
  800955:	89 e5                	mov    %esp,%ebp
  800957:	57                   	push   %edi
  800958:	56                   	push   %esi
  800959:	53                   	push   %ebx
  80095a:	83 ec 3c             	sub    $0x3c,%esp
  80095d:	8b 75 08             	mov    0x8(%ebp),%esi
  800960:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800963:	8b 7d 10             	mov    0x10(%ebp),%edi
  800966:	e9 32 04 00 00       	jmp    800d9d <vprintfmt+0x449>
		padc = ' ';
  80096b:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80096f:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800976:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80097d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800984:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80098b:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800992:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800997:	8d 47 01             	lea    0x1(%edi),%eax
  80099a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80099d:	0f b6 17             	movzbl (%edi),%edx
  8009a0:	8d 42 dd             	lea    -0x23(%edx),%eax
  8009a3:	3c 55                	cmp    $0x55,%al
  8009a5:	0f 87 12 05 00 00    	ja     800ebd <vprintfmt+0x569>
  8009ab:	0f b6 c0             	movzbl %al,%eax
  8009ae:	ff 24 85 80 31 80 00 	jmp    *0x803180(,%eax,4)
  8009b5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8009b8:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8009bc:	eb d9                	jmp    800997 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8009be:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8009c1:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8009c5:	eb d0                	jmp    800997 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8009c7:	0f b6 d2             	movzbl %dl,%edx
  8009ca:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8009cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8009d2:	89 75 08             	mov    %esi,0x8(%ebp)
  8009d5:	eb 03                	jmp    8009da <vprintfmt+0x86>
  8009d7:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8009da:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8009dd:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8009e1:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8009e4:	8d 72 d0             	lea    -0x30(%edx),%esi
  8009e7:	83 fe 09             	cmp    $0x9,%esi
  8009ea:	76 eb                	jbe    8009d7 <vprintfmt+0x83>
  8009ec:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009ef:	8b 75 08             	mov    0x8(%ebp),%esi
  8009f2:	eb 14                	jmp    800a08 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8009f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f7:	8b 00                	mov    (%eax),%eax
  8009f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ff:	8d 40 04             	lea    0x4(%eax),%eax
  800a02:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800a05:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800a08:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a0c:	79 89                	jns    800997 <vprintfmt+0x43>
				width = precision, precision = -1;
  800a0e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a11:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a14:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800a1b:	e9 77 ff ff ff       	jmp    800997 <vprintfmt+0x43>
  800a20:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a23:	85 c0                	test   %eax,%eax
  800a25:	0f 48 c1             	cmovs  %ecx,%eax
  800a28:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800a2b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800a2e:	e9 64 ff ff ff       	jmp    800997 <vprintfmt+0x43>
  800a33:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800a36:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800a3d:	e9 55 ff ff ff       	jmp    800997 <vprintfmt+0x43>
			lflag++;
  800a42:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800a46:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800a49:	e9 49 ff ff ff       	jmp    800997 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800a4e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a51:	8d 78 04             	lea    0x4(%eax),%edi
  800a54:	83 ec 08             	sub    $0x8,%esp
  800a57:	53                   	push   %ebx
  800a58:	ff 30                	pushl  (%eax)
  800a5a:	ff d6                	call   *%esi
			break;
  800a5c:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800a5f:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800a62:	e9 33 03 00 00       	jmp    800d9a <vprintfmt+0x446>
			err = va_arg(ap, int);
  800a67:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6a:	8d 78 04             	lea    0x4(%eax),%edi
  800a6d:	8b 00                	mov    (%eax),%eax
  800a6f:	99                   	cltd   
  800a70:	31 d0                	xor    %edx,%eax
  800a72:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a74:	83 f8 11             	cmp    $0x11,%eax
  800a77:	7f 23                	jg     800a9c <vprintfmt+0x148>
  800a79:	8b 14 85 e0 32 80 00 	mov    0x8032e0(,%eax,4),%edx
  800a80:	85 d2                	test   %edx,%edx
  800a82:	74 18                	je     800a9c <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800a84:	52                   	push   %edx
  800a85:	68 21 34 80 00       	push   $0x803421
  800a8a:	53                   	push   %ebx
  800a8b:	56                   	push   %esi
  800a8c:	e8 a6 fe ff ff       	call   800937 <printfmt>
  800a91:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800a94:	89 7d 14             	mov    %edi,0x14(%ebp)
  800a97:	e9 fe 02 00 00       	jmp    800d9a <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800a9c:	50                   	push   %eax
  800a9d:	68 b7 2f 80 00       	push   $0x802fb7
  800aa2:	53                   	push   %ebx
  800aa3:	56                   	push   %esi
  800aa4:	e8 8e fe ff ff       	call   800937 <printfmt>
  800aa9:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800aac:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800aaf:	e9 e6 02 00 00       	jmp    800d9a <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800ab4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab7:	83 c0 04             	add    $0x4,%eax
  800aba:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800abd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac0:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800ac2:	85 c9                	test   %ecx,%ecx
  800ac4:	b8 b0 2f 80 00       	mov    $0x802fb0,%eax
  800ac9:	0f 45 c1             	cmovne %ecx,%eax
  800acc:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800acf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ad3:	7e 06                	jle    800adb <vprintfmt+0x187>
  800ad5:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800ad9:	75 0d                	jne    800ae8 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800adb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800ade:	89 c7                	mov    %eax,%edi
  800ae0:	03 45 e0             	add    -0x20(%ebp),%eax
  800ae3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800ae6:	eb 53                	jmp    800b3b <vprintfmt+0x1e7>
  800ae8:	83 ec 08             	sub    $0x8,%esp
  800aeb:	ff 75 d8             	pushl  -0x28(%ebp)
  800aee:	50                   	push   %eax
  800aef:	e8 71 04 00 00       	call   800f65 <strnlen>
  800af4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800af7:	29 c1                	sub    %eax,%ecx
  800af9:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800afc:	83 c4 10             	add    $0x10,%esp
  800aff:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800b01:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800b05:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800b08:	eb 0f                	jmp    800b19 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800b0a:	83 ec 08             	sub    $0x8,%esp
  800b0d:	53                   	push   %ebx
  800b0e:	ff 75 e0             	pushl  -0x20(%ebp)
  800b11:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800b13:	83 ef 01             	sub    $0x1,%edi
  800b16:	83 c4 10             	add    $0x10,%esp
  800b19:	85 ff                	test   %edi,%edi
  800b1b:	7f ed                	jg     800b0a <vprintfmt+0x1b6>
  800b1d:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800b20:	85 c9                	test   %ecx,%ecx
  800b22:	b8 00 00 00 00       	mov    $0x0,%eax
  800b27:	0f 49 c1             	cmovns %ecx,%eax
  800b2a:	29 c1                	sub    %eax,%ecx
  800b2c:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800b2f:	eb aa                	jmp    800adb <vprintfmt+0x187>
					putch(ch, putdat);
  800b31:	83 ec 08             	sub    $0x8,%esp
  800b34:	53                   	push   %ebx
  800b35:	52                   	push   %edx
  800b36:	ff d6                	call   *%esi
  800b38:	83 c4 10             	add    $0x10,%esp
  800b3b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800b3e:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b40:	83 c7 01             	add    $0x1,%edi
  800b43:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800b47:	0f be d0             	movsbl %al,%edx
  800b4a:	85 d2                	test   %edx,%edx
  800b4c:	74 4b                	je     800b99 <vprintfmt+0x245>
  800b4e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800b52:	78 06                	js     800b5a <vprintfmt+0x206>
  800b54:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800b58:	78 1e                	js     800b78 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800b5a:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800b5e:	74 d1                	je     800b31 <vprintfmt+0x1dd>
  800b60:	0f be c0             	movsbl %al,%eax
  800b63:	83 e8 20             	sub    $0x20,%eax
  800b66:	83 f8 5e             	cmp    $0x5e,%eax
  800b69:	76 c6                	jbe    800b31 <vprintfmt+0x1dd>
					putch('?', putdat);
  800b6b:	83 ec 08             	sub    $0x8,%esp
  800b6e:	53                   	push   %ebx
  800b6f:	6a 3f                	push   $0x3f
  800b71:	ff d6                	call   *%esi
  800b73:	83 c4 10             	add    $0x10,%esp
  800b76:	eb c3                	jmp    800b3b <vprintfmt+0x1e7>
  800b78:	89 cf                	mov    %ecx,%edi
  800b7a:	eb 0e                	jmp    800b8a <vprintfmt+0x236>
				putch(' ', putdat);
  800b7c:	83 ec 08             	sub    $0x8,%esp
  800b7f:	53                   	push   %ebx
  800b80:	6a 20                	push   $0x20
  800b82:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800b84:	83 ef 01             	sub    $0x1,%edi
  800b87:	83 c4 10             	add    $0x10,%esp
  800b8a:	85 ff                	test   %edi,%edi
  800b8c:	7f ee                	jg     800b7c <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800b8e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800b91:	89 45 14             	mov    %eax,0x14(%ebp)
  800b94:	e9 01 02 00 00       	jmp    800d9a <vprintfmt+0x446>
  800b99:	89 cf                	mov    %ecx,%edi
  800b9b:	eb ed                	jmp    800b8a <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800b9d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800ba0:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800ba7:	e9 eb fd ff ff       	jmp    800997 <vprintfmt+0x43>
	if (lflag >= 2)
  800bac:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800bb0:	7f 21                	jg     800bd3 <vprintfmt+0x27f>
	else if (lflag)
  800bb2:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800bb6:	74 68                	je     800c20 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800bb8:	8b 45 14             	mov    0x14(%ebp),%eax
  800bbb:	8b 00                	mov    (%eax),%eax
  800bbd:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800bc0:	89 c1                	mov    %eax,%ecx
  800bc2:	c1 f9 1f             	sar    $0x1f,%ecx
  800bc5:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800bc8:	8b 45 14             	mov    0x14(%ebp),%eax
  800bcb:	8d 40 04             	lea    0x4(%eax),%eax
  800bce:	89 45 14             	mov    %eax,0x14(%ebp)
  800bd1:	eb 17                	jmp    800bea <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800bd3:	8b 45 14             	mov    0x14(%ebp),%eax
  800bd6:	8b 50 04             	mov    0x4(%eax),%edx
  800bd9:	8b 00                	mov    (%eax),%eax
  800bdb:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800bde:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800be1:	8b 45 14             	mov    0x14(%ebp),%eax
  800be4:	8d 40 08             	lea    0x8(%eax),%eax
  800be7:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800bea:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800bed:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800bf0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bf3:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800bf6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800bfa:	78 3f                	js     800c3b <vprintfmt+0x2e7>
			base = 10;
  800bfc:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800c01:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800c05:	0f 84 71 01 00 00    	je     800d7c <vprintfmt+0x428>
				putch('+', putdat);
  800c0b:	83 ec 08             	sub    $0x8,%esp
  800c0e:	53                   	push   %ebx
  800c0f:	6a 2b                	push   $0x2b
  800c11:	ff d6                	call   *%esi
  800c13:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800c16:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c1b:	e9 5c 01 00 00       	jmp    800d7c <vprintfmt+0x428>
		return va_arg(*ap, int);
  800c20:	8b 45 14             	mov    0x14(%ebp),%eax
  800c23:	8b 00                	mov    (%eax),%eax
  800c25:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800c28:	89 c1                	mov    %eax,%ecx
  800c2a:	c1 f9 1f             	sar    $0x1f,%ecx
  800c2d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800c30:	8b 45 14             	mov    0x14(%ebp),%eax
  800c33:	8d 40 04             	lea    0x4(%eax),%eax
  800c36:	89 45 14             	mov    %eax,0x14(%ebp)
  800c39:	eb af                	jmp    800bea <vprintfmt+0x296>
				putch('-', putdat);
  800c3b:	83 ec 08             	sub    $0x8,%esp
  800c3e:	53                   	push   %ebx
  800c3f:	6a 2d                	push   $0x2d
  800c41:	ff d6                	call   *%esi
				num = -(long long) num;
  800c43:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800c46:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800c49:	f7 d8                	neg    %eax
  800c4b:	83 d2 00             	adc    $0x0,%edx
  800c4e:	f7 da                	neg    %edx
  800c50:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c53:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c56:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800c59:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c5e:	e9 19 01 00 00       	jmp    800d7c <vprintfmt+0x428>
	if (lflag >= 2)
  800c63:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800c67:	7f 29                	jg     800c92 <vprintfmt+0x33e>
	else if (lflag)
  800c69:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800c6d:	74 44                	je     800cb3 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800c6f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c72:	8b 00                	mov    (%eax),%eax
  800c74:	ba 00 00 00 00       	mov    $0x0,%edx
  800c79:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c7c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c7f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c82:	8d 40 04             	lea    0x4(%eax),%eax
  800c85:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800c88:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c8d:	e9 ea 00 00 00       	jmp    800d7c <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800c92:	8b 45 14             	mov    0x14(%ebp),%eax
  800c95:	8b 50 04             	mov    0x4(%eax),%edx
  800c98:	8b 00                	mov    (%eax),%eax
  800c9a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c9d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ca0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca3:	8d 40 08             	lea    0x8(%eax),%eax
  800ca6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800ca9:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cae:	e9 c9 00 00 00       	jmp    800d7c <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800cb3:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb6:	8b 00                	mov    (%eax),%eax
  800cb8:	ba 00 00 00 00       	mov    $0x0,%edx
  800cbd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800cc0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800cc3:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc6:	8d 40 04             	lea    0x4(%eax),%eax
  800cc9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800ccc:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cd1:	e9 a6 00 00 00       	jmp    800d7c <vprintfmt+0x428>
			putch('0', putdat);
  800cd6:	83 ec 08             	sub    $0x8,%esp
  800cd9:	53                   	push   %ebx
  800cda:	6a 30                	push   $0x30
  800cdc:	ff d6                	call   *%esi
	if (lflag >= 2)
  800cde:	83 c4 10             	add    $0x10,%esp
  800ce1:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800ce5:	7f 26                	jg     800d0d <vprintfmt+0x3b9>
	else if (lflag)
  800ce7:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800ceb:	74 3e                	je     800d2b <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800ced:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf0:	8b 00                	mov    (%eax),%eax
  800cf2:	ba 00 00 00 00       	mov    $0x0,%edx
  800cf7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800cfa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800cfd:	8b 45 14             	mov    0x14(%ebp),%eax
  800d00:	8d 40 04             	lea    0x4(%eax),%eax
  800d03:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800d06:	b8 08 00 00 00       	mov    $0x8,%eax
  800d0b:	eb 6f                	jmp    800d7c <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800d0d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d10:	8b 50 04             	mov    0x4(%eax),%edx
  800d13:	8b 00                	mov    (%eax),%eax
  800d15:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d18:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800d1b:	8b 45 14             	mov    0x14(%ebp),%eax
  800d1e:	8d 40 08             	lea    0x8(%eax),%eax
  800d21:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800d24:	b8 08 00 00 00       	mov    $0x8,%eax
  800d29:	eb 51                	jmp    800d7c <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800d2b:	8b 45 14             	mov    0x14(%ebp),%eax
  800d2e:	8b 00                	mov    (%eax),%eax
  800d30:	ba 00 00 00 00       	mov    $0x0,%edx
  800d35:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d38:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800d3b:	8b 45 14             	mov    0x14(%ebp),%eax
  800d3e:	8d 40 04             	lea    0x4(%eax),%eax
  800d41:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800d44:	b8 08 00 00 00       	mov    $0x8,%eax
  800d49:	eb 31                	jmp    800d7c <vprintfmt+0x428>
			putch('0', putdat);
  800d4b:	83 ec 08             	sub    $0x8,%esp
  800d4e:	53                   	push   %ebx
  800d4f:	6a 30                	push   $0x30
  800d51:	ff d6                	call   *%esi
			putch('x', putdat);
  800d53:	83 c4 08             	add    $0x8,%esp
  800d56:	53                   	push   %ebx
  800d57:	6a 78                	push   $0x78
  800d59:	ff d6                	call   *%esi
			num = (unsigned long long)
  800d5b:	8b 45 14             	mov    0x14(%ebp),%eax
  800d5e:	8b 00                	mov    (%eax),%eax
  800d60:	ba 00 00 00 00       	mov    $0x0,%edx
  800d65:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d68:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800d6b:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800d6e:	8b 45 14             	mov    0x14(%ebp),%eax
  800d71:	8d 40 04             	lea    0x4(%eax),%eax
  800d74:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800d77:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800d7c:	83 ec 0c             	sub    $0xc,%esp
  800d7f:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800d83:	52                   	push   %edx
  800d84:	ff 75 e0             	pushl  -0x20(%ebp)
  800d87:	50                   	push   %eax
  800d88:	ff 75 dc             	pushl  -0x24(%ebp)
  800d8b:	ff 75 d8             	pushl  -0x28(%ebp)
  800d8e:	89 da                	mov    %ebx,%edx
  800d90:	89 f0                	mov    %esi,%eax
  800d92:	e8 a4 fa ff ff       	call   80083b <printnum>
			break;
  800d97:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800d9a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d9d:	83 c7 01             	add    $0x1,%edi
  800da0:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800da4:	83 f8 25             	cmp    $0x25,%eax
  800da7:	0f 84 be fb ff ff    	je     80096b <vprintfmt+0x17>
			if (ch == '\0')
  800dad:	85 c0                	test   %eax,%eax
  800daf:	0f 84 28 01 00 00    	je     800edd <vprintfmt+0x589>
			putch(ch, putdat);
  800db5:	83 ec 08             	sub    $0x8,%esp
  800db8:	53                   	push   %ebx
  800db9:	50                   	push   %eax
  800dba:	ff d6                	call   *%esi
  800dbc:	83 c4 10             	add    $0x10,%esp
  800dbf:	eb dc                	jmp    800d9d <vprintfmt+0x449>
	if (lflag >= 2)
  800dc1:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800dc5:	7f 26                	jg     800ded <vprintfmt+0x499>
	else if (lflag)
  800dc7:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800dcb:	74 41                	je     800e0e <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800dcd:	8b 45 14             	mov    0x14(%ebp),%eax
  800dd0:	8b 00                	mov    (%eax),%eax
  800dd2:	ba 00 00 00 00       	mov    $0x0,%edx
  800dd7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800dda:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ddd:	8b 45 14             	mov    0x14(%ebp),%eax
  800de0:	8d 40 04             	lea    0x4(%eax),%eax
  800de3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800de6:	b8 10 00 00 00       	mov    $0x10,%eax
  800deb:	eb 8f                	jmp    800d7c <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800ded:	8b 45 14             	mov    0x14(%ebp),%eax
  800df0:	8b 50 04             	mov    0x4(%eax),%edx
  800df3:	8b 00                	mov    (%eax),%eax
  800df5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800df8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800dfb:	8b 45 14             	mov    0x14(%ebp),%eax
  800dfe:	8d 40 08             	lea    0x8(%eax),%eax
  800e01:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800e04:	b8 10 00 00 00       	mov    $0x10,%eax
  800e09:	e9 6e ff ff ff       	jmp    800d7c <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800e0e:	8b 45 14             	mov    0x14(%ebp),%eax
  800e11:	8b 00                	mov    (%eax),%eax
  800e13:	ba 00 00 00 00       	mov    $0x0,%edx
  800e18:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800e1b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800e1e:	8b 45 14             	mov    0x14(%ebp),%eax
  800e21:	8d 40 04             	lea    0x4(%eax),%eax
  800e24:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800e27:	b8 10 00 00 00       	mov    $0x10,%eax
  800e2c:	e9 4b ff ff ff       	jmp    800d7c <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800e31:	8b 45 14             	mov    0x14(%ebp),%eax
  800e34:	83 c0 04             	add    $0x4,%eax
  800e37:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800e3a:	8b 45 14             	mov    0x14(%ebp),%eax
  800e3d:	8b 00                	mov    (%eax),%eax
  800e3f:	85 c0                	test   %eax,%eax
  800e41:	74 14                	je     800e57 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800e43:	8b 13                	mov    (%ebx),%edx
  800e45:	83 fa 7f             	cmp    $0x7f,%edx
  800e48:	7f 37                	jg     800e81 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800e4a:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800e4c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800e4f:	89 45 14             	mov    %eax,0x14(%ebp)
  800e52:	e9 43 ff ff ff       	jmp    800d9a <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800e57:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e5c:	bf d5 30 80 00       	mov    $0x8030d5,%edi
							putch(ch, putdat);
  800e61:	83 ec 08             	sub    $0x8,%esp
  800e64:	53                   	push   %ebx
  800e65:	50                   	push   %eax
  800e66:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800e68:	83 c7 01             	add    $0x1,%edi
  800e6b:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800e6f:	83 c4 10             	add    $0x10,%esp
  800e72:	85 c0                	test   %eax,%eax
  800e74:	75 eb                	jne    800e61 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800e76:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800e79:	89 45 14             	mov    %eax,0x14(%ebp)
  800e7c:	e9 19 ff ff ff       	jmp    800d9a <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800e81:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800e83:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e88:	bf 0d 31 80 00       	mov    $0x80310d,%edi
							putch(ch, putdat);
  800e8d:	83 ec 08             	sub    $0x8,%esp
  800e90:	53                   	push   %ebx
  800e91:	50                   	push   %eax
  800e92:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800e94:	83 c7 01             	add    $0x1,%edi
  800e97:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800e9b:	83 c4 10             	add    $0x10,%esp
  800e9e:	85 c0                	test   %eax,%eax
  800ea0:	75 eb                	jne    800e8d <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800ea2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800ea5:	89 45 14             	mov    %eax,0x14(%ebp)
  800ea8:	e9 ed fe ff ff       	jmp    800d9a <vprintfmt+0x446>
			putch(ch, putdat);
  800ead:	83 ec 08             	sub    $0x8,%esp
  800eb0:	53                   	push   %ebx
  800eb1:	6a 25                	push   $0x25
  800eb3:	ff d6                	call   *%esi
			break;
  800eb5:	83 c4 10             	add    $0x10,%esp
  800eb8:	e9 dd fe ff ff       	jmp    800d9a <vprintfmt+0x446>
			putch('%', putdat);
  800ebd:	83 ec 08             	sub    $0x8,%esp
  800ec0:	53                   	push   %ebx
  800ec1:	6a 25                	push   $0x25
  800ec3:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ec5:	83 c4 10             	add    $0x10,%esp
  800ec8:	89 f8                	mov    %edi,%eax
  800eca:	eb 03                	jmp    800ecf <vprintfmt+0x57b>
  800ecc:	83 e8 01             	sub    $0x1,%eax
  800ecf:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800ed3:	75 f7                	jne    800ecc <vprintfmt+0x578>
  800ed5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ed8:	e9 bd fe ff ff       	jmp    800d9a <vprintfmt+0x446>
}
  800edd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ee0:	5b                   	pop    %ebx
  800ee1:	5e                   	pop    %esi
  800ee2:	5f                   	pop    %edi
  800ee3:	5d                   	pop    %ebp
  800ee4:	c3                   	ret    

00800ee5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ee5:	55                   	push   %ebp
  800ee6:	89 e5                	mov    %esp,%ebp
  800ee8:	83 ec 18             	sub    $0x18,%esp
  800eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800eee:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ef1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ef4:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800ef8:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800efb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800f02:	85 c0                	test   %eax,%eax
  800f04:	74 26                	je     800f2c <vsnprintf+0x47>
  800f06:	85 d2                	test   %edx,%edx
  800f08:	7e 22                	jle    800f2c <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800f0a:	ff 75 14             	pushl  0x14(%ebp)
  800f0d:	ff 75 10             	pushl  0x10(%ebp)
  800f10:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800f13:	50                   	push   %eax
  800f14:	68 1a 09 80 00       	push   $0x80091a
  800f19:	e8 36 fa ff ff       	call   800954 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800f1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f21:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800f24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f27:	83 c4 10             	add    $0x10,%esp
}
  800f2a:	c9                   	leave  
  800f2b:	c3                   	ret    
		return -E_INVAL;
  800f2c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f31:	eb f7                	jmp    800f2a <vsnprintf+0x45>

00800f33 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f33:	55                   	push   %ebp
  800f34:	89 e5                	mov    %esp,%ebp
  800f36:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800f39:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800f3c:	50                   	push   %eax
  800f3d:	ff 75 10             	pushl  0x10(%ebp)
  800f40:	ff 75 0c             	pushl  0xc(%ebp)
  800f43:	ff 75 08             	pushl  0x8(%ebp)
  800f46:	e8 9a ff ff ff       	call   800ee5 <vsnprintf>
	va_end(ap);

	return rc;
}
  800f4b:	c9                   	leave  
  800f4c:	c3                   	ret    

00800f4d <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800f4d:	55                   	push   %ebp
  800f4e:	89 e5                	mov    %esp,%ebp
  800f50:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800f53:	b8 00 00 00 00       	mov    $0x0,%eax
  800f58:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800f5c:	74 05                	je     800f63 <strlen+0x16>
		n++;
  800f5e:	83 c0 01             	add    $0x1,%eax
  800f61:	eb f5                	jmp    800f58 <strlen+0xb>
	return n;
}
  800f63:	5d                   	pop    %ebp
  800f64:	c3                   	ret    

00800f65 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800f65:	55                   	push   %ebp
  800f66:	89 e5                	mov    %esp,%ebp
  800f68:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f6b:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f6e:	ba 00 00 00 00       	mov    $0x0,%edx
  800f73:	39 c2                	cmp    %eax,%edx
  800f75:	74 0d                	je     800f84 <strnlen+0x1f>
  800f77:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800f7b:	74 05                	je     800f82 <strnlen+0x1d>
		n++;
  800f7d:	83 c2 01             	add    $0x1,%edx
  800f80:	eb f1                	jmp    800f73 <strnlen+0xe>
  800f82:	89 d0                	mov    %edx,%eax
	return n;
}
  800f84:	5d                   	pop    %ebp
  800f85:	c3                   	ret    

00800f86 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f86:	55                   	push   %ebp
  800f87:	89 e5                	mov    %esp,%ebp
  800f89:	53                   	push   %ebx
  800f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800f90:	ba 00 00 00 00       	mov    $0x0,%edx
  800f95:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800f99:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800f9c:	83 c2 01             	add    $0x1,%edx
  800f9f:	84 c9                	test   %cl,%cl
  800fa1:	75 f2                	jne    800f95 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800fa3:	5b                   	pop    %ebx
  800fa4:	5d                   	pop    %ebp
  800fa5:	c3                   	ret    

00800fa6 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800fa6:	55                   	push   %ebp
  800fa7:	89 e5                	mov    %esp,%ebp
  800fa9:	53                   	push   %ebx
  800faa:	83 ec 10             	sub    $0x10,%esp
  800fad:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800fb0:	53                   	push   %ebx
  800fb1:	e8 97 ff ff ff       	call   800f4d <strlen>
  800fb6:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800fb9:	ff 75 0c             	pushl  0xc(%ebp)
  800fbc:	01 d8                	add    %ebx,%eax
  800fbe:	50                   	push   %eax
  800fbf:	e8 c2 ff ff ff       	call   800f86 <strcpy>
	return dst;
}
  800fc4:	89 d8                	mov    %ebx,%eax
  800fc6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fc9:	c9                   	leave  
  800fca:	c3                   	ret    

00800fcb <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800fcb:	55                   	push   %ebp
  800fcc:	89 e5                	mov    %esp,%ebp
  800fce:	56                   	push   %esi
  800fcf:	53                   	push   %ebx
  800fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd6:	89 c6                	mov    %eax,%esi
  800fd8:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800fdb:	89 c2                	mov    %eax,%edx
  800fdd:	39 f2                	cmp    %esi,%edx
  800fdf:	74 11                	je     800ff2 <strncpy+0x27>
		*dst++ = *src;
  800fe1:	83 c2 01             	add    $0x1,%edx
  800fe4:	0f b6 19             	movzbl (%ecx),%ebx
  800fe7:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800fea:	80 fb 01             	cmp    $0x1,%bl
  800fed:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800ff0:	eb eb                	jmp    800fdd <strncpy+0x12>
	}
	return ret;
}
  800ff2:	5b                   	pop    %ebx
  800ff3:	5e                   	pop    %esi
  800ff4:	5d                   	pop    %ebp
  800ff5:	c3                   	ret    

00800ff6 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ff6:	55                   	push   %ebp
  800ff7:	89 e5                	mov    %esp,%ebp
  800ff9:	56                   	push   %esi
  800ffa:	53                   	push   %ebx
  800ffb:	8b 75 08             	mov    0x8(%ebp),%esi
  800ffe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801001:	8b 55 10             	mov    0x10(%ebp),%edx
  801004:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801006:	85 d2                	test   %edx,%edx
  801008:	74 21                	je     80102b <strlcpy+0x35>
  80100a:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80100e:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  801010:	39 c2                	cmp    %eax,%edx
  801012:	74 14                	je     801028 <strlcpy+0x32>
  801014:	0f b6 19             	movzbl (%ecx),%ebx
  801017:	84 db                	test   %bl,%bl
  801019:	74 0b                	je     801026 <strlcpy+0x30>
			*dst++ = *src++;
  80101b:	83 c1 01             	add    $0x1,%ecx
  80101e:	83 c2 01             	add    $0x1,%edx
  801021:	88 5a ff             	mov    %bl,-0x1(%edx)
  801024:	eb ea                	jmp    801010 <strlcpy+0x1a>
  801026:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801028:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80102b:	29 f0                	sub    %esi,%eax
}
  80102d:	5b                   	pop    %ebx
  80102e:	5e                   	pop    %esi
  80102f:	5d                   	pop    %ebp
  801030:	c3                   	ret    

00801031 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801031:	55                   	push   %ebp
  801032:	89 e5                	mov    %esp,%ebp
  801034:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801037:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80103a:	0f b6 01             	movzbl (%ecx),%eax
  80103d:	84 c0                	test   %al,%al
  80103f:	74 0c                	je     80104d <strcmp+0x1c>
  801041:	3a 02                	cmp    (%edx),%al
  801043:	75 08                	jne    80104d <strcmp+0x1c>
		p++, q++;
  801045:	83 c1 01             	add    $0x1,%ecx
  801048:	83 c2 01             	add    $0x1,%edx
  80104b:	eb ed                	jmp    80103a <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80104d:	0f b6 c0             	movzbl %al,%eax
  801050:	0f b6 12             	movzbl (%edx),%edx
  801053:	29 d0                	sub    %edx,%eax
}
  801055:	5d                   	pop    %ebp
  801056:	c3                   	ret    

00801057 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801057:	55                   	push   %ebp
  801058:	89 e5                	mov    %esp,%ebp
  80105a:	53                   	push   %ebx
  80105b:	8b 45 08             	mov    0x8(%ebp),%eax
  80105e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801061:	89 c3                	mov    %eax,%ebx
  801063:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801066:	eb 06                	jmp    80106e <strncmp+0x17>
		n--, p++, q++;
  801068:	83 c0 01             	add    $0x1,%eax
  80106b:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80106e:	39 d8                	cmp    %ebx,%eax
  801070:	74 16                	je     801088 <strncmp+0x31>
  801072:	0f b6 08             	movzbl (%eax),%ecx
  801075:	84 c9                	test   %cl,%cl
  801077:	74 04                	je     80107d <strncmp+0x26>
  801079:	3a 0a                	cmp    (%edx),%cl
  80107b:	74 eb                	je     801068 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80107d:	0f b6 00             	movzbl (%eax),%eax
  801080:	0f b6 12             	movzbl (%edx),%edx
  801083:	29 d0                	sub    %edx,%eax
}
  801085:	5b                   	pop    %ebx
  801086:	5d                   	pop    %ebp
  801087:	c3                   	ret    
		return 0;
  801088:	b8 00 00 00 00       	mov    $0x0,%eax
  80108d:	eb f6                	jmp    801085 <strncmp+0x2e>

0080108f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80108f:	55                   	push   %ebp
  801090:	89 e5                	mov    %esp,%ebp
  801092:	8b 45 08             	mov    0x8(%ebp),%eax
  801095:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801099:	0f b6 10             	movzbl (%eax),%edx
  80109c:	84 d2                	test   %dl,%dl
  80109e:	74 09                	je     8010a9 <strchr+0x1a>
		if (*s == c)
  8010a0:	38 ca                	cmp    %cl,%dl
  8010a2:	74 0a                	je     8010ae <strchr+0x1f>
	for (; *s; s++)
  8010a4:	83 c0 01             	add    $0x1,%eax
  8010a7:	eb f0                	jmp    801099 <strchr+0xa>
			return (char *) s;
	return 0;
  8010a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010ae:	5d                   	pop    %ebp
  8010af:	c3                   	ret    

008010b0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8010b0:	55                   	push   %ebp
  8010b1:	89 e5                	mov    %esp,%ebp
  8010b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8010ba:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8010bd:	38 ca                	cmp    %cl,%dl
  8010bf:	74 09                	je     8010ca <strfind+0x1a>
  8010c1:	84 d2                	test   %dl,%dl
  8010c3:	74 05                	je     8010ca <strfind+0x1a>
	for (; *s; s++)
  8010c5:	83 c0 01             	add    $0x1,%eax
  8010c8:	eb f0                	jmp    8010ba <strfind+0xa>
			break;
	return (char *) s;
}
  8010ca:	5d                   	pop    %ebp
  8010cb:	c3                   	ret    

008010cc <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8010cc:	55                   	push   %ebp
  8010cd:	89 e5                	mov    %esp,%ebp
  8010cf:	57                   	push   %edi
  8010d0:	56                   	push   %esi
  8010d1:	53                   	push   %ebx
  8010d2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8010d5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8010d8:	85 c9                	test   %ecx,%ecx
  8010da:	74 31                	je     80110d <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8010dc:	89 f8                	mov    %edi,%eax
  8010de:	09 c8                	or     %ecx,%eax
  8010e0:	a8 03                	test   $0x3,%al
  8010e2:	75 23                	jne    801107 <memset+0x3b>
		c &= 0xFF;
  8010e4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8010e8:	89 d3                	mov    %edx,%ebx
  8010ea:	c1 e3 08             	shl    $0x8,%ebx
  8010ed:	89 d0                	mov    %edx,%eax
  8010ef:	c1 e0 18             	shl    $0x18,%eax
  8010f2:	89 d6                	mov    %edx,%esi
  8010f4:	c1 e6 10             	shl    $0x10,%esi
  8010f7:	09 f0                	or     %esi,%eax
  8010f9:	09 c2                	or     %eax,%edx
  8010fb:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8010fd:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801100:	89 d0                	mov    %edx,%eax
  801102:	fc                   	cld    
  801103:	f3 ab                	rep stos %eax,%es:(%edi)
  801105:	eb 06                	jmp    80110d <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801107:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110a:	fc                   	cld    
  80110b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80110d:	89 f8                	mov    %edi,%eax
  80110f:	5b                   	pop    %ebx
  801110:	5e                   	pop    %esi
  801111:	5f                   	pop    %edi
  801112:	5d                   	pop    %ebp
  801113:	c3                   	ret    

00801114 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801114:	55                   	push   %ebp
  801115:	89 e5                	mov    %esp,%ebp
  801117:	57                   	push   %edi
  801118:	56                   	push   %esi
  801119:	8b 45 08             	mov    0x8(%ebp),%eax
  80111c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80111f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801122:	39 c6                	cmp    %eax,%esi
  801124:	73 32                	jae    801158 <memmove+0x44>
  801126:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801129:	39 c2                	cmp    %eax,%edx
  80112b:	76 2b                	jbe    801158 <memmove+0x44>
		s += n;
		d += n;
  80112d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801130:	89 fe                	mov    %edi,%esi
  801132:	09 ce                	or     %ecx,%esi
  801134:	09 d6                	or     %edx,%esi
  801136:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80113c:	75 0e                	jne    80114c <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80113e:	83 ef 04             	sub    $0x4,%edi
  801141:	8d 72 fc             	lea    -0x4(%edx),%esi
  801144:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801147:	fd                   	std    
  801148:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80114a:	eb 09                	jmp    801155 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80114c:	83 ef 01             	sub    $0x1,%edi
  80114f:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801152:	fd                   	std    
  801153:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801155:	fc                   	cld    
  801156:	eb 1a                	jmp    801172 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801158:	89 c2                	mov    %eax,%edx
  80115a:	09 ca                	or     %ecx,%edx
  80115c:	09 f2                	or     %esi,%edx
  80115e:	f6 c2 03             	test   $0x3,%dl
  801161:	75 0a                	jne    80116d <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801163:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801166:	89 c7                	mov    %eax,%edi
  801168:	fc                   	cld    
  801169:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80116b:	eb 05                	jmp    801172 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  80116d:	89 c7                	mov    %eax,%edi
  80116f:	fc                   	cld    
  801170:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801172:	5e                   	pop    %esi
  801173:	5f                   	pop    %edi
  801174:	5d                   	pop    %ebp
  801175:	c3                   	ret    

00801176 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801176:	55                   	push   %ebp
  801177:	89 e5                	mov    %esp,%ebp
  801179:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  80117c:	ff 75 10             	pushl  0x10(%ebp)
  80117f:	ff 75 0c             	pushl  0xc(%ebp)
  801182:	ff 75 08             	pushl  0x8(%ebp)
  801185:	e8 8a ff ff ff       	call   801114 <memmove>
}
  80118a:	c9                   	leave  
  80118b:	c3                   	ret    

0080118c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80118c:	55                   	push   %ebp
  80118d:	89 e5                	mov    %esp,%ebp
  80118f:	56                   	push   %esi
  801190:	53                   	push   %ebx
  801191:	8b 45 08             	mov    0x8(%ebp),%eax
  801194:	8b 55 0c             	mov    0xc(%ebp),%edx
  801197:	89 c6                	mov    %eax,%esi
  801199:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80119c:	39 f0                	cmp    %esi,%eax
  80119e:	74 1c                	je     8011bc <memcmp+0x30>
		if (*s1 != *s2)
  8011a0:	0f b6 08             	movzbl (%eax),%ecx
  8011a3:	0f b6 1a             	movzbl (%edx),%ebx
  8011a6:	38 d9                	cmp    %bl,%cl
  8011a8:	75 08                	jne    8011b2 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8011aa:	83 c0 01             	add    $0x1,%eax
  8011ad:	83 c2 01             	add    $0x1,%edx
  8011b0:	eb ea                	jmp    80119c <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8011b2:	0f b6 c1             	movzbl %cl,%eax
  8011b5:	0f b6 db             	movzbl %bl,%ebx
  8011b8:	29 d8                	sub    %ebx,%eax
  8011ba:	eb 05                	jmp    8011c1 <memcmp+0x35>
	}

	return 0;
  8011bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011c1:	5b                   	pop    %ebx
  8011c2:	5e                   	pop    %esi
  8011c3:	5d                   	pop    %ebp
  8011c4:	c3                   	ret    

008011c5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8011c5:	55                   	push   %ebp
  8011c6:	89 e5                	mov    %esp,%ebp
  8011c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8011ce:	89 c2                	mov    %eax,%edx
  8011d0:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8011d3:	39 d0                	cmp    %edx,%eax
  8011d5:	73 09                	jae    8011e0 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011d7:	38 08                	cmp    %cl,(%eax)
  8011d9:	74 05                	je     8011e0 <memfind+0x1b>
	for (; s < ends; s++)
  8011db:	83 c0 01             	add    $0x1,%eax
  8011de:	eb f3                	jmp    8011d3 <memfind+0xe>
			break;
	return (void *) s;
}
  8011e0:	5d                   	pop    %ebp
  8011e1:	c3                   	ret    

008011e2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011e2:	55                   	push   %ebp
  8011e3:	89 e5                	mov    %esp,%ebp
  8011e5:	57                   	push   %edi
  8011e6:	56                   	push   %esi
  8011e7:	53                   	push   %ebx
  8011e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011eb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011ee:	eb 03                	jmp    8011f3 <strtol+0x11>
		s++;
  8011f0:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8011f3:	0f b6 01             	movzbl (%ecx),%eax
  8011f6:	3c 20                	cmp    $0x20,%al
  8011f8:	74 f6                	je     8011f0 <strtol+0xe>
  8011fa:	3c 09                	cmp    $0x9,%al
  8011fc:	74 f2                	je     8011f0 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  8011fe:	3c 2b                	cmp    $0x2b,%al
  801200:	74 2a                	je     80122c <strtol+0x4a>
	int neg = 0;
  801202:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801207:	3c 2d                	cmp    $0x2d,%al
  801209:	74 2b                	je     801236 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80120b:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801211:	75 0f                	jne    801222 <strtol+0x40>
  801213:	80 39 30             	cmpb   $0x30,(%ecx)
  801216:	74 28                	je     801240 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801218:	85 db                	test   %ebx,%ebx
  80121a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80121f:	0f 44 d8             	cmove  %eax,%ebx
  801222:	b8 00 00 00 00       	mov    $0x0,%eax
  801227:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80122a:	eb 50                	jmp    80127c <strtol+0x9a>
		s++;
  80122c:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  80122f:	bf 00 00 00 00       	mov    $0x0,%edi
  801234:	eb d5                	jmp    80120b <strtol+0x29>
		s++, neg = 1;
  801236:	83 c1 01             	add    $0x1,%ecx
  801239:	bf 01 00 00 00       	mov    $0x1,%edi
  80123e:	eb cb                	jmp    80120b <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801240:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801244:	74 0e                	je     801254 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  801246:	85 db                	test   %ebx,%ebx
  801248:	75 d8                	jne    801222 <strtol+0x40>
		s++, base = 8;
  80124a:	83 c1 01             	add    $0x1,%ecx
  80124d:	bb 08 00 00 00       	mov    $0x8,%ebx
  801252:	eb ce                	jmp    801222 <strtol+0x40>
		s += 2, base = 16;
  801254:	83 c1 02             	add    $0x2,%ecx
  801257:	bb 10 00 00 00       	mov    $0x10,%ebx
  80125c:	eb c4                	jmp    801222 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  80125e:	8d 72 9f             	lea    -0x61(%edx),%esi
  801261:	89 f3                	mov    %esi,%ebx
  801263:	80 fb 19             	cmp    $0x19,%bl
  801266:	77 29                	ja     801291 <strtol+0xaf>
			dig = *s - 'a' + 10;
  801268:	0f be d2             	movsbl %dl,%edx
  80126b:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  80126e:	3b 55 10             	cmp    0x10(%ebp),%edx
  801271:	7d 30                	jge    8012a3 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  801273:	83 c1 01             	add    $0x1,%ecx
  801276:	0f af 45 10          	imul   0x10(%ebp),%eax
  80127a:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  80127c:	0f b6 11             	movzbl (%ecx),%edx
  80127f:	8d 72 d0             	lea    -0x30(%edx),%esi
  801282:	89 f3                	mov    %esi,%ebx
  801284:	80 fb 09             	cmp    $0x9,%bl
  801287:	77 d5                	ja     80125e <strtol+0x7c>
			dig = *s - '0';
  801289:	0f be d2             	movsbl %dl,%edx
  80128c:	83 ea 30             	sub    $0x30,%edx
  80128f:	eb dd                	jmp    80126e <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  801291:	8d 72 bf             	lea    -0x41(%edx),%esi
  801294:	89 f3                	mov    %esi,%ebx
  801296:	80 fb 19             	cmp    $0x19,%bl
  801299:	77 08                	ja     8012a3 <strtol+0xc1>
			dig = *s - 'A' + 10;
  80129b:	0f be d2             	movsbl %dl,%edx
  80129e:	83 ea 37             	sub    $0x37,%edx
  8012a1:	eb cb                	jmp    80126e <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  8012a3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012a7:	74 05                	je     8012ae <strtol+0xcc>
		*endptr = (char *) s;
  8012a9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012ac:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  8012ae:	89 c2                	mov    %eax,%edx
  8012b0:	f7 da                	neg    %edx
  8012b2:	85 ff                	test   %edi,%edi
  8012b4:	0f 45 c2             	cmovne %edx,%eax
}
  8012b7:	5b                   	pop    %ebx
  8012b8:	5e                   	pop    %esi
  8012b9:	5f                   	pop    %edi
  8012ba:	5d                   	pop    %ebp
  8012bb:	c3                   	ret    

008012bc <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8012bc:	55                   	push   %ebp
  8012bd:	89 e5                	mov    %esp,%ebp
  8012bf:	57                   	push   %edi
  8012c0:	56                   	push   %esi
  8012c1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8012c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8012c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8012ca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012cd:	89 c3                	mov    %eax,%ebx
  8012cf:	89 c7                	mov    %eax,%edi
  8012d1:	89 c6                	mov    %eax,%esi
  8012d3:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8012d5:	5b                   	pop    %ebx
  8012d6:	5e                   	pop    %esi
  8012d7:	5f                   	pop    %edi
  8012d8:	5d                   	pop    %ebp
  8012d9:	c3                   	ret    

008012da <sys_cgetc>:

int
sys_cgetc(void)
{
  8012da:	55                   	push   %ebp
  8012db:	89 e5                	mov    %esp,%ebp
  8012dd:	57                   	push   %edi
  8012de:	56                   	push   %esi
  8012df:	53                   	push   %ebx
	asm volatile("int %1\n"
  8012e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8012e5:	b8 01 00 00 00       	mov    $0x1,%eax
  8012ea:	89 d1                	mov    %edx,%ecx
  8012ec:	89 d3                	mov    %edx,%ebx
  8012ee:	89 d7                	mov    %edx,%edi
  8012f0:	89 d6                	mov    %edx,%esi
  8012f2:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8012f4:	5b                   	pop    %ebx
  8012f5:	5e                   	pop    %esi
  8012f6:	5f                   	pop    %edi
  8012f7:	5d                   	pop    %ebp
  8012f8:	c3                   	ret    

008012f9 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8012f9:	55                   	push   %ebp
  8012fa:	89 e5                	mov    %esp,%ebp
  8012fc:	57                   	push   %edi
  8012fd:	56                   	push   %esi
  8012fe:	53                   	push   %ebx
  8012ff:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801302:	b9 00 00 00 00       	mov    $0x0,%ecx
  801307:	8b 55 08             	mov    0x8(%ebp),%edx
  80130a:	b8 03 00 00 00       	mov    $0x3,%eax
  80130f:	89 cb                	mov    %ecx,%ebx
  801311:	89 cf                	mov    %ecx,%edi
  801313:	89 ce                	mov    %ecx,%esi
  801315:	cd 30                	int    $0x30
	if(check && ret > 0)
  801317:	85 c0                	test   %eax,%eax
  801319:	7f 08                	jg     801323 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80131b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80131e:	5b                   	pop    %ebx
  80131f:	5e                   	pop    %esi
  801320:	5f                   	pop    %edi
  801321:	5d                   	pop    %ebp
  801322:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801323:	83 ec 0c             	sub    $0xc,%esp
  801326:	50                   	push   %eax
  801327:	6a 03                	push   $0x3
  801329:	68 28 33 80 00       	push   $0x803328
  80132e:	6a 43                	push   $0x43
  801330:	68 45 33 80 00       	push   $0x803345
  801335:	e8 f7 f3 ff ff       	call   800731 <_panic>

0080133a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80133a:	55                   	push   %ebp
  80133b:	89 e5                	mov    %esp,%ebp
  80133d:	57                   	push   %edi
  80133e:	56                   	push   %esi
  80133f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801340:	ba 00 00 00 00       	mov    $0x0,%edx
  801345:	b8 02 00 00 00       	mov    $0x2,%eax
  80134a:	89 d1                	mov    %edx,%ecx
  80134c:	89 d3                	mov    %edx,%ebx
  80134e:	89 d7                	mov    %edx,%edi
  801350:	89 d6                	mov    %edx,%esi
  801352:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801354:	5b                   	pop    %ebx
  801355:	5e                   	pop    %esi
  801356:	5f                   	pop    %edi
  801357:	5d                   	pop    %ebp
  801358:	c3                   	ret    

00801359 <sys_yield>:

void
sys_yield(void)
{
  801359:	55                   	push   %ebp
  80135a:	89 e5                	mov    %esp,%ebp
  80135c:	57                   	push   %edi
  80135d:	56                   	push   %esi
  80135e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80135f:	ba 00 00 00 00       	mov    $0x0,%edx
  801364:	b8 0b 00 00 00       	mov    $0xb,%eax
  801369:	89 d1                	mov    %edx,%ecx
  80136b:	89 d3                	mov    %edx,%ebx
  80136d:	89 d7                	mov    %edx,%edi
  80136f:	89 d6                	mov    %edx,%esi
  801371:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801373:	5b                   	pop    %ebx
  801374:	5e                   	pop    %esi
  801375:	5f                   	pop    %edi
  801376:	5d                   	pop    %ebp
  801377:	c3                   	ret    

00801378 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801378:	55                   	push   %ebp
  801379:	89 e5                	mov    %esp,%ebp
  80137b:	57                   	push   %edi
  80137c:	56                   	push   %esi
  80137d:	53                   	push   %ebx
  80137e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801381:	be 00 00 00 00       	mov    $0x0,%esi
  801386:	8b 55 08             	mov    0x8(%ebp),%edx
  801389:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80138c:	b8 04 00 00 00       	mov    $0x4,%eax
  801391:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801394:	89 f7                	mov    %esi,%edi
  801396:	cd 30                	int    $0x30
	if(check && ret > 0)
  801398:	85 c0                	test   %eax,%eax
  80139a:	7f 08                	jg     8013a4 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80139c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80139f:	5b                   	pop    %ebx
  8013a0:	5e                   	pop    %esi
  8013a1:	5f                   	pop    %edi
  8013a2:	5d                   	pop    %ebp
  8013a3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8013a4:	83 ec 0c             	sub    $0xc,%esp
  8013a7:	50                   	push   %eax
  8013a8:	6a 04                	push   $0x4
  8013aa:	68 28 33 80 00       	push   $0x803328
  8013af:	6a 43                	push   $0x43
  8013b1:	68 45 33 80 00       	push   $0x803345
  8013b6:	e8 76 f3 ff ff       	call   800731 <_panic>

008013bb <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8013bb:	55                   	push   %ebp
  8013bc:	89 e5                	mov    %esp,%ebp
  8013be:	57                   	push   %edi
  8013bf:	56                   	push   %esi
  8013c0:	53                   	push   %ebx
  8013c1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8013c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8013c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013ca:	b8 05 00 00 00       	mov    $0x5,%eax
  8013cf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8013d2:	8b 7d 14             	mov    0x14(%ebp),%edi
  8013d5:	8b 75 18             	mov    0x18(%ebp),%esi
  8013d8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8013da:	85 c0                	test   %eax,%eax
  8013dc:	7f 08                	jg     8013e6 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8013de:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013e1:	5b                   	pop    %ebx
  8013e2:	5e                   	pop    %esi
  8013e3:	5f                   	pop    %edi
  8013e4:	5d                   	pop    %ebp
  8013e5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8013e6:	83 ec 0c             	sub    $0xc,%esp
  8013e9:	50                   	push   %eax
  8013ea:	6a 05                	push   $0x5
  8013ec:	68 28 33 80 00       	push   $0x803328
  8013f1:	6a 43                	push   $0x43
  8013f3:	68 45 33 80 00       	push   $0x803345
  8013f8:	e8 34 f3 ff ff       	call   800731 <_panic>

008013fd <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8013fd:	55                   	push   %ebp
  8013fe:	89 e5                	mov    %esp,%ebp
  801400:	57                   	push   %edi
  801401:	56                   	push   %esi
  801402:	53                   	push   %ebx
  801403:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801406:	bb 00 00 00 00       	mov    $0x0,%ebx
  80140b:	8b 55 08             	mov    0x8(%ebp),%edx
  80140e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801411:	b8 06 00 00 00       	mov    $0x6,%eax
  801416:	89 df                	mov    %ebx,%edi
  801418:	89 de                	mov    %ebx,%esi
  80141a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80141c:	85 c0                	test   %eax,%eax
  80141e:	7f 08                	jg     801428 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801420:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801423:	5b                   	pop    %ebx
  801424:	5e                   	pop    %esi
  801425:	5f                   	pop    %edi
  801426:	5d                   	pop    %ebp
  801427:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801428:	83 ec 0c             	sub    $0xc,%esp
  80142b:	50                   	push   %eax
  80142c:	6a 06                	push   $0x6
  80142e:	68 28 33 80 00       	push   $0x803328
  801433:	6a 43                	push   $0x43
  801435:	68 45 33 80 00       	push   $0x803345
  80143a:	e8 f2 f2 ff ff       	call   800731 <_panic>

0080143f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80143f:	55                   	push   %ebp
  801440:	89 e5                	mov    %esp,%ebp
  801442:	57                   	push   %edi
  801443:	56                   	push   %esi
  801444:	53                   	push   %ebx
  801445:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801448:	bb 00 00 00 00       	mov    $0x0,%ebx
  80144d:	8b 55 08             	mov    0x8(%ebp),%edx
  801450:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801453:	b8 08 00 00 00       	mov    $0x8,%eax
  801458:	89 df                	mov    %ebx,%edi
  80145a:	89 de                	mov    %ebx,%esi
  80145c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80145e:	85 c0                	test   %eax,%eax
  801460:	7f 08                	jg     80146a <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801462:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801465:	5b                   	pop    %ebx
  801466:	5e                   	pop    %esi
  801467:	5f                   	pop    %edi
  801468:	5d                   	pop    %ebp
  801469:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80146a:	83 ec 0c             	sub    $0xc,%esp
  80146d:	50                   	push   %eax
  80146e:	6a 08                	push   $0x8
  801470:	68 28 33 80 00       	push   $0x803328
  801475:	6a 43                	push   $0x43
  801477:	68 45 33 80 00       	push   $0x803345
  80147c:	e8 b0 f2 ff ff       	call   800731 <_panic>

00801481 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801481:	55                   	push   %ebp
  801482:	89 e5                	mov    %esp,%ebp
  801484:	57                   	push   %edi
  801485:	56                   	push   %esi
  801486:	53                   	push   %ebx
  801487:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80148a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80148f:	8b 55 08             	mov    0x8(%ebp),%edx
  801492:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801495:	b8 09 00 00 00       	mov    $0x9,%eax
  80149a:	89 df                	mov    %ebx,%edi
  80149c:	89 de                	mov    %ebx,%esi
  80149e:	cd 30                	int    $0x30
	if(check && ret > 0)
  8014a0:	85 c0                	test   %eax,%eax
  8014a2:	7f 08                	jg     8014ac <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8014a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014a7:	5b                   	pop    %ebx
  8014a8:	5e                   	pop    %esi
  8014a9:	5f                   	pop    %edi
  8014aa:	5d                   	pop    %ebp
  8014ab:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8014ac:	83 ec 0c             	sub    $0xc,%esp
  8014af:	50                   	push   %eax
  8014b0:	6a 09                	push   $0x9
  8014b2:	68 28 33 80 00       	push   $0x803328
  8014b7:	6a 43                	push   $0x43
  8014b9:	68 45 33 80 00       	push   $0x803345
  8014be:	e8 6e f2 ff ff       	call   800731 <_panic>

008014c3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8014c3:	55                   	push   %ebp
  8014c4:	89 e5                	mov    %esp,%ebp
  8014c6:	57                   	push   %edi
  8014c7:	56                   	push   %esi
  8014c8:	53                   	push   %ebx
  8014c9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8014cc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8014d4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014d7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8014dc:	89 df                	mov    %ebx,%edi
  8014de:	89 de                	mov    %ebx,%esi
  8014e0:	cd 30                	int    $0x30
	if(check && ret > 0)
  8014e2:	85 c0                	test   %eax,%eax
  8014e4:	7f 08                	jg     8014ee <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8014e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014e9:	5b                   	pop    %ebx
  8014ea:	5e                   	pop    %esi
  8014eb:	5f                   	pop    %edi
  8014ec:	5d                   	pop    %ebp
  8014ed:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8014ee:	83 ec 0c             	sub    $0xc,%esp
  8014f1:	50                   	push   %eax
  8014f2:	6a 0a                	push   $0xa
  8014f4:	68 28 33 80 00       	push   $0x803328
  8014f9:	6a 43                	push   $0x43
  8014fb:	68 45 33 80 00       	push   $0x803345
  801500:	e8 2c f2 ff ff       	call   800731 <_panic>

00801505 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801505:	55                   	push   %ebp
  801506:	89 e5                	mov    %esp,%ebp
  801508:	57                   	push   %edi
  801509:	56                   	push   %esi
  80150a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80150b:	8b 55 08             	mov    0x8(%ebp),%edx
  80150e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801511:	b8 0c 00 00 00       	mov    $0xc,%eax
  801516:	be 00 00 00 00       	mov    $0x0,%esi
  80151b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80151e:	8b 7d 14             	mov    0x14(%ebp),%edi
  801521:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801523:	5b                   	pop    %ebx
  801524:	5e                   	pop    %esi
  801525:	5f                   	pop    %edi
  801526:	5d                   	pop    %ebp
  801527:	c3                   	ret    

00801528 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801528:	55                   	push   %ebp
  801529:	89 e5                	mov    %esp,%ebp
  80152b:	57                   	push   %edi
  80152c:	56                   	push   %esi
  80152d:	53                   	push   %ebx
  80152e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801531:	b9 00 00 00 00       	mov    $0x0,%ecx
  801536:	8b 55 08             	mov    0x8(%ebp),%edx
  801539:	b8 0d 00 00 00       	mov    $0xd,%eax
  80153e:	89 cb                	mov    %ecx,%ebx
  801540:	89 cf                	mov    %ecx,%edi
  801542:	89 ce                	mov    %ecx,%esi
  801544:	cd 30                	int    $0x30
	if(check && ret > 0)
  801546:	85 c0                	test   %eax,%eax
  801548:	7f 08                	jg     801552 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80154a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80154d:	5b                   	pop    %ebx
  80154e:	5e                   	pop    %esi
  80154f:	5f                   	pop    %edi
  801550:	5d                   	pop    %ebp
  801551:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801552:	83 ec 0c             	sub    $0xc,%esp
  801555:	50                   	push   %eax
  801556:	6a 0d                	push   $0xd
  801558:	68 28 33 80 00       	push   $0x803328
  80155d:	6a 43                	push   $0x43
  80155f:	68 45 33 80 00       	push   $0x803345
  801564:	e8 c8 f1 ff ff       	call   800731 <_panic>

00801569 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801569:	55                   	push   %ebp
  80156a:	89 e5                	mov    %esp,%ebp
  80156c:	57                   	push   %edi
  80156d:	56                   	push   %esi
  80156e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80156f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801574:	8b 55 08             	mov    0x8(%ebp),%edx
  801577:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80157a:	b8 0e 00 00 00       	mov    $0xe,%eax
  80157f:	89 df                	mov    %ebx,%edi
  801581:	89 de                	mov    %ebx,%esi
  801583:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801585:	5b                   	pop    %ebx
  801586:	5e                   	pop    %esi
  801587:	5f                   	pop    %edi
  801588:	5d                   	pop    %ebp
  801589:	c3                   	ret    

0080158a <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  80158a:	55                   	push   %ebp
  80158b:	89 e5                	mov    %esp,%ebp
  80158d:	57                   	push   %edi
  80158e:	56                   	push   %esi
  80158f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801590:	b9 00 00 00 00       	mov    $0x0,%ecx
  801595:	8b 55 08             	mov    0x8(%ebp),%edx
  801598:	b8 0f 00 00 00       	mov    $0xf,%eax
  80159d:	89 cb                	mov    %ecx,%ebx
  80159f:	89 cf                	mov    %ecx,%edi
  8015a1:	89 ce                	mov    %ecx,%esi
  8015a3:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8015a5:	5b                   	pop    %ebx
  8015a6:	5e                   	pop    %esi
  8015a7:	5f                   	pop    %edi
  8015a8:	5d                   	pop    %ebp
  8015a9:	c3                   	ret    

008015aa <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8015aa:	55                   	push   %ebp
  8015ab:	89 e5                	mov    %esp,%ebp
  8015ad:	57                   	push   %edi
  8015ae:	56                   	push   %esi
  8015af:	53                   	push   %ebx
	asm volatile("int %1\n"
  8015b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8015b5:	b8 10 00 00 00       	mov    $0x10,%eax
  8015ba:	89 d1                	mov    %edx,%ecx
  8015bc:	89 d3                	mov    %edx,%ebx
  8015be:	89 d7                	mov    %edx,%edi
  8015c0:	89 d6                	mov    %edx,%esi
  8015c2:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8015c4:	5b                   	pop    %ebx
  8015c5:	5e                   	pop    %esi
  8015c6:	5f                   	pop    %edi
  8015c7:	5d                   	pop    %ebp
  8015c8:	c3                   	ret    

008015c9 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  8015c9:	55                   	push   %ebp
  8015ca:	89 e5                	mov    %esp,%ebp
  8015cc:	57                   	push   %edi
  8015cd:	56                   	push   %esi
  8015ce:	53                   	push   %ebx
	asm volatile("int %1\n"
  8015cf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8015d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015da:	b8 11 00 00 00       	mov    $0x11,%eax
  8015df:	89 df                	mov    %ebx,%edi
  8015e1:	89 de                	mov    %ebx,%esi
  8015e3:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8015e5:	5b                   	pop    %ebx
  8015e6:	5e                   	pop    %esi
  8015e7:	5f                   	pop    %edi
  8015e8:	5d                   	pop    %ebp
  8015e9:	c3                   	ret    

008015ea <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  8015ea:	55                   	push   %ebp
  8015eb:	89 e5                	mov    %esp,%ebp
  8015ed:	57                   	push   %edi
  8015ee:	56                   	push   %esi
  8015ef:	53                   	push   %ebx
	asm volatile("int %1\n"
  8015f0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8015f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015fb:	b8 12 00 00 00       	mov    $0x12,%eax
  801600:	89 df                	mov    %ebx,%edi
  801602:	89 de                	mov    %ebx,%esi
  801604:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801606:	5b                   	pop    %ebx
  801607:	5e                   	pop    %esi
  801608:	5f                   	pop    %edi
  801609:	5d                   	pop    %ebp
  80160a:	c3                   	ret    

0080160b <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  80160b:	55                   	push   %ebp
  80160c:	89 e5                	mov    %esp,%ebp
  80160e:	57                   	push   %edi
  80160f:	56                   	push   %esi
  801610:	53                   	push   %ebx
  801611:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801614:	bb 00 00 00 00       	mov    $0x0,%ebx
  801619:	8b 55 08             	mov    0x8(%ebp),%edx
  80161c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80161f:	b8 13 00 00 00       	mov    $0x13,%eax
  801624:	89 df                	mov    %ebx,%edi
  801626:	89 de                	mov    %ebx,%esi
  801628:	cd 30                	int    $0x30
	if(check && ret > 0)
  80162a:	85 c0                	test   %eax,%eax
  80162c:	7f 08                	jg     801636 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80162e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801631:	5b                   	pop    %ebx
  801632:	5e                   	pop    %esi
  801633:	5f                   	pop    %edi
  801634:	5d                   	pop    %ebp
  801635:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801636:	83 ec 0c             	sub    $0xc,%esp
  801639:	50                   	push   %eax
  80163a:	6a 13                	push   $0x13
  80163c:	68 28 33 80 00       	push   $0x803328
  801641:	6a 43                	push   $0x43
  801643:	68 45 33 80 00       	push   $0x803345
  801648:	e8 e4 f0 ff ff       	call   800731 <_panic>

0080164d <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  80164d:	55                   	push   %ebp
  80164e:	89 e5                	mov    %esp,%ebp
  801650:	57                   	push   %edi
  801651:	56                   	push   %esi
  801652:	53                   	push   %ebx
	asm volatile("int %1\n"
  801653:	b9 00 00 00 00       	mov    $0x0,%ecx
  801658:	8b 55 08             	mov    0x8(%ebp),%edx
  80165b:	b8 14 00 00 00       	mov    $0x14,%eax
  801660:	89 cb                	mov    %ecx,%ebx
  801662:	89 cf                	mov    %ecx,%edi
  801664:	89 ce                	mov    %ecx,%esi
  801666:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801668:	5b                   	pop    %ebx
  801669:	5e                   	pop    %esi
  80166a:	5f                   	pop    %edi
  80166b:	5d                   	pop    %ebp
  80166c:	c3                   	ret    

0080166d <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80166d:	55                   	push   %ebp
  80166e:	89 e5                	mov    %esp,%ebp
  801670:	56                   	push   %esi
  801671:	53                   	push   %ebx
  801672:	8b 75 08             	mov    0x8(%ebp),%esi
  801675:	8b 45 0c             	mov    0xc(%ebp),%eax
  801678:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  80167b:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80167d:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801682:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  801685:	83 ec 0c             	sub    $0xc,%esp
  801688:	50                   	push   %eax
  801689:	e8 9a fe ff ff       	call   801528 <sys_ipc_recv>
	if(ret < 0){
  80168e:	83 c4 10             	add    $0x10,%esp
  801691:	85 c0                	test   %eax,%eax
  801693:	78 2b                	js     8016c0 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  801695:	85 f6                	test   %esi,%esi
  801697:	74 0a                	je     8016a3 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  801699:	a1 08 50 80 00       	mov    0x805008,%eax
  80169e:	8b 40 78             	mov    0x78(%eax),%eax
  8016a1:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8016a3:	85 db                	test   %ebx,%ebx
  8016a5:	74 0a                	je     8016b1 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8016a7:	a1 08 50 80 00       	mov    0x805008,%eax
  8016ac:	8b 40 7c             	mov    0x7c(%eax),%eax
  8016af:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8016b1:	a1 08 50 80 00       	mov    0x805008,%eax
  8016b6:	8b 40 74             	mov    0x74(%eax),%eax
}
  8016b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016bc:	5b                   	pop    %ebx
  8016bd:	5e                   	pop    %esi
  8016be:	5d                   	pop    %ebp
  8016bf:	c3                   	ret    
		if(from_env_store)
  8016c0:	85 f6                	test   %esi,%esi
  8016c2:	74 06                	je     8016ca <ipc_recv+0x5d>
			*from_env_store = 0;
  8016c4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8016ca:	85 db                	test   %ebx,%ebx
  8016cc:	74 eb                	je     8016b9 <ipc_recv+0x4c>
			*perm_store = 0;
  8016ce:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8016d4:	eb e3                	jmp    8016b9 <ipc_recv+0x4c>

008016d6 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8016d6:	55                   	push   %ebp
  8016d7:	89 e5                	mov    %esp,%ebp
  8016d9:	57                   	push   %edi
  8016da:	56                   	push   %esi
  8016db:	53                   	push   %ebx
  8016dc:	83 ec 0c             	sub    $0xc,%esp
  8016df:	8b 7d 08             	mov    0x8(%ebp),%edi
  8016e2:	8b 75 0c             	mov    0xc(%ebp),%esi
  8016e5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8016e8:	85 db                	test   %ebx,%ebx
  8016ea:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8016ef:	0f 44 d8             	cmove  %eax,%ebx
  8016f2:	eb 05                	jmp    8016f9 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8016f4:	e8 60 fc ff ff       	call   801359 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8016f9:	ff 75 14             	pushl  0x14(%ebp)
  8016fc:	53                   	push   %ebx
  8016fd:	56                   	push   %esi
  8016fe:	57                   	push   %edi
  8016ff:	e8 01 fe ff ff       	call   801505 <sys_ipc_try_send>
  801704:	83 c4 10             	add    $0x10,%esp
  801707:	85 c0                	test   %eax,%eax
  801709:	74 1b                	je     801726 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80170b:	79 e7                	jns    8016f4 <ipc_send+0x1e>
  80170d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801710:	74 e2                	je     8016f4 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  801712:	83 ec 04             	sub    $0x4,%esp
  801715:	68 53 33 80 00       	push   $0x803353
  80171a:	6a 46                	push   $0x46
  80171c:	68 68 33 80 00       	push   $0x803368
  801721:	e8 0b f0 ff ff       	call   800731 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  801726:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801729:	5b                   	pop    %ebx
  80172a:	5e                   	pop    %esi
  80172b:	5f                   	pop    %edi
  80172c:	5d                   	pop    %ebp
  80172d:	c3                   	ret    

0080172e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80172e:	55                   	push   %ebp
  80172f:	89 e5                	mov    %esp,%ebp
  801731:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801734:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801739:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  80173f:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801745:	8b 52 50             	mov    0x50(%edx),%edx
  801748:	39 ca                	cmp    %ecx,%edx
  80174a:	74 11                	je     80175d <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  80174c:	83 c0 01             	add    $0x1,%eax
  80174f:	3d 00 04 00 00       	cmp    $0x400,%eax
  801754:	75 e3                	jne    801739 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801756:	b8 00 00 00 00       	mov    $0x0,%eax
  80175b:	eb 0e                	jmp    80176b <ipc_find_env+0x3d>
			return envs[i].env_id;
  80175d:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801763:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801768:	8b 40 48             	mov    0x48(%eax),%eax
}
  80176b:	5d                   	pop    %ebp
  80176c:	c3                   	ret    

0080176d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80176d:	55                   	push   %ebp
  80176e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801770:	8b 45 08             	mov    0x8(%ebp),%eax
  801773:	05 00 00 00 30       	add    $0x30000000,%eax
  801778:	c1 e8 0c             	shr    $0xc,%eax
}
  80177b:	5d                   	pop    %ebp
  80177c:	c3                   	ret    

0080177d <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80177d:	55                   	push   %ebp
  80177e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801780:	8b 45 08             	mov    0x8(%ebp),%eax
  801783:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801788:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80178d:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801792:	5d                   	pop    %ebp
  801793:	c3                   	ret    

00801794 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801794:	55                   	push   %ebp
  801795:	89 e5                	mov    %esp,%ebp
  801797:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80179c:	89 c2                	mov    %eax,%edx
  80179e:	c1 ea 16             	shr    $0x16,%edx
  8017a1:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8017a8:	f6 c2 01             	test   $0x1,%dl
  8017ab:	74 2d                	je     8017da <fd_alloc+0x46>
  8017ad:	89 c2                	mov    %eax,%edx
  8017af:	c1 ea 0c             	shr    $0xc,%edx
  8017b2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8017b9:	f6 c2 01             	test   $0x1,%dl
  8017bc:	74 1c                	je     8017da <fd_alloc+0x46>
  8017be:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8017c3:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8017c8:	75 d2                	jne    80179c <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8017ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8017d3:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8017d8:	eb 0a                	jmp    8017e4 <fd_alloc+0x50>
			*fd_store = fd;
  8017da:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017dd:	89 01                	mov    %eax,(%ecx)
			return 0;
  8017df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017e4:	5d                   	pop    %ebp
  8017e5:	c3                   	ret    

008017e6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8017e6:	55                   	push   %ebp
  8017e7:	89 e5                	mov    %esp,%ebp
  8017e9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8017ec:	83 f8 1f             	cmp    $0x1f,%eax
  8017ef:	77 30                	ja     801821 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8017f1:	c1 e0 0c             	shl    $0xc,%eax
  8017f4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8017f9:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8017ff:	f6 c2 01             	test   $0x1,%dl
  801802:	74 24                	je     801828 <fd_lookup+0x42>
  801804:	89 c2                	mov    %eax,%edx
  801806:	c1 ea 0c             	shr    $0xc,%edx
  801809:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801810:	f6 c2 01             	test   $0x1,%dl
  801813:	74 1a                	je     80182f <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801815:	8b 55 0c             	mov    0xc(%ebp),%edx
  801818:	89 02                	mov    %eax,(%edx)
	return 0;
  80181a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80181f:	5d                   	pop    %ebp
  801820:	c3                   	ret    
		return -E_INVAL;
  801821:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801826:	eb f7                	jmp    80181f <fd_lookup+0x39>
		return -E_INVAL;
  801828:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80182d:	eb f0                	jmp    80181f <fd_lookup+0x39>
  80182f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801834:	eb e9                	jmp    80181f <fd_lookup+0x39>

00801836 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801836:	55                   	push   %ebp
  801837:	89 e5                	mov    %esp,%ebp
  801839:	83 ec 08             	sub    $0x8,%esp
  80183c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80183f:	ba 00 00 00 00       	mov    $0x0,%edx
  801844:	b8 08 40 80 00       	mov    $0x804008,%eax
		if (devtab[i]->dev_id == dev_id) {
  801849:	39 08                	cmp    %ecx,(%eax)
  80184b:	74 38                	je     801885 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80184d:	83 c2 01             	add    $0x1,%edx
  801850:	8b 04 95 f4 33 80 00 	mov    0x8033f4(,%edx,4),%eax
  801857:	85 c0                	test   %eax,%eax
  801859:	75 ee                	jne    801849 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80185b:	a1 08 50 80 00       	mov    0x805008,%eax
  801860:	8b 40 48             	mov    0x48(%eax),%eax
  801863:	83 ec 04             	sub    $0x4,%esp
  801866:	51                   	push   %ecx
  801867:	50                   	push   %eax
  801868:	68 74 33 80 00       	push   $0x803374
  80186d:	e8 b5 ef ff ff       	call   800827 <cprintf>
	*dev = 0;
  801872:	8b 45 0c             	mov    0xc(%ebp),%eax
  801875:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80187b:	83 c4 10             	add    $0x10,%esp
  80187e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801883:	c9                   	leave  
  801884:	c3                   	ret    
			*dev = devtab[i];
  801885:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801888:	89 01                	mov    %eax,(%ecx)
			return 0;
  80188a:	b8 00 00 00 00       	mov    $0x0,%eax
  80188f:	eb f2                	jmp    801883 <dev_lookup+0x4d>

00801891 <fd_close>:
{
  801891:	55                   	push   %ebp
  801892:	89 e5                	mov    %esp,%ebp
  801894:	57                   	push   %edi
  801895:	56                   	push   %esi
  801896:	53                   	push   %ebx
  801897:	83 ec 24             	sub    $0x24,%esp
  80189a:	8b 75 08             	mov    0x8(%ebp),%esi
  80189d:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8018a0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8018a3:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8018a4:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8018aa:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8018ad:	50                   	push   %eax
  8018ae:	e8 33 ff ff ff       	call   8017e6 <fd_lookup>
  8018b3:	89 c3                	mov    %eax,%ebx
  8018b5:	83 c4 10             	add    $0x10,%esp
  8018b8:	85 c0                	test   %eax,%eax
  8018ba:	78 05                	js     8018c1 <fd_close+0x30>
	    || fd != fd2)
  8018bc:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8018bf:	74 16                	je     8018d7 <fd_close+0x46>
		return (must_exist ? r : 0);
  8018c1:	89 f8                	mov    %edi,%eax
  8018c3:	84 c0                	test   %al,%al
  8018c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ca:	0f 44 d8             	cmove  %eax,%ebx
}
  8018cd:	89 d8                	mov    %ebx,%eax
  8018cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018d2:	5b                   	pop    %ebx
  8018d3:	5e                   	pop    %esi
  8018d4:	5f                   	pop    %edi
  8018d5:	5d                   	pop    %ebp
  8018d6:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8018d7:	83 ec 08             	sub    $0x8,%esp
  8018da:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8018dd:	50                   	push   %eax
  8018de:	ff 36                	pushl  (%esi)
  8018e0:	e8 51 ff ff ff       	call   801836 <dev_lookup>
  8018e5:	89 c3                	mov    %eax,%ebx
  8018e7:	83 c4 10             	add    $0x10,%esp
  8018ea:	85 c0                	test   %eax,%eax
  8018ec:	78 1a                	js     801908 <fd_close+0x77>
		if (dev->dev_close)
  8018ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018f1:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8018f4:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8018f9:	85 c0                	test   %eax,%eax
  8018fb:	74 0b                	je     801908 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8018fd:	83 ec 0c             	sub    $0xc,%esp
  801900:	56                   	push   %esi
  801901:	ff d0                	call   *%eax
  801903:	89 c3                	mov    %eax,%ebx
  801905:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801908:	83 ec 08             	sub    $0x8,%esp
  80190b:	56                   	push   %esi
  80190c:	6a 00                	push   $0x0
  80190e:	e8 ea fa ff ff       	call   8013fd <sys_page_unmap>
	return r;
  801913:	83 c4 10             	add    $0x10,%esp
  801916:	eb b5                	jmp    8018cd <fd_close+0x3c>

00801918 <close>:

int
close(int fdnum)
{
  801918:	55                   	push   %ebp
  801919:	89 e5                	mov    %esp,%ebp
  80191b:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80191e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801921:	50                   	push   %eax
  801922:	ff 75 08             	pushl  0x8(%ebp)
  801925:	e8 bc fe ff ff       	call   8017e6 <fd_lookup>
  80192a:	83 c4 10             	add    $0x10,%esp
  80192d:	85 c0                	test   %eax,%eax
  80192f:	79 02                	jns    801933 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801931:	c9                   	leave  
  801932:	c3                   	ret    
		return fd_close(fd, 1);
  801933:	83 ec 08             	sub    $0x8,%esp
  801936:	6a 01                	push   $0x1
  801938:	ff 75 f4             	pushl  -0xc(%ebp)
  80193b:	e8 51 ff ff ff       	call   801891 <fd_close>
  801940:	83 c4 10             	add    $0x10,%esp
  801943:	eb ec                	jmp    801931 <close+0x19>

00801945 <close_all>:

void
close_all(void)
{
  801945:	55                   	push   %ebp
  801946:	89 e5                	mov    %esp,%ebp
  801948:	53                   	push   %ebx
  801949:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80194c:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801951:	83 ec 0c             	sub    $0xc,%esp
  801954:	53                   	push   %ebx
  801955:	e8 be ff ff ff       	call   801918 <close>
	for (i = 0; i < MAXFD; i++)
  80195a:	83 c3 01             	add    $0x1,%ebx
  80195d:	83 c4 10             	add    $0x10,%esp
  801960:	83 fb 20             	cmp    $0x20,%ebx
  801963:	75 ec                	jne    801951 <close_all+0xc>
}
  801965:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801968:	c9                   	leave  
  801969:	c3                   	ret    

0080196a <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80196a:	55                   	push   %ebp
  80196b:	89 e5                	mov    %esp,%ebp
  80196d:	57                   	push   %edi
  80196e:	56                   	push   %esi
  80196f:	53                   	push   %ebx
  801970:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801973:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801976:	50                   	push   %eax
  801977:	ff 75 08             	pushl  0x8(%ebp)
  80197a:	e8 67 fe ff ff       	call   8017e6 <fd_lookup>
  80197f:	89 c3                	mov    %eax,%ebx
  801981:	83 c4 10             	add    $0x10,%esp
  801984:	85 c0                	test   %eax,%eax
  801986:	0f 88 81 00 00 00    	js     801a0d <dup+0xa3>
		return r;
	close(newfdnum);
  80198c:	83 ec 0c             	sub    $0xc,%esp
  80198f:	ff 75 0c             	pushl  0xc(%ebp)
  801992:	e8 81 ff ff ff       	call   801918 <close>

	newfd = INDEX2FD(newfdnum);
  801997:	8b 75 0c             	mov    0xc(%ebp),%esi
  80199a:	c1 e6 0c             	shl    $0xc,%esi
  80199d:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8019a3:	83 c4 04             	add    $0x4,%esp
  8019a6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8019a9:	e8 cf fd ff ff       	call   80177d <fd2data>
  8019ae:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8019b0:	89 34 24             	mov    %esi,(%esp)
  8019b3:	e8 c5 fd ff ff       	call   80177d <fd2data>
  8019b8:	83 c4 10             	add    $0x10,%esp
  8019bb:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8019bd:	89 d8                	mov    %ebx,%eax
  8019bf:	c1 e8 16             	shr    $0x16,%eax
  8019c2:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8019c9:	a8 01                	test   $0x1,%al
  8019cb:	74 11                	je     8019de <dup+0x74>
  8019cd:	89 d8                	mov    %ebx,%eax
  8019cf:	c1 e8 0c             	shr    $0xc,%eax
  8019d2:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8019d9:	f6 c2 01             	test   $0x1,%dl
  8019dc:	75 39                	jne    801a17 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8019de:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8019e1:	89 d0                	mov    %edx,%eax
  8019e3:	c1 e8 0c             	shr    $0xc,%eax
  8019e6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8019ed:	83 ec 0c             	sub    $0xc,%esp
  8019f0:	25 07 0e 00 00       	and    $0xe07,%eax
  8019f5:	50                   	push   %eax
  8019f6:	56                   	push   %esi
  8019f7:	6a 00                	push   $0x0
  8019f9:	52                   	push   %edx
  8019fa:	6a 00                	push   $0x0
  8019fc:	e8 ba f9 ff ff       	call   8013bb <sys_page_map>
  801a01:	89 c3                	mov    %eax,%ebx
  801a03:	83 c4 20             	add    $0x20,%esp
  801a06:	85 c0                	test   %eax,%eax
  801a08:	78 31                	js     801a3b <dup+0xd1>
		goto err;

	return newfdnum;
  801a0a:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801a0d:	89 d8                	mov    %ebx,%eax
  801a0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a12:	5b                   	pop    %ebx
  801a13:	5e                   	pop    %esi
  801a14:	5f                   	pop    %edi
  801a15:	5d                   	pop    %ebp
  801a16:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801a17:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a1e:	83 ec 0c             	sub    $0xc,%esp
  801a21:	25 07 0e 00 00       	and    $0xe07,%eax
  801a26:	50                   	push   %eax
  801a27:	57                   	push   %edi
  801a28:	6a 00                	push   $0x0
  801a2a:	53                   	push   %ebx
  801a2b:	6a 00                	push   $0x0
  801a2d:	e8 89 f9 ff ff       	call   8013bb <sys_page_map>
  801a32:	89 c3                	mov    %eax,%ebx
  801a34:	83 c4 20             	add    $0x20,%esp
  801a37:	85 c0                	test   %eax,%eax
  801a39:	79 a3                	jns    8019de <dup+0x74>
	sys_page_unmap(0, newfd);
  801a3b:	83 ec 08             	sub    $0x8,%esp
  801a3e:	56                   	push   %esi
  801a3f:	6a 00                	push   $0x0
  801a41:	e8 b7 f9 ff ff       	call   8013fd <sys_page_unmap>
	sys_page_unmap(0, nva);
  801a46:	83 c4 08             	add    $0x8,%esp
  801a49:	57                   	push   %edi
  801a4a:	6a 00                	push   $0x0
  801a4c:	e8 ac f9 ff ff       	call   8013fd <sys_page_unmap>
	return r;
  801a51:	83 c4 10             	add    $0x10,%esp
  801a54:	eb b7                	jmp    801a0d <dup+0xa3>

00801a56 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
  801a59:	53                   	push   %ebx
  801a5a:	83 ec 1c             	sub    $0x1c,%esp
  801a5d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a60:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a63:	50                   	push   %eax
  801a64:	53                   	push   %ebx
  801a65:	e8 7c fd ff ff       	call   8017e6 <fd_lookup>
  801a6a:	83 c4 10             	add    $0x10,%esp
  801a6d:	85 c0                	test   %eax,%eax
  801a6f:	78 3f                	js     801ab0 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a71:	83 ec 08             	sub    $0x8,%esp
  801a74:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a77:	50                   	push   %eax
  801a78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a7b:	ff 30                	pushl  (%eax)
  801a7d:	e8 b4 fd ff ff       	call   801836 <dev_lookup>
  801a82:	83 c4 10             	add    $0x10,%esp
  801a85:	85 c0                	test   %eax,%eax
  801a87:	78 27                	js     801ab0 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801a89:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a8c:	8b 42 08             	mov    0x8(%edx),%eax
  801a8f:	83 e0 03             	and    $0x3,%eax
  801a92:	83 f8 01             	cmp    $0x1,%eax
  801a95:	74 1e                	je     801ab5 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801a97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a9a:	8b 40 08             	mov    0x8(%eax),%eax
  801a9d:	85 c0                	test   %eax,%eax
  801a9f:	74 35                	je     801ad6 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801aa1:	83 ec 04             	sub    $0x4,%esp
  801aa4:	ff 75 10             	pushl  0x10(%ebp)
  801aa7:	ff 75 0c             	pushl  0xc(%ebp)
  801aaa:	52                   	push   %edx
  801aab:	ff d0                	call   *%eax
  801aad:	83 c4 10             	add    $0x10,%esp
}
  801ab0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ab3:	c9                   	leave  
  801ab4:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801ab5:	a1 08 50 80 00       	mov    0x805008,%eax
  801aba:	8b 40 48             	mov    0x48(%eax),%eax
  801abd:	83 ec 04             	sub    $0x4,%esp
  801ac0:	53                   	push   %ebx
  801ac1:	50                   	push   %eax
  801ac2:	68 b8 33 80 00       	push   $0x8033b8
  801ac7:	e8 5b ed ff ff       	call   800827 <cprintf>
		return -E_INVAL;
  801acc:	83 c4 10             	add    $0x10,%esp
  801acf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ad4:	eb da                	jmp    801ab0 <read+0x5a>
		return -E_NOT_SUPP;
  801ad6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801adb:	eb d3                	jmp    801ab0 <read+0x5a>

00801add <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801add:	55                   	push   %ebp
  801ade:	89 e5                	mov    %esp,%ebp
  801ae0:	57                   	push   %edi
  801ae1:	56                   	push   %esi
  801ae2:	53                   	push   %ebx
  801ae3:	83 ec 0c             	sub    $0xc,%esp
  801ae6:	8b 7d 08             	mov    0x8(%ebp),%edi
  801ae9:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801aec:	bb 00 00 00 00       	mov    $0x0,%ebx
  801af1:	39 f3                	cmp    %esi,%ebx
  801af3:	73 23                	jae    801b18 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801af5:	83 ec 04             	sub    $0x4,%esp
  801af8:	89 f0                	mov    %esi,%eax
  801afa:	29 d8                	sub    %ebx,%eax
  801afc:	50                   	push   %eax
  801afd:	89 d8                	mov    %ebx,%eax
  801aff:	03 45 0c             	add    0xc(%ebp),%eax
  801b02:	50                   	push   %eax
  801b03:	57                   	push   %edi
  801b04:	e8 4d ff ff ff       	call   801a56 <read>
		if (m < 0)
  801b09:	83 c4 10             	add    $0x10,%esp
  801b0c:	85 c0                	test   %eax,%eax
  801b0e:	78 06                	js     801b16 <readn+0x39>
			return m;
		if (m == 0)
  801b10:	74 06                	je     801b18 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801b12:	01 c3                	add    %eax,%ebx
  801b14:	eb db                	jmp    801af1 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801b16:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801b18:	89 d8                	mov    %ebx,%eax
  801b1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b1d:	5b                   	pop    %ebx
  801b1e:	5e                   	pop    %esi
  801b1f:	5f                   	pop    %edi
  801b20:	5d                   	pop    %ebp
  801b21:	c3                   	ret    

00801b22 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801b22:	55                   	push   %ebp
  801b23:	89 e5                	mov    %esp,%ebp
  801b25:	53                   	push   %ebx
  801b26:	83 ec 1c             	sub    $0x1c,%esp
  801b29:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b2c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b2f:	50                   	push   %eax
  801b30:	53                   	push   %ebx
  801b31:	e8 b0 fc ff ff       	call   8017e6 <fd_lookup>
  801b36:	83 c4 10             	add    $0x10,%esp
  801b39:	85 c0                	test   %eax,%eax
  801b3b:	78 3a                	js     801b77 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b3d:	83 ec 08             	sub    $0x8,%esp
  801b40:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b43:	50                   	push   %eax
  801b44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b47:	ff 30                	pushl  (%eax)
  801b49:	e8 e8 fc ff ff       	call   801836 <dev_lookup>
  801b4e:	83 c4 10             	add    $0x10,%esp
  801b51:	85 c0                	test   %eax,%eax
  801b53:	78 22                	js     801b77 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b58:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b5c:	74 1e                	je     801b7c <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801b5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b61:	8b 52 0c             	mov    0xc(%edx),%edx
  801b64:	85 d2                	test   %edx,%edx
  801b66:	74 35                	je     801b9d <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801b68:	83 ec 04             	sub    $0x4,%esp
  801b6b:	ff 75 10             	pushl  0x10(%ebp)
  801b6e:	ff 75 0c             	pushl  0xc(%ebp)
  801b71:	50                   	push   %eax
  801b72:	ff d2                	call   *%edx
  801b74:	83 c4 10             	add    $0x10,%esp
}
  801b77:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b7a:	c9                   	leave  
  801b7b:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801b7c:	a1 08 50 80 00       	mov    0x805008,%eax
  801b81:	8b 40 48             	mov    0x48(%eax),%eax
  801b84:	83 ec 04             	sub    $0x4,%esp
  801b87:	53                   	push   %ebx
  801b88:	50                   	push   %eax
  801b89:	68 d4 33 80 00       	push   $0x8033d4
  801b8e:	e8 94 ec ff ff       	call   800827 <cprintf>
		return -E_INVAL;
  801b93:	83 c4 10             	add    $0x10,%esp
  801b96:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b9b:	eb da                	jmp    801b77 <write+0x55>
		return -E_NOT_SUPP;
  801b9d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ba2:	eb d3                	jmp    801b77 <write+0x55>

00801ba4 <seek>:

int
seek(int fdnum, off_t offset)
{
  801ba4:	55                   	push   %ebp
  801ba5:	89 e5                	mov    %esp,%ebp
  801ba7:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801baa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bad:	50                   	push   %eax
  801bae:	ff 75 08             	pushl  0x8(%ebp)
  801bb1:	e8 30 fc ff ff       	call   8017e6 <fd_lookup>
  801bb6:	83 c4 10             	add    $0x10,%esp
  801bb9:	85 c0                	test   %eax,%eax
  801bbb:	78 0e                	js     801bcb <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801bbd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bc3:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801bc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bcb:	c9                   	leave  
  801bcc:	c3                   	ret    

00801bcd <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801bcd:	55                   	push   %ebp
  801bce:	89 e5                	mov    %esp,%ebp
  801bd0:	53                   	push   %ebx
  801bd1:	83 ec 1c             	sub    $0x1c,%esp
  801bd4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801bd7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bda:	50                   	push   %eax
  801bdb:	53                   	push   %ebx
  801bdc:	e8 05 fc ff ff       	call   8017e6 <fd_lookup>
  801be1:	83 c4 10             	add    $0x10,%esp
  801be4:	85 c0                	test   %eax,%eax
  801be6:	78 37                	js     801c1f <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801be8:	83 ec 08             	sub    $0x8,%esp
  801beb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bee:	50                   	push   %eax
  801bef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bf2:	ff 30                	pushl  (%eax)
  801bf4:	e8 3d fc ff ff       	call   801836 <dev_lookup>
  801bf9:	83 c4 10             	add    $0x10,%esp
  801bfc:	85 c0                	test   %eax,%eax
  801bfe:	78 1f                	js     801c1f <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c03:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801c07:	74 1b                	je     801c24 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801c09:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c0c:	8b 52 18             	mov    0x18(%edx),%edx
  801c0f:	85 d2                	test   %edx,%edx
  801c11:	74 32                	je     801c45 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801c13:	83 ec 08             	sub    $0x8,%esp
  801c16:	ff 75 0c             	pushl  0xc(%ebp)
  801c19:	50                   	push   %eax
  801c1a:	ff d2                	call   *%edx
  801c1c:	83 c4 10             	add    $0x10,%esp
}
  801c1f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c22:	c9                   	leave  
  801c23:	c3                   	ret    
			thisenv->env_id, fdnum);
  801c24:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801c29:	8b 40 48             	mov    0x48(%eax),%eax
  801c2c:	83 ec 04             	sub    $0x4,%esp
  801c2f:	53                   	push   %ebx
  801c30:	50                   	push   %eax
  801c31:	68 94 33 80 00       	push   $0x803394
  801c36:	e8 ec eb ff ff       	call   800827 <cprintf>
		return -E_INVAL;
  801c3b:	83 c4 10             	add    $0x10,%esp
  801c3e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c43:	eb da                	jmp    801c1f <ftruncate+0x52>
		return -E_NOT_SUPP;
  801c45:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c4a:	eb d3                	jmp    801c1f <ftruncate+0x52>

00801c4c <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801c4c:	55                   	push   %ebp
  801c4d:	89 e5                	mov    %esp,%ebp
  801c4f:	53                   	push   %ebx
  801c50:	83 ec 1c             	sub    $0x1c,%esp
  801c53:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c56:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c59:	50                   	push   %eax
  801c5a:	ff 75 08             	pushl  0x8(%ebp)
  801c5d:	e8 84 fb ff ff       	call   8017e6 <fd_lookup>
  801c62:	83 c4 10             	add    $0x10,%esp
  801c65:	85 c0                	test   %eax,%eax
  801c67:	78 4b                	js     801cb4 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c69:	83 ec 08             	sub    $0x8,%esp
  801c6c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c6f:	50                   	push   %eax
  801c70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c73:	ff 30                	pushl  (%eax)
  801c75:	e8 bc fb ff ff       	call   801836 <dev_lookup>
  801c7a:	83 c4 10             	add    $0x10,%esp
  801c7d:	85 c0                	test   %eax,%eax
  801c7f:	78 33                	js     801cb4 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c84:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801c88:	74 2f                	je     801cb9 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801c8a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801c8d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801c94:	00 00 00 
	stat->st_isdir = 0;
  801c97:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c9e:	00 00 00 
	stat->st_dev = dev;
  801ca1:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801ca7:	83 ec 08             	sub    $0x8,%esp
  801caa:	53                   	push   %ebx
  801cab:	ff 75 f0             	pushl  -0x10(%ebp)
  801cae:	ff 50 14             	call   *0x14(%eax)
  801cb1:	83 c4 10             	add    $0x10,%esp
}
  801cb4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cb7:	c9                   	leave  
  801cb8:	c3                   	ret    
		return -E_NOT_SUPP;
  801cb9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801cbe:	eb f4                	jmp    801cb4 <fstat+0x68>

00801cc0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801cc0:	55                   	push   %ebp
  801cc1:	89 e5                	mov    %esp,%ebp
  801cc3:	56                   	push   %esi
  801cc4:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801cc5:	83 ec 08             	sub    $0x8,%esp
  801cc8:	6a 00                	push   $0x0
  801cca:	ff 75 08             	pushl  0x8(%ebp)
  801ccd:	e8 22 02 00 00       	call   801ef4 <open>
  801cd2:	89 c3                	mov    %eax,%ebx
  801cd4:	83 c4 10             	add    $0x10,%esp
  801cd7:	85 c0                	test   %eax,%eax
  801cd9:	78 1b                	js     801cf6 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801cdb:	83 ec 08             	sub    $0x8,%esp
  801cde:	ff 75 0c             	pushl  0xc(%ebp)
  801ce1:	50                   	push   %eax
  801ce2:	e8 65 ff ff ff       	call   801c4c <fstat>
  801ce7:	89 c6                	mov    %eax,%esi
	close(fd);
  801ce9:	89 1c 24             	mov    %ebx,(%esp)
  801cec:	e8 27 fc ff ff       	call   801918 <close>
	return r;
  801cf1:	83 c4 10             	add    $0x10,%esp
  801cf4:	89 f3                	mov    %esi,%ebx
}
  801cf6:	89 d8                	mov    %ebx,%eax
  801cf8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cfb:	5b                   	pop    %ebx
  801cfc:	5e                   	pop    %esi
  801cfd:	5d                   	pop    %ebp
  801cfe:	c3                   	ret    

00801cff <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801cff:	55                   	push   %ebp
  801d00:	89 e5                	mov    %esp,%ebp
  801d02:	56                   	push   %esi
  801d03:	53                   	push   %ebx
  801d04:	89 c6                	mov    %eax,%esi
  801d06:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801d08:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801d0f:	74 27                	je     801d38 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801d11:	6a 07                	push   $0x7
  801d13:	68 00 60 80 00       	push   $0x806000
  801d18:	56                   	push   %esi
  801d19:	ff 35 00 50 80 00    	pushl  0x805000
  801d1f:	e8 b2 f9 ff ff       	call   8016d6 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801d24:	83 c4 0c             	add    $0xc,%esp
  801d27:	6a 00                	push   $0x0
  801d29:	53                   	push   %ebx
  801d2a:	6a 00                	push   $0x0
  801d2c:	e8 3c f9 ff ff       	call   80166d <ipc_recv>
}
  801d31:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d34:	5b                   	pop    %ebx
  801d35:	5e                   	pop    %esi
  801d36:	5d                   	pop    %ebp
  801d37:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801d38:	83 ec 0c             	sub    $0xc,%esp
  801d3b:	6a 01                	push   $0x1
  801d3d:	e8 ec f9 ff ff       	call   80172e <ipc_find_env>
  801d42:	a3 00 50 80 00       	mov    %eax,0x805000
  801d47:	83 c4 10             	add    $0x10,%esp
  801d4a:	eb c5                	jmp    801d11 <fsipc+0x12>

00801d4c <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801d4c:	55                   	push   %ebp
  801d4d:	89 e5                	mov    %esp,%ebp
  801d4f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801d52:	8b 45 08             	mov    0x8(%ebp),%eax
  801d55:	8b 40 0c             	mov    0xc(%eax),%eax
  801d58:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801d5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d60:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801d65:	ba 00 00 00 00       	mov    $0x0,%edx
  801d6a:	b8 02 00 00 00       	mov    $0x2,%eax
  801d6f:	e8 8b ff ff ff       	call   801cff <fsipc>
}
  801d74:	c9                   	leave  
  801d75:	c3                   	ret    

00801d76 <devfile_flush>:
{
  801d76:	55                   	push   %ebp
  801d77:	89 e5                	mov    %esp,%ebp
  801d79:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7f:	8b 40 0c             	mov    0xc(%eax),%eax
  801d82:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801d87:	ba 00 00 00 00       	mov    $0x0,%edx
  801d8c:	b8 06 00 00 00       	mov    $0x6,%eax
  801d91:	e8 69 ff ff ff       	call   801cff <fsipc>
}
  801d96:	c9                   	leave  
  801d97:	c3                   	ret    

00801d98 <devfile_stat>:
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
  801d9b:	53                   	push   %ebx
  801d9c:	83 ec 04             	sub    $0x4,%esp
  801d9f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801da2:	8b 45 08             	mov    0x8(%ebp),%eax
  801da5:	8b 40 0c             	mov    0xc(%eax),%eax
  801da8:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801dad:	ba 00 00 00 00       	mov    $0x0,%edx
  801db2:	b8 05 00 00 00       	mov    $0x5,%eax
  801db7:	e8 43 ff ff ff       	call   801cff <fsipc>
  801dbc:	85 c0                	test   %eax,%eax
  801dbe:	78 2c                	js     801dec <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801dc0:	83 ec 08             	sub    $0x8,%esp
  801dc3:	68 00 60 80 00       	push   $0x806000
  801dc8:	53                   	push   %ebx
  801dc9:	e8 b8 f1 ff ff       	call   800f86 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801dce:	a1 80 60 80 00       	mov    0x806080,%eax
  801dd3:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801dd9:	a1 84 60 80 00       	mov    0x806084,%eax
  801dde:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801de4:	83 c4 10             	add    $0x10,%esp
  801de7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801def:	c9                   	leave  
  801df0:	c3                   	ret    

00801df1 <devfile_write>:
{
  801df1:	55                   	push   %ebp
  801df2:	89 e5                	mov    %esp,%ebp
  801df4:	53                   	push   %ebx
  801df5:	83 ec 08             	sub    $0x8,%esp
  801df8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfe:	8b 40 0c             	mov    0xc(%eax),%eax
  801e01:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801e06:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801e0c:	53                   	push   %ebx
  801e0d:	ff 75 0c             	pushl  0xc(%ebp)
  801e10:	68 08 60 80 00       	push   $0x806008
  801e15:	e8 5c f3 ff ff       	call   801176 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801e1a:	ba 00 00 00 00       	mov    $0x0,%edx
  801e1f:	b8 04 00 00 00       	mov    $0x4,%eax
  801e24:	e8 d6 fe ff ff       	call   801cff <fsipc>
  801e29:	83 c4 10             	add    $0x10,%esp
  801e2c:	85 c0                	test   %eax,%eax
  801e2e:	78 0b                	js     801e3b <devfile_write+0x4a>
	assert(r <= n);
  801e30:	39 d8                	cmp    %ebx,%eax
  801e32:	77 0c                	ja     801e40 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801e34:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801e39:	7f 1e                	jg     801e59 <devfile_write+0x68>
}
  801e3b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e3e:	c9                   	leave  
  801e3f:	c3                   	ret    
	assert(r <= n);
  801e40:	68 08 34 80 00       	push   $0x803408
  801e45:	68 0f 34 80 00       	push   $0x80340f
  801e4a:	68 98 00 00 00       	push   $0x98
  801e4f:	68 24 34 80 00       	push   $0x803424
  801e54:	e8 d8 e8 ff ff       	call   800731 <_panic>
	assert(r <= PGSIZE);
  801e59:	68 2f 34 80 00       	push   $0x80342f
  801e5e:	68 0f 34 80 00       	push   $0x80340f
  801e63:	68 99 00 00 00       	push   $0x99
  801e68:	68 24 34 80 00       	push   $0x803424
  801e6d:	e8 bf e8 ff ff       	call   800731 <_panic>

00801e72 <devfile_read>:
{
  801e72:	55                   	push   %ebp
  801e73:	89 e5                	mov    %esp,%ebp
  801e75:	56                   	push   %esi
  801e76:	53                   	push   %ebx
  801e77:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7d:	8b 40 0c             	mov    0xc(%eax),%eax
  801e80:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801e85:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801e8b:	ba 00 00 00 00       	mov    $0x0,%edx
  801e90:	b8 03 00 00 00       	mov    $0x3,%eax
  801e95:	e8 65 fe ff ff       	call   801cff <fsipc>
  801e9a:	89 c3                	mov    %eax,%ebx
  801e9c:	85 c0                	test   %eax,%eax
  801e9e:	78 1f                	js     801ebf <devfile_read+0x4d>
	assert(r <= n);
  801ea0:	39 f0                	cmp    %esi,%eax
  801ea2:	77 24                	ja     801ec8 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801ea4:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ea9:	7f 33                	jg     801ede <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801eab:	83 ec 04             	sub    $0x4,%esp
  801eae:	50                   	push   %eax
  801eaf:	68 00 60 80 00       	push   $0x806000
  801eb4:	ff 75 0c             	pushl  0xc(%ebp)
  801eb7:	e8 58 f2 ff ff       	call   801114 <memmove>
	return r;
  801ebc:	83 c4 10             	add    $0x10,%esp
}
  801ebf:	89 d8                	mov    %ebx,%eax
  801ec1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ec4:	5b                   	pop    %ebx
  801ec5:	5e                   	pop    %esi
  801ec6:	5d                   	pop    %ebp
  801ec7:	c3                   	ret    
	assert(r <= n);
  801ec8:	68 08 34 80 00       	push   $0x803408
  801ecd:	68 0f 34 80 00       	push   $0x80340f
  801ed2:	6a 7c                	push   $0x7c
  801ed4:	68 24 34 80 00       	push   $0x803424
  801ed9:	e8 53 e8 ff ff       	call   800731 <_panic>
	assert(r <= PGSIZE);
  801ede:	68 2f 34 80 00       	push   $0x80342f
  801ee3:	68 0f 34 80 00       	push   $0x80340f
  801ee8:	6a 7d                	push   $0x7d
  801eea:	68 24 34 80 00       	push   $0x803424
  801eef:	e8 3d e8 ff ff       	call   800731 <_panic>

00801ef4 <open>:
{
  801ef4:	55                   	push   %ebp
  801ef5:	89 e5                	mov    %esp,%ebp
  801ef7:	56                   	push   %esi
  801ef8:	53                   	push   %ebx
  801ef9:	83 ec 1c             	sub    $0x1c,%esp
  801efc:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801eff:	56                   	push   %esi
  801f00:	e8 48 f0 ff ff       	call   800f4d <strlen>
  801f05:	83 c4 10             	add    $0x10,%esp
  801f08:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801f0d:	7f 6c                	jg     801f7b <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801f0f:	83 ec 0c             	sub    $0xc,%esp
  801f12:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f15:	50                   	push   %eax
  801f16:	e8 79 f8 ff ff       	call   801794 <fd_alloc>
  801f1b:	89 c3                	mov    %eax,%ebx
  801f1d:	83 c4 10             	add    $0x10,%esp
  801f20:	85 c0                	test   %eax,%eax
  801f22:	78 3c                	js     801f60 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801f24:	83 ec 08             	sub    $0x8,%esp
  801f27:	56                   	push   %esi
  801f28:	68 00 60 80 00       	push   $0x806000
  801f2d:	e8 54 f0 ff ff       	call   800f86 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801f32:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f35:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801f3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f3d:	b8 01 00 00 00       	mov    $0x1,%eax
  801f42:	e8 b8 fd ff ff       	call   801cff <fsipc>
  801f47:	89 c3                	mov    %eax,%ebx
  801f49:	83 c4 10             	add    $0x10,%esp
  801f4c:	85 c0                	test   %eax,%eax
  801f4e:	78 19                	js     801f69 <open+0x75>
	return fd2num(fd);
  801f50:	83 ec 0c             	sub    $0xc,%esp
  801f53:	ff 75 f4             	pushl  -0xc(%ebp)
  801f56:	e8 12 f8 ff ff       	call   80176d <fd2num>
  801f5b:	89 c3                	mov    %eax,%ebx
  801f5d:	83 c4 10             	add    $0x10,%esp
}
  801f60:	89 d8                	mov    %ebx,%eax
  801f62:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f65:	5b                   	pop    %ebx
  801f66:	5e                   	pop    %esi
  801f67:	5d                   	pop    %ebp
  801f68:	c3                   	ret    
		fd_close(fd, 0);
  801f69:	83 ec 08             	sub    $0x8,%esp
  801f6c:	6a 00                	push   $0x0
  801f6e:	ff 75 f4             	pushl  -0xc(%ebp)
  801f71:	e8 1b f9 ff ff       	call   801891 <fd_close>
		return r;
  801f76:	83 c4 10             	add    $0x10,%esp
  801f79:	eb e5                	jmp    801f60 <open+0x6c>
		return -E_BAD_PATH;
  801f7b:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801f80:	eb de                	jmp    801f60 <open+0x6c>

00801f82 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801f82:	55                   	push   %ebp
  801f83:	89 e5                	mov    %esp,%ebp
  801f85:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801f88:	ba 00 00 00 00       	mov    $0x0,%edx
  801f8d:	b8 08 00 00 00       	mov    $0x8,%eax
  801f92:	e8 68 fd ff ff       	call   801cff <fsipc>
}
  801f97:	c9                   	leave  
  801f98:	c3                   	ret    

00801f99 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801f99:	55                   	push   %ebp
  801f9a:	89 e5                	mov    %esp,%ebp
  801f9c:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801f9f:	68 3b 34 80 00       	push   $0x80343b
  801fa4:	ff 75 0c             	pushl  0xc(%ebp)
  801fa7:	e8 da ef ff ff       	call   800f86 <strcpy>
	return 0;
}
  801fac:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb1:	c9                   	leave  
  801fb2:	c3                   	ret    

00801fb3 <devsock_close>:
{
  801fb3:	55                   	push   %ebp
  801fb4:	89 e5                	mov    %esp,%ebp
  801fb6:	53                   	push   %ebx
  801fb7:	83 ec 10             	sub    $0x10,%esp
  801fba:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801fbd:	53                   	push   %ebx
  801fbe:	e8 00 09 00 00       	call   8028c3 <pageref>
  801fc3:	83 c4 10             	add    $0x10,%esp
		return 0;
  801fc6:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801fcb:	83 f8 01             	cmp    $0x1,%eax
  801fce:	74 07                	je     801fd7 <devsock_close+0x24>
}
  801fd0:	89 d0                	mov    %edx,%eax
  801fd2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fd5:	c9                   	leave  
  801fd6:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801fd7:	83 ec 0c             	sub    $0xc,%esp
  801fda:	ff 73 0c             	pushl  0xc(%ebx)
  801fdd:	e8 b9 02 00 00       	call   80229b <nsipc_close>
  801fe2:	89 c2                	mov    %eax,%edx
  801fe4:	83 c4 10             	add    $0x10,%esp
  801fe7:	eb e7                	jmp    801fd0 <devsock_close+0x1d>

00801fe9 <devsock_write>:
{
  801fe9:	55                   	push   %ebp
  801fea:	89 e5                	mov    %esp,%ebp
  801fec:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801fef:	6a 00                	push   $0x0
  801ff1:	ff 75 10             	pushl  0x10(%ebp)
  801ff4:	ff 75 0c             	pushl  0xc(%ebp)
  801ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffa:	ff 70 0c             	pushl  0xc(%eax)
  801ffd:	e8 76 03 00 00       	call   802378 <nsipc_send>
}
  802002:	c9                   	leave  
  802003:	c3                   	ret    

00802004 <devsock_read>:
{
  802004:	55                   	push   %ebp
  802005:	89 e5                	mov    %esp,%ebp
  802007:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80200a:	6a 00                	push   $0x0
  80200c:	ff 75 10             	pushl  0x10(%ebp)
  80200f:	ff 75 0c             	pushl  0xc(%ebp)
  802012:	8b 45 08             	mov    0x8(%ebp),%eax
  802015:	ff 70 0c             	pushl  0xc(%eax)
  802018:	e8 ef 02 00 00       	call   80230c <nsipc_recv>
}
  80201d:	c9                   	leave  
  80201e:	c3                   	ret    

0080201f <fd2sockid>:
{
  80201f:	55                   	push   %ebp
  802020:	89 e5                	mov    %esp,%ebp
  802022:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  802025:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802028:	52                   	push   %edx
  802029:	50                   	push   %eax
  80202a:	e8 b7 f7 ff ff       	call   8017e6 <fd_lookup>
  80202f:	83 c4 10             	add    $0x10,%esp
  802032:	85 c0                	test   %eax,%eax
  802034:	78 10                	js     802046 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  802036:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802039:	8b 0d 24 40 80 00    	mov    0x804024,%ecx
  80203f:	39 08                	cmp    %ecx,(%eax)
  802041:	75 05                	jne    802048 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  802043:	8b 40 0c             	mov    0xc(%eax),%eax
}
  802046:	c9                   	leave  
  802047:	c3                   	ret    
		return -E_NOT_SUPP;
  802048:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80204d:	eb f7                	jmp    802046 <fd2sockid+0x27>

0080204f <alloc_sockfd>:
{
  80204f:	55                   	push   %ebp
  802050:	89 e5                	mov    %esp,%ebp
  802052:	56                   	push   %esi
  802053:	53                   	push   %ebx
  802054:	83 ec 1c             	sub    $0x1c,%esp
  802057:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  802059:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80205c:	50                   	push   %eax
  80205d:	e8 32 f7 ff ff       	call   801794 <fd_alloc>
  802062:	89 c3                	mov    %eax,%ebx
  802064:	83 c4 10             	add    $0x10,%esp
  802067:	85 c0                	test   %eax,%eax
  802069:	78 43                	js     8020ae <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80206b:	83 ec 04             	sub    $0x4,%esp
  80206e:	68 07 04 00 00       	push   $0x407
  802073:	ff 75 f4             	pushl  -0xc(%ebp)
  802076:	6a 00                	push   $0x0
  802078:	e8 fb f2 ff ff       	call   801378 <sys_page_alloc>
  80207d:	89 c3                	mov    %eax,%ebx
  80207f:	83 c4 10             	add    $0x10,%esp
  802082:	85 c0                	test   %eax,%eax
  802084:	78 28                	js     8020ae <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802086:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802089:	8b 15 24 40 80 00    	mov    0x804024,%edx
  80208f:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802091:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802094:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80209b:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80209e:	83 ec 0c             	sub    $0xc,%esp
  8020a1:	50                   	push   %eax
  8020a2:	e8 c6 f6 ff ff       	call   80176d <fd2num>
  8020a7:	89 c3                	mov    %eax,%ebx
  8020a9:	83 c4 10             	add    $0x10,%esp
  8020ac:	eb 0c                	jmp    8020ba <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8020ae:	83 ec 0c             	sub    $0xc,%esp
  8020b1:	56                   	push   %esi
  8020b2:	e8 e4 01 00 00       	call   80229b <nsipc_close>
		return r;
  8020b7:	83 c4 10             	add    $0x10,%esp
}
  8020ba:	89 d8                	mov    %ebx,%eax
  8020bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020bf:	5b                   	pop    %ebx
  8020c0:	5e                   	pop    %esi
  8020c1:	5d                   	pop    %ebp
  8020c2:	c3                   	ret    

008020c3 <accept>:
{
  8020c3:	55                   	push   %ebp
  8020c4:	89 e5                	mov    %esp,%ebp
  8020c6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cc:	e8 4e ff ff ff       	call   80201f <fd2sockid>
  8020d1:	85 c0                	test   %eax,%eax
  8020d3:	78 1b                	js     8020f0 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8020d5:	83 ec 04             	sub    $0x4,%esp
  8020d8:	ff 75 10             	pushl  0x10(%ebp)
  8020db:	ff 75 0c             	pushl  0xc(%ebp)
  8020de:	50                   	push   %eax
  8020df:	e8 0e 01 00 00       	call   8021f2 <nsipc_accept>
  8020e4:	83 c4 10             	add    $0x10,%esp
  8020e7:	85 c0                	test   %eax,%eax
  8020e9:	78 05                	js     8020f0 <accept+0x2d>
	return alloc_sockfd(r);
  8020eb:	e8 5f ff ff ff       	call   80204f <alloc_sockfd>
}
  8020f0:	c9                   	leave  
  8020f1:	c3                   	ret    

008020f2 <bind>:
{
  8020f2:	55                   	push   %ebp
  8020f3:	89 e5                	mov    %esp,%ebp
  8020f5:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fb:	e8 1f ff ff ff       	call   80201f <fd2sockid>
  802100:	85 c0                	test   %eax,%eax
  802102:	78 12                	js     802116 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802104:	83 ec 04             	sub    $0x4,%esp
  802107:	ff 75 10             	pushl  0x10(%ebp)
  80210a:	ff 75 0c             	pushl  0xc(%ebp)
  80210d:	50                   	push   %eax
  80210e:	e8 31 01 00 00       	call   802244 <nsipc_bind>
  802113:	83 c4 10             	add    $0x10,%esp
}
  802116:	c9                   	leave  
  802117:	c3                   	ret    

00802118 <shutdown>:
{
  802118:	55                   	push   %ebp
  802119:	89 e5                	mov    %esp,%ebp
  80211b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80211e:	8b 45 08             	mov    0x8(%ebp),%eax
  802121:	e8 f9 fe ff ff       	call   80201f <fd2sockid>
  802126:	85 c0                	test   %eax,%eax
  802128:	78 0f                	js     802139 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80212a:	83 ec 08             	sub    $0x8,%esp
  80212d:	ff 75 0c             	pushl  0xc(%ebp)
  802130:	50                   	push   %eax
  802131:	e8 43 01 00 00       	call   802279 <nsipc_shutdown>
  802136:	83 c4 10             	add    $0x10,%esp
}
  802139:	c9                   	leave  
  80213a:	c3                   	ret    

0080213b <connect>:
{
  80213b:	55                   	push   %ebp
  80213c:	89 e5                	mov    %esp,%ebp
  80213e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802141:	8b 45 08             	mov    0x8(%ebp),%eax
  802144:	e8 d6 fe ff ff       	call   80201f <fd2sockid>
  802149:	85 c0                	test   %eax,%eax
  80214b:	78 12                	js     80215f <connect+0x24>
	return nsipc_connect(r, name, namelen);
  80214d:	83 ec 04             	sub    $0x4,%esp
  802150:	ff 75 10             	pushl  0x10(%ebp)
  802153:	ff 75 0c             	pushl  0xc(%ebp)
  802156:	50                   	push   %eax
  802157:	e8 59 01 00 00       	call   8022b5 <nsipc_connect>
  80215c:	83 c4 10             	add    $0x10,%esp
}
  80215f:	c9                   	leave  
  802160:	c3                   	ret    

00802161 <listen>:
{
  802161:	55                   	push   %ebp
  802162:	89 e5                	mov    %esp,%ebp
  802164:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802167:	8b 45 08             	mov    0x8(%ebp),%eax
  80216a:	e8 b0 fe ff ff       	call   80201f <fd2sockid>
  80216f:	85 c0                	test   %eax,%eax
  802171:	78 0f                	js     802182 <listen+0x21>
	return nsipc_listen(r, backlog);
  802173:	83 ec 08             	sub    $0x8,%esp
  802176:	ff 75 0c             	pushl  0xc(%ebp)
  802179:	50                   	push   %eax
  80217a:	e8 6b 01 00 00       	call   8022ea <nsipc_listen>
  80217f:	83 c4 10             	add    $0x10,%esp
}
  802182:	c9                   	leave  
  802183:	c3                   	ret    

00802184 <socket>:

int
socket(int domain, int type, int protocol)
{
  802184:	55                   	push   %ebp
  802185:	89 e5                	mov    %esp,%ebp
  802187:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80218a:	ff 75 10             	pushl  0x10(%ebp)
  80218d:	ff 75 0c             	pushl  0xc(%ebp)
  802190:	ff 75 08             	pushl  0x8(%ebp)
  802193:	e8 3e 02 00 00       	call   8023d6 <nsipc_socket>
  802198:	83 c4 10             	add    $0x10,%esp
  80219b:	85 c0                	test   %eax,%eax
  80219d:	78 05                	js     8021a4 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  80219f:	e8 ab fe ff ff       	call   80204f <alloc_sockfd>
}
  8021a4:	c9                   	leave  
  8021a5:	c3                   	ret    

008021a6 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8021a6:	55                   	push   %ebp
  8021a7:	89 e5                	mov    %esp,%ebp
  8021a9:	53                   	push   %ebx
  8021aa:	83 ec 04             	sub    $0x4,%esp
  8021ad:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8021af:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8021b6:	74 26                	je     8021de <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8021b8:	6a 07                	push   $0x7
  8021ba:	68 00 70 80 00       	push   $0x807000
  8021bf:	53                   	push   %ebx
  8021c0:	ff 35 04 50 80 00    	pushl  0x805004
  8021c6:	e8 0b f5 ff ff       	call   8016d6 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8021cb:	83 c4 0c             	add    $0xc,%esp
  8021ce:	6a 00                	push   $0x0
  8021d0:	6a 00                	push   $0x0
  8021d2:	6a 00                	push   $0x0
  8021d4:	e8 94 f4 ff ff       	call   80166d <ipc_recv>
}
  8021d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021dc:	c9                   	leave  
  8021dd:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8021de:	83 ec 0c             	sub    $0xc,%esp
  8021e1:	6a 02                	push   $0x2
  8021e3:	e8 46 f5 ff ff       	call   80172e <ipc_find_env>
  8021e8:	a3 04 50 80 00       	mov    %eax,0x805004
  8021ed:	83 c4 10             	add    $0x10,%esp
  8021f0:	eb c6                	jmp    8021b8 <nsipc+0x12>

008021f2 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8021f2:	55                   	push   %ebp
  8021f3:	89 e5                	mov    %esp,%ebp
  8021f5:	56                   	push   %esi
  8021f6:	53                   	push   %ebx
  8021f7:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8021fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fd:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802202:	8b 06                	mov    (%esi),%eax
  802204:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802209:	b8 01 00 00 00       	mov    $0x1,%eax
  80220e:	e8 93 ff ff ff       	call   8021a6 <nsipc>
  802213:	89 c3                	mov    %eax,%ebx
  802215:	85 c0                	test   %eax,%eax
  802217:	79 09                	jns    802222 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802219:	89 d8                	mov    %ebx,%eax
  80221b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80221e:	5b                   	pop    %ebx
  80221f:	5e                   	pop    %esi
  802220:	5d                   	pop    %ebp
  802221:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802222:	83 ec 04             	sub    $0x4,%esp
  802225:	ff 35 10 70 80 00    	pushl  0x807010
  80222b:	68 00 70 80 00       	push   $0x807000
  802230:	ff 75 0c             	pushl  0xc(%ebp)
  802233:	e8 dc ee ff ff       	call   801114 <memmove>
		*addrlen = ret->ret_addrlen;
  802238:	a1 10 70 80 00       	mov    0x807010,%eax
  80223d:	89 06                	mov    %eax,(%esi)
  80223f:	83 c4 10             	add    $0x10,%esp
	return r;
  802242:	eb d5                	jmp    802219 <nsipc_accept+0x27>

00802244 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802244:	55                   	push   %ebp
  802245:	89 e5                	mov    %esp,%ebp
  802247:	53                   	push   %ebx
  802248:	83 ec 08             	sub    $0x8,%esp
  80224b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80224e:	8b 45 08             	mov    0x8(%ebp),%eax
  802251:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802256:	53                   	push   %ebx
  802257:	ff 75 0c             	pushl  0xc(%ebp)
  80225a:	68 04 70 80 00       	push   $0x807004
  80225f:	e8 b0 ee ff ff       	call   801114 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802264:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80226a:	b8 02 00 00 00       	mov    $0x2,%eax
  80226f:	e8 32 ff ff ff       	call   8021a6 <nsipc>
}
  802274:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802277:	c9                   	leave  
  802278:	c3                   	ret    

00802279 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802279:	55                   	push   %ebp
  80227a:	89 e5                	mov    %esp,%ebp
  80227c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80227f:	8b 45 08             	mov    0x8(%ebp),%eax
  802282:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802287:	8b 45 0c             	mov    0xc(%ebp),%eax
  80228a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  80228f:	b8 03 00 00 00       	mov    $0x3,%eax
  802294:	e8 0d ff ff ff       	call   8021a6 <nsipc>
}
  802299:	c9                   	leave  
  80229a:	c3                   	ret    

0080229b <nsipc_close>:

int
nsipc_close(int s)
{
  80229b:	55                   	push   %ebp
  80229c:	89 e5                	mov    %esp,%ebp
  80229e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8022a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a4:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8022a9:	b8 04 00 00 00       	mov    $0x4,%eax
  8022ae:	e8 f3 fe ff ff       	call   8021a6 <nsipc>
}
  8022b3:	c9                   	leave  
  8022b4:	c3                   	ret    

008022b5 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8022b5:	55                   	push   %ebp
  8022b6:	89 e5                	mov    %esp,%ebp
  8022b8:	53                   	push   %ebx
  8022b9:	83 ec 08             	sub    $0x8,%esp
  8022bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8022bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c2:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8022c7:	53                   	push   %ebx
  8022c8:	ff 75 0c             	pushl  0xc(%ebp)
  8022cb:	68 04 70 80 00       	push   $0x807004
  8022d0:	e8 3f ee ff ff       	call   801114 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8022d5:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8022db:	b8 05 00 00 00       	mov    $0x5,%eax
  8022e0:	e8 c1 fe ff ff       	call   8021a6 <nsipc>
}
  8022e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022e8:	c9                   	leave  
  8022e9:	c3                   	ret    

008022ea <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8022ea:	55                   	push   %ebp
  8022eb:	89 e5                	mov    %esp,%ebp
  8022ed:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8022f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f3:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8022f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022fb:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802300:	b8 06 00 00 00       	mov    $0x6,%eax
  802305:	e8 9c fe ff ff       	call   8021a6 <nsipc>
}
  80230a:	c9                   	leave  
  80230b:	c3                   	ret    

0080230c <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80230c:	55                   	push   %ebp
  80230d:	89 e5                	mov    %esp,%ebp
  80230f:	56                   	push   %esi
  802310:	53                   	push   %ebx
  802311:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802314:	8b 45 08             	mov    0x8(%ebp),%eax
  802317:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80231c:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802322:	8b 45 14             	mov    0x14(%ebp),%eax
  802325:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80232a:	b8 07 00 00 00       	mov    $0x7,%eax
  80232f:	e8 72 fe ff ff       	call   8021a6 <nsipc>
  802334:	89 c3                	mov    %eax,%ebx
  802336:	85 c0                	test   %eax,%eax
  802338:	78 1f                	js     802359 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80233a:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80233f:	7f 21                	jg     802362 <nsipc_recv+0x56>
  802341:	39 c6                	cmp    %eax,%esi
  802343:	7c 1d                	jl     802362 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802345:	83 ec 04             	sub    $0x4,%esp
  802348:	50                   	push   %eax
  802349:	68 00 70 80 00       	push   $0x807000
  80234e:	ff 75 0c             	pushl  0xc(%ebp)
  802351:	e8 be ed ff ff       	call   801114 <memmove>
  802356:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802359:	89 d8                	mov    %ebx,%eax
  80235b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80235e:	5b                   	pop    %ebx
  80235f:	5e                   	pop    %esi
  802360:	5d                   	pop    %ebp
  802361:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802362:	68 47 34 80 00       	push   $0x803447
  802367:	68 0f 34 80 00       	push   $0x80340f
  80236c:	6a 62                	push   $0x62
  80236e:	68 5c 34 80 00       	push   $0x80345c
  802373:	e8 b9 e3 ff ff       	call   800731 <_panic>

00802378 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802378:	55                   	push   %ebp
  802379:	89 e5                	mov    %esp,%ebp
  80237b:	53                   	push   %ebx
  80237c:	83 ec 04             	sub    $0x4,%esp
  80237f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802382:	8b 45 08             	mov    0x8(%ebp),%eax
  802385:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80238a:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802390:	7f 2e                	jg     8023c0 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802392:	83 ec 04             	sub    $0x4,%esp
  802395:	53                   	push   %ebx
  802396:	ff 75 0c             	pushl  0xc(%ebp)
  802399:	68 0c 70 80 00       	push   $0x80700c
  80239e:	e8 71 ed ff ff       	call   801114 <memmove>
	nsipcbuf.send.req_size = size;
  8023a3:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8023a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8023ac:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8023b1:	b8 08 00 00 00       	mov    $0x8,%eax
  8023b6:	e8 eb fd ff ff       	call   8021a6 <nsipc>
}
  8023bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023be:	c9                   	leave  
  8023bf:	c3                   	ret    
	assert(size < 1600);
  8023c0:	68 68 34 80 00       	push   $0x803468
  8023c5:	68 0f 34 80 00       	push   $0x80340f
  8023ca:	6a 6d                	push   $0x6d
  8023cc:	68 5c 34 80 00       	push   $0x80345c
  8023d1:	e8 5b e3 ff ff       	call   800731 <_panic>

008023d6 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8023d6:	55                   	push   %ebp
  8023d7:	89 e5                	mov    %esp,%ebp
  8023d9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8023dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023df:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8023e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023e7:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8023ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8023ef:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8023f4:	b8 09 00 00 00       	mov    $0x9,%eax
  8023f9:	e8 a8 fd ff ff       	call   8021a6 <nsipc>
}
  8023fe:	c9                   	leave  
  8023ff:	c3                   	ret    

00802400 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802400:	55                   	push   %ebp
  802401:	89 e5                	mov    %esp,%ebp
  802403:	56                   	push   %esi
  802404:	53                   	push   %ebx
  802405:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802408:	83 ec 0c             	sub    $0xc,%esp
  80240b:	ff 75 08             	pushl  0x8(%ebp)
  80240e:	e8 6a f3 ff ff       	call   80177d <fd2data>
  802413:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802415:	83 c4 08             	add    $0x8,%esp
  802418:	68 74 34 80 00       	push   $0x803474
  80241d:	53                   	push   %ebx
  80241e:	e8 63 eb ff ff       	call   800f86 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802423:	8b 46 04             	mov    0x4(%esi),%eax
  802426:	2b 06                	sub    (%esi),%eax
  802428:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80242e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802435:	00 00 00 
	stat->st_dev = &devpipe;
  802438:	c7 83 88 00 00 00 40 	movl   $0x804040,0x88(%ebx)
  80243f:	40 80 00 
	return 0;
}
  802442:	b8 00 00 00 00       	mov    $0x0,%eax
  802447:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80244a:	5b                   	pop    %ebx
  80244b:	5e                   	pop    %esi
  80244c:	5d                   	pop    %ebp
  80244d:	c3                   	ret    

0080244e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80244e:	55                   	push   %ebp
  80244f:	89 e5                	mov    %esp,%ebp
  802451:	53                   	push   %ebx
  802452:	83 ec 0c             	sub    $0xc,%esp
  802455:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802458:	53                   	push   %ebx
  802459:	6a 00                	push   $0x0
  80245b:	e8 9d ef ff ff       	call   8013fd <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802460:	89 1c 24             	mov    %ebx,(%esp)
  802463:	e8 15 f3 ff ff       	call   80177d <fd2data>
  802468:	83 c4 08             	add    $0x8,%esp
  80246b:	50                   	push   %eax
  80246c:	6a 00                	push   $0x0
  80246e:	e8 8a ef ff ff       	call   8013fd <sys_page_unmap>
}
  802473:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802476:	c9                   	leave  
  802477:	c3                   	ret    

00802478 <_pipeisclosed>:
{
  802478:	55                   	push   %ebp
  802479:	89 e5                	mov    %esp,%ebp
  80247b:	57                   	push   %edi
  80247c:	56                   	push   %esi
  80247d:	53                   	push   %ebx
  80247e:	83 ec 1c             	sub    $0x1c,%esp
  802481:	89 c7                	mov    %eax,%edi
  802483:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802485:	a1 08 50 80 00       	mov    0x805008,%eax
  80248a:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80248d:	83 ec 0c             	sub    $0xc,%esp
  802490:	57                   	push   %edi
  802491:	e8 2d 04 00 00       	call   8028c3 <pageref>
  802496:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802499:	89 34 24             	mov    %esi,(%esp)
  80249c:	e8 22 04 00 00       	call   8028c3 <pageref>
		nn = thisenv->env_runs;
  8024a1:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8024a7:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8024aa:	83 c4 10             	add    $0x10,%esp
  8024ad:	39 cb                	cmp    %ecx,%ebx
  8024af:	74 1b                	je     8024cc <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8024b1:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8024b4:	75 cf                	jne    802485 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8024b6:	8b 42 58             	mov    0x58(%edx),%eax
  8024b9:	6a 01                	push   $0x1
  8024bb:	50                   	push   %eax
  8024bc:	53                   	push   %ebx
  8024bd:	68 7b 34 80 00       	push   $0x80347b
  8024c2:	e8 60 e3 ff ff       	call   800827 <cprintf>
  8024c7:	83 c4 10             	add    $0x10,%esp
  8024ca:	eb b9                	jmp    802485 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8024cc:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8024cf:	0f 94 c0             	sete   %al
  8024d2:	0f b6 c0             	movzbl %al,%eax
}
  8024d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024d8:	5b                   	pop    %ebx
  8024d9:	5e                   	pop    %esi
  8024da:	5f                   	pop    %edi
  8024db:	5d                   	pop    %ebp
  8024dc:	c3                   	ret    

008024dd <devpipe_write>:
{
  8024dd:	55                   	push   %ebp
  8024de:	89 e5                	mov    %esp,%ebp
  8024e0:	57                   	push   %edi
  8024e1:	56                   	push   %esi
  8024e2:	53                   	push   %ebx
  8024e3:	83 ec 28             	sub    $0x28,%esp
  8024e6:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8024e9:	56                   	push   %esi
  8024ea:	e8 8e f2 ff ff       	call   80177d <fd2data>
  8024ef:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8024f1:	83 c4 10             	add    $0x10,%esp
  8024f4:	bf 00 00 00 00       	mov    $0x0,%edi
  8024f9:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8024fc:	74 4f                	je     80254d <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8024fe:	8b 43 04             	mov    0x4(%ebx),%eax
  802501:	8b 0b                	mov    (%ebx),%ecx
  802503:	8d 51 20             	lea    0x20(%ecx),%edx
  802506:	39 d0                	cmp    %edx,%eax
  802508:	72 14                	jb     80251e <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80250a:	89 da                	mov    %ebx,%edx
  80250c:	89 f0                	mov    %esi,%eax
  80250e:	e8 65 ff ff ff       	call   802478 <_pipeisclosed>
  802513:	85 c0                	test   %eax,%eax
  802515:	75 3b                	jne    802552 <devpipe_write+0x75>
			sys_yield();
  802517:	e8 3d ee ff ff       	call   801359 <sys_yield>
  80251c:	eb e0                	jmp    8024fe <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80251e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802521:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802525:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802528:	89 c2                	mov    %eax,%edx
  80252a:	c1 fa 1f             	sar    $0x1f,%edx
  80252d:	89 d1                	mov    %edx,%ecx
  80252f:	c1 e9 1b             	shr    $0x1b,%ecx
  802532:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802535:	83 e2 1f             	and    $0x1f,%edx
  802538:	29 ca                	sub    %ecx,%edx
  80253a:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80253e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802542:	83 c0 01             	add    $0x1,%eax
  802545:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802548:	83 c7 01             	add    $0x1,%edi
  80254b:	eb ac                	jmp    8024f9 <devpipe_write+0x1c>
	return i;
  80254d:	8b 45 10             	mov    0x10(%ebp),%eax
  802550:	eb 05                	jmp    802557 <devpipe_write+0x7a>
				return 0;
  802552:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802557:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80255a:	5b                   	pop    %ebx
  80255b:	5e                   	pop    %esi
  80255c:	5f                   	pop    %edi
  80255d:	5d                   	pop    %ebp
  80255e:	c3                   	ret    

0080255f <devpipe_read>:
{
  80255f:	55                   	push   %ebp
  802560:	89 e5                	mov    %esp,%ebp
  802562:	57                   	push   %edi
  802563:	56                   	push   %esi
  802564:	53                   	push   %ebx
  802565:	83 ec 18             	sub    $0x18,%esp
  802568:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80256b:	57                   	push   %edi
  80256c:	e8 0c f2 ff ff       	call   80177d <fd2data>
  802571:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802573:	83 c4 10             	add    $0x10,%esp
  802576:	be 00 00 00 00       	mov    $0x0,%esi
  80257b:	3b 75 10             	cmp    0x10(%ebp),%esi
  80257e:	75 14                	jne    802594 <devpipe_read+0x35>
	return i;
  802580:	8b 45 10             	mov    0x10(%ebp),%eax
  802583:	eb 02                	jmp    802587 <devpipe_read+0x28>
				return i;
  802585:	89 f0                	mov    %esi,%eax
}
  802587:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80258a:	5b                   	pop    %ebx
  80258b:	5e                   	pop    %esi
  80258c:	5f                   	pop    %edi
  80258d:	5d                   	pop    %ebp
  80258e:	c3                   	ret    
			sys_yield();
  80258f:	e8 c5 ed ff ff       	call   801359 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802594:	8b 03                	mov    (%ebx),%eax
  802596:	3b 43 04             	cmp    0x4(%ebx),%eax
  802599:	75 18                	jne    8025b3 <devpipe_read+0x54>
			if (i > 0)
  80259b:	85 f6                	test   %esi,%esi
  80259d:	75 e6                	jne    802585 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  80259f:	89 da                	mov    %ebx,%edx
  8025a1:	89 f8                	mov    %edi,%eax
  8025a3:	e8 d0 fe ff ff       	call   802478 <_pipeisclosed>
  8025a8:	85 c0                	test   %eax,%eax
  8025aa:	74 e3                	je     80258f <devpipe_read+0x30>
				return 0;
  8025ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b1:	eb d4                	jmp    802587 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8025b3:	99                   	cltd   
  8025b4:	c1 ea 1b             	shr    $0x1b,%edx
  8025b7:	01 d0                	add    %edx,%eax
  8025b9:	83 e0 1f             	and    $0x1f,%eax
  8025bc:	29 d0                	sub    %edx,%eax
  8025be:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8025c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8025c6:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8025c9:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8025cc:	83 c6 01             	add    $0x1,%esi
  8025cf:	eb aa                	jmp    80257b <devpipe_read+0x1c>

008025d1 <pipe>:
{
  8025d1:	55                   	push   %ebp
  8025d2:	89 e5                	mov    %esp,%ebp
  8025d4:	56                   	push   %esi
  8025d5:	53                   	push   %ebx
  8025d6:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8025d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025dc:	50                   	push   %eax
  8025dd:	e8 b2 f1 ff ff       	call   801794 <fd_alloc>
  8025e2:	89 c3                	mov    %eax,%ebx
  8025e4:	83 c4 10             	add    $0x10,%esp
  8025e7:	85 c0                	test   %eax,%eax
  8025e9:	0f 88 23 01 00 00    	js     802712 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025ef:	83 ec 04             	sub    $0x4,%esp
  8025f2:	68 07 04 00 00       	push   $0x407
  8025f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8025fa:	6a 00                	push   $0x0
  8025fc:	e8 77 ed ff ff       	call   801378 <sys_page_alloc>
  802601:	89 c3                	mov    %eax,%ebx
  802603:	83 c4 10             	add    $0x10,%esp
  802606:	85 c0                	test   %eax,%eax
  802608:	0f 88 04 01 00 00    	js     802712 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80260e:	83 ec 0c             	sub    $0xc,%esp
  802611:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802614:	50                   	push   %eax
  802615:	e8 7a f1 ff ff       	call   801794 <fd_alloc>
  80261a:	89 c3                	mov    %eax,%ebx
  80261c:	83 c4 10             	add    $0x10,%esp
  80261f:	85 c0                	test   %eax,%eax
  802621:	0f 88 db 00 00 00    	js     802702 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802627:	83 ec 04             	sub    $0x4,%esp
  80262a:	68 07 04 00 00       	push   $0x407
  80262f:	ff 75 f0             	pushl  -0x10(%ebp)
  802632:	6a 00                	push   $0x0
  802634:	e8 3f ed ff ff       	call   801378 <sys_page_alloc>
  802639:	89 c3                	mov    %eax,%ebx
  80263b:	83 c4 10             	add    $0x10,%esp
  80263e:	85 c0                	test   %eax,%eax
  802640:	0f 88 bc 00 00 00    	js     802702 <pipe+0x131>
	va = fd2data(fd0);
  802646:	83 ec 0c             	sub    $0xc,%esp
  802649:	ff 75 f4             	pushl  -0xc(%ebp)
  80264c:	e8 2c f1 ff ff       	call   80177d <fd2data>
  802651:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802653:	83 c4 0c             	add    $0xc,%esp
  802656:	68 07 04 00 00       	push   $0x407
  80265b:	50                   	push   %eax
  80265c:	6a 00                	push   $0x0
  80265e:	e8 15 ed ff ff       	call   801378 <sys_page_alloc>
  802663:	89 c3                	mov    %eax,%ebx
  802665:	83 c4 10             	add    $0x10,%esp
  802668:	85 c0                	test   %eax,%eax
  80266a:	0f 88 82 00 00 00    	js     8026f2 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802670:	83 ec 0c             	sub    $0xc,%esp
  802673:	ff 75 f0             	pushl  -0x10(%ebp)
  802676:	e8 02 f1 ff ff       	call   80177d <fd2data>
  80267b:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802682:	50                   	push   %eax
  802683:	6a 00                	push   $0x0
  802685:	56                   	push   %esi
  802686:	6a 00                	push   $0x0
  802688:	e8 2e ed ff ff       	call   8013bb <sys_page_map>
  80268d:	89 c3                	mov    %eax,%ebx
  80268f:	83 c4 20             	add    $0x20,%esp
  802692:	85 c0                	test   %eax,%eax
  802694:	78 4e                	js     8026e4 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802696:	a1 40 40 80 00       	mov    0x804040,%eax
  80269b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80269e:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8026a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026a3:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8026aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026ad:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8026af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026b2:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8026b9:	83 ec 0c             	sub    $0xc,%esp
  8026bc:	ff 75 f4             	pushl  -0xc(%ebp)
  8026bf:	e8 a9 f0 ff ff       	call   80176d <fd2num>
  8026c4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026c7:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8026c9:	83 c4 04             	add    $0x4,%esp
  8026cc:	ff 75 f0             	pushl  -0x10(%ebp)
  8026cf:	e8 99 f0 ff ff       	call   80176d <fd2num>
  8026d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026d7:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8026da:	83 c4 10             	add    $0x10,%esp
  8026dd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8026e2:	eb 2e                	jmp    802712 <pipe+0x141>
	sys_page_unmap(0, va);
  8026e4:	83 ec 08             	sub    $0x8,%esp
  8026e7:	56                   	push   %esi
  8026e8:	6a 00                	push   $0x0
  8026ea:	e8 0e ed ff ff       	call   8013fd <sys_page_unmap>
  8026ef:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8026f2:	83 ec 08             	sub    $0x8,%esp
  8026f5:	ff 75 f0             	pushl  -0x10(%ebp)
  8026f8:	6a 00                	push   $0x0
  8026fa:	e8 fe ec ff ff       	call   8013fd <sys_page_unmap>
  8026ff:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802702:	83 ec 08             	sub    $0x8,%esp
  802705:	ff 75 f4             	pushl  -0xc(%ebp)
  802708:	6a 00                	push   $0x0
  80270a:	e8 ee ec ff ff       	call   8013fd <sys_page_unmap>
  80270f:	83 c4 10             	add    $0x10,%esp
}
  802712:	89 d8                	mov    %ebx,%eax
  802714:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802717:	5b                   	pop    %ebx
  802718:	5e                   	pop    %esi
  802719:	5d                   	pop    %ebp
  80271a:	c3                   	ret    

0080271b <pipeisclosed>:
{
  80271b:	55                   	push   %ebp
  80271c:	89 e5                	mov    %esp,%ebp
  80271e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802721:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802724:	50                   	push   %eax
  802725:	ff 75 08             	pushl  0x8(%ebp)
  802728:	e8 b9 f0 ff ff       	call   8017e6 <fd_lookup>
  80272d:	83 c4 10             	add    $0x10,%esp
  802730:	85 c0                	test   %eax,%eax
  802732:	78 18                	js     80274c <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802734:	83 ec 0c             	sub    $0xc,%esp
  802737:	ff 75 f4             	pushl  -0xc(%ebp)
  80273a:	e8 3e f0 ff ff       	call   80177d <fd2data>
	return _pipeisclosed(fd, p);
  80273f:	89 c2                	mov    %eax,%edx
  802741:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802744:	e8 2f fd ff ff       	call   802478 <_pipeisclosed>
  802749:	83 c4 10             	add    $0x10,%esp
}
  80274c:	c9                   	leave  
  80274d:	c3                   	ret    

0080274e <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80274e:	b8 00 00 00 00       	mov    $0x0,%eax
  802753:	c3                   	ret    

00802754 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802754:	55                   	push   %ebp
  802755:	89 e5                	mov    %esp,%ebp
  802757:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80275a:	68 93 34 80 00       	push   $0x803493
  80275f:	ff 75 0c             	pushl  0xc(%ebp)
  802762:	e8 1f e8 ff ff       	call   800f86 <strcpy>
	return 0;
}
  802767:	b8 00 00 00 00       	mov    $0x0,%eax
  80276c:	c9                   	leave  
  80276d:	c3                   	ret    

0080276e <devcons_write>:
{
  80276e:	55                   	push   %ebp
  80276f:	89 e5                	mov    %esp,%ebp
  802771:	57                   	push   %edi
  802772:	56                   	push   %esi
  802773:	53                   	push   %ebx
  802774:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80277a:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80277f:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802785:	3b 75 10             	cmp    0x10(%ebp),%esi
  802788:	73 31                	jae    8027bb <devcons_write+0x4d>
		m = n - tot;
  80278a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80278d:	29 f3                	sub    %esi,%ebx
  80278f:	83 fb 7f             	cmp    $0x7f,%ebx
  802792:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802797:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80279a:	83 ec 04             	sub    $0x4,%esp
  80279d:	53                   	push   %ebx
  80279e:	89 f0                	mov    %esi,%eax
  8027a0:	03 45 0c             	add    0xc(%ebp),%eax
  8027a3:	50                   	push   %eax
  8027a4:	57                   	push   %edi
  8027a5:	e8 6a e9 ff ff       	call   801114 <memmove>
		sys_cputs(buf, m);
  8027aa:	83 c4 08             	add    $0x8,%esp
  8027ad:	53                   	push   %ebx
  8027ae:	57                   	push   %edi
  8027af:	e8 08 eb ff ff       	call   8012bc <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8027b4:	01 de                	add    %ebx,%esi
  8027b6:	83 c4 10             	add    $0x10,%esp
  8027b9:	eb ca                	jmp    802785 <devcons_write+0x17>
}
  8027bb:	89 f0                	mov    %esi,%eax
  8027bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8027c0:	5b                   	pop    %ebx
  8027c1:	5e                   	pop    %esi
  8027c2:	5f                   	pop    %edi
  8027c3:	5d                   	pop    %ebp
  8027c4:	c3                   	ret    

008027c5 <devcons_read>:
{
  8027c5:	55                   	push   %ebp
  8027c6:	89 e5                	mov    %esp,%ebp
  8027c8:	83 ec 08             	sub    $0x8,%esp
  8027cb:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8027d0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8027d4:	74 21                	je     8027f7 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8027d6:	e8 ff ea ff ff       	call   8012da <sys_cgetc>
  8027db:	85 c0                	test   %eax,%eax
  8027dd:	75 07                	jne    8027e6 <devcons_read+0x21>
		sys_yield();
  8027df:	e8 75 eb ff ff       	call   801359 <sys_yield>
  8027e4:	eb f0                	jmp    8027d6 <devcons_read+0x11>
	if (c < 0)
  8027e6:	78 0f                	js     8027f7 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8027e8:	83 f8 04             	cmp    $0x4,%eax
  8027eb:	74 0c                	je     8027f9 <devcons_read+0x34>
	*(char*)vbuf = c;
  8027ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027f0:	88 02                	mov    %al,(%edx)
	return 1;
  8027f2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8027f7:	c9                   	leave  
  8027f8:	c3                   	ret    
		return 0;
  8027f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8027fe:	eb f7                	jmp    8027f7 <devcons_read+0x32>

00802800 <cputchar>:
{
  802800:	55                   	push   %ebp
  802801:	89 e5                	mov    %esp,%ebp
  802803:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802806:	8b 45 08             	mov    0x8(%ebp),%eax
  802809:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80280c:	6a 01                	push   $0x1
  80280e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802811:	50                   	push   %eax
  802812:	e8 a5 ea ff ff       	call   8012bc <sys_cputs>
}
  802817:	83 c4 10             	add    $0x10,%esp
  80281a:	c9                   	leave  
  80281b:	c3                   	ret    

0080281c <getchar>:
{
  80281c:	55                   	push   %ebp
  80281d:	89 e5                	mov    %esp,%ebp
  80281f:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802822:	6a 01                	push   $0x1
  802824:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802827:	50                   	push   %eax
  802828:	6a 00                	push   $0x0
  80282a:	e8 27 f2 ff ff       	call   801a56 <read>
	if (r < 0)
  80282f:	83 c4 10             	add    $0x10,%esp
  802832:	85 c0                	test   %eax,%eax
  802834:	78 06                	js     80283c <getchar+0x20>
	if (r < 1)
  802836:	74 06                	je     80283e <getchar+0x22>
	return c;
  802838:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80283c:	c9                   	leave  
  80283d:	c3                   	ret    
		return -E_EOF;
  80283e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802843:	eb f7                	jmp    80283c <getchar+0x20>

00802845 <iscons>:
{
  802845:	55                   	push   %ebp
  802846:	89 e5                	mov    %esp,%ebp
  802848:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80284b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80284e:	50                   	push   %eax
  80284f:	ff 75 08             	pushl  0x8(%ebp)
  802852:	e8 8f ef ff ff       	call   8017e6 <fd_lookup>
  802857:	83 c4 10             	add    $0x10,%esp
  80285a:	85 c0                	test   %eax,%eax
  80285c:	78 11                	js     80286f <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80285e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802861:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  802867:	39 10                	cmp    %edx,(%eax)
  802869:	0f 94 c0             	sete   %al
  80286c:	0f b6 c0             	movzbl %al,%eax
}
  80286f:	c9                   	leave  
  802870:	c3                   	ret    

00802871 <opencons>:
{
  802871:	55                   	push   %ebp
  802872:	89 e5                	mov    %esp,%ebp
  802874:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802877:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80287a:	50                   	push   %eax
  80287b:	e8 14 ef ff ff       	call   801794 <fd_alloc>
  802880:	83 c4 10             	add    $0x10,%esp
  802883:	85 c0                	test   %eax,%eax
  802885:	78 3a                	js     8028c1 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802887:	83 ec 04             	sub    $0x4,%esp
  80288a:	68 07 04 00 00       	push   $0x407
  80288f:	ff 75 f4             	pushl  -0xc(%ebp)
  802892:	6a 00                	push   $0x0
  802894:	e8 df ea ff ff       	call   801378 <sys_page_alloc>
  802899:	83 c4 10             	add    $0x10,%esp
  80289c:	85 c0                	test   %eax,%eax
  80289e:	78 21                	js     8028c1 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8028a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a3:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  8028a9:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8028ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ae:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8028b5:	83 ec 0c             	sub    $0xc,%esp
  8028b8:	50                   	push   %eax
  8028b9:	e8 af ee ff ff       	call   80176d <fd2num>
  8028be:	83 c4 10             	add    $0x10,%esp
}
  8028c1:	c9                   	leave  
  8028c2:	c3                   	ret    

008028c3 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8028c3:	55                   	push   %ebp
  8028c4:	89 e5                	mov    %esp,%ebp
  8028c6:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8028c9:	89 d0                	mov    %edx,%eax
  8028cb:	c1 e8 16             	shr    $0x16,%eax
  8028ce:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8028d5:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8028da:	f6 c1 01             	test   $0x1,%cl
  8028dd:	74 1d                	je     8028fc <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8028df:	c1 ea 0c             	shr    $0xc,%edx
  8028e2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8028e9:	f6 c2 01             	test   $0x1,%dl
  8028ec:	74 0e                	je     8028fc <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8028ee:	c1 ea 0c             	shr    $0xc,%edx
  8028f1:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8028f8:	ef 
  8028f9:	0f b7 c0             	movzwl %ax,%eax
}
  8028fc:	5d                   	pop    %ebp
  8028fd:	c3                   	ret    
  8028fe:	66 90                	xchg   %ax,%ax

00802900 <__udivdi3>:
  802900:	55                   	push   %ebp
  802901:	57                   	push   %edi
  802902:	56                   	push   %esi
  802903:	53                   	push   %ebx
  802904:	83 ec 1c             	sub    $0x1c,%esp
  802907:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80290b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80290f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802913:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802917:	85 d2                	test   %edx,%edx
  802919:	75 4d                	jne    802968 <__udivdi3+0x68>
  80291b:	39 f3                	cmp    %esi,%ebx
  80291d:	76 19                	jbe    802938 <__udivdi3+0x38>
  80291f:	31 ff                	xor    %edi,%edi
  802921:	89 e8                	mov    %ebp,%eax
  802923:	89 f2                	mov    %esi,%edx
  802925:	f7 f3                	div    %ebx
  802927:	89 fa                	mov    %edi,%edx
  802929:	83 c4 1c             	add    $0x1c,%esp
  80292c:	5b                   	pop    %ebx
  80292d:	5e                   	pop    %esi
  80292e:	5f                   	pop    %edi
  80292f:	5d                   	pop    %ebp
  802930:	c3                   	ret    
  802931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802938:	89 d9                	mov    %ebx,%ecx
  80293a:	85 db                	test   %ebx,%ebx
  80293c:	75 0b                	jne    802949 <__udivdi3+0x49>
  80293e:	b8 01 00 00 00       	mov    $0x1,%eax
  802943:	31 d2                	xor    %edx,%edx
  802945:	f7 f3                	div    %ebx
  802947:	89 c1                	mov    %eax,%ecx
  802949:	31 d2                	xor    %edx,%edx
  80294b:	89 f0                	mov    %esi,%eax
  80294d:	f7 f1                	div    %ecx
  80294f:	89 c6                	mov    %eax,%esi
  802951:	89 e8                	mov    %ebp,%eax
  802953:	89 f7                	mov    %esi,%edi
  802955:	f7 f1                	div    %ecx
  802957:	89 fa                	mov    %edi,%edx
  802959:	83 c4 1c             	add    $0x1c,%esp
  80295c:	5b                   	pop    %ebx
  80295d:	5e                   	pop    %esi
  80295e:	5f                   	pop    %edi
  80295f:	5d                   	pop    %ebp
  802960:	c3                   	ret    
  802961:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802968:	39 f2                	cmp    %esi,%edx
  80296a:	77 1c                	ja     802988 <__udivdi3+0x88>
  80296c:	0f bd fa             	bsr    %edx,%edi
  80296f:	83 f7 1f             	xor    $0x1f,%edi
  802972:	75 2c                	jne    8029a0 <__udivdi3+0xa0>
  802974:	39 f2                	cmp    %esi,%edx
  802976:	72 06                	jb     80297e <__udivdi3+0x7e>
  802978:	31 c0                	xor    %eax,%eax
  80297a:	39 eb                	cmp    %ebp,%ebx
  80297c:	77 a9                	ja     802927 <__udivdi3+0x27>
  80297e:	b8 01 00 00 00       	mov    $0x1,%eax
  802983:	eb a2                	jmp    802927 <__udivdi3+0x27>
  802985:	8d 76 00             	lea    0x0(%esi),%esi
  802988:	31 ff                	xor    %edi,%edi
  80298a:	31 c0                	xor    %eax,%eax
  80298c:	89 fa                	mov    %edi,%edx
  80298e:	83 c4 1c             	add    $0x1c,%esp
  802991:	5b                   	pop    %ebx
  802992:	5e                   	pop    %esi
  802993:	5f                   	pop    %edi
  802994:	5d                   	pop    %ebp
  802995:	c3                   	ret    
  802996:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80299d:	8d 76 00             	lea    0x0(%esi),%esi
  8029a0:	89 f9                	mov    %edi,%ecx
  8029a2:	b8 20 00 00 00       	mov    $0x20,%eax
  8029a7:	29 f8                	sub    %edi,%eax
  8029a9:	d3 e2                	shl    %cl,%edx
  8029ab:	89 54 24 08          	mov    %edx,0x8(%esp)
  8029af:	89 c1                	mov    %eax,%ecx
  8029b1:	89 da                	mov    %ebx,%edx
  8029b3:	d3 ea                	shr    %cl,%edx
  8029b5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8029b9:	09 d1                	or     %edx,%ecx
  8029bb:	89 f2                	mov    %esi,%edx
  8029bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8029c1:	89 f9                	mov    %edi,%ecx
  8029c3:	d3 e3                	shl    %cl,%ebx
  8029c5:	89 c1                	mov    %eax,%ecx
  8029c7:	d3 ea                	shr    %cl,%edx
  8029c9:	89 f9                	mov    %edi,%ecx
  8029cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8029cf:	89 eb                	mov    %ebp,%ebx
  8029d1:	d3 e6                	shl    %cl,%esi
  8029d3:	89 c1                	mov    %eax,%ecx
  8029d5:	d3 eb                	shr    %cl,%ebx
  8029d7:	09 de                	or     %ebx,%esi
  8029d9:	89 f0                	mov    %esi,%eax
  8029db:	f7 74 24 08          	divl   0x8(%esp)
  8029df:	89 d6                	mov    %edx,%esi
  8029e1:	89 c3                	mov    %eax,%ebx
  8029e3:	f7 64 24 0c          	mull   0xc(%esp)
  8029e7:	39 d6                	cmp    %edx,%esi
  8029e9:	72 15                	jb     802a00 <__udivdi3+0x100>
  8029eb:	89 f9                	mov    %edi,%ecx
  8029ed:	d3 e5                	shl    %cl,%ebp
  8029ef:	39 c5                	cmp    %eax,%ebp
  8029f1:	73 04                	jae    8029f7 <__udivdi3+0xf7>
  8029f3:	39 d6                	cmp    %edx,%esi
  8029f5:	74 09                	je     802a00 <__udivdi3+0x100>
  8029f7:	89 d8                	mov    %ebx,%eax
  8029f9:	31 ff                	xor    %edi,%edi
  8029fb:	e9 27 ff ff ff       	jmp    802927 <__udivdi3+0x27>
  802a00:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802a03:	31 ff                	xor    %edi,%edi
  802a05:	e9 1d ff ff ff       	jmp    802927 <__udivdi3+0x27>
  802a0a:	66 90                	xchg   %ax,%ax
  802a0c:	66 90                	xchg   %ax,%ax
  802a0e:	66 90                	xchg   %ax,%ax

00802a10 <__umoddi3>:
  802a10:	55                   	push   %ebp
  802a11:	57                   	push   %edi
  802a12:	56                   	push   %esi
  802a13:	53                   	push   %ebx
  802a14:	83 ec 1c             	sub    $0x1c,%esp
  802a17:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802a1b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802a1f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802a23:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a27:	89 da                	mov    %ebx,%edx
  802a29:	85 c0                	test   %eax,%eax
  802a2b:	75 43                	jne    802a70 <__umoddi3+0x60>
  802a2d:	39 df                	cmp    %ebx,%edi
  802a2f:	76 17                	jbe    802a48 <__umoddi3+0x38>
  802a31:	89 f0                	mov    %esi,%eax
  802a33:	f7 f7                	div    %edi
  802a35:	89 d0                	mov    %edx,%eax
  802a37:	31 d2                	xor    %edx,%edx
  802a39:	83 c4 1c             	add    $0x1c,%esp
  802a3c:	5b                   	pop    %ebx
  802a3d:	5e                   	pop    %esi
  802a3e:	5f                   	pop    %edi
  802a3f:	5d                   	pop    %ebp
  802a40:	c3                   	ret    
  802a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a48:	89 fd                	mov    %edi,%ebp
  802a4a:	85 ff                	test   %edi,%edi
  802a4c:	75 0b                	jne    802a59 <__umoddi3+0x49>
  802a4e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a53:	31 d2                	xor    %edx,%edx
  802a55:	f7 f7                	div    %edi
  802a57:	89 c5                	mov    %eax,%ebp
  802a59:	89 d8                	mov    %ebx,%eax
  802a5b:	31 d2                	xor    %edx,%edx
  802a5d:	f7 f5                	div    %ebp
  802a5f:	89 f0                	mov    %esi,%eax
  802a61:	f7 f5                	div    %ebp
  802a63:	89 d0                	mov    %edx,%eax
  802a65:	eb d0                	jmp    802a37 <__umoddi3+0x27>
  802a67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a6e:	66 90                	xchg   %ax,%ax
  802a70:	89 f1                	mov    %esi,%ecx
  802a72:	39 d8                	cmp    %ebx,%eax
  802a74:	76 0a                	jbe    802a80 <__umoddi3+0x70>
  802a76:	89 f0                	mov    %esi,%eax
  802a78:	83 c4 1c             	add    $0x1c,%esp
  802a7b:	5b                   	pop    %ebx
  802a7c:	5e                   	pop    %esi
  802a7d:	5f                   	pop    %edi
  802a7e:	5d                   	pop    %ebp
  802a7f:	c3                   	ret    
  802a80:	0f bd e8             	bsr    %eax,%ebp
  802a83:	83 f5 1f             	xor    $0x1f,%ebp
  802a86:	75 20                	jne    802aa8 <__umoddi3+0x98>
  802a88:	39 d8                	cmp    %ebx,%eax
  802a8a:	0f 82 b0 00 00 00    	jb     802b40 <__umoddi3+0x130>
  802a90:	39 f7                	cmp    %esi,%edi
  802a92:	0f 86 a8 00 00 00    	jbe    802b40 <__umoddi3+0x130>
  802a98:	89 c8                	mov    %ecx,%eax
  802a9a:	83 c4 1c             	add    $0x1c,%esp
  802a9d:	5b                   	pop    %ebx
  802a9e:	5e                   	pop    %esi
  802a9f:	5f                   	pop    %edi
  802aa0:	5d                   	pop    %ebp
  802aa1:	c3                   	ret    
  802aa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802aa8:	89 e9                	mov    %ebp,%ecx
  802aaa:	ba 20 00 00 00       	mov    $0x20,%edx
  802aaf:	29 ea                	sub    %ebp,%edx
  802ab1:	d3 e0                	shl    %cl,%eax
  802ab3:	89 44 24 08          	mov    %eax,0x8(%esp)
  802ab7:	89 d1                	mov    %edx,%ecx
  802ab9:	89 f8                	mov    %edi,%eax
  802abb:	d3 e8                	shr    %cl,%eax
  802abd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802ac1:	89 54 24 04          	mov    %edx,0x4(%esp)
  802ac5:	8b 54 24 04          	mov    0x4(%esp),%edx
  802ac9:	09 c1                	or     %eax,%ecx
  802acb:	89 d8                	mov    %ebx,%eax
  802acd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802ad1:	89 e9                	mov    %ebp,%ecx
  802ad3:	d3 e7                	shl    %cl,%edi
  802ad5:	89 d1                	mov    %edx,%ecx
  802ad7:	d3 e8                	shr    %cl,%eax
  802ad9:	89 e9                	mov    %ebp,%ecx
  802adb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802adf:	d3 e3                	shl    %cl,%ebx
  802ae1:	89 c7                	mov    %eax,%edi
  802ae3:	89 d1                	mov    %edx,%ecx
  802ae5:	89 f0                	mov    %esi,%eax
  802ae7:	d3 e8                	shr    %cl,%eax
  802ae9:	89 e9                	mov    %ebp,%ecx
  802aeb:	89 fa                	mov    %edi,%edx
  802aed:	d3 e6                	shl    %cl,%esi
  802aef:	09 d8                	or     %ebx,%eax
  802af1:	f7 74 24 08          	divl   0x8(%esp)
  802af5:	89 d1                	mov    %edx,%ecx
  802af7:	89 f3                	mov    %esi,%ebx
  802af9:	f7 64 24 0c          	mull   0xc(%esp)
  802afd:	89 c6                	mov    %eax,%esi
  802aff:	89 d7                	mov    %edx,%edi
  802b01:	39 d1                	cmp    %edx,%ecx
  802b03:	72 06                	jb     802b0b <__umoddi3+0xfb>
  802b05:	75 10                	jne    802b17 <__umoddi3+0x107>
  802b07:	39 c3                	cmp    %eax,%ebx
  802b09:	73 0c                	jae    802b17 <__umoddi3+0x107>
  802b0b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802b0f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802b13:	89 d7                	mov    %edx,%edi
  802b15:	89 c6                	mov    %eax,%esi
  802b17:	89 ca                	mov    %ecx,%edx
  802b19:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802b1e:	29 f3                	sub    %esi,%ebx
  802b20:	19 fa                	sbb    %edi,%edx
  802b22:	89 d0                	mov    %edx,%eax
  802b24:	d3 e0                	shl    %cl,%eax
  802b26:	89 e9                	mov    %ebp,%ecx
  802b28:	d3 eb                	shr    %cl,%ebx
  802b2a:	d3 ea                	shr    %cl,%edx
  802b2c:	09 d8                	or     %ebx,%eax
  802b2e:	83 c4 1c             	add    $0x1c,%esp
  802b31:	5b                   	pop    %ebx
  802b32:	5e                   	pop    %esi
  802b33:	5f                   	pop    %edi
  802b34:	5d                   	pop    %ebp
  802b35:	c3                   	ret    
  802b36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b3d:	8d 76 00             	lea    0x0(%esi),%esi
  802b40:	89 da                	mov    %ebx,%edx
  802b42:	29 fe                	sub    %edi,%esi
  802b44:	19 c2                	sbb    %eax,%edx
  802b46:	89 f1                	mov    %esi,%ecx
  802b48:	89 c8                	mov    %ecx,%eax
  802b4a:	e9 4b ff ff ff       	jmp    802a9a <__umoddi3+0x8a>
