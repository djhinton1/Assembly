# David J. Hinton II
# CS 447 5/22/19

.data
	enterNumber:	.asciiz "\nEnter a number between 0 and 9: "
	lowNumber:	.asciiz "Your guess is too low. "
	highNumber:	.asciiz "Your guess is too high. "
	youLose:	.asciiz "You lose. The number was "
	youWin:		.asciiz "Congradulation! You Win! "
.text
	#getting the system time
	addi	$v0, $zero, 30
	syscall
	add 	$t0, $zero, $a0
	
	#setting RNG seed
	addi 	$v0, $zero, 40
	add 	$a0, $zero, $zero
	add 	$a1, $zero, $t0
	syscall
	
	#generating random number
	addi 	$v0, $zero, 42
	add 	$a0, $zero, $zero
	addi 	$a1, $zero, 9
	syscall
	add 	$s0, $zero, $a0
	
	guess:
		#prompting for guess
		la 	$a0, enterNumber
		addi 	$v0, $zero, 4
		syscall
	
		#collecting input
		addi 	$v0, $zero, 5
		syscall
		add 	$s1, $zero, $v0
	
		addi 	$t1, $t1, 1		#increment $t1 by 1
		beq $s1, $s0, win		#check to see if answer equal
		beq $t1, 3, lose		#check to see if user has reached guess limit
		
		slt $t2, $s1, $s0		#too high, too low?
		beq $t2, 1, lessThan
		
		#your number is too high
		la 	$a0, highNumber
		addi 	$v0, $zero, 4
		syscall
		
		j guess
	
	lessThan:
		#your number is too low
		la 	$a0, lowNumber
		addi 	$v0, $zero, 4
		syscall
		j guess
		
	win:
		#congrats, you win
		la 	$a0, youWin
		addi 	$v0, $zero, 4
		syscall
		
		addi 	$v0, $zero, 10		#terminating program
		syscall
		
	lose:
		#sorry, you lose
		la 	$a0, youLose
		addi 	$v0, $zero, 4
		syscall
	
		#printing an integer
		addi	$v0, $zero, 1
		add	$a0, $zero, $s0
		syscall
		
		addi 	$v0, $zero, 10		#terminating program
		syscall
	