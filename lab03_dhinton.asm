# David J. Hinton II
# CS 447 5/30/19

.data
	message1:	.asciiz "Please enter a positive integer: "
	message2:	.asciiz "Please enter another positive integer: "
	message3:	.asciiz "A nagative integer is not alllowed.\n" 
	times:		.asciiz " * "
	exp:		.asciiz	" ^ "
	equal:		.asciiz " = "
	newline:	.asciiz	"\n"
.text

# USER INPUT
#-------------------------------------------------------------------------------------
	input1:
		#prompting user for first numbers
		la 	$a0, message1
		addi 	$v0, $zero, 4
		syscall
	
		#collecting input 1
		addi 	$v0, $zero, 5
		syscall
		add 	$t0, $zero, $v0		#TOP NUMBER
		
		#checking that it is positive
		slt	$s0, $t0, $zero
		beq	$s0, 0, input2
		
		la 	$a0, message3
		addi 	$v0, $zero, 4
		syscall
		
		j input1
		
	input2:
		#prompting user for second number
		la 	$a0, message2
		addi 	$v0, $zero, 4
		syscall
	
		#collecting input 2
		addi 	$v0, $zero, 5
		syscall
		add 	$t1, $zero, $v0		#BOTTOM NUMBER
		add	$s1, $zero, $t1
		add	$s2, $zero, $s1
		
		#checking that it is positive
		slt	$s0, $t1, $zero
		beq	$s0, 0, initalize
		
		la 	$a0, message3
		addi 	$v0, $zero, 4
		syscall
		
		j input2
		
# MULTIPLICATION
#-------------------------------------------------------------------------------------
	initalize:
		#initalize variables
		add	$t2, $zero, $t0 	#PARTIAL RESULT (gets moved)
		li	$t3, 0			#RESULT
	
	start:
		beq 	$t1, $zero, terminate
		
		andi 	$t4, $t1, 1 
		beq	$t4, $zero, skipAdd
		
		add	$t3, $t3, $t2
		
	skipAdd:
		srl	$t1, $t1, 1
		sll	$t2, $t2, 1
		j start
	
	terminate:
		#printing an expression
		addi	$v0, $zero, 1
		add	$a0, $zero, $t0
		syscall
		la 	$a0, times
		addi 	$v0, $zero, 4
		syscall
		addi	$v0, $zero, 1
		add	$a0, $zero, $s1
		syscall
		la 	$a0, equal
		addi 	$v0, $zero, 4
		syscall
		addi	$v0, $zero, 1
		add	$a0, $zero, $t3
		syscall
		la 	$a0, newline
		addi 	$v0, $zero, 4
		syscall
# EXPONENT
#-------------------------------------------------------------------------------------
	initalize_e:
		#initalize variables
		add	$t1, $zero, $t0
		add	$t2, $zero, $t0 	#PARTIAL RESULT (gets moved)
		li	$t3, 0			#RESULT
	
	start_e:
		beq 	$t1, $zero, terminate_e
		
		andi 	$t4, $t1, 1 
		beq	$t4, $zero, skipAdd_e
		
		add	$t3, $t3, $t2
		
	skipAdd_e:
		srl	$t1, $t1, 1
		sll	$t2, $t2, 1
		j start_e
		
	continue_e:
		add	$t1, $zero, $t0
		add	$t2, $zero, $t3
		add	$t3, $zero, $zero
		j start_e
			
	
	terminate_e:
		subi	$s1, $s1, 1
		slti	$t4, $s1, 2
		beq	$t4, 0, continue_e
	
		#printing an expression
		addi	$v0, $zero, 1
		add	$a0, $zero, $t0
		syscall
		la 	$a0, exp
		addi 	$v0, $zero, 4
		syscall
		addi	$v0, $zero, 1
		add	$a0, $zero, $s2
		syscall
		la 	$a0, equal
		addi 	$v0, $zero, 4
		syscall
		addi	$v0, $zero, 1
		add	$a0, $zero, $t3
		syscall
		la 	$a0, newline
		addi 	$v0, $zero, 4
		syscall

	
