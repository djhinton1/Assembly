# David Hinton (dah172)
# CS 447 6/6/19 Project 2


.data
simonList:	.space	400	# room for 100 ints
tones:		.word	1, 2, 4, 8 

.text

_main:	
	beq	$t9, 16, continue
	add	$t9, $zero, $zero
	j _main
	
	continue:	
	addi	$t8, $zero, 16
	add	$s0, $zero, $zero		# s0 is the counter (number of tones played so far / stored in simonList)
	add	$a0, $zero, $zero		# $a0 needs to be reset after end 

_start:
	jal	_playSequence
	jal	_newTone
	add	$s0, $s0, 1			# new count of tones played so far
	add	$a0, $zero, $s0			# argument for functions
	jal	_userPlay
	j	_start

_playSequence: add	$t0, $zero, $zero	# t0 will be our loop counter
	
	playTones:
	beq	$t0, $a0, seqReturn
	mul	$t1, $t0, 4			# multiply by 4 bytes to get index of next tone	
	la	$t1, simonList($t1)		# will get the address of the tone to be played
	lw	$t8, ($t1)			# will play a sound
	addi	$t0, $t0, 1
	j	playTones
	
	seqReturn:
	jr	$ra
	
_newTone:	add	$t7, $zero, $a0		# number of tones played so far
	addi	$a0, $zero, 5			# setup for random int generator
	addi	$a1, $zero, 4			# setup for random int generator
	addi	$v0, $zero, 42			# setup for random int generator
	syscall					# $a0 contains random number 0, 1, 2, or 3
	mul	$t0, $a0, 4			# multiply random int by 4 (bytes) to get address of random tone from .data ($s0 here, is acting as an index)
	la	$t0, tones($t0)			# this will get the address of a random tone using the random int generator 
	lw	$t8, ($t0)			# load value of 'tone' into t8 to change simon
	lw	$t0, ($t0)			# load value for programming purposes
	mul	$t7, $t7, 4			# multiply by 4 bytes to get where to store next tone
	sw	$t0, simonList($t7)		# the counter will be 1 more than the index needed so we must account for that. for example: there is ONE tone stored at tones[index ZERO].
	jr	$ra
			
_userPlay:
	add	$t0, $zero, $zero		# t0 is our counter again
	add	$t9, $zero, $zero
	
	
	userTones: 
	beq	$t9, $zero, userTones
	mul	$t1, $t0, 4			# multiply by 4 bytes to get index of next tone	
	la	$t1, simonList($t1)		# will get the address of the tone to be played
	lw	$t1, ($t1)			# get the tone
	bne	$t9, $t1, _endGame		# if user input does not equal the tone to be played, then end the game
	add	$t8, ,$zero, $t1		# play sound from user input
	addi	$t0, $t0, 1			# increment our counter
	beq	$t0, $a0, userReturn		# if we reach the end of the sequence then we should continue the game
	add	$t9, $zero, $zero		# otherwise we should continue guessing
	j	userTones
	
	userReturn:
	jr	$ra
	
_endGame:
	addi	$t8, $zero, 15
	add	$t0, $zero, $zero
	add	$t2, $zero, $zero
	
	clear:
	beq 	$t0, $a0, end
	mul	$t1, $t0, 4			# multiply by 4 bytes to get index of next tone	
	la	$t1, simonList($t1)		# will get the address of the tone to be played
	sw	$t2, ($t1)			# play sound from user input
	add	$t0, $t0, 1
	end:
	j	_main
	













