# for the new project: similar to last project where we must be continuously checking for t9 to be not equal to zero
# need to create an array ( of size 100 ) to store the tones

# Argument:
#  $a0 - the n
# Return Value:
#  $v0 = n!
_factorial:
	addi 	$sp, $sp, -8
	sw 	$s0, 4($sp)
	sw	$ra, $0($sp)
	add 	$s0, $zero, $a0
	beq 	$s0, $zer0, factReturnOne
	# n is not zero, need to return n * (n-1)!
	add	$a0, $s0, -1			# n - 1
	jal	_factorial
	mul	$v0, $v0, $s0			# n * (n - 1)! $s0 is the n and $v0 is the return value from (n - 1)
	j	factReturn
factReturnOne:
	addi 	$v0, $zero, 1
factReturn:
	lw	$s0, 4($sp)
	lw	$ra, 0($sp)
	addi	$sp, $sp, 8
	jr	$ra
	
	
# ALU built from transistors (Arithmetic Logic Unit) transistors - electronic switch
# transistor on - allows flow from high voltage to low voltage (used to be very large because vaccume tubes were used as transistors)
# ^why computers took up large rooms
#
# multiplexer - allowes user to select which input goes to output input 


	