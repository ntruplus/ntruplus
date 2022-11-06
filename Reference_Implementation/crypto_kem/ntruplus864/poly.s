	.file	"poly.c"
	.text
	.globl	poly_tobytes
	.type	poly_tobytes, @function
poly_tobytes:
.LFB0:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$0, -28(%rbp)
	jmp	.L2
.L5:
	movl	$0, -24(%rbp)
	jmp	.L3
.L4:
	movl	-24(%rbp), %eax
	sall	$6, %eax
	movl	%eax, %edx
	movl	-28(%rbp), %eax
	addl	%eax, %edx
	movq	-48(%rbp), %rax
	movslq	%edx, %rdx
	movzwl	(%rax,%rdx,2), %eax
	movw	%ax, -16(%rbp)
	movl	-24(%rbp), %eax
	sall	$6, %eax
	movl	%eax, %edx
	movl	-28(%rbp), %eax
	addl	%edx, %eax
	leal	16(%rax), %edx
	movq	-48(%rbp), %rax
	movslq	%edx, %rdx
	movzwl	(%rax,%rdx,2), %eax
	movw	%ax, -14(%rbp)
	movl	-24(%rbp), %eax
	sall	$6, %eax
	movl	%eax, %edx
	movl	-28(%rbp), %eax
	addl	%edx, %eax
	leal	32(%rax), %edx
	movq	-48(%rbp), %rax
	movslq	%edx, %rdx
	movzwl	(%rax,%rdx,2), %eax
	movw	%ax, -12(%rbp)
	movl	-24(%rbp), %eax
	sall	$6, %eax
	movl	%eax, %edx
	movl	-28(%rbp), %eax
	addl	%edx, %eax
	leal	48(%rax), %edx
	movq	-48(%rbp), %rax
	movslq	%edx, %rdx
	movzwl	(%rax,%rdx,2), %eax
	movw	%ax, -10(%rbp)
	movzwl	-16(%rbp), %ecx
	movl	-24(%rbp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$4, %eax
	movl	%eax, %edx
	movl	-28(%rbp), %eax
	addl	%edx, %eax
	addl	%eax, %eax
	movslq	%eax, %rdx
	movq	-40(%rbp), %rax
	addq	%rdx, %rax
	movl	%ecx, %edx
	movb	%dl, (%rax)
	movzwl	-16(%rbp), %eax
	sarw	$8, %ax
	movl	%eax, %esi
	movzwl	-14(%rbp), %eax
	sall	$4, %eax
	movl	%eax, %ecx
	movl	-24(%rbp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$4, %eax
	movl	%eax, %edx
	movl	-28(%rbp), %eax
	addl	%edx, %eax
	addl	%eax, %eax
	cltq
	leaq	1(%rax), %rdx
	movq	-40(%rbp), %rax
	addq	%rdx, %rax
	leal	(%rsi,%rcx), %edx
	movb	%dl, (%rax)
	movzwl	-14(%rbp), %eax
	sarw	$4, %ax
	movl	%eax, %ecx
	movl	-24(%rbp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$4, %eax
	movl	%eax, %edx
	movl	-28(%rbp), %eax
	addl	%edx, %eax
	addl	%eax, %eax
	cltq
	leaq	32(%rax), %rdx
	movq	-40(%rbp), %rax
	addq	%rdx, %rax
	movl	%ecx, %edx
	movb	%dl, (%rax)
	movzwl	-12(%rbp), %ecx
	movl	-24(%rbp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$4, %eax
	movl	%eax, %edx
	movl	-28(%rbp), %eax
	addl	%edx, %eax
	addl	%eax, %eax
	cltq
	leaq	33(%rax), %rdx
	movq	-40(%rbp), %rax
	addq	%rdx, %rax
	movl	%ecx, %edx
	movb	%dl, (%rax)
	movzwl	-12(%rbp), %eax
	sarw	$8, %ax
	movl	%eax, %esi
	movzwl	-10(%rbp), %eax
	sall	$4, %eax
	movl	%eax, %ecx
	movl	-24(%rbp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$4, %eax
	movl	%eax, %edx
	movl	-28(%rbp), %eax
	addl	%edx, %eax
	addl	%eax, %eax
	cltq
	leaq	64(%rax), %rdx
	movq	-40(%rbp), %rax
	addq	%rdx, %rax
	leal	(%rsi,%rcx), %edx
	movb	%dl, (%rax)
	movzwl	-10(%rbp), %eax
	sarw	$4, %ax
	movl	%eax, %ecx
	movl	-24(%rbp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$4, %eax
	movl	%eax, %edx
	movl	-28(%rbp), %eax
	addl	%edx, %eax
	addl	%eax, %eax
	cltq
	leaq	65(%rax), %rdx
	movq	-40(%rbp), %rax
	addq	%rdx, %rax
	movl	%ecx, %edx
	movb	%dl, (%rax)
	addl	$1, -24(%rbp)
.L3:
	cmpl	$12, -24(%rbp)
	jle	.L4
	addl	$1, -28(%rbp)
.L2:
	cmpl	$15, -28(%rbp)
	jle	.L5
	movl	$0, -20(%rbp)
	jmp	.L6
.L7:
	movl	-20(%rbp), %eax
	leal	832(%rax), %edx
	movq	-48(%rbp), %rax
	movslq	%edx, %rdx
	movzwl	(%rax,%rdx,2), %eax
	movw	%ax, -16(%rbp)
	movl	-20(%rbp), %eax
	leal	840(%rax), %edx
	movq	-48(%rbp), %rax
	movslq	%edx, %rdx
	movzwl	(%rax,%rdx,2), %eax
	movw	%ax, -14(%rbp)
	movl	-20(%rbp), %eax
	leal	848(%rax), %edx
	movq	-48(%rbp), %rax
	movslq	%edx, %rdx
	movzwl	(%rax,%rdx,2), %eax
	movw	%ax, -12(%rbp)
	movl	-20(%rbp), %eax
	leal	856(%rax), %edx
	movq	-48(%rbp), %rax
	movslq	%edx, %rdx
	movzwl	(%rax,%rdx,2), %eax
	movw	%ax, -10(%rbp)
	movzwl	-16(%rbp), %ecx
	movl	-20(%rbp), %eax
	addl	$624, %eax
	addl	%eax, %eax
	movslq	%eax, %rdx
	movq	-40(%rbp), %rax
	addq	%rdx, %rax
	movl	%ecx, %edx
	movb	%dl, (%rax)
	movzwl	-16(%rbp), %eax
	sarw	$8, %ax
	movl	%eax, %esi
	movzwl	-14(%rbp), %eax
	sall	$4, %eax
	movl	%eax, %edx
	movl	-20(%rbp), %eax
	addl	$624, %eax
	addl	%eax, %eax
	cltq
	leaq	1(%rax), %rcx
	movq	-40(%rbp), %rax
	addq	%rcx, %rax
	addl	%esi, %edx
	movb	%dl, (%rax)
	movzwl	-14(%rbp), %eax
	sarw	$4, %ax
	movl	%eax, %ecx
	movl	-20(%rbp), %eax
	addl	$624, %eax
	addl	%eax, %eax
	cltq
	leaq	16(%rax), %rdx
	movq	-40(%rbp), %rax
	addq	%rdx, %rax
	movl	%ecx, %edx
	movb	%dl, (%rax)
	movzwl	-12(%rbp), %ecx
	movl	-20(%rbp), %eax
	addl	$624, %eax
	addl	%eax, %eax
	cltq
	leaq	17(%rax), %rdx
	movq	-40(%rbp), %rax
	addq	%rdx, %rax
	movl	%ecx, %edx
	movb	%dl, (%rax)
	movzwl	-12(%rbp), %eax
	sarw	$8, %ax
	movl	%eax, %esi
	movzwl	-10(%rbp), %eax
	sall	$4, %eax
	movl	%eax, %edx
	movl	-20(%rbp), %eax
	addl	$624, %eax
	addl	%eax, %eax
	cltq
	leaq	32(%rax), %rcx
	movq	-40(%rbp), %rax
	addq	%rcx, %rax
	addl	%esi, %edx
	movb	%dl, (%rax)
	movzwl	-10(%rbp), %eax
	sarw	$4, %ax
	movl	%eax, %ecx
	movl	-20(%rbp), %eax
	addl	$624, %eax
	addl	%eax, %eax
	cltq
	leaq	33(%rax), %rdx
	movq	-40(%rbp), %rax
	addq	%rdx, %rax
	movl	%ecx, %edx
	movb	%dl, (%rax)
	addl	$1, -20(%rbp)
.L6:
	cmpl	$7, -20(%rbp)
	jle	.L7
	nop
	movq	-8(%rbp), %rax
	xorq	%fs:40, %rax
	je	.L8
	call	__stack_chk_fail@PLT
.L8:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	poly_tobytes, .-poly_tobytes
	.globl	poly_frombytes
	.type	poly_frombytes, @function
poly_frombytes:
.LFB1:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$0, -28(%rbp)
	jmp	.L10
.L13:
	movl	$0, -24(%rbp)
	jmp	.L11
.L12:
	movl	-24(%rbp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$4, %eax
	movl	%eax, %edx
	movl	-28(%rbp), %eax
	addl	%edx, %eax
	addl	%eax, %eax
	movslq	%eax, %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movb	%al, -14(%rbp)
	movl	-24(%rbp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$4, %eax
	movl	%eax, %edx
	movl	-28(%rbp), %eax
	addl	%edx, %eax
	addl	%eax, %eax
	cltq
	leaq	1(%rax), %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movb	%al, -13(%rbp)
	movl	-24(%rbp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$4, %eax
	movl	%eax, %edx
	movl	-28(%rbp), %eax
	addl	%edx, %eax
	addl	%eax, %eax
	cltq
	leaq	32(%rax), %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movb	%al, -12(%rbp)
	movl	-24(%rbp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$4, %eax
	movl	%eax, %edx
	movl	-28(%rbp), %eax
	addl	%edx, %eax
	addl	%eax, %eax
	cltq
	leaq	33(%rax), %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movb	%al, -11(%rbp)
	movl	-24(%rbp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$4, %eax
	movl	%eax, %edx
	movl	-28(%rbp), %eax
	addl	%edx, %eax
	addl	%eax, %eax
	cltq
	leaq	64(%rax), %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movb	%al, -10(%rbp)
	movl	-24(%rbp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$4, %eax
	movl	%eax, %edx
	movl	-28(%rbp), %eax
	addl	%edx, %eax
	addl	%eax, %eax
	cltq
	leaq	65(%rax), %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movb	%al, -9(%rbp)
	movzbl	-14(%rbp), %eax
	movl	-24(%rbp), %edx
	movl	%edx, %ecx
	sall	$6, %ecx
	movl	-28(%rbp), %edx
	addl	%ecx, %edx
	movzbl	%al, %ecx
	movq	-40(%rbp), %rax
	movslq	%edx, %rdx
	movw	%cx, (%rax,%rdx,2)
	movl	-24(%rbp), %eax
	sall	$6, %eax
	movl	%eax, %edx
	movl	-28(%rbp), %eax
	addl	%eax, %edx
	movq	-40(%rbp), %rax
	movslq	%edx, %rdx
	movzwl	(%rax,%rdx,2), %eax
	movl	%eax, %edx
	movzbl	-13(%rbp), %eax
	movzbl	%al, %eax
	sall	$8, %eax
	andw	$3840, %ax
	leal	(%rdx,%rax), %ecx
	movl	-24(%rbp), %eax
	sall	$6, %eax
	movl	%eax, %edx
	movl	-28(%rbp), %eax
	addl	%eax, %edx
	movq	-40(%rbp), %rax
	movslq	%edx, %rdx
	movw	%cx, (%rax,%rdx,2)
	movzbl	-13(%rbp), %eax
	shrb	$4, %al
	movl	%eax, %ecx
	movl	-24(%rbp), %eax
	sall	$6, %eax
	movl	%eax, %edx
	movl	-28(%rbp), %eax
	addl	%edx, %eax
	leal	16(%rax), %edx
	movzbl	%cl, %ecx
	movq	-40(%rbp), %rax
	movslq	%edx, %rdx
	movw	%cx, (%rax,%rdx,2)
	movl	-24(%rbp), %eax
	sall	$6, %eax
	movl	%eax, %edx
	movl	-28(%rbp), %eax
	addl	%edx, %eax
	leal	16(%rax), %edx
	movq	-40(%rbp), %rax
	movslq	%edx, %rdx
	movzwl	(%rax,%rdx,2), %eax
	movl	%eax, %edx
	movzbl	-12(%rbp), %eax
	movzbl	%al, %eax
	sall	$4, %eax
	leal	(%rdx,%rax), %ecx
	movl	-24(%rbp), %eax
	sall	$6, %eax
	movl	%eax, %edx
	movl	-28(%rbp), %eax
	addl	%edx, %eax
	leal	16(%rax), %edx
	movq	-40(%rbp), %rax
	movslq	%edx, %rdx
	movw	%cx, (%rax,%rdx,2)
	movzbl	-11(%rbp), %eax
	movl	-24(%rbp), %edx
	movl	%edx, %ecx
	sall	$6, %ecx
	movl	-28(%rbp), %edx
	addl	%ecx, %edx
	addl	$32, %edx
	movzbl	%al, %ecx
	movq	-40(%rbp), %rax
	movslq	%edx, %rdx
	movw	%cx, (%rax,%rdx,2)
	movl	-24(%rbp), %eax
	sall	$6, %eax
	movl	%eax, %edx
	movl	-28(%rbp), %eax
	addl	%edx, %eax
	leal	32(%rax), %edx
	movq	-40(%rbp), %rax
	movslq	%edx, %rdx
	movzwl	(%rax,%rdx,2), %eax
	movl	%eax, %edx
	movzbl	-10(%rbp), %eax
	movzbl	%al, %eax
	sall	$8, %eax
	andw	$3840, %ax
	leal	(%rdx,%rax), %ecx
	movl	-24(%rbp), %eax
	sall	$6, %eax
	movl	%eax, %edx
	movl	-28(%rbp), %eax
	addl	%edx, %eax
	leal	32(%rax), %edx
	movq	-40(%rbp), %rax
	movslq	%edx, %rdx
	movw	%cx, (%rax,%rdx,2)
	movzbl	-10(%rbp), %eax
	shrb	$4, %al
	movl	%eax, %ecx
	movl	-24(%rbp), %eax
	sall	$6, %eax
	movl	%eax, %edx
	movl	-28(%rbp), %eax
	addl	%edx, %eax
	leal	48(%rax), %edx
	movzbl	%cl, %ecx
	movq	-40(%rbp), %rax
	movslq	%edx, %rdx
	movw	%cx, (%rax,%rdx,2)
	movl	-24(%rbp), %eax
	sall	$6, %eax
	movl	%eax, %edx
	movl	-28(%rbp), %eax
	addl	%edx, %eax
	leal	48(%rax), %edx
	movq	-40(%rbp), %rax
	movslq	%edx, %rdx
	movzwl	(%rax,%rdx,2), %eax
	movl	%eax, %edx
	movzbl	-9(%rbp), %eax
	movzbl	%al, %eax
	sall	$4, %eax
	leal	(%rdx,%rax), %ecx
	movl	-24(%rbp), %eax
	sall	$6, %eax
	movl	%eax, %edx
	movl	-28(%rbp), %eax
	addl	%edx, %eax
	leal	48(%rax), %edx
	movq	-40(%rbp), %rax
	movslq	%edx, %rdx
	movw	%cx, (%rax,%rdx,2)
	addl	$1, -24(%rbp)
.L11:
	cmpl	$12, -24(%rbp)
	jle	.L12
	addl	$1, -28(%rbp)
.L10:
	cmpl	$15, -28(%rbp)
	jle	.L13
	movl	$0, -20(%rbp)
	jmp	.L14
.L15:
	movl	-20(%rbp), %eax
	addl	$624, %eax
	addl	%eax, %eax
	movslq	%eax, %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movb	%al, -14(%rbp)
	movl	-20(%rbp), %eax
	addl	$624, %eax
	addl	%eax, %eax
	cltq
	leaq	1(%rax), %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movb	%al, -13(%rbp)
	movl	-20(%rbp), %eax
	addl	$624, %eax
	addl	%eax, %eax
	cltq
	leaq	16(%rax), %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movb	%al, -12(%rbp)
	movl	-20(%rbp), %eax
	addl	$624, %eax
	addl	%eax, %eax
	cltq
	leaq	17(%rax), %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movb	%al, -11(%rbp)
	movl	-20(%rbp), %eax
	addl	$624, %eax
	addl	%eax, %eax
	cltq
	leaq	32(%rax), %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movb	%al, -10(%rbp)
	movl	-20(%rbp), %eax
	addl	$624, %eax
	addl	%eax, %eax
	cltq
	leaq	33(%rax), %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movb	%al, -9(%rbp)
	movzbl	-14(%rbp), %eax
	movl	-20(%rbp), %edx
	addl	$832, %edx
	movzbl	%al, %ecx
	movq	-40(%rbp), %rax
	movslq	%edx, %rdx
	movw	%cx, (%rax,%rdx,2)
	movl	-20(%rbp), %eax
	leal	832(%rax), %edx
	movq	-40(%rbp), %rax
	movslq	%edx, %rdx
	movzwl	(%rax,%rdx,2), %eax
	movl	%eax, %edx
	movzbl	-13(%rbp), %eax
	movzbl	%al, %eax
	sall	$8, %eax
	andw	$3840, %ax
	leal	(%rdx,%rax), %ecx
	movl	-20(%rbp), %eax
	leal	832(%rax), %edx
	movq	-40(%rbp), %rax
	movslq	%edx, %rdx
	movw	%cx, (%rax,%rdx,2)
	movzbl	-13(%rbp), %eax
	shrb	$4, %al
	movl	%eax, %ecx
	movl	-20(%rbp), %eax
	leal	840(%rax), %edx
	movzbl	%cl, %ecx
	movq	-40(%rbp), %rax
	movslq	%edx, %rdx
	movw	%cx, (%rax,%rdx,2)
	movl	-20(%rbp), %eax
	leal	840(%rax), %edx
	movq	-40(%rbp), %rax
	movslq	%edx, %rdx
	movzwl	(%rax,%rdx,2), %eax
	movl	%eax, %edx
	movzbl	-12(%rbp), %eax
	movzbl	%al, %eax
	sall	$4, %eax
	leal	(%rdx,%rax), %ecx
	movl	-20(%rbp), %eax
	leal	840(%rax), %edx
	movq	-40(%rbp), %rax
	movslq	%edx, %rdx
	movw	%cx, (%rax,%rdx,2)
	movzbl	-11(%rbp), %eax
	movl	-20(%rbp), %edx
	addl	$848, %edx
	movzbl	%al, %ecx
	movq	-40(%rbp), %rax
	movslq	%edx, %rdx
	movw	%cx, (%rax,%rdx,2)
	movl	-20(%rbp), %eax
	leal	848(%rax), %edx
	movq	-40(%rbp), %rax
	movslq	%edx, %rdx
	movzwl	(%rax,%rdx,2), %eax
	movl	%eax, %edx
	movzbl	-10(%rbp), %eax
	movzbl	%al, %eax
	sall	$8, %eax
	andw	$3840, %ax
	leal	(%rdx,%rax), %ecx
	movl	-20(%rbp), %eax
	leal	848(%rax), %edx
	movq	-40(%rbp), %rax
	movslq	%edx, %rdx
	movw	%cx, (%rax,%rdx,2)
	movzbl	-10(%rbp), %eax
	shrb	$4, %al
	movl	%eax, %ecx
	movl	-20(%rbp), %eax
	leal	856(%rax), %edx
	movzbl	%cl, %ecx
	movq	-40(%rbp), %rax
	movslq	%edx, %rdx
	movw	%cx, (%rax,%rdx,2)
	movl	-20(%rbp), %eax
	leal	856(%rax), %edx
	movq	-40(%rbp), %rax
	movslq	%edx, %rdx
	movzwl	(%rax,%rdx,2), %eax
	movl	%eax, %edx
	movzbl	-9(%rbp), %eax
	movzbl	%al, %eax
	sall	$4, %eax
	leal	(%rdx,%rax), %ecx
	movl	-20(%rbp), %eax
	leal	856(%rax), %edx
	movq	-40(%rbp), %rax
	movslq	%edx, %rdx
	movw	%cx, (%rax,%rdx,2)
	addl	$1, -20(%rbp)
.L14:
	cmpl	$7, -20(%rbp)
	jle	.L15
	nop
	movq	-8(%rbp), %rax
	xorq	%fs:40, %rax
	je	.L16
	call	__stack_chk_fail@PLT
.L16:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	poly_frombytes, .-poly_frombytes
	.globl	poly_ntt
	.type	poly_ntt, @function
poly_ntt:
.LFB2:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-16(%rbp), %rdx
	movq	-8(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	ntt@PLT
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	poly_ntt, .-poly_ntt
	.globl	poly_invntt
	.type	poly_invntt, @function
poly_invntt:
.LFB3:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-16(%rbp), %rdx
	movq	-8(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	invntt@PLT
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	poly_invntt, .-poly_invntt
	.globl	poly_basemul
	.type	poly_basemul, @function
poly_basemul:
.LFB4:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	%rdx, -40(%rbp)
	movl	$0, -4(%rbp)
	jmp	.L20
.L21:
	movl	-4(%rbp), %eax
	addl	$143, %eax
	movl	%eax, %eax
	leaq	(%rax,%rax), %rdx
	leaq	zetas(%rip), %rax
	movzwl	(%rdx,%rax), %eax
	movswl	%ax, %ecx
	movq	-40(%rbp), %rsi
	movl	-4(%rbp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	addl	%eax, %eax
	movl	%eax, %eax
	addq	%rax, %rax
	leaq	(%rsi,%rax), %rdi
	movq	-32(%rbp), %rsi
	movl	-4(%rbp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	addl	%eax, %eax
	movl	%eax, %eax
	addq	%rax, %rax
	addq	%rax, %rsi
	movq	-24(%rbp), %r8
	movl	-4(%rbp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	addl	%eax, %eax
	movl	%eax, %eax
	addq	%rax, %rax
	addq	%r8, %rax
	movq	%rdi, %rdx
	movq	%rax, %rdi
	call	basemul@PLT
	movl	-4(%rbp), %eax
	addl	$143, %eax
	movl	%eax, %eax
	leaq	(%rax,%rax), %rdx
	leaq	zetas(%rip), %rax
	movzwl	(%rdx,%rax), %eax
	negl	%eax
	movswl	%ax, %ecx
	movq	-40(%rbp), %rsi
	movl	-4(%rbp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	addl	%eax, %eax
	movl	%eax, %eax
	addq	$3, %rax
	addq	%rax, %rax
	leaq	(%rsi,%rax), %rdi
	movq	-32(%rbp), %rsi
	movl	-4(%rbp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	addl	%eax, %eax
	movl	%eax, %eax
	addq	$3, %rax
	addq	%rax, %rax
	addq	%rax, %rsi
	movq	-24(%rbp), %r8
	movl	-4(%rbp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	addl	%eax, %eax
	movl	%eax, %eax
	addq	$3, %rax
	addq	%rax, %rax
	addq	%r8, %rax
	movq	%rdi, %rdx
	movq	%rax, %rdi
	call	basemul@PLT
	addl	$1, -4(%rbp)
.L20:
	cmpl	$143, -4(%rbp)
	jbe	.L21
	nop
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4:
	.size	poly_basemul, .-poly_basemul
	.globl	poly_baseinv
	.type	poly_baseinv, @function
poly_baseinv:
.LFB5:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movl	$0, -4(%rbp)
	movl	$0, -8(%rbp)
	jmp	.L23
.L24:
	movl	-8(%rbp), %eax
	addl	$143, %eax
	movl	%eax, %eax
	leaq	(%rax,%rax), %rdx
	leaq	zetas(%rip), %rax
	movzwl	(%rdx,%rax), %eax
	movswl	%ax, %ecx
	movq	-32(%rbp), %rsi
	movl	-8(%rbp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	addl	%eax, %eax
	movl	%eax, %eax
	addq	%rax, %rax
	addq	%rax, %rsi
	movq	-24(%rbp), %rdi
	movl	-8(%rbp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	addl	%eax, %eax
	movl	%eax, %eax
	addq	%rax, %rax
	addq	%rdi, %rax
	movl	%ecx, %edx
	movq	%rax, %rdi
	call	baseinv@PLT
	addl	%eax, -4(%rbp)
	movl	-8(%rbp), %eax
	addl	$143, %eax
	movl	%eax, %eax
	leaq	(%rax,%rax), %rdx
	leaq	zetas(%rip), %rax
	movzwl	(%rdx,%rax), %eax
	negl	%eax
	movswl	%ax, %ecx
	movq	-32(%rbp), %rsi
	movl	-8(%rbp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	addl	%eax, %eax
	movl	%eax, %eax
	addq	$3, %rax
	addq	%rax, %rax
	addq	%rax, %rsi
	movq	-24(%rbp), %rdi
	movl	-8(%rbp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	addl	%eax, %eax
	movl	%eax, %eax
	addq	$3, %rax
	addq	%rax, %rax
	addq	%rdi, %rax
	movl	%ecx, %edx
	movq	%rax, %rdi
	call	baseinv@PLT
	addl	%eax, -4(%rbp)
	addl	$1, -8(%rbp)
.L23:
	cmpl	$143, -8(%rbp)
	jbe	.L24
	movl	-4(%rbp), %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE5:
	.size	poly_baseinv, .-poly_baseinv
	.globl	poly_reduce
	.type	poly_reduce, @function
poly_reduce:
.LFB6:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movl	$0, -4(%rbp)
	jmp	.L27
.L28:
	movq	-24(%rbp), %rax
	movl	-4(%rbp), %edx
	movslq	%edx, %rdx
	movzwl	(%rax,%rdx,2), %eax
	cwtl
	movl	%eax, %edi
	call	fqred16@PLT
	movq	-24(%rbp), %rdx
	movl	-4(%rbp), %ecx
	movslq	%ecx, %rcx
	movw	%ax, (%rdx,%rcx,2)
	addl	$1, -4(%rbp)
.L27:
	cmpl	$863, -4(%rbp)
	jle	.L28
	nop
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	poly_reduce, .-poly_reduce
	.globl	poly_freeze
	.type	poly_freeze, @function
poly_freeze:
.LFB7:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	poly_reduce
	movl	$0, -4(%rbp)
	jmp	.L30
.L31:
	movq	-24(%rbp), %rax
	movl	-4(%rbp), %edx
	movslq	%edx, %rdx
	movzwl	(%rax,%rdx,2), %eax
	cwtl
	movl	%eax, %edi
	call	fqcsubq@PLT
	movq	-24(%rbp), %rdx
	movl	-4(%rbp), %ecx
	movslq	%ecx, %rcx
	movw	%ax, (%rdx,%rcx,2)
	addl	$1, -4(%rbp)
.L30:
	cmpl	$863, -4(%rbp)
	jle	.L31
	nop
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	poly_freeze, .-poly_freeze
	.globl	poly_add
	.type	poly_add, @function
poly_add:
.LFB8:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	%rdx, -40(%rbp)
	movl	$0, -4(%rbp)
	jmp	.L33
.L34:
	movq	-32(%rbp), %rax
	movl	-4(%rbp), %edx
	movslq	%edx, %rdx
	movzwl	(%rax,%rdx,2), %eax
	movl	%eax, %ecx
	movq	-40(%rbp), %rax
	movl	-4(%rbp), %edx
	movslq	%edx, %rdx
	movzwl	(%rax,%rdx,2), %eax
	addl	%ecx, %eax
	movl	%eax, %ecx
	movq	-24(%rbp), %rax
	movl	-4(%rbp), %edx
	movslq	%edx, %rdx
	movw	%cx, (%rax,%rdx,2)
	addl	$1, -4(%rbp)
.L33:
	cmpl	$863, -4(%rbp)
	jle	.L34
	nop
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	poly_add, .-poly_add
	.globl	poly_sub
	.type	poly_sub, @function
poly_sub:
.LFB9:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	%rdx, -40(%rbp)
	movl	$0, -4(%rbp)
	jmp	.L36
.L37:
	movq	-32(%rbp), %rax
	movl	-4(%rbp), %edx
	movslq	%edx, %rdx
	movzwl	(%rax,%rdx,2), %eax
	movl	%eax, %ecx
	movq	-40(%rbp), %rax
	movl	-4(%rbp), %edx
	movslq	%edx, %rdx
	movzwl	(%rax,%rdx,2), %eax
	subl	%eax, %ecx
	movl	%ecx, %eax
	movl	%eax, %ecx
	movq	-24(%rbp), %rax
	movl	-4(%rbp), %edx
	movslq	%edx, %rdx
	movw	%cx, (%rax,%rdx,2)
	addl	$1, -4(%rbp)
.L36:
	cmpl	$863, -4(%rbp)
	jle	.L37
	nop
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	poly_sub, .-poly_sub
	.globl	poly_triple
	.type	poly_triple, @function
poly_triple:
.LFB10:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)
	movl	$0, -4(%rbp)
	jmp	.L39
.L40:
	movq	-24(%rbp), %rax
	movl	-4(%rbp), %edx
	movslq	%edx, %rdx
	movzwl	(%rax,%rdx,2), %eax
	movl	%eax, %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	movl	%eax, %ecx
	movq	-24(%rbp), %rax
	movl	-4(%rbp), %edx
	movslq	%edx, %rdx
	movw	%cx, (%rax,%rdx,2)
	addl	$1, -4(%rbp)
.L39:
	cmpl	$863, -4(%rbp)
	jle	.L40
	nop
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	poly_triple, .-poly_triple
	.type	crepmod3, @function
crepmod3:
.LFB11:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, %eax
	movw	%ax, -4(%rbp)
	movzwl	-4(%rbp), %eax
	sarw	$15, %ax
	andw	$3457, %ax
	movl	%eax, %edx
	movzwl	-4(%rbp), %eax
	addl	%edx, %eax
	movw	%ax, -4(%rbp)
	movzwl	-4(%rbp), %eax
	subw	$1728, %ax
	movw	%ax, -4(%rbp)
	movzwl	-4(%rbp), %eax
	sarw	$15, %ax
	andw	$3457, %ax
	movl	%eax, %edx
	movzwl	-4(%rbp), %eax
	addl	%edx, %eax
	movw	%ax, -4(%rbp)
	movzwl	-4(%rbp), %eax
	subw	$1729, %ax
	movw	%ax, -4(%rbp)
	movzwl	-4(%rbp), %eax
	sarw	$8, %ax
	movl	%eax, %edx
	movzwl	-4(%rbp), %eax
	movzbl	%al, %eax
	addl	%edx, %eax
	movw	%ax, -4(%rbp)
	movzwl	-4(%rbp), %eax
	sarw	$4, %ax
	movl	%eax, %edx
	movzwl	-4(%rbp), %eax
	andl	$15, %eax
	addl	%edx, %eax
	movw	%ax, -4(%rbp)
	movzwl	-4(%rbp), %eax
	sarw	$2, %ax
	movl	%eax, %edx
	movzwl	-4(%rbp), %eax
	andl	$3, %eax
	addl	%edx, %eax
	movw	%ax, -4(%rbp)
	movzwl	-4(%rbp), %eax
	sarw	$2, %ax
	movl	%eax, %edx
	movzwl	-4(%rbp), %eax
	andl	$3, %eax
	addl	%edx, %eax
	movw	%ax, -4(%rbp)
	movzwl	-4(%rbp), %eax
	subl	$3, %eax
	movw	%ax, -4(%rbp)
	movswl	-4(%rbp), %eax
	addl	$1, %eax
	sarl	$15, %eax
	andl	$3, %eax
	movl	%eax, %edx
	movzwl	-4(%rbp), %eax
	addl	%edx, %eax
	movw	%ax, -4(%rbp)
	movzwl	-4(%rbp), %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	crepmod3, .-crepmod3
	.globl	poly_crepmod3
	.type	poly_crepmod3, @function
poly_crepmod3:
.LFB12:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movl	$0, -4(%rbp)
	jmp	.L44
.L45:
	movq	-32(%rbp), %rax
	movl	-4(%rbp), %edx
	movzwl	(%rax,%rdx,2), %eax
	cwtl
	movl	%eax, %edi
	call	crepmod3
	movq	-24(%rbp), %rdx
	movl	-4(%rbp), %ecx
	movw	%ax, (%rdx,%rcx,2)
	addl	$1, -4(%rbp)
.L44:
	cmpl	$863, -4(%rbp)
	jbe	.L45
	nop
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	poly_crepmod3, .-poly_crepmod3
	.globl	poly_cbd1
	.type	poly_cbd1, @function
poly_cbd1:
.LFB13:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movl	$0, -36(%rbp)
	jmp	.L47
.L54:
	movl	$0, -32(%rbp)
	jmp	.L48
.L53:
	movl	-36(%rbp), %eax
	sall	$5, %eax
	movslq	%eax, %rdx
	movl	-32(%rbp), %eax
	sall	$2, %eax
	cltq
	addq	%rax, %rdx
	movq	-64(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, %rdi
	call	load32_littleendian@PLT
	movl	%eax, -44(%rbp)
	movl	-36(%rbp), %eax
	sall	$5, %eax
	movslq	%eax, %rdx
	movl	-32(%rbp), %eax
	sall	$2, %eax
	cltq
	addq	%rdx, %rax
	leaq	108(%rax), %rdx
	movq	-64(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, %rdi
	call	load32_littleendian@PLT
	movl	%eax, -40(%rbp)
	movl	$0, -28(%rbp)
	jmp	.L49
.L52:
	movl	$0, -24(%rbp)
	jmp	.L50
.L51:
	movl	-44(%rbp), %eax
	andl	$1, %eax
	movl	%eax, %edx
	movl	-40(%rbp), %eax
	andl	$1, %eax
	movl	%edx, %ecx
	subl	%eax, %ecx
	movl	-36(%rbp), %eax
	sall	$4, %eax
	movl	%eax, %edx
	movl	-24(%rbp), %eax
	addl	%edx, %eax
	leal	0(,%rax,8), %edx
	movl	-32(%rbp), %eax
	addl	%edx, %eax
	leal	(%rax,%rax), %edx
	movl	-28(%rbp), %eax
	addl	%eax, %edx
	movq	-56(%rbp), %rax
	movslq	%edx, %rdx
	movw	%cx, (%rax,%rdx,2)
	shrl	-44(%rbp)
	shrl	-40(%rbp)
	addl	$1, -24(%rbp)
.L50:
	cmpl	$15, -24(%rbp)
	jle	.L51
	addl	$1, -28(%rbp)
.L49:
	cmpl	$1, -28(%rbp)
	jle	.L52
	addl	$1, -32(%rbp)
.L48:
	cmpl	$7, -32(%rbp)
	jle	.L53
	addl	$1, -36(%rbp)
.L47:
	cmpl	$2, -36(%rbp)
	jle	.L54
	movl	$0, -20(%rbp)
	jmp	.L55
.L60:
	movl	-20(%rbp), %eax
	sall	$2, %eax
	cltq
	leaq	96(%rax), %rdx
	movq	-64(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, %rdi
	call	load32_littleendian@PLT
	movl	%eax, -44(%rbp)
	movl	-20(%rbp), %eax
	sall	$2, %eax
	cltq
	leaq	204(%rax), %rdx
	movq	-64(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, %rdi
	call	load32_littleendian@PLT
	movl	%eax, -40(%rbp)
	movl	$0, -16(%rbp)
	jmp	.L56
.L59:
	movl	$0, -12(%rbp)
	jmp	.L57
.L58:
	movl	-44(%rbp), %eax
	andl	$1, %eax
	movl	%eax, %edx
	movl	-40(%rbp), %eax
	andl	$1, %eax
	movl	%edx, %ecx
	subl	%eax, %ecx
	movl	-12(%rbp), %eax
	addl	$192, %eax
	leal	(%rax,%rax), %edx
	movl	-20(%rbp), %eax
	addl	%edx, %eax
	leal	(%rax,%rax), %edx
	movl	-16(%rbp), %eax
	addl	%eax, %edx
	movq	-56(%rbp), %rax
	movslq	%edx, %rdx
	movw	%cx, (%rax,%rdx,2)
	shrl	-44(%rbp)
	shrl	-40(%rbp)
	addl	$1, -12(%rbp)
.L57:
	cmpl	$15, -12(%rbp)
	jle	.L58
	addl	$1, -16(%rbp)
.L56:
	cmpl	$1, -16(%rbp)
	jle	.L59
	addl	$1, -20(%rbp)
.L55:
	cmpl	$1, -20(%rbp)
	jle	.L60
	movq	-64(%rbp), %rax
	addq	$104, %rax
	movq	%rax, %rdi
	call	load32_littleendian@PLT
	movl	%eax, -44(%rbp)
	movq	-64(%rbp), %rax
	addq	$212, %rax
	movq	%rax, %rdi
	call	load32_littleendian@PLT
	movl	%eax, -40(%rbp)
	movl	$0, -8(%rbp)
	jmp	.L61
.L64:
	movl	$0, -4(%rbp)
	jmp	.L62
.L63:
	movl	-44(%rbp), %eax
	andl	$1, %eax
	movl	%eax, %edx
	movl	-40(%rbp), %eax
	andl	$1, %eax
	movl	%edx, %ecx
	subl	%eax, %ecx
	movl	-4(%rbp), %eax
	addl	$416, %eax
	leal	(%rax,%rax), %edx
	movl	-8(%rbp), %eax
	addl	%eax, %edx
	movq	-56(%rbp), %rax
	movslq	%edx, %rdx
	movw	%cx, (%rax,%rdx,2)
	shrl	-44(%rbp)
	shrl	-40(%rbp)
	addl	$1, -4(%rbp)
.L62:
	cmpl	$15, -4(%rbp)
	jle	.L63
	addl	$1, -8(%rbp)
.L61:
	cmpl	$1, -8(%rbp)
	jle	.L64
	nop
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE13:
	.size	poly_cbd1, .-poly_cbd1
	.globl	poly_sotp
	.type	poly_sotp, @function
poly_sotp:
.LFB14:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$320, %rsp
	movq	%rdi, -296(%rbp)
	movq	%rsi, -304(%rbp)
	movq	%rdx, -312(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$0, -268(%rbp)
	jmp	.L66
.L67:
	movl	-268(%rbp), %eax
	movslq	%eax, %rdx
	movq	-312(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %ecx
	movl	-268(%rbp), %eax
	movslq	%eax, %rdx
	movq	-304(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	xorl	%eax, %ecx
	movl	%ecx, %edx
	movl	-268(%rbp), %eax
	cltq
	movb	%dl, -224(%rbp,%rax)
	addl	$1, -268(%rbp)
.L66:
	cmpl	$107, -268(%rbp)
	jle	.L67
	movl	$108, -264(%rbp)
	jmp	.L68
.L69:
	movl	-264(%rbp), %eax
	movslq	%eax, %rdx
	movq	-312(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %edx
	movl	-264(%rbp), %eax
	cltq
	movb	%dl, -224(%rbp,%rax)
	addl	$1, -264(%rbp)
.L68:
	cmpl	$215, -264(%rbp)
	jle	.L69
	movl	$0, -260(%rbp)
	jmp	.L70
.L77:
	movl	$0, -256(%rbp)
	jmp	.L71
.L76:
	movl	-260(%rbp), %eax
	sall	$5, %eax
	movslq	%eax, %rdx
	movl	-256(%rbp), %eax
	sall	$2, %eax
	cltq
	addq	%rax, %rdx
	leaq	-224(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, %rdi
	call	load32_littleendian@PLT
	movl	%eax, -276(%rbp)
	movl	-260(%rbp), %eax
	sall	$5, %eax
	movslq	%eax, %rdx
	movl	-256(%rbp), %eax
	sall	$2, %eax
	cltq
	addq	%rdx, %rax
	leaq	108(%rax), %rdx
	leaq	-224(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, %rdi
	call	load32_littleendian@PLT
	movl	%eax, -272(%rbp)
	movl	$0, -252(%rbp)
	jmp	.L72
.L75:
	movl	$0, -248(%rbp)
	jmp	.L73
.L74:
	movl	-276(%rbp), %eax
	andl	$1, %eax
	movl	%eax, %edx
	movl	-272(%rbp), %eax
	andl	$1, %eax
	movl	%edx, %ecx
	subl	%eax, %ecx
	movl	-260(%rbp), %eax
	sall	$4, %eax
	movl	%eax, %edx
	movl	-248(%rbp), %eax
	addl	%edx, %eax
	leal	0(,%rax,8), %edx
	movl	-256(%rbp), %eax
	addl	%edx, %eax
	leal	(%rax,%rax), %edx
	movl	-252(%rbp), %eax
	addl	%eax, %edx
	movq	-296(%rbp), %rax
	movslq	%edx, %rdx
	movw	%cx, (%rax,%rdx,2)
	shrl	-276(%rbp)
	shrl	-272(%rbp)
	addl	$1, -248(%rbp)
.L73:
	cmpl	$15, -248(%rbp)
	jle	.L74
	addl	$1, -252(%rbp)
.L72:
	cmpl	$1, -252(%rbp)
	jle	.L75
	addl	$1, -256(%rbp)
.L71:
	cmpl	$7, -256(%rbp)
	jle	.L76
	addl	$1, -260(%rbp)
.L70:
	cmpl	$2, -260(%rbp)
	jle	.L77
	movl	$0, -244(%rbp)
	jmp	.L78
.L83:
	movl	-244(%rbp), %eax
	sall	$2, %eax
	cltq
	leaq	96(%rax), %rdx
	leaq	-224(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, %rdi
	call	load32_littleendian@PLT
	movl	%eax, -276(%rbp)
	movl	-244(%rbp), %eax
	sall	$2, %eax
	cltq
	leaq	204(%rax), %rdx
	leaq	-224(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, %rdi
	call	load32_littleendian@PLT
	movl	%eax, -272(%rbp)
	movl	$0, -240(%rbp)
	jmp	.L79
.L82:
	movl	$0, -236(%rbp)
	jmp	.L80
.L81:
	movl	-276(%rbp), %eax
	andl	$1, %eax
	movl	%eax, %edx
	movl	-272(%rbp), %eax
	andl	$1, %eax
	movl	%edx, %ecx
	subl	%eax, %ecx
	movl	-236(%rbp), %eax
	addl	$192, %eax
	leal	(%rax,%rax), %edx
	movl	-244(%rbp), %eax
	addl	%edx, %eax
	leal	(%rax,%rax), %edx
	movl	-240(%rbp), %eax
	addl	%eax, %edx
	movq	-296(%rbp), %rax
	movslq	%edx, %rdx
	movw	%cx, (%rax,%rdx,2)
	shrl	-276(%rbp)
	shrl	-272(%rbp)
	addl	$1, -236(%rbp)
.L80:
	cmpl	$15, -236(%rbp)
	jle	.L81
	addl	$1, -240(%rbp)
.L79:
	cmpl	$1, -240(%rbp)
	jle	.L82
	addl	$1, -244(%rbp)
.L78:
	cmpl	$1, -244(%rbp)
	jle	.L83
	leaq	-224(%rbp), %rax
	addq	$104, %rax
	movq	%rax, %rdi
	call	load32_littleendian@PLT
	movl	%eax, -276(%rbp)
	leaq	-224(%rbp), %rax
	addq	$212, %rax
	movq	%rax, %rdi
	call	load32_littleendian@PLT
	movl	%eax, -272(%rbp)
	movl	$0, -232(%rbp)
	jmp	.L84
.L87:
	movl	$0, -228(%rbp)
	jmp	.L85
.L86:
	movl	-276(%rbp), %eax
	andl	$1, %eax
	movl	%eax, %edx
	movl	-272(%rbp), %eax
	andl	$1, %eax
	movl	%edx, %ecx
	subl	%eax, %ecx
	movl	-228(%rbp), %eax
	addl	$416, %eax
	leal	(%rax,%rax), %edx
	movl	-232(%rbp), %eax
	addl	%eax, %edx
	movq	-296(%rbp), %rax
	movslq	%edx, %rdx
	movw	%cx, (%rax,%rdx,2)
	shrl	-276(%rbp)
	shrl	-272(%rbp)
	addl	$1, -228(%rbp)
.L85:
	cmpl	$15, -228(%rbp)
	jle	.L86
	addl	$1, -232(%rbp)
.L84:
	cmpl	$1, -232(%rbp)
	jle	.L87
	nop
	movq	-8(%rbp), %rax
	xorq	%fs:40, %rax
	je	.L88
	call	__stack_chk_fail@PLT
.L88:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE14:
	.size	poly_sotp, .-poly_sotp
	.globl	poly_sotp_inv
	.type	poly_sotp_inv, @function
poly_sotp_inv:
.LFB15:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$80, %rsp
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movq	%rdx, -72(%rbp)
	movl	$0, -36(%rbp)
	jmp	.L90
.L97:
	movl	$0, -32(%rbp)
	jmp	.L91
.L96:
	movl	-36(%rbp), %eax
	sall	$5, %eax
	movslq	%eax, %rdx
	movl	-32(%rbp), %eax
	sall	$2, %eax
	cltq
	addq	%rax, %rdx
	movq	-72(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, %rdi
	call	load32_littleendian@PLT
	movl	%eax, -48(%rbp)
	movl	-36(%rbp), %eax
	sall	$5, %eax
	movslq	%eax, %rdx
	movl	-32(%rbp), %eax
	sall	$2, %eax
	cltq
	addq	%rdx, %rax
	leaq	108(%rax), %rdx
	movq	-72(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, %rdi
	call	load32_littleendian@PLT
	movl	%eax, -44(%rbp)
	movl	$0, -40(%rbp)
	movl	$0, -28(%rbp)
	jmp	.L92
.L95:
	movl	$0, -24(%rbp)
	jmp	.L93
.L94:
	movl	-36(%rbp), %eax
	sall	$4, %eax
	movl	%eax, %edx
	movl	-24(%rbp), %eax
	addl	%edx, %eax
	leal	0(,%rax,8), %edx
	movl	-32(%rbp), %eax
	addl	%edx, %eax
	leal	(%rax,%rax), %edx
	movl	-28(%rbp), %eax
	addl	%eax, %edx
	movq	-64(%rbp), %rax
	movslq	%edx, %rdx
	movzwl	(%rax,%rdx,2), %eax
	movswl	%ax, %edx
	movl	-44(%rbp), %eax
	addl	%edx, %eax
	xorl	-48(%rbp), %eax
	andl	$1, %eax
	movl	%eax, %edx
	movl	-28(%rbp), %eax
	sall	$4, %eax
	movl	%eax, %ecx
	movl	-24(%rbp), %eax
	addl	%ecx, %eax
	movl	%eax, %ecx
	sall	%cl, %edx
	movl	%edx, %eax
	xorl	%eax, -40(%rbp)
	shrl	-48(%rbp)
	shrl	-44(%rbp)
	addl	$1, -24(%rbp)
.L93:
	cmpl	$15, -24(%rbp)
	jle	.L94
	addl	$1, -28(%rbp)
.L92:
	cmpl	$1, -28(%rbp)
	jle	.L95
	movl	-36(%rbp), %eax
	leal	0(,%rax,8), %edx
	movl	-32(%rbp), %eax
	addl	%edx, %eax
	sall	$2, %eax
	movslq	%eax, %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movl	-40(%rbp), %edx
	movb	%dl, (%rax)
	movl	-40(%rbp), %eax
	shrl	$8, %eax
	movl	%eax, %ecx
	movl	-36(%rbp), %eax
	leal	0(,%rax,8), %edx
	movl	-32(%rbp), %eax
	addl	%edx, %eax
	sall	$2, %eax
	cltq
	leaq	1(%rax), %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movl	%ecx, %edx
	movb	%dl, (%rax)
	movl	-40(%rbp), %eax
	shrl	$16, %eax
	movl	%eax, %ecx
	movl	-36(%rbp), %eax
	leal	0(,%rax,8), %edx
	movl	-32(%rbp), %eax
	addl	%edx, %eax
	sall	$2, %eax
	cltq
	leaq	2(%rax), %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movl	%ecx, %edx
	movb	%dl, (%rax)
	movl	-40(%rbp), %eax
	shrl	$24, %eax
	movl	%eax, %ecx
	movl	-36(%rbp), %eax
	leal	0(,%rax,8), %edx
	movl	-32(%rbp), %eax
	addl	%edx, %eax
	sall	$2, %eax
	cltq
	leaq	3(%rax), %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movl	%ecx, %edx
	movb	%dl, (%rax)
	addl	$1, -32(%rbp)
.L91:
	cmpl	$7, -32(%rbp)
	jle	.L96
	addl	$1, -36(%rbp)
.L90:
	cmpl	$2, -36(%rbp)
	jle	.L97
	movl	$0, -20(%rbp)
	jmp	.L98
.L103:
	movl	-20(%rbp), %eax
	sall	$2, %eax
	cltq
	leaq	96(%rax), %rdx
	movq	-72(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, %rdi
	call	load32_littleendian@PLT
	movl	%eax, -48(%rbp)
	movl	-20(%rbp), %eax
	sall	$2, %eax
	cltq
	leaq	204(%rax), %rdx
	movq	-72(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, %rdi
	call	load32_littleendian@PLT
	movl	%eax, -44(%rbp)
	movl	$0, -40(%rbp)
	movl	$0, -16(%rbp)
	jmp	.L99
.L102:
	movl	$0, -12(%rbp)
	jmp	.L100
.L101:
	movl	-12(%rbp), %eax
	addl	$192, %eax
	leal	(%rax,%rax), %edx
	movl	-20(%rbp), %eax
	addl	%edx, %eax
	leal	(%rax,%rax), %edx
	movl	-16(%rbp), %eax
	addl	%eax, %edx
	movq	-64(%rbp), %rax
	movslq	%edx, %rdx
	movzwl	(%rax,%rdx,2), %eax
	movswl	%ax, %edx
	movl	-44(%rbp), %eax
	addl	%edx, %eax
	xorl	-48(%rbp), %eax
	andl	$1, %eax
	movl	%eax, %edx
	movl	-16(%rbp), %eax
	sall	$4, %eax
	movl	%eax, %ecx
	movl	-12(%rbp), %eax
	addl	%ecx, %eax
	movl	%eax, %ecx
	sall	%cl, %edx
	movl	%edx, %eax
	xorl	%eax, -40(%rbp)
	shrl	-48(%rbp)
	shrl	-44(%rbp)
	addl	$1, -12(%rbp)
.L100:
	cmpl	$15, -12(%rbp)
	jle	.L101
	addl	$1, -16(%rbp)
.L99:
	cmpl	$1, -16(%rbp)
	jle	.L102
	movl	-20(%rbp), %eax
	addl	$24, %eax
	sall	$2, %eax
	movslq	%eax, %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movl	-40(%rbp), %edx
	movb	%dl, (%rax)
	movl	-40(%rbp), %eax
	shrl	$8, %eax
	movl	%eax, %ecx
	movl	-20(%rbp), %eax
	addl	$24, %eax
	sall	$2, %eax
	cltq
	leaq	1(%rax), %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movl	%ecx, %edx
	movb	%dl, (%rax)
	movl	-40(%rbp), %eax
	shrl	$16, %eax
	movl	%eax, %ecx
	movl	-20(%rbp), %eax
	addl	$24, %eax
	sall	$2, %eax
	cltq
	leaq	2(%rax), %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movl	%ecx, %edx
	movb	%dl, (%rax)
	movl	-40(%rbp), %eax
	shrl	$24, %eax
	movl	%eax, %ecx
	movl	-20(%rbp), %eax
	addl	$24, %eax
	sall	$2, %eax
	cltq
	leaq	3(%rax), %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movl	%ecx, %edx
	movb	%dl, (%rax)
	addl	$1, -20(%rbp)
.L98:
	cmpl	$1, -20(%rbp)
	jle	.L103
	movq	-72(%rbp), %rax
	addq	$104, %rax
	movq	%rax, %rdi
	call	load32_littleendian@PLT
	movl	%eax, -48(%rbp)
	movq	-72(%rbp), %rax
	addq	$212, %rax
	movq	%rax, %rdi
	call	load32_littleendian@PLT
	movl	%eax, -44(%rbp)
	movl	$0, -40(%rbp)
	movl	$0, -8(%rbp)
	jmp	.L104
.L107:
	movl	$0, -4(%rbp)
	jmp	.L105
.L106:
	movl	-4(%rbp), %eax
	addl	$416, %eax
	leal	(%rax,%rax), %edx
	movl	-8(%rbp), %eax
	addl	%eax, %edx
	movq	-64(%rbp), %rax
	movslq	%edx, %rdx
	movzwl	(%rax,%rdx,2), %eax
	movswl	%ax, %edx
	movl	-44(%rbp), %eax
	addl	%edx, %eax
	xorl	-48(%rbp), %eax
	andl	$1, %eax
	movl	%eax, %edx
	movl	-8(%rbp), %eax
	sall	$4, %eax
	movl	%eax, %ecx
	movl	-4(%rbp), %eax
	addl	%ecx, %eax
	movl	%eax, %ecx
	sall	%cl, %edx
	movl	%edx, %eax
	xorl	%eax, -40(%rbp)
	shrl	-48(%rbp)
	shrl	-44(%rbp)
	addl	$1, -4(%rbp)
.L105:
	cmpl	$15, -4(%rbp)
	jle	.L106
	addl	$1, -8(%rbp)
.L104:
	cmpl	$1, -8(%rbp)
	jle	.L107
	movq	-56(%rbp), %rax
	addq	$104, %rax
	movl	-40(%rbp), %edx
	movb	%dl, (%rax)
	movl	-40(%rbp), %eax
	shrl	$8, %eax
	movl	%eax, %edx
	movq	-56(%rbp), %rax
	addq	$105, %rax
	movb	%dl, (%rax)
	movl	-40(%rbp), %eax
	shrl	$16, %eax
	movl	%eax, %edx
	movq	-56(%rbp), %rax
	addq	$106, %rax
	movb	%dl, (%rax)
	movl	-40(%rbp), %eax
	shrl	$24, %eax
	movl	%eax, %edx
	movq	-56(%rbp), %rax
	addq	$107, %rax
	movb	%dl, (%rax)
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE15:
	.size	poly_sotp_inv, .-poly_sotp_inv
	.ident	"GCC: (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	 1f - 0f
	.long	 4f - 1f
	.long	 5
0:
	.string	 "GNU"
1:
	.align 8
	.long	 0xc0000002
	.long	 3f - 2f
2:
	.long	 0x3
3:
	.align 8
4:
