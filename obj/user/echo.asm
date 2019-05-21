
obj/user/echo.debug:     file format elf32-i386


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
  80002c:	e8 b3 00 00 00       	call   8000e4 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
  80003c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80003f:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i, nflag;

	nflag = 0;
  800042:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  800049:	83 ff 01             	cmp    $0x1,%edi
  80004c:	7f 07                	jg     800055 <umain+0x22>
		nflag = 1;
		argc--;
		argv++;
	}
	for (i = 1; i < argc; i++) {
  80004e:	bb 01 00 00 00       	mov    $0x1,%ebx
  800053:	eb 60                	jmp    8000b5 <umain+0x82>
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  800055:	83 ec 08             	sub    $0x8,%esp
  800058:	68 20 20 80 00       	push   $0x802020
  80005d:	ff 76 04             	pushl  0x4(%esi)
  800060:	e8 0a 02 00 00       	call   80026f <strcmp>
  800065:	83 c4 10             	add    $0x10,%esp
	nflag = 0;
  800068:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  80006f:	85 c0                	test   %eax,%eax
  800071:	75 db                	jne    80004e <umain+0x1b>
		argc--;
  800073:	83 ef 01             	sub    $0x1,%edi
		argv++;
  800076:	83 c6 04             	add    $0x4,%esi
		nflag = 1;
  800079:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  800080:	eb cc                	jmp    80004e <umain+0x1b>
		if (i > 1)
			write(1, " ", 1);
  800082:	83 ec 04             	sub    $0x4,%esp
  800085:	6a 01                	push   $0x1
  800087:	68 23 20 80 00       	push   $0x802023
  80008c:	6a 01                	push   $0x1
  80008e:	e8 05 0b 00 00       	call   800b98 <write>
  800093:	83 c4 10             	add    $0x10,%esp
		write(1, argv[i], strlen(argv[i]));
  800096:	83 ec 0c             	sub    $0xc,%esp
  800099:	ff 34 9e             	pushl  (%esi,%ebx,4)
  80009c:	e8 ea 00 00 00       	call   80018b <strlen>
  8000a1:	83 c4 0c             	add    $0xc,%esp
  8000a4:	50                   	push   %eax
  8000a5:	ff 34 9e             	pushl  (%esi,%ebx,4)
  8000a8:	6a 01                	push   $0x1
  8000aa:	e8 e9 0a 00 00       	call   800b98 <write>
	for (i = 1; i < argc; i++) {
  8000af:	83 c3 01             	add    $0x1,%ebx
  8000b2:	83 c4 10             	add    $0x10,%esp
  8000b5:	39 df                	cmp    %ebx,%edi
  8000b7:	7e 07                	jle    8000c0 <umain+0x8d>
		if (i > 1)
  8000b9:	83 fb 01             	cmp    $0x1,%ebx
  8000bc:	7f c4                	jg     800082 <umain+0x4f>
  8000be:	eb d6                	jmp    800096 <umain+0x63>
	}
	if (!nflag)
  8000c0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8000c4:	74 08                	je     8000ce <umain+0x9b>
		write(1, "\n", 1);
}
  8000c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000c9:	5b                   	pop    %ebx
  8000ca:	5e                   	pop    %esi
  8000cb:	5f                   	pop    %edi
  8000cc:	5d                   	pop    %ebp
  8000cd:	c3                   	ret    
		write(1, "\n", 1);
  8000ce:	83 ec 04             	sub    $0x4,%esp
  8000d1:	6a 01                	push   $0x1
  8000d3:	68 33 25 80 00       	push   $0x802533
  8000d8:	6a 01                	push   $0x1
  8000da:	e8 b9 0a 00 00       	call   800b98 <write>
  8000df:	83 c4 10             	add    $0x10,%esp
}
  8000e2:	eb e2                	jmp    8000c6 <umain+0x93>

008000e4 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  8000e4:	55                   	push   %ebp
  8000e5:	89 e5                	mov    %esp,%ebp
  8000e7:	57                   	push   %edi
  8000e8:	56                   	push   %esi
  8000e9:	53                   	push   %ebx
  8000ea:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  8000ed:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8000f4:	00 00 00 
	envid_t find = sys_getenvid();
  8000f7:	e8 7c 04 00 00       	call   800578 <sys_getenvid>
  8000fc:	8b 1d 04 40 80 00    	mov    0x804004,%ebx
  800102:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  800107:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  80010c:	bf 01 00 00 00       	mov    $0x1,%edi
  800111:	eb 0b                	jmp    80011e <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  800113:	83 c2 01             	add    $0x1,%edx
  800116:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  80011c:	74 21                	je     80013f <libmain+0x5b>
		if(envs[i].env_id == find)
  80011e:	89 d1                	mov    %edx,%ecx
  800120:	c1 e1 07             	shl    $0x7,%ecx
  800123:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800129:	8b 49 48             	mov    0x48(%ecx),%ecx
  80012c:	39 c1                	cmp    %eax,%ecx
  80012e:	75 e3                	jne    800113 <libmain+0x2f>
  800130:	89 d3                	mov    %edx,%ebx
  800132:	c1 e3 07             	shl    $0x7,%ebx
  800135:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80013b:	89 fe                	mov    %edi,%esi
  80013d:	eb d4                	jmp    800113 <libmain+0x2f>
  80013f:	89 f0                	mov    %esi,%eax
  800141:	84 c0                	test   %al,%al
  800143:	74 06                	je     80014b <libmain+0x67>
  800145:	89 1d 04 40 80 00    	mov    %ebx,0x804004
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80014b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80014f:	7e 0a                	jle    80015b <libmain+0x77>
		binaryname = argv[0];
  800151:	8b 45 0c             	mov    0xc(%ebp),%eax
  800154:	8b 00                	mov    (%eax),%eax
  800156:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80015b:	83 ec 08             	sub    $0x8,%esp
  80015e:	ff 75 0c             	pushl  0xc(%ebp)
  800161:	ff 75 08             	pushl  0x8(%ebp)
  800164:	e8 ca fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800169:	e8 0b 00 00 00       	call   800179 <exit>
}
  80016e:	83 c4 10             	add    $0x10,%esp
  800171:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800174:	5b                   	pop    %ebx
  800175:	5e                   	pop    %esi
  800176:	5f                   	pop    %edi
  800177:	5d                   	pop    %ebp
  800178:	c3                   	ret    

00800179 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800179:	55                   	push   %ebp
  80017a:	89 e5                	mov    %esp,%ebp
  80017c:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  80017f:	6a 00                	push   $0x0
  800181:	e8 b1 03 00 00       	call   800537 <sys_env_destroy>
}
  800186:	83 c4 10             	add    $0x10,%esp
  800189:	c9                   	leave  
  80018a:	c3                   	ret    

0080018b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80018b:	55                   	push   %ebp
  80018c:	89 e5                	mov    %esp,%ebp
  80018e:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800191:	b8 00 00 00 00       	mov    $0x0,%eax
  800196:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80019a:	74 05                	je     8001a1 <strlen+0x16>
		n++;
  80019c:	83 c0 01             	add    $0x1,%eax
  80019f:	eb f5                	jmp    800196 <strlen+0xb>
	return n;
}
  8001a1:	5d                   	pop    %ebp
  8001a2:	c3                   	ret    

008001a3 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8001a3:	55                   	push   %ebp
  8001a4:	89 e5                	mov    %esp,%ebp
  8001a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001a9:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8001ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8001b1:	39 c2                	cmp    %eax,%edx
  8001b3:	74 0d                	je     8001c2 <strnlen+0x1f>
  8001b5:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8001b9:	74 05                	je     8001c0 <strnlen+0x1d>
		n++;
  8001bb:	83 c2 01             	add    $0x1,%edx
  8001be:	eb f1                	jmp    8001b1 <strnlen+0xe>
  8001c0:	89 d0                	mov    %edx,%eax
	return n;
}
  8001c2:	5d                   	pop    %ebp
  8001c3:	c3                   	ret    

008001c4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8001c4:	55                   	push   %ebp
  8001c5:	89 e5                	mov    %esp,%ebp
  8001c7:	53                   	push   %ebx
  8001c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8001cb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8001ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8001d3:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8001d7:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8001da:	83 c2 01             	add    $0x1,%edx
  8001dd:	84 c9                	test   %cl,%cl
  8001df:	75 f2                	jne    8001d3 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8001e1:	5b                   	pop    %ebx
  8001e2:	5d                   	pop    %ebp
  8001e3:	c3                   	ret    

008001e4 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8001e4:	55                   	push   %ebp
  8001e5:	89 e5                	mov    %esp,%ebp
  8001e7:	53                   	push   %ebx
  8001e8:	83 ec 10             	sub    $0x10,%esp
  8001eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8001ee:	53                   	push   %ebx
  8001ef:	e8 97 ff ff ff       	call   80018b <strlen>
  8001f4:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8001f7:	ff 75 0c             	pushl  0xc(%ebp)
  8001fa:	01 d8                	add    %ebx,%eax
  8001fc:	50                   	push   %eax
  8001fd:	e8 c2 ff ff ff       	call   8001c4 <strcpy>
	return dst;
}
  800202:	89 d8                	mov    %ebx,%eax
  800204:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800207:	c9                   	leave  
  800208:	c3                   	ret    

00800209 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800209:	55                   	push   %ebp
  80020a:	89 e5                	mov    %esp,%ebp
  80020c:	56                   	push   %esi
  80020d:	53                   	push   %ebx
  80020e:	8b 45 08             	mov    0x8(%ebp),%eax
  800211:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800214:	89 c6                	mov    %eax,%esi
  800216:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800219:	89 c2                	mov    %eax,%edx
  80021b:	39 f2                	cmp    %esi,%edx
  80021d:	74 11                	je     800230 <strncpy+0x27>
		*dst++ = *src;
  80021f:	83 c2 01             	add    $0x1,%edx
  800222:	0f b6 19             	movzbl (%ecx),%ebx
  800225:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800228:	80 fb 01             	cmp    $0x1,%bl
  80022b:	83 d9 ff             	sbb    $0xffffffff,%ecx
  80022e:	eb eb                	jmp    80021b <strncpy+0x12>
	}
	return ret;
}
  800230:	5b                   	pop    %ebx
  800231:	5e                   	pop    %esi
  800232:	5d                   	pop    %ebp
  800233:	c3                   	ret    

00800234 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800234:	55                   	push   %ebp
  800235:	89 e5                	mov    %esp,%ebp
  800237:	56                   	push   %esi
  800238:	53                   	push   %ebx
  800239:	8b 75 08             	mov    0x8(%ebp),%esi
  80023c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80023f:	8b 55 10             	mov    0x10(%ebp),%edx
  800242:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800244:	85 d2                	test   %edx,%edx
  800246:	74 21                	je     800269 <strlcpy+0x35>
  800248:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80024c:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80024e:	39 c2                	cmp    %eax,%edx
  800250:	74 14                	je     800266 <strlcpy+0x32>
  800252:	0f b6 19             	movzbl (%ecx),%ebx
  800255:	84 db                	test   %bl,%bl
  800257:	74 0b                	je     800264 <strlcpy+0x30>
			*dst++ = *src++;
  800259:	83 c1 01             	add    $0x1,%ecx
  80025c:	83 c2 01             	add    $0x1,%edx
  80025f:	88 5a ff             	mov    %bl,-0x1(%edx)
  800262:	eb ea                	jmp    80024e <strlcpy+0x1a>
  800264:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800266:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800269:	29 f0                	sub    %esi,%eax
}
  80026b:	5b                   	pop    %ebx
  80026c:	5e                   	pop    %esi
  80026d:	5d                   	pop    %ebp
  80026e:	c3                   	ret    

0080026f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80026f:	55                   	push   %ebp
  800270:	89 e5                	mov    %esp,%ebp
  800272:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800275:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800278:	0f b6 01             	movzbl (%ecx),%eax
  80027b:	84 c0                	test   %al,%al
  80027d:	74 0c                	je     80028b <strcmp+0x1c>
  80027f:	3a 02                	cmp    (%edx),%al
  800281:	75 08                	jne    80028b <strcmp+0x1c>
		p++, q++;
  800283:	83 c1 01             	add    $0x1,%ecx
  800286:	83 c2 01             	add    $0x1,%edx
  800289:	eb ed                	jmp    800278 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80028b:	0f b6 c0             	movzbl %al,%eax
  80028e:	0f b6 12             	movzbl (%edx),%edx
  800291:	29 d0                	sub    %edx,%eax
}
  800293:	5d                   	pop    %ebp
  800294:	c3                   	ret    

00800295 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800295:	55                   	push   %ebp
  800296:	89 e5                	mov    %esp,%ebp
  800298:	53                   	push   %ebx
  800299:	8b 45 08             	mov    0x8(%ebp),%eax
  80029c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80029f:	89 c3                	mov    %eax,%ebx
  8002a1:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8002a4:	eb 06                	jmp    8002ac <strncmp+0x17>
		n--, p++, q++;
  8002a6:	83 c0 01             	add    $0x1,%eax
  8002a9:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8002ac:	39 d8                	cmp    %ebx,%eax
  8002ae:	74 16                	je     8002c6 <strncmp+0x31>
  8002b0:	0f b6 08             	movzbl (%eax),%ecx
  8002b3:	84 c9                	test   %cl,%cl
  8002b5:	74 04                	je     8002bb <strncmp+0x26>
  8002b7:	3a 0a                	cmp    (%edx),%cl
  8002b9:	74 eb                	je     8002a6 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8002bb:	0f b6 00             	movzbl (%eax),%eax
  8002be:	0f b6 12             	movzbl (%edx),%edx
  8002c1:	29 d0                	sub    %edx,%eax
}
  8002c3:	5b                   	pop    %ebx
  8002c4:	5d                   	pop    %ebp
  8002c5:	c3                   	ret    
		return 0;
  8002c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8002cb:	eb f6                	jmp    8002c3 <strncmp+0x2e>

008002cd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8002cd:	55                   	push   %ebp
  8002ce:	89 e5                	mov    %esp,%ebp
  8002d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d3:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8002d7:	0f b6 10             	movzbl (%eax),%edx
  8002da:	84 d2                	test   %dl,%dl
  8002dc:	74 09                	je     8002e7 <strchr+0x1a>
		if (*s == c)
  8002de:	38 ca                	cmp    %cl,%dl
  8002e0:	74 0a                	je     8002ec <strchr+0x1f>
	for (; *s; s++)
  8002e2:	83 c0 01             	add    $0x1,%eax
  8002e5:	eb f0                	jmp    8002d7 <strchr+0xa>
			return (char *) s;
	return 0;
  8002e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8002ec:	5d                   	pop    %ebp
  8002ed:	c3                   	ret    

008002ee <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8002ee:	55                   	push   %ebp
  8002ef:	89 e5                	mov    %esp,%ebp
  8002f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8002f8:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8002fb:	38 ca                	cmp    %cl,%dl
  8002fd:	74 09                	je     800308 <strfind+0x1a>
  8002ff:	84 d2                	test   %dl,%dl
  800301:	74 05                	je     800308 <strfind+0x1a>
	for (; *s; s++)
  800303:	83 c0 01             	add    $0x1,%eax
  800306:	eb f0                	jmp    8002f8 <strfind+0xa>
			break;
	return (char *) s;
}
  800308:	5d                   	pop    %ebp
  800309:	c3                   	ret    

0080030a <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80030a:	55                   	push   %ebp
  80030b:	89 e5                	mov    %esp,%ebp
  80030d:	57                   	push   %edi
  80030e:	56                   	push   %esi
  80030f:	53                   	push   %ebx
  800310:	8b 7d 08             	mov    0x8(%ebp),%edi
  800313:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800316:	85 c9                	test   %ecx,%ecx
  800318:	74 31                	je     80034b <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80031a:	89 f8                	mov    %edi,%eax
  80031c:	09 c8                	or     %ecx,%eax
  80031e:	a8 03                	test   $0x3,%al
  800320:	75 23                	jne    800345 <memset+0x3b>
		c &= 0xFF;
  800322:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800326:	89 d3                	mov    %edx,%ebx
  800328:	c1 e3 08             	shl    $0x8,%ebx
  80032b:	89 d0                	mov    %edx,%eax
  80032d:	c1 e0 18             	shl    $0x18,%eax
  800330:	89 d6                	mov    %edx,%esi
  800332:	c1 e6 10             	shl    $0x10,%esi
  800335:	09 f0                	or     %esi,%eax
  800337:	09 c2                	or     %eax,%edx
  800339:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80033b:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80033e:	89 d0                	mov    %edx,%eax
  800340:	fc                   	cld    
  800341:	f3 ab                	rep stos %eax,%es:(%edi)
  800343:	eb 06                	jmp    80034b <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800345:	8b 45 0c             	mov    0xc(%ebp),%eax
  800348:	fc                   	cld    
  800349:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80034b:	89 f8                	mov    %edi,%eax
  80034d:	5b                   	pop    %ebx
  80034e:	5e                   	pop    %esi
  80034f:	5f                   	pop    %edi
  800350:	5d                   	pop    %ebp
  800351:	c3                   	ret    

00800352 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800352:	55                   	push   %ebp
  800353:	89 e5                	mov    %esp,%ebp
  800355:	57                   	push   %edi
  800356:	56                   	push   %esi
  800357:	8b 45 08             	mov    0x8(%ebp),%eax
  80035a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80035d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800360:	39 c6                	cmp    %eax,%esi
  800362:	73 32                	jae    800396 <memmove+0x44>
  800364:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800367:	39 c2                	cmp    %eax,%edx
  800369:	76 2b                	jbe    800396 <memmove+0x44>
		s += n;
		d += n;
  80036b:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80036e:	89 fe                	mov    %edi,%esi
  800370:	09 ce                	or     %ecx,%esi
  800372:	09 d6                	or     %edx,%esi
  800374:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80037a:	75 0e                	jne    80038a <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80037c:	83 ef 04             	sub    $0x4,%edi
  80037f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800382:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800385:	fd                   	std    
  800386:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800388:	eb 09                	jmp    800393 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80038a:	83 ef 01             	sub    $0x1,%edi
  80038d:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800390:	fd                   	std    
  800391:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800393:	fc                   	cld    
  800394:	eb 1a                	jmp    8003b0 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800396:	89 c2                	mov    %eax,%edx
  800398:	09 ca                	or     %ecx,%edx
  80039a:	09 f2                	or     %esi,%edx
  80039c:	f6 c2 03             	test   $0x3,%dl
  80039f:	75 0a                	jne    8003ab <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8003a1:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8003a4:	89 c7                	mov    %eax,%edi
  8003a6:	fc                   	cld    
  8003a7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8003a9:	eb 05                	jmp    8003b0 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  8003ab:	89 c7                	mov    %eax,%edi
  8003ad:	fc                   	cld    
  8003ae:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8003b0:	5e                   	pop    %esi
  8003b1:	5f                   	pop    %edi
  8003b2:	5d                   	pop    %ebp
  8003b3:	c3                   	ret    

008003b4 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8003b4:	55                   	push   %ebp
  8003b5:	89 e5                	mov    %esp,%ebp
  8003b7:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8003ba:	ff 75 10             	pushl  0x10(%ebp)
  8003bd:	ff 75 0c             	pushl  0xc(%ebp)
  8003c0:	ff 75 08             	pushl  0x8(%ebp)
  8003c3:	e8 8a ff ff ff       	call   800352 <memmove>
}
  8003c8:	c9                   	leave  
  8003c9:	c3                   	ret    

008003ca <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8003ca:	55                   	push   %ebp
  8003cb:	89 e5                	mov    %esp,%ebp
  8003cd:	56                   	push   %esi
  8003ce:	53                   	push   %ebx
  8003cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003d5:	89 c6                	mov    %eax,%esi
  8003d7:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8003da:	39 f0                	cmp    %esi,%eax
  8003dc:	74 1c                	je     8003fa <memcmp+0x30>
		if (*s1 != *s2)
  8003de:	0f b6 08             	movzbl (%eax),%ecx
  8003e1:	0f b6 1a             	movzbl (%edx),%ebx
  8003e4:	38 d9                	cmp    %bl,%cl
  8003e6:	75 08                	jne    8003f0 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8003e8:	83 c0 01             	add    $0x1,%eax
  8003eb:	83 c2 01             	add    $0x1,%edx
  8003ee:	eb ea                	jmp    8003da <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8003f0:	0f b6 c1             	movzbl %cl,%eax
  8003f3:	0f b6 db             	movzbl %bl,%ebx
  8003f6:	29 d8                	sub    %ebx,%eax
  8003f8:	eb 05                	jmp    8003ff <memcmp+0x35>
	}

	return 0;
  8003fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8003ff:	5b                   	pop    %ebx
  800400:	5e                   	pop    %esi
  800401:	5d                   	pop    %ebp
  800402:	c3                   	ret    

00800403 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800403:	55                   	push   %ebp
  800404:	89 e5                	mov    %esp,%ebp
  800406:	8b 45 08             	mov    0x8(%ebp),%eax
  800409:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  80040c:	89 c2                	mov    %eax,%edx
  80040e:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800411:	39 d0                	cmp    %edx,%eax
  800413:	73 09                	jae    80041e <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800415:	38 08                	cmp    %cl,(%eax)
  800417:	74 05                	je     80041e <memfind+0x1b>
	for (; s < ends; s++)
  800419:	83 c0 01             	add    $0x1,%eax
  80041c:	eb f3                	jmp    800411 <memfind+0xe>
			break;
	return (void *) s;
}
  80041e:	5d                   	pop    %ebp
  80041f:	c3                   	ret    

00800420 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800420:	55                   	push   %ebp
  800421:	89 e5                	mov    %esp,%ebp
  800423:	57                   	push   %edi
  800424:	56                   	push   %esi
  800425:	53                   	push   %ebx
  800426:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800429:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80042c:	eb 03                	jmp    800431 <strtol+0x11>
		s++;
  80042e:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800431:	0f b6 01             	movzbl (%ecx),%eax
  800434:	3c 20                	cmp    $0x20,%al
  800436:	74 f6                	je     80042e <strtol+0xe>
  800438:	3c 09                	cmp    $0x9,%al
  80043a:	74 f2                	je     80042e <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  80043c:	3c 2b                	cmp    $0x2b,%al
  80043e:	74 2a                	je     80046a <strtol+0x4a>
	int neg = 0;
  800440:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800445:	3c 2d                	cmp    $0x2d,%al
  800447:	74 2b                	je     800474 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800449:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  80044f:	75 0f                	jne    800460 <strtol+0x40>
  800451:	80 39 30             	cmpb   $0x30,(%ecx)
  800454:	74 28                	je     80047e <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800456:	85 db                	test   %ebx,%ebx
  800458:	b8 0a 00 00 00       	mov    $0xa,%eax
  80045d:	0f 44 d8             	cmove  %eax,%ebx
  800460:	b8 00 00 00 00       	mov    $0x0,%eax
  800465:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800468:	eb 50                	jmp    8004ba <strtol+0x9a>
		s++;
  80046a:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  80046d:	bf 00 00 00 00       	mov    $0x0,%edi
  800472:	eb d5                	jmp    800449 <strtol+0x29>
		s++, neg = 1;
  800474:	83 c1 01             	add    $0x1,%ecx
  800477:	bf 01 00 00 00       	mov    $0x1,%edi
  80047c:	eb cb                	jmp    800449 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80047e:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800482:	74 0e                	je     800492 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800484:	85 db                	test   %ebx,%ebx
  800486:	75 d8                	jne    800460 <strtol+0x40>
		s++, base = 8;
  800488:	83 c1 01             	add    $0x1,%ecx
  80048b:	bb 08 00 00 00       	mov    $0x8,%ebx
  800490:	eb ce                	jmp    800460 <strtol+0x40>
		s += 2, base = 16;
  800492:	83 c1 02             	add    $0x2,%ecx
  800495:	bb 10 00 00 00       	mov    $0x10,%ebx
  80049a:	eb c4                	jmp    800460 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  80049c:	8d 72 9f             	lea    -0x61(%edx),%esi
  80049f:	89 f3                	mov    %esi,%ebx
  8004a1:	80 fb 19             	cmp    $0x19,%bl
  8004a4:	77 29                	ja     8004cf <strtol+0xaf>
			dig = *s - 'a' + 10;
  8004a6:	0f be d2             	movsbl %dl,%edx
  8004a9:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8004ac:	3b 55 10             	cmp    0x10(%ebp),%edx
  8004af:	7d 30                	jge    8004e1 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  8004b1:	83 c1 01             	add    $0x1,%ecx
  8004b4:	0f af 45 10          	imul   0x10(%ebp),%eax
  8004b8:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  8004ba:	0f b6 11             	movzbl (%ecx),%edx
  8004bd:	8d 72 d0             	lea    -0x30(%edx),%esi
  8004c0:	89 f3                	mov    %esi,%ebx
  8004c2:	80 fb 09             	cmp    $0x9,%bl
  8004c5:	77 d5                	ja     80049c <strtol+0x7c>
			dig = *s - '0';
  8004c7:	0f be d2             	movsbl %dl,%edx
  8004ca:	83 ea 30             	sub    $0x30,%edx
  8004cd:	eb dd                	jmp    8004ac <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  8004cf:	8d 72 bf             	lea    -0x41(%edx),%esi
  8004d2:	89 f3                	mov    %esi,%ebx
  8004d4:	80 fb 19             	cmp    $0x19,%bl
  8004d7:	77 08                	ja     8004e1 <strtol+0xc1>
			dig = *s - 'A' + 10;
  8004d9:	0f be d2             	movsbl %dl,%edx
  8004dc:	83 ea 37             	sub    $0x37,%edx
  8004df:	eb cb                	jmp    8004ac <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  8004e1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004e5:	74 05                	je     8004ec <strtol+0xcc>
		*endptr = (char *) s;
  8004e7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8004ea:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  8004ec:	89 c2                	mov    %eax,%edx
  8004ee:	f7 da                	neg    %edx
  8004f0:	85 ff                	test   %edi,%edi
  8004f2:	0f 45 c2             	cmovne %edx,%eax
}
  8004f5:	5b                   	pop    %ebx
  8004f6:	5e                   	pop    %esi
  8004f7:	5f                   	pop    %edi
  8004f8:	5d                   	pop    %ebp
  8004f9:	c3                   	ret    

008004fa <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8004fa:	55                   	push   %ebp
  8004fb:	89 e5                	mov    %esp,%ebp
  8004fd:	57                   	push   %edi
  8004fe:	56                   	push   %esi
  8004ff:	53                   	push   %ebx
	asm volatile("int %1\n"
  800500:	b8 00 00 00 00       	mov    $0x0,%eax
  800505:	8b 55 08             	mov    0x8(%ebp),%edx
  800508:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80050b:	89 c3                	mov    %eax,%ebx
  80050d:	89 c7                	mov    %eax,%edi
  80050f:	89 c6                	mov    %eax,%esi
  800511:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800513:	5b                   	pop    %ebx
  800514:	5e                   	pop    %esi
  800515:	5f                   	pop    %edi
  800516:	5d                   	pop    %ebp
  800517:	c3                   	ret    

00800518 <sys_cgetc>:

int
sys_cgetc(void)
{
  800518:	55                   	push   %ebp
  800519:	89 e5                	mov    %esp,%ebp
  80051b:	57                   	push   %edi
  80051c:	56                   	push   %esi
  80051d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80051e:	ba 00 00 00 00       	mov    $0x0,%edx
  800523:	b8 01 00 00 00       	mov    $0x1,%eax
  800528:	89 d1                	mov    %edx,%ecx
  80052a:	89 d3                	mov    %edx,%ebx
  80052c:	89 d7                	mov    %edx,%edi
  80052e:	89 d6                	mov    %edx,%esi
  800530:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800532:	5b                   	pop    %ebx
  800533:	5e                   	pop    %esi
  800534:	5f                   	pop    %edi
  800535:	5d                   	pop    %ebp
  800536:	c3                   	ret    

00800537 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800537:	55                   	push   %ebp
  800538:	89 e5                	mov    %esp,%ebp
  80053a:	57                   	push   %edi
  80053b:	56                   	push   %esi
  80053c:	53                   	push   %ebx
  80053d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800540:	b9 00 00 00 00       	mov    $0x0,%ecx
  800545:	8b 55 08             	mov    0x8(%ebp),%edx
  800548:	b8 03 00 00 00       	mov    $0x3,%eax
  80054d:	89 cb                	mov    %ecx,%ebx
  80054f:	89 cf                	mov    %ecx,%edi
  800551:	89 ce                	mov    %ecx,%esi
  800553:	cd 30                	int    $0x30
	if(check && ret > 0)
  800555:	85 c0                	test   %eax,%eax
  800557:	7f 08                	jg     800561 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800559:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80055c:	5b                   	pop    %ebx
  80055d:	5e                   	pop    %esi
  80055e:	5f                   	pop    %edi
  80055f:	5d                   	pop    %ebp
  800560:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800561:	83 ec 0c             	sub    $0xc,%esp
  800564:	50                   	push   %eax
  800565:	6a 03                	push   $0x3
  800567:	68 2f 20 80 00       	push   $0x80202f
  80056c:	6a 43                	push   $0x43
  80056e:	68 4c 20 80 00       	push   $0x80204c
  800573:	e8 f3 0e 00 00       	call   80146b <_panic>

00800578 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800578:	55                   	push   %ebp
  800579:	89 e5                	mov    %esp,%ebp
  80057b:	57                   	push   %edi
  80057c:	56                   	push   %esi
  80057d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80057e:	ba 00 00 00 00       	mov    $0x0,%edx
  800583:	b8 02 00 00 00       	mov    $0x2,%eax
  800588:	89 d1                	mov    %edx,%ecx
  80058a:	89 d3                	mov    %edx,%ebx
  80058c:	89 d7                	mov    %edx,%edi
  80058e:	89 d6                	mov    %edx,%esi
  800590:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800592:	5b                   	pop    %ebx
  800593:	5e                   	pop    %esi
  800594:	5f                   	pop    %edi
  800595:	5d                   	pop    %ebp
  800596:	c3                   	ret    

00800597 <sys_yield>:

void
sys_yield(void)
{
  800597:	55                   	push   %ebp
  800598:	89 e5                	mov    %esp,%ebp
  80059a:	57                   	push   %edi
  80059b:	56                   	push   %esi
  80059c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80059d:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a2:	b8 0b 00 00 00       	mov    $0xb,%eax
  8005a7:	89 d1                	mov    %edx,%ecx
  8005a9:	89 d3                	mov    %edx,%ebx
  8005ab:	89 d7                	mov    %edx,%edi
  8005ad:	89 d6                	mov    %edx,%esi
  8005af:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8005b1:	5b                   	pop    %ebx
  8005b2:	5e                   	pop    %esi
  8005b3:	5f                   	pop    %edi
  8005b4:	5d                   	pop    %ebp
  8005b5:	c3                   	ret    

008005b6 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8005b6:	55                   	push   %ebp
  8005b7:	89 e5                	mov    %esp,%ebp
  8005b9:	57                   	push   %edi
  8005ba:	56                   	push   %esi
  8005bb:	53                   	push   %ebx
  8005bc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8005bf:	be 00 00 00 00       	mov    $0x0,%esi
  8005c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8005c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005ca:	b8 04 00 00 00       	mov    $0x4,%eax
  8005cf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8005d2:	89 f7                	mov    %esi,%edi
  8005d4:	cd 30                	int    $0x30
	if(check && ret > 0)
  8005d6:	85 c0                	test   %eax,%eax
  8005d8:	7f 08                	jg     8005e2 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8005da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005dd:	5b                   	pop    %ebx
  8005de:	5e                   	pop    %esi
  8005df:	5f                   	pop    %edi
  8005e0:	5d                   	pop    %ebp
  8005e1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8005e2:	83 ec 0c             	sub    $0xc,%esp
  8005e5:	50                   	push   %eax
  8005e6:	6a 04                	push   $0x4
  8005e8:	68 2f 20 80 00       	push   $0x80202f
  8005ed:	6a 43                	push   $0x43
  8005ef:	68 4c 20 80 00       	push   $0x80204c
  8005f4:	e8 72 0e 00 00       	call   80146b <_panic>

008005f9 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8005f9:	55                   	push   %ebp
  8005fa:	89 e5                	mov    %esp,%ebp
  8005fc:	57                   	push   %edi
  8005fd:	56                   	push   %esi
  8005fe:	53                   	push   %ebx
  8005ff:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800602:	8b 55 08             	mov    0x8(%ebp),%edx
  800605:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800608:	b8 05 00 00 00       	mov    $0x5,%eax
  80060d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800610:	8b 7d 14             	mov    0x14(%ebp),%edi
  800613:	8b 75 18             	mov    0x18(%ebp),%esi
  800616:	cd 30                	int    $0x30
	if(check && ret > 0)
  800618:	85 c0                	test   %eax,%eax
  80061a:	7f 08                	jg     800624 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80061c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80061f:	5b                   	pop    %ebx
  800620:	5e                   	pop    %esi
  800621:	5f                   	pop    %edi
  800622:	5d                   	pop    %ebp
  800623:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800624:	83 ec 0c             	sub    $0xc,%esp
  800627:	50                   	push   %eax
  800628:	6a 05                	push   $0x5
  80062a:	68 2f 20 80 00       	push   $0x80202f
  80062f:	6a 43                	push   $0x43
  800631:	68 4c 20 80 00       	push   $0x80204c
  800636:	e8 30 0e 00 00       	call   80146b <_panic>

0080063b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80063b:	55                   	push   %ebp
  80063c:	89 e5                	mov    %esp,%ebp
  80063e:	57                   	push   %edi
  80063f:	56                   	push   %esi
  800640:	53                   	push   %ebx
  800641:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800644:	bb 00 00 00 00       	mov    $0x0,%ebx
  800649:	8b 55 08             	mov    0x8(%ebp),%edx
  80064c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80064f:	b8 06 00 00 00       	mov    $0x6,%eax
  800654:	89 df                	mov    %ebx,%edi
  800656:	89 de                	mov    %ebx,%esi
  800658:	cd 30                	int    $0x30
	if(check && ret > 0)
  80065a:	85 c0                	test   %eax,%eax
  80065c:	7f 08                	jg     800666 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80065e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800661:	5b                   	pop    %ebx
  800662:	5e                   	pop    %esi
  800663:	5f                   	pop    %edi
  800664:	5d                   	pop    %ebp
  800665:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800666:	83 ec 0c             	sub    $0xc,%esp
  800669:	50                   	push   %eax
  80066a:	6a 06                	push   $0x6
  80066c:	68 2f 20 80 00       	push   $0x80202f
  800671:	6a 43                	push   $0x43
  800673:	68 4c 20 80 00       	push   $0x80204c
  800678:	e8 ee 0d 00 00       	call   80146b <_panic>

0080067d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80067d:	55                   	push   %ebp
  80067e:	89 e5                	mov    %esp,%ebp
  800680:	57                   	push   %edi
  800681:	56                   	push   %esi
  800682:	53                   	push   %ebx
  800683:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800686:	bb 00 00 00 00       	mov    $0x0,%ebx
  80068b:	8b 55 08             	mov    0x8(%ebp),%edx
  80068e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800691:	b8 08 00 00 00       	mov    $0x8,%eax
  800696:	89 df                	mov    %ebx,%edi
  800698:	89 de                	mov    %ebx,%esi
  80069a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80069c:	85 c0                	test   %eax,%eax
  80069e:	7f 08                	jg     8006a8 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8006a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006a3:	5b                   	pop    %ebx
  8006a4:	5e                   	pop    %esi
  8006a5:	5f                   	pop    %edi
  8006a6:	5d                   	pop    %ebp
  8006a7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8006a8:	83 ec 0c             	sub    $0xc,%esp
  8006ab:	50                   	push   %eax
  8006ac:	6a 08                	push   $0x8
  8006ae:	68 2f 20 80 00       	push   $0x80202f
  8006b3:	6a 43                	push   $0x43
  8006b5:	68 4c 20 80 00       	push   $0x80204c
  8006ba:	e8 ac 0d 00 00       	call   80146b <_panic>

008006bf <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8006bf:	55                   	push   %ebp
  8006c0:	89 e5                	mov    %esp,%ebp
  8006c2:	57                   	push   %edi
  8006c3:	56                   	push   %esi
  8006c4:	53                   	push   %ebx
  8006c5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8006c8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8006d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006d3:	b8 09 00 00 00       	mov    $0x9,%eax
  8006d8:	89 df                	mov    %ebx,%edi
  8006da:	89 de                	mov    %ebx,%esi
  8006dc:	cd 30                	int    $0x30
	if(check && ret > 0)
  8006de:	85 c0                	test   %eax,%eax
  8006e0:	7f 08                	jg     8006ea <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8006e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006e5:	5b                   	pop    %ebx
  8006e6:	5e                   	pop    %esi
  8006e7:	5f                   	pop    %edi
  8006e8:	5d                   	pop    %ebp
  8006e9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8006ea:	83 ec 0c             	sub    $0xc,%esp
  8006ed:	50                   	push   %eax
  8006ee:	6a 09                	push   $0x9
  8006f0:	68 2f 20 80 00       	push   $0x80202f
  8006f5:	6a 43                	push   $0x43
  8006f7:	68 4c 20 80 00       	push   $0x80204c
  8006fc:	e8 6a 0d 00 00       	call   80146b <_panic>

00800701 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800701:	55                   	push   %ebp
  800702:	89 e5                	mov    %esp,%ebp
  800704:	57                   	push   %edi
  800705:	56                   	push   %esi
  800706:	53                   	push   %ebx
  800707:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80070a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80070f:	8b 55 08             	mov    0x8(%ebp),%edx
  800712:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800715:	b8 0a 00 00 00       	mov    $0xa,%eax
  80071a:	89 df                	mov    %ebx,%edi
  80071c:	89 de                	mov    %ebx,%esi
  80071e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800720:	85 c0                	test   %eax,%eax
  800722:	7f 08                	jg     80072c <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800724:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800727:	5b                   	pop    %ebx
  800728:	5e                   	pop    %esi
  800729:	5f                   	pop    %edi
  80072a:	5d                   	pop    %ebp
  80072b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80072c:	83 ec 0c             	sub    $0xc,%esp
  80072f:	50                   	push   %eax
  800730:	6a 0a                	push   $0xa
  800732:	68 2f 20 80 00       	push   $0x80202f
  800737:	6a 43                	push   $0x43
  800739:	68 4c 20 80 00       	push   $0x80204c
  80073e:	e8 28 0d 00 00       	call   80146b <_panic>

00800743 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800743:	55                   	push   %ebp
  800744:	89 e5                	mov    %esp,%ebp
  800746:	57                   	push   %edi
  800747:	56                   	push   %esi
  800748:	53                   	push   %ebx
	asm volatile("int %1\n"
  800749:	8b 55 08             	mov    0x8(%ebp),%edx
  80074c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80074f:	b8 0c 00 00 00       	mov    $0xc,%eax
  800754:	be 00 00 00 00       	mov    $0x0,%esi
  800759:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80075c:	8b 7d 14             	mov    0x14(%ebp),%edi
  80075f:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800761:	5b                   	pop    %ebx
  800762:	5e                   	pop    %esi
  800763:	5f                   	pop    %edi
  800764:	5d                   	pop    %ebp
  800765:	c3                   	ret    

00800766 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800766:	55                   	push   %ebp
  800767:	89 e5                	mov    %esp,%ebp
  800769:	57                   	push   %edi
  80076a:	56                   	push   %esi
  80076b:	53                   	push   %ebx
  80076c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80076f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800774:	8b 55 08             	mov    0x8(%ebp),%edx
  800777:	b8 0d 00 00 00       	mov    $0xd,%eax
  80077c:	89 cb                	mov    %ecx,%ebx
  80077e:	89 cf                	mov    %ecx,%edi
  800780:	89 ce                	mov    %ecx,%esi
  800782:	cd 30                	int    $0x30
	if(check && ret > 0)
  800784:	85 c0                	test   %eax,%eax
  800786:	7f 08                	jg     800790 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800788:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80078b:	5b                   	pop    %ebx
  80078c:	5e                   	pop    %esi
  80078d:	5f                   	pop    %edi
  80078e:	5d                   	pop    %ebp
  80078f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800790:	83 ec 0c             	sub    $0xc,%esp
  800793:	50                   	push   %eax
  800794:	6a 0d                	push   $0xd
  800796:	68 2f 20 80 00       	push   $0x80202f
  80079b:	6a 43                	push   $0x43
  80079d:	68 4c 20 80 00       	push   $0x80204c
  8007a2:	e8 c4 0c 00 00       	call   80146b <_panic>

008007a7 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  8007a7:	55                   	push   %ebp
  8007a8:	89 e5                	mov    %esp,%ebp
  8007aa:	57                   	push   %edi
  8007ab:	56                   	push   %esi
  8007ac:	53                   	push   %ebx
	asm volatile("int %1\n"
  8007ad:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8007b5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007b8:	b8 0e 00 00 00       	mov    $0xe,%eax
  8007bd:	89 df                	mov    %ebx,%edi
  8007bf:	89 de                	mov    %ebx,%esi
  8007c1:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8007c3:	5b                   	pop    %ebx
  8007c4:	5e                   	pop    %esi
  8007c5:	5f                   	pop    %edi
  8007c6:	5d                   	pop    %ebp
  8007c7:	c3                   	ret    

008007c8 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8007c8:	55                   	push   %ebp
  8007c9:	89 e5                	mov    %esp,%ebp
  8007cb:	57                   	push   %edi
  8007cc:	56                   	push   %esi
  8007cd:	53                   	push   %ebx
	asm volatile("int %1\n"
  8007ce:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8007d6:	b8 0f 00 00 00       	mov    $0xf,%eax
  8007db:	89 cb                	mov    %ecx,%ebx
  8007dd:	89 cf                	mov    %ecx,%edi
  8007df:	89 ce                	mov    %ecx,%esi
  8007e1:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8007e3:	5b                   	pop    %ebx
  8007e4:	5e                   	pop    %esi
  8007e5:	5f                   	pop    %edi
  8007e6:	5d                   	pop    %ebp
  8007e7:	c3                   	ret    

008007e8 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8007e8:	55                   	push   %ebp
  8007e9:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8007eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ee:	05 00 00 00 30       	add    $0x30000000,%eax
  8007f3:	c1 e8 0c             	shr    $0xc,%eax
}
  8007f6:	5d                   	pop    %ebp
  8007f7:	c3                   	ret    

008007f8 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8007f8:	55                   	push   %ebp
  8007f9:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8007fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fe:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800803:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800808:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80080d:	5d                   	pop    %ebp
  80080e:	c3                   	ret    

0080080f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80080f:	55                   	push   %ebp
  800810:	89 e5                	mov    %esp,%ebp
  800812:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800817:	89 c2                	mov    %eax,%edx
  800819:	c1 ea 16             	shr    $0x16,%edx
  80081c:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800823:	f6 c2 01             	test   $0x1,%dl
  800826:	74 2d                	je     800855 <fd_alloc+0x46>
  800828:	89 c2                	mov    %eax,%edx
  80082a:	c1 ea 0c             	shr    $0xc,%edx
  80082d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800834:	f6 c2 01             	test   $0x1,%dl
  800837:	74 1c                	je     800855 <fd_alloc+0x46>
  800839:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80083e:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800843:	75 d2                	jne    800817 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800845:	8b 45 08             	mov    0x8(%ebp),%eax
  800848:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80084e:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800853:	eb 0a                	jmp    80085f <fd_alloc+0x50>
			*fd_store = fd;
  800855:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800858:	89 01                	mov    %eax,(%ecx)
			return 0;
  80085a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80085f:	5d                   	pop    %ebp
  800860:	c3                   	ret    

00800861 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800861:	55                   	push   %ebp
  800862:	89 e5                	mov    %esp,%ebp
  800864:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800867:	83 f8 1f             	cmp    $0x1f,%eax
  80086a:	77 30                	ja     80089c <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80086c:	c1 e0 0c             	shl    $0xc,%eax
  80086f:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800874:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80087a:	f6 c2 01             	test   $0x1,%dl
  80087d:	74 24                	je     8008a3 <fd_lookup+0x42>
  80087f:	89 c2                	mov    %eax,%edx
  800881:	c1 ea 0c             	shr    $0xc,%edx
  800884:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80088b:	f6 c2 01             	test   $0x1,%dl
  80088e:	74 1a                	je     8008aa <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800890:	8b 55 0c             	mov    0xc(%ebp),%edx
  800893:	89 02                	mov    %eax,(%edx)
	return 0;
  800895:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80089a:	5d                   	pop    %ebp
  80089b:	c3                   	ret    
		return -E_INVAL;
  80089c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008a1:	eb f7                	jmp    80089a <fd_lookup+0x39>
		return -E_INVAL;
  8008a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008a8:	eb f0                	jmp    80089a <fd_lookup+0x39>
  8008aa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008af:	eb e9                	jmp    80089a <fd_lookup+0x39>

008008b1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8008b1:	55                   	push   %ebp
  8008b2:	89 e5                	mov    %esp,%ebp
  8008b4:	83 ec 08             	sub    $0x8,%esp
  8008b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008ba:	ba d8 20 80 00       	mov    $0x8020d8,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8008bf:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8008c4:	39 08                	cmp    %ecx,(%eax)
  8008c6:	74 33                	je     8008fb <dev_lookup+0x4a>
  8008c8:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8008cb:	8b 02                	mov    (%edx),%eax
  8008cd:	85 c0                	test   %eax,%eax
  8008cf:	75 f3                	jne    8008c4 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8008d1:	a1 04 40 80 00       	mov    0x804004,%eax
  8008d6:	8b 40 48             	mov    0x48(%eax),%eax
  8008d9:	83 ec 04             	sub    $0x4,%esp
  8008dc:	51                   	push   %ecx
  8008dd:	50                   	push   %eax
  8008de:	68 5c 20 80 00       	push   $0x80205c
  8008e3:	e8 79 0c 00 00       	call   801561 <cprintf>
	*dev = 0;
  8008e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8008f1:	83 c4 10             	add    $0x10,%esp
  8008f4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8008f9:	c9                   	leave  
  8008fa:	c3                   	ret    
			*dev = devtab[i];
  8008fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008fe:	89 01                	mov    %eax,(%ecx)
			return 0;
  800900:	b8 00 00 00 00       	mov    $0x0,%eax
  800905:	eb f2                	jmp    8008f9 <dev_lookup+0x48>

00800907 <fd_close>:
{
  800907:	55                   	push   %ebp
  800908:	89 e5                	mov    %esp,%ebp
  80090a:	57                   	push   %edi
  80090b:	56                   	push   %esi
  80090c:	53                   	push   %ebx
  80090d:	83 ec 24             	sub    $0x24,%esp
  800910:	8b 75 08             	mov    0x8(%ebp),%esi
  800913:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800916:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800919:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80091a:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800920:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800923:	50                   	push   %eax
  800924:	e8 38 ff ff ff       	call   800861 <fd_lookup>
  800929:	89 c3                	mov    %eax,%ebx
  80092b:	83 c4 10             	add    $0x10,%esp
  80092e:	85 c0                	test   %eax,%eax
  800930:	78 05                	js     800937 <fd_close+0x30>
	    || fd != fd2)
  800932:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800935:	74 16                	je     80094d <fd_close+0x46>
		return (must_exist ? r : 0);
  800937:	89 f8                	mov    %edi,%eax
  800939:	84 c0                	test   %al,%al
  80093b:	b8 00 00 00 00       	mov    $0x0,%eax
  800940:	0f 44 d8             	cmove  %eax,%ebx
}
  800943:	89 d8                	mov    %ebx,%eax
  800945:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800948:	5b                   	pop    %ebx
  800949:	5e                   	pop    %esi
  80094a:	5f                   	pop    %edi
  80094b:	5d                   	pop    %ebp
  80094c:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80094d:	83 ec 08             	sub    $0x8,%esp
  800950:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800953:	50                   	push   %eax
  800954:	ff 36                	pushl  (%esi)
  800956:	e8 56 ff ff ff       	call   8008b1 <dev_lookup>
  80095b:	89 c3                	mov    %eax,%ebx
  80095d:	83 c4 10             	add    $0x10,%esp
  800960:	85 c0                	test   %eax,%eax
  800962:	78 1a                	js     80097e <fd_close+0x77>
		if (dev->dev_close)
  800964:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800967:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80096a:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80096f:	85 c0                	test   %eax,%eax
  800971:	74 0b                	je     80097e <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  800973:	83 ec 0c             	sub    $0xc,%esp
  800976:	56                   	push   %esi
  800977:	ff d0                	call   *%eax
  800979:	89 c3                	mov    %eax,%ebx
  80097b:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80097e:	83 ec 08             	sub    $0x8,%esp
  800981:	56                   	push   %esi
  800982:	6a 00                	push   $0x0
  800984:	e8 b2 fc ff ff       	call   80063b <sys_page_unmap>
	return r;
  800989:	83 c4 10             	add    $0x10,%esp
  80098c:	eb b5                	jmp    800943 <fd_close+0x3c>

0080098e <close>:

int
close(int fdnum)
{
  80098e:	55                   	push   %ebp
  80098f:	89 e5                	mov    %esp,%ebp
  800991:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800994:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800997:	50                   	push   %eax
  800998:	ff 75 08             	pushl  0x8(%ebp)
  80099b:	e8 c1 fe ff ff       	call   800861 <fd_lookup>
  8009a0:	83 c4 10             	add    $0x10,%esp
  8009a3:	85 c0                	test   %eax,%eax
  8009a5:	79 02                	jns    8009a9 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8009a7:	c9                   	leave  
  8009a8:	c3                   	ret    
		return fd_close(fd, 1);
  8009a9:	83 ec 08             	sub    $0x8,%esp
  8009ac:	6a 01                	push   $0x1
  8009ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8009b1:	e8 51 ff ff ff       	call   800907 <fd_close>
  8009b6:	83 c4 10             	add    $0x10,%esp
  8009b9:	eb ec                	jmp    8009a7 <close+0x19>

008009bb <close_all>:

void
close_all(void)
{
  8009bb:	55                   	push   %ebp
  8009bc:	89 e5                	mov    %esp,%ebp
  8009be:	53                   	push   %ebx
  8009bf:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8009c2:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8009c7:	83 ec 0c             	sub    $0xc,%esp
  8009ca:	53                   	push   %ebx
  8009cb:	e8 be ff ff ff       	call   80098e <close>
	for (i = 0; i < MAXFD; i++)
  8009d0:	83 c3 01             	add    $0x1,%ebx
  8009d3:	83 c4 10             	add    $0x10,%esp
  8009d6:	83 fb 20             	cmp    $0x20,%ebx
  8009d9:	75 ec                	jne    8009c7 <close_all+0xc>
}
  8009db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009de:	c9                   	leave  
  8009df:	c3                   	ret    

008009e0 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8009e0:	55                   	push   %ebp
  8009e1:	89 e5                	mov    %esp,%ebp
  8009e3:	57                   	push   %edi
  8009e4:	56                   	push   %esi
  8009e5:	53                   	push   %ebx
  8009e6:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8009e9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8009ec:	50                   	push   %eax
  8009ed:	ff 75 08             	pushl  0x8(%ebp)
  8009f0:	e8 6c fe ff ff       	call   800861 <fd_lookup>
  8009f5:	89 c3                	mov    %eax,%ebx
  8009f7:	83 c4 10             	add    $0x10,%esp
  8009fa:	85 c0                	test   %eax,%eax
  8009fc:	0f 88 81 00 00 00    	js     800a83 <dup+0xa3>
		return r;
	close(newfdnum);
  800a02:	83 ec 0c             	sub    $0xc,%esp
  800a05:	ff 75 0c             	pushl  0xc(%ebp)
  800a08:	e8 81 ff ff ff       	call   80098e <close>

	newfd = INDEX2FD(newfdnum);
  800a0d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a10:	c1 e6 0c             	shl    $0xc,%esi
  800a13:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800a19:	83 c4 04             	add    $0x4,%esp
  800a1c:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a1f:	e8 d4 fd ff ff       	call   8007f8 <fd2data>
  800a24:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800a26:	89 34 24             	mov    %esi,(%esp)
  800a29:	e8 ca fd ff ff       	call   8007f8 <fd2data>
  800a2e:	83 c4 10             	add    $0x10,%esp
  800a31:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800a33:	89 d8                	mov    %ebx,%eax
  800a35:	c1 e8 16             	shr    $0x16,%eax
  800a38:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800a3f:	a8 01                	test   $0x1,%al
  800a41:	74 11                	je     800a54 <dup+0x74>
  800a43:	89 d8                	mov    %ebx,%eax
  800a45:	c1 e8 0c             	shr    $0xc,%eax
  800a48:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800a4f:	f6 c2 01             	test   $0x1,%dl
  800a52:	75 39                	jne    800a8d <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800a54:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800a57:	89 d0                	mov    %edx,%eax
  800a59:	c1 e8 0c             	shr    $0xc,%eax
  800a5c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800a63:	83 ec 0c             	sub    $0xc,%esp
  800a66:	25 07 0e 00 00       	and    $0xe07,%eax
  800a6b:	50                   	push   %eax
  800a6c:	56                   	push   %esi
  800a6d:	6a 00                	push   $0x0
  800a6f:	52                   	push   %edx
  800a70:	6a 00                	push   $0x0
  800a72:	e8 82 fb ff ff       	call   8005f9 <sys_page_map>
  800a77:	89 c3                	mov    %eax,%ebx
  800a79:	83 c4 20             	add    $0x20,%esp
  800a7c:	85 c0                	test   %eax,%eax
  800a7e:	78 31                	js     800ab1 <dup+0xd1>
		goto err;

	return newfdnum;
  800a80:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800a83:	89 d8                	mov    %ebx,%eax
  800a85:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a88:	5b                   	pop    %ebx
  800a89:	5e                   	pop    %esi
  800a8a:	5f                   	pop    %edi
  800a8b:	5d                   	pop    %ebp
  800a8c:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800a8d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800a94:	83 ec 0c             	sub    $0xc,%esp
  800a97:	25 07 0e 00 00       	and    $0xe07,%eax
  800a9c:	50                   	push   %eax
  800a9d:	57                   	push   %edi
  800a9e:	6a 00                	push   $0x0
  800aa0:	53                   	push   %ebx
  800aa1:	6a 00                	push   $0x0
  800aa3:	e8 51 fb ff ff       	call   8005f9 <sys_page_map>
  800aa8:	89 c3                	mov    %eax,%ebx
  800aaa:	83 c4 20             	add    $0x20,%esp
  800aad:	85 c0                	test   %eax,%eax
  800aaf:	79 a3                	jns    800a54 <dup+0x74>
	sys_page_unmap(0, newfd);
  800ab1:	83 ec 08             	sub    $0x8,%esp
  800ab4:	56                   	push   %esi
  800ab5:	6a 00                	push   $0x0
  800ab7:	e8 7f fb ff ff       	call   80063b <sys_page_unmap>
	sys_page_unmap(0, nva);
  800abc:	83 c4 08             	add    $0x8,%esp
  800abf:	57                   	push   %edi
  800ac0:	6a 00                	push   $0x0
  800ac2:	e8 74 fb ff ff       	call   80063b <sys_page_unmap>
	return r;
  800ac7:	83 c4 10             	add    $0x10,%esp
  800aca:	eb b7                	jmp    800a83 <dup+0xa3>

00800acc <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800acc:	55                   	push   %ebp
  800acd:	89 e5                	mov    %esp,%ebp
  800acf:	53                   	push   %ebx
  800ad0:	83 ec 1c             	sub    $0x1c,%esp
  800ad3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800ad6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800ad9:	50                   	push   %eax
  800ada:	53                   	push   %ebx
  800adb:	e8 81 fd ff ff       	call   800861 <fd_lookup>
  800ae0:	83 c4 10             	add    $0x10,%esp
  800ae3:	85 c0                	test   %eax,%eax
  800ae5:	78 3f                	js     800b26 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800ae7:	83 ec 08             	sub    $0x8,%esp
  800aea:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800aed:	50                   	push   %eax
  800aee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800af1:	ff 30                	pushl  (%eax)
  800af3:	e8 b9 fd ff ff       	call   8008b1 <dev_lookup>
  800af8:	83 c4 10             	add    $0x10,%esp
  800afb:	85 c0                	test   %eax,%eax
  800afd:	78 27                	js     800b26 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800aff:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800b02:	8b 42 08             	mov    0x8(%edx),%eax
  800b05:	83 e0 03             	and    $0x3,%eax
  800b08:	83 f8 01             	cmp    $0x1,%eax
  800b0b:	74 1e                	je     800b2b <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  800b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b10:	8b 40 08             	mov    0x8(%eax),%eax
  800b13:	85 c0                	test   %eax,%eax
  800b15:	74 35                	je     800b4c <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800b17:	83 ec 04             	sub    $0x4,%esp
  800b1a:	ff 75 10             	pushl  0x10(%ebp)
  800b1d:	ff 75 0c             	pushl  0xc(%ebp)
  800b20:	52                   	push   %edx
  800b21:	ff d0                	call   *%eax
  800b23:	83 c4 10             	add    $0x10,%esp
}
  800b26:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b29:	c9                   	leave  
  800b2a:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800b2b:	a1 04 40 80 00       	mov    0x804004,%eax
  800b30:	8b 40 48             	mov    0x48(%eax),%eax
  800b33:	83 ec 04             	sub    $0x4,%esp
  800b36:	53                   	push   %ebx
  800b37:	50                   	push   %eax
  800b38:	68 9d 20 80 00       	push   $0x80209d
  800b3d:	e8 1f 0a 00 00       	call   801561 <cprintf>
		return -E_INVAL;
  800b42:	83 c4 10             	add    $0x10,%esp
  800b45:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b4a:	eb da                	jmp    800b26 <read+0x5a>
		return -E_NOT_SUPP;
  800b4c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800b51:	eb d3                	jmp    800b26 <read+0x5a>

00800b53 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800b53:	55                   	push   %ebp
  800b54:	89 e5                	mov    %esp,%ebp
  800b56:	57                   	push   %edi
  800b57:	56                   	push   %esi
  800b58:	53                   	push   %ebx
  800b59:	83 ec 0c             	sub    $0xc,%esp
  800b5c:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b5f:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800b62:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b67:	39 f3                	cmp    %esi,%ebx
  800b69:	73 23                	jae    800b8e <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800b6b:	83 ec 04             	sub    $0x4,%esp
  800b6e:	89 f0                	mov    %esi,%eax
  800b70:	29 d8                	sub    %ebx,%eax
  800b72:	50                   	push   %eax
  800b73:	89 d8                	mov    %ebx,%eax
  800b75:	03 45 0c             	add    0xc(%ebp),%eax
  800b78:	50                   	push   %eax
  800b79:	57                   	push   %edi
  800b7a:	e8 4d ff ff ff       	call   800acc <read>
		if (m < 0)
  800b7f:	83 c4 10             	add    $0x10,%esp
  800b82:	85 c0                	test   %eax,%eax
  800b84:	78 06                	js     800b8c <readn+0x39>
			return m;
		if (m == 0)
  800b86:	74 06                	je     800b8e <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  800b88:	01 c3                	add    %eax,%ebx
  800b8a:	eb db                	jmp    800b67 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800b8c:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  800b8e:	89 d8                	mov    %ebx,%eax
  800b90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b93:	5b                   	pop    %ebx
  800b94:	5e                   	pop    %esi
  800b95:	5f                   	pop    %edi
  800b96:	5d                   	pop    %ebp
  800b97:	c3                   	ret    

00800b98 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800b98:	55                   	push   %ebp
  800b99:	89 e5                	mov    %esp,%ebp
  800b9b:	53                   	push   %ebx
  800b9c:	83 ec 1c             	sub    $0x1c,%esp
  800b9f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800ba2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800ba5:	50                   	push   %eax
  800ba6:	53                   	push   %ebx
  800ba7:	e8 b5 fc ff ff       	call   800861 <fd_lookup>
  800bac:	83 c4 10             	add    $0x10,%esp
  800baf:	85 c0                	test   %eax,%eax
  800bb1:	78 3a                	js     800bed <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800bb3:	83 ec 08             	sub    $0x8,%esp
  800bb6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800bb9:	50                   	push   %eax
  800bba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bbd:	ff 30                	pushl  (%eax)
  800bbf:	e8 ed fc ff ff       	call   8008b1 <dev_lookup>
  800bc4:	83 c4 10             	add    $0x10,%esp
  800bc7:	85 c0                	test   %eax,%eax
  800bc9:	78 22                	js     800bed <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800bcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bce:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800bd2:	74 1e                	je     800bf2 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800bd4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bd7:	8b 52 0c             	mov    0xc(%edx),%edx
  800bda:	85 d2                	test   %edx,%edx
  800bdc:	74 35                	je     800c13 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800bde:	83 ec 04             	sub    $0x4,%esp
  800be1:	ff 75 10             	pushl  0x10(%ebp)
  800be4:	ff 75 0c             	pushl  0xc(%ebp)
  800be7:	50                   	push   %eax
  800be8:	ff d2                	call   *%edx
  800bea:	83 c4 10             	add    $0x10,%esp
}
  800bed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bf0:	c9                   	leave  
  800bf1:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800bf2:	a1 04 40 80 00       	mov    0x804004,%eax
  800bf7:	8b 40 48             	mov    0x48(%eax),%eax
  800bfa:	83 ec 04             	sub    $0x4,%esp
  800bfd:	53                   	push   %ebx
  800bfe:	50                   	push   %eax
  800bff:	68 b9 20 80 00       	push   $0x8020b9
  800c04:	e8 58 09 00 00       	call   801561 <cprintf>
		return -E_INVAL;
  800c09:	83 c4 10             	add    $0x10,%esp
  800c0c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c11:	eb da                	jmp    800bed <write+0x55>
		return -E_NOT_SUPP;
  800c13:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800c18:	eb d3                	jmp    800bed <write+0x55>

00800c1a <seek>:

int
seek(int fdnum, off_t offset)
{
  800c1a:	55                   	push   %ebp
  800c1b:	89 e5                	mov    %esp,%ebp
  800c1d:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800c20:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c23:	50                   	push   %eax
  800c24:	ff 75 08             	pushl  0x8(%ebp)
  800c27:	e8 35 fc ff ff       	call   800861 <fd_lookup>
  800c2c:	83 c4 10             	add    $0x10,%esp
  800c2f:	85 c0                	test   %eax,%eax
  800c31:	78 0e                	js     800c41 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  800c33:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c39:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800c3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c41:	c9                   	leave  
  800c42:	c3                   	ret    

00800c43 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800c43:	55                   	push   %ebp
  800c44:	89 e5                	mov    %esp,%ebp
  800c46:	53                   	push   %ebx
  800c47:	83 ec 1c             	sub    $0x1c,%esp
  800c4a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800c4d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800c50:	50                   	push   %eax
  800c51:	53                   	push   %ebx
  800c52:	e8 0a fc ff ff       	call   800861 <fd_lookup>
  800c57:	83 c4 10             	add    $0x10,%esp
  800c5a:	85 c0                	test   %eax,%eax
  800c5c:	78 37                	js     800c95 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800c5e:	83 ec 08             	sub    $0x8,%esp
  800c61:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c64:	50                   	push   %eax
  800c65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c68:	ff 30                	pushl  (%eax)
  800c6a:	e8 42 fc ff ff       	call   8008b1 <dev_lookup>
  800c6f:	83 c4 10             	add    $0x10,%esp
  800c72:	85 c0                	test   %eax,%eax
  800c74:	78 1f                	js     800c95 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800c76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c79:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800c7d:	74 1b                	je     800c9a <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  800c7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c82:	8b 52 18             	mov    0x18(%edx),%edx
  800c85:	85 d2                	test   %edx,%edx
  800c87:	74 32                	je     800cbb <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800c89:	83 ec 08             	sub    $0x8,%esp
  800c8c:	ff 75 0c             	pushl  0xc(%ebp)
  800c8f:	50                   	push   %eax
  800c90:	ff d2                	call   *%edx
  800c92:	83 c4 10             	add    $0x10,%esp
}
  800c95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c98:	c9                   	leave  
  800c99:	c3                   	ret    
			thisenv->env_id, fdnum);
  800c9a:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800c9f:	8b 40 48             	mov    0x48(%eax),%eax
  800ca2:	83 ec 04             	sub    $0x4,%esp
  800ca5:	53                   	push   %ebx
  800ca6:	50                   	push   %eax
  800ca7:	68 7c 20 80 00       	push   $0x80207c
  800cac:	e8 b0 08 00 00       	call   801561 <cprintf>
		return -E_INVAL;
  800cb1:	83 c4 10             	add    $0x10,%esp
  800cb4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800cb9:	eb da                	jmp    800c95 <ftruncate+0x52>
		return -E_NOT_SUPP;
  800cbb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800cc0:	eb d3                	jmp    800c95 <ftruncate+0x52>

00800cc2 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800cc2:	55                   	push   %ebp
  800cc3:	89 e5                	mov    %esp,%ebp
  800cc5:	53                   	push   %ebx
  800cc6:	83 ec 1c             	sub    $0x1c,%esp
  800cc9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800ccc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800ccf:	50                   	push   %eax
  800cd0:	ff 75 08             	pushl  0x8(%ebp)
  800cd3:	e8 89 fb ff ff       	call   800861 <fd_lookup>
  800cd8:	83 c4 10             	add    $0x10,%esp
  800cdb:	85 c0                	test   %eax,%eax
  800cdd:	78 4b                	js     800d2a <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800cdf:	83 ec 08             	sub    $0x8,%esp
  800ce2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ce5:	50                   	push   %eax
  800ce6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ce9:	ff 30                	pushl  (%eax)
  800ceb:	e8 c1 fb ff ff       	call   8008b1 <dev_lookup>
  800cf0:	83 c4 10             	add    $0x10,%esp
  800cf3:	85 c0                	test   %eax,%eax
  800cf5:	78 33                	js     800d2a <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  800cf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cfa:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800cfe:	74 2f                	je     800d2f <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800d00:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800d03:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800d0a:	00 00 00 
	stat->st_isdir = 0;
  800d0d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800d14:	00 00 00 
	stat->st_dev = dev;
  800d17:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800d1d:	83 ec 08             	sub    $0x8,%esp
  800d20:	53                   	push   %ebx
  800d21:	ff 75 f0             	pushl  -0x10(%ebp)
  800d24:	ff 50 14             	call   *0x14(%eax)
  800d27:	83 c4 10             	add    $0x10,%esp
}
  800d2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d2d:	c9                   	leave  
  800d2e:	c3                   	ret    
		return -E_NOT_SUPP;
  800d2f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800d34:	eb f4                	jmp    800d2a <fstat+0x68>

00800d36 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800d36:	55                   	push   %ebp
  800d37:	89 e5                	mov    %esp,%ebp
  800d39:	56                   	push   %esi
  800d3a:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800d3b:	83 ec 08             	sub    $0x8,%esp
  800d3e:	6a 00                	push   $0x0
  800d40:	ff 75 08             	pushl  0x8(%ebp)
  800d43:	e8 bb 01 00 00       	call   800f03 <open>
  800d48:	89 c3                	mov    %eax,%ebx
  800d4a:	83 c4 10             	add    $0x10,%esp
  800d4d:	85 c0                	test   %eax,%eax
  800d4f:	78 1b                	js     800d6c <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  800d51:	83 ec 08             	sub    $0x8,%esp
  800d54:	ff 75 0c             	pushl  0xc(%ebp)
  800d57:	50                   	push   %eax
  800d58:	e8 65 ff ff ff       	call   800cc2 <fstat>
  800d5d:	89 c6                	mov    %eax,%esi
	close(fd);
  800d5f:	89 1c 24             	mov    %ebx,(%esp)
  800d62:	e8 27 fc ff ff       	call   80098e <close>
	return r;
  800d67:	83 c4 10             	add    $0x10,%esp
  800d6a:	89 f3                	mov    %esi,%ebx
}
  800d6c:	89 d8                	mov    %ebx,%eax
  800d6e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d71:	5b                   	pop    %ebx
  800d72:	5e                   	pop    %esi
  800d73:	5d                   	pop    %ebp
  800d74:	c3                   	ret    

00800d75 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800d75:	55                   	push   %ebp
  800d76:	89 e5                	mov    %esp,%ebp
  800d78:	56                   	push   %esi
  800d79:	53                   	push   %ebx
  800d7a:	89 c6                	mov    %eax,%esi
  800d7c:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800d7e:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800d85:	74 27                	je     800dae <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800d87:	6a 07                	push   $0x7
  800d89:	68 00 50 80 00       	push   $0x805000
  800d8e:	56                   	push   %esi
  800d8f:	ff 35 00 40 80 00    	pushl  0x804000
  800d95:	e8 56 0f 00 00       	call   801cf0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800d9a:	83 c4 0c             	add    $0xc,%esp
  800d9d:	6a 00                	push   $0x0
  800d9f:	53                   	push   %ebx
  800da0:	6a 00                	push   $0x0
  800da2:	e8 e0 0e 00 00       	call   801c87 <ipc_recv>
}
  800da7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800daa:	5b                   	pop    %ebx
  800dab:	5e                   	pop    %esi
  800dac:	5d                   	pop    %ebp
  800dad:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800dae:	83 ec 0c             	sub    $0xc,%esp
  800db1:	6a 01                	push   $0x1
  800db3:	e8 90 0f 00 00       	call   801d48 <ipc_find_env>
  800db8:	a3 00 40 80 00       	mov    %eax,0x804000
  800dbd:	83 c4 10             	add    $0x10,%esp
  800dc0:	eb c5                	jmp    800d87 <fsipc+0x12>

00800dc2 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800dc2:	55                   	push   %ebp
  800dc3:	89 e5                	mov    %esp,%ebp
  800dc5:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcb:	8b 40 0c             	mov    0xc(%eax),%eax
  800dce:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800dd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd6:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800ddb:	ba 00 00 00 00       	mov    $0x0,%edx
  800de0:	b8 02 00 00 00       	mov    $0x2,%eax
  800de5:	e8 8b ff ff ff       	call   800d75 <fsipc>
}
  800dea:	c9                   	leave  
  800deb:	c3                   	ret    

00800dec <devfile_flush>:
{
  800dec:	55                   	push   %ebp
  800ded:	89 e5                	mov    %esp,%ebp
  800def:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800df2:	8b 45 08             	mov    0x8(%ebp),%eax
  800df5:	8b 40 0c             	mov    0xc(%eax),%eax
  800df8:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800dfd:	ba 00 00 00 00       	mov    $0x0,%edx
  800e02:	b8 06 00 00 00       	mov    $0x6,%eax
  800e07:	e8 69 ff ff ff       	call   800d75 <fsipc>
}
  800e0c:	c9                   	leave  
  800e0d:	c3                   	ret    

00800e0e <devfile_stat>:
{
  800e0e:	55                   	push   %ebp
  800e0f:	89 e5                	mov    %esp,%ebp
  800e11:	53                   	push   %ebx
  800e12:	83 ec 04             	sub    $0x4,%esp
  800e15:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800e18:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1b:	8b 40 0c             	mov    0xc(%eax),%eax
  800e1e:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800e23:	ba 00 00 00 00       	mov    $0x0,%edx
  800e28:	b8 05 00 00 00       	mov    $0x5,%eax
  800e2d:	e8 43 ff ff ff       	call   800d75 <fsipc>
  800e32:	85 c0                	test   %eax,%eax
  800e34:	78 2c                	js     800e62 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800e36:	83 ec 08             	sub    $0x8,%esp
  800e39:	68 00 50 80 00       	push   $0x805000
  800e3e:	53                   	push   %ebx
  800e3f:	e8 80 f3 ff ff       	call   8001c4 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800e44:	a1 80 50 80 00       	mov    0x805080,%eax
  800e49:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800e4f:	a1 84 50 80 00       	mov    0x805084,%eax
  800e54:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800e5a:	83 c4 10             	add    $0x10,%esp
  800e5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e65:	c9                   	leave  
  800e66:	c3                   	ret    

00800e67 <devfile_write>:
{
  800e67:	55                   	push   %ebp
  800e68:	89 e5                	mov    %esp,%ebp
  800e6a:	83 ec 0c             	sub    $0xc,%esp
	panic("devfile_write not implemented");
  800e6d:	68 e8 20 80 00       	push   $0x8020e8
  800e72:	68 90 00 00 00       	push   $0x90
  800e77:	68 06 21 80 00       	push   $0x802106
  800e7c:	e8 ea 05 00 00       	call   80146b <_panic>

00800e81 <devfile_read>:
{
  800e81:	55                   	push   %ebp
  800e82:	89 e5                	mov    %esp,%ebp
  800e84:	56                   	push   %esi
  800e85:	53                   	push   %ebx
  800e86:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8c:	8b 40 0c             	mov    0xc(%eax),%eax
  800e8f:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800e94:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800e9a:	ba 00 00 00 00       	mov    $0x0,%edx
  800e9f:	b8 03 00 00 00       	mov    $0x3,%eax
  800ea4:	e8 cc fe ff ff       	call   800d75 <fsipc>
  800ea9:	89 c3                	mov    %eax,%ebx
  800eab:	85 c0                	test   %eax,%eax
  800ead:	78 1f                	js     800ece <devfile_read+0x4d>
	assert(r <= n);
  800eaf:	39 f0                	cmp    %esi,%eax
  800eb1:	77 24                	ja     800ed7 <devfile_read+0x56>
	assert(r <= PGSIZE);
  800eb3:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800eb8:	7f 33                	jg     800eed <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800eba:	83 ec 04             	sub    $0x4,%esp
  800ebd:	50                   	push   %eax
  800ebe:	68 00 50 80 00       	push   $0x805000
  800ec3:	ff 75 0c             	pushl  0xc(%ebp)
  800ec6:	e8 87 f4 ff ff       	call   800352 <memmove>
	return r;
  800ecb:	83 c4 10             	add    $0x10,%esp
}
  800ece:	89 d8                	mov    %ebx,%eax
  800ed0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ed3:	5b                   	pop    %ebx
  800ed4:	5e                   	pop    %esi
  800ed5:	5d                   	pop    %ebp
  800ed6:	c3                   	ret    
	assert(r <= n);
  800ed7:	68 11 21 80 00       	push   $0x802111
  800edc:	68 18 21 80 00       	push   $0x802118
  800ee1:	6a 7c                	push   $0x7c
  800ee3:	68 06 21 80 00       	push   $0x802106
  800ee8:	e8 7e 05 00 00       	call   80146b <_panic>
	assert(r <= PGSIZE);
  800eed:	68 2d 21 80 00       	push   $0x80212d
  800ef2:	68 18 21 80 00       	push   $0x802118
  800ef7:	6a 7d                	push   $0x7d
  800ef9:	68 06 21 80 00       	push   $0x802106
  800efe:	e8 68 05 00 00       	call   80146b <_panic>

00800f03 <open>:
{
  800f03:	55                   	push   %ebp
  800f04:	89 e5                	mov    %esp,%ebp
  800f06:	56                   	push   %esi
  800f07:	53                   	push   %ebx
  800f08:	83 ec 1c             	sub    $0x1c,%esp
  800f0b:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800f0e:	56                   	push   %esi
  800f0f:	e8 77 f2 ff ff       	call   80018b <strlen>
  800f14:	83 c4 10             	add    $0x10,%esp
  800f17:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800f1c:	7f 6c                	jg     800f8a <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  800f1e:	83 ec 0c             	sub    $0xc,%esp
  800f21:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f24:	50                   	push   %eax
  800f25:	e8 e5 f8 ff ff       	call   80080f <fd_alloc>
  800f2a:	89 c3                	mov    %eax,%ebx
  800f2c:	83 c4 10             	add    $0x10,%esp
  800f2f:	85 c0                	test   %eax,%eax
  800f31:	78 3c                	js     800f6f <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  800f33:	83 ec 08             	sub    $0x8,%esp
  800f36:	56                   	push   %esi
  800f37:	68 00 50 80 00       	push   $0x805000
  800f3c:	e8 83 f2 ff ff       	call   8001c4 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800f41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f44:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800f49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f4c:	b8 01 00 00 00       	mov    $0x1,%eax
  800f51:	e8 1f fe ff ff       	call   800d75 <fsipc>
  800f56:	89 c3                	mov    %eax,%ebx
  800f58:	83 c4 10             	add    $0x10,%esp
  800f5b:	85 c0                	test   %eax,%eax
  800f5d:	78 19                	js     800f78 <open+0x75>
	return fd2num(fd);
  800f5f:	83 ec 0c             	sub    $0xc,%esp
  800f62:	ff 75 f4             	pushl  -0xc(%ebp)
  800f65:	e8 7e f8 ff ff       	call   8007e8 <fd2num>
  800f6a:	89 c3                	mov    %eax,%ebx
  800f6c:	83 c4 10             	add    $0x10,%esp
}
  800f6f:	89 d8                	mov    %ebx,%eax
  800f71:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f74:	5b                   	pop    %ebx
  800f75:	5e                   	pop    %esi
  800f76:	5d                   	pop    %ebp
  800f77:	c3                   	ret    
		fd_close(fd, 0);
  800f78:	83 ec 08             	sub    $0x8,%esp
  800f7b:	6a 00                	push   $0x0
  800f7d:	ff 75 f4             	pushl  -0xc(%ebp)
  800f80:	e8 82 f9 ff ff       	call   800907 <fd_close>
		return r;
  800f85:	83 c4 10             	add    $0x10,%esp
  800f88:	eb e5                	jmp    800f6f <open+0x6c>
		return -E_BAD_PATH;
  800f8a:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800f8f:	eb de                	jmp    800f6f <open+0x6c>

00800f91 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800f91:	55                   	push   %ebp
  800f92:	89 e5                	mov    %esp,%ebp
  800f94:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800f97:	ba 00 00 00 00       	mov    $0x0,%edx
  800f9c:	b8 08 00 00 00       	mov    $0x8,%eax
  800fa1:	e8 cf fd ff ff       	call   800d75 <fsipc>
}
  800fa6:	c9                   	leave  
  800fa7:	c3                   	ret    

00800fa8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800fa8:	55                   	push   %ebp
  800fa9:	89 e5                	mov    %esp,%ebp
  800fab:	56                   	push   %esi
  800fac:	53                   	push   %ebx
  800fad:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800fb0:	83 ec 0c             	sub    $0xc,%esp
  800fb3:	ff 75 08             	pushl  0x8(%ebp)
  800fb6:	e8 3d f8 ff ff       	call   8007f8 <fd2data>
  800fbb:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800fbd:	83 c4 08             	add    $0x8,%esp
  800fc0:	68 39 21 80 00       	push   $0x802139
  800fc5:	53                   	push   %ebx
  800fc6:	e8 f9 f1 ff ff       	call   8001c4 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800fcb:	8b 46 04             	mov    0x4(%esi),%eax
  800fce:	2b 06                	sub    (%esi),%eax
  800fd0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800fd6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800fdd:	00 00 00 
	stat->st_dev = &devpipe;
  800fe0:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800fe7:	30 80 00 
	return 0;
}
  800fea:	b8 00 00 00 00       	mov    $0x0,%eax
  800fef:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ff2:	5b                   	pop    %ebx
  800ff3:	5e                   	pop    %esi
  800ff4:	5d                   	pop    %ebp
  800ff5:	c3                   	ret    

00800ff6 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800ff6:	55                   	push   %ebp
  800ff7:	89 e5                	mov    %esp,%ebp
  800ff9:	53                   	push   %ebx
  800ffa:	83 ec 0c             	sub    $0xc,%esp
  800ffd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801000:	53                   	push   %ebx
  801001:	6a 00                	push   $0x0
  801003:	e8 33 f6 ff ff       	call   80063b <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801008:	89 1c 24             	mov    %ebx,(%esp)
  80100b:	e8 e8 f7 ff ff       	call   8007f8 <fd2data>
  801010:	83 c4 08             	add    $0x8,%esp
  801013:	50                   	push   %eax
  801014:	6a 00                	push   $0x0
  801016:	e8 20 f6 ff ff       	call   80063b <sys_page_unmap>
}
  80101b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80101e:	c9                   	leave  
  80101f:	c3                   	ret    

00801020 <_pipeisclosed>:
{
  801020:	55                   	push   %ebp
  801021:	89 e5                	mov    %esp,%ebp
  801023:	57                   	push   %edi
  801024:	56                   	push   %esi
  801025:	53                   	push   %ebx
  801026:	83 ec 1c             	sub    $0x1c,%esp
  801029:	89 c7                	mov    %eax,%edi
  80102b:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80102d:	a1 04 40 80 00       	mov    0x804004,%eax
  801032:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801035:	83 ec 0c             	sub    $0xc,%esp
  801038:	57                   	push   %edi
  801039:	e8 45 0d 00 00       	call   801d83 <pageref>
  80103e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801041:	89 34 24             	mov    %esi,(%esp)
  801044:	e8 3a 0d 00 00       	call   801d83 <pageref>
		nn = thisenv->env_runs;
  801049:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80104f:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801052:	83 c4 10             	add    $0x10,%esp
  801055:	39 cb                	cmp    %ecx,%ebx
  801057:	74 1b                	je     801074 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801059:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80105c:	75 cf                	jne    80102d <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80105e:	8b 42 58             	mov    0x58(%edx),%eax
  801061:	6a 01                	push   $0x1
  801063:	50                   	push   %eax
  801064:	53                   	push   %ebx
  801065:	68 40 21 80 00       	push   $0x802140
  80106a:	e8 f2 04 00 00       	call   801561 <cprintf>
  80106f:	83 c4 10             	add    $0x10,%esp
  801072:	eb b9                	jmp    80102d <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801074:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801077:	0f 94 c0             	sete   %al
  80107a:	0f b6 c0             	movzbl %al,%eax
}
  80107d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801080:	5b                   	pop    %ebx
  801081:	5e                   	pop    %esi
  801082:	5f                   	pop    %edi
  801083:	5d                   	pop    %ebp
  801084:	c3                   	ret    

00801085 <devpipe_write>:
{
  801085:	55                   	push   %ebp
  801086:	89 e5                	mov    %esp,%ebp
  801088:	57                   	push   %edi
  801089:	56                   	push   %esi
  80108a:	53                   	push   %ebx
  80108b:	83 ec 28             	sub    $0x28,%esp
  80108e:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801091:	56                   	push   %esi
  801092:	e8 61 f7 ff ff       	call   8007f8 <fd2data>
  801097:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801099:	83 c4 10             	add    $0x10,%esp
  80109c:	bf 00 00 00 00       	mov    $0x0,%edi
  8010a1:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8010a4:	74 4f                	je     8010f5 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8010a6:	8b 43 04             	mov    0x4(%ebx),%eax
  8010a9:	8b 0b                	mov    (%ebx),%ecx
  8010ab:	8d 51 20             	lea    0x20(%ecx),%edx
  8010ae:	39 d0                	cmp    %edx,%eax
  8010b0:	72 14                	jb     8010c6 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8010b2:	89 da                	mov    %ebx,%edx
  8010b4:	89 f0                	mov    %esi,%eax
  8010b6:	e8 65 ff ff ff       	call   801020 <_pipeisclosed>
  8010bb:	85 c0                	test   %eax,%eax
  8010bd:	75 3b                	jne    8010fa <devpipe_write+0x75>
			sys_yield();
  8010bf:	e8 d3 f4 ff ff       	call   800597 <sys_yield>
  8010c4:	eb e0                	jmp    8010a6 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8010c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010c9:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8010cd:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8010d0:	89 c2                	mov    %eax,%edx
  8010d2:	c1 fa 1f             	sar    $0x1f,%edx
  8010d5:	89 d1                	mov    %edx,%ecx
  8010d7:	c1 e9 1b             	shr    $0x1b,%ecx
  8010da:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8010dd:	83 e2 1f             	and    $0x1f,%edx
  8010e0:	29 ca                	sub    %ecx,%edx
  8010e2:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8010e6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8010ea:	83 c0 01             	add    $0x1,%eax
  8010ed:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8010f0:	83 c7 01             	add    $0x1,%edi
  8010f3:	eb ac                	jmp    8010a1 <devpipe_write+0x1c>
	return i;
  8010f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f8:	eb 05                	jmp    8010ff <devpipe_write+0x7a>
				return 0;
  8010fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801102:	5b                   	pop    %ebx
  801103:	5e                   	pop    %esi
  801104:	5f                   	pop    %edi
  801105:	5d                   	pop    %ebp
  801106:	c3                   	ret    

00801107 <devpipe_read>:
{
  801107:	55                   	push   %ebp
  801108:	89 e5                	mov    %esp,%ebp
  80110a:	57                   	push   %edi
  80110b:	56                   	push   %esi
  80110c:	53                   	push   %ebx
  80110d:	83 ec 18             	sub    $0x18,%esp
  801110:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801113:	57                   	push   %edi
  801114:	e8 df f6 ff ff       	call   8007f8 <fd2data>
  801119:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80111b:	83 c4 10             	add    $0x10,%esp
  80111e:	be 00 00 00 00       	mov    $0x0,%esi
  801123:	3b 75 10             	cmp    0x10(%ebp),%esi
  801126:	75 14                	jne    80113c <devpipe_read+0x35>
	return i;
  801128:	8b 45 10             	mov    0x10(%ebp),%eax
  80112b:	eb 02                	jmp    80112f <devpipe_read+0x28>
				return i;
  80112d:	89 f0                	mov    %esi,%eax
}
  80112f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801132:	5b                   	pop    %ebx
  801133:	5e                   	pop    %esi
  801134:	5f                   	pop    %edi
  801135:	5d                   	pop    %ebp
  801136:	c3                   	ret    
			sys_yield();
  801137:	e8 5b f4 ff ff       	call   800597 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80113c:	8b 03                	mov    (%ebx),%eax
  80113e:	3b 43 04             	cmp    0x4(%ebx),%eax
  801141:	75 18                	jne    80115b <devpipe_read+0x54>
			if (i > 0)
  801143:	85 f6                	test   %esi,%esi
  801145:	75 e6                	jne    80112d <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801147:	89 da                	mov    %ebx,%edx
  801149:	89 f8                	mov    %edi,%eax
  80114b:	e8 d0 fe ff ff       	call   801020 <_pipeisclosed>
  801150:	85 c0                	test   %eax,%eax
  801152:	74 e3                	je     801137 <devpipe_read+0x30>
				return 0;
  801154:	b8 00 00 00 00       	mov    $0x0,%eax
  801159:	eb d4                	jmp    80112f <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80115b:	99                   	cltd   
  80115c:	c1 ea 1b             	shr    $0x1b,%edx
  80115f:	01 d0                	add    %edx,%eax
  801161:	83 e0 1f             	and    $0x1f,%eax
  801164:	29 d0                	sub    %edx,%eax
  801166:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80116b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80116e:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801171:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801174:	83 c6 01             	add    $0x1,%esi
  801177:	eb aa                	jmp    801123 <devpipe_read+0x1c>

00801179 <pipe>:
{
  801179:	55                   	push   %ebp
  80117a:	89 e5                	mov    %esp,%ebp
  80117c:	56                   	push   %esi
  80117d:	53                   	push   %ebx
  80117e:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801181:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801184:	50                   	push   %eax
  801185:	e8 85 f6 ff ff       	call   80080f <fd_alloc>
  80118a:	89 c3                	mov    %eax,%ebx
  80118c:	83 c4 10             	add    $0x10,%esp
  80118f:	85 c0                	test   %eax,%eax
  801191:	0f 88 23 01 00 00    	js     8012ba <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801197:	83 ec 04             	sub    $0x4,%esp
  80119a:	68 07 04 00 00       	push   $0x407
  80119f:	ff 75 f4             	pushl  -0xc(%ebp)
  8011a2:	6a 00                	push   $0x0
  8011a4:	e8 0d f4 ff ff       	call   8005b6 <sys_page_alloc>
  8011a9:	89 c3                	mov    %eax,%ebx
  8011ab:	83 c4 10             	add    $0x10,%esp
  8011ae:	85 c0                	test   %eax,%eax
  8011b0:	0f 88 04 01 00 00    	js     8012ba <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8011b6:	83 ec 0c             	sub    $0xc,%esp
  8011b9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011bc:	50                   	push   %eax
  8011bd:	e8 4d f6 ff ff       	call   80080f <fd_alloc>
  8011c2:	89 c3                	mov    %eax,%ebx
  8011c4:	83 c4 10             	add    $0x10,%esp
  8011c7:	85 c0                	test   %eax,%eax
  8011c9:	0f 88 db 00 00 00    	js     8012aa <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8011cf:	83 ec 04             	sub    $0x4,%esp
  8011d2:	68 07 04 00 00       	push   $0x407
  8011d7:	ff 75 f0             	pushl  -0x10(%ebp)
  8011da:	6a 00                	push   $0x0
  8011dc:	e8 d5 f3 ff ff       	call   8005b6 <sys_page_alloc>
  8011e1:	89 c3                	mov    %eax,%ebx
  8011e3:	83 c4 10             	add    $0x10,%esp
  8011e6:	85 c0                	test   %eax,%eax
  8011e8:	0f 88 bc 00 00 00    	js     8012aa <pipe+0x131>
	va = fd2data(fd0);
  8011ee:	83 ec 0c             	sub    $0xc,%esp
  8011f1:	ff 75 f4             	pushl  -0xc(%ebp)
  8011f4:	e8 ff f5 ff ff       	call   8007f8 <fd2data>
  8011f9:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8011fb:	83 c4 0c             	add    $0xc,%esp
  8011fe:	68 07 04 00 00       	push   $0x407
  801203:	50                   	push   %eax
  801204:	6a 00                	push   $0x0
  801206:	e8 ab f3 ff ff       	call   8005b6 <sys_page_alloc>
  80120b:	89 c3                	mov    %eax,%ebx
  80120d:	83 c4 10             	add    $0x10,%esp
  801210:	85 c0                	test   %eax,%eax
  801212:	0f 88 82 00 00 00    	js     80129a <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801218:	83 ec 0c             	sub    $0xc,%esp
  80121b:	ff 75 f0             	pushl  -0x10(%ebp)
  80121e:	e8 d5 f5 ff ff       	call   8007f8 <fd2data>
  801223:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80122a:	50                   	push   %eax
  80122b:	6a 00                	push   $0x0
  80122d:	56                   	push   %esi
  80122e:	6a 00                	push   $0x0
  801230:	e8 c4 f3 ff ff       	call   8005f9 <sys_page_map>
  801235:	89 c3                	mov    %eax,%ebx
  801237:	83 c4 20             	add    $0x20,%esp
  80123a:	85 c0                	test   %eax,%eax
  80123c:	78 4e                	js     80128c <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  80123e:	a1 20 30 80 00       	mov    0x803020,%eax
  801243:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801246:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801248:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80124b:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801252:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801255:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801257:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80125a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801261:	83 ec 0c             	sub    $0xc,%esp
  801264:	ff 75 f4             	pushl  -0xc(%ebp)
  801267:	e8 7c f5 ff ff       	call   8007e8 <fd2num>
  80126c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80126f:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801271:	83 c4 04             	add    $0x4,%esp
  801274:	ff 75 f0             	pushl  -0x10(%ebp)
  801277:	e8 6c f5 ff ff       	call   8007e8 <fd2num>
  80127c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80127f:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801282:	83 c4 10             	add    $0x10,%esp
  801285:	bb 00 00 00 00       	mov    $0x0,%ebx
  80128a:	eb 2e                	jmp    8012ba <pipe+0x141>
	sys_page_unmap(0, va);
  80128c:	83 ec 08             	sub    $0x8,%esp
  80128f:	56                   	push   %esi
  801290:	6a 00                	push   $0x0
  801292:	e8 a4 f3 ff ff       	call   80063b <sys_page_unmap>
  801297:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80129a:	83 ec 08             	sub    $0x8,%esp
  80129d:	ff 75 f0             	pushl  -0x10(%ebp)
  8012a0:	6a 00                	push   $0x0
  8012a2:	e8 94 f3 ff ff       	call   80063b <sys_page_unmap>
  8012a7:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8012aa:	83 ec 08             	sub    $0x8,%esp
  8012ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8012b0:	6a 00                	push   $0x0
  8012b2:	e8 84 f3 ff ff       	call   80063b <sys_page_unmap>
  8012b7:	83 c4 10             	add    $0x10,%esp
}
  8012ba:	89 d8                	mov    %ebx,%eax
  8012bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012bf:	5b                   	pop    %ebx
  8012c0:	5e                   	pop    %esi
  8012c1:	5d                   	pop    %ebp
  8012c2:	c3                   	ret    

008012c3 <pipeisclosed>:
{
  8012c3:	55                   	push   %ebp
  8012c4:	89 e5                	mov    %esp,%ebp
  8012c6:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012cc:	50                   	push   %eax
  8012cd:	ff 75 08             	pushl  0x8(%ebp)
  8012d0:	e8 8c f5 ff ff       	call   800861 <fd_lookup>
  8012d5:	83 c4 10             	add    $0x10,%esp
  8012d8:	85 c0                	test   %eax,%eax
  8012da:	78 18                	js     8012f4 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8012dc:	83 ec 0c             	sub    $0xc,%esp
  8012df:	ff 75 f4             	pushl  -0xc(%ebp)
  8012e2:	e8 11 f5 ff ff       	call   8007f8 <fd2data>
	return _pipeisclosed(fd, p);
  8012e7:	89 c2                	mov    %eax,%edx
  8012e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012ec:	e8 2f fd ff ff       	call   801020 <_pipeisclosed>
  8012f1:	83 c4 10             	add    $0x10,%esp
}
  8012f4:	c9                   	leave  
  8012f5:	c3                   	ret    

008012f6 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8012f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8012fb:	c3                   	ret    

008012fc <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8012fc:	55                   	push   %ebp
  8012fd:	89 e5                	mov    %esp,%ebp
  8012ff:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801302:	68 58 21 80 00       	push   $0x802158
  801307:	ff 75 0c             	pushl  0xc(%ebp)
  80130a:	e8 b5 ee ff ff       	call   8001c4 <strcpy>
	return 0;
}
  80130f:	b8 00 00 00 00       	mov    $0x0,%eax
  801314:	c9                   	leave  
  801315:	c3                   	ret    

00801316 <devcons_write>:
{
  801316:	55                   	push   %ebp
  801317:	89 e5                	mov    %esp,%ebp
  801319:	57                   	push   %edi
  80131a:	56                   	push   %esi
  80131b:	53                   	push   %ebx
  80131c:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801322:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801327:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80132d:	3b 75 10             	cmp    0x10(%ebp),%esi
  801330:	73 31                	jae    801363 <devcons_write+0x4d>
		m = n - tot;
  801332:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801335:	29 f3                	sub    %esi,%ebx
  801337:	83 fb 7f             	cmp    $0x7f,%ebx
  80133a:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80133f:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801342:	83 ec 04             	sub    $0x4,%esp
  801345:	53                   	push   %ebx
  801346:	89 f0                	mov    %esi,%eax
  801348:	03 45 0c             	add    0xc(%ebp),%eax
  80134b:	50                   	push   %eax
  80134c:	57                   	push   %edi
  80134d:	e8 00 f0 ff ff       	call   800352 <memmove>
		sys_cputs(buf, m);
  801352:	83 c4 08             	add    $0x8,%esp
  801355:	53                   	push   %ebx
  801356:	57                   	push   %edi
  801357:	e8 9e f1 ff ff       	call   8004fa <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80135c:	01 de                	add    %ebx,%esi
  80135e:	83 c4 10             	add    $0x10,%esp
  801361:	eb ca                	jmp    80132d <devcons_write+0x17>
}
  801363:	89 f0                	mov    %esi,%eax
  801365:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801368:	5b                   	pop    %ebx
  801369:	5e                   	pop    %esi
  80136a:	5f                   	pop    %edi
  80136b:	5d                   	pop    %ebp
  80136c:	c3                   	ret    

0080136d <devcons_read>:
{
  80136d:	55                   	push   %ebp
  80136e:	89 e5                	mov    %esp,%ebp
  801370:	83 ec 08             	sub    $0x8,%esp
  801373:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801378:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80137c:	74 21                	je     80139f <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80137e:	e8 95 f1 ff ff       	call   800518 <sys_cgetc>
  801383:	85 c0                	test   %eax,%eax
  801385:	75 07                	jne    80138e <devcons_read+0x21>
		sys_yield();
  801387:	e8 0b f2 ff ff       	call   800597 <sys_yield>
  80138c:	eb f0                	jmp    80137e <devcons_read+0x11>
	if (c < 0)
  80138e:	78 0f                	js     80139f <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  801390:	83 f8 04             	cmp    $0x4,%eax
  801393:	74 0c                	je     8013a1 <devcons_read+0x34>
	*(char*)vbuf = c;
  801395:	8b 55 0c             	mov    0xc(%ebp),%edx
  801398:	88 02                	mov    %al,(%edx)
	return 1;
  80139a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80139f:	c9                   	leave  
  8013a0:	c3                   	ret    
		return 0;
  8013a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a6:	eb f7                	jmp    80139f <devcons_read+0x32>

008013a8 <cputchar>:
{
  8013a8:	55                   	push   %ebp
  8013a9:	89 e5                	mov    %esp,%ebp
  8013ab:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8013ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b1:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8013b4:	6a 01                	push   $0x1
  8013b6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8013b9:	50                   	push   %eax
  8013ba:	e8 3b f1 ff ff       	call   8004fa <sys_cputs>
}
  8013bf:	83 c4 10             	add    $0x10,%esp
  8013c2:	c9                   	leave  
  8013c3:	c3                   	ret    

008013c4 <getchar>:
{
  8013c4:	55                   	push   %ebp
  8013c5:	89 e5                	mov    %esp,%ebp
  8013c7:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8013ca:	6a 01                	push   $0x1
  8013cc:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8013cf:	50                   	push   %eax
  8013d0:	6a 00                	push   $0x0
  8013d2:	e8 f5 f6 ff ff       	call   800acc <read>
	if (r < 0)
  8013d7:	83 c4 10             	add    $0x10,%esp
  8013da:	85 c0                	test   %eax,%eax
  8013dc:	78 06                	js     8013e4 <getchar+0x20>
	if (r < 1)
  8013de:	74 06                	je     8013e6 <getchar+0x22>
	return c;
  8013e0:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8013e4:	c9                   	leave  
  8013e5:	c3                   	ret    
		return -E_EOF;
  8013e6:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8013eb:	eb f7                	jmp    8013e4 <getchar+0x20>

008013ed <iscons>:
{
  8013ed:	55                   	push   %ebp
  8013ee:	89 e5                	mov    %esp,%ebp
  8013f0:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013f3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013f6:	50                   	push   %eax
  8013f7:	ff 75 08             	pushl  0x8(%ebp)
  8013fa:	e8 62 f4 ff ff       	call   800861 <fd_lookup>
  8013ff:	83 c4 10             	add    $0x10,%esp
  801402:	85 c0                	test   %eax,%eax
  801404:	78 11                	js     801417 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801406:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801409:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80140f:	39 10                	cmp    %edx,(%eax)
  801411:	0f 94 c0             	sete   %al
  801414:	0f b6 c0             	movzbl %al,%eax
}
  801417:	c9                   	leave  
  801418:	c3                   	ret    

00801419 <opencons>:
{
  801419:	55                   	push   %ebp
  80141a:	89 e5                	mov    %esp,%ebp
  80141c:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80141f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801422:	50                   	push   %eax
  801423:	e8 e7 f3 ff ff       	call   80080f <fd_alloc>
  801428:	83 c4 10             	add    $0x10,%esp
  80142b:	85 c0                	test   %eax,%eax
  80142d:	78 3a                	js     801469 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80142f:	83 ec 04             	sub    $0x4,%esp
  801432:	68 07 04 00 00       	push   $0x407
  801437:	ff 75 f4             	pushl  -0xc(%ebp)
  80143a:	6a 00                	push   $0x0
  80143c:	e8 75 f1 ff ff       	call   8005b6 <sys_page_alloc>
  801441:	83 c4 10             	add    $0x10,%esp
  801444:	85 c0                	test   %eax,%eax
  801446:	78 21                	js     801469 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801448:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80144b:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801451:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801456:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80145d:	83 ec 0c             	sub    $0xc,%esp
  801460:	50                   	push   %eax
  801461:	e8 82 f3 ff ff       	call   8007e8 <fd2num>
  801466:	83 c4 10             	add    $0x10,%esp
}
  801469:	c9                   	leave  
  80146a:	c3                   	ret    

0080146b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80146b:	55                   	push   %ebp
  80146c:	89 e5                	mov    %esp,%ebp
  80146e:	56                   	push   %esi
  80146f:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  801470:	a1 04 40 80 00       	mov    0x804004,%eax
  801475:	8b 40 48             	mov    0x48(%eax),%eax
  801478:	83 ec 04             	sub    $0x4,%esp
  80147b:	68 94 21 80 00       	push   $0x802194
  801480:	50                   	push   %eax
  801481:	68 64 21 80 00       	push   $0x802164
  801486:	e8 d6 00 00 00       	call   801561 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80148b:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80148e:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801494:	e8 df f0 ff ff       	call   800578 <sys_getenvid>
  801499:	83 c4 04             	add    $0x4,%esp
  80149c:	ff 75 0c             	pushl  0xc(%ebp)
  80149f:	ff 75 08             	pushl  0x8(%ebp)
  8014a2:	56                   	push   %esi
  8014a3:	50                   	push   %eax
  8014a4:	68 70 21 80 00       	push   $0x802170
  8014a9:	e8 b3 00 00 00       	call   801561 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8014ae:	83 c4 18             	add    $0x18,%esp
  8014b1:	53                   	push   %ebx
  8014b2:	ff 75 10             	pushl  0x10(%ebp)
  8014b5:	e8 56 00 00 00       	call   801510 <vcprintf>
	cprintf("\n");
  8014ba:	c7 04 24 33 25 80 00 	movl   $0x802533,(%esp)
  8014c1:	e8 9b 00 00 00       	call   801561 <cprintf>
  8014c6:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8014c9:	cc                   	int3   
  8014ca:	eb fd                	jmp    8014c9 <_panic+0x5e>

008014cc <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8014cc:	55                   	push   %ebp
  8014cd:	89 e5                	mov    %esp,%ebp
  8014cf:	53                   	push   %ebx
  8014d0:	83 ec 04             	sub    $0x4,%esp
  8014d3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8014d6:	8b 13                	mov    (%ebx),%edx
  8014d8:	8d 42 01             	lea    0x1(%edx),%eax
  8014db:	89 03                	mov    %eax,(%ebx)
  8014dd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014e0:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8014e4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8014e9:	74 09                	je     8014f4 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8014eb:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8014ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014f2:	c9                   	leave  
  8014f3:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8014f4:	83 ec 08             	sub    $0x8,%esp
  8014f7:	68 ff 00 00 00       	push   $0xff
  8014fc:	8d 43 08             	lea    0x8(%ebx),%eax
  8014ff:	50                   	push   %eax
  801500:	e8 f5 ef ff ff       	call   8004fa <sys_cputs>
		b->idx = 0;
  801505:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80150b:	83 c4 10             	add    $0x10,%esp
  80150e:	eb db                	jmp    8014eb <putch+0x1f>

00801510 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801510:	55                   	push   %ebp
  801511:	89 e5                	mov    %esp,%ebp
  801513:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801519:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801520:	00 00 00 
	b.cnt = 0;
  801523:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80152a:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80152d:	ff 75 0c             	pushl  0xc(%ebp)
  801530:	ff 75 08             	pushl  0x8(%ebp)
  801533:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801539:	50                   	push   %eax
  80153a:	68 cc 14 80 00       	push   $0x8014cc
  80153f:	e8 4a 01 00 00       	call   80168e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801544:	83 c4 08             	add    $0x8,%esp
  801547:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80154d:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801553:	50                   	push   %eax
  801554:	e8 a1 ef ff ff       	call   8004fa <sys_cputs>

	return b.cnt;
}
  801559:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80155f:	c9                   	leave  
  801560:	c3                   	ret    

00801561 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801561:	55                   	push   %ebp
  801562:	89 e5                	mov    %esp,%ebp
  801564:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801567:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80156a:	50                   	push   %eax
  80156b:	ff 75 08             	pushl  0x8(%ebp)
  80156e:	e8 9d ff ff ff       	call   801510 <vcprintf>
	va_end(ap);

	return cnt;
}
  801573:	c9                   	leave  
  801574:	c3                   	ret    

00801575 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801575:	55                   	push   %ebp
  801576:	89 e5                	mov    %esp,%ebp
  801578:	57                   	push   %edi
  801579:	56                   	push   %esi
  80157a:	53                   	push   %ebx
  80157b:	83 ec 1c             	sub    $0x1c,%esp
  80157e:	89 c6                	mov    %eax,%esi
  801580:	89 d7                	mov    %edx,%edi
  801582:	8b 45 08             	mov    0x8(%ebp),%eax
  801585:	8b 55 0c             	mov    0xc(%ebp),%edx
  801588:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80158b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80158e:	8b 45 10             	mov    0x10(%ebp),%eax
  801591:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  801594:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  801598:	74 2c                	je     8015c6 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80159a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80159d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8015a4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8015a7:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8015aa:	39 c2                	cmp    %eax,%edx
  8015ac:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8015af:	73 43                	jae    8015f4 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8015b1:	83 eb 01             	sub    $0x1,%ebx
  8015b4:	85 db                	test   %ebx,%ebx
  8015b6:	7e 6c                	jle    801624 <printnum+0xaf>
				putch(padc, putdat);
  8015b8:	83 ec 08             	sub    $0x8,%esp
  8015bb:	57                   	push   %edi
  8015bc:	ff 75 18             	pushl  0x18(%ebp)
  8015bf:	ff d6                	call   *%esi
  8015c1:	83 c4 10             	add    $0x10,%esp
  8015c4:	eb eb                	jmp    8015b1 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8015c6:	83 ec 0c             	sub    $0xc,%esp
  8015c9:	6a 20                	push   $0x20
  8015cb:	6a 00                	push   $0x0
  8015cd:	50                   	push   %eax
  8015ce:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015d1:	ff 75 e0             	pushl  -0x20(%ebp)
  8015d4:	89 fa                	mov    %edi,%edx
  8015d6:	89 f0                	mov    %esi,%eax
  8015d8:	e8 98 ff ff ff       	call   801575 <printnum>
		while (--width > 0)
  8015dd:	83 c4 20             	add    $0x20,%esp
  8015e0:	83 eb 01             	sub    $0x1,%ebx
  8015e3:	85 db                	test   %ebx,%ebx
  8015e5:	7e 65                	jle    80164c <printnum+0xd7>
			putch(padc, putdat);
  8015e7:	83 ec 08             	sub    $0x8,%esp
  8015ea:	57                   	push   %edi
  8015eb:	6a 20                	push   $0x20
  8015ed:	ff d6                	call   *%esi
  8015ef:	83 c4 10             	add    $0x10,%esp
  8015f2:	eb ec                	jmp    8015e0 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8015f4:	83 ec 0c             	sub    $0xc,%esp
  8015f7:	ff 75 18             	pushl  0x18(%ebp)
  8015fa:	83 eb 01             	sub    $0x1,%ebx
  8015fd:	53                   	push   %ebx
  8015fe:	50                   	push   %eax
  8015ff:	83 ec 08             	sub    $0x8,%esp
  801602:	ff 75 dc             	pushl  -0x24(%ebp)
  801605:	ff 75 d8             	pushl  -0x28(%ebp)
  801608:	ff 75 e4             	pushl  -0x1c(%ebp)
  80160b:	ff 75 e0             	pushl  -0x20(%ebp)
  80160e:	e8 ad 07 00 00       	call   801dc0 <__udivdi3>
  801613:	83 c4 18             	add    $0x18,%esp
  801616:	52                   	push   %edx
  801617:	50                   	push   %eax
  801618:	89 fa                	mov    %edi,%edx
  80161a:	89 f0                	mov    %esi,%eax
  80161c:	e8 54 ff ff ff       	call   801575 <printnum>
  801621:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  801624:	83 ec 08             	sub    $0x8,%esp
  801627:	57                   	push   %edi
  801628:	83 ec 04             	sub    $0x4,%esp
  80162b:	ff 75 dc             	pushl  -0x24(%ebp)
  80162e:	ff 75 d8             	pushl  -0x28(%ebp)
  801631:	ff 75 e4             	pushl  -0x1c(%ebp)
  801634:	ff 75 e0             	pushl  -0x20(%ebp)
  801637:	e8 94 08 00 00       	call   801ed0 <__umoddi3>
  80163c:	83 c4 14             	add    $0x14,%esp
  80163f:	0f be 80 9b 21 80 00 	movsbl 0x80219b(%eax),%eax
  801646:	50                   	push   %eax
  801647:	ff d6                	call   *%esi
  801649:	83 c4 10             	add    $0x10,%esp
	}
}
  80164c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80164f:	5b                   	pop    %ebx
  801650:	5e                   	pop    %esi
  801651:	5f                   	pop    %edi
  801652:	5d                   	pop    %ebp
  801653:	c3                   	ret    

00801654 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801654:	55                   	push   %ebp
  801655:	89 e5                	mov    %esp,%ebp
  801657:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80165a:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80165e:	8b 10                	mov    (%eax),%edx
  801660:	3b 50 04             	cmp    0x4(%eax),%edx
  801663:	73 0a                	jae    80166f <sprintputch+0x1b>
		*b->buf++ = ch;
  801665:	8d 4a 01             	lea    0x1(%edx),%ecx
  801668:	89 08                	mov    %ecx,(%eax)
  80166a:	8b 45 08             	mov    0x8(%ebp),%eax
  80166d:	88 02                	mov    %al,(%edx)
}
  80166f:	5d                   	pop    %ebp
  801670:	c3                   	ret    

00801671 <printfmt>:
{
  801671:	55                   	push   %ebp
  801672:	89 e5                	mov    %esp,%ebp
  801674:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  801677:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80167a:	50                   	push   %eax
  80167b:	ff 75 10             	pushl  0x10(%ebp)
  80167e:	ff 75 0c             	pushl  0xc(%ebp)
  801681:	ff 75 08             	pushl  0x8(%ebp)
  801684:	e8 05 00 00 00       	call   80168e <vprintfmt>
}
  801689:	83 c4 10             	add    $0x10,%esp
  80168c:	c9                   	leave  
  80168d:	c3                   	ret    

0080168e <vprintfmt>:
{
  80168e:	55                   	push   %ebp
  80168f:	89 e5                	mov    %esp,%ebp
  801691:	57                   	push   %edi
  801692:	56                   	push   %esi
  801693:	53                   	push   %ebx
  801694:	83 ec 3c             	sub    $0x3c,%esp
  801697:	8b 75 08             	mov    0x8(%ebp),%esi
  80169a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80169d:	8b 7d 10             	mov    0x10(%ebp),%edi
  8016a0:	e9 32 04 00 00       	jmp    801ad7 <vprintfmt+0x449>
		padc = ' ';
  8016a5:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8016a9:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8016b0:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8016b7:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8016be:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8016c5:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8016cc:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8016d1:	8d 47 01             	lea    0x1(%edi),%eax
  8016d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8016d7:	0f b6 17             	movzbl (%edi),%edx
  8016da:	8d 42 dd             	lea    -0x23(%edx),%eax
  8016dd:	3c 55                	cmp    $0x55,%al
  8016df:	0f 87 12 05 00 00    	ja     801bf7 <vprintfmt+0x569>
  8016e5:	0f b6 c0             	movzbl %al,%eax
  8016e8:	ff 24 85 80 23 80 00 	jmp    *0x802380(,%eax,4)
  8016ef:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8016f2:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8016f6:	eb d9                	jmp    8016d1 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8016f8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8016fb:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8016ff:	eb d0                	jmp    8016d1 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  801701:	0f b6 d2             	movzbl %dl,%edx
  801704:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801707:	b8 00 00 00 00       	mov    $0x0,%eax
  80170c:	89 75 08             	mov    %esi,0x8(%ebp)
  80170f:	eb 03                	jmp    801714 <vprintfmt+0x86>
  801711:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801714:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801717:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80171b:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80171e:	8d 72 d0             	lea    -0x30(%edx),%esi
  801721:	83 fe 09             	cmp    $0x9,%esi
  801724:	76 eb                	jbe    801711 <vprintfmt+0x83>
  801726:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801729:	8b 75 08             	mov    0x8(%ebp),%esi
  80172c:	eb 14                	jmp    801742 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  80172e:	8b 45 14             	mov    0x14(%ebp),%eax
  801731:	8b 00                	mov    (%eax),%eax
  801733:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801736:	8b 45 14             	mov    0x14(%ebp),%eax
  801739:	8d 40 04             	lea    0x4(%eax),%eax
  80173c:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80173f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801742:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801746:	79 89                	jns    8016d1 <vprintfmt+0x43>
				width = precision, precision = -1;
  801748:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80174b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80174e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  801755:	e9 77 ff ff ff       	jmp    8016d1 <vprintfmt+0x43>
  80175a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80175d:	85 c0                	test   %eax,%eax
  80175f:	0f 48 c1             	cmovs  %ecx,%eax
  801762:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801765:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801768:	e9 64 ff ff ff       	jmp    8016d1 <vprintfmt+0x43>
  80176d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  801770:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  801777:	e9 55 ff ff ff       	jmp    8016d1 <vprintfmt+0x43>
			lflag++;
  80177c:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801780:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801783:	e9 49 ff ff ff       	jmp    8016d1 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  801788:	8b 45 14             	mov    0x14(%ebp),%eax
  80178b:	8d 78 04             	lea    0x4(%eax),%edi
  80178e:	83 ec 08             	sub    $0x8,%esp
  801791:	53                   	push   %ebx
  801792:	ff 30                	pushl  (%eax)
  801794:	ff d6                	call   *%esi
			break;
  801796:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  801799:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80179c:	e9 33 03 00 00       	jmp    801ad4 <vprintfmt+0x446>
			err = va_arg(ap, int);
  8017a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8017a4:	8d 78 04             	lea    0x4(%eax),%edi
  8017a7:	8b 00                	mov    (%eax),%eax
  8017a9:	99                   	cltd   
  8017aa:	31 d0                	xor    %edx,%eax
  8017ac:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8017ae:	83 f8 0f             	cmp    $0xf,%eax
  8017b1:	7f 23                	jg     8017d6 <vprintfmt+0x148>
  8017b3:	8b 14 85 e0 24 80 00 	mov    0x8024e0(,%eax,4),%edx
  8017ba:	85 d2                	test   %edx,%edx
  8017bc:	74 18                	je     8017d6 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8017be:	52                   	push   %edx
  8017bf:	68 2a 21 80 00       	push   $0x80212a
  8017c4:	53                   	push   %ebx
  8017c5:	56                   	push   %esi
  8017c6:	e8 a6 fe ff ff       	call   801671 <printfmt>
  8017cb:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8017ce:	89 7d 14             	mov    %edi,0x14(%ebp)
  8017d1:	e9 fe 02 00 00       	jmp    801ad4 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8017d6:	50                   	push   %eax
  8017d7:	68 b3 21 80 00       	push   $0x8021b3
  8017dc:	53                   	push   %ebx
  8017dd:	56                   	push   %esi
  8017de:	e8 8e fe ff ff       	call   801671 <printfmt>
  8017e3:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8017e6:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8017e9:	e9 e6 02 00 00       	jmp    801ad4 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8017ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8017f1:	83 c0 04             	add    $0x4,%eax
  8017f4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8017f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8017fa:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8017fc:	85 c9                	test   %ecx,%ecx
  8017fe:	b8 ac 21 80 00       	mov    $0x8021ac,%eax
  801803:	0f 45 c1             	cmovne %ecx,%eax
  801806:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  801809:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80180d:	7e 06                	jle    801815 <vprintfmt+0x187>
  80180f:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  801813:	75 0d                	jne    801822 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  801815:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801818:	89 c7                	mov    %eax,%edi
  80181a:	03 45 e0             	add    -0x20(%ebp),%eax
  80181d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801820:	eb 53                	jmp    801875 <vprintfmt+0x1e7>
  801822:	83 ec 08             	sub    $0x8,%esp
  801825:	ff 75 d8             	pushl  -0x28(%ebp)
  801828:	50                   	push   %eax
  801829:	e8 75 e9 ff ff       	call   8001a3 <strnlen>
  80182e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801831:	29 c1                	sub    %eax,%ecx
  801833:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  801836:	83 c4 10             	add    $0x10,%esp
  801839:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80183b:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  80183f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  801842:	eb 0f                	jmp    801853 <vprintfmt+0x1c5>
					putch(padc, putdat);
  801844:	83 ec 08             	sub    $0x8,%esp
  801847:	53                   	push   %ebx
  801848:	ff 75 e0             	pushl  -0x20(%ebp)
  80184b:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80184d:	83 ef 01             	sub    $0x1,%edi
  801850:	83 c4 10             	add    $0x10,%esp
  801853:	85 ff                	test   %edi,%edi
  801855:	7f ed                	jg     801844 <vprintfmt+0x1b6>
  801857:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  80185a:	85 c9                	test   %ecx,%ecx
  80185c:	b8 00 00 00 00       	mov    $0x0,%eax
  801861:	0f 49 c1             	cmovns %ecx,%eax
  801864:	29 c1                	sub    %eax,%ecx
  801866:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  801869:	eb aa                	jmp    801815 <vprintfmt+0x187>
					putch(ch, putdat);
  80186b:	83 ec 08             	sub    $0x8,%esp
  80186e:	53                   	push   %ebx
  80186f:	52                   	push   %edx
  801870:	ff d6                	call   *%esi
  801872:	83 c4 10             	add    $0x10,%esp
  801875:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801878:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80187a:	83 c7 01             	add    $0x1,%edi
  80187d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801881:	0f be d0             	movsbl %al,%edx
  801884:	85 d2                	test   %edx,%edx
  801886:	74 4b                	je     8018d3 <vprintfmt+0x245>
  801888:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80188c:	78 06                	js     801894 <vprintfmt+0x206>
  80188e:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  801892:	78 1e                	js     8018b2 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  801894:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  801898:	74 d1                	je     80186b <vprintfmt+0x1dd>
  80189a:	0f be c0             	movsbl %al,%eax
  80189d:	83 e8 20             	sub    $0x20,%eax
  8018a0:	83 f8 5e             	cmp    $0x5e,%eax
  8018a3:	76 c6                	jbe    80186b <vprintfmt+0x1dd>
					putch('?', putdat);
  8018a5:	83 ec 08             	sub    $0x8,%esp
  8018a8:	53                   	push   %ebx
  8018a9:	6a 3f                	push   $0x3f
  8018ab:	ff d6                	call   *%esi
  8018ad:	83 c4 10             	add    $0x10,%esp
  8018b0:	eb c3                	jmp    801875 <vprintfmt+0x1e7>
  8018b2:	89 cf                	mov    %ecx,%edi
  8018b4:	eb 0e                	jmp    8018c4 <vprintfmt+0x236>
				putch(' ', putdat);
  8018b6:	83 ec 08             	sub    $0x8,%esp
  8018b9:	53                   	push   %ebx
  8018ba:	6a 20                	push   $0x20
  8018bc:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8018be:	83 ef 01             	sub    $0x1,%edi
  8018c1:	83 c4 10             	add    $0x10,%esp
  8018c4:	85 ff                	test   %edi,%edi
  8018c6:	7f ee                	jg     8018b6 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8018c8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8018cb:	89 45 14             	mov    %eax,0x14(%ebp)
  8018ce:	e9 01 02 00 00       	jmp    801ad4 <vprintfmt+0x446>
  8018d3:	89 cf                	mov    %ecx,%edi
  8018d5:	eb ed                	jmp    8018c4 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8018d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8018da:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8018e1:	e9 eb fd ff ff       	jmp    8016d1 <vprintfmt+0x43>
	if (lflag >= 2)
  8018e6:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8018ea:	7f 21                	jg     80190d <vprintfmt+0x27f>
	else if (lflag)
  8018ec:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8018f0:	74 68                	je     80195a <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8018f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8018f5:	8b 00                	mov    (%eax),%eax
  8018f7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8018fa:	89 c1                	mov    %eax,%ecx
  8018fc:	c1 f9 1f             	sar    $0x1f,%ecx
  8018ff:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  801902:	8b 45 14             	mov    0x14(%ebp),%eax
  801905:	8d 40 04             	lea    0x4(%eax),%eax
  801908:	89 45 14             	mov    %eax,0x14(%ebp)
  80190b:	eb 17                	jmp    801924 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  80190d:	8b 45 14             	mov    0x14(%ebp),%eax
  801910:	8b 50 04             	mov    0x4(%eax),%edx
  801913:	8b 00                	mov    (%eax),%eax
  801915:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801918:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80191b:	8b 45 14             	mov    0x14(%ebp),%eax
  80191e:	8d 40 08             	lea    0x8(%eax),%eax
  801921:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  801924:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801927:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80192a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80192d:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  801930:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801934:	78 3f                	js     801975 <vprintfmt+0x2e7>
			base = 10;
  801936:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  80193b:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80193f:	0f 84 71 01 00 00    	je     801ab6 <vprintfmt+0x428>
				putch('+', putdat);
  801945:	83 ec 08             	sub    $0x8,%esp
  801948:	53                   	push   %ebx
  801949:	6a 2b                	push   $0x2b
  80194b:	ff d6                	call   *%esi
  80194d:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801950:	b8 0a 00 00 00       	mov    $0xa,%eax
  801955:	e9 5c 01 00 00       	jmp    801ab6 <vprintfmt+0x428>
		return va_arg(*ap, int);
  80195a:	8b 45 14             	mov    0x14(%ebp),%eax
  80195d:	8b 00                	mov    (%eax),%eax
  80195f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801962:	89 c1                	mov    %eax,%ecx
  801964:	c1 f9 1f             	sar    $0x1f,%ecx
  801967:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80196a:	8b 45 14             	mov    0x14(%ebp),%eax
  80196d:	8d 40 04             	lea    0x4(%eax),%eax
  801970:	89 45 14             	mov    %eax,0x14(%ebp)
  801973:	eb af                	jmp    801924 <vprintfmt+0x296>
				putch('-', putdat);
  801975:	83 ec 08             	sub    $0x8,%esp
  801978:	53                   	push   %ebx
  801979:	6a 2d                	push   $0x2d
  80197b:	ff d6                	call   *%esi
				num = -(long long) num;
  80197d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801980:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801983:	f7 d8                	neg    %eax
  801985:	83 d2 00             	adc    $0x0,%edx
  801988:	f7 da                	neg    %edx
  80198a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80198d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801990:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801993:	b8 0a 00 00 00       	mov    $0xa,%eax
  801998:	e9 19 01 00 00       	jmp    801ab6 <vprintfmt+0x428>
	if (lflag >= 2)
  80199d:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8019a1:	7f 29                	jg     8019cc <vprintfmt+0x33e>
	else if (lflag)
  8019a3:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8019a7:	74 44                	je     8019ed <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8019a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ac:	8b 00                	mov    (%eax),%eax
  8019ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8019b3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019b6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8019b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8019bc:	8d 40 04             	lea    0x4(%eax),%eax
  8019bf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019c2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019c7:	e9 ea 00 00 00       	jmp    801ab6 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8019cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8019cf:	8b 50 04             	mov    0x4(%eax),%edx
  8019d2:	8b 00                	mov    (%eax),%eax
  8019d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019d7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8019da:	8b 45 14             	mov    0x14(%ebp),%eax
  8019dd:	8d 40 08             	lea    0x8(%eax),%eax
  8019e0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019e3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019e8:	e9 c9 00 00 00       	jmp    801ab6 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8019ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8019f0:	8b 00                	mov    (%eax),%eax
  8019f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8019f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019fa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8019fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801a00:	8d 40 04             	lea    0x4(%eax),%eax
  801a03:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801a06:	b8 0a 00 00 00       	mov    $0xa,%eax
  801a0b:	e9 a6 00 00 00       	jmp    801ab6 <vprintfmt+0x428>
			putch('0', putdat);
  801a10:	83 ec 08             	sub    $0x8,%esp
  801a13:	53                   	push   %ebx
  801a14:	6a 30                	push   $0x30
  801a16:	ff d6                	call   *%esi
	if (lflag >= 2)
  801a18:	83 c4 10             	add    $0x10,%esp
  801a1b:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  801a1f:	7f 26                	jg     801a47 <vprintfmt+0x3b9>
	else if (lflag)
  801a21:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  801a25:	74 3e                	je     801a65 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  801a27:	8b 45 14             	mov    0x14(%ebp),%eax
  801a2a:	8b 00                	mov    (%eax),%eax
  801a2c:	ba 00 00 00 00       	mov    $0x0,%edx
  801a31:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a34:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a37:	8b 45 14             	mov    0x14(%ebp),%eax
  801a3a:	8d 40 04             	lea    0x4(%eax),%eax
  801a3d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801a40:	b8 08 00 00 00       	mov    $0x8,%eax
  801a45:	eb 6f                	jmp    801ab6 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  801a47:	8b 45 14             	mov    0x14(%ebp),%eax
  801a4a:	8b 50 04             	mov    0x4(%eax),%edx
  801a4d:	8b 00                	mov    (%eax),%eax
  801a4f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a52:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a55:	8b 45 14             	mov    0x14(%ebp),%eax
  801a58:	8d 40 08             	lea    0x8(%eax),%eax
  801a5b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801a5e:	b8 08 00 00 00       	mov    $0x8,%eax
  801a63:	eb 51                	jmp    801ab6 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  801a65:	8b 45 14             	mov    0x14(%ebp),%eax
  801a68:	8b 00                	mov    (%eax),%eax
  801a6a:	ba 00 00 00 00       	mov    $0x0,%edx
  801a6f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a72:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a75:	8b 45 14             	mov    0x14(%ebp),%eax
  801a78:	8d 40 04             	lea    0x4(%eax),%eax
  801a7b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801a7e:	b8 08 00 00 00       	mov    $0x8,%eax
  801a83:	eb 31                	jmp    801ab6 <vprintfmt+0x428>
			putch('0', putdat);
  801a85:	83 ec 08             	sub    $0x8,%esp
  801a88:	53                   	push   %ebx
  801a89:	6a 30                	push   $0x30
  801a8b:	ff d6                	call   *%esi
			putch('x', putdat);
  801a8d:	83 c4 08             	add    $0x8,%esp
  801a90:	53                   	push   %ebx
  801a91:	6a 78                	push   $0x78
  801a93:	ff d6                	call   *%esi
			num = (unsigned long long)
  801a95:	8b 45 14             	mov    0x14(%ebp),%eax
  801a98:	8b 00                	mov    (%eax),%eax
  801a9a:	ba 00 00 00 00       	mov    $0x0,%edx
  801a9f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801aa2:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  801aa5:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801aa8:	8b 45 14             	mov    0x14(%ebp),%eax
  801aab:	8d 40 04             	lea    0x4(%eax),%eax
  801aae:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801ab1:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801ab6:	83 ec 0c             	sub    $0xc,%esp
  801ab9:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  801abd:	52                   	push   %edx
  801abe:	ff 75 e0             	pushl  -0x20(%ebp)
  801ac1:	50                   	push   %eax
  801ac2:	ff 75 dc             	pushl  -0x24(%ebp)
  801ac5:	ff 75 d8             	pushl  -0x28(%ebp)
  801ac8:	89 da                	mov    %ebx,%edx
  801aca:	89 f0                	mov    %esi,%eax
  801acc:	e8 a4 fa ff ff       	call   801575 <printnum>
			break;
  801ad1:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  801ad4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801ad7:	83 c7 01             	add    $0x1,%edi
  801ada:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801ade:	83 f8 25             	cmp    $0x25,%eax
  801ae1:	0f 84 be fb ff ff    	je     8016a5 <vprintfmt+0x17>
			if (ch == '\0')
  801ae7:	85 c0                	test   %eax,%eax
  801ae9:	0f 84 28 01 00 00    	je     801c17 <vprintfmt+0x589>
			putch(ch, putdat);
  801aef:	83 ec 08             	sub    $0x8,%esp
  801af2:	53                   	push   %ebx
  801af3:	50                   	push   %eax
  801af4:	ff d6                	call   *%esi
  801af6:	83 c4 10             	add    $0x10,%esp
  801af9:	eb dc                	jmp    801ad7 <vprintfmt+0x449>
	if (lflag >= 2)
  801afb:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  801aff:	7f 26                	jg     801b27 <vprintfmt+0x499>
	else if (lflag)
  801b01:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  801b05:	74 41                	je     801b48 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  801b07:	8b 45 14             	mov    0x14(%ebp),%eax
  801b0a:	8b 00                	mov    (%eax),%eax
  801b0c:	ba 00 00 00 00       	mov    $0x0,%edx
  801b11:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801b14:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801b17:	8b 45 14             	mov    0x14(%ebp),%eax
  801b1a:	8d 40 04             	lea    0x4(%eax),%eax
  801b1d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b20:	b8 10 00 00 00       	mov    $0x10,%eax
  801b25:	eb 8f                	jmp    801ab6 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  801b27:	8b 45 14             	mov    0x14(%ebp),%eax
  801b2a:	8b 50 04             	mov    0x4(%eax),%edx
  801b2d:	8b 00                	mov    (%eax),%eax
  801b2f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801b32:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801b35:	8b 45 14             	mov    0x14(%ebp),%eax
  801b38:	8d 40 08             	lea    0x8(%eax),%eax
  801b3b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b3e:	b8 10 00 00 00       	mov    $0x10,%eax
  801b43:	e9 6e ff ff ff       	jmp    801ab6 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  801b48:	8b 45 14             	mov    0x14(%ebp),%eax
  801b4b:	8b 00                	mov    (%eax),%eax
  801b4d:	ba 00 00 00 00       	mov    $0x0,%edx
  801b52:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801b55:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801b58:	8b 45 14             	mov    0x14(%ebp),%eax
  801b5b:	8d 40 04             	lea    0x4(%eax),%eax
  801b5e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b61:	b8 10 00 00 00       	mov    $0x10,%eax
  801b66:	e9 4b ff ff ff       	jmp    801ab6 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  801b6b:	8b 45 14             	mov    0x14(%ebp),%eax
  801b6e:	83 c0 04             	add    $0x4,%eax
  801b71:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801b74:	8b 45 14             	mov    0x14(%ebp),%eax
  801b77:	8b 00                	mov    (%eax),%eax
  801b79:	85 c0                	test   %eax,%eax
  801b7b:	74 14                	je     801b91 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  801b7d:	8b 13                	mov    (%ebx),%edx
  801b7f:	83 fa 7f             	cmp    $0x7f,%edx
  801b82:	7f 37                	jg     801bbb <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  801b84:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  801b86:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b89:	89 45 14             	mov    %eax,0x14(%ebp)
  801b8c:	e9 43 ff ff ff       	jmp    801ad4 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  801b91:	b8 0a 00 00 00       	mov    $0xa,%eax
  801b96:	bf d1 22 80 00       	mov    $0x8022d1,%edi
							putch(ch, putdat);
  801b9b:	83 ec 08             	sub    $0x8,%esp
  801b9e:	53                   	push   %ebx
  801b9f:	50                   	push   %eax
  801ba0:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  801ba2:	83 c7 01             	add    $0x1,%edi
  801ba5:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  801ba9:	83 c4 10             	add    $0x10,%esp
  801bac:	85 c0                	test   %eax,%eax
  801bae:	75 eb                	jne    801b9b <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  801bb0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801bb3:	89 45 14             	mov    %eax,0x14(%ebp)
  801bb6:	e9 19 ff ff ff       	jmp    801ad4 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  801bbb:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  801bbd:	b8 0a 00 00 00       	mov    $0xa,%eax
  801bc2:	bf 09 23 80 00       	mov    $0x802309,%edi
							putch(ch, putdat);
  801bc7:	83 ec 08             	sub    $0x8,%esp
  801bca:	53                   	push   %ebx
  801bcb:	50                   	push   %eax
  801bcc:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  801bce:	83 c7 01             	add    $0x1,%edi
  801bd1:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  801bd5:	83 c4 10             	add    $0x10,%esp
  801bd8:	85 c0                	test   %eax,%eax
  801bda:	75 eb                	jne    801bc7 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  801bdc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801bdf:	89 45 14             	mov    %eax,0x14(%ebp)
  801be2:	e9 ed fe ff ff       	jmp    801ad4 <vprintfmt+0x446>
			putch(ch, putdat);
  801be7:	83 ec 08             	sub    $0x8,%esp
  801bea:	53                   	push   %ebx
  801beb:	6a 25                	push   $0x25
  801bed:	ff d6                	call   *%esi
			break;
  801bef:	83 c4 10             	add    $0x10,%esp
  801bf2:	e9 dd fe ff ff       	jmp    801ad4 <vprintfmt+0x446>
			putch('%', putdat);
  801bf7:	83 ec 08             	sub    $0x8,%esp
  801bfa:	53                   	push   %ebx
  801bfb:	6a 25                	push   $0x25
  801bfd:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801bff:	83 c4 10             	add    $0x10,%esp
  801c02:	89 f8                	mov    %edi,%eax
  801c04:	eb 03                	jmp    801c09 <vprintfmt+0x57b>
  801c06:	83 e8 01             	sub    $0x1,%eax
  801c09:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801c0d:	75 f7                	jne    801c06 <vprintfmt+0x578>
  801c0f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801c12:	e9 bd fe ff ff       	jmp    801ad4 <vprintfmt+0x446>
}
  801c17:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c1a:	5b                   	pop    %ebx
  801c1b:	5e                   	pop    %esi
  801c1c:	5f                   	pop    %edi
  801c1d:	5d                   	pop    %ebp
  801c1e:	c3                   	ret    

00801c1f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801c1f:	55                   	push   %ebp
  801c20:	89 e5                	mov    %esp,%ebp
  801c22:	83 ec 18             	sub    $0x18,%esp
  801c25:	8b 45 08             	mov    0x8(%ebp),%eax
  801c28:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801c2b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801c2e:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801c32:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801c35:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801c3c:	85 c0                	test   %eax,%eax
  801c3e:	74 26                	je     801c66 <vsnprintf+0x47>
  801c40:	85 d2                	test   %edx,%edx
  801c42:	7e 22                	jle    801c66 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801c44:	ff 75 14             	pushl  0x14(%ebp)
  801c47:	ff 75 10             	pushl  0x10(%ebp)
  801c4a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801c4d:	50                   	push   %eax
  801c4e:	68 54 16 80 00       	push   $0x801654
  801c53:	e8 36 fa ff ff       	call   80168e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801c58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c5b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c61:	83 c4 10             	add    $0x10,%esp
}
  801c64:	c9                   	leave  
  801c65:	c3                   	ret    
		return -E_INVAL;
  801c66:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c6b:	eb f7                	jmp    801c64 <vsnprintf+0x45>

00801c6d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801c6d:	55                   	push   %ebp
  801c6e:	89 e5                	mov    %esp,%ebp
  801c70:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801c73:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801c76:	50                   	push   %eax
  801c77:	ff 75 10             	pushl  0x10(%ebp)
  801c7a:	ff 75 0c             	pushl  0xc(%ebp)
  801c7d:	ff 75 08             	pushl  0x8(%ebp)
  801c80:	e8 9a ff ff ff       	call   801c1f <vsnprintf>
	va_end(ap);

	return rc;
}
  801c85:	c9                   	leave  
  801c86:	c3                   	ret    

00801c87 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801c87:	55                   	push   %ebp
  801c88:	89 e5                	mov    %esp,%ebp
  801c8a:	56                   	push   %esi
  801c8b:	53                   	push   %ebx
  801c8c:	8b 75 08             	mov    0x8(%ebp),%esi
  801c8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c92:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// cprintf("in %s\n", __FUNCTION__);
	int ret;
	if(!pg)
  801c95:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801c97:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801c9c:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  801c9f:	83 ec 0c             	sub    $0xc,%esp
  801ca2:	50                   	push   %eax
  801ca3:	e8 be ea ff ff       	call   800766 <sys_ipc_recv>
	if(ret < 0){
  801ca8:	83 c4 10             	add    $0x10,%esp
  801cab:	85 c0                	test   %eax,%eax
  801cad:	78 2b                	js     801cda <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  801caf:	85 f6                	test   %esi,%esi
  801cb1:	74 0a                	je     801cbd <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  801cb3:	a1 04 40 80 00       	mov    0x804004,%eax
  801cb8:	8b 40 74             	mov    0x74(%eax),%eax
  801cbb:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  801cbd:	85 db                	test   %ebx,%ebx
  801cbf:	74 0a                	je     801ccb <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  801cc1:	a1 04 40 80 00       	mov    0x804004,%eax
  801cc6:	8b 40 78             	mov    0x78(%eax),%eax
  801cc9:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  801ccb:	a1 04 40 80 00       	mov    0x804004,%eax
  801cd0:	8b 40 70             	mov    0x70(%eax),%eax
}
  801cd3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cd6:	5b                   	pop    %ebx
  801cd7:	5e                   	pop    %esi
  801cd8:	5d                   	pop    %ebp
  801cd9:	c3                   	ret    
		if(from_env_store)
  801cda:	85 f6                	test   %esi,%esi
  801cdc:	74 06                	je     801ce4 <ipc_recv+0x5d>
			*from_env_store = 0;
  801cde:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  801ce4:	85 db                	test   %ebx,%ebx
  801ce6:	74 eb                	je     801cd3 <ipc_recv+0x4c>
			*perm_store = 0;
  801ce8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801cee:	eb e3                	jmp    801cd3 <ipc_recv+0x4c>

00801cf0 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  801cf0:	55                   	push   %ebp
  801cf1:	89 e5                	mov    %esp,%ebp
  801cf3:	57                   	push   %edi
  801cf4:	56                   	push   %esi
  801cf5:	53                   	push   %ebx
  801cf6:	83 ec 0c             	sub    $0xc,%esp
  801cf9:	8b 7d 08             	mov    0x8(%ebp),%edi
  801cfc:	8b 75 0c             	mov    0xc(%ebp),%esi
  801cff:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  801d02:	85 db                	test   %ebx,%ebx
  801d04:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801d09:	0f 44 d8             	cmove  %eax,%ebx
  801d0c:	eb 05                	jmp    801d13 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  801d0e:	e8 84 e8 ff ff       	call   800597 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  801d13:	ff 75 14             	pushl  0x14(%ebp)
  801d16:	53                   	push   %ebx
  801d17:	56                   	push   %esi
  801d18:	57                   	push   %edi
  801d19:	e8 25 ea ff ff       	call   800743 <sys_ipc_try_send>
  801d1e:	83 c4 10             	add    $0x10,%esp
  801d21:	85 c0                	test   %eax,%eax
  801d23:	74 1b                	je     801d40 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  801d25:	79 e7                	jns    801d0e <ipc_send+0x1e>
  801d27:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801d2a:	74 e2                	je     801d0e <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  801d2c:	83 ec 04             	sub    $0x4,%esp
  801d2f:	68 20 25 80 00       	push   $0x802520
  801d34:	6a 49                	push   $0x49
  801d36:	68 35 25 80 00       	push   $0x802535
  801d3b:	e8 2b f7 ff ff       	call   80146b <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  801d40:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d43:	5b                   	pop    %ebx
  801d44:	5e                   	pop    %esi
  801d45:	5f                   	pop    %edi
  801d46:	5d                   	pop    %ebp
  801d47:	c3                   	ret    

00801d48 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801d48:	55                   	push   %ebp
  801d49:	89 e5                	mov    %esp,%ebp
  801d4b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801d4e:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801d53:	89 c2                	mov    %eax,%edx
  801d55:	c1 e2 07             	shl    $0x7,%edx
  801d58:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801d5e:	8b 52 50             	mov    0x50(%edx),%edx
  801d61:	39 ca                	cmp    %ecx,%edx
  801d63:	74 11                	je     801d76 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  801d65:	83 c0 01             	add    $0x1,%eax
  801d68:	3d 00 04 00 00       	cmp    $0x400,%eax
  801d6d:	75 e4                	jne    801d53 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801d6f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d74:	eb 0b                	jmp    801d81 <ipc_find_env+0x39>
			return envs[i].env_id;
  801d76:	c1 e0 07             	shl    $0x7,%eax
  801d79:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801d7e:	8b 40 48             	mov    0x48(%eax),%eax
}
  801d81:	5d                   	pop    %ebp
  801d82:	c3                   	ret    

00801d83 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801d83:	55                   	push   %ebp
  801d84:	89 e5                	mov    %esp,%ebp
  801d86:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801d89:	89 d0                	mov    %edx,%eax
  801d8b:	c1 e8 16             	shr    $0x16,%eax
  801d8e:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801d95:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801d9a:	f6 c1 01             	test   $0x1,%cl
  801d9d:	74 1d                	je     801dbc <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801d9f:	c1 ea 0c             	shr    $0xc,%edx
  801da2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801da9:	f6 c2 01             	test   $0x1,%dl
  801dac:	74 0e                	je     801dbc <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801dae:	c1 ea 0c             	shr    $0xc,%edx
  801db1:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801db8:	ef 
  801db9:	0f b7 c0             	movzwl %ax,%eax
}
  801dbc:	5d                   	pop    %ebp
  801dbd:	c3                   	ret    
  801dbe:	66 90                	xchg   %ax,%ax

00801dc0 <__udivdi3>:
  801dc0:	55                   	push   %ebp
  801dc1:	57                   	push   %edi
  801dc2:	56                   	push   %esi
  801dc3:	53                   	push   %ebx
  801dc4:	83 ec 1c             	sub    $0x1c,%esp
  801dc7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801dcb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801dcf:	8b 74 24 34          	mov    0x34(%esp),%esi
  801dd3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801dd7:	85 d2                	test   %edx,%edx
  801dd9:	75 4d                	jne    801e28 <__udivdi3+0x68>
  801ddb:	39 f3                	cmp    %esi,%ebx
  801ddd:	76 19                	jbe    801df8 <__udivdi3+0x38>
  801ddf:	31 ff                	xor    %edi,%edi
  801de1:	89 e8                	mov    %ebp,%eax
  801de3:	89 f2                	mov    %esi,%edx
  801de5:	f7 f3                	div    %ebx
  801de7:	89 fa                	mov    %edi,%edx
  801de9:	83 c4 1c             	add    $0x1c,%esp
  801dec:	5b                   	pop    %ebx
  801ded:	5e                   	pop    %esi
  801dee:	5f                   	pop    %edi
  801def:	5d                   	pop    %ebp
  801df0:	c3                   	ret    
  801df1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801df8:	89 d9                	mov    %ebx,%ecx
  801dfa:	85 db                	test   %ebx,%ebx
  801dfc:	75 0b                	jne    801e09 <__udivdi3+0x49>
  801dfe:	b8 01 00 00 00       	mov    $0x1,%eax
  801e03:	31 d2                	xor    %edx,%edx
  801e05:	f7 f3                	div    %ebx
  801e07:	89 c1                	mov    %eax,%ecx
  801e09:	31 d2                	xor    %edx,%edx
  801e0b:	89 f0                	mov    %esi,%eax
  801e0d:	f7 f1                	div    %ecx
  801e0f:	89 c6                	mov    %eax,%esi
  801e11:	89 e8                	mov    %ebp,%eax
  801e13:	89 f7                	mov    %esi,%edi
  801e15:	f7 f1                	div    %ecx
  801e17:	89 fa                	mov    %edi,%edx
  801e19:	83 c4 1c             	add    $0x1c,%esp
  801e1c:	5b                   	pop    %ebx
  801e1d:	5e                   	pop    %esi
  801e1e:	5f                   	pop    %edi
  801e1f:	5d                   	pop    %ebp
  801e20:	c3                   	ret    
  801e21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e28:	39 f2                	cmp    %esi,%edx
  801e2a:	77 1c                	ja     801e48 <__udivdi3+0x88>
  801e2c:	0f bd fa             	bsr    %edx,%edi
  801e2f:	83 f7 1f             	xor    $0x1f,%edi
  801e32:	75 2c                	jne    801e60 <__udivdi3+0xa0>
  801e34:	39 f2                	cmp    %esi,%edx
  801e36:	72 06                	jb     801e3e <__udivdi3+0x7e>
  801e38:	31 c0                	xor    %eax,%eax
  801e3a:	39 eb                	cmp    %ebp,%ebx
  801e3c:	77 a9                	ja     801de7 <__udivdi3+0x27>
  801e3e:	b8 01 00 00 00       	mov    $0x1,%eax
  801e43:	eb a2                	jmp    801de7 <__udivdi3+0x27>
  801e45:	8d 76 00             	lea    0x0(%esi),%esi
  801e48:	31 ff                	xor    %edi,%edi
  801e4a:	31 c0                	xor    %eax,%eax
  801e4c:	89 fa                	mov    %edi,%edx
  801e4e:	83 c4 1c             	add    $0x1c,%esp
  801e51:	5b                   	pop    %ebx
  801e52:	5e                   	pop    %esi
  801e53:	5f                   	pop    %edi
  801e54:	5d                   	pop    %ebp
  801e55:	c3                   	ret    
  801e56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e5d:	8d 76 00             	lea    0x0(%esi),%esi
  801e60:	89 f9                	mov    %edi,%ecx
  801e62:	b8 20 00 00 00       	mov    $0x20,%eax
  801e67:	29 f8                	sub    %edi,%eax
  801e69:	d3 e2                	shl    %cl,%edx
  801e6b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e6f:	89 c1                	mov    %eax,%ecx
  801e71:	89 da                	mov    %ebx,%edx
  801e73:	d3 ea                	shr    %cl,%edx
  801e75:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801e79:	09 d1                	or     %edx,%ecx
  801e7b:	89 f2                	mov    %esi,%edx
  801e7d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e81:	89 f9                	mov    %edi,%ecx
  801e83:	d3 e3                	shl    %cl,%ebx
  801e85:	89 c1                	mov    %eax,%ecx
  801e87:	d3 ea                	shr    %cl,%edx
  801e89:	89 f9                	mov    %edi,%ecx
  801e8b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801e8f:	89 eb                	mov    %ebp,%ebx
  801e91:	d3 e6                	shl    %cl,%esi
  801e93:	89 c1                	mov    %eax,%ecx
  801e95:	d3 eb                	shr    %cl,%ebx
  801e97:	09 de                	or     %ebx,%esi
  801e99:	89 f0                	mov    %esi,%eax
  801e9b:	f7 74 24 08          	divl   0x8(%esp)
  801e9f:	89 d6                	mov    %edx,%esi
  801ea1:	89 c3                	mov    %eax,%ebx
  801ea3:	f7 64 24 0c          	mull   0xc(%esp)
  801ea7:	39 d6                	cmp    %edx,%esi
  801ea9:	72 15                	jb     801ec0 <__udivdi3+0x100>
  801eab:	89 f9                	mov    %edi,%ecx
  801ead:	d3 e5                	shl    %cl,%ebp
  801eaf:	39 c5                	cmp    %eax,%ebp
  801eb1:	73 04                	jae    801eb7 <__udivdi3+0xf7>
  801eb3:	39 d6                	cmp    %edx,%esi
  801eb5:	74 09                	je     801ec0 <__udivdi3+0x100>
  801eb7:	89 d8                	mov    %ebx,%eax
  801eb9:	31 ff                	xor    %edi,%edi
  801ebb:	e9 27 ff ff ff       	jmp    801de7 <__udivdi3+0x27>
  801ec0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801ec3:	31 ff                	xor    %edi,%edi
  801ec5:	e9 1d ff ff ff       	jmp    801de7 <__udivdi3+0x27>
  801eca:	66 90                	xchg   %ax,%ax
  801ecc:	66 90                	xchg   %ax,%ax
  801ece:	66 90                	xchg   %ax,%ax

00801ed0 <__umoddi3>:
  801ed0:	55                   	push   %ebp
  801ed1:	57                   	push   %edi
  801ed2:	56                   	push   %esi
  801ed3:	53                   	push   %ebx
  801ed4:	83 ec 1c             	sub    $0x1c,%esp
  801ed7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801edb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801edf:	8b 74 24 30          	mov    0x30(%esp),%esi
  801ee3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ee7:	89 da                	mov    %ebx,%edx
  801ee9:	85 c0                	test   %eax,%eax
  801eeb:	75 43                	jne    801f30 <__umoddi3+0x60>
  801eed:	39 df                	cmp    %ebx,%edi
  801eef:	76 17                	jbe    801f08 <__umoddi3+0x38>
  801ef1:	89 f0                	mov    %esi,%eax
  801ef3:	f7 f7                	div    %edi
  801ef5:	89 d0                	mov    %edx,%eax
  801ef7:	31 d2                	xor    %edx,%edx
  801ef9:	83 c4 1c             	add    $0x1c,%esp
  801efc:	5b                   	pop    %ebx
  801efd:	5e                   	pop    %esi
  801efe:	5f                   	pop    %edi
  801eff:	5d                   	pop    %ebp
  801f00:	c3                   	ret    
  801f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f08:	89 fd                	mov    %edi,%ebp
  801f0a:	85 ff                	test   %edi,%edi
  801f0c:	75 0b                	jne    801f19 <__umoddi3+0x49>
  801f0e:	b8 01 00 00 00       	mov    $0x1,%eax
  801f13:	31 d2                	xor    %edx,%edx
  801f15:	f7 f7                	div    %edi
  801f17:	89 c5                	mov    %eax,%ebp
  801f19:	89 d8                	mov    %ebx,%eax
  801f1b:	31 d2                	xor    %edx,%edx
  801f1d:	f7 f5                	div    %ebp
  801f1f:	89 f0                	mov    %esi,%eax
  801f21:	f7 f5                	div    %ebp
  801f23:	89 d0                	mov    %edx,%eax
  801f25:	eb d0                	jmp    801ef7 <__umoddi3+0x27>
  801f27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f2e:	66 90                	xchg   %ax,%ax
  801f30:	89 f1                	mov    %esi,%ecx
  801f32:	39 d8                	cmp    %ebx,%eax
  801f34:	76 0a                	jbe    801f40 <__umoddi3+0x70>
  801f36:	89 f0                	mov    %esi,%eax
  801f38:	83 c4 1c             	add    $0x1c,%esp
  801f3b:	5b                   	pop    %ebx
  801f3c:	5e                   	pop    %esi
  801f3d:	5f                   	pop    %edi
  801f3e:	5d                   	pop    %ebp
  801f3f:	c3                   	ret    
  801f40:	0f bd e8             	bsr    %eax,%ebp
  801f43:	83 f5 1f             	xor    $0x1f,%ebp
  801f46:	75 20                	jne    801f68 <__umoddi3+0x98>
  801f48:	39 d8                	cmp    %ebx,%eax
  801f4a:	0f 82 b0 00 00 00    	jb     802000 <__umoddi3+0x130>
  801f50:	39 f7                	cmp    %esi,%edi
  801f52:	0f 86 a8 00 00 00    	jbe    802000 <__umoddi3+0x130>
  801f58:	89 c8                	mov    %ecx,%eax
  801f5a:	83 c4 1c             	add    $0x1c,%esp
  801f5d:	5b                   	pop    %ebx
  801f5e:	5e                   	pop    %esi
  801f5f:	5f                   	pop    %edi
  801f60:	5d                   	pop    %ebp
  801f61:	c3                   	ret    
  801f62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801f68:	89 e9                	mov    %ebp,%ecx
  801f6a:	ba 20 00 00 00       	mov    $0x20,%edx
  801f6f:	29 ea                	sub    %ebp,%edx
  801f71:	d3 e0                	shl    %cl,%eax
  801f73:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f77:	89 d1                	mov    %edx,%ecx
  801f79:	89 f8                	mov    %edi,%eax
  801f7b:	d3 e8                	shr    %cl,%eax
  801f7d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801f81:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f85:	8b 54 24 04          	mov    0x4(%esp),%edx
  801f89:	09 c1                	or     %eax,%ecx
  801f8b:	89 d8                	mov    %ebx,%eax
  801f8d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801f91:	89 e9                	mov    %ebp,%ecx
  801f93:	d3 e7                	shl    %cl,%edi
  801f95:	89 d1                	mov    %edx,%ecx
  801f97:	d3 e8                	shr    %cl,%eax
  801f99:	89 e9                	mov    %ebp,%ecx
  801f9b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801f9f:	d3 e3                	shl    %cl,%ebx
  801fa1:	89 c7                	mov    %eax,%edi
  801fa3:	89 d1                	mov    %edx,%ecx
  801fa5:	89 f0                	mov    %esi,%eax
  801fa7:	d3 e8                	shr    %cl,%eax
  801fa9:	89 e9                	mov    %ebp,%ecx
  801fab:	89 fa                	mov    %edi,%edx
  801fad:	d3 e6                	shl    %cl,%esi
  801faf:	09 d8                	or     %ebx,%eax
  801fb1:	f7 74 24 08          	divl   0x8(%esp)
  801fb5:	89 d1                	mov    %edx,%ecx
  801fb7:	89 f3                	mov    %esi,%ebx
  801fb9:	f7 64 24 0c          	mull   0xc(%esp)
  801fbd:	89 c6                	mov    %eax,%esi
  801fbf:	89 d7                	mov    %edx,%edi
  801fc1:	39 d1                	cmp    %edx,%ecx
  801fc3:	72 06                	jb     801fcb <__umoddi3+0xfb>
  801fc5:	75 10                	jne    801fd7 <__umoddi3+0x107>
  801fc7:	39 c3                	cmp    %eax,%ebx
  801fc9:	73 0c                	jae    801fd7 <__umoddi3+0x107>
  801fcb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  801fcf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801fd3:	89 d7                	mov    %edx,%edi
  801fd5:	89 c6                	mov    %eax,%esi
  801fd7:	89 ca                	mov    %ecx,%edx
  801fd9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801fde:	29 f3                	sub    %esi,%ebx
  801fe0:	19 fa                	sbb    %edi,%edx
  801fe2:	89 d0                	mov    %edx,%eax
  801fe4:	d3 e0                	shl    %cl,%eax
  801fe6:	89 e9                	mov    %ebp,%ecx
  801fe8:	d3 eb                	shr    %cl,%ebx
  801fea:	d3 ea                	shr    %cl,%edx
  801fec:	09 d8                	or     %ebx,%eax
  801fee:	83 c4 1c             	add    $0x1c,%esp
  801ff1:	5b                   	pop    %ebx
  801ff2:	5e                   	pop    %esi
  801ff3:	5f                   	pop    %edi
  801ff4:	5d                   	pop    %ebp
  801ff5:	c3                   	ret    
  801ff6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801ffd:	8d 76 00             	lea    0x0(%esi),%esi
  802000:	89 da                	mov    %ebx,%edx
  802002:	29 fe                	sub    %edi,%esi
  802004:	19 c2                	sbb    %eax,%edx
  802006:	89 f1                	mov    %esi,%ecx
  802008:	89 c8                	mov    %ecx,%eax
  80200a:	e9 4b ff ff ff       	jmp    801f5a <__umoddi3+0x8a>
