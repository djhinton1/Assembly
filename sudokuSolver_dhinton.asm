# David Hinton (dah172)
# CS 447 7/8/19

.text
			
main:
	add	$a0, $zero, $zero	# offset from begining of cell to guess
	jal	_guess			# get solution
	addi	$v0, $zero, 10
	syscall


########################################################################################################
# _guess = guesses numbers to place into cells 
#
# Arguments:
#   $a0 - offset of cell to guess
#
# Registers used:
#   $s0 - offset from begining of cell to guess (saves in $a0)
#   $s1 - cell row number
#   $s2 - cell column number
#   $s3 - current number to test
#   $s4 - board location

_guess:
	# stack activation record
	add     $sp, $sp, -20		# initialize activation frame
	sw      $ra, 16($sp)		# back up return address
	sw      $s3, 12($sp)		# back up $s3 
	sw      $s2, 8($sp)		# back up $s2 
	sw      $s1, 4($sp)		# back up $s1 
	sw      $s0, 0($sp)		# back up $s0 

	add	$s0, $zero, $a0		# save argument in $s0 (offset from begining of cell to guess)
	add	$s4, $zero, $a1		# save argument in $s0 (location of board)
	beq	$s0, 81, guess_goodNumber 	# check to see if index (offset) is out of bounds // if it is, then we need to continue to next

	# get cell coordinates
	li	$s3, 9			# size of board
	div	$s0, $s3		# cell offset / board size
	mflo	$s1			# cell row number
	mfhi	$s2			# cell column number

	# check if cell is empty
	lb	$t0, 0xffff8000($s0)	# load current cell value
	beqz	$t0, guessLoop		# if empty, guess numbers
	addi	$a0, $s0, 1		# incrementing the offset
	jal	_guess			
	j	guessReturn		

	guessLoop:
		# check to seee if the number guessed works in the cell
		add	$a0, $zero, $s3		# number to check (going backwards from 9)
		add	$a1, $zero, $s1		# row number
		add	$a2, $zero, $s2		# column number
		jal	_check			
	
		bnez	$v0, guess_badNumber	# if the check failed then this number is not good for the box
		sb	$s3, 0xffff8000($s0)	# if it does work, then place this number in the cell permanently
	
		# Go on to the next cell
		addi	$a0, $s0, 1		# increment offset
		jal	_guess			# guess number for next cell
		beqz	$v0, guessReturn		# return from guess function (a number worked)

	guess_badNumber:
		subi	$s3, $s3, 1		# new number to test (decrement by 1)
		bnez	$s3, guessLoop		# test number
		sb	$zero, 0xffff8000($s0)	# place 0 into cell if nothing works in the cell
		li	$v0, 1			# store 1 as return value (number did not work)
		j	guessReturn		# return from guess function (no number worked)

	guess_goodNumber:
		move	$v0, $zero		# store 0 as return value (numkber worked in cell)

	guessReturn:
		# delete stack record
		lw	$s0, 0($sp)		
		lw	$s1, 4($sp)		
		lw	$s2, 8($sp)		
		lw	$s3, 12($sp)		
		lw	$ra, 16($sp)		
		addi	$sp, $sp, 20		
		jr	$ra			

########################################################################################################
# _check = check to make sure number guessed is allowed in the cell
#
# Arguments:
#   $a0 - guessed number to check
#   $a1 - cell row number
#   $a2 - cell column number

# Registers used:
#   t-registers

_check:
	addi	$t0, $zero, 9		# counter
	mul	$t1, $a1, $t0		# offset from the begining of the row-to-check first cell 
	
	checkRow:
		# check row
		lb	$t2, 0xffff8000($t1)	# number in current cell
		beq	$a0, $t2, checkFail	# found that the guessed number already exists in the row, so fail check
		addi	$t1, $t1, 1		# increment to next cell
		sub	$t0, $t0, 1		# decrement counter
		bnez	$t0, checkRow		# check next cell in row
		
		# if number passes the row check, we need to set up for column check
		add	$t1, $zero, $a2		# offset from the begining of the col-to-check first cell 
		
	checkCol:
		# check col
		lb	$t2, 0xffff8000($t1)	# number in current cell
		beq	$a0, $t2, checkFail	# found that the guessed number already exists in the col, so fail check
		addi	$t1, $t1, 9		# increment to next cell
		ble	$t1, 81, checkCol	# check next cell in col

		# if number passes the col check, we need to set up for box check
		div	$t0, $a1, 3		# row / 3
		mul	$t0, $t0, 27		# offset of the row
		div	$t1, $a2, 3		# col / 3
		mul	$t1, $t1, 3		# offset of the column
		add	$t1, $t0, $t1		# offset from the begining of the box-to-check first cell

		li	$t0, 3			# row counter
		li	$t3, 3			# col counter
		
	checkBox:
		# check box
		lb	$t2, 0xffff8000($t1)	# number in current cell
		beq	$a0, $t2, checkFail	# found that the guessed number already exists in the box, so fail check
		sub	$t3, $t3, 1		# decrement column counter
		beqz	$t3, check_endRow	# if this is the end of the box row, then we need to go to the next row in the box
		addi	$t1, $t1, 1		# if not, then increment to next cell
		j	checkBox		# check next cell in box
		
	check_endRow:
		addi	$t1, $t1, 7		# move to begining of next row
		addi	$t3, $zero, 3		# reinitialize col counter
		sub	$t0, $t0, 1		# decrement row counter
		bnez	$t0, checkBox		# continue if this is not the end of the entire box

		move	$v0, $zero		# store 0 in return value (good number)
		j	checkReturn		

	checkFail:
		li	$v0, 1			# store 1 in return value (bad number)

	checkReturn:
		jr	$ra                   

	
