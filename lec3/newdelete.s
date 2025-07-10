	.file	"newdelete.cc"
	.text
#APP
	.globl _ZSt21ios_base_library_initv
	.section	.rodata._ZN12MySmallClassD2Ev.str1.1,"aMS",@progbits,1
.LC0:
	.string	"small dtor"
#NO_APP
	.section	.text._ZN12MySmallClassD2Ev,"axG",@progbits,_ZN12MySmallClassD5Ev,comdat
	.align 2
	.weak	_ZN12MySmallClassD2Ev
	.type	_ZN12MySmallClassD2Ev, @function
_ZN12MySmallClassD2Ev:
.LFB2061:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA2061
	endbr64
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movl	$10, %edx
	leaq	.LC0(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rbx
	movq	%rbx, %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	_ZSt4cout(%rip), %rax
	movq	-24(%rax), %rax
	movq	240(%rbx,%rax), %rbx
	testq	%rbx, %rbx
	je	.L6
	cmpb	$0, 56(%rbx)
	je	.L3
	movzbl	67(%rbx), %esi
.L4:
	movsbl	%sil, %esi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZNSo3putEc@PLT
	movq	%rax, %rdi
	call	_ZNSo5flushEv@PLT
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L6:
	.cfi_restore_state
	call	_ZSt16__throw_bad_castv@PLT
.L3:
	movq	%rbx, %rdi
	call	_ZNKSt5ctypeIcE13_M_widen_initEv@PLT
	movq	(%rbx), %rax
	movl	$10, %esi
	movq	%rbx, %rdi
	call	*48(%rax)
	movl	%eax, %esi
	jmp	.L4
	.cfi_endproc
.LFE2061:
	.globl	__gxx_personality_v0
	.section	.gcc_except_table._ZN12MySmallClassD2Ev,"aG",@progbits,_ZN12MySmallClassD5Ev,comdat
.LLSDA2061:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE2061-.LLSDACSB2061
.LLSDACSB2061:
.LLSDACSE2061:
	.section	.text._ZN12MySmallClassD2Ev,"axG",@progbits,_ZN12MySmallClassD5Ev,comdat
	.size	_ZN12MySmallClassD2Ev, .-_ZN12MySmallClassD2Ev
	.weak	_ZN12MySmallClassD1Ev
	.set	_ZN12MySmallClassD1Ev,_ZN12MySmallClassD2Ev
	.section	.rodata._ZN10MyBigClassD2Ev.str1.1,"aMS",@progbits,1
.LC1:
	.string	"big dtor"
	.section	.text._ZN10MyBigClassD2Ev,"axG",@progbits,_ZN10MyBigClassD5Ev,comdat
	.align 2
	.weak	_ZN10MyBigClassD2Ev
	.type	_ZN10MyBigClassD2Ev, @function
_ZN10MyBigClassD2Ev:
.LFB2067:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA2067
	endbr64
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movl	$8, %edx
	leaq	.LC1(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rbx
	movq	%rbx, %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	_ZSt4cout(%rip), %rax
	movq	-24(%rax), %rax
	movq	240(%rbx,%rax), %rbx
	testq	%rbx, %rbx
	je	.L12
	cmpb	$0, 56(%rbx)
	je	.L9
	movzbl	67(%rbx), %esi
.L10:
	movsbl	%sil, %esi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZNSo3putEc@PLT
	movq	%rax, %rdi
	call	_ZNSo5flushEv@PLT
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L12:
	.cfi_restore_state
	call	_ZSt16__throw_bad_castv@PLT
.L9:
	movq	%rbx, %rdi
	call	_ZNKSt5ctypeIcE13_M_widen_initEv@PLT
	movq	(%rbx), %rax
	movl	$10, %esi
	movq	%rbx, %rdi
	call	*48(%rax)
	movl	%eax, %esi
	jmp	.L10
	.cfi_endproc
.LFE2067:
	.section	.gcc_except_table._ZN10MyBigClassD2Ev,"aG",@progbits,_ZN10MyBigClassD5Ev,comdat
.LLSDA2067:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE2067-.LLSDACSB2067
.LLSDACSB2067:
.LLSDACSE2067:
	.section	.text._ZN10MyBigClassD2Ev,"axG",@progbits,_ZN10MyBigClassD5Ev,comdat
	.size	_ZN10MyBigClassD2Ev, .-_ZN10MyBigClassD2Ev
	.weak	_ZN10MyBigClassD1Ev
	.set	_ZN10MyBigClassD1Ev,_ZN10MyBigClassD2Ev
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC2:
	.string	"big ctor"
.LC3:
	.string	"small ctor"
	.text
	.globl	main
	.type	main, @function
main:
.LFB2069:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA2069
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$24, %rsp
	.cfi_def_cfa_offset 80
	movl	$12, %edi
.LEHB0:
	call	_Znwm@PLT
.LEHE0:
	movq	%rax, %rbx
	movl	$1, (%rax)
	movl	$2, 4(%rax)
	movl	$3, 8(%rax)
	movl	$8, %edx
	leaq	.LC2(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
.LEHB1:
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	_ZSt4cout(%rip), %rax
	movq	-24(%rax), %rax
	leaq	_ZSt4cout(%rip), %rdx
	movq	240(%rdx,%rax), %rbp
	testq	%rbp, %rbp
	je	.L50
	cmpb	$0, 56(%rbp)
	je	.L15
	movzbl	67(%rbp), %esi
.L16:
	movsbl	%sil, %esi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZNSo3putEc@PLT
	jmp	.L51
.L50:
	call	_ZSt16__throw_bad_castv@PLT
.LEHE1:
.L41:
	endbr64
	movq	%rax, %rbp
	movl	$12, %esi
	movq	%rbx, %rdi
	call	_ZdlPvm@PLT
	movq	%rbp, %rdi
.LEHB2:
	call	_Unwind_Resume@PLT
.LEHE2:
.L15:
	movq	%rbp, %rdi
.LEHB3:
	call	_ZNKSt5ctypeIcE13_M_widen_initEv@PLT
	movq	0(%rbp), %rax
	movl	$10, %esi
	movq	%rbp, %rdi
	call	*48(%rax)
	movl	%eax, %esi
	jmp	.L16
.L51:
	movq	%rax, %rdi
	call	_ZNSo5flushEv@PLT
.LEHE3:
	movl	$4, %edi
.LEHB4:
	call	_Znwm@PLT
.LEHE4:
	movq	%rax, %r13
	movl	$1, (%rax)
	movl	$10, %edx
	leaq	.LC3(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
.LEHB5:
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	_ZSt4cout(%rip), %rax
	movq	-24(%rax), %rax
	leaq	_ZSt4cout(%rip), %rdx
	movq	240(%rdx,%rax), %rbx
	testq	%rbx, %rbx
	je	.L52
	cmpb	$0, 56(%rbx)
	je	.L18
	movzbl	67(%rbx), %esi
.L19:
	movsbl	%sil, %esi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZNSo3putEc@PLT
	jmp	.L53
.L52:
	call	_ZSt16__throw_bad_castv@PLT
.LEHE5:
.L42:
	endbr64
	movq	%rax, %rbx
	movl	$4, %esi
	movq	%r13, %rdi
	call	_ZdlPvm@PLT
	movq	%rbx, %rdi
.LEHB6:
	call	_Unwind_Resume@PLT
.LEHE6:
.L18:
	movq	%rbx, %rdi
.LEHB7:
	call	_ZNKSt5ctypeIcE13_M_widen_initEv@PLT
	movq	(%rbx), %rax
	movl	$10, %esi
	movq	%rbx, %rdi
	call	*48(%rax)
	movl	%eax, %esi
	jmp	.L19
.L53:
	movq	%rax, %rdi
	call	_ZNSo5flushEv@PLT
.LEHE7:
	movl	$68, %edi
.LEHB8:
	call	_Znam@PLT
.LEHE8:
	movq	%rax, 8(%rsp)
	movq	$5, (%rax)
	addq	$8, %rax
	movq	%rax, (%rsp)
	movq	%rax, %rbx
	movl	$4, %r14d
	leaq	.LC2(%rip), %r15
	leaq	_ZSt4cout(%rip), %r12
	jmp	.L23
.L57:
	movq	(%r12), %rax
	movq	-24(%rax), %rax
	movq	240(%r12,%rax), %rbp
	testq	%rbp, %rbp
	je	.L54
	cmpb	$0, 56(%rbp)
	je	.L21
	movzbl	67(%rbp), %esi
.L22:
	movsbl	%sil, %esi
	movq	%r12, %rdi
.LEHB9:
	call	_ZNSo3putEc@PLT
	jmp	.L55
.L54:
	call	_ZSt16__throw_bad_castv@PLT
.L43:
	endbr64
	movq	%rax, %rbp
	movl	$4, %ebx
	subq	%r14, %rbx
	imulq	$12, %rbx, %rbx
	movq	(%rsp), %rax
	addq	%rax, %rbx
.L37:
	movq	(%rsp), %rax
	cmpq	%rax, %rbx
	je	.L36
	subq	$12, %rbx
	movq	%rbx, %rdi
	call	_ZN10MyBigClassD1Ev
	jmp	.L37
.L21:
	movq	%rbp, %rdi
	call	_ZNKSt5ctypeIcE13_M_widen_initEv@PLT
	movq	0(%rbp), %rax
	movl	$10, %esi
	movq	%rbp, %rdi
	call	*48(%rax)
	movl	%eax, %esi
	jmp	.L22
.L55:
	movq	%rax, %rdi
	call	_ZNSo5flushEv@PLT
	addq	$12, %rbx
	subq	$1, %r14
	cmpq	$-1, %r14
	je	.L56
.L23:
	movl	$1, (%rbx)
	movl	$2, 4(%rbx)
	movl	$3, 8(%rbx)
	movl	$8, %edx
	movq	%r15, %rsi
	movq	%r12, %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
.LEHE9:
	jmp	.L57
.L56:
	movl	$28, %edi
.LEHB10:
	call	_Znam@PLT
.LEHE10:
	movq	%rax, 8(%rsp)
	movq	$5, (%rax)
	addq	$8, %rax
	movq	%rax, (%rsp)
	movq	%rax, %r14
	movl	$4, %r12d
	leaq	.LC3(%rip), %r15
	leaq	_ZSt4cout(%rip), %rbp
	jmp	.L27
.L61:
	movq	0(%rbp), %rax
	movq	-24(%rax), %rax
	movq	240(%rbp,%rax), %rbx
	testq	%rbx, %rbx
	je	.L58
	cmpb	$0, 56(%rbx)
	je	.L25
	movzbl	67(%rbx), %esi
.L26:
	movsbl	%sil, %esi
	movq	%rbp, %rdi
.LEHB11:
	call	_ZNSo3putEc@PLT
	jmp	.L59
.L58:
	call	_ZSt16__throw_bad_castv@PLT
.L44:
	endbr64
	movq	%rax, %rbp
	movl	$4, %eax
	subq	%r12, %rax
	movq	(%rsp), %rcx
	leaq	(%rcx,%rax,4), %rbx
.L40:
	movq	(%rsp), %rax
	cmpq	%rax, %rbx
	je	.L39
	subq	$4, %rbx
	movq	%rbx, %rdi
	call	_ZN12MySmallClassD1Ev
	jmp	.L40
.L25:
	movq	%rbx, %rdi
	call	_ZNKSt5ctypeIcE13_M_widen_initEv@PLT
	movq	(%rbx), %rax
	movl	$10, %esi
	movq	%rbx, %rdi
	call	*48(%rax)
	movl	%eax, %esi
	jmp	.L26
.L59:
	movq	%rax, %rdi
	call	_ZNSo5flushEv@PLT
	subq	$1, %r12
	addq	$4, %r14
	cmpq	$-1, %r12
	je	.L60
.L27:
	movl	$1, (%r14)
	movl	$10, %edx
	movq	%r15, %rsi
	movq	%rbp, %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
.LEHE11:
	jmp	.L61
.L60:
	movq	-8(%r13), %rax
	leaq	0(,%rax,4), %r15
	leaq	0(%r13,%r15), %r12
	cmpq	%r12, %r13
	je	.L28
	leaq	.LC0(%rip), %r14
	leaq	_ZSt4cout(%rip), %rbp
	jmp	.L32
.L62:
	call	_ZSt16__throw_bad_castv@PLT
.L30:
	movq	%rbx, %rdi
	call	_ZNKSt5ctypeIcE13_M_widen_initEv@PLT
	movq	(%rbx), %rax
	movl	$10, %esi
	movq	%rbx, %rdi
	call	*48(%rax)
	movl	%eax, %esi
.L31:
	movsbl	%sil, %esi
	movq	%rbp, %rdi
	call	_ZNSo3putEc@PLT
	movq	%rax, %rdi
	call	_ZNSo5flushEv@PLT
	cmpq	%r12, %r13
	je	.L28
.L32:
	subq	$4, %r12
	movl	$10, %edx
	movq	%r14, %rsi
	movq	%rbp, %rdi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	movq	0(%rbp), %rax
	movq	-24(%rax), %rax
	movq	240(%rbp,%rax), %rbx
	testq	%rbx, %rbx
	je	.L62
	cmpb	$0, 56(%rbx)
	je	.L30
	movzbl	67(%rbx), %esi
	jmp	.L31
.L36:
	movl	$68, %esi
	movq	8(%rsp), %rdi
	call	_ZdaPvm@PLT
	movq	%rbp, %rdi
.LEHB12:
	call	_Unwind_Resume@PLT
.L39:
	movl	$28, %esi
	movq	8(%rsp), %rdi
	call	_ZdaPvm@PLT
	movq	%rbp, %rdi
	call	_Unwind_Resume@PLT
.LEHE12:
.L28:
	leaq	8(%r15), %rsi
	leaq	-8(%r13), %rdi
	call	_ZdaPvm@PLT
	movl	$0, %eax
	addq	$24, %rsp
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE2069:
	.section	.gcc_except_table,"a",@progbits
.LLSDA2069:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE2069-.LLSDACSB2069
.LLSDACSB2069:
	.uleb128 .LEHB0-.LFB2069
	.uleb128 .LEHE0-.LEHB0
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB1-.LFB2069
	.uleb128 .LEHE1-.LEHB1
	.uleb128 .L41-.LFB2069
	.uleb128 0
	.uleb128 .LEHB2-.LFB2069
	.uleb128 .LEHE2-.LEHB2
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB3-.LFB2069
	.uleb128 .LEHE3-.LEHB3
	.uleb128 .L41-.LFB2069
	.uleb128 0
	.uleb128 .LEHB4-.LFB2069
	.uleb128 .LEHE4-.LEHB4
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB5-.LFB2069
	.uleb128 .LEHE5-.LEHB5
	.uleb128 .L42-.LFB2069
	.uleb128 0
	.uleb128 .LEHB6-.LFB2069
	.uleb128 .LEHE6-.LEHB6
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB7-.LFB2069
	.uleb128 .LEHE7-.LEHB7
	.uleb128 .L42-.LFB2069
	.uleb128 0
	.uleb128 .LEHB8-.LFB2069
	.uleb128 .LEHE8-.LEHB8
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB9-.LFB2069
	.uleb128 .LEHE9-.LEHB9
	.uleb128 .L43-.LFB2069
	.uleb128 0
	.uleb128 .LEHB10-.LFB2069
	.uleb128 .LEHE10-.LEHB10
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB11-.LFB2069
	.uleb128 .LEHE11-.LEHB11
	.uleb128 .L44-.LFB2069
	.uleb128 0
	.uleb128 .LEHB12-.LFB2069
	.uleb128 .LEHE12-.LEHB12
	.uleb128 0
	.uleb128 0
.LLSDACSE2069:
	.text
	.size	main, .-main
	.hidden	DW.ref.__gxx_personality_v0
	.weak	DW.ref.__gxx_personality_v0
	.section	.data.rel.local.DW.ref.__gxx_personality_v0,"awG",@progbits,DW.ref.__gxx_personality_v0,comdat
	.align 8
	.type	DW.ref.__gxx_personality_v0, @object
	.size	DW.ref.__gxx_personality_v0, 8
DW.ref.__gxx_personality_v0:
	.quad	__gxx_personality_v0
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
