	.file	"mangle.cc"
	.text
	.globl	_Z3fooi
	.type	_Z3fooi, @function
_Z3fooi:
.LFB1:
	.cfi_startproc
	endbr64
	movl	%edi, %eax
	ret
	.cfi_endproc
.LFE1:
	.size	_Z3fooi, .-_Z3fooi
	.align 2
	.globl	_ZN1S3fooEi
	.type	_ZN1S3fooEi, @function
_ZN1S3fooEi:
.LFB2:
	.cfi_startproc
	endbr64
	movl	%esi, %eax
	ret
	.cfi_endproc
.LFE2:
	.size	_ZN1S3fooEi, .-_ZN1S3fooEi
	.globl	_Z3fooP1Si
	.type	_Z3fooP1Si, @function
_Z3fooP1Si:
.LFB0:
	.cfi_startproc
	endbr64
	call	_ZN1S3fooEi
	ret
	.cfi_endproc
.LFE0:
	.size	_Z3fooP1Si, .-_Z3fooP1Si
	.globl	bar
	.type	bar, @function
bar:
.LFB3:
	.cfi_startproc
	endbr64
	movl	%edi, %eax
	ret
	.cfi_endproc
.LFE3:
	.size	bar, .-bar
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04) 13.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
