#simple divide:

.text

_divide:
addi	$a0, $zero, 20
addi	$a1, $zero, 2

add	$t0, $zero, $zero	# position
add	$t1, $zero, $a0		# dividend 
add	$t2, $zero, $a1		# divisor 
addi	$s0, $zero, 0		# quotient
add	$s1, $zero, $t0		# remainder

			
leftShift:	andi	$t9, $t2, 0x80000000		# looking to see if there is a 1 in the most significant bit 
		bne	$t9, $zero, start_divide	# if divisor is set (to the left) correctly then we can move on, if not, then keep shifting:     
		addi	$t0, $t0, 1			# increment position (number of times we had to shift)
		sll	$t2, $t2, 1			# shift the divisor by 1
		j	leftShift			# 
		
start_divide:	sll	$s0, $s0, 1			# left shift quotient (result) by 1
		sltu	$t9, $t1, $t2			# if dividend (remainder) < divisor then branch (skip adding the 1 to quotient)
		beq	$t9, 1, skipAdd_divide		# otherwise: 
		subu	$t1, $t1, $t2			# dividend - divisor
		add	$s0, $s0, 1			# quotient + 1
		
skipAdd_divide:	srl	$t2, $t2, 1			# shift divisor right by 1
		addi	$t0, $t0, -1			# decrement position
		bgez	$t0, start_divide		# repeat while (position >= 0)
		
end_divide:	add	$s1, $zero, $t1			# $s1 = remainder
		jr	$ra				# return






#addi	$a0, $zero, 20
#addi	$a1, $zero, 2

#add	$t0, $zero, $a0		# dividend t1
#add	$t1, $zero, $a1		# divisor t2
#sll	$t1, $t1, 4
#addi	$s0, $zero, 0		# quotient
#add	$s1, $zero, $t0		# remainder

#loop:
#slt	$t2, $s1, $a1		# if the remainder is less than the divisor then we are finished
#beq	$t2, 1, done		# we are done
#sub	$s1, $s1, $t1		# remainder = remainder - divisor
#slt	$t2, $s1, $zero		
#beq	$t2, 0, shiftPlus	# if remainder is positive, then shift 1 into quotient via branch
#add	$s1, $s1, $t1		# return remainder to original value
#sll	$s0, $s0, 1		# left shift 0 into quotient
#srl	$t1, $t1, 1		# right shift divisor by 1
#j 	loop


#shiftPlus:
#sll	$s0, $s0, 1		# shift quitient to left
#addi	$s0, $s0, 1		# add 1
#srl	$t1, $t1, 1		# right shift divisor by 1
#j	loop

#done: nop