	.data
id: .quad	123456789

	.section	.rodata	
format:	.string	"%ld\n"	
true:	.string "True\n"
false:	.string "False\n"

	.text	
	.globl	main
	.type	main, @function	
main:
	pushq	%rbp		# save the old frame pointer
	movq	%rsp, %rbp	# create the new frame pointer

	movq	$id, %rbx	# load id into the bx register

	movq	$format, %rdi	# pass the format string as the first parameter of printf
	movq	(%rbx), %rsi	# pass the id as the second parameter of printf
	movq	$0, %rax	# zero the al register
	call	printf

	movb	1(%rbx), %cl	# copy the second byte of id into cl
	test	$1, %cl	# check wיhether said byte represents an odd number
	jne 	.odd	

# if the byte represents an even number, save id (mod 3)
.even:		
	movq	$0, %rdx
	movq	id, %rax
	movq	$3, %rcx
	divq	%rcx
	movq	%rdx, %rsi	# rsi = id % 3
	jmp		.l1

# otherwise, save 3*id
.odd:
	movq	id, %rsi
	leaq	(%rsi,%rsi,2), %rsi # rdi = 3*id
			
.l1: 
	movq	$format, %rdi
	movq	$0, %rax
	call	printf	# print the saved result

	movb 	(%rbx), %cl		# copy the first byte of id into cl
	movb 	2(%rbx), %ch	# copy the third byte of id into ch
	xorb	%cl, %ch	# xor the two bytes, and save the result in ch
	mov		$127, %ah 
	cmpb	%ah, %ch	# check if the xored result is greater than or equal to 127
	jbe 	.less 

.greater:
	movq	$true, %rdi
	jmp		.l2

.less:
	movq	$false, %rdi

.l2: nop
	movq	$0, %rax
	call	printf		# print True or False according to the case

	movb 	3(%rbx), %cl # copy the forth byte of id into cl
	movq 	$0, %rsi	# initialize rsi to zero, to later use it as a counter 
	movq 	$0, %rax	# initialzie rax to zero, for both comparison reasons and printf usage

.while_loop:
	test	$1, %cl		# check whether the first bit of cl is set
	je		.l3
	inc		%rsi 	# if it is, increase the counting register by 1

.l3:  
	cmpb 	%al, %cl	# check if we've finished counting
	je 		.l4

	shrb	%cl		# right shift the number
	jmp 	.while_loop
	
.l4: 
	movq	$format, %rdi
	call 	printf

	movq	$0, %rax	# return value is zero.ller function.
	movq	%rbp, %rsp	# restore the old stack pointer - release all used memory.
	popq	%rbp		# restore old frame pointer (the caller function frame).
	ret		# return to caller function (OS).
