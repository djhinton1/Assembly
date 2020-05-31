# David Hinton (dah172)
# CS 447 6/6/19 Project 1

# $a0 holds operand "A"
# $a1 holds operand "B"

# $t9 represents a hold and is set to value 1
# calculator will continue when $t9 is set to 0

.text
	_main:
	wait:
		beq	$t9, $zero, wait			
		jal	_add
		jal	_subtract
		jal	_multiply
		jal	_divide		
		jal	_root
		add	$t9, $zero, $zero
		j	wait
	
####################################################################################################################################
				
	# _add
	#	
	# gets the sum of two Q8.8 numbers 
	# stores result in lower 16 bits of register $v0
	# 
	# Arguments (in Q8.8 format)
	#  - $a0: "A" input to be summed
	#  - $a1: "B" input to be summed 
	#
	# Return Value
	#  - $v0: lower holds value of (A + B)	
	
	_add:
		add	$t0, $a0, $a1			# $t0 = A + B
		and	$t0, $t0, 0x0000ffff		# ensures lower 16 bits are used and upper 16 bits are zeros (space for the subtract)
		add	$v0, $zero, $t0			# store in lower 16 bits of register
		jr	$ra
		
####################################################################################################################################

	# _subtract
	#
	# gets the difference of two Q8.8 numbers 
	# stores result in upper 16 bits of register $v0
	# 
	# Arguments (in Q8.8 format)
	#  - $a0: "A" input from which to subtract
	#  - $a1: "B" ammount to subtract from pervious input
	#
	# Return Value
	#  - $v0: upper holds value of (A - B) 
	
	_subtract:
		sub	$t0, $a0, $a1			# $t0 = A - B
		sll	$t0, $t0, 16			# shifting left as the subtraction result is to be stored in upper 16 bits of $v0
		add	$v0, $v0, $t0			# store result in upper 16 bits of $v0
		jr	$ra

####################################################################################################################################

	# _multiply
	#
	# multiplies two Q8.8 numbers 
	# stores result in lower 16 bits of register $v1
	# 
	# Arguments (in Q8.8 format)
	#  - $a0: "A" first number to be multiplied 
	#  - $a1: "B" second number to be multiplied
	#
	# Return Value
	#  - $v1: lower holds value of (A * B)
	
	_multiply:
		initalize_multiply:
			#initalize variables
			add	$t0, $zero, $a0 		# PARTIAL RESULT (gets moved left) (top number)
			add	$t1, $zero, $a1			# multiplier (gets moved right) (bottom number)
			li	$t2, 0				# RESULT
			li	$t5, 0				# no. of negative numbers (counter)
			
			slt	$t4, $t0, $zero			# determining if $t0 is a negative number
			bne	$t4, 1, checkInput_multiply	# if it is not, then move to the next number
			not	$t0, $t0			# flip bit by bit (turn from negative to positive)
			addi	$t0, $t0, 1			# add 1 (turn from negative to positive)
			addi	$t5, $t5, 1			# increment our "number of negatives" counter
			
		checkInput_multiply:
			slt	$t4, $t1, $zero			# determining if $t1 is a negative number
			bne	$t4, 1, start_multiply		# if it is not, then we can skip straight to multiplication
			not	$t1, $t1			# flip bit by bit (turn from negative to positive)
			addi	$t1, $t1, 1			# add 1 (turn from negative to positive)
			addi	$t5, $t5, 1			# increment our "number of negatives" counter
			
		start_multiply:
			beq 	$t1, $zero, checkSign_multiply	# if the multiplier = 0, then terminate; we are done
		
			andi 	$t3, $t1, 1 			# is the partiel result to be added to the result?
			beq	$t3, $zero, skipAdd_multiply	# if not, then skip the addition and shift respective inputs
		
			add	$t2, $t2, $t0			# add the partial result to the total result
		
		skipAdd_multiply:
			sll	$t0, $t0, 1			# shift partial result to the left
			srl	$t1, $t1, 1			# shift multilpier to the right
			j start_multiply
			
		checkSign_multiply:
			bne	$t5, 1, terminate_multiply
			not	$t2, $t2			# flip result bit by bit (turn from negative to positive)
			addi	$t2, $t2, 1			# add 1 to flipped result (turn from negative to positive)
			
		terminate_multiply:
			srl	$t2, $t2, 8			# convert to Q16.8 format
			and	$t2, $t2, 0x0000ffff		# ensures lower 16 bits are used and upper 16 bits are zeros (space for the divide)
			add	$v1, $zero, $t2
			jr	$ra
				
####################################################################################################################################			
	
	# _divide
	#
	# divides two Q8.8 numbers
	# stores result in upper 16 bits of register $v1
	# 
	# Arguments (in Q8.8 format)
	#  - $a0: "A" input from which to divide
	#  - $a1: "B" ammount to divide by
	#
	# Return Value
	#  - $v1: upper holds value of (A / B) 
	
	_divide:
		addi	$t0, $zero, 8		# position (we have to offset the position because we are in Q8.8 format)
		add	$t1, $zero, $a0		# dividend / remainder
		add	$t2, $zero, $a1		# divisor 
		addi	$t3, $zero, 0		# quotient
		li	$t4, 0			# no. of negative numbers (counter)
		
		check1Input_divide:
			slt	$t8, $t1, $zero			# determining if $t1 is a negative number
			bne	$t8, 1, check2Input_divide	# if it is not, then move to the next number
			not	$t1, $t1			# flip bit by bit (turn from negative to positive)
			addi	$t1, $t1, 1			# add 1 (turn from negative to positive)
			addi	$t4, $t4, 1			# increment our "number of negatives" counter
			
		check2Input_divide:
			slt	$t8, $t2, $zero			# determining if $t2 is a negative number
			bne	$t8, 1, leftShift_divide	# if it is not, then we can skip straight to multiplication
			not	$t2, $t2			# flip bit by bit (turn from negative to positive)
			addi	$t2, $t2, 1			# add 1 (turn from negative to positive)
			addi	$t4, $t4, 1			# increment our "number of negatives" counter

		leftShift_divide: # move until there is a one in most siginificant bit
			andi	$t8, $t2, 0x80000000		# looking to see if there is a 1 in the most significant bit 
			bne	$t8, $zero, start_divide	# if divisor is set (to the left) correctly then we can move on, if not, then keep shifting:     
			addi	$t0, $t0, 1			# increment position (number of times we had to shift)
			sll	$t2, $t2, 1			# shift the divisor by 1
			j	leftShift_divide			 
		
		start_divide:	
			sll	$t3, $t3, 1			# left shift quotient (result) by 1
			sltu	$t8, $t1, $t2			# if dividend (remainder) < divisor then branch (skip adding the 1 to quotient)
			beq	$t8, 1, skipAdd_divide		# otherwise: 
			subu	$t1, $t1, $t2			# dividend (remainder) - divisor
			add	$t3, $t3, 1			# quotient + 1
		
		skipAdd_divide:	
			srl	$t2, $t2, 1			# shift divisor right by 1
			addi	$t0, $t0, -1			# decrement position
			bgez	$t0, start_divide		# repeat while (position >= 0)
			
		checkSign_divide:
			bne	$t4, 1, end_divide
			not	$t3, $t3			# flip result bit by bit (turn from negative to positive)
			addi	$t3, $t3, 1			# add 1 to flipped result (turn from negative to positive)
			
		end_divide:
			sll	$t3, $t3, 16
			add	$v1, $v1, $t3
			jr	$ra				# return
					
		
####################################################################################################################################	

	# _root
	#
	# obtains the square root of a number
	#
	# Arguments:
	# - $a0: the number of which to take the square root
	#
	# Return Values:
	# - $a2: the result
	
	_root:
		add	$t0, $zero, $a0				# $t0 is "A"
		add	$t1, $zero, $zero			# $t1 is the result
		add	$t2, $zero, $zero			# $t2 is the current remainder 	
		add	$t3, $zero, $zero				# $t3 is a counter
		add	$t4, $zero, $zero			# $t4 is unused group of 2
		
		check1Input_root:
			slt	$t8, $t0, $zero			# determining if $t1 is a negative number
			bne	$t8, 1, leftShift_root		# if it is not, then move to the next number
			not	$t0, $t0			# flip bit by bit (turn from negative to positive)
			addi	$t0, $t0, 1			# add 1 (turn from negative to positive)
		
		leftShift_root: 				# move until there is a one in most siginificant bit
			beq	$t0, $zero, done_root		# square root of zero is zero
			andi	$t8, $t0, 0x80000000		# looking to see if there is a 1 in the most significant bit 
			andi	$t7, $t0, 0x40000000		# looking to see if there is a 1 in the penultimate most significant bit
			or	$t8, $t8, $t7			# if there is a one in the most significant 2 bits
			bne	$t8, $zero, start_root		# if "A" is set (to the left) correctly then we can move on, if not, then keep shifting:     
			addi	$t3, $t3, 2			# increment counter (number of bits we have shifted)
			sll	$t0, $t0, 2			# shift "A" to the left by 2 (next 2 bits)
			j	leftShift_root
	
		start_root:
			andi	$t4, $t8, 0xffffffff
			srl	$t4, $t4, 30			# shift group of 2 to lower bits
			sll	$t2, $t2, 2			# (current remainder * 4)
			add	$t2, $t2, $t4			# current remainder = (current remainder * 4) + unused group
			sll	$t5, $t1, 2			# temp = (result * 4)
			add	$t6, $zero, 1			# x = 1 (guess)
			add	$t7, $t6, $t5			# temp + x
			beq	$t2, $t7, continue_root		# if temp + x = current remainder, good we can continue
			slt	$t8, $t2, $t7			# will be 1 if (current remainder) < (temp + x) --> means that we need to change x to 0.
			beq	$t8, 0, continue_root
			add	$t7, $zero, $zero		# change ((temp + x) * x) to evaluate to 0
			add	$t6, $zero, $zero		# change x to 0
			
		continue_root:	
			sub	$t2, $t2, $t7			# current remainder = current remainder - ((temp + x) * x)
			sll	$t1, $t1, 1			# current result = current result * 2
			add	$t1, $t1, $t6			# result = (current result * 2) + x
			sll	$t0, $t0, 2			# shift "A" to the left by 2 (next 2 bits)
			addi	$t3, $t3, 2			# increment counter
			beq	$t3, 40, done_root		# 32 for going through entire bit set + 8 for shifting to 8.8 format		
			add	$t8, $zero, $t0
			j	start_root
			
		done_root:	
			add	$a2, $zero, $t1	
			jr	$ra
			
			
			
			
			
			
			
			
			
