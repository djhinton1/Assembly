# David Hinton (dah172)
# CS 447 6/20/19

.data
	sumTitle:	.asciiz	"Summation: sum(n)\n"
	integer_n:	.asciiz	"Please enter an integer (greater than or equal to 0): "
	sumResult:	.asciiz	"sum("
	powTitle:	.asciiz	"Power: pow(x,y)\n"
	integer_x:	.asciiz	"Please enter an integer for x (greater than or equal to 0): "
	integer_y:	.asciiz	"Please enter an integer for y (greater than or equal to 0): "
	powResult:	.asciiz "pow("
	comma:		.asciiz	","
	fTitle:		.asciiz	"Fibonacci: F(n)\n"
	fResult:	.asciiz	"F("
	isMsg:		.asciiz	") is "
	period:		.asciiz ".\n"
.text
	# Sum
	addi $v0, $zero, 4		# Syscall 4: Print string
	la   $a0, sumTitle		# Set $a0 to sumTitle
	syscall				# Print "Summation..."
	la   $a0, integer_n		# Set $a0 to integer_n
	syscall				# Print "Please..."
	addi $v0, $zero, 5		# Syscall 5: Read integer
	syscall				# Read an integer
	add  $s0, $zero, $v0		# $s0 is n
	add  $a0, $zero, $s0		# Set argument for _sum
	jal  _sum			# Call the _sum function
	add  $s1, $zero, $v0		# $s1 = sum(n)
	# Print result (sum)
	addi $v0, $zero, 4		# Syscall 4: Print string
	la   $a0, sumResult		# Set $a0 to sumResult
	syscall				# Print "sum("
	addi $v0, $zero, 1		# Syscall 1: Print integer
	add  $a0, $zero, $s0		# Set $a0 to n
	syscall				# Print n
	addi $v0, $zero, 4		# Syscall 4: Print string
	la   $a0, isMsg			# Set $a0 to isMsg
	syscall				# Print ") is "
	addi $v0, $zero, 1		# Syscall 1: Print integer
	add  $a0, $zero, $s1		# Set $a0 to result of sum
	syscall				# Print result
	addi $v0, $zero, 4		# Syscall 4: Print string
	la   $a0, period		# Set $a0 to period
	syscall				# Print ".\n"

	# Power
	addi $v0, $zero, 4		# Syscall 4: Print string
	la   $a0, powTitle		# Set $a0 to powTitle
	syscall				# Print "Summation..."
	la   $a0, integer_x		# Set $a0 to integer_x
	syscall				# Print "Please..."
	addi $v0, $zero, 5		# Syscall 5: Read integer
	syscall				# Read an integer
	add  $s0, $zero, $v0		# $s0 is x
	addi $v0, $zero, 4		# Syscall 4: Print string	
	la   $a0, integer_y		# Set $a0 to integer_y
	syscall				# Print "Please..."
	addi $v0, $zero, 5		# Syscall 5: Read integer
	syscall				# Read an integer
	add  $s1, $zero, $v0		# $s1 is y
	add  $a0, $zero, $s0		# Set argument x for _pow
	add  $a1, $zero, $s1		# Set argument y for _pow
	jal  _pow			# Call the _pow function
	add  $s2, $zero, $v0		# $s2 = pow(x,y)
	# Print result (pow)
	addi $v0, $zero, 4		# Syscall 4: Print string
	la   $a0, powResult		# Set $a0 to powResult
	syscall				# Print "pow("
	addi $v0, $zero, 1		# Syscall 1: Print integer
	add  $a0, $zero, $s0		# Set $a0 to x
	syscall				# Print x
	addi $v0, $zero, 4		# Syscal 4: Print string
	la   $a0, comma			# Set $a0 to comma
	syscall				# Print ","
	addi $v0, $zero, 1		# Syscall 1: Print integer
	add  $a0, $zero, $s1		# Set $a0 to y
	syscall				# Print y
	addi $v0, $zero, 4		# Syscall 4: Print string
	la   $a0, isMsg			# Set $a0 to isMsg
	syscall				# Print ") is "
	addi $v0, $zero, 1		# Syscall 1: Print integer
	add  $a0, $zero, $s2		# Set $a0 to result of pow
	syscall				# Print result
	addi $v0, $zero, 4		# Syscall 4: Print string
	la   $a0, period		# Set $a0 to period
	syscall				# Print ".\n"

	# Fibonacci
	addi $v0, $zero, 4		# Syscall 4: Print string
	la   $a0, fTitle		# Set $a0 to fTitle
	syscall				# Print "Fibonacci..."
	la   $a0, integer_n		# Set $a0 to integer_n
	syscall				# Print "Please..."
	addi $v0, $zero, 5		# Syscall 5: Read integer
	syscall				# Read an integer
	add  $s0, $zero, $v0		# $s0 is n
	add  $a0, $zero, $s0		# Set argument for _fibonacci
	jal  _fibonacci			# Call the _fabonacci function
	add  $s1, $zero, $v0		# $s1 = fibonacci(n)
	# Print result (fibonacci)
	addi $v0, $zero, 4		# Syscall 4: Print string
	la   $a0, fResult		# Set $a0 to sumResult
	syscall				# Print "F("
	addi $v0, $zero, 1		# Syscall 1: Print integer
	add  $a0, $zero, $s0		# Set $a0 to n
	syscall				# Print n
	addi $v0, $zero, 4		# Syscall 4: Print string
	la   $a0, isMsg			# Set $a0 to isMsg
	syscall				# Print ") is "
	addi $v0, $zero, 1		# Syscall 1: Print integer
	add  $a0, $zero, $s1		# Set $a0 to result of fibonacci
	syscall				# Print result
	addi $v0, $zero, 4		# Syscall 4: Print string
	la   $a0, period		# Set $a0 to period
	syscall				# Print ".\n"
	# Terminate Program
	addi $v0, $zero, 10		# Syscall 10: Terminate program
	syscall				# Terminate Program

# _sum
#
# Recursively calculate summation of a given number
#   sum(n) = n + sum(n - 1)
# where n >= 0 and sum(0) = 0.
#
# Argument:
#   $a0 - n
# Return Value:
#   $v0 = sum(n)
_sum:
	addi 	$sp, $sp, -8			# adjust the stack pointer for backing up registers
	sw 	$s0, 4($sp)			# back up $s0 to the stack
	sw	$ra, 0($sp)			# back up $ra to the stack
	add 	$s0, $zero, $a0			# put the argument value $a0 into the $s0 register
	beq 	$s0, $zero, addReturnZero	# if the argument is zero, then we need to return zero
						# if the argument is not zero then we need to do recursion on (arg - 1)
	addi	$a0, $s0, -1			# the new argument is $s0 - 1
	jal	_sum				# call ourself (_sum)
	add	$v0, $v0, $s0			# n + (n - 1) $s0 is the n and $v0 is the return value from (n - 1)
	j	addReturn			# return this value when done (not 0, i.e. skip zero part)
	
	addReturnZero:
	add 	$v0, $zero, $zero		# if the argument passed in is zero, then we can just return 0 (base case)
	
	addReturn:
	lw	$s0, 4($sp)			# pop off the stack
	lw	$ra, 0($sp)			# pop off the stack
	addi	$sp, $sp, 8			# return stack pointer to position before this function was called
	jr	$ra				# return

# _pow
#
# Recursively calculate x^y
#   x^y = x * (x^(y - 1))
# where x >= 0 and y >= 0
#
# Arguments:
#   - $a0 - x
#   - $a1 - y
# Return Value
#   - $v0 = x^y
_pow:
	addi 	$sp, $sp, -12			# adjust the stack pointer for backing up registers
	sw 	$s0, 8($sp)			# back up $s0 to the stack
	sw	$s1, 4($sp)			# back up $s1 to the stack
	sw	$ra, 0($sp)			# back up $ra to the stack
	add 	$s0, $zero, $a0			# put the argument value $a0, into the $s0 register
	add	$s1, $zero, $a1			# put the argument value $a1, into the $s1 register
	beq 	$s1, $zero, powReturnOne	# if the "y" argument is zero, then we need to return one
	beq	$s1, 1, powReturnOriginal	# if the "y" argument is one, then we need to return just x
						# if the argument is not zero then we need to do recursion on (arg - 1)
	addi	$a1, $s1, -1			# the new "y" argument is $s1 - 1
	jal	_pow				# call ourself (_pow)
	mul	$v0, $v0, $s0			# x * x ($s0 is the x and $v0 is the return value from (x * x))
	j	powReturn			# return this value when done (not 0, i.e. skip zero part)
	
	powReturnOriginal:
	add	$v0, $zero, $s0			# if the "y" argument is 1, then we return original
	j	powReturn
	
	powReturnOne:
	addi 	$v0, $zero, 1			# if the "y" argument passed in is zero, then we can just return 1 (base case)
	
	powReturn:
	lw	$s0, 8($sp)			# pop off the stack
	lw	$s1, 4($sp)			# pop off the stack
	lw	$ra, 0($sp)			# pop off the stack
	addi	$sp, $sp, 12			# return stack pointer to position before this function was called
	jr	$ra				# return
	

# _fibonacci
#
# Calculate a Fibonacci number (F) where
#   F(0) = 0
#   F(1) = 1
#   F(n) = F(n - 1) + F(n - 2)
# Argument:
#   $a0 = n
# Return Value:
#   $v0 = F(n)
_fibonacci:
	addi 	$sp, $sp, -12			# adjust the stack pointer for backing up registers
	sw 	$s0, 8($sp)			# back up $s0 to the stack
	sw	$s1, 4($sp)			# back up $s1 to the stack
	sw	$ra, 0($sp)			# back up $ra to the stack
	add 	$s0, $zero, $a0			# put the argument value $a0, into the $s0 register
	beq 	$s0, $zero, fibReturnZero	# if the "n" argument is zero, then we need to return zero
	beq	$s0, 1, fibReturnOne		# if the "n" argument is one, then we need to return one
						# if the argument is not zero then we need to do recursion on F(arg - 1) + F(arg - 2)
	addi	$a0, $s0, -1			# the new "n" argument is $s0 - 1
	jal	_fibonacci			# call ourself (_pow)
	add	$s1, $zero, $v0			# $t0 is F(n - 1)
	addi	$a0, $s0, -2			# the new "n" argument is $s0 - 2
	jal	_fibonacci			# call ourself (_pow)
	add	$v0, $s1, $v0			# F(n - 1) + F(n - 2) ($s0 and $v0 come from function calls above)
	j	fibReturn			# return this value when done (not 0, i.e. skip zero and 1 part)
	
	fibReturnZero:
	add	$v0, $zero, $zero		# if the "n" argument is 0, then we return zero
	j	fibReturn
	
	fibReturnOne:
	addi 	$v0, $zero, 1			# if the "n" argument passed in is one, then we can just return 1 (base case)
	
	fibReturn:
	lw	$s0, 8($sp)			# pop off the stack
	lw	$s1, 4($sp)			# pop off the stack
	lw	$ra, 0($sp)			# pop off the stack
	addi	$sp, $sp, 12			# return stack pointer to position before this function was called
	jr	$ra				# return				# return
	