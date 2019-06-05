
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
  800042:	e8 7e 0f 00 00       	call   800fc5 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800047:	89 1d 00 64 80 00    	mov    %ebx,0x806400

	fsenv = ipc_find_env(ENV_TYPE_FS);
  80004d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800054:	e8 f4 16 00 00       	call   80174d <ipc_find_env>
	ipc_send(fsenv, FSREQ_OPEN, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800059:	6a 07                	push   $0x7
  80005b:	68 00 60 80 00       	push   $0x806000
  800060:	6a 01                	push   $0x1
  800062:	50                   	push   %eax
  800063:	e8 8d 16 00 00       	call   8016f5 <ipc_send>
	return ipc_recv(NULL, FVA, NULL);
  800068:	83 c4 1c             	add    $0x1c,%esp
  80006b:	6a 00                	push   $0x0
  80006d:	68 00 c0 cc cc       	push   $0xccccc000
  800072:	6a 00                	push   $0x0
  800074:	e8 13 16 00 00       	call   80168c <ipc_recv>
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
  80008f:	b8 80 2b 80 00       	mov    $0x802b80,%eax
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
  8000b3:	b8 b5 2b 80 00       	mov    $0x802bb5,%eax
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
  8000ef:	68 d6 2b 80 00       	push   $0x802bd6
  8000f4:	e8 6d 07 00 00       	call   800866 <cprintf>

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
  800122:	e8 65 0e 00 00       	call   800f8c <strlen>
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  80012d:	0f 85 d2 03 00 00    	jne    800505 <umain+0x487>
		panic("file_stat returned size %d wanted %d\n", st.st_size, strlen(msg));
	cprintf("file_stat is good\n");
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	68 f8 2b 80 00       	push   $0x802bf8
  80013b:	e8 26 07 00 00       	call   800866 <cprintf>

	memset(buf, 0, sizeof buf);
  800140:	83 c4 0c             	add    $0xc,%esp
  800143:	68 00 02 00 00       	push   $0x200
  800148:	6a 00                	push   $0x0
  80014a:	8d 9d 4c fd ff ff    	lea    -0x2b4(%ebp),%ebx
  800150:	53                   	push   %ebx
  800151:	e8 b5 0f 00 00       	call   80110b <memset>
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
  800185:	e8 e6 0e 00 00       	call   801070 <strcmp>
  80018a:	83 c4 10             	add    $0x10,%esp
  80018d:	85 c0                	test   %eax,%eax
  80018f:	0f 85 a7 03 00 00    	jne    80053c <umain+0x4be>
		panic("file_read returned wrong data");
	cprintf("file_read is good\n");
  800195:	83 ec 0c             	sub    $0xc,%esp
  800198:	68 37 2c 80 00       	push   $0x802c37
  80019d:	e8 c4 06 00 00       	call   800866 <cprintf>

	if ((r = devfile.dev_close(FVA)) < 0)
  8001a2:	c7 04 24 00 c0 cc cc 	movl   $0xccccc000,(%esp)
  8001a9:	ff 15 18 40 80 00    	call   *0x804018
  8001af:	83 c4 10             	add    $0x10,%esp
  8001b2:	85 c0                	test   %eax,%eax
  8001b4:	0f 88 96 03 00 00    	js     800550 <umain+0x4d2>
		panic("file_close: %e", r);
	cprintf("file_close is good\n");
  8001ba:	83 ec 0c             	sub    $0xc,%esp
  8001bd:	68 59 2c 80 00       	push   $0x802c59
  8001c2:	e8 9f 06 00 00       	call   800866 <cprintf>

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
  8001f1:	e8 46 12 00 00       	call   80143c <sys_page_unmap>

	cprintf("%d: before dev_read!!\n", thisenv->env_id);
  8001f6:	a1 08 50 80 00       	mov    0x805008,%eax
  8001fb:	8b 40 48             	mov    0x48(%eax),%eax
  8001fe:	83 c4 08             	add    $0x8,%esp
  800201:	50                   	push   %eax
  800202:	68 6d 2c 80 00       	push   $0x802c6d
  800207:	e8 5a 06 00 00       	call   800866 <cprintf>
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
  800236:	68 84 2c 80 00       	push   $0x802c84
  80023b:	e8 26 06 00 00       	call   800866 <cprintf>

	// Try writing
	if ((r = xopen("/new-file", O_RDWR|O_CREAT)) < 0)
  800240:	ba 02 01 00 00       	mov    $0x102,%edx
  800245:	b8 9a 2c 80 00       	mov    $0x802c9a,%eax
  80024a:	e8 e4 fd ff ff       	call   800033 <xopen>
  80024f:	83 c4 10             	add    $0x10,%esp
  800252:	85 c0                	test   %eax,%eax
  800254:	0f 88 31 03 00 00    	js     80058b <umain+0x50d>
		panic("serve_open /new-file: %e", r);

	if ((r = devfile.dev_write(FVA, msg, strlen(msg))) != strlen(msg))
  80025a:	8b 1d 14 40 80 00    	mov    0x804014,%ebx
  800260:	83 ec 0c             	sub    $0xc,%esp
  800263:	ff 35 00 40 80 00    	pushl  0x804000
  800269:	e8 1e 0d 00 00       	call   800f8c <strlen>
  80026e:	83 c4 0c             	add    $0xc,%esp
  800271:	50                   	push   %eax
  800272:	ff 35 00 40 80 00    	pushl  0x804000
  800278:	68 00 c0 cc cc       	push   $0xccccc000
  80027d:	ff d3                	call   *%ebx
  80027f:	89 c3                	mov    %eax,%ebx
  800281:	83 c4 04             	add    $0x4,%esp
  800284:	ff 35 00 40 80 00    	pushl  0x804000
  80028a:	e8 fd 0c 00 00       	call   800f8c <strlen>
  80028f:	83 c4 10             	add    $0x10,%esp
  800292:	39 d8                	cmp    %ebx,%eax
  800294:	0f 85 03 03 00 00    	jne    80059d <umain+0x51f>
		panic("file_write: %e", r);
	cprintf("file_write is good\n");
  80029a:	83 ec 0c             	sub    $0xc,%esp
  80029d:	68 cc 2c 80 00       	push   $0x802ccc
  8002a2:	e8 bf 05 00 00       	call   800866 <cprintf>

	FVA->fd_offset = 0;
  8002a7:	c7 05 04 c0 cc cc 00 	movl   $0x0,0xccccc004
  8002ae:	00 00 00 
	memset(buf, 0, sizeof buf);
  8002b1:	83 c4 0c             	add    $0xc,%esp
  8002b4:	68 00 02 00 00       	push   $0x200
  8002b9:	6a 00                	push   $0x0
  8002bb:	8d 9d 4c fd ff ff    	lea    -0x2b4(%ebp),%ebx
  8002c1:	53                   	push   %ebx
  8002c2:	e8 44 0e 00 00       	call   80110b <memset>
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
  8002f1:	e8 96 0c 00 00       	call   800f8c <strlen>
  8002f6:	83 c4 10             	add    $0x10,%esp
  8002f9:	39 d8                	cmp    %ebx,%eax
  8002fb:	0f 85 c0 02 00 00    	jne    8005c1 <umain+0x543>
		panic("file_read after file_write returned wrong length: %d", r);
	if (strcmp(buf, msg) != 0)
  800301:	83 ec 08             	sub    $0x8,%esp
  800304:	ff 35 00 40 80 00    	pushl  0x804000
  80030a:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  800310:	50                   	push   %eax
  800311:	e8 5a 0d 00 00       	call   801070 <strcmp>
  800316:	83 c4 10             	add    $0x10,%esp
  800319:	85 c0                	test   %eax,%eax
  80031b:	0f 85 b2 02 00 00    	jne    8005d3 <umain+0x555>
		panic("file_read after file_write returned wrong data");
	cprintf("file_read after file_write is good\n");
  800321:	83 ec 0c             	sub    $0xc,%esp
  800324:	68 b0 2e 80 00       	push   $0x802eb0
  800329:	e8 38 05 00 00       	call   800866 <cprintf>

	// Now we'll try out open
	if ((r = open("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  80032e:	83 c4 08             	add    $0x8,%esp
  800331:	6a 00                	push   $0x0
  800333:	68 80 2b 80 00       	push   $0x802b80
  800338:	e8 d2 1b 00 00       	call   801f0f <open>
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
  80035a:	68 b5 2b 80 00       	push   $0x802bb5
  80035f:	e8 ab 1b 00 00       	call   801f0f <open>
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
  80039d:	68 dc 2b 80 00       	push   $0x802bdc
  8003a2:	e8 bf 04 00 00       	call   800866 <cprintf>

	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
  8003a7:	83 c4 08             	add    $0x8,%esp
  8003aa:	68 01 01 00 00       	push   $0x101
  8003af:	68 fb 2c 80 00       	push   $0x802cfb
  8003b4:	e8 56 1b 00 00       	call   801f0f <open>
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
  8003d7:	e8 2f 0d 00 00       	call   80110b <memset>
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
  8003f7:	e8 41 17 00 00       	call   801b3d <write>
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
  800419:	e8 15 15 00 00       	call   801933 <close>

	if ((f = open("/big", O_RDONLY)) < 0)
  80041e:	83 c4 08             	add    $0x8,%esp
  800421:	6a 00                	push   $0x0
  800423:	68 fb 2c 80 00       	push   $0x802cfb
  800428:	e8 e2 1a 00 00       	call   801f0f <open>
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
  800450:	e8 a3 16 00 00       	call   801af8 <readn>
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
  80048b:	e8 a3 14 00 00       	call   801933 <close>
	cprintf("large file is good\n");
  800490:	c7 04 24 40 2d 80 00 	movl   $0x802d40,(%esp)
  800497:	e8 ca 03 00 00       	call   800866 <cprintf>
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
  8004a8:	68 8b 2b 80 00       	push   $0x802b8b
  8004ad:	6a 20                	push   $0x20
  8004af:	68 a5 2b 80 00       	push   $0x802ba5
  8004b4:	e8 b7 02 00 00       	call   800770 <_panic>
		panic("serve_open /not-found succeeded!");
  8004b9:	83 ec 04             	sub    $0x4,%esp
  8004bc:	68 54 2d 80 00       	push   $0x802d54
  8004c1:	6a 22                	push   $0x22
  8004c3:	68 a5 2b 80 00       	push   $0x802ba5
  8004c8:	e8 a3 02 00 00       	call   800770 <_panic>
		panic("serve_open /newmotd: %e", r);
  8004cd:	50                   	push   %eax
  8004ce:	68 be 2b 80 00       	push   $0x802bbe
  8004d3:	6a 25                	push   $0x25
  8004d5:	68 a5 2b 80 00       	push   $0x802ba5
  8004da:	e8 91 02 00 00       	call   800770 <_panic>
		panic("serve_open did not fill struct Fd correctly\n");
  8004df:	83 ec 04             	sub    $0x4,%esp
  8004e2:	68 78 2d 80 00       	push   $0x802d78
  8004e7:	6a 27                	push   $0x27
  8004e9:	68 a5 2b 80 00       	push   $0x802ba5
  8004ee:	e8 7d 02 00 00       	call   800770 <_panic>
		panic("file_stat: %e", r);
  8004f3:	50                   	push   %eax
  8004f4:	68 ea 2b 80 00       	push   $0x802bea
  8004f9:	6a 2b                	push   $0x2b
  8004fb:	68 a5 2b 80 00       	push   $0x802ba5
  800500:	e8 6b 02 00 00       	call   800770 <_panic>
		panic("file_stat returned size %d wanted %d\n", st.st_size, strlen(msg));
  800505:	83 ec 0c             	sub    $0xc,%esp
  800508:	ff 35 00 40 80 00    	pushl  0x804000
  80050e:	e8 79 0a 00 00       	call   800f8c <strlen>
  800513:	89 04 24             	mov    %eax,(%esp)
  800516:	ff 75 cc             	pushl  -0x34(%ebp)
  800519:	68 a8 2d 80 00       	push   $0x802da8
  80051e:	6a 2d                	push   $0x2d
  800520:	68 a5 2b 80 00       	push   $0x802ba5
  800525:	e8 46 02 00 00       	call   800770 <_panic>
		panic("file_read: %e", r);
  80052a:	50                   	push   %eax
  80052b:	68 0b 2c 80 00       	push   $0x802c0b
  800530:	6a 32                	push   $0x32
  800532:	68 a5 2b 80 00       	push   $0x802ba5
  800537:	e8 34 02 00 00       	call   800770 <_panic>
		panic("file_read returned wrong data");
  80053c:	83 ec 04             	sub    $0x4,%esp
  80053f:	68 19 2c 80 00       	push   $0x802c19
  800544:	6a 34                	push   $0x34
  800546:	68 a5 2b 80 00       	push   $0x802ba5
  80054b:	e8 20 02 00 00       	call   800770 <_panic>
		panic("file_close: %e", r);
  800550:	50                   	push   %eax
  800551:	68 4a 2c 80 00       	push   $0x802c4a
  800556:	6a 38                	push   $0x38
  800558:	68 a5 2b 80 00       	push   $0x802ba5
  80055d:	e8 0e 02 00 00       	call   800770 <_panic>
		cprintf("%d: after dev_read!! the r: %d\n", thisenv->env_id, r);
  800562:	a1 08 50 80 00       	mov    0x805008,%eax
  800567:	8b 40 48             	mov    0x48(%eax),%eax
  80056a:	83 ec 04             	sub    $0x4,%esp
  80056d:	53                   	push   %ebx
  80056e:	50                   	push   %eax
  80056f:	68 d0 2d 80 00       	push   $0x802dd0
  800574:	e8 ed 02 00 00       	call   800866 <cprintf>
		panic("serve_read does not handle stale fileids correctly: %e", r);
  800579:	53                   	push   %ebx
  80057a:	68 f0 2d 80 00       	push   $0x802df0
  80057f:	6a 45                	push   $0x45
  800581:	68 a5 2b 80 00       	push   $0x802ba5
  800586:	e8 e5 01 00 00       	call   800770 <_panic>
		panic("serve_open /new-file: %e", r);
  80058b:	50                   	push   %eax
  80058c:	68 a4 2c 80 00       	push   $0x802ca4
  800591:	6a 4b                	push   $0x4b
  800593:	68 a5 2b 80 00       	push   $0x802ba5
  800598:	e8 d3 01 00 00       	call   800770 <_panic>
		panic("file_write: %e", r);
  80059d:	53                   	push   %ebx
  80059e:	68 bd 2c 80 00       	push   $0x802cbd
  8005a3:	6a 4e                	push   $0x4e
  8005a5:	68 a5 2b 80 00       	push   $0x802ba5
  8005aa:	e8 c1 01 00 00       	call   800770 <_panic>
		panic("file_read after file_write: %e", r);
  8005af:	50                   	push   %eax
  8005b0:	68 28 2e 80 00       	push   $0x802e28
  8005b5:	6a 54                	push   $0x54
  8005b7:	68 a5 2b 80 00       	push   $0x802ba5
  8005bc:	e8 af 01 00 00       	call   800770 <_panic>
		panic("file_read after file_write returned wrong length: %d", r);
  8005c1:	53                   	push   %ebx
  8005c2:	68 48 2e 80 00       	push   $0x802e48
  8005c7:	6a 56                	push   $0x56
  8005c9:	68 a5 2b 80 00       	push   $0x802ba5
  8005ce:	e8 9d 01 00 00       	call   800770 <_panic>
		panic("file_read after file_write returned wrong data");
  8005d3:	83 ec 04             	sub    $0x4,%esp
  8005d6:	68 80 2e 80 00       	push   $0x802e80
  8005db:	6a 58                	push   $0x58
  8005dd:	68 a5 2b 80 00       	push   $0x802ba5
  8005e2:	e8 89 01 00 00       	call   800770 <_panic>
		panic("open /not-found: %e", r);
  8005e7:	50                   	push   %eax
  8005e8:	68 91 2b 80 00       	push   $0x802b91
  8005ed:	6a 5d                	push   $0x5d
  8005ef:	68 a5 2b 80 00       	push   $0x802ba5
  8005f4:	e8 77 01 00 00       	call   800770 <_panic>
		panic("open /not-found succeeded!");
  8005f9:	83 ec 04             	sub    $0x4,%esp
  8005fc:	68 e0 2c 80 00       	push   $0x802ce0
  800601:	6a 5f                	push   $0x5f
  800603:	68 a5 2b 80 00       	push   $0x802ba5
  800608:	e8 63 01 00 00       	call   800770 <_panic>
		panic("open /newmotd: %e", r);
  80060d:	50                   	push   %eax
  80060e:	68 c4 2b 80 00       	push   $0x802bc4
  800613:	6a 62                	push   $0x62
  800615:	68 a5 2b 80 00       	push   $0x802ba5
  80061a:	e8 51 01 00 00       	call   800770 <_panic>
		panic("open did not fill struct Fd correctly\n");
  80061f:	83 ec 04             	sub    $0x4,%esp
  800622:	68 d4 2e 80 00       	push   $0x802ed4
  800627:	6a 65                	push   $0x65
  800629:	68 a5 2b 80 00       	push   $0x802ba5
  80062e:	e8 3d 01 00 00       	call   800770 <_panic>
		panic("creat /big: %e", f);
  800633:	50                   	push   %eax
  800634:	68 00 2d 80 00       	push   $0x802d00
  800639:	6a 6a                	push   $0x6a
  80063b:	68 a5 2b 80 00       	push   $0x802ba5
  800640:	e8 2b 01 00 00       	call   800770 <_panic>
			panic("write /big@%d: %e", i, r);
  800645:	83 ec 0c             	sub    $0xc,%esp
  800648:	50                   	push   %eax
  800649:	56                   	push   %esi
  80064a:	68 0f 2d 80 00       	push   $0x802d0f
  80064f:	6a 6f                	push   $0x6f
  800651:	68 a5 2b 80 00       	push   $0x802ba5
  800656:	e8 15 01 00 00       	call   800770 <_panic>
		panic("open /big: %e", f);
  80065b:	50                   	push   %eax
  80065c:	68 21 2d 80 00       	push   $0x802d21
  800661:	6a 74                	push   $0x74
  800663:	68 a5 2b 80 00       	push   $0x802ba5
  800668:	e8 03 01 00 00       	call   800770 <_panic>
			panic("read /big@%d: %e", i, r);
  80066d:	83 ec 0c             	sub    $0xc,%esp
  800670:	50                   	push   %eax
  800671:	53                   	push   %ebx
  800672:	68 2f 2d 80 00       	push   $0x802d2f
  800677:	6a 78                	push   $0x78
  800679:	68 a5 2b 80 00       	push   $0x802ba5
  80067e:	e8 ed 00 00 00       	call   800770 <_panic>
			panic("read /big from %d returned %d < %d bytes",
  800683:	83 ec 08             	sub    $0x8,%esp
  800686:	68 00 02 00 00       	push   $0x200
  80068b:	50                   	push   %eax
  80068c:	53                   	push   %ebx
  80068d:	68 fc 2e 80 00       	push   $0x802efc
  800692:	6a 7b                	push   $0x7b
  800694:	68 a5 2b 80 00       	push   $0x802ba5
  800699:	e8 d2 00 00 00       	call   800770 <_panic>
			panic("read /big from %d returned bad data %d",
  80069e:	83 ec 0c             	sub    $0xc,%esp
  8006a1:	50                   	push   %eax
  8006a2:	53                   	push   %ebx
  8006a3:	68 28 2f 80 00       	push   $0x802f28
  8006a8:	6a 7e                	push   $0x7e
  8006aa:	68 a5 2b 80 00       	push   $0x802ba5
  8006af:	e8 bc 00 00 00       	call   800770 <_panic>

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
  8006c7:	e8 ad 0c 00 00       	call   801379 <sys_getenvid>
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

	cprintf("in libmain.c call umain!\n");
  80072b:	83 ec 0c             	sub    $0xc,%esp
  80072e:	68 76 2f 80 00       	push   $0x802f76
  800733:	e8 2e 01 00 00       	call   800866 <cprintf>
	// call user main routine
	umain(argc, argv);
  800738:	83 c4 08             	add    $0x8,%esp
  80073b:	ff 75 0c             	pushl  0xc(%ebp)
  80073e:	ff 75 08             	pushl  0x8(%ebp)
  800741:	e8 38 f9 ff ff       	call   80007e <umain>

	// exit gracefully
	exit();
  800746:	e8 0b 00 00 00       	call   800756 <exit>
}
  80074b:	83 c4 10             	add    $0x10,%esp
  80074e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800751:	5b                   	pop    %ebx
  800752:	5e                   	pop    %esi
  800753:	5f                   	pop    %edi
  800754:	5d                   	pop    %ebp
  800755:	c3                   	ret    

00800756 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800756:	55                   	push   %ebp
  800757:	89 e5                	mov    %esp,%ebp
  800759:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80075c:	e8 ff 11 00 00       	call   801960 <close_all>
	sys_env_destroy(0);
  800761:	83 ec 0c             	sub    $0xc,%esp
  800764:	6a 00                	push   $0x0
  800766:	e8 cd 0b 00 00       	call   801338 <sys_env_destroy>
}
  80076b:	83 c4 10             	add    $0x10,%esp
  80076e:	c9                   	leave  
  80076f:	c3                   	ret    

00800770 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800770:	55                   	push   %ebp
  800771:	89 e5                	mov    %esp,%ebp
  800773:	56                   	push   %esi
  800774:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800775:	a1 08 50 80 00       	mov    0x805008,%eax
  80077a:	8b 40 48             	mov    0x48(%eax),%eax
  80077d:	83 ec 04             	sub    $0x4,%esp
  800780:	68 cc 2f 80 00       	push   $0x802fcc
  800785:	50                   	push   %eax
  800786:	68 9a 2f 80 00       	push   $0x802f9a
  80078b:	e8 d6 00 00 00       	call   800866 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800790:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800793:	8b 35 04 40 80 00    	mov    0x804004,%esi
  800799:	e8 db 0b 00 00       	call   801379 <sys_getenvid>
  80079e:	83 c4 04             	add    $0x4,%esp
  8007a1:	ff 75 0c             	pushl  0xc(%ebp)
  8007a4:	ff 75 08             	pushl  0x8(%ebp)
  8007a7:	56                   	push   %esi
  8007a8:	50                   	push   %eax
  8007a9:	68 a8 2f 80 00       	push   $0x802fa8
  8007ae:	e8 b3 00 00 00       	call   800866 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8007b3:	83 c4 18             	add    $0x18,%esp
  8007b6:	53                   	push   %ebx
  8007b7:	ff 75 10             	pushl  0x10(%ebp)
  8007ba:	e8 56 00 00 00       	call   800815 <vcprintf>
	cprintf("\n");
  8007bf:	c7 04 24 82 2c 80 00 	movl   $0x802c82,(%esp)
  8007c6:	e8 9b 00 00 00       	call   800866 <cprintf>
  8007cb:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8007ce:	cc                   	int3   
  8007cf:	eb fd                	jmp    8007ce <_panic+0x5e>

008007d1 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8007d1:	55                   	push   %ebp
  8007d2:	89 e5                	mov    %esp,%ebp
  8007d4:	53                   	push   %ebx
  8007d5:	83 ec 04             	sub    $0x4,%esp
  8007d8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8007db:	8b 13                	mov    (%ebx),%edx
  8007dd:	8d 42 01             	lea    0x1(%edx),%eax
  8007e0:	89 03                	mov    %eax,(%ebx)
  8007e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007e5:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8007e9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8007ee:	74 09                	je     8007f9 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8007f0:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8007f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007f7:	c9                   	leave  
  8007f8:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8007f9:	83 ec 08             	sub    $0x8,%esp
  8007fc:	68 ff 00 00 00       	push   $0xff
  800801:	8d 43 08             	lea    0x8(%ebx),%eax
  800804:	50                   	push   %eax
  800805:	e8 f1 0a 00 00       	call   8012fb <sys_cputs>
		b->idx = 0;
  80080a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800810:	83 c4 10             	add    $0x10,%esp
  800813:	eb db                	jmp    8007f0 <putch+0x1f>

00800815 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800815:	55                   	push   %ebp
  800816:	89 e5                	mov    %esp,%ebp
  800818:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80081e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800825:	00 00 00 
	b.cnt = 0;
  800828:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80082f:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800832:	ff 75 0c             	pushl  0xc(%ebp)
  800835:	ff 75 08             	pushl  0x8(%ebp)
  800838:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80083e:	50                   	push   %eax
  80083f:	68 d1 07 80 00       	push   $0x8007d1
  800844:	e8 4a 01 00 00       	call   800993 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800849:	83 c4 08             	add    $0x8,%esp
  80084c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800852:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800858:	50                   	push   %eax
  800859:	e8 9d 0a 00 00       	call   8012fb <sys_cputs>

	return b.cnt;
}
  80085e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800864:	c9                   	leave  
  800865:	c3                   	ret    

00800866 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800866:	55                   	push   %ebp
  800867:	89 e5                	mov    %esp,%ebp
  800869:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80086c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80086f:	50                   	push   %eax
  800870:	ff 75 08             	pushl  0x8(%ebp)
  800873:	e8 9d ff ff ff       	call   800815 <vcprintf>
	va_end(ap);

	return cnt;
}
  800878:	c9                   	leave  
  800879:	c3                   	ret    

0080087a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80087a:	55                   	push   %ebp
  80087b:	89 e5                	mov    %esp,%ebp
  80087d:	57                   	push   %edi
  80087e:	56                   	push   %esi
  80087f:	53                   	push   %ebx
  800880:	83 ec 1c             	sub    $0x1c,%esp
  800883:	89 c6                	mov    %eax,%esi
  800885:	89 d7                	mov    %edx,%edi
  800887:	8b 45 08             	mov    0x8(%ebp),%eax
  80088a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80088d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800890:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800893:	8b 45 10             	mov    0x10(%ebp),%eax
  800896:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800899:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80089d:	74 2c                	je     8008cb <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80089f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008a2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8008a9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008ac:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8008af:	39 c2                	cmp    %eax,%edx
  8008b1:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8008b4:	73 43                	jae    8008f9 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8008b6:	83 eb 01             	sub    $0x1,%ebx
  8008b9:	85 db                	test   %ebx,%ebx
  8008bb:	7e 6c                	jle    800929 <printnum+0xaf>
				putch(padc, putdat);
  8008bd:	83 ec 08             	sub    $0x8,%esp
  8008c0:	57                   	push   %edi
  8008c1:	ff 75 18             	pushl  0x18(%ebp)
  8008c4:	ff d6                	call   *%esi
  8008c6:	83 c4 10             	add    $0x10,%esp
  8008c9:	eb eb                	jmp    8008b6 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8008cb:	83 ec 0c             	sub    $0xc,%esp
  8008ce:	6a 20                	push   $0x20
  8008d0:	6a 00                	push   $0x0
  8008d2:	50                   	push   %eax
  8008d3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8008d6:	ff 75 e0             	pushl  -0x20(%ebp)
  8008d9:	89 fa                	mov    %edi,%edx
  8008db:	89 f0                	mov    %esi,%eax
  8008dd:	e8 98 ff ff ff       	call   80087a <printnum>
		while (--width > 0)
  8008e2:	83 c4 20             	add    $0x20,%esp
  8008e5:	83 eb 01             	sub    $0x1,%ebx
  8008e8:	85 db                	test   %ebx,%ebx
  8008ea:	7e 65                	jle    800951 <printnum+0xd7>
			putch(padc, putdat);
  8008ec:	83 ec 08             	sub    $0x8,%esp
  8008ef:	57                   	push   %edi
  8008f0:	6a 20                	push   $0x20
  8008f2:	ff d6                	call   *%esi
  8008f4:	83 c4 10             	add    $0x10,%esp
  8008f7:	eb ec                	jmp    8008e5 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8008f9:	83 ec 0c             	sub    $0xc,%esp
  8008fc:	ff 75 18             	pushl  0x18(%ebp)
  8008ff:	83 eb 01             	sub    $0x1,%ebx
  800902:	53                   	push   %ebx
  800903:	50                   	push   %eax
  800904:	83 ec 08             	sub    $0x8,%esp
  800907:	ff 75 dc             	pushl  -0x24(%ebp)
  80090a:	ff 75 d8             	pushl  -0x28(%ebp)
  80090d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800910:	ff 75 e0             	pushl  -0x20(%ebp)
  800913:	e8 08 20 00 00       	call   802920 <__udivdi3>
  800918:	83 c4 18             	add    $0x18,%esp
  80091b:	52                   	push   %edx
  80091c:	50                   	push   %eax
  80091d:	89 fa                	mov    %edi,%edx
  80091f:	89 f0                	mov    %esi,%eax
  800921:	e8 54 ff ff ff       	call   80087a <printnum>
  800926:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800929:	83 ec 08             	sub    $0x8,%esp
  80092c:	57                   	push   %edi
  80092d:	83 ec 04             	sub    $0x4,%esp
  800930:	ff 75 dc             	pushl  -0x24(%ebp)
  800933:	ff 75 d8             	pushl  -0x28(%ebp)
  800936:	ff 75 e4             	pushl  -0x1c(%ebp)
  800939:	ff 75 e0             	pushl  -0x20(%ebp)
  80093c:	e8 ef 20 00 00       	call   802a30 <__umoddi3>
  800941:	83 c4 14             	add    $0x14,%esp
  800944:	0f be 80 d3 2f 80 00 	movsbl 0x802fd3(%eax),%eax
  80094b:	50                   	push   %eax
  80094c:	ff d6                	call   *%esi
  80094e:	83 c4 10             	add    $0x10,%esp
	}
}
  800951:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800954:	5b                   	pop    %ebx
  800955:	5e                   	pop    %esi
  800956:	5f                   	pop    %edi
  800957:	5d                   	pop    %ebp
  800958:	c3                   	ret    

00800959 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800959:	55                   	push   %ebp
  80095a:	89 e5                	mov    %esp,%ebp
  80095c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80095f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800963:	8b 10                	mov    (%eax),%edx
  800965:	3b 50 04             	cmp    0x4(%eax),%edx
  800968:	73 0a                	jae    800974 <sprintputch+0x1b>
		*b->buf++ = ch;
  80096a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80096d:	89 08                	mov    %ecx,(%eax)
  80096f:	8b 45 08             	mov    0x8(%ebp),%eax
  800972:	88 02                	mov    %al,(%edx)
}
  800974:	5d                   	pop    %ebp
  800975:	c3                   	ret    

00800976 <printfmt>:
{
  800976:	55                   	push   %ebp
  800977:	89 e5                	mov    %esp,%ebp
  800979:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80097c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80097f:	50                   	push   %eax
  800980:	ff 75 10             	pushl  0x10(%ebp)
  800983:	ff 75 0c             	pushl  0xc(%ebp)
  800986:	ff 75 08             	pushl  0x8(%ebp)
  800989:	e8 05 00 00 00       	call   800993 <vprintfmt>
}
  80098e:	83 c4 10             	add    $0x10,%esp
  800991:	c9                   	leave  
  800992:	c3                   	ret    

00800993 <vprintfmt>:
{
  800993:	55                   	push   %ebp
  800994:	89 e5                	mov    %esp,%ebp
  800996:	57                   	push   %edi
  800997:	56                   	push   %esi
  800998:	53                   	push   %ebx
  800999:	83 ec 3c             	sub    $0x3c,%esp
  80099c:	8b 75 08             	mov    0x8(%ebp),%esi
  80099f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8009a2:	8b 7d 10             	mov    0x10(%ebp),%edi
  8009a5:	e9 32 04 00 00       	jmp    800ddc <vprintfmt+0x449>
		padc = ' ';
  8009aa:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8009ae:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8009b5:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8009bc:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8009c3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009ca:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8009d1:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8009d6:	8d 47 01             	lea    0x1(%edi),%eax
  8009d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009dc:	0f b6 17             	movzbl (%edi),%edx
  8009df:	8d 42 dd             	lea    -0x23(%edx),%eax
  8009e2:	3c 55                	cmp    $0x55,%al
  8009e4:	0f 87 12 05 00 00    	ja     800efc <vprintfmt+0x569>
  8009ea:	0f b6 c0             	movzbl %al,%eax
  8009ed:	ff 24 85 c0 31 80 00 	jmp    *0x8031c0(,%eax,4)
  8009f4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8009f7:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8009fb:	eb d9                	jmp    8009d6 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8009fd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800a00:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800a04:	eb d0                	jmp    8009d6 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800a06:	0f b6 d2             	movzbl %dl,%edx
  800a09:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800a0c:	b8 00 00 00 00       	mov    $0x0,%eax
  800a11:	89 75 08             	mov    %esi,0x8(%ebp)
  800a14:	eb 03                	jmp    800a19 <vprintfmt+0x86>
  800a16:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800a19:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800a1c:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800a20:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800a23:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a26:	83 fe 09             	cmp    $0x9,%esi
  800a29:	76 eb                	jbe    800a16 <vprintfmt+0x83>
  800a2b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a2e:	8b 75 08             	mov    0x8(%ebp),%esi
  800a31:	eb 14                	jmp    800a47 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800a33:	8b 45 14             	mov    0x14(%ebp),%eax
  800a36:	8b 00                	mov    (%eax),%eax
  800a38:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a3b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3e:	8d 40 04             	lea    0x4(%eax),%eax
  800a41:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800a44:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800a47:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a4b:	79 89                	jns    8009d6 <vprintfmt+0x43>
				width = precision, precision = -1;
  800a4d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a50:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a53:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800a5a:	e9 77 ff ff ff       	jmp    8009d6 <vprintfmt+0x43>
  800a5f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a62:	85 c0                	test   %eax,%eax
  800a64:	0f 48 c1             	cmovs  %ecx,%eax
  800a67:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800a6a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800a6d:	e9 64 ff ff ff       	jmp    8009d6 <vprintfmt+0x43>
  800a72:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800a75:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800a7c:	e9 55 ff ff ff       	jmp    8009d6 <vprintfmt+0x43>
			lflag++;
  800a81:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800a85:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800a88:	e9 49 ff ff ff       	jmp    8009d6 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800a8d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a90:	8d 78 04             	lea    0x4(%eax),%edi
  800a93:	83 ec 08             	sub    $0x8,%esp
  800a96:	53                   	push   %ebx
  800a97:	ff 30                	pushl  (%eax)
  800a99:	ff d6                	call   *%esi
			break;
  800a9b:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800a9e:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800aa1:	e9 33 03 00 00       	jmp    800dd9 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800aa6:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa9:	8d 78 04             	lea    0x4(%eax),%edi
  800aac:	8b 00                	mov    (%eax),%eax
  800aae:	99                   	cltd   
  800aaf:	31 d0                	xor    %edx,%eax
  800ab1:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800ab3:	83 f8 10             	cmp    $0x10,%eax
  800ab6:	7f 23                	jg     800adb <vprintfmt+0x148>
  800ab8:	8b 14 85 20 33 80 00 	mov    0x803320(,%eax,4),%edx
  800abf:	85 d2                	test   %edx,%edx
  800ac1:	74 18                	je     800adb <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800ac3:	52                   	push   %edx
  800ac4:	68 5d 34 80 00       	push   $0x80345d
  800ac9:	53                   	push   %ebx
  800aca:	56                   	push   %esi
  800acb:	e8 a6 fe ff ff       	call   800976 <printfmt>
  800ad0:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800ad3:	89 7d 14             	mov    %edi,0x14(%ebp)
  800ad6:	e9 fe 02 00 00       	jmp    800dd9 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800adb:	50                   	push   %eax
  800adc:	68 eb 2f 80 00       	push   $0x802feb
  800ae1:	53                   	push   %ebx
  800ae2:	56                   	push   %esi
  800ae3:	e8 8e fe ff ff       	call   800976 <printfmt>
  800ae8:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800aeb:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800aee:	e9 e6 02 00 00       	jmp    800dd9 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800af3:	8b 45 14             	mov    0x14(%ebp),%eax
  800af6:	83 c0 04             	add    $0x4,%eax
  800af9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800afc:	8b 45 14             	mov    0x14(%ebp),%eax
  800aff:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800b01:	85 c9                	test   %ecx,%ecx
  800b03:	b8 e4 2f 80 00       	mov    $0x802fe4,%eax
  800b08:	0f 45 c1             	cmovne %ecx,%eax
  800b0b:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800b0e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b12:	7e 06                	jle    800b1a <vprintfmt+0x187>
  800b14:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800b18:	75 0d                	jne    800b27 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b1a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800b1d:	89 c7                	mov    %eax,%edi
  800b1f:	03 45 e0             	add    -0x20(%ebp),%eax
  800b22:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800b25:	eb 53                	jmp    800b7a <vprintfmt+0x1e7>
  800b27:	83 ec 08             	sub    $0x8,%esp
  800b2a:	ff 75 d8             	pushl  -0x28(%ebp)
  800b2d:	50                   	push   %eax
  800b2e:	e8 71 04 00 00       	call   800fa4 <strnlen>
  800b33:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800b36:	29 c1                	sub    %eax,%ecx
  800b38:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800b3b:	83 c4 10             	add    $0x10,%esp
  800b3e:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800b40:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800b44:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800b47:	eb 0f                	jmp    800b58 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800b49:	83 ec 08             	sub    $0x8,%esp
  800b4c:	53                   	push   %ebx
  800b4d:	ff 75 e0             	pushl  -0x20(%ebp)
  800b50:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800b52:	83 ef 01             	sub    $0x1,%edi
  800b55:	83 c4 10             	add    $0x10,%esp
  800b58:	85 ff                	test   %edi,%edi
  800b5a:	7f ed                	jg     800b49 <vprintfmt+0x1b6>
  800b5c:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800b5f:	85 c9                	test   %ecx,%ecx
  800b61:	b8 00 00 00 00       	mov    $0x0,%eax
  800b66:	0f 49 c1             	cmovns %ecx,%eax
  800b69:	29 c1                	sub    %eax,%ecx
  800b6b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800b6e:	eb aa                	jmp    800b1a <vprintfmt+0x187>
					putch(ch, putdat);
  800b70:	83 ec 08             	sub    $0x8,%esp
  800b73:	53                   	push   %ebx
  800b74:	52                   	push   %edx
  800b75:	ff d6                	call   *%esi
  800b77:	83 c4 10             	add    $0x10,%esp
  800b7a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800b7d:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b7f:	83 c7 01             	add    $0x1,%edi
  800b82:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800b86:	0f be d0             	movsbl %al,%edx
  800b89:	85 d2                	test   %edx,%edx
  800b8b:	74 4b                	je     800bd8 <vprintfmt+0x245>
  800b8d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800b91:	78 06                	js     800b99 <vprintfmt+0x206>
  800b93:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800b97:	78 1e                	js     800bb7 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800b99:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800b9d:	74 d1                	je     800b70 <vprintfmt+0x1dd>
  800b9f:	0f be c0             	movsbl %al,%eax
  800ba2:	83 e8 20             	sub    $0x20,%eax
  800ba5:	83 f8 5e             	cmp    $0x5e,%eax
  800ba8:	76 c6                	jbe    800b70 <vprintfmt+0x1dd>
					putch('?', putdat);
  800baa:	83 ec 08             	sub    $0x8,%esp
  800bad:	53                   	push   %ebx
  800bae:	6a 3f                	push   $0x3f
  800bb0:	ff d6                	call   *%esi
  800bb2:	83 c4 10             	add    $0x10,%esp
  800bb5:	eb c3                	jmp    800b7a <vprintfmt+0x1e7>
  800bb7:	89 cf                	mov    %ecx,%edi
  800bb9:	eb 0e                	jmp    800bc9 <vprintfmt+0x236>
				putch(' ', putdat);
  800bbb:	83 ec 08             	sub    $0x8,%esp
  800bbe:	53                   	push   %ebx
  800bbf:	6a 20                	push   $0x20
  800bc1:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800bc3:	83 ef 01             	sub    $0x1,%edi
  800bc6:	83 c4 10             	add    $0x10,%esp
  800bc9:	85 ff                	test   %edi,%edi
  800bcb:	7f ee                	jg     800bbb <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800bcd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800bd0:	89 45 14             	mov    %eax,0x14(%ebp)
  800bd3:	e9 01 02 00 00       	jmp    800dd9 <vprintfmt+0x446>
  800bd8:	89 cf                	mov    %ecx,%edi
  800bda:	eb ed                	jmp    800bc9 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800bdc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800bdf:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800be6:	e9 eb fd ff ff       	jmp    8009d6 <vprintfmt+0x43>
	if (lflag >= 2)
  800beb:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800bef:	7f 21                	jg     800c12 <vprintfmt+0x27f>
	else if (lflag)
  800bf1:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800bf5:	74 68                	je     800c5f <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800bf7:	8b 45 14             	mov    0x14(%ebp),%eax
  800bfa:	8b 00                	mov    (%eax),%eax
  800bfc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800bff:	89 c1                	mov    %eax,%ecx
  800c01:	c1 f9 1f             	sar    $0x1f,%ecx
  800c04:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800c07:	8b 45 14             	mov    0x14(%ebp),%eax
  800c0a:	8d 40 04             	lea    0x4(%eax),%eax
  800c0d:	89 45 14             	mov    %eax,0x14(%ebp)
  800c10:	eb 17                	jmp    800c29 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800c12:	8b 45 14             	mov    0x14(%ebp),%eax
  800c15:	8b 50 04             	mov    0x4(%eax),%edx
  800c18:	8b 00                	mov    (%eax),%eax
  800c1a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800c1d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800c20:	8b 45 14             	mov    0x14(%ebp),%eax
  800c23:	8d 40 08             	lea    0x8(%eax),%eax
  800c26:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800c29:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800c2c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800c2f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c32:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800c35:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800c39:	78 3f                	js     800c7a <vprintfmt+0x2e7>
			base = 10;
  800c3b:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800c40:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800c44:	0f 84 71 01 00 00    	je     800dbb <vprintfmt+0x428>
				putch('+', putdat);
  800c4a:	83 ec 08             	sub    $0x8,%esp
  800c4d:	53                   	push   %ebx
  800c4e:	6a 2b                	push   $0x2b
  800c50:	ff d6                	call   *%esi
  800c52:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800c55:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c5a:	e9 5c 01 00 00       	jmp    800dbb <vprintfmt+0x428>
		return va_arg(*ap, int);
  800c5f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c62:	8b 00                	mov    (%eax),%eax
  800c64:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800c67:	89 c1                	mov    %eax,%ecx
  800c69:	c1 f9 1f             	sar    $0x1f,%ecx
  800c6c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800c6f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c72:	8d 40 04             	lea    0x4(%eax),%eax
  800c75:	89 45 14             	mov    %eax,0x14(%ebp)
  800c78:	eb af                	jmp    800c29 <vprintfmt+0x296>
				putch('-', putdat);
  800c7a:	83 ec 08             	sub    $0x8,%esp
  800c7d:	53                   	push   %ebx
  800c7e:	6a 2d                	push   $0x2d
  800c80:	ff d6                	call   *%esi
				num = -(long long) num;
  800c82:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800c85:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800c88:	f7 d8                	neg    %eax
  800c8a:	83 d2 00             	adc    $0x0,%edx
  800c8d:	f7 da                	neg    %edx
  800c8f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c92:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c95:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800c98:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c9d:	e9 19 01 00 00       	jmp    800dbb <vprintfmt+0x428>
	if (lflag >= 2)
  800ca2:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800ca6:	7f 29                	jg     800cd1 <vprintfmt+0x33e>
	else if (lflag)
  800ca8:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800cac:	74 44                	je     800cf2 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
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
  800ccc:	e9 ea 00 00 00       	jmp    800dbb <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800cd1:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd4:	8b 50 04             	mov    0x4(%eax),%edx
  800cd7:	8b 00                	mov    (%eax),%eax
  800cd9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800cdc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800cdf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce2:	8d 40 08             	lea    0x8(%eax),%eax
  800ce5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800ce8:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ced:	e9 c9 00 00 00       	jmp    800dbb <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800cf2:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf5:	8b 00                	mov    (%eax),%eax
  800cf7:	ba 00 00 00 00       	mov    $0x0,%edx
  800cfc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800cff:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800d02:	8b 45 14             	mov    0x14(%ebp),%eax
  800d05:	8d 40 04             	lea    0x4(%eax),%eax
  800d08:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800d0b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d10:	e9 a6 00 00 00       	jmp    800dbb <vprintfmt+0x428>
			putch('0', putdat);
  800d15:	83 ec 08             	sub    $0x8,%esp
  800d18:	53                   	push   %ebx
  800d19:	6a 30                	push   $0x30
  800d1b:	ff d6                	call   *%esi
	if (lflag >= 2)
  800d1d:	83 c4 10             	add    $0x10,%esp
  800d20:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800d24:	7f 26                	jg     800d4c <vprintfmt+0x3b9>
	else if (lflag)
  800d26:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800d2a:	74 3e                	je     800d6a <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800d2c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d2f:	8b 00                	mov    (%eax),%eax
  800d31:	ba 00 00 00 00       	mov    $0x0,%edx
  800d36:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d39:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800d3c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d3f:	8d 40 04             	lea    0x4(%eax),%eax
  800d42:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800d45:	b8 08 00 00 00       	mov    $0x8,%eax
  800d4a:	eb 6f                	jmp    800dbb <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800d4c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d4f:	8b 50 04             	mov    0x4(%eax),%edx
  800d52:	8b 00                	mov    (%eax),%eax
  800d54:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d57:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800d5a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d5d:	8d 40 08             	lea    0x8(%eax),%eax
  800d60:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800d63:	b8 08 00 00 00       	mov    $0x8,%eax
  800d68:	eb 51                	jmp    800dbb <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800d6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d6d:	8b 00                	mov    (%eax),%eax
  800d6f:	ba 00 00 00 00       	mov    $0x0,%edx
  800d74:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d77:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800d7a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d7d:	8d 40 04             	lea    0x4(%eax),%eax
  800d80:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800d83:	b8 08 00 00 00       	mov    $0x8,%eax
  800d88:	eb 31                	jmp    800dbb <vprintfmt+0x428>
			putch('0', putdat);
  800d8a:	83 ec 08             	sub    $0x8,%esp
  800d8d:	53                   	push   %ebx
  800d8e:	6a 30                	push   $0x30
  800d90:	ff d6                	call   *%esi
			putch('x', putdat);
  800d92:	83 c4 08             	add    $0x8,%esp
  800d95:	53                   	push   %ebx
  800d96:	6a 78                	push   $0x78
  800d98:	ff d6                	call   *%esi
			num = (unsigned long long)
  800d9a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d9d:	8b 00                	mov    (%eax),%eax
  800d9f:	ba 00 00 00 00       	mov    $0x0,%edx
  800da4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800da7:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800daa:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800dad:	8b 45 14             	mov    0x14(%ebp),%eax
  800db0:	8d 40 04             	lea    0x4(%eax),%eax
  800db3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800db6:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800dbb:	83 ec 0c             	sub    $0xc,%esp
  800dbe:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800dc2:	52                   	push   %edx
  800dc3:	ff 75 e0             	pushl  -0x20(%ebp)
  800dc6:	50                   	push   %eax
  800dc7:	ff 75 dc             	pushl  -0x24(%ebp)
  800dca:	ff 75 d8             	pushl  -0x28(%ebp)
  800dcd:	89 da                	mov    %ebx,%edx
  800dcf:	89 f0                	mov    %esi,%eax
  800dd1:	e8 a4 fa ff ff       	call   80087a <printnum>
			break;
  800dd6:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800dd9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ddc:	83 c7 01             	add    $0x1,%edi
  800ddf:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800de3:	83 f8 25             	cmp    $0x25,%eax
  800de6:	0f 84 be fb ff ff    	je     8009aa <vprintfmt+0x17>
			if (ch == '\0')
  800dec:	85 c0                	test   %eax,%eax
  800dee:	0f 84 28 01 00 00    	je     800f1c <vprintfmt+0x589>
			putch(ch, putdat);
  800df4:	83 ec 08             	sub    $0x8,%esp
  800df7:	53                   	push   %ebx
  800df8:	50                   	push   %eax
  800df9:	ff d6                	call   *%esi
  800dfb:	83 c4 10             	add    $0x10,%esp
  800dfe:	eb dc                	jmp    800ddc <vprintfmt+0x449>
	if (lflag >= 2)
  800e00:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800e04:	7f 26                	jg     800e2c <vprintfmt+0x499>
	else if (lflag)
  800e06:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800e0a:	74 41                	je     800e4d <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800e0c:	8b 45 14             	mov    0x14(%ebp),%eax
  800e0f:	8b 00                	mov    (%eax),%eax
  800e11:	ba 00 00 00 00       	mov    $0x0,%edx
  800e16:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800e19:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800e1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800e1f:	8d 40 04             	lea    0x4(%eax),%eax
  800e22:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800e25:	b8 10 00 00 00       	mov    $0x10,%eax
  800e2a:	eb 8f                	jmp    800dbb <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800e2c:	8b 45 14             	mov    0x14(%ebp),%eax
  800e2f:	8b 50 04             	mov    0x4(%eax),%edx
  800e32:	8b 00                	mov    (%eax),%eax
  800e34:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800e37:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800e3a:	8b 45 14             	mov    0x14(%ebp),%eax
  800e3d:	8d 40 08             	lea    0x8(%eax),%eax
  800e40:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800e43:	b8 10 00 00 00       	mov    $0x10,%eax
  800e48:	e9 6e ff ff ff       	jmp    800dbb <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800e4d:	8b 45 14             	mov    0x14(%ebp),%eax
  800e50:	8b 00                	mov    (%eax),%eax
  800e52:	ba 00 00 00 00       	mov    $0x0,%edx
  800e57:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800e5a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800e5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800e60:	8d 40 04             	lea    0x4(%eax),%eax
  800e63:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800e66:	b8 10 00 00 00       	mov    $0x10,%eax
  800e6b:	e9 4b ff ff ff       	jmp    800dbb <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800e70:	8b 45 14             	mov    0x14(%ebp),%eax
  800e73:	83 c0 04             	add    $0x4,%eax
  800e76:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800e79:	8b 45 14             	mov    0x14(%ebp),%eax
  800e7c:	8b 00                	mov    (%eax),%eax
  800e7e:	85 c0                	test   %eax,%eax
  800e80:	74 14                	je     800e96 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800e82:	8b 13                	mov    (%ebx),%edx
  800e84:	83 fa 7f             	cmp    $0x7f,%edx
  800e87:	7f 37                	jg     800ec0 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800e89:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800e8b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800e8e:	89 45 14             	mov    %eax,0x14(%ebp)
  800e91:	e9 43 ff ff ff       	jmp    800dd9 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800e96:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e9b:	bf 09 31 80 00       	mov    $0x803109,%edi
							putch(ch, putdat);
  800ea0:	83 ec 08             	sub    $0x8,%esp
  800ea3:	53                   	push   %ebx
  800ea4:	50                   	push   %eax
  800ea5:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800ea7:	83 c7 01             	add    $0x1,%edi
  800eaa:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800eae:	83 c4 10             	add    $0x10,%esp
  800eb1:	85 c0                	test   %eax,%eax
  800eb3:	75 eb                	jne    800ea0 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800eb5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800eb8:	89 45 14             	mov    %eax,0x14(%ebp)
  800ebb:	e9 19 ff ff ff       	jmp    800dd9 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800ec0:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800ec2:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ec7:	bf 41 31 80 00       	mov    $0x803141,%edi
							putch(ch, putdat);
  800ecc:	83 ec 08             	sub    $0x8,%esp
  800ecf:	53                   	push   %ebx
  800ed0:	50                   	push   %eax
  800ed1:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800ed3:	83 c7 01             	add    $0x1,%edi
  800ed6:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800eda:	83 c4 10             	add    $0x10,%esp
  800edd:	85 c0                	test   %eax,%eax
  800edf:	75 eb                	jne    800ecc <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800ee1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800ee4:	89 45 14             	mov    %eax,0x14(%ebp)
  800ee7:	e9 ed fe ff ff       	jmp    800dd9 <vprintfmt+0x446>
			putch(ch, putdat);
  800eec:	83 ec 08             	sub    $0x8,%esp
  800eef:	53                   	push   %ebx
  800ef0:	6a 25                	push   $0x25
  800ef2:	ff d6                	call   *%esi
			break;
  800ef4:	83 c4 10             	add    $0x10,%esp
  800ef7:	e9 dd fe ff ff       	jmp    800dd9 <vprintfmt+0x446>
			putch('%', putdat);
  800efc:	83 ec 08             	sub    $0x8,%esp
  800eff:	53                   	push   %ebx
  800f00:	6a 25                	push   $0x25
  800f02:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f04:	83 c4 10             	add    $0x10,%esp
  800f07:	89 f8                	mov    %edi,%eax
  800f09:	eb 03                	jmp    800f0e <vprintfmt+0x57b>
  800f0b:	83 e8 01             	sub    $0x1,%eax
  800f0e:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800f12:	75 f7                	jne    800f0b <vprintfmt+0x578>
  800f14:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800f17:	e9 bd fe ff ff       	jmp    800dd9 <vprintfmt+0x446>
}
  800f1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f1f:	5b                   	pop    %ebx
  800f20:	5e                   	pop    %esi
  800f21:	5f                   	pop    %edi
  800f22:	5d                   	pop    %ebp
  800f23:	c3                   	ret    

00800f24 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f24:	55                   	push   %ebp
  800f25:	89 e5                	mov    %esp,%ebp
  800f27:	83 ec 18             	sub    $0x18,%esp
  800f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f30:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800f33:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800f37:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800f3a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800f41:	85 c0                	test   %eax,%eax
  800f43:	74 26                	je     800f6b <vsnprintf+0x47>
  800f45:	85 d2                	test   %edx,%edx
  800f47:	7e 22                	jle    800f6b <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800f49:	ff 75 14             	pushl  0x14(%ebp)
  800f4c:	ff 75 10             	pushl  0x10(%ebp)
  800f4f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800f52:	50                   	push   %eax
  800f53:	68 59 09 80 00       	push   $0x800959
  800f58:	e8 36 fa ff ff       	call   800993 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800f5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f60:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800f63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f66:	83 c4 10             	add    $0x10,%esp
}
  800f69:	c9                   	leave  
  800f6a:	c3                   	ret    
		return -E_INVAL;
  800f6b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f70:	eb f7                	jmp    800f69 <vsnprintf+0x45>

00800f72 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f72:	55                   	push   %ebp
  800f73:	89 e5                	mov    %esp,%ebp
  800f75:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800f78:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800f7b:	50                   	push   %eax
  800f7c:	ff 75 10             	pushl  0x10(%ebp)
  800f7f:	ff 75 0c             	pushl  0xc(%ebp)
  800f82:	ff 75 08             	pushl  0x8(%ebp)
  800f85:	e8 9a ff ff ff       	call   800f24 <vsnprintf>
	va_end(ap);

	return rc;
}
  800f8a:	c9                   	leave  
  800f8b:	c3                   	ret    

00800f8c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800f8c:	55                   	push   %ebp
  800f8d:	89 e5                	mov    %esp,%ebp
  800f8f:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800f92:	b8 00 00 00 00       	mov    $0x0,%eax
  800f97:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800f9b:	74 05                	je     800fa2 <strlen+0x16>
		n++;
  800f9d:	83 c0 01             	add    $0x1,%eax
  800fa0:	eb f5                	jmp    800f97 <strlen+0xb>
	return n;
}
  800fa2:	5d                   	pop    %ebp
  800fa3:	c3                   	ret    

00800fa4 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800fa4:	55                   	push   %ebp
  800fa5:	89 e5                	mov    %esp,%ebp
  800fa7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800faa:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800fad:	ba 00 00 00 00       	mov    $0x0,%edx
  800fb2:	39 c2                	cmp    %eax,%edx
  800fb4:	74 0d                	je     800fc3 <strnlen+0x1f>
  800fb6:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800fba:	74 05                	je     800fc1 <strnlen+0x1d>
		n++;
  800fbc:	83 c2 01             	add    $0x1,%edx
  800fbf:	eb f1                	jmp    800fb2 <strnlen+0xe>
  800fc1:	89 d0                	mov    %edx,%eax
	return n;
}
  800fc3:	5d                   	pop    %ebp
  800fc4:	c3                   	ret    

00800fc5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800fc5:	55                   	push   %ebp
  800fc6:	89 e5                	mov    %esp,%ebp
  800fc8:	53                   	push   %ebx
  800fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800fcf:	ba 00 00 00 00       	mov    $0x0,%edx
  800fd4:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800fd8:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800fdb:	83 c2 01             	add    $0x1,%edx
  800fde:	84 c9                	test   %cl,%cl
  800fe0:	75 f2                	jne    800fd4 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800fe2:	5b                   	pop    %ebx
  800fe3:	5d                   	pop    %ebp
  800fe4:	c3                   	ret    

00800fe5 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800fe5:	55                   	push   %ebp
  800fe6:	89 e5                	mov    %esp,%ebp
  800fe8:	53                   	push   %ebx
  800fe9:	83 ec 10             	sub    $0x10,%esp
  800fec:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800fef:	53                   	push   %ebx
  800ff0:	e8 97 ff ff ff       	call   800f8c <strlen>
  800ff5:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800ff8:	ff 75 0c             	pushl  0xc(%ebp)
  800ffb:	01 d8                	add    %ebx,%eax
  800ffd:	50                   	push   %eax
  800ffe:	e8 c2 ff ff ff       	call   800fc5 <strcpy>
	return dst;
}
  801003:	89 d8                	mov    %ebx,%eax
  801005:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801008:	c9                   	leave  
  801009:	c3                   	ret    

0080100a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80100a:	55                   	push   %ebp
  80100b:	89 e5                	mov    %esp,%ebp
  80100d:	56                   	push   %esi
  80100e:	53                   	push   %ebx
  80100f:	8b 45 08             	mov    0x8(%ebp),%eax
  801012:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801015:	89 c6                	mov    %eax,%esi
  801017:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80101a:	89 c2                	mov    %eax,%edx
  80101c:	39 f2                	cmp    %esi,%edx
  80101e:	74 11                	je     801031 <strncpy+0x27>
		*dst++ = *src;
  801020:	83 c2 01             	add    $0x1,%edx
  801023:	0f b6 19             	movzbl (%ecx),%ebx
  801026:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801029:	80 fb 01             	cmp    $0x1,%bl
  80102c:	83 d9 ff             	sbb    $0xffffffff,%ecx
  80102f:	eb eb                	jmp    80101c <strncpy+0x12>
	}
	return ret;
}
  801031:	5b                   	pop    %ebx
  801032:	5e                   	pop    %esi
  801033:	5d                   	pop    %ebp
  801034:	c3                   	ret    

00801035 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801035:	55                   	push   %ebp
  801036:	89 e5                	mov    %esp,%ebp
  801038:	56                   	push   %esi
  801039:	53                   	push   %ebx
  80103a:	8b 75 08             	mov    0x8(%ebp),%esi
  80103d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801040:	8b 55 10             	mov    0x10(%ebp),%edx
  801043:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801045:	85 d2                	test   %edx,%edx
  801047:	74 21                	je     80106a <strlcpy+0x35>
  801049:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80104d:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80104f:	39 c2                	cmp    %eax,%edx
  801051:	74 14                	je     801067 <strlcpy+0x32>
  801053:	0f b6 19             	movzbl (%ecx),%ebx
  801056:	84 db                	test   %bl,%bl
  801058:	74 0b                	je     801065 <strlcpy+0x30>
			*dst++ = *src++;
  80105a:	83 c1 01             	add    $0x1,%ecx
  80105d:	83 c2 01             	add    $0x1,%edx
  801060:	88 5a ff             	mov    %bl,-0x1(%edx)
  801063:	eb ea                	jmp    80104f <strlcpy+0x1a>
  801065:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801067:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80106a:	29 f0                	sub    %esi,%eax
}
  80106c:	5b                   	pop    %ebx
  80106d:	5e                   	pop    %esi
  80106e:	5d                   	pop    %ebp
  80106f:	c3                   	ret    

00801070 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801070:	55                   	push   %ebp
  801071:	89 e5                	mov    %esp,%ebp
  801073:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801076:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801079:	0f b6 01             	movzbl (%ecx),%eax
  80107c:	84 c0                	test   %al,%al
  80107e:	74 0c                	je     80108c <strcmp+0x1c>
  801080:	3a 02                	cmp    (%edx),%al
  801082:	75 08                	jne    80108c <strcmp+0x1c>
		p++, q++;
  801084:	83 c1 01             	add    $0x1,%ecx
  801087:	83 c2 01             	add    $0x1,%edx
  80108a:	eb ed                	jmp    801079 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80108c:	0f b6 c0             	movzbl %al,%eax
  80108f:	0f b6 12             	movzbl (%edx),%edx
  801092:	29 d0                	sub    %edx,%eax
}
  801094:	5d                   	pop    %ebp
  801095:	c3                   	ret    

00801096 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801096:	55                   	push   %ebp
  801097:	89 e5                	mov    %esp,%ebp
  801099:	53                   	push   %ebx
  80109a:	8b 45 08             	mov    0x8(%ebp),%eax
  80109d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010a0:	89 c3                	mov    %eax,%ebx
  8010a2:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8010a5:	eb 06                	jmp    8010ad <strncmp+0x17>
		n--, p++, q++;
  8010a7:	83 c0 01             	add    $0x1,%eax
  8010aa:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8010ad:	39 d8                	cmp    %ebx,%eax
  8010af:	74 16                	je     8010c7 <strncmp+0x31>
  8010b1:	0f b6 08             	movzbl (%eax),%ecx
  8010b4:	84 c9                	test   %cl,%cl
  8010b6:	74 04                	je     8010bc <strncmp+0x26>
  8010b8:	3a 0a                	cmp    (%edx),%cl
  8010ba:	74 eb                	je     8010a7 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8010bc:	0f b6 00             	movzbl (%eax),%eax
  8010bf:	0f b6 12             	movzbl (%edx),%edx
  8010c2:	29 d0                	sub    %edx,%eax
}
  8010c4:	5b                   	pop    %ebx
  8010c5:	5d                   	pop    %ebp
  8010c6:	c3                   	ret    
		return 0;
  8010c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8010cc:	eb f6                	jmp    8010c4 <strncmp+0x2e>

008010ce <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8010ce:	55                   	push   %ebp
  8010cf:	89 e5                	mov    %esp,%ebp
  8010d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8010d8:	0f b6 10             	movzbl (%eax),%edx
  8010db:	84 d2                	test   %dl,%dl
  8010dd:	74 09                	je     8010e8 <strchr+0x1a>
		if (*s == c)
  8010df:	38 ca                	cmp    %cl,%dl
  8010e1:	74 0a                	je     8010ed <strchr+0x1f>
	for (; *s; s++)
  8010e3:	83 c0 01             	add    $0x1,%eax
  8010e6:	eb f0                	jmp    8010d8 <strchr+0xa>
			return (char *) s;
	return 0;
  8010e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010ed:	5d                   	pop    %ebp
  8010ee:	c3                   	ret    

008010ef <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8010ef:	55                   	push   %ebp
  8010f0:	89 e5                	mov    %esp,%ebp
  8010f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8010f9:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8010fc:	38 ca                	cmp    %cl,%dl
  8010fe:	74 09                	je     801109 <strfind+0x1a>
  801100:	84 d2                	test   %dl,%dl
  801102:	74 05                	je     801109 <strfind+0x1a>
	for (; *s; s++)
  801104:	83 c0 01             	add    $0x1,%eax
  801107:	eb f0                	jmp    8010f9 <strfind+0xa>
			break;
	return (char *) s;
}
  801109:	5d                   	pop    %ebp
  80110a:	c3                   	ret    

0080110b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80110b:	55                   	push   %ebp
  80110c:	89 e5                	mov    %esp,%ebp
  80110e:	57                   	push   %edi
  80110f:	56                   	push   %esi
  801110:	53                   	push   %ebx
  801111:	8b 7d 08             	mov    0x8(%ebp),%edi
  801114:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801117:	85 c9                	test   %ecx,%ecx
  801119:	74 31                	je     80114c <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80111b:	89 f8                	mov    %edi,%eax
  80111d:	09 c8                	or     %ecx,%eax
  80111f:	a8 03                	test   $0x3,%al
  801121:	75 23                	jne    801146 <memset+0x3b>
		c &= 0xFF;
  801123:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801127:	89 d3                	mov    %edx,%ebx
  801129:	c1 e3 08             	shl    $0x8,%ebx
  80112c:	89 d0                	mov    %edx,%eax
  80112e:	c1 e0 18             	shl    $0x18,%eax
  801131:	89 d6                	mov    %edx,%esi
  801133:	c1 e6 10             	shl    $0x10,%esi
  801136:	09 f0                	or     %esi,%eax
  801138:	09 c2                	or     %eax,%edx
  80113a:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80113c:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80113f:	89 d0                	mov    %edx,%eax
  801141:	fc                   	cld    
  801142:	f3 ab                	rep stos %eax,%es:(%edi)
  801144:	eb 06                	jmp    80114c <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801146:	8b 45 0c             	mov    0xc(%ebp),%eax
  801149:	fc                   	cld    
  80114a:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80114c:	89 f8                	mov    %edi,%eax
  80114e:	5b                   	pop    %ebx
  80114f:	5e                   	pop    %esi
  801150:	5f                   	pop    %edi
  801151:	5d                   	pop    %ebp
  801152:	c3                   	ret    

00801153 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801153:	55                   	push   %ebp
  801154:	89 e5                	mov    %esp,%ebp
  801156:	57                   	push   %edi
  801157:	56                   	push   %esi
  801158:	8b 45 08             	mov    0x8(%ebp),%eax
  80115b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80115e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801161:	39 c6                	cmp    %eax,%esi
  801163:	73 32                	jae    801197 <memmove+0x44>
  801165:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801168:	39 c2                	cmp    %eax,%edx
  80116a:	76 2b                	jbe    801197 <memmove+0x44>
		s += n;
		d += n;
  80116c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80116f:	89 fe                	mov    %edi,%esi
  801171:	09 ce                	or     %ecx,%esi
  801173:	09 d6                	or     %edx,%esi
  801175:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80117b:	75 0e                	jne    80118b <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80117d:	83 ef 04             	sub    $0x4,%edi
  801180:	8d 72 fc             	lea    -0x4(%edx),%esi
  801183:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801186:	fd                   	std    
  801187:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801189:	eb 09                	jmp    801194 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80118b:	83 ef 01             	sub    $0x1,%edi
  80118e:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801191:	fd                   	std    
  801192:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801194:	fc                   	cld    
  801195:	eb 1a                	jmp    8011b1 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801197:	89 c2                	mov    %eax,%edx
  801199:	09 ca                	or     %ecx,%edx
  80119b:	09 f2                	or     %esi,%edx
  80119d:	f6 c2 03             	test   $0x3,%dl
  8011a0:	75 0a                	jne    8011ac <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8011a2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8011a5:	89 c7                	mov    %eax,%edi
  8011a7:	fc                   	cld    
  8011a8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8011aa:	eb 05                	jmp    8011b1 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  8011ac:	89 c7                	mov    %eax,%edi
  8011ae:	fc                   	cld    
  8011af:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8011b1:	5e                   	pop    %esi
  8011b2:	5f                   	pop    %edi
  8011b3:	5d                   	pop    %ebp
  8011b4:	c3                   	ret    

008011b5 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8011b5:	55                   	push   %ebp
  8011b6:	89 e5                	mov    %esp,%ebp
  8011b8:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8011bb:	ff 75 10             	pushl  0x10(%ebp)
  8011be:	ff 75 0c             	pushl  0xc(%ebp)
  8011c1:	ff 75 08             	pushl  0x8(%ebp)
  8011c4:	e8 8a ff ff ff       	call   801153 <memmove>
}
  8011c9:	c9                   	leave  
  8011ca:	c3                   	ret    

008011cb <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8011cb:	55                   	push   %ebp
  8011cc:	89 e5                	mov    %esp,%ebp
  8011ce:	56                   	push   %esi
  8011cf:	53                   	push   %ebx
  8011d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011d6:	89 c6                	mov    %eax,%esi
  8011d8:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8011db:	39 f0                	cmp    %esi,%eax
  8011dd:	74 1c                	je     8011fb <memcmp+0x30>
		if (*s1 != *s2)
  8011df:	0f b6 08             	movzbl (%eax),%ecx
  8011e2:	0f b6 1a             	movzbl (%edx),%ebx
  8011e5:	38 d9                	cmp    %bl,%cl
  8011e7:	75 08                	jne    8011f1 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8011e9:	83 c0 01             	add    $0x1,%eax
  8011ec:	83 c2 01             	add    $0x1,%edx
  8011ef:	eb ea                	jmp    8011db <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8011f1:	0f b6 c1             	movzbl %cl,%eax
  8011f4:	0f b6 db             	movzbl %bl,%ebx
  8011f7:	29 d8                	sub    %ebx,%eax
  8011f9:	eb 05                	jmp    801200 <memcmp+0x35>
	}

	return 0;
  8011fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801200:	5b                   	pop    %ebx
  801201:	5e                   	pop    %esi
  801202:	5d                   	pop    %ebp
  801203:	c3                   	ret    

00801204 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801204:	55                   	push   %ebp
  801205:	89 e5                	mov    %esp,%ebp
  801207:	8b 45 08             	mov    0x8(%ebp),%eax
  80120a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  80120d:	89 c2                	mov    %eax,%edx
  80120f:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801212:	39 d0                	cmp    %edx,%eax
  801214:	73 09                	jae    80121f <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  801216:	38 08                	cmp    %cl,(%eax)
  801218:	74 05                	je     80121f <memfind+0x1b>
	for (; s < ends; s++)
  80121a:	83 c0 01             	add    $0x1,%eax
  80121d:	eb f3                	jmp    801212 <memfind+0xe>
			break;
	return (void *) s;
}
  80121f:	5d                   	pop    %ebp
  801220:	c3                   	ret    

00801221 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801221:	55                   	push   %ebp
  801222:	89 e5                	mov    %esp,%ebp
  801224:	57                   	push   %edi
  801225:	56                   	push   %esi
  801226:	53                   	push   %ebx
  801227:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80122a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80122d:	eb 03                	jmp    801232 <strtol+0x11>
		s++;
  80122f:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801232:	0f b6 01             	movzbl (%ecx),%eax
  801235:	3c 20                	cmp    $0x20,%al
  801237:	74 f6                	je     80122f <strtol+0xe>
  801239:	3c 09                	cmp    $0x9,%al
  80123b:	74 f2                	je     80122f <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  80123d:	3c 2b                	cmp    $0x2b,%al
  80123f:	74 2a                	je     80126b <strtol+0x4a>
	int neg = 0;
  801241:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801246:	3c 2d                	cmp    $0x2d,%al
  801248:	74 2b                	je     801275 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80124a:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801250:	75 0f                	jne    801261 <strtol+0x40>
  801252:	80 39 30             	cmpb   $0x30,(%ecx)
  801255:	74 28                	je     80127f <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801257:	85 db                	test   %ebx,%ebx
  801259:	b8 0a 00 00 00       	mov    $0xa,%eax
  80125e:	0f 44 d8             	cmove  %eax,%ebx
  801261:	b8 00 00 00 00       	mov    $0x0,%eax
  801266:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801269:	eb 50                	jmp    8012bb <strtol+0x9a>
		s++;
  80126b:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  80126e:	bf 00 00 00 00       	mov    $0x0,%edi
  801273:	eb d5                	jmp    80124a <strtol+0x29>
		s++, neg = 1;
  801275:	83 c1 01             	add    $0x1,%ecx
  801278:	bf 01 00 00 00       	mov    $0x1,%edi
  80127d:	eb cb                	jmp    80124a <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80127f:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801283:	74 0e                	je     801293 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  801285:	85 db                	test   %ebx,%ebx
  801287:	75 d8                	jne    801261 <strtol+0x40>
		s++, base = 8;
  801289:	83 c1 01             	add    $0x1,%ecx
  80128c:	bb 08 00 00 00       	mov    $0x8,%ebx
  801291:	eb ce                	jmp    801261 <strtol+0x40>
		s += 2, base = 16;
  801293:	83 c1 02             	add    $0x2,%ecx
  801296:	bb 10 00 00 00       	mov    $0x10,%ebx
  80129b:	eb c4                	jmp    801261 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  80129d:	8d 72 9f             	lea    -0x61(%edx),%esi
  8012a0:	89 f3                	mov    %esi,%ebx
  8012a2:	80 fb 19             	cmp    $0x19,%bl
  8012a5:	77 29                	ja     8012d0 <strtol+0xaf>
			dig = *s - 'a' + 10;
  8012a7:	0f be d2             	movsbl %dl,%edx
  8012aa:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8012ad:	3b 55 10             	cmp    0x10(%ebp),%edx
  8012b0:	7d 30                	jge    8012e2 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  8012b2:	83 c1 01             	add    $0x1,%ecx
  8012b5:	0f af 45 10          	imul   0x10(%ebp),%eax
  8012b9:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  8012bb:	0f b6 11             	movzbl (%ecx),%edx
  8012be:	8d 72 d0             	lea    -0x30(%edx),%esi
  8012c1:	89 f3                	mov    %esi,%ebx
  8012c3:	80 fb 09             	cmp    $0x9,%bl
  8012c6:	77 d5                	ja     80129d <strtol+0x7c>
			dig = *s - '0';
  8012c8:	0f be d2             	movsbl %dl,%edx
  8012cb:	83 ea 30             	sub    $0x30,%edx
  8012ce:	eb dd                	jmp    8012ad <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  8012d0:	8d 72 bf             	lea    -0x41(%edx),%esi
  8012d3:	89 f3                	mov    %esi,%ebx
  8012d5:	80 fb 19             	cmp    $0x19,%bl
  8012d8:	77 08                	ja     8012e2 <strtol+0xc1>
			dig = *s - 'A' + 10;
  8012da:	0f be d2             	movsbl %dl,%edx
  8012dd:	83 ea 37             	sub    $0x37,%edx
  8012e0:	eb cb                	jmp    8012ad <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  8012e2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012e6:	74 05                	je     8012ed <strtol+0xcc>
		*endptr = (char *) s;
  8012e8:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012eb:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  8012ed:	89 c2                	mov    %eax,%edx
  8012ef:	f7 da                	neg    %edx
  8012f1:	85 ff                	test   %edi,%edi
  8012f3:	0f 45 c2             	cmovne %edx,%eax
}
  8012f6:	5b                   	pop    %ebx
  8012f7:	5e                   	pop    %esi
  8012f8:	5f                   	pop    %edi
  8012f9:	5d                   	pop    %ebp
  8012fa:	c3                   	ret    

008012fb <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8012fb:	55                   	push   %ebp
  8012fc:	89 e5                	mov    %esp,%ebp
  8012fe:	57                   	push   %edi
  8012ff:	56                   	push   %esi
  801300:	53                   	push   %ebx
	asm volatile("int %1\n"
  801301:	b8 00 00 00 00       	mov    $0x0,%eax
  801306:	8b 55 08             	mov    0x8(%ebp),%edx
  801309:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80130c:	89 c3                	mov    %eax,%ebx
  80130e:	89 c7                	mov    %eax,%edi
  801310:	89 c6                	mov    %eax,%esi
  801312:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801314:	5b                   	pop    %ebx
  801315:	5e                   	pop    %esi
  801316:	5f                   	pop    %edi
  801317:	5d                   	pop    %ebp
  801318:	c3                   	ret    

00801319 <sys_cgetc>:

int
sys_cgetc(void)
{
  801319:	55                   	push   %ebp
  80131a:	89 e5                	mov    %esp,%ebp
  80131c:	57                   	push   %edi
  80131d:	56                   	push   %esi
  80131e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80131f:	ba 00 00 00 00       	mov    $0x0,%edx
  801324:	b8 01 00 00 00       	mov    $0x1,%eax
  801329:	89 d1                	mov    %edx,%ecx
  80132b:	89 d3                	mov    %edx,%ebx
  80132d:	89 d7                	mov    %edx,%edi
  80132f:	89 d6                	mov    %edx,%esi
  801331:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801333:	5b                   	pop    %ebx
  801334:	5e                   	pop    %esi
  801335:	5f                   	pop    %edi
  801336:	5d                   	pop    %ebp
  801337:	c3                   	ret    

00801338 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801338:	55                   	push   %ebp
  801339:	89 e5                	mov    %esp,%ebp
  80133b:	57                   	push   %edi
  80133c:	56                   	push   %esi
  80133d:	53                   	push   %ebx
  80133e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801341:	b9 00 00 00 00       	mov    $0x0,%ecx
  801346:	8b 55 08             	mov    0x8(%ebp),%edx
  801349:	b8 03 00 00 00       	mov    $0x3,%eax
  80134e:	89 cb                	mov    %ecx,%ebx
  801350:	89 cf                	mov    %ecx,%edi
  801352:	89 ce                	mov    %ecx,%esi
  801354:	cd 30                	int    $0x30
	if(check && ret > 0)
  801356:	85 c0                	test   %eax,%eax
  801358:	7f 08                	jg     801362 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80135a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80135d:	5b                   	pop    %ebx
  80135e:	5e                   	pop    %esi
  80135f:	5f                   	pop    %edi
  801360:	5d                   	pop    %ebp
  801361:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801362:	83 ec 0c             	sub    $0xc,%esp
  801365:	50                   	push   %eax
  801366:	6a 03                	push   $0x3
  801368:	68 64 33 80 00       	push   $0x803364
  80136d:	6a 43                	push   $0x43
  80136f:	68 81 33 80 00       	push   $0x803381
  801374:	e8 f7 f3 ff ff       	call   800770 <_panic>

00801379 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801379:	55                   	push   %ebp
  80137a:	89 e5                	mov    %esp,%ebp
  80137c:	57                   	push   %edi
  80137d:	56                   	push   %esi
  80137e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80137f:	ba 00 00 00 00       	mov    $0x0,%edx
  801384:	b8 02 00 00 00       	mov    $0x2,%eax
  801389:	89 d1                	mov    %edx,%ecx
  80138b:	89 d3                	mov    %edx,%ebx
  80138d:	89 d7                	mov    %edx,%edi
  80138f:	89 d6                	mov    %edx,%esi
  801391:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801393:	5b                   	pop    %ebx
  801394:	5e                   	pop    %esi
  801395:	5f                   	pop    %edi
  801396:	5d                   	pop    %ebp
  801397:	c3                   	ret    

00801398 <sys_yield>:

void
sys_yield(void)
{
  801398:	55                   	push   %ebp
  801399:	89 e5                	mov    %esp,%ebp
  80139b:	57                   	push   %edi
  80139c:	56                   	push   %esi
  80139d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80139e:	ba 00 00 00 00       	mov    $0x0,%edx
  8013a3:	b8 0b 00 00 00       	mov    $0xb,%eax
  8013a8:	89 d1                	mov    %edx,%ecx
  8013aa:	89 d3                	mov    %edx,%ebx
  8013ac:	89 d7                	mov    %edx,%edi
  8013ae:	89 d6                	mov    %edx,%esi
  8013b0:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8013b2:	5b                   	pop    %ebx
  8013b3:	5e                   	pop    %esi
  8013b4:	5f                   	pop    %edi
  8013b5:	5d                   	pop    %ebp
  8013b6:	c3                   	ret    

008013b7 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8013b7:	55                   	push   %ebp
  8013b8:	89 e5                	mov    %esp,%ebp
  8013ba:	57                   	push   %edi
  8013bb:	56                   	push   %esi
  8013bc:	53                   	push   %ebx
  8013bd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8013c0:	be 00 00 00 00       	mov    $0x0,%esi
  8013c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8013c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013cb:	b8 04 00 00 00       	mov    $0x4,%eax
  8013d0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8013d3:	89 f7                	mov    %esi,%edi
  8013d5:	cd 30                	int    $0x30
	if(check && ret > 0)
  8013d7:	85 c0                	test   %eax,%eax
  8013d9:	7f 08                	jg     8013e3 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8013db:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013de:	5b                   	pop    %ebx
  8013df:	5e                   	pop    %esi
  8013e0:	5f                   	pop    %edi
  8013e1:	5d                   	pop    %ebp
  8013e2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8013e3:	83 ec 0c             	sub    $0xc,%esp
  8013e6:	50                   	push   %eax
  8013e7:	6a 04                	push   $0x4
  8013e9:	68 64 33 80 00       	push   $0x803364
  8013ee:	6a 43                	push   $0x43
  8013f0:	68 81 33 80 00       	push   $0x803381
  8013f5:	e8 76 f3 ff ff       	call   800770 <_panic>

008013fa <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8013fa:	55                   	push   %ebp
  8013fb:	89 e5                	mov    %esp,%ebp
  8013fd:	57                   	push   %edi
  8013fe:	56                   	push   %esi
  8013ff:	53                   	push   %ebx
  801400:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801403:	8b 55 08             	mov    0x8(%ebp),%edx
  801406:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801409:	b8 05 00 00 00       	mov    $0x5,%eax
  80140e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801411:	8b 7d 14             	mov    0x14(%ebp),%edi
  801414:	8b 75 18             	mov    0x18(%ebp),%esi
  801417:	cd 30                	int    $0x30
	if(check && ret > 0)
  801419:	85 c0                	test   %eax,%eax
  80141b:	7f 08                	jg     801425 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80141d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801420:	5b                   	pop    %ebx
  801421:	5e                   	pop    %esi
  801422:	5f                   	pop    %edi
  801423:	5d                   	pop    %ebp
  801424:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801425:	83 ec 0c             	sub    $0xc,%esp
  801428:	50                   	push   %eax
  801429:	6a 05                	push   $0x5
  80142b:	68 64 33 80 00       	push   $0x803364
  801430:	6a 43                	push   $0x43
  801432:	68 81 33 80 00       	push   $0x803381
  801437:	e8 34 f3 ff ff       	call   800770 <_panic>

0080143c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80143c:	55                   	push   %ebp
  80143d:	89 e5                	mov    %esp,%ebp
  80143f:	57                   	push   %edi
  801440:	56                   	push   %esi
  801441:	53                   	push   %ebx
  801442:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801445:	bb 00 00 00 00       	mov    $0x0,%ebx
  80144a:	8b 55 08             	mov    0x8(%ebp),%edx
  80144d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801450:	b8 06 00 00 00       	mov    $0x6,%eax
  801455:	89 df                	mov    %ebx,%edi
  801457:	89 de                	mov    %ebx,%esi
  801459:	cd 30                	int    $0x30
	if(check && ret > 0)
  80145b:	85 c0                	test   %eax,%eax
  80145d:	7f 08                	jg     801467 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80145f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801462:	5b                   	pop    %ebx
  801463:	5e                   	pop    %esi
  801464:	5f                   	pop    %edi
  801465:	5d                   	pop    %ebp
  801466:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801467:	83 ec 0c             	sub    $0xc,%esp
  80146a:	50                   	push   %eax
  80146b:	6a 06                	push   $0x6
  80146d:	68 64 33 80 00       	push   $0x803364
  801472:	6a 43                	push   $0x43
  801474:	68 81 33 80 00       	push   $0x803381
  801479:	e8 f2 f2 ff ff       	call   800770 <_panic>

0080147e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80147e:	55                   	push   %ebp
  80147f:	89 e5                	mov    %esp,%ebp
  801481:	57                   	push   %edi
  801482:	56                   	push   %esi
  801483:	53                   	push   %ebx
  801484:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801487:	bb 00 00 00 00       	mov    $0x0,%ebx
  80148c:	8b 55 08             	mov    0x8(%ebp),%edx
  80148f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801492:	b8 08 00 00 00       	mov    $0x8,%eax
  801497:	89 df                	mov    %ebx,%edi
  801499:	89 de                	mov    %ebx,%esi
  80149b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80149d:	85 c0                	test   %eax,%eax
  80149f:	7f 08                	jg     8014a9 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8014a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014a4:	5b                   	pop    %ebx
  8014a5:	5e                   	pop    %esi
  8014a6:	5f                   	pop    %edi
  8014a7:	5d                   	pop    %ebp
  8014a8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8014a9:	83 ec 0c             	sub    $0xc,%esp
  8014ac:	50                   	push   %eax
  8014ad:	6a 08                	push   $0x8
  8014af:	68 64 33 80 00       	push   $0x803364
  8014b4:	6a 43                	push   $0x43
  8014b6:	68 81 33 80 00       	push   $0x803381
  8014bb:	e8 b0 f2 ff ff       	call   800770 <_panic>

008014c0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8014c0:	55                   	push   %ebp
  8014c1:	89 e5                	mov    %esp,%ebp
  8014c3:	57                   	push   %edi
  8014c4:	56                   	push   %esi
  8014c5:	53                   	push   %ebx
  8014c6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8014c9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8014d1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014d4:	b8 09 00 00 00       	mov    $0x9,%eax
  8014d9:	89 df                	mov    %ebx,%edi
  8014db:	89 de                	mov    %ebx,%esi
  8014dd:	cd 30                	int    $0x30
	if(check && ret > 0)
  8014df:	85 c0                	test   %eax,%eax
  8014e1:	7f 08                	jg     8014eb <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8014e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014e6:	5b                   	pop    %ebx
  8014e7:	5e                   	pop    %esi
  8014e8:	5f                   	pop    %edi
  8014e9:	5d                   	pop    %ebp
  8014ea:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8014eb:	83 ec 0c             	sub    $0xc,%esp
  8014ee:	50                   	push   %eax
  8014ef:	6a 09                	push   $0x9
  8014f1:	68 64 33 80 00       	push   $0x803364
  8014f6:	6a 43                	push   $0x43
  8014f8:	68 81 33 80 00       	push   $0x803381
  8014fd:	e8 6e f2 ff ff       	call   800770 <_panic>

00801502 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801502:	55                   	push   %ebp
  801503:	89 e5                	mov    %esp,%ebp
  801505:	57                   	push   %edi
  801506:	56                   	push   %esi
  801507:	53                   	push   %ebx
  801508:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80150b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801510:	8b 55 08             	mov    0x8(%ebp),%edx
  801513:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801516:	b8 0a 00 00 00       	mov    $0xa,%eax
  80151b:	89 df                	mov    %ebx,%edi
  80151d:	89 de                	mov    %ebx,%esi
  80151f:	cd 30                	int    $0x30
	if(check && ret > 0)
  801521:	85 c0                	test   %eax,%eax
  801523:	7f 08                	jg     80152d <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801525:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801528:	5b                   	pop    %ebx
  801529:	5e                   	pop    %esi
  80152a:	5f                   	pop    %edi
  80152b:	5d                   	pop    %ebp
  80152c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80152d:	83 ec 0c             	sub    $0xc,%esp
  801530:	50                   	push   %eax
  801531:	6a 0a                	push   $0xa
  801533:	68 64 33 80 00       	push   $0x803364
  801538:	6a 43                	push   $0x43
  80153a:	68 81 33 80 00       	push   $0x803381
  80153f:	e8 2c f2 ff ff       	call   800770 <_panic>

00801544 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801544:	55                   	push   %ebp
  801545:	89 e5                	mov    %esp,%ebp
  801547:	57                   	push   %edi
  801548:	56                   	push   %esi
  801549:	53                   	push   %ebx
	asm volatile("int %1\n"
  80154a:	8b 55 08             	mov    0x8(%ebp),%edx
  80154d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801550:	b8 0c 00 00 00       	mov    $0xc,%eax
  801555:	be 00 00 00 00       	mov    $0x0,%esi
  80155a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80155d:	8b 7d 14             	mov    0x14(%ebp),%edi
  801560:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801562:	5b                   	pop    %ebx
  801563:	5e                   	pop    %esi
  801564:	5f                   	pop    %edi
  801565:	5d                   	pop    %ebp
  801566:	c3                   	ret    

00801567 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801567:	55                   	push   %ebp
  801568:	89 e5                	mov    %esp,%ebp
  80156a:	57                   	push   %edi
  80156b:	56                   	push   %esi
  80156c:	53                   	push   %ebx
  80156d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801570:	b9 00 00 00 00       	mov    $0x0,%ecx
  801575:	8b 55 08             	mov    0x8(%ebp),%edx
  801578:	b8 0d 00 00 00       	mov    $0xd,%eax
  80157d:	89 cb                	mov    %ecx,%ebx
  80157f:	89 cf                	mov    %ecx,%edi
  801581:	89 ce                	mov    %ecx,%esi
  801583:	cd 30                	int    $0x30
	if(check && ret > 0)
  801585:	85 c0                	test   %eax,%eax
  801587:	7f 08                	jg     801591 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801589:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80158c:	5b                   	pop    %ebx
  80158d:	5e                   	pop    %esi
  80158e:	5f                   	pop    %edi
  80158f:	5d                   	pop    %ebp
  801590:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801591:	83 ec 0c             	sub    $0xc,%esp
  801594:	50                   	push   %eax
  801595:	6a 0d                	push   $0xd
  801597:	68 64 33 80 00       	push   $0x803364
  80159c:	6a 43                	push   $0x43
  80159e:	68 81 33 80 00       	push   $0x803381
  8015a3:	e8 c8 f1 ff ff       	call   800770 <_panic>

008015a8 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  8015a8:	55                   	push   %ebp
  8015a9:	89 e5                	mov    %esp,%ebp
  8015ab:	57                   	push   %edi
  8015ac:	56                   	push   %esi
  8015ad:	53                   	push   %ebx
	asm volatile("int %1\n"
  8015ae:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8015b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015b9:	b8 0e 00 00 00       	mov    $0xe,%eax
  8015be:	89 df                	mov    %ebx,%edi
  8015c0:	89 de                	mov    %ebx,%esi
  8015c2:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8015c4:	5b                   	pop    %ebx
  8015c5:	5e                   	pop    %esi
  8015c6:	5f                   	pop    %edi
  8015c7:	5d                   	pop    %ebp
  8015c8:	c3                   	ret    

008015c9 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8015c9:	55                   	push   %ebp
  8015ca:	89 e5                	mov    %esp,%ebp
  8015cc:	57                   	push   %edi
  8015cd:	56                   	push   %esi
  8015ce:	53                   	push   %ebx
	asm volatile("int %1\n"
  8015cf:	b9 00 00 00 00       	mov    $0x0,%ecx
  8015d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8015d7:	b8 0f 00 00 00       	mov    $0xf,%eax
  8015dc:	89 cb                	mov    %ecx,%ebx
  8015de:	89 cf                	mov    %ecx,%edi
  8015e0:	89 ce                	mov    %ecx,%esi
  8015e2:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8015e4:	5b                   	pop    %ebx
  8015e5:	5e                   	pop    %esi
  8015e6:	5f                   	pop    %edi
  8015e7:	5d                   	pop    %ebp
  8015e8:	c3                   	ret    

008015e9 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8015e9:	55                   	push   %ebp
  8015ea:	89 e5                	mov    %esp,%ebp
  8015ec:	57                   	push   %edi
  8015ed:	56                   	push   %esi
  8015ee:	53                   	push   %ebx
	asm volatile("int %1\n"
  8015ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8015f4:	b8 10 00 00 00       	mov    $0x10,%eax
  8015f9:	89 d1                	mov    %edx,%ecx
  8015fb:	89 d3                	mov    %edx,%ebx
  8015fd:	89 d7                	mov    %edx,%edi
  8015ff:	89 d6                	mov    %edx,%esi
  801601:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801603:	5b                   	pop    %ebx
  801604:	5e                   	pop    %esi
  801605:	5f                   	pop    %edi
  801606:	5d                   	pop    %ebp
  801607:	c3                   	ret    

00801608 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801608:	55                   	push   %ebp
  801609:	89 e5                	mov    %esp,%ebp
  80160b:	57                   	push   %edi
  80160c:	56                   	push   %esi
  80160d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80160e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801613:	8b 55 08             	mov    0x8(%ebp),%edx
  801616:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801619:	b8 11 00 00 00       	mov    $0x11,%eax
  80161e:	89 df                	mov    %ebx,%edi
  801620:	89 de                	mov    %ebx,%esi
  801622:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801624:	5b                   	pop    %ebx
  801625:	5e                   	pop    %esi
  801626:	5f                   	pop    %edi
  801627:	5d                   	pop    %ebp
  801628:	c3                   	ret    

00801629 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801629:	55                   	push   %ebp
  80162a:	89 e5                	mov    %esp,%ebp
  80162c:	57                   	push   %edi
  80162d:	56                   	push   %esi
  80162e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80162f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801634:	8b 55 08             	mov    0x8(%ebp),%edx
  801637:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80163a:	b8 12 00 00 00       	mov    $0x12,%eax
  80163f:	89 df                	mov    %ebx,%edi
  801641:	89 de                	mov    %ebx,%esi
  801643:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801645:	5b                   	pop    %ebx
  801646:	5e                   	pop    %esi
  801647:	5f                   	pop    %edi
  801648:	5d                   	pop    %ebp
  801649:	c3                   	ret    

0080164a <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  80164a:	55                   	push   %ebp
  80164b:	89 e5                	mov    %esp,%ebp
  80164d:	57                   	push   %edi
  80164e:	56                   	push   %esi
  80164f:	53                   	push   %ebx
  801650:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801653:	bb 00 00 00 00       	mov    $0x0,%ebx
  801658:	8b 55 08             	mov    0x8(%ebp),%edx
  80165b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80165e:	b8 13 00 00 00       	mov    $0x13,%eax
  801663:	89 df                	mov    %ebx,%edi
  801665:	89 de                	mov    %ebx,%esi
  801667:	cd 30                	int    $0x30
	if(check && ret > 0)
  801669:	85 c0                	test   %eax,%eax
  80166b:	7f 08                	jg     801675 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80166d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801670:	5b                   	pop    %ebx
  801671:	5e                   	pop    %esi
  801672:	5f                   	pop    %edi
  801673:	5d                   	pop    %ebp
  801674:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801675:	83 ec 0c             	sub    $0xc,%esp
  801678:	50                   	push   %eax
  801679:	6a 13                	push   $0x13
  80167b:	68 64 33 80 00       	push   $0x803364
  801680:	6a 43                	push   $0x43
  801682:	68 81 33 80 00       	push   $0x803381
  801687:	e8 e4 f0 ff ff       	call   800770 <_panic>

0080168c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80168c:	55                   	push   %ebp
  80168d:	89 e5                	mov    %esp,%ebp
  80168f:	56                   	push   %esi
  801690:	53                   	push   %ebx
  801691:	8b 75 08             	mov    0x8(%ebp),%esi
  801694:	8b 45 0c             	mov    0xc(%ebp),%eax
  801697:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  80169a:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80169c:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8016a1:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8016a4:	83 ec 0c             	sub    $0xc,%esp
  8016a7:	50                   	push   %eax
  8016a8:	e8 ba fe ff ff       	call   801567 <sys_ipc_recv>
	if(ret < 0){
  8016ad:	83 c4 10             	add    $0x10,%esp
  8016b0:	85 c0                	test   %eax,%eax
  8016b2:	78 2b                	js     8016df <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8016b4:	85 f6                	test   %esi,%esi
  8016b6:	74 0a                	je     8016c2 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  8016b8:	a1 08 50 80 00       	mov    0x805008,%eax
  8016bd:	8b 40 74             	mov    0x74(%eax),%eax
  8016c0:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8016c2:	85 db                	test   %ebx,%ebx
  8016c4:	74 0a                	je     8016d0 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  8016c6:	a1 08 50 80 00       	mov    0x805008,%eax
  8016cb:	8b 40 78             	mov    0x78(%eax),%eax
  8016ce:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  8016d0:	a1 08 50 80 00       	mov    0x805008,%eax
  8016d5:	8b 40 70             	mov    0x70(%eax),%eax
}
  8016d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016db:	5b                   	pop    %ebx
  8016dc:	5e                   	pop    %esi
  8016dd:	5d                   	pop    %ebp
  8016de:	c3                   	ret    
		if(from_env_store)
  8016df:	85 f6                	test   %esi,%esi
  8016e1:	74 06                	je     8016e9 <ipc_recv+0x5d>
			*from_env_store = 0;
  8016e3:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8016e9:	85 db                	test   %ebx,%ebx
  8016eb:	74 eb                	je     8016d8 <ipc_recv+0x4c>
			*perm_store = 0;
  8016ed:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8016f3:	eb e3                	jmp    8016d8 <ipc_recv+0x4c>

008016f5 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8016f5:	55                   	push   %ebp
  8016f6:	89 e5                	mov    %esp,%ebp
  8016f8:	57                   	push   %edi
  8016f9:	56                   	push   %esi
  8016fa:	53                   	push   %ebx
  8016fb:	83 ec 0c             	sub    $0xc,%esp
  8016fe:	8b 7d 08             	mov    0x8(%ebp),%edi
  801701:	8b 75 0c             	mov    0xc(%ebp),%esi
  801704:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  801707:	85 db                	test   %ebx,%ebx
  801709:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80170e:	0f 44 d8             	cmove  %eax,%ebx
  801711:	eb 05                	jmp    801718 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  801713:	e8 80 fc ff ff       	call   801398 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  801718:	ff 75 14             	pushl  0x14(%ebp)
  80171b:	53                   	push   %ebx
  80171c:	56                   	push   %esi
  80171d:	57                   	push   %edi
  80171e:	e8 21 fe ff ff       	call   801544 <sys_ipc_try_send>
  801723:	83 c4 10             	add    $0x10,%esp
  801726:	85 c0                	test   %eax,%eax
  801728:	74 1b                	je     801745 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80172a:	79 e7                	jns    801713 <ipc_send+0x1e>
  80172c:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80172f:	74 e2                	je     801713 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  801731:	83 ec 04             	sub    $0x4,%esp
  801734:	68 8f 33 80 00       	push   $0x80338f
  801739:	6a 48                	push   $0x48
  80173b:	68 a4 33 80 00       	push   $0x8033a4
  801740:	e8 2b f0 ff ff       	call   800770 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  801745:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801748:	5b                   	pop    %ebx
  801749:	5e                   	pop    %esi
  80174a:	5f                   	pop    %edi
  80174b:	5d                   	pop    %ebp
  80174c:	c3                   	ret    

0080174d <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80174d:	55                   	push   %ebp
  80174e:	89 e5                	mov    %esp,%ebp
  801750:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801753:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801758:	89 c2                	mov    %eax,%edx
  80175a:	c1 e2 07             	shl    $0x7,%edx
  80175d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801763:	8b 52 50             	mov    0x50(%edx),%edx
  801766:	39 ca                	cmp    %ecx,%edx
  801768:	74 11                	je     80177b <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  80176a:	83 c0 01             	add    $0x1,%eax
  80176d:	3d 00 04 00 00       	cmp    $0x400,%eax
  801772:	75 e4                	jne    801758 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801774:	b8 00 00 00 00       	mov    $0x0,%eax
  801779:	eb 0b                	jmp    801786 <ipc_find_env+0x39>
			return envs[i].env_id;
  80177b:	c1 e0 07             	shl    $0x7,%eax
  80177e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801783:	8b 40 48             	mov    0x48(%eax),%eax
}
  801786:	5d                   	pop    %ebp
  801787:	c3                   	ret    

00801788 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801788:	55                   	push   %ebp
  801789:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80178b:	8b 45 08             	mov    0x8(%ebp),%eax
  80178e:	05 00 00 00 30       	add    $0x30000000,%eax
  801793:	c1 e8 0c             	shr    $0xc,%eax
}
  801796:	5d                   	pop    %ebp
  801797:	c3                   	ret    

00801798 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801798:	55                   	push   %ebp
  801799:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80179b:	8b 45 08             	mov    0x8(%ebp),%eax
  80179e:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8017a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017a8:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8017ad:	5d                   	pop    %ebp
  8017ae:	c3                   	ret    

008017af <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8017af:	55                   	push   %ebp
  8017b0:	89 e5                	mov    %esp,%ebp
  8017b2:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8017b7:	89 c2                	mov    %eax,%edx
  8017b9:	c1 ea 16             	shr    $0x16,%edx
  8017bc:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8017c3:	f6 c2 01             	test   $0x1,%dl
  8017c6:	74 2d                	je     8017f5 <fd_alloc+0x46>
  8017c8:	89 c2                	mov    %eax,%edx
  8017ca:	c1 ea 0c             	shr    $0xc,%edx
  8017cd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8017d4:	f6 c2 01             	test   $0x1,%dl
  8017d7:	74 1c                	je     8017f5 <fd_alloc+0x46>
  8017d9:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8017de:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8017e3:	75 d2                	jne    8017b7 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8017e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8017ee:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8017f3:	eb 0a                	jmp    8017ff <fd_alloc+0x50>
			*fd_store = fd;
  8017f5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017f8:	89 01                	mov    %eax,(%ecx)
			return 0;
  8017fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017ff:	5d                   	pop    %ebp
  801800:	c3                   	ret    

00801801 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801801:	55                   	push   %ebp
  801802:	89 e5                	mov    %esp,%ebp
  801804:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801807:	83 f8 1f             	cmp    $0x1f,%eax
  80180a:	77 30                	ja     80183c <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80180c:	c1 e0 0c             	shl    $0xc,%eax
  80180f:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801814:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80181a:	f6 c2 01             	test   $0x1,%dl
  80181d:	74 24                	je     801843 <fd_lookup+0x42>
  80181f:	89 c2                	mov    %eax,%edx
  801821:	c1 ea 0c             	shr    $0xc,%edx
  801824:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80182b:	f6 c2 01             	test   $0x1,%dl
  80182e:	74 1a                	je     80184a <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801830:	8b 55 0c             	mov    0xc(%ebp),%edx
  801833:	89 02                	mov    %eax,(%edx)
	return 0;
  801835:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80183a:	5d                   	pop    %ebp
  80183b:	c3                   	ret    
		return -E_INVAL;
  80183c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801841:	eb f7                	jmp    80183a <fd_lookup+0x39>
		return -E_INVAL;
  801843:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801848:	eb f0                	jmp    80183a <fd_lookup+0x39>
  80184a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80184f:	eb e9                	jmp    80183a <fd_lookup+0x39>

00801851 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801851:	55                   	push   %ebp
  801852:	89 e5                	mov    %esp,%ebp
  801854:	83 ec 08             	sub    $0x8,%esp
  801857:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80185a:	ba 00 00 00 00       	mov    $0x0,%edx
  80185f:	b8 08 40 80 00       	mov    $0x804008,%eax
		if (devtab[i]->dev_id == dev_id) {
  801864:	39 08                	cmp    %ecx,(%eax)
  801866:	74 38                	je     8018a0 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801868:	83 c2 01             	add    $0x1,%edx
  80186b:	8b 04 95 30 34 80 00 	mov    0x803430(,%edx,4),%eax
  801872:	85 c0                	test   %eax,%eax
  801874:	75 ee                	jne    801864 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801876:	a1 08 50 80 00       	mov    0x805008,%eax
  80187b:	8b 40 48             	mov    0x48(%eax),%eax
  80187e:	83 ec 04             	sub    $0x4,%esp
  801881:	51                   	push   %ecx
  801882:	50                   	push   %eax
  801883:	68 b0 33 80 00       	push   $0x8033b0
  801888:	e8 d9 ef ff ff       	call   800866 <cprintf>
	*dev = 0;
  80188d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801890:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801896:	83 c4 10             	add    $0x10,%esp
  801899:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80189e:	c9                   	leave  
  80189f:	c3                   	ret    
			*dev = devtab[i];
  8018a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018a3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8018a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8018aa:	eb f2                	jmp    80189e <dev_lookup+0x4d>

008018ac <fd_close>:
{
  8018ac:	55                   	push   %ebp
  8018ad:	89 e5                	mov    %esp,%ebp
  8018af:	57                   	push   %edi
  8018b0:	56                   	push   %esi
  8018b1:	53                   	push   %ebx
  8018b2:	83 ec 24             	sub    $0x24,%esp
  8018b5:	8b 75 08             	mov    0x8(%ebp),%esi
  8018b8:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8018bb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8018be:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8018bf:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8018c5:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8018c8:	50                   	push   %eax
  8018c9:	e8 33 ff ff ff       	call   801801 <fd_lookup>
  8018ce:	89 c3                	mov    %eax,%ebx
  8018d0:	83 c4 10             	add    $0x10,%esp
  8018d3:	85 c0                	test   %eax,%eax
  8018d5:	78 05                	js     8018dc <fd_close+0x30>
	    || fd != fd2)
  8018d7:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8018da:	74 16                	je     8018f2 <fd_close+0x46>
		return (must_exist ? r : 0);
  8018dc:	89 f8                	mov    %edi,%eax
  8018de:	84 c0                	test   %al,%al
  8018e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e5:	0f 44 d8             	cmove  %eax,%ebx
}
  8018e8:	89 d8                	mov    %ebx,%eax
  8018ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018ed:	5b                   	pop    %ebx
  8018ee:	5e                   	pop    %esi
  8018ef:	5f                   	pop    %edi
  8018f0:	5d                   	pop    %ebp
  8018f1:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8018f2:	83 ec 08             	sub    $0x8,%esp
  8018f5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8018f8:	50                   	push   %eax
  8018f9:	ff 36                	pushl  (%esi)
  8018fb:	e8 51 ff ff ff       	call   801851 <dev_lookup>
  801900:	89 c3                	mov    %eax,%ebx
  801902:	83 c4 10             	add    $0x10,%esp
  801905:	85 c0                	test   %eax,%eax
  801907:	78 1a                	js     801923 <fd_close+0x77>
		if (dev->dev_close)
  801909:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80190c:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80190f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801914:	85 c0                	test   %eax,%eax
  801916:	74 0b                	je     801923 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801918:	83 ec 0c             	sub    $0xc,%esp
  80191b:	56                   	push   %esi
  80191c:	ff d0                	call   *%eax
  80191e:	89 c3                	mov    %eax,%ebx
  801920:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801923:	83 ec 08             	sub    $0x8,%esp
  801926:	56                   	push   %esi
  801927:	6a 00                	push   $0x0
  801929:	e8 0e fb ff ff       	call   80143c <sys_page_unmap>
	return r;
  80192e:	83 c4 10             	add    $0x10,%esp
  801931:	eb b5                	jmp    8018e8 <fd_close+0x3c>

00801933 <close>:

int
close(int fdnum)
{
  801933:	55                   	push   %ebp
  801934:	89 e5                	mov    %esp,%ebp
  801936:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801939:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80193c:	50                   	push   %eax
  80193d:	ff 75 08             	pushl  0x8(%ebp)
  801940:	e8 bc fe ff ff       	call   801801 <fd_lookup>
  801945:	83 c4 10             	add    $0x10,%esp
  801948:	85 c0                	test   %eax,%eax
  80194a:	79 02                	jns    80194e <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80194c:	c9                   	leave  
  80194d:	c3                   	ret    
		return fd_close(fd, 1);
  80194e:	83 ec 08             	sub    $0x8,%esp
  801951:	6a 01                	push   $0x1
  801953:	ff 75 f4             	pushl  -0xc(%ebp)
  801956:	e8 51 ff ff ff       	call   8018ac <fd_close>
  80195b:	83 c4 10             	add    $0x10,%esp
  80195e:	eb ec                	jmp    80194c <close+0x19>

00801960 <close_all>:

void
close_all(void)
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
  801963:	53                   	push   %ebx
  801964:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801967:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80196c:	83 ec 0c             	sub    $0xc,%esp
  80196f:	53                   	push   %ebx
  801970:	e8 be ff ff ff       	call   801933 <close>
	for (i = 0; i < MAXFD; i++)
  801975:	83 c3 01             	add    $0x1,%ebx
  801978:	83 c4 10             	add    $0x10,%esp
  80197b:	83 fb 20             	cmp    $0x20,%ebx
  80197e:	75 ec                	jne    80196c <close_all+0xc>
}
  801980:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801983:	c9                   	leave  
  801984:	c3                   	ret    

00801985 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801985:	55                   	push   %ebp
  801986:	89 e5                	mov    %esp,%ebp
  801988:	57                   	push   %edi
  801989:	56                   	push   %esi
  80198a:	53                   	push   %ebx
  80198b:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80198e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801991:	50                   	push   %eax
  801992:	ff 75 08             	pushl  0x8(%ebp)
  801995:	e8 67 fe ff ff       	call   801801 <fd_lookup>
  80199a:	89 c3                	mov    %eax,%ebx
  80199c:	83 c4 10             	add    $0x10,%esp
  80199f:	85 c0                	test   %eax,%eax
  8019a1:	0f 88 81 00 00 00    	js     801a28 <dup+0xa3>
		return r;
	close(newfdnum);
  8019a7:	83 ec 0c             	sub    $0xc,%esp
  8019aa:	ff 75 0c             	pushl  0xc(%ebp)
  8019ad:	e8 81 ff ff ff       	call   801933 <close>

	newfd = INDEX2FD(newfdnum);
  8019b2:	8b 75 0c             	mov    0xc(%ebp),%esi
  8019b5:	c1 e6 0c             	shl    $0xc,%esi
  8019b8:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8019be:	83 c4 04             	add    $0x4,%esp
  8019c1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8019c4:	e8 cf fd ff ff       	call   801798 <fd2data>
  8019c9:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8019cb:	89 34 24             	mov    %esi,(%esp)
  8019ce:	e8 c5 fd ff ff       	call   801798 <fd2data>
  8019d3:	83 c4 10             	add    $0x10,%esp
  8019d6:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8019d8:	89 d8                	mov    %ebx,%eax
  8019da:	c1 e8 16             	shr    $0x16,%eax
  8019dd:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8019e4:	a8 01                	test   $0x1,%al
  8019e6:	74 11                	je     8019f9 <dup+0x74>
  8019e8:	89 d8                	mov    %ebx,%eax
  8019ea:	c1 e8 0c             	shr    $0xc,%eax
  8019ed:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8019f4:	f6 c2 01             	test   $0x1,%dl
  8019f7:	75 39                	jne    801a32 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8019f9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8019fc:	89 d0                	mov    %edx,%eax
  8019fe:	c1 e8 0c             	shr    $0xc,%eax
  801a01:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a08:	83 ec 0c             	sub    $0xc,%esp
  801a0b:	25 07 0e 00 00       	and    $0xe07,%eax
  801a10:	50                   	push   %eax
  801a11:	56                   	push   %esi
  801a12:	6a 00                	push   $0x0
  801a14:	52                   	push   %edx
  801a15:	6a 00                	push   $0x0
  801a17:	e8 de f9 ff ff       	call   8013fa <sys_page_map>
  801a1c:	89 c3                	mov    %eax,%ebx
  801a1e:	83 c4 20             	add    $0x20,%esp
  801a21:	85 c0                	test   %eax,%eax
  801a23:	78 31                	js     801a56 <dup+0xd1>
		goto err;

	return newfdnum;
  801a25:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801a28:	89 d8                	mov    %ebx,%eax
  801a2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a2d:	5b                   	pop    %ebx
  801a2e:	5e                   	pop    %esi
  801a2f:	5f                   	pop    %edi
  801a30:	5d                   	pop    %ebp
  801a31:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801a32:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a39:	83 ec 0c             	sub    $0xc,%esp
  801a3c:	25 07 0e 00 00       	and    $0xe07,%eax
  801a41:	50                   	push   %eax
  801a42:	57                   	push   %edi
  801a43:	6a 00                	push   $0x0
  801a45:	53                   	push   %ebx
  801a46:	6a 00                	push   $0x0
  801a48:	e8 ad f9 ff ff       	call   8013fa <sys_page_map>
  801a4d:	89 c3                	mov    %eax,%ebx
  801a4f:	83 c4 20             	add    $0x20,%esp
  801a52:	85 c0                	test   %eax,%eax
  801a54:	79 a3                	jns    8019f9 <dup+0x74>
	sys_page_unmap(0, newfd);
  801a56:	83 ec 08             	sub    $0x8,%esp
  801a59:	56                   	push   %esi
  801a5a:	6a 00                	push   $0x0
  801a5c:	e8 db f9 ff ff       	call   80143c <sys_page_unmap>
	sys_page_unmap(0, nva);
  801a61:	83 c4 08             	add    $0x8,%esp
  801a64:	57                   	push   %edi
  801a65:	6a 00                	push   $0x0
  801a67:	e8 d0 f9 ff ff       	call   80143c <sys_page_unmap>
	return r;
  801a6c:	83 c4 10             	add    $0x10,%esp
  801a6f:	eb b7                	jmp    801a28 <dup+0xa3>

00801a71 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
  801a74:	53                   	push   %ebx
  801a75:	83 ec 1c             	sub    $0x1c,%esp
  801a78:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a7b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a7e:	50                   	push   %eax
  801a7f:	53                   	push   %ebx
  801a80:	e8 7c fd ff ff       	call   801801 <fd_lookup>
  801a85:	83 c4 10             	add    $0x10,%esp
  801a88:	85 c0                	test   %eax,%eax
  801a8a:	78 3f                	js     801acb <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a8c:	83 ec 08             	sub    $0x8,%esp
  801a8f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a92:	50                   	push   %eax
  801a93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a96:	ff 30                	pushl  (%eax)
  801a98:	e8 b4 fd ff ff       	call   801851 <dev_lookup>
  801a9d:	83 c4 10             	add    $0x10,%esp
  801aa0:	85 c0                	test   %eax,%eax
  801aa2:	78 27                	js     801acb <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801aa4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801aa7:	8b 42 08             	mov    0x8(%edx),%eax
  801aaa:	83 e0 03             	and    $0x3,%eax
  801aad:	83 f8 01             	cmp    $0x1,%eax
  801ab0:	74 1e                	je     801ad0 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801ab2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ab5:	8b 40 08             	mov    0x8(%eax),%eax
  801ab8:	85 c0                	test   %eax,%eax
  801aba:	74 35                	je     801af1 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801abc:	83 ec 04             	sub    $0x4,%esp
  801abf:	ff 75 10             	pushl  0x10(%ebp)
  801ac2:	ff 75 0c             	pushl  0xc(%ebp)
  801ac5:	52                   	push   %edx
  801ac6:	ff d0                	call   *%eax
  801ac8:	83 c4 10             	add    $0x10,%esp
}
  801acb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ace:	c9                   	leave  
  801acf:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801ad0:	a1 08 50 80 00       	mov    0x805008,%eax
  801ad5:	8b 40 48             	mov    0x48(%eax),%eax
  801ad8:	83 ec 04             	sub    $0x4,%esp
  801adb:	53                   	push   %ebx
  801adc:	50                   	push   %eax
  801add:	68 f4 33 80 00       	push   $0x8033f4
  801ae2:	e8 7f ed ff ff       	call   800866 <cprintf>
		return -E_INVAL;
  801ae7:	83 c4 10             	add    $0x10,%esp
  801aea:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801aef:	eb da                	jmp    801acb <read+0x5a>
		return -E_NOT_SUPP;
  801af1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801af6:	eb d3                	jmp    801acb <read+0x5a>

00801af8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801af8:	55                   	push   %ebp
  801af9:	89 e5                	mov    %esp,%ebp
  801afb:	57                   	push   %edi
  801afc:	56                   	push   %esi
  801afd:	53                   	push   %ebx
  801afe:	83 ec 0c             	sub    $0xc,%esp
  801b01:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b04:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801b07:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b0c:	39 f3                	cmp    %esi,%ebx
  801b0e:	73 23                	jae    801b33 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801b10:	83 ec 04             	sub    $0x4,%esp
  801b13:	89 f0                	mov    %esi,%eax
  801b15:	29 d8                	sub    %ebx,%eax
  801b17:	50                   	push   %eax
  801b18:	89 d8                	mov    %ebx,%eax
  801b1a:	03 45 0c             	add    0xc(%ebp),%eax
  801b1d:	50                   	push   %eax
  801b1e:	57                   	push   %edi
  801b1f:	e8 4d ff ff ff       	call   801a71 <read>
		if (m < 0)
  801b24:	83 c4 10             	add    $0x10,%esp
  801b27:	85 c0                	test   %eax,%eax
  801b29:	78 06                	js     801b31 <readn+0x39>
			return m;
		if (m == 0)
  801b2b:	74 06                	je     801b33 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801b2d:	01 c3                	add    %eax,%ebx
  801b2f:	eb db                	jmp    801b0c <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801b31:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801b33:	89 d8                	mov    %ebx,%eax
  801b35:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b38:	5b                   	pop    %ebx
  801b39:	5e                   	pop    %esi
  801b3a:	5f                   	pop    %edi
  801b3b:	5d                   	pop    %ebp
  801b3c:	c3                   	ret    

00801b3d <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801b3d:	55                   	push   %ebp
  801b3e:	89 e5                	mov    %esp,%ebp
  801b40:	53                   	push   %ebx
  801b41:	83 ec 1c             	sub    $0x1c,%esp
  801b44:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b47:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b4a:	50                   	push   %eax
  801b4b:	53                   	push   %ebx
  801b4c:	e8 b0 fc ff ff       	call   801801 <fd_lookup>
  801b51:	83 c4 10             	add    $0x10,%esp
  801b54:	85 c0                	test   %eax,%eax
  801b56:	78 3a                	js     801b92 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b58:	83 ec 08             	sub    $0x8,%esp
  801b5b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b5e:	50                   	push   %eax
  801b5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b62:	ff 30                	pushl  (%eax)
  801b64:	e8 e8 fc ff ff       	call   801851 <dev_lookup>
  801b69:	83 c4 10             	add    $0x10,%esp
  801b6c:	85 c0                	test   %eax,%eax
  801b6e:	78 22                	js     801b92 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b73:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b77:	74 1e                	je     801b97 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801b79:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b7c:	8b 52 0c             	mov    0xc(%edx),%edx
  801b7f:	85 d2                	test   %edx,%edx
  801b81:	74 35                	je     801bb8 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801b83:	83 ec 04             	sub    $0x4,%esp
  801b86:	ff 75 10             	pushl  0x10(%ebp)
  801b89:	ff 75 0c             	pushl  0xc(%ebp)
  801b8c:	50                   	push   %eax
  801b8d:	ff d2                	call   *%edx
  801b8f:	83 c4 10             	add    $0x10,%esp
}
  801b92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b95:	c9                   	leave  
  801b96:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801b97:	a1 08 50 80 00       	mov    0x805008,%eax
  801b9c:	8b 40 48             	mov    0x48(%eax),%eax
  801b9f:	83 ec 04             	sub    $0x4,%esp
  801ba2:	53                   	push   %ebx
  801ba3:	50                   	push   %eax
  801ba4:	68 10 34 80 00       	push   $0x803410
  801ba9:	e8 b8 ec ff ff       	call   800866 <cprintf>
		return -E_INVAL;
  801bae:	83 c4 10             	add    $0x10,%esp
  801bb1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bb6:	eb da                	jmp    801b92 <write+0x55>
		return -E_NOT_SUPP;
  801bb8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bbd:	eb d3                	jmp    801b92 <write+0x55>

00801bbf <seek>:

int
seek(int fdnum, off_t offset)
{
  801bbf:	55                   	push   %ebp
  801bc0:	89 e5                	mov    %esp,%ebp
  801bc2:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801bc5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bc8:	50                   	push   %eax
  801bc9:	ff 75 08             	pushl  0x8(%ebp)
  801bcc:	e8 30 fc ff ff       	call   801801 <fd_lookup>
  801bd1:	83 c4 10             	add    $0x10,%esp
  801bd4:	85 c0                	test   %eax,%eax
  801bd6:	78 0e                	js     801be6 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801bd8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bde:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801be1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801be6:	c9                   	leave  
  801be7:	c3                   	ret    

00801be8 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801be8:	55                   	push   %ebp
  801be9:	89 e5                	mov    %esp,%ebp
  801beb:	53                   	push   %ebx
  801bec:	83 ec 1c             	sub    $0x1c,%esp
  801bef:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801bf2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bf5:	50                   	push   %eax
  801bf6:	53                   	push   %ebx
  801bf7:	e8 05 fc ff ff       	call   801801 <fd_lookup>
  801bfc:	83 c4 10             	add    $0x10,%esp
  801bff:	85 c0                	test   %eax,%eax
  801c01:	78 37                	js     801c3a <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c03:	83 ec 08             	sub    $0x8,%esp
  801c06:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c09:	50                   	push   %eax
  801c0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c0d:	ff 30                	pushl  (%eax)
  801c0f:	e8 3d fc ff ff       	call   801851 <dev_lookup>
  801c14:	83 c4 10             	add    $0x10,%esp
  801c17:	85 c0                	test   %eax,%eax
  801c19:	78 1f                	js     801c3a <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c1e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801c22:	74 1b                	je     801c3f <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801c24:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c27:	8b 52 18             	mov    0x18(%edx),%edx
  801c2a:	85 d2                	test   %edx,%edx
  801c2c:	74 32                	je     801c60 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801c2e:	83 ec 08             	sub    $0x8,%esp
  801c31:	ff 75 0c             	pushl  0xc(%ebp)
  801c34:	50                   	push   %eax
  801c35:	ff d2                	call   *%edx
  801c37:	83 c4 10             	add    $0x10,%esp
}
  801c3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c3d:	c9                   	leave  
  801c3e:	c3                   	ret    
			thisenv->env_id, fdnum);
  801c3f:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801c44:	8b 40 48             	mov    0x48(%eax),%eax
  801c47:	83 ec 04             	sub    $0x4,%esp
  801c4a:	53                   	push   %ebx
  801c4b:	50                   	push   %eax
  801c4c:	68 d0 33 80 00       	push   $0x8033d0
  801c51:	e8 10 ec ff ff       	call   800866 <cprintf>
		return -E_INVAL;
  801c56:	83 c4 10             	add    $0x10,%esp
  801c59:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c5e:	eb da                	jmp    801c3a <ftruncate+0x52>
		return -E_NOT_SUPP;
  801c60:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c65:	eb d3                	jmp    801c3a <ftruncate+0x52>

00801c67 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801c67:	55                   	push   %ebp
  801c68:	89 e5                	mov    %esp,%ebp
  801c6a:	53                   	push   %ebx
  801c6b:	83 ec 1c             	sub    $0x1c,%esp
  801c6e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c71:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c74:	50                   	push   %eax
  801c75:	ff 75 08             	pushl  0x8(%ebp)
  801c78:	e8 84 fb ff ff       	call   801801 <fd_lookup>
  801c7d:	83 c4 10             	add    $0x10,%esp
  801c80:	85 c0                	test   %eax,%eax
  801c82:	78 4b                	js     801ccf <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c84:	83 ec 08             	sub    $0x8,%esp
  801c87:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c8a:	50                   	push   %eax
  801c8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c8e:	ff 30                	pushl  (%eax)
  801c90:	e8 bc fb ff ff       	call   801851 <dev_lookup>
  801c95:	83 c4 10             	add    $0x10,%esp
  801c98:	85 c0                	test   %eax,%eax
  801c9a:	78 33                	js     801ccf <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c9f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801ca3:	74 2f                	je     801cd4 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801ca5:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801ca8:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801caf:	00 00 00 
	stat->st_isdir = 0;
  801cb2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801cb9:	00 00 00 
	stat->st_dev = dev;
  801cbc:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801cc2:	83 ec 08             	sub    $0x8,%esp
  801cc5:	53                   	push   %ebx
  801cc6:	ff 75 f0             	pushl  -0x10(%ebp)
  801cc9:	ff 50 14             	call   *0x14(%eax)
  801ccc:	83 c4 10             	add    $0x10,%esp
}
  801ccf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cd2:	c9                   	leave  
  801cd3:	c3                   	ret    
		return -E_NOT_SUPP;
  801cd4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801cd9:	eb f4                	jmp    801ccf <fstat+0x68>

00801cdb <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801cdb:	55                   	push   %ebp
  801cdc:	89 e5                	mov    %esp,%ebp
  801cde:	56                   	push   %esi
  801cdf:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801ce0:	83 ec 08             	sub    $0x8,%esp
  801ce3:	6a 00                	push   $0x0
  801ce5:	ff 75 08             	pushl  0x8(%ebp)
  801ce8:	e8 22 02 00 00       	call   801f0f <open>
  801ced:	89 c3                	mov    %eax,%ebx
  801cef:	83 c4 10             	add    $0x10,%esp
  801cf2:	85 c0                	test   %eax,%eax
  801cf4:	78 1b                	js     801d11 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801cf6:	83 ec 08             	sub    $0x8,%esp
  801cf9:	ff 75 0c             	pushl  0xc(%ebp)
  801cfc:	50                   	push   %eax
  801cfd:	e8 65 ff ff ff       	call   801c67 <fstat>
  801d02:	89 c6                	mov    %eax,%esi
	close(fd);
  801d04:	89 1c 24             	mov    %ebx,(%esp)
  801d07:	e8 27 fc ff ff       	call   801933 <close>
	return r;
  801d0c:	83 c4 10             	add    $0x10,%esp
  801d0f:	89 f3                	mov    %esi,%ebx
}
  801d11:	89 d8                	mov    %ebx,%eax
  801d13:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d16:	5b                   	pop    %ebx
  801d17:	5e                   	pop    %esi
  801d18:	5d                   	pop    %ebp
  801d19:	c3                   	ret    

00801d1a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801d1a:	55                   	push   %ebp
  801d1b:	89 e5                	mov    %esp,%ebp
  801d1d:	56                   	push   %esi
  801d1e:	53                   	push   %ebx
  801d1f:	89 c6                	mov    %eax,%esi
  801d21:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801d23:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801d2a:	74 27                	je     801d53 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801d2c:	6a 07                	push   $0x7
  801d2e:	68 00 60 80 00       	push   $0x806000
  801d33:	56                   	push   %esi
  801d34:	ff 35 00 50 80 00    	pushl  0x805000
  801d3a:	e8 b6 f9 ff ff       	call   8016f5 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801d3f:	83 c4 0c             	add    $0xc,%esp
  801d42:	6a 00                	push   $0x0
  801d44:	53                   	push   %ebx
  801d45:	6a 00                	push   $0x0
  801d47:	e8 40 f9 ff ff       	call   80168c <ipc_recv>
}
  801d4c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d4f:	5b                   	pop    %ebx
  801d50:	5e                   	pop    %esi
  801d51:	5d                   	pop    %ebp
  801d52:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801d53:	83 ec 0c             	sub    $0xc,%esp
  801d56:	6a 01                	push   $0x1
  801d58:	e8 f0 f9 ff ff       	call   80174d <ipc_find_env>
  801d5d:	a3 00 50 80 00       	mov    %eax,0x805000
  801d62:	83 c4 10             	add    $0x10,%esp
  801d65:	eb c5                	jmp    801d2c <fsipc+0x12>

00801d67 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801d67:	55                   	push   %ebp
  801d68:	89 e5                	mov    %esp,%ebp
  801d6a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d70:	8b 40 0c             	mov    0xc(%eax),%eax
  801d73:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801d78:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d7b:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801d80:	ba 00 00 00 00       	mov    $0x0,%edx
  801d85:	b8 02 00 00 00       	mov    $0x2,%eax
  801d8a:	e8 8b ff ff ff       	call   801d1a <fsipc>
}
  801d8f:	c9                   	leave  
  801d90:	c3                   	ret    

00801d91 <devfile_flush>:
{
  801d91:	55                   	push   %ebp
  801d92:	89 e5                	mov    %esp,%ebp
  801d94:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801d97:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9a:	8b 40 0c             	mov    0xc(%eax),%eax
  801d9d:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801da2:	ba 00 00 00 00       	mov    $0x0,%edx
  801da7:	b8 06 00 00 00       	mov    $0x6,%eax
  801dac:	e8 69 ff ff ff       	call   801d1a <fsipc>
}
  801db1:	c9                   	leave  
  801db2:	c3                   	ret    

00801db3 <devfile_stat>:
{
  801db3:	55                   	push   %ebp
  801db4:	89 e5                	mov    %esp,%ebp
  801db6:	53                   	push   %ebx
  801db7:	83 ec 04             	sub    $0x4,%esp
  801dba:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc0:	8b 40 0c             	mov    0xc(%eax),%eax
  801dc3:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801dc8:	ba 00 00 00 00       	mov    $0x0,%edx
  801dcd:	b8 05 00 00 00       	mov    $0x5,%eax
  801dd2:	e8 43 ff ff ff       	call   801d1a <fsipc>
  801dd7:	85 c0                	test   %eax,%eax
  801dd9:	78 2c                	js     801e07 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801ddb:	83 ec 08             	sub    $0x8,%esp
  801dde:	68 00 60 80 00       	push   $0x806000
  801de3:	53                   	push   %ebx
  801de4:	e8 dc f1 ff ff       	call   800fc5 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801de9:	a1 80 60 80 00       	mov    0x806080,%eax
  801dee:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801df4:	a1 84 60 80 00       	mov    0x806084,%eax
  801df9:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801dff:	83 c4 10             	add    $0x10,%esp
  801e02:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e07:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e0a:	c9                   	leave  
  801e0b:	c3                   	ret    

00801e0c <devfile_write>:
{
  801e0c:	55                   	push   %ebp
  801e0d:	89 e5                	mov    %esp,%ebp
  801e0f:	53                   	push   %ebx
  801e10:	83 ec 08             	sub    $0x8,%esp
  801e13:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801e16:	8b 45 08             	mov    0x8(%ebp),%eax
  801e19:	8b 40 0c             	mov    0xc(%eax),%eax
  801e1c:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801e21:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801e27:	53                   	push   %ebx
  801e28:	ff 75 0c             	pushl  0xc(%ebp)
  801e2b:	68 08 60 80 00       	push   $0x806008
  801e30:	e8 80 f3 ff ff       	call   8011b5 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801e35:	ba 00 00 00 00       	mov    $0x0,%edx
  801e3a:	b8 04 00 00 00       	mov    $0x4,%eax
  801e3f:	e8 d6 fe ff ff       	call   801d1a <fsipc>
  801e44:	83 c4 10             	add    $0x10,%esp
  801e47:	85 c0                	test   %eax,%eax
  801e49:	78 0b                	js     801e56 <devfile_write+0x4a>
	assert(r <= n);
  801e4b:	39 d8                	cmp    %ebx,%eax
  801e4d:	77 0c                	ja     801e5b <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801e4f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801e54:	7f 1e                	jg     801e74 <devfile_write+0x68>
}
  801e56:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e59:	c9                   	leave  
  801e5a:	c3                   	ret    
	assert(r <= n);
  801e5b:	68 44 34 80 00       	push   $0x803444
  801e60:	68 4b 34 80 00       	push   $0x80344b
  801e65:	68 98 00 00 00       	push   $0x98
  801e6a:	68 60 34 80 00       	push   $0x803460
  801e6f:	e8 fc e8 ff ff       	call   800770 <_panic>
	assert(r <= PGSIZE);
  801e74:	68 6b 34 80 00       	push   $0x80346b
  801e79:	68 4b 34 80 00       	push   $0x80344b
  801e7e:	68 99 00 00 00       	push   $0x99
  801e83:	68 60 34 80 00       	push   $0x803460
  801e88:	e8 e3 e8 ff ff       	call   800770 <_panic>

00801e8d <devfile_read>:
{
  801e8d:	55                   	push   %ebp
  801e8e:	89 e5                	mov    %esp,%ebp
  801e90:	56                   	push   %esi
  801e91:	53                   	push   %ebx
  801e92:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801e95:	8b 45 08             	mov    0x8(%ebp),%eax
  801e98:	8b 40 0c             	mov    0xc(%eax),%eax
  801e9b:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801ea0:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801ea6:	ba 00 00 00 00       	mov    $0x0,%edx
  801eab:	b8 03 00 00 00       	mov    $0x3,%eax
  801eb0:	e8 65 fe ff ff       	call   801d1a <fsipc>
  801eb5:	89 c3                	mov    %eax,%ebx
  801eb7:	85 c0                	test   %eax,%eax
  801eb9:	78 1f                	js     801eda <devfile_read+0x4d>
	assert(r <= n);
  801ebb:	39 f0                	cmp    %esi,%eax
  801ebd:	77 24                	ja     801ee3 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801ebf:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ec4:	7f 33                	jg     801ef9 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801ec6:	83 ec 04             	sub    $0x4,%esp
  801ec9:	50                   	push   %eax
  801eca:	68 00 60 80 00       	push   $0x806000
  801ecf:	ff 75 0c             	pushl  0xc(%ebp)
  801ed2:	e8 7c f2 ff ff       	call   801153 <memmove>
	return r;
  801ed7:	83 c4 10             	add    $0x10,%esp
}
  801eda:	89 d8                	mov    %ebx,%eax
  801edc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801edf:	5b                   	pop    %ebx
  801ee0:	5e                   	pop    %esi
  801ee1:	5d                   	pop    %ebp
  801ee2:	c3                   	ret    
	assert(r <= n);
  801ee3:	68 44 34 80 00       	push   $0x803444
  801ee8:	68 4b 34 80 00       	push   $0x80344b
  801eed:	6a 7c                	push   $0x7c
  801eef:	68 60 34 80 00       	push   $0x803460
  801ef4:	e8 77 e8 ff ff       	call   800770 <_panic>
	assert(r <= PGSIZE);
  801ef9:	68 6b 34 80 00       	push   $0x80346b
  801efe:	68 4b 34 80 00       	push   $0x80344b
  801f03:	6a 7d                	push   $0x7d
  801f05:	68 60 34 80 00       	push   $0x803460
  801f0a:	e8 61 e8 ff ff       	call   800770 <_panic>

00801f0f <open>:
{
  801f0f:	55                   	push   %ebp
  801f10:	89 e5                	mov    %esp,%ebp
  801f12:	56                   	push   %esi
  801f13:	53                   	push   %ebx
  801f14:	83 ec 1c             	sub    $0x1c,%esp
  801f17:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801f1a:	56                   	push   %esi
  801f1b:	e8 6c f0 ff ff       	call   800f8c <strlen>
  801f20:	83 c4 10             	add    $0x10,%esp
  801f23:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801f28:	7f 6c                	jg     801f96 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801f2a:	83 ec 0c             	sub    $0xc,%esp
  801f2d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f30:	50                   	push   %eax
  801f31:	e8 79 f8 ff ff       	call   8017af <fd_alloc>
  801f36:	89 c3                	mov    %eax,%ebx
  801f38:	83 c4 10             	add    $0x10,%esp
  801f3b:	85 c0                	test   %eax,%eax
  801f3d:	78 3c                	js     801f7b <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801f3f:	83 ec 08             	sub    $0x8,%esp
  801f42:	56                   	push   %esi
  801f43:	68 00 60 80 00       	push   $0x806000
  801f48:	e8 78 f0 ff ff       	call   800fc5 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801f4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f50:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801f55:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f58:	b8 01 00 00 00       	mov    $0x1,%eax
  801f5d:	e8 b8 fd ff ff       	call   801d1a <fsipc>
  801f62:	89 c3                	mov    %eax,%ebx
  801f64:	83 c4 10             	add    $0x10,%esp
  801f67:	85 c0                	test   %eax,%eax
  801f69:	78 19                	js     801f84 <open+0x75>
	return fd2num(fd);
  801f6b:	83 ec 0c             	sub    $0xc,%esp
  801f6e:	ff 75 f4             	pushl  -0xc(%ebp)
  801f71:	e8 12 f8 ff ff       	call   801788 <fd2num>
  801f76:	89 c3                	mov    %eax,%ebx
  801f78:	83 c4 10             	add    $0x10,%esp
}
  801f7b:	89 d8                	mov    %ebx,%eax
  801f7d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f80:	5b                   	pop    %ebx
  801f81:	5e                   	pop    %esi
  801f82:	5d                   	pop    %ebp
  801f83:	c3                   	ret    
		fd_close(fd, 0);
  801f84:	83 ec 08             	sub    $0x8,%esp
  801f87:	6a 00                	push   $0x0
  801f89:	ff 75 f4             	pushl  -0xc(%ebp)
  801f8c:	e8 1b f9 ff ff       	call   8018ac <fd_close>
		return r;
  801f91:	83 c4 10             	add    $0x10,%esp
  801f94:	eb e5                	jmp    801f7b <open+0x6c>
		return -E_BAD_PATH;
  801f96:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801f9b:	eb de                	jmp    801f7b <open+0x6c>

00801f9d <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801f9d:	55                   	push   %ebp
  801f9e:	89 e5                	mov    %esp,%ebp
  801fa0:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801fa3:	ba 00 00 00 00       	mov    $0x0,%edx
  801fa8:	b8 08 00 00 00       	mov    $0x8,%eax
  801fad:	e8 68 fd ff ff       	call   801d1a <fsipc>
}
  801fb2:	c9                   	leave  
  801fb3:	c3                   	ret    

00801fb4 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801fb4:	55                   	push   %ebp
  801fb5:	89 e5                	mov    %esp,%ebp
  801fb7:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801fba:	68 77 34 80 00       	push   $0x803477
  801fbf:	ff 75 0c             	pushl  0xc(%ebp)
  801fc2:	e8 fe ef ff ff       	call   800fc5 <strcpy>
	return 0;
}
  801fc7:	b8 00 00 00 00       	mov    $0x0,%eax
  801fcc:	c9                   	leave  
  801fcd:	c3                   	ret    

00801fce <devsock_close>:
{
  801fce:	55                   	push   %ebp
  801fcf:	89 e5                	mov    %esp,%ebp
  801fd1:	53                   	push   %ebx
  801fd2:	83 ec 10             	sub    $0x10,%esp
  801fd5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801fd8:	53                   	push   %ebx
  801fd9:	e8 00 09 00 00       	call   8028de <pageref>
  801fde:	83 c4 10             	add    $0x10,%esp
		return 0;
  801fe1:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801fe6:	83 f8 01             	cmp    $0x1,%eax
  801fe9:	74 07                	je     801ff2 <devsock_close+0x24>
}
  801feb:	89 d0                	mov    %edx,%eax
  801fed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ff0:	c9                   	leave  
  801ff1:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801ff2:	83 ec 0c             	sub    $0xc,%esp
  801ff5:	ff 73 0c             	pushl  0xc(%ebx)
  801ff8:	e8 b9 02 00 00       	call   8022b6 <nsipc_close>
  801ffd:	89 c2                	mov    %eax,%edx
  801fff:	83 c4 10             	add    $0x10,%esp
  802002:	eb e7                	jmp    801feb <devsock_close+0x1d>

00802004 <devsock_write>:
{
  802004:	55                   	push   %ebp
  802005:	89 e5                	mov    %esp,%ebp
  802007:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80200a:	6a 00                	push   $0x0
  80200c:	ff 75 10             	pushl  0x10(%ebp)
  80200f:	ff 75 0c             	pushl  0xc(%ebp)
  802012:	8b 45 08             	mov    0x8(%ebp),%eax
  802015:	ff 70 0c             	pushl  0xc(%eax)
  802018:	e8 76 03 00 00       	call   802393 <nsipc_send>
}
  80201d:	c9                   	leave  
  80201e:	c3                   	ret    

0080201f <devsock_read>:
{
  80201f:	55                   	push   %ebp
  802020:	89 e5                	mov    %esp,%ebp
  802022:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802025:	6a 00                	push   $0x0
  802027:	ff 75 10             	pushl  0x10(%ebp)
  80202a:	ff 75 0c             	pushl  0xc(%ebp)
  80202d:	8b 45 08             	mov    0x8(%ebp),%eax
  802030:	ff 70 0c             	pushl  0xc(%eax)
  802033:	e8 ef 02 00 00       	call   802327 <nsipc_recv>
}
  802038:	c9                   	leave  
  802039:	c3                   	ret    

0080203a <fd2sockid>:
{
  80203a:	55                   	push   %ebp
  80203b:	89 e5                	mov    %esp,%ebp
  80203d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  802040:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802043:	52                   	push   %edx
  802044:	50                   	push   %eax
  802045:	e8 b7 f7 ff ff       	call   801801 <fd_lookup>
  80204a:	83 c4 10             	add    $0x10,%esp
  80204d:	85 c0                	test   %eax,%eax
  80204f:	78 10                	js     802061 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  802051:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802054:	8b 0d 24 40 80 00    	mov    0x804024,%ecx
  80205a:	39 08                	cmp    %ecx,(%eax)
  80205c:	75 05                	jne    802063 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80205e:	8b 40 0c             	mov    0xc(%eax),%eax
}
  802061:	c9                   	leave  
  802062:	c3                   	ret    
		return -E_NOT_SUPP;
  802063:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802068:	eb f7                	jmp    802061 <fd2sockid+0x27>

0080206a <alloc_sockfd>:
{
  80206a:	55                   	push   %ebp
  80206b:	89 e5                	mov    %esp,%ebp
  80206d:	56                   	push   %esi
  80206e:	53                   	push   %ebx
  80206f:	83 ec 1c             	sub    $0x1c,%esp
  802072:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  802074:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802077:	50                   	push   %eax
  802078:	e8 32 f7 ff ff       	call   8017af <fd_alloc>
  80207d:	89 c3                	mov    %eax,%ebx
  80207f:	83 c4 10             	add    $0x10,%esp
  802082:	85 c0                	test   %eax,%eax
  802084:	78 43                	js     8020c9 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802086:	83 ec 04             	sub    $0x4,%esp
  802089:	68 07 04 00 00       	push   $0x407
  80208e:	ff 75 f4             	pushl  -0xc(%ebp)
  802091:	6a 00                	push   $0x0
  802093:	e8 1f f3 ff ff       	call   8013b7 <sys_page_alloc>
  802098:	89 c3                	mov    %eax,%ebx
  80209a:	83 c4 10             	add    $0x10,%esp
  80209d:	85 c0                	test   %eax,%eax
  80209f:	78 28                	js     8020c9 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8020a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a4:	8b 15 24 40 80 00    	mov    0x804024,%edx
  8020aa:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8020ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020af:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8020b6:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8020b9:	83 ec 0c             	sub    $0xc,%esp
  8020bc:	50                   	push   %eax
  8020bd:	e8 c6 f6 ff ff       	call   801788 <fd2num>
  8020c2:	89 c3                	mov    %eax,%ebx
  8020c4:	83 c4 10             	add    $0x10,%esp
  8020c7:	eb 0c                	jmp    8020d5 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8020c9:	83 ec 0c             	sub    $0xc,%esp
  8020cc:	56                   	push   %esi
  8020cd:	e8 e4 01 00 00       	call   8022b6 <nsipc_close>
		return r;
  8020d2:	83 c4 10             	add    $0x10,%esp
}
  8020d5:	89 d8                	mov    %ebx,%eax
  8020d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020da:	5b                   	pop    %ebx
  8020db:	5e                   	pop    %esi
  8020dc:	5d                   	pop    %ebp
  8020dd:	c3                   	ret    

008020de <accept>:
{
  8020de:	55                   	push   %ebp
  8020df:	89 e5                	mov    %esp,%ebp
  8020e1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e7:	e8 4e ff ff ff       	call   80203a <fd2sockid>
  8020ec:	85 c0                	test   %eax,%eax
  8020ee:	78 1b                	js     80210b <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8020f0:	83 ec 04             	sub    $0x4,%esp
  8020f3:	ff 75 10             	pushl  0x10(%ebp)
  8020f6:	ff 75 0c             	pushl  0xc(%ebp)
  8020f9:	50                   	push   %eax
  8020fa:	e8 0e 01 00 00       	call   80220d <nsipc_accept>
  8020ff:	83 c4 10             	add    $0x10,%esp
  802102:	85 c0                	test   %eax,%eax
  802104:	78 05                	js     80210b <accept+0x2d>
	return alloc_sockfd(r);
  802106:	e8 5f ff ff ff       	call   80206a <alloc_sockfd>
}
  80210b:	c9                   	leave  
  80210c:	c3                   	ret    

0080210d <bind>:
{
  80210d:	55                   	push   %ebp
  80210e:	89 e5                	mov    %esp,%ebp
  802110:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802113:	8b 45 08             	mov    0x8(%ebp),%eax
  802116:	e8 1f ff ff ff       	call   80203a <fd2sockid>
  80211b:	85 c0                	test   %eax,%eax
  80211d:	78 12                	js     802131 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  80211f:	83 ec 04             	sub    $0x4,%esp
  802122:	ff 75 10             	pushl  0x10(%ebp)
  802125:	ff 75 0c             	pushl  0xc(%ebp)
  802128:	50                   	push   %eax
  802129:	e8 31 01 00 00       	call   80225f <nsipc_bind>
  80212e:	83 c4 10             	add    $0x10,%esp
}
  802131:	c9                   	leave  
  802132:	c3                   	ret    

00802133 <shutdown>:
{
  802133:	55                   	push   %ebp
  802134:	89 e5                	mov    %esp,%ebp
  802136:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802139:	8b 45 08             	mov    0x8(%ebp),%eax
  80213c:	e8 f9 fe ff ff       	call   80203a <fd2sockid>
  802141:	85 c0                	test   %eax,%eax
  802143:	78 0f                	js     802154 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  802145:	83 ec 08             	sub    $0x8,%esp
  802148:	ff 75 0c             	pushl  0xc(%ebp)
  80214b:	50                   	push   %eax
  80214c:	e8 43 01 00 00       	call   802294 <nsipc_shutdown>
  802151:	83 c4 10             	add    $0x10,%esp
}
  802154:	c9                   	leave  
  802155:	c3                   	ret    

00802156 <connect>:
{
  802156:	55                   	push   %ebp
  802157:	89 e5                	mov    %esp,%ebp
  802159:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80215c:	8b 45 08             	mov    0x8(%ebp),%eax
  80215f:	e8 d6 fe ff ff       	call   80203a <fd2sockid>
  802164:	85 c0                	test   %eax,%eax
  802166:	78 12                	js     80217a <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802168:	83 ec 04             	sub    $0x4,%esp
  80216b:	ff 75 10             	pushl  0x10(%ebp)
  80216e:	ff 75 0c             	pushl  0xc(%ebp)
  802171:	50                   	push   %eax
  802172:	e8 59 01 00 00       	call   8022d0 <nsipc_connect>
  802177:	83 c4 10             	add    $0x10,%esp
}
  80217a:	c9                   	leave  
  80217b:	c3                   	ret    

0080217c <listen>:
{
  80217c:	55                   	push   %ebp
  80217d:	89 e5                	mov    %esp,%ebp
  80217f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802182:	8b 45 08             	mov    0x8(%ebp),%eax
  802185:	e8 b0 fe ff ff       	call   80203a <fd2sockid>
  80218a:	85 c0                	test   %eax,%eax
  80218c:	78 0f                	js     80219d <listen+0x21>
	return nsipc_listen(r, backlog);
  80218e:	83 ec 08             	sub    $0x8,%esp
  802191:	ff 75 0c             	pushl  0xc(%ebp)
  802194:	50                   	push   %eax
  802195:	e8 6b 01 00 00       	call   802305 <nsipc_listen>
  80219a:	83 c4 10             	add    $0x10,%esp
}
  80219d:	c9                   	leave  
  80219e:	c3                   	ret    

0080219f <socket>:

int
socket(int domain, int type, int protocol)
{
  80219f:	55                   	push   %ebp
  8021a0:	89 e5                	mov    %esp,%ebp
  8021a2:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8021a5:	ff 75 10             	pushl  0x10(%ebp)
  8021a8:	ff 75 0c             	pushl  0xc(%ebp)
  8021ab:	ff 75 08             	pushl  0x8(%ebp)
  8021ae:	e8 3e 02 00 00       	call   8023f1 <nsipc_socket>
  8021b3:	83 c4 10             	add    $0x10,%esp
  8021b6:	85 c0                	test   %eax,%eax
  8021b8:	78 05                	js     8021bf <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8021ba:	e8 ab fe ff ff       	call   80206a <alloc_sockfd>
}
  8021bf:	c9                   	leave  
  8021c0:	c3                   	ret    

008021c1 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8021c1:	55                   	push   %ebp
  8021c2:	89 e5                	mov    %esp,%ebp
  8021c4:	53                   	push   %ebx
  8021c5:	83 ec 04             	sub    $0x4,%esp
  8021c8:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8021ca:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8021d1:	74 26                	je     8021f9 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8021d3:	6a 07                	push   $0x7
  8021d5:	68 00 70 80 00       	push   $0x807000
  8021da:	53                   	push   %ebx
  8021db:	ff 35 04 50 80 00    	pushl  0x805004
  8021e1:	e8 0f f5 ff ff       	call   8016f5 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8021e6:	83 c4 0c             	add    $0xc,%esp
  8021e9:	6a 00                	push   $0x0
  8021eb:	6a 00                	push   $0x0
  8021ed:	6a 00                	push   $0x0
  8021ef:	e8 98 f4 ff ff       	call   80168c <ipc_recv>
}
  8021f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021f7:	c9                   	leave  
  8021f8:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8021f9:	83 ec 0c             	sub    $0xc,%esp
  8021fc:	6a 02                	push   $0x2
  8021fe:	e8 4a f5 ff ff       	call   80174d <ipc_find_env>
  802203:	a3 04 50 80 00       	mov    %eax,0x805004
  802208:	83 c4 10             	add    $0x10,%esp
  80220b:	eb c6                	jmp    8021d3 <nsipc+0x12>

0080220d <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80220d:	55                   	push   %ebp
  80220e:	89 e5                	mov    %esp,%ebp
  802210:	56                   	push   %esi
  802211:	53                   	push   %ebx
  802212:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802215:	8b 45 08             	mov    0x8(%ebp),%eax
  802218:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80221d:	8b 06                	mov    (%esi),%eax
  80221f:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802224:	b8 01 00 00 00       	mov    $0x1,%eax
  802229:	e8 93 ff ff ff       	call   8021c1 <nsipc>
  80222e:	89 c3                	mov    %eax,%ebx
  802230:	85 c0                	test   %eax,%eax
  802232:	79 09                	jns    80223d <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802234:	89 d8                	mov    %ebx,%eax
  802236:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802239:	5b                   	pop    %ebx
  80223a:	5e                   	pop    %esi
  80223b:	5d                   	pop    %ebp
  80223c:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80223d:	83 ec 04             	sub    $0x4,%esp
  802240:	ff 35 10 70 80 00    	pushl  0x807010
  802246:	68 00 70 80 00       	push   $0x807000
  80224b:	ff 75 0c             	pushl  0xc(%ebp)
  80224e:	e8 00 ef ff ff       	call   801153 <memmove>
		*addrlen = ret->ret_addrlen;
  802253:	a1 10 70 80 00       	mov    0x807010,%eax
  802258:	89 06                	mov    %eax,(%esi)
  80225a:	83 c4 10             	add    $0x10,%esp
	return r;
  80225d:	eb d5                	jmp    802234 <nsipc_accept+0x27>

0080225f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80225f:	55                   	push   %ebp
  802260:	89 e5                	mov    %esp,%ebp
  802262:	53                   	push   %ebx
  802263:	83 ec 08             	sub    $0x8,%esp
  802266:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802269:	8b 45 08             	mov    0x8(%ebp),%eax
  80226c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802271:	53                   	push   %ebx
  802272:	ff 75 0c             	pushl  0xc(%ebp)
  802275:	68 04 70 80 00       	push   $0x807004
  80227a:	e8 d4 ee ff ff       	call   801153 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80227f:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802285:	b8 02 00 00 00       	mov    $0x2,%eax
  80228a:	e8 32 ff ff ff       	call   8021c1 <nsipc>
}
  80228f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802292:	c9                   	leave  
  802293:	c3                   	ret    

00802294 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802294:	55                   	push   %ebp
  802295:	89 e5                	mov    %esp,%ebp
  802297:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80229a:	8b 45 08             	mov    0x8(%ebp),%eax
  80229d:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8022a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022a5:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8022aa:	b8 03 00 00 00       	mov    $0x3,%eax
  8022af:	e8 0d ff ff ff       	call   8021c1 <nsipc>
}
  8022b4:	c9                   	leave  
  8022b5:	c3                   	ret    

008022b6 <nsipc_close>:

int
nsipc_close(int s)
{
  8022b6:	55                   	push   %ebp
  8022b7:	89 e5                	mov    %esp,%ebp
  8022b9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8022bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bf:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8022c4:	b8 04 00 00 00       	mov    $0x4,%eax
  8022c9:	e8 f3 fe ff ff       	call   8021c1 <nsipc>
}
  8022ce:	c9                   	leave  
  8022cf:	c3                   	ret    

008022d0 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8022d0:	55                   	push   %ebp
  8022d1:	89 e5                	mov    %esp,%ebp
  8022d3:	53                   	push   %ebx
  8022d4:	83 ec 08             	sub    $0x8,%esp
  8022d7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8022da:	8b 45 08             	mov    0x8(%ebp),%eax
  8022dd:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8022e2:	53                   	push   %ebx
  8022e3:	ff 75 0c             	pushl  0xc(%ebp)
  8022e6:	68 04 70 80 00       	push   $0x807004
  8022eb:	e8 63 ee ff ff       	call   801153 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8022f0:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8022f6:	b8 05 00 00 00       	mov    $0x5,%eax
  8022fb:	e8 c1 fe ff ff       	call   8021c1 <nsipc>
}
  802300:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802303:	c9                   	leave  
  802304:	c3                   	ret    

00802305 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802305:	55                   	push   %ebp
  802306:	89 e5                	mov    %esp,%ebp
  802308:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80230b:	8b 45 08             	mov    0x8(%ebp),%eax
  80230e:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802313:	8b 45 0c             	mov    0xc(%ebp),%eax
  802316:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80231b:	b8 06 00 00 00       	mov    $0x6,%eax
  802320:	e8 9c fe ff ff       	call   8021c1 <nsipc>
}
  802325:	c9                   	leave  
  802326:	c3                   	ret    

00802327 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802327:	55                   	push   %ebp
  802328:	89 e5                	mov    %esp,%ebp
  80232a:	56                   	push   %esi
  80232b:	53                   	push   %ebx
  80232c:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80232f:	8b 45 08             	mov    0x8(%ebp),%eax
  802332:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802337:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  80233d:	8b 45 14             	mov    0x14(%ebp),%eax
  802340:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802345:	b8 07 00 00 00       	mov    $0x7,%eax
  80234a:	e8 72 fe ff ff       	call   8021c1 <nsipc>
  80234f:	89 c3                	mov    %eax,%ebx
  802351:	85 c0                	test   %eax,%eax
  802353:	78 1f                	js     802374 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802355:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80235a:	7f 21                	jg     80237d <nsipc_recv+0x56>
  80235c:	39 c6                	cmp    %eax,%esi
  80235e:	7c 1d                	jl     80237d <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802360:	83 ec 04             	sub    $0x4,%esp
  802363:	50                   	push   %eax
  802364:	68 00 70 80 00       	push   $0x807000
  802369:	ff 75 0c             	pushl  0xc(%ebp)
  80236c:	e8 e2 ed ff ff       	call   801153 <memmove>
  802371:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802374:	89 d8                	mov    %ebx,%eax
  802376:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802379:	5b                   	pop    %ebx
  80237a:	5e                   	pop    %esi
  80237b:	5d                   	pop    %ebp
  80237c:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80237d:	68 83 34 80 00       	push   $0x803483
  802382:	68 4b 34 80 00       	push   $0x80344b
  802387:	6a 62                	push   $0x62
  802389:	68 98 34 80 00       	push   $0x803498
  80238e:	e8 dd e3 ff ff       	call   800770 <_panic>

00802393 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802393:	55                   	push   %ebp
  802394:	89 e5                	mov    %esp,%ebp
  802396:	53                   	push   %ebx
  802397:	83 ec 04             	sub    $0x4,%esp
  80239a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80239d:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a0:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8023a5:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8023ab:	7f 2e                	jg     8023db <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8023ad:	83 ec 04             	sub    $0x4,%esp
  8023b0:	53                   	push   %ebx
  8023b1:	ff 75 0c             	pushl  0xc(%ebp)
  8023b4:	68 0c 70 80 00       	push   $0x80700c
  8023b9:	e8 95 ed ff ff       	call   801153 <memmove>
	nsipcbuf.send.req_size = size;
  8023be:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8023c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8023c7:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8023cc:	b8 08 00 00 00       	mov    $0x8,%eax
  8023d1:	e8 eb fd ff ff       	call   8021c1 <nsipc>
}
  8023d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023d9:	c9                   	leave  
  8023da:	c3                   	ret    
	assert(size < 1600);
  8023db:	68 a4 34 80 00       	push   $0x8034a4
  8023e0:	68 4b 34 80 00       	push   $0x80344b
  8023e5:	6a 6d                	push   $0x6d
  8023e7:	68 98 34 80 00       	push   $0x803498
  8023ec:	e8 7f e3 ff ff       	call   800770 <_panic>

008023f1 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8023f1:	55                   	push   %ebp
  8023f2:	89 e5                	mov    %esp,%ebp
  8023f4:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8023f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fa:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8023ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  802402:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802407:	8b 45 10             	mov    0x10(%ebp),%eax
  80240a:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80240f:	b8 09 00 00 00       	mov    $0x9,%eax
  802414:	e8 a8 fd ff ff       	call   8021c1 <nsipc>
}
  802419:	c9                   	leave  
  80241a:	c3                   	ret    

0080241b <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80241b:	55                   	push   %ebp
  80241c:	89 e5                	mov    %esp,%ebp
  80241e:	56                   	push   %esi
  80241f:	53                   	push   %ebx
  802420:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802423:	83 ec 0c             	sub    $0xc,%esp
  802426:	ff 75 08             	pushl  0x8(%ebp)
  802429:	e8 6a f3 ff ff       	call   801798 <fd2data>
  80242e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802430:	83 c4 08             	add    $0x8,%esp
  802433:	68 b0 34 80 00       	push   $0x8034b0
  802438:	53                   	push   %ebx
  802439:	e8 87 eb ff ff       	call   800fc5 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80243e:	8b 46 04             	mov    0x4(%esi),%eax
  802441:	2b 06                	sub    (%esi),%eax
  802443:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802449:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802450:	00 00 00 
	stat->st_dev = &devpipe;
  802453:	c7 83 88 00 00 00 40 	movl   $0x804040,0x88(%ebx)
  80245a:	40 80 00 
	return 0;
}
  80245d:	b8 00 00 00 00       	mov    $0x0,%eax
  802462:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802465:	5b                   	pop    %ebx
  802466:	5e                   	pop    %esi
  802467:	5d                   	pop    %ebp
  802468:	c3                   	ret    

00802469 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802469:	55                   	push   %ebp
  80246a:	89 e5                	mov    %esp,%ebp
  80246c:	53                   	push   %ebx
  80246d:	83 ec 0c             	sub    $0xc,%esp
  802470:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802473:	53                   	push   %ebx
  802474:	6a 00                	push   $0x0
  802476:	e8 c1 ef ff ff       	call   80143c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80247b:	89 1c 24             	mov    %ebx,(%esp)
  80247e:	e8 15 f3 ff ff       	call   801798 <fd2data>
  802483:	83 c4 08             	add    $0x8,%esp
  802486:	50                   	push   %eax
  802487:	6a 00                	push   $0x0
  802489:	e8 ae ef ff ff       	call   80143c <sys_page_unmap>
}
  80248e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802491:	c9                   	leave  
  802492:	c3                   	ret    

00802493 <_pipeisclosed>:
{
  802493:	55                   	push   %ebp
  802494:	89 e5                	mov    %esp,%ebp
  802496:	57                   	push   %edi
  802497:	56                   	push   %esi
  802498:	53                   	push   %ebx
  802499:	83 ec 1c             	sub    $0x1c,%esp
  80249c:	89 c7                	mov    %eax,%edi
  80249e:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8024a0:	a1 08 50 80 00       	mov    0x805008,%eax
  8024a5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8024a8:	83 ec 0c             	sub    $0xc,%esp
  8024ab:	57                   	push   %edi
  8024ac:	e8 2d 04 00 00       	call   8028de <pageref>
  8024b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8024b4:	89 34 24             	mov    %esi,(%esp)
  8024b7:	e8 22 04 00 00       	call   8028de <pageref>
		nn = thisenv->env_runs;
  8024bc:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8024c2:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8024c5:	83 c4 10             	add    $0x10,%esp
  8024c8:	39 cb                	cmp    %ecx,%ebx
  8024ca:	74 1b                	je     8024e7 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8024cc:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8024cf:	75 cf                	jne    8024a0 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8024d1:	8b 42 58             	mov    0x58(%edx),%eax
  8024d4:	6a 01                	push   $0x1
  8024d6:	50                   	push   %eax
  8024d7:	53                   	push   %ebx
  8024d8:	68 b7 34 80 00       	push   $0x8034b7
  8024dd:	e8 84 e3 ff ff       	call   800866 <cprintf>
  8024e2:	83 c4 10             	add    $0x10,%esp
  8024e5:	eb b9                	jmp    8024a0 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8024e7:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8024ea:	0f 94 c0             	sete   %al
  8024ed:	0f b6 c0             	movzbl %al,%eax
}
  8024f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024f3:	5b                   	pop    %ebx
  8024f4:	5e                   	pop    %esi
  8024f5:	5f                   	pop    %edi
  8024f6:	5d                   	pop    %ebp
  8024f7:	c3                   	ret    

008024f8 <devpipe_write>:
{
  8024f8:	55                   	push   %ebp
  8024f9:	89 e5                	mov    %esp,%ebp
  8024fb:	57                   	push   %edi
  8024fc:	56                   	push   %esi
  8024fd:	53                   	push   %ebx
  8024fe:	83 ec 28             	sub    $0x28,%esp
  802501:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802504:	56                   	push   %esi
  802505:	e8 8e f2 ff ff       	call   801798 <fd2data>
  80250a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80250c:	83 c4 10             	add    $0x10,%esp
  80250f:	bf 00 00 00 00       	mov    $0x0,%edi
  802514:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802517:	74 4f                	je     802568 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802519:	8b 43 04             	mov    0x4(%ebx),%eax
  80251c:	8b 0b                	mov    (%ebx),%ecx
  80251e:	8d 51 20             	lea    0x20(%ecx),%edx
  802521:	39 d0                	cmp    %edx,%eax
  802523:	72 14                	jb     802539 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802525:	89 da                	mov    %ebx,%edx
  802527:	89 f0                	mov    %esi,%eax
  802529:	e8 65 ff ff ff       	call   802493 <_pipeisclosed>
  80252e:	85 c0                	test   %eax,%eax
  802530:	75 3b                	jne    80256d <devpipe_write+0x75>
			sys_yield();
  802532:	e8 61 ee ff ff       	call   801398 <sys_yield>
  802537:	eb e0                	jmp    802519 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802539:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80253c:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802540:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802543:	89 c2                	mov    %eax,%edx
  802545:	c1 fa 1f             	sar    $0x1f,%edx
  802548:	89 d1                	mov    %edx,%ecx
  80254a:	c1 e9 1b             	shr    $0x1b,%ecx
  80254d:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802550:	83 e2 1f             	and    $0x1f,%edx
  802553:	29 ca                	sub    %ecx,%edx
  802555:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802559:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80255d:	83 c0 01             	add    $0x1,%eax
  802560:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802563:	83 c7 01             	add    $0x1,%edi
  802566:	eb ac                	jmp    802514 <devpipe_write+0x1c>
	return i;
  802568:	8b 45 10             	mov    0x10(%ebp),%eax
  80256b:	eb 05                	jmp    802572 <devpipe_write+0x7a>
				return 0;
  80256d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802572:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802575:	5b                   	pop    %ebx
  802576:	5e                   	pop    %esi
  802577:	5f                   	pop    %edi
  802578:	5d                   	pop    %ebp
  802579:	c3                   	ret    

0080257a <devpipe_read>:
{
  80257a:	55                   	push   %ebp
  80257b:	89 e5                	mov    %esp,%ebp
  80257d:	57                   	push   %edi
  80257e:	56                   	push   %esi
  80257f:	53                   	push   %ebx
  802580:	83 ec 18             	sub    $0x18,%esp
  802583:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802586:	57                   	push   %edi
  802587:	e8 0c f2 ff ff       	call   801798 <fd2data>
  80258c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80258e:	83 c4 10             	add    $0x10,%esp
  802591:	be 00 00 00 00       	mov    $0x0,%esi
  802596:	3b 75 10             	cmp    0x10(%ebp),%esi
  802599:	75 14                	jne    8025af <devpipe_read+0x35>
	return i;
  80259b:	8b 45 10             	mov    0x10(%ebp),%eax
  80259e:	eb 02                	jmp    8025a2 <devpipe_read+0x28>
				return i;
  8025a0:	89 f0                	mov    %esi,%eax
}
  8025a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025a5:	5b                   	pop    %ebx
  8025a6:	5e                   	pop    %esi
  8025a7:	5f                   	pop    %edi
  8025a8:	5d                   	pop    %ebp
  8025a9:	c3                   	ret    
			sys_yield();
  8025aa:	e8 e9 ed ff ff       	call   801398 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8025af:	8b 03                	mov    (%ebx),%eax
  8025b1:	3b 43 04             	cmp    0x4(%ebx),%eax
  8025b4:	75 18                	jne    8025ce <devpipe_read+0x54>
			if (i > 0)
  8025b6:	85 f6                	test   %esi,%esi
  8025b8:	75 e6                	jne    8025a0 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8025ba:	89 da                	mov    %ebx,%edx
  8025bc:	89 f8                	mov    %edi,%eax
  8025be:	e8 d0 fe ff ff       	call   802493 <_pipeisclosed>
  8025c3:	85 c0                	test   %eax,%eax
  8025c5:	74 e3                	je     8025aa <devpipe_read+0x30>
				return 0;
  8025c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8025cc:	eb d4                	jmp    8025a2 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8025ce:	99                   	cltd   
  8025cf:	c1 ea 1b             	shr    $0x1b,%edx
  8025d2:	01 d0                	add    %edx,%eax
  8025d4:	83 e0 1f             	and    $0x1f,%eax
  8025d7:	29 d0                	sub    %edx,%eax
  8025d9:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8025de:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8025e1:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8025e4:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8025e7:	83 c6 01             	add    $0x1,%esi
  8025ea:	eb aa                	jmp    802596 <devpipe_read+0x1c>

008025ec <pipe>:
{
  8025ec:	55                   	push   %ebp
  8025ed:	89 e5                	mov    %esp,%ebp
  8025ef:	56                   	push   %esi
  8025f0:	53                   	push   %ebx
  8025f1:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8025f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025f7:	50                   	push   %eax
  8025f8:	e8 b2 f1 ff ff       	call   8017af <fd_alloc>
  8025fd:	89 c3                	mov    %eax,%ebx
  8025ff:	83 c4 10             	add    $0x10,%esp
  802602:	85 c0                	test   %eax,%eax
  802604:	0f 88 23 01 00 00    	js     80272d <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80260a:	83 ec 04             	sub    $0x4,%esp
  80260d:	68 07 04 00 00       	push   $0x407
  802612:	ff 75 f4             	pushl  -0xc(%ebp)
  802615:	6a 00                	push   $0x0
  802617:	e8 9b ed ff ff       	call   8013b7 <sys_page_alloc>
  80261c:	89 c3                	mov    %eax,%ebx
  80261e:	83 c4 10             	add    $0x10,%esp
  802621:	85 c0                	test   %eax,%eax
  802623:	0f 88 04 01 00 00    	js     80272d <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802629:	83 ec 0c             	sub    $0xc,%esp
  80262c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80262f:	50                   	push   %eax
  802630:	e8 7a f1 ff ff       	call   8017af <fd_alloc>
  802635:	89 c3                	mov    %eax,%ebx
  802637:	83 c4 10             	add    $0x10,%esp
  80263a:	85 c0                	test   %eax,%eax
  80263c:	0f 88 db 00 00 00    	js     80271d <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802642:	83 ec 04             	sub    $0x4,%esp
  802645:	68 07 04 00 00       	push   $0x407
  80264a:	ff 75 f0             	pushl  -0x10(%ebp)
  80264d:	6a 00                	push   $0x0
  80264f:	e8 63 ed ff ff       	call   8013b7 <sys_page_alloc>
  802654:	89 c3                	mov    %eax,%ebx
  802656:	83 c4 10             	add    $0x10,%esp
  802659:	85 c0                	test   %eax,%eax
  80265b:	0f 88 bc 00 00 00    	js     80271d <pipe+0x131>
	va = fd2data(fd0);
  802661:	83 ec 0c             	sub    $0xc,%esp
  802664:	ff 75 f4             	pushl  -0xc(%ebp)
  802667:	e8 2c f1 ff ff       	call   801798 <fd2data>
  80266c:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80266e:	83 c4 0c             	add    $0xc,%esp
  802671:	68 07 04 00 00       	push   $0x407
  802676:	50                   	push   %eax
  802677:	6a 00                	push   $0x0
  802679:	e8 39 ed ff ff       	call   8013b7 <sys_page_alloc>
  80267e:	89 c3                	mov    %eax,%ebx
  802680:	83 c4 10             	add    $0x10,%esp
  802683:	85 c0                	test   %eax,%eax
  802685:	0f 88 82 00 00 00    	js     80270d <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80268b:	83 ec 0c             	sub    $0xc,%esp
  80268e:	ff 75 f0             	pushl  -0x10(%ebp)
  802691:	e8 02 f1 ff ff       	call   801798 <fd2data>
  802696:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80269d:	50                   	push   %eax
  80269e:	6a 00                	push   $0x0
  8026a0:	56                   	push   %esi
  8026a1:	6a 00                	push   $0x0
  8026a3:	e8 52 ed ff ff       	call   8013fa <sys_page_map>
  8026a8:	89 c3                	mov    %eax,%ebx
  8026aa:	83 c4 20             	add    $0x20,%esp
  8026ad:	85 c0                	test   %eax,%eax
  8026af:	78 4e                	js     8026ff <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8026b1:	a1 40 40 80 00       	mov    0x804040,%eax
  8026b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026b9:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8026bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026be:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8026c5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026c8:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8026ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026cd:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8026d4:	83 ec 0c             	sub    $0xc,%esp
  8026d7:	ff 75 f4             	pushl  -0xc(%ebp)
  8026da:	e8 a9 f0 ff ff       	call   801788 <fd2num>
  8026df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026e2:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8026e4:	83 c4 04             	add    $0x4,%esp
  8026e7:	ff 75 f0             	pushl  -0x10(%ebp)
  8026ea:	e8 99 f0 ff ff       	call   801788 <fd2num>
  8026ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026f2:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8026f5:	83 c4 10             	add    $0x10,%esp
  8026f8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8026fd:	eb 2e                	jmp    80272d <pipe+0x141>
	sys_page_unmap(0, va);
  8026ff:	83 ec 08             	sub    $0x8,%esp
  802702:	56                   	push   %esi
  802703:	6a 00                	push   $0x0
  802705:	e8 32 ed ff ff       	call   80143c <sys_page_unmap>
  80270a:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80270d:	83 ec 08             	sub    $0x8,%esp
  802710:	ff 75 f0             	pushl  -0x10(%ebp)
  802713:	6a 00                	push   $0x0
  802715:	e8 22 ed ff ff       	call   80143c <sys_page_unmap>
  80271a:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80271d:	83 ec 08             	sub    $0x8,%esp
  802720:	ff 75 f4             	pushl  -0xc(%ebp)
  802723:	6a 00                	push   $0x0
  802725:	e8 12 ed ff ff       	call   80143c <sys_page_unmap>
  80272a:	83 c4 10             	add    $0x10,%esp
}
  80272d:	89 d8                	mov    %ebx,%eax
  80272f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802732:	5b                   	pop    %ebx
  802733:	5e                   	pop    %esi
  802734:	5d                   	pop    %ebp
  802735:	c3                   	ret    

00802736 <pipeisclosed>:
{
  802736:	55                   	push   %ebp
  802737:	89 e5                	mov    %esp,%ebp
  802739:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80273c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80273f:	50                   	push   %eax
  802740:	ff 75 08             	pushl  0x8(%ebp)
  802743:	e8 b9 f0 ff ff       	call   801801 <fd_lookup>
  802748:	83 c4 10             	add    $0x10,%esp
  80274b:	85 c0                	test   %eax,%eax
  80274d:	78 18                	js     802767 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80274f:	83 ec 0c             	sub    $0xc,%esp
  802752:	ff 75 f4             	pushl  -0xc(%ebp)
  802755:	e8 3e f0 ff ff       	call   801798 <fd2data>
	return _pipeisclosed(fd, p);
  80275a:	89 c2                	mov    %eax,%edx
  80275c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275f:	e8 2f fd ff ff       	call   802493 <_pipeisclosed>
  802764:	83 c4 10             	add    $0x10,%esp
}
  802767:	c9                   	leave  
  802768:	c3                   	ret    

00802769 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802769:	b8 00 00 00 00       	mov    $0x0,%eax
  80276e:	c3                   	ret    

0080276f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80276f:	55                   	push   %ebp
  802770:	89 e5                	mov    %esp,%ebp
  802772:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802775:	68 cf 34 80 00       	push   $0x8034cf
  80277a:	ff 75 0c             	pushl  0xc(%ebp)
  80277d:	e8 43 e8 ff ff       	call   800fc5 <strcpy>
	return 0;
}
  802782:	b8 00 00 00 00       	mov    $0x0,%eax
  802787:	c9                   	leave  
  802788:	c3                   	ret    

00802789 <devcons_write>:
{
  802789:	55                   	push   %ebp
  80278a:	89 e5                	mov    %esp,%ebp
  80278c:	57                   	push   %edi
  80278d:	56                   	push   %esi
  80278e:	53                   	push   %ebx
  80278f:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802795:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80279a:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8027a0:	3b 75 10             	cmp    0x10(%ebp),%esi
  8027a3:	73 31                	jae    8027d6 <devcons_write+0x4d>
		m = n - tot;
  8027a5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8027a8:	29 f3                	sub    %esi,%ebx
  8027aa:	83 fb 7f             	cmp    $0x7f,%ebx
  8027ad:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8027b2:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8027b5:	83 ec 04             	sub    $0x4,%esp
  8027b8:	53                   	push   %ebx
  8027b9:	89 f0                	mov    %esi,%eax
  8027bb:	03 45 0c             	add    0xc(%ebp),%eax
  8027be:	50                   	push   %eax
  8027bf:	57                   	push   %edi
  8027c0:	e8 8e e9 ff ff       	call   801153 <memmove>
		sys_cputs(buf, m);
  8027c5:	83 c4 08             	add    $0x8,%esp
  8027c8:	53                   	push   %ebx
  8027c9:	57                   	push   %edi
  8027ca:	e8 2c eb ff ff       	call   8012fb <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8027cf:	01 de                	add    %ebx,%esi
  8027d1:	83 c4 10             	add    $0x10,%esp
  8027d4:	eb ca                	jmp    8027a0 <devcons_write+0x17>
}
  8027d6:	89 f0                	mov    %esi,%eax
  8027d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8027db:	5b                   	pop    %ebx
  8027dc:	5e                   	pop    %esi
  8027dd:	5f                   	pop    %edi
  8027de:	5d                   	pop    %ebp
  8027df:	c3                   	ret    

008027e0 <devcons_read>:
{
  8027e0:	55                   	push   %ebp
  8027e1:	89 e5                	mov    %esp,%ebp
  8027e3:	83 ec 08             	sub    $0x8,%esp
  8027e6:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8027eb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8027ef:	74 21                	je     802812 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8027f1:	e8 23 eb ff ff       	call   801319 <sys_cgetc>
  8027f6:	85 c0                	test   %eax,%eax
  8027f8:	75 07                	jne    802801 <devcons_read+0x21>
		sys_yield();
  8027fa:	e8 99 eb ff ff       	call   801398 <sys_yield>
  8027ff:	eb f0                	jmp    8027f1 <devcons_read+0x11>
	if (c < 0)
  802801:	78 0f                	js     802812 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802803:	83 f8 04             	cmp    $0x4,%eax
  802806:	74 0c                	je     802814 <devcons_read+0x34>
	*(char*)vbuf = c;
  802808:	8b 55 0c             	mov    0xc(%ebp),%edx
  80280b:	88 02                	mov    %al,(%edx)
	return 1;
  80280d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802812:	c9                   	leave  
  802813:	c3                   	ret    
		return 0;
  802814:	b8 00 00 00 00       	mov    $0x0,%eax
  802819:	eb f7                	jmp    802812 <devcons_read+0x32>

0080281b <cputchar>:
{
  80281b:	55                   	push   %ebp
  80281c:	89 e5                	mov    %esp,%ebp
  80281e:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802821:	8b 45 08             	mov    0x8(%ebp),%eax
  802824:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802827:	6a 01                	push   $0x1
  802829:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80282c:	50                   	push   %eax
  80282d:	e8 c9 ea ff ff       	call   8012fb <sys_cputs>
}
  802832:	83 c4 10             	add    $0x10,%esp
  802835:	c9                   	leave  
  802836:	c3                   	ret    

00802837 <getchar>:
{
  802837:	55                   	push   %ebp
  802838:	89 e5                	mov    %esp,%ebp
  80283a:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80283d:	6a 01                	push   $0x1
  80283f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802842:	50                   	push   %eax
  802843:	6a 00                	push   $0x0
  802845:	e8 27 f2 ff ff       	call   801a71 <read>
	if (r < 0)
  80284a:	83 c4 10             	add    $0x10,%esp
  80284d:	85 c0                	test   %eax,%eax
  80284f:	78 06                	js     802857 <getchar+0x20>
	if (r < 1)
  802851:	74 06                	je     802859 <getchar+0x22>
	return c;
  802853:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802857:	c9                   	leave  
  802858:	c3                   	ret    
		return -E_EOF;
  802859:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80285e:	eb f7                	jmp    802857 <getchar+0x20>

00802860 <iscons>:
{
  802860:	55                   	push   %ebp
  802861:	89 e5                	mov    %esp,%ebp
  802863:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802866:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802869:	50                   	push   %eax
  80286a:	ff 75 08             	pushl  0x8(%ebp)
  80286d:	e8 8f ef ff ff       	call   801801 <fd_lookup>
  802872:	83 c4 10             	add    $0x10,%esp
  802875:	85 c0                	test   %eax,%eax
  802877:	78 11                	js     80288a <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802879:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287c:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  802882:	39 10                	cmp    %edx,(%eax)
  802884:	0f 94 c0             	sete   %al
  802887:	0f b6 c0             	movzbl %al,%eax
}
  80288a:	c9                   	leave  
  80288b:	c3                   	ret    

0080288c <opencons>:
{
  80288c:	55                   	push   %ebp
  80288d:	89 e5                	mov    %esp,%ebp
  80288f:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802892:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802895:	50                   	push   %eax
  802896:	e8 14 ef ff ff       	call   8017af <fd_alloc>
  80289b:	83 c4 10             	add    $0x10,%esp
  80289e:	85 c0                	test   %eax,%eax
  8028a0:	78 3a                	js     8028dc <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8028a2:	83 ec 04             	sub    $0x4,%esp
  8028a5:	68 07 04 00 00       	push   $0x407
  8028aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8028ad:	6a 00                	push   $0x0
  8028af:	e8 03 eb ff ff       	call   8013b7 <sys_page_alloc>
  8028b4:	83 c4 10             	add    $0x10,%esp
  8028b7:	85 c0                	test   %eax,%eax
  8028b9:	78 21                	js     8028dc <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8028bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028be:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  8028c4:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8028c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8028d0:	83 ec 0c             	sub    $0xc,%esp
  8028d3:	50                   	push   %eax
  8028d4:	e8 af ee ff ff       	call   801788 <fd2num>
  8028d9:	83 c4 10             	add    $0x10,%esp
}
  8028dc:	c9                   	leave  
  8028dd:	c3                   	ret    

008028de <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8028de:	55                   	push   %ebp
  8028df:	89 e5                	mov    %esp,%ebp
  8028e1:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8028e4:	89 d0                	mov    %edx,%eax
  8028e6:	c1 e8 16             	shr    $0x16,%eax
  8028e9:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8028f0:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8028f5:	f6 c1 01             	test   $0x1,%cl
  8028f8:	74 1d                	je     802917 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8028fa:	c1 ea 0c             	shr    $0xc,%edx
  8028fd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802904:	f6 c2 01             	test   $0x1,%dl
  802907:	74 0e                	je     802917 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802909:	c1 ea 0c             	shr    $0xc,%edx
  80290c:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802913:	ef 
  802914:	0f b7 c0             	movzwl %ax,%eax
}
  802917:	5d                   	pop    %ebp
  802918:	c3                   	ret    
  802919:	66 90                	xchg   %ax,%ax
  80291b:	66 90                	xchg   %ax,%ax
  80291d:	66 90                	xchg   %ax,%ax
  80291f:	90                   	nop

00802920 <__udivdi3>:
  802920:	55                   	push   %ebp
  802921:	57                   	push   %edi
  802922:	56                   	push   %esi
  802923:	53                   	push   %ebx
  802924:	83 ec 1c             	sub    $0x1c,%esp
  802927:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80292b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80292f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802933:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802937:	85 d2                	test   %edx,%edx
  802939:	75 4d                	jne    802988 <__udivdi3+0x68>
  80293b:	39 f3                	cmp    %esi,%ebx
  80293d:	76 19                	jbe    802958 <__udivdi3+0x38>
  80293f:	31 ff                	xor    %edi,%edi
  802941:	89 e8                	mov    %ebp,%eax
  802943:	89 f2                	mov    %esi,%edx
  802945:	f7 f3                	div    %ebx
  802947:	89 fa                	mov    %edi,%edx
  802949:	83 c4 1c             	add    $0x1c,%esp
  80294c:	5b                   	pop    %ebx
  80294d:	5e                   	pop    %esi
  80294e:	5f                   	pop    %edi
  80294f:	5d                   	pop    %ebp
  802950:	c3                   	ret    
  802951:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802958:	89 d9                	mov    %ebx,%ecx
  80295a:	85 db                	test   %ebx,%ebx
  80295c:	75 0b                	jne    802969 <__udivdi3+0x49>
  80295e:	b8 01 00 00 00       	mov    $0x1,%eax
  802963:	31 d2                	xor    %edx,%edx
  802965:	f7 f3                	div    %ebx
  802967:	89 c1                	mov    %eax,%ecx
  802969:	31 d2                	xor    %edx,%edx
  80296b:	89 f0                	mov    %esi,%eax
  80296d:	f7 f1                	div    %ecx
  80296f:	89 c6                	mov    %eax,%esi
  802971:	89 e8                	mov    %ebp,%eax
  802973:	89 f7                	mov    %esi,%edi
  802975:	f7 f1                	div    %ecx
  802977:	89 fa                	mov    %edi,%edx
  802979:	83 c4 1c             	add    $0x1c,%esp
  80297c:	5b                   	pop    %ebx
  80297d:	5e                   	pop    %esi
  80297e:	5f                   	pop    %edi
  80297f:	5d                   	pop    %ebp
  802980:	c3                   	ret    
  802981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802988:	39 f2                	cmp    %esi,%edx
  80298a:	77 1c                	ja     8029a8 <__udivdi3+0x88>
  80298c:	0f bd fa             	bsr    %edx,%edi
  80298f:	83 f7 1f             	xor    $0x1f,%edi
  802992:	75 2c                	jne    8029c0 <__udivdi3+0xa0>
  802994:	39 f2                	cmp    %esi,%edx
  802996:	72 06                	jb     80299e <__udivdi3+0x7e>
  802998:	31 c0                	xor    %eax,%eax
  80299a:	39 eb                	cmp    %ebp,%ebx
  80299c:	77 a9                	ja     802947 <__udivdi3+0x27>
  80299e:	b8 01 00 00 00       	mov    $0x1,%eax
  8029a3:	eb a2                	jmp    802947 <__udivdi3+0x27>
  8029a5:	8d 76 00             	lea    0x0(%esi),%esi
  8029a8:	31 ff                	xor    %edi,%edi
  8029aa:	31 c0                	xor    %eax,%eax
  8029ac:	89 fa                	mov    %edi,%edx
  8029ae:	83 c4 1c             	add    $0x1c,%esp
  8029b1:	5b                   	pop    %ebx
  8029b2:	5e                   	pop    %esi
  8029b3:	5f                   	pop    %edi
  8029b4:	5d                   	pop    %ebp
  8029b5:	c3                   	ret    
  8029b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029bd:	8d 76 00             	lea    0x0(%esi),%esi
  8029c0:	89 f9                	mov    %edi,%ecx
  8029c2:	b8 20 00 00 00       	mov    $0x20,%eax
  8029c7:	29 f8                	sub    %edi,%eax
  8029c9:	d3 e2                	shl    %cl,%edx
  8029cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8029cf:	89 c1                	mov    %eax,%ecx
  8029d1:	89 da                	mov    %ebx,%edx
  8029d3:	d3 ea                	shr    %cl,%edx
  8029d5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8029d9:	09 d1                	or     %edx,%ecx
  8029db:	89 f2                	mov    %esi,%edx
  8029dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8029e1:	89 f9                	mov    %edi,%ecx
  8029e3:	d3 e3                	shl    %cl,%ebx
  8029e5:	89 c1                	mov    %eax,%ecx
  8029e7:	d3 ea                	shr    %cl,%edx
  8029e9:	89 f9                	mov    %edi,%ecx
  8029eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8029ef:	89 eb                	mov    %ebp,%ebx
  8029f1:	d3 e6                	shl    %cl,%esi
  8029f3:	89 c1                	mov    %eax,%ecx
  8029f5:	d3 eb                	shr    %cl,%ebx
  8029f7:	09 de                	or     %ebx,%esi
  8029f9:	89 f0                	mov    %esi,%eax
  8029fb:	f7 74 24 08          	divl   0x8(%esp)
  8029ff:	89 d6                	mov    %edx,%esi
  802a01:	89 c3                	mov    %eax,%ebx
  802a03:	f7 64 24 0c          	mull   0xc(%esp)
  802a07:	39 d6                	cmp    %edx,%esi
  802a09:	72 15                	jb     802a20 <__udivdi3+0x100>
  802a0b:	89 f9                	mov    %edi,%ecx
  802a0d:	d3 e5                	shl    %cl,%ebp
  802a0f:	39 c5                	cmp    %eax,%ebp
  802a11:	73 04                	jae    802a17 <__udivdi3+0xf7>
  802a13:	39 d6                	cmp    %edx,%esi
  802a15:	74 09                	je     802a20 <__udivdi3+0x100>
  802a17:	89 d8                	mov    %ebx,%eax
  802a19:	31 ff                	xor    %edi,%edi
  802a1b:	e9 27 ff ff ff       	jmp    802947 <__udivdi3+0x27>
  802a20:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802a23:	31 ff                	xor    %edi,%edi
  802a25:	e9 1d ff ff ff       	jmp    802947 <__udivdi3+0x27>
  802a2a:	66 90                	xchg   %ax,%ax
  802a2c:	66 90                	xchg   %ax,%ax
  802a2e:	66 90                	xchg   %ax,%ax

00802a30 <__umoddi3>:
  802a30:	55                   	push   %ebp
  802a31:	57                   	push   %edi
  802a32:	56                   	push   %esi
  802a33:	53                   	push   %ebx
  802a34:	83 ec 1c             	sub    $0x1c,%esp
  802a37:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802a3b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802a3f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802a43:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a47:	89 da                	mov    %ebx,%edx
  802a49:	85 c0                	test   %eax,%eax
  802a4b:	75 43                	jne    802a90 <__umoddi3+0x60>
  802a4d:	39 df                	cmp    %ebx,%edi
  802a4f:	76 17                	jbe    802a68 <__umoddi3+0x38>
  802a51:	89 f0                	mov    %esi,%eax
  802a53:	f7 f7                	div    %edi
  802a55:	89 d0                	mov    %edx,%eax
  802a57:	31 d2                	xor    %edx,%edx
  802a59:	83 c4 1c             	add    $0x1c,%esp
  802a5c:	5b                   	pop    %ebx
  802a5d:	5e                   	pop    %esi
  802a5e:	5f                   	pop    %edi
  802a5f:	5d                   	pop    %ebp
  802a60:	c3                   	ret    
  802a61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a68:	89 fd                	mov    %edi,%ebp
  802a6a:	85 ff                	test   %edi,%edi
  802a6c:	75 0b                	jne    802a79 <__umoddi3+0x49>
  802a6e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a73:	31 d2                	xor    %edx,%edx
  802a75:	f7 f7                	div    %edi
  802a77:	89 c5                	mov    %eax,%ebp
  802a79:	89 d8                	mov    %ebx,%eax
  802a7b:	31 d2                	xor    %edx,%edx
  802a7d:	f7 f5                	div    %ebp
  802a7f:	89 f0                	mov    %esi,%eax
  802a81:	f7 f5                	div    %ebp
  802a83:	89 d0                	mov    %edx,%eax
  802a85:	eb d0                	jmp    802a57 <__umoddi3+0x27>
  802a87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a8e:	66 90                	xchg   %ax,%ax
  802a90:	89 f1                	mov    %esi,%ecx
  802a92:	39 d8                	cmp    %ebx,%eax
  802a94:	76 0a                	jbe    802aa0 <__umoddi3+0x70>
  802a96:	89 f0                	mov    %esi,%eax
  802a98:	83 c4 1c             	add    $0x1c,%esp
  802a9b:	5b                   	pop    %ebx
  802a9c:	5e                   	pop    %esi
  802a9d:	5f                   	pop    %edi
  802a9e:	5d                   	pop    %ebp
  802a9f:	c3                   	ret    
  802aa0:	0f bd e8             	bsr    %eax,%ebp
  802aa3:	83 f5 1f             	xor    $0x1f,%ebp
  802aa6:	75 20                	jne    802ac8 <__umoddi3+0x98>
  802aa8:	39 d8                	cmp    %ebx,%eax
  802aaa:	0f 82 b0 00 00 00    	jb     802b60 <__umoddi3+0x130>
  802ab0:	39 f7                	cmp    %esi,%edi
  802ab2:	0f 86 a8 00 00 00    	jbe    802b60 <__umoddi3+0x130>
  802ab8:	89 c8                	mov    %ecx,%eax
  802aba:	83 c4 1c             	add    $0x1c,%esp
  802abd:	5b                   	pop    %ebx
  802abe:	5e                   	pop    %esi
  802abf:	5f                   	pop    %edi
  802ac0:	5d                   	pop    %ebp
  802ac1:	c3                   	ret    
  802ac2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802ac8:	89 e9                	mov    %ebp,%ecx
  802aca:	ba 20 00 00 00       	mov    $0x20,%edx
  802acf:	29 ea                	sub    %ebp,%edx
  802ad1:	d3 e0                	shl    %cl,%eax
  802ad3:	89 44 24 08          	mov    %eax,0x8(%esp)
  802ad7:	89 d1                	mov    %edx,%ecx
  802ad9:	89 f8                	mov    %edi,%eax
  802adb:	d3 e8                	shr    %cl,%eax
  802add:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802ae1:	89 54 24 04          	mov    %edx,0x4(%esp)
  802ae5:	8b 54 24 04          	mov    0x4(%esp),%edx
  802ae9:	09 c1                	or     %eax,%ecx
  802aeb:	89 d8                	mov    %ebx,%eax
  802aed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802af1:	89 e9                	mov    %ebp,%ecx
  802af3:	d3 e7                	shl    %cl,%edi
  802af5:	89 d1                	mov    %edx,%ecx
  802af7:	d3 e8                	shr    %cl,%eax
  802af9:	89 e9                	mov    %ebp,%ecx
  802afb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802aff:	d3 e3                	shl    %cl,%ebx
  802b01:	89 c7                	mov    %eax,%edi
  802b03:	89 d1                	mov    %edx,%ecx
  802b05:	89 f0                	mov    %esi,%eax
  802b07:	d3 e8                	shr    %cl,%eax
  802b09:	89 e9                	mov    %ebp,%ecx
  802b0b:	89 fa                	mov    %edi,%edx
  802b0d:	d3 e6                	shl    %cl,%esi
  802b0f:	09 d8                	or     %ebx,%eax
  802b11:	f7 74 24 08          	divl   0x8(%esp)
  802b15:	89 d1                	mov    %edx,%ecx
  802b17:	89 f3                	mov    %esi,%ebx
  802b19:	f7 64 24 0c          	mull   0xc(%esp)
  802b1d:	89 c6                	mov    %eax,%esi
  802b1f:	89 d7                	mov    %edx,%edi
  802b21:	39 d1                	cmp    %edx,%ecx
  802b23:	72 06                	jb     802b2b <__umoddi3+0xfb>
  802b25:	75 10                	jne    802b37 <__umoddi3+0x107>
  802b27:	39 c3                	cmp    %eax,%ebx
  802b29:	73 0c                	jae    802b37 <__umoddi3+0x107>
  802b2b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802b2f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802b33:	89 d7                	mov    %edx,%edi
  802b35:	89 c6                	mov    %eax,%esi
  802b37:	89 ca                	mov    %ecx,%edx
  802b39:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802b3e:	29 f3                	sub    %esi,%ebx
  802b40:	19 fa                	sbb    %edi,%edx
  802b42:	89 d0                	mov    %edx,%eax
  802b44:	d3 e0                	shl    %cl,%eax
  802b46:	89 e9                	mov    %ebp,%ecx
  802b48:	d3 eb                	shr    %cl,%ebx
  802b4a:	d3 ea                	shr    %cl,%edx
  802b4c:	09 d8                	or     %ebx,%eax
  802b4e:	83 c4 1c             	add    $0x1c,%esp
  802b51:	5b                   	pop    %ebx
  802b52:	5e                   	pop    %esi
  802b53:	5f                   	pop    %edi
  802b54:	5d                   	pop    %ebp
  802b55:	c3                   	ret    
  802b56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b5d:	8d 76 00             	lea    0x0(%esi),%esi
  802b60:	89 da                	mov    %ebx,%edx
  802b62:	29 fe                	sub    %edi,%esi
  802b64:	19 c2                	sbb    %eax,%edx
  802b66:	89 f1                	mov    %esi,%ecx
  802b68:	89 c8                	mov    %ecx,%eax
  802b6a:	e9 4b ff ff ff       	jmp    802aba <__umoddi3+0x8a>
