
obj/boot/boot.out:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00007c00 <start>:
start:
  # FIRST PHASE: Register y operation mode setup.
  # Assemble for 16-bit mode
  
	.code16  
        cli
    7c00:	fa                   	cli    

	# Set up the important data segment registers (DS, ES, SS).
	xorw	%ax,%ax			# Segment number zero
    7c01:	31 c0                	xor    %eax,%eax
	movw	%ax,%ds			# -> Data Segment
    7c03:	8e d8                	mov    %eax,%ds
	movw	%ax,%es			# -> Extra Segment
    7c05:	8e c0                	mov    %eax,%es
	movw	%ax,%ss			# -> Stack Segment
    7c07:	8e d0                	mov    %eax,%ss


	lgdt	gdtdesc		# load GDT: mandatory in protected mode
    7c09:	0f 01 16             	lgdtl  (%esi)
    7c0c:	54                   	push   %esp
    7c0d:	7c 0f                	jl     7c1e <protcseg+0x1>
	movl	%cr0, %eax	# Turn on protected mode
    7c0f:	20 c0                	and    %al,%al
	orl	$CR0_PE_ON, %eax
    7c11:	66 83 c8 01          	or     $0x1,%ax
	movl	%eax, %cr0
    7c15:	0f 22 c0             	mov    %eax,%cr0

    # CPU magic: jump to relocation, flush prefetch queue, and
	# reload %cs.  Has the effect of just jmp to the next
	# instruction, but simultaneously loads CS with
	# $PROT_MODE_CSEG.
	ljmp	$PROT_MODE_CSEG, $protcseg
    7c18:	ea 1d 7c 08 00 66 b8 	ljmp   $0xb866,$0x87c1d

00007c1d <protcseg>:
	# to generate code for that mode
	.code32
protcseg:	

	# Set up the protected-mode data segment registers
	movw	$PROT_MODE_DSEG, %ax	# Our data segment selector
    7c1d:	66 b8 10 00          	mov    $0x10,%ax
	movw	%ax, %ds		# -> DS: Data Segment
    7c21:	8e d8                	mov    %eax,%ds
	movw	%ax, %es		# -> ES: Extra Segment
    7c23:	8e c0                	mov    %eax,%es
	movw	%ax, %fs		# -> FS
    7c25:	8e e0                	mov    %eax,%fs
	movw	%ax, %gs		# -> GS
    7c27:	8e e8                	mov    %eax,%gs
	movw	%ax, %ss		# -> SS: Stack Segment
    7c29:	8e d0                	mov    %eax,%ss
	#
	#Agregue aquí su codigo para resolver el inciso 2)
	#de las actividades asignadas
	#
	#
	movb   $0x67,0xB8000 
    7c2b:	c6 05 00 80 0b 00 67 	movb   $0x67,0xb8000
	movb   $0x1E,0xB8001 
    7c32:	c6 05 01 80 0b 00 1e 	movb   $0x1e,0xb8001

00007c39 <hang>:

	#call printString
	
hang:
	jmp hang
    7c39:	eb fe                	jmp    7c39 <hang>
    7c3b:	90                   	nop

00007c3c <gdt>:
	...

00007c44 <gdt_code>:
    7c44:	ff                   	(bad)  
    7c45:	ff 00                	incl   (%eax)
    7c47:	00 00                	add    %al,(%eax)
    7c49:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf

00007c4c <gdt_data>:
    7c4c:	ff                   	(bad)  
    7c4d:	ff 00                	incl   (%eax)
    7c4f:	00 00                	add    %al,(%eax)
    7c51:	92                   	xchg   %eax,%edx
    7c52:	cf                   	iret   
	...

00007c54 <gdt_end>:
    7c54:	17                   	pop    %ss
    7c55:	00 3c 7c             	add    %bh,(%esp,%edi,2)
	...

00007c5a <cls>:

const char *cadena = "Bienvenido al GOS";

void cls()
{
    7c5a:	55                   	push   %ebp
	unsigned char *vidmem = (unsigned char *)0xB8000;
    7c5b:	b8 00 80 0b 00       	mov    $0xb8000,%eax

const char *cadena = "Bienvenido al GOS";

void cls()
{
    7c60:	89 e5                	mov    %esp,%ebp
  	const long size = 80*25;
	long loop;

   	for (loop=0; loop<size; loop++) 
   	{
      		*vidmem++ = 0;
    7c62:	c6 00 00             	movb   $0x0,(%eax)
    7c65:	83 c0 02             	add    $0x2,%eax
{
	unsigned char *vidmem = (unsigned char *)0xB8000;
  	const long size = 80*25;
	long loop;

   	for (loop=0; loop<size; loop++) 
    7c68:	3d a0 8f 0b 00       	cmp    $0xb8fa0,%eax
   	{
      		*vidmem++ = 0;
      		*vidmem++ = 0xA;
    7c6d:	c6 40 ff 0a          	movb   $0xa,-0x1(%eax)
{
	unsigned char *vidmem = (unsigned char *)0xB8000;
  	const long size = 80*25;
	long loop;

   	for (loop=0; loop<size; loop++) 
    7c71:	75 ef                	jne    7c62 <cls+0x8>
   	{
      		*vidmem++ = 0;
      		*vidmem++ = 0xA;
   	}
}
    7c73:	5d                   	pop    %ebp
    7c74:	c3                   	ret    

00007c75 <print>:

void print(const char *_message)
{
    7c75:	55                   	push   %ebp
  unsigned char *vidmem = (unsigned char *)0xB8000;
    7c76:	b8 00 80 0b 00       	mov    $0xb8000,%eax
      		*vidmem++ = 0xA;
   	}
}

void print(const char *_message)
{
    7c7b:	89 e5                	mov    %esp,%ebp
  unsigned char *vidmem = (unsigned char *)0xB8000;
  const long size = 80*25;
  long loop;
  
  while(*cadena!=0) {
    7c7d:	8b 15 40 7d 00 00    	mov    0x7d40,%edx
    7c83:	8a 12                	mov    (%edx),%dl
    7c85:	84 d2                	test   %dl,%dl
    7c87:	74 11                	je     7c9a <print+0x25>
    *vidmem++ = *cadena;
    7c89:	88 10                	mov    %dl,(%eax)
    7c8b:	83 c0 02             	add    $0x2,%eax
    *vidmem++ = 0x1E;
    7c8e:	c6 40 ff 1e          	movb   $0x1e,-0x1(%eax)
    *cadena++;
    7c92:	ff 05 40 7d 00 00    	incl   0x7d40
    7c98:	eb e3                	jmp    7c7d <print+0x8>
  }
}
    7c9a:	5d                   	pop    %ebp
    7c9b:	c3                   	ret    

00007c9c <printString>:

int printString()
{
    7c9c:	55                   	push   %ebp
    7c9d:	89 e5                	mov    %esp,%ebp
  cls();
    7c9f:	e8 b6 ff ff ff       	call   7c5a <cls>
  print(cadena);
    7ca4:	ff 35 40 7d 00 00    	pushl  0x7d40
    7caa:	e8 c6 ff ff ff       	call   7c75 <print>
  return 0;
}
    7caf:	31 c0                	xor    %eax,%eax
    7cb1:	c9                   	leave  
    7cb2:	c3                   	ret    
