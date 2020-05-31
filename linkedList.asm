# ADT Bag (linked List)
.text
	addi	$a0, $zero, 12
	addi	$a1, $zero, 0		# null reference
	jal 	_newNode
	add	$s0, $zero, $v0
	
	addi	$a0, $zero, 9
	add	$a1, $zero, $s0
	jal	_newNode
	add	$s1, $zero, $v0

# _newNode
#
# Create a new node.
#
# Arguments:
#  $a0 - data to store
#  #a1 - the adress of the next node
# Return:
#  $v0 - the adress of this new node
_newNode:
	add	$t0, $zero, $a0		# $t0 is the data (int)
	add	$t1, $zero, $a1		# $t1, is the address of the next node
	# allocate memory for 8 bytes
	addi	$a0, $zero, 8		# ammount to allocate is 8 bytes
	addi 	$v0, $zero, 9	 	# Syscall 9: allocate memory
	syscall
	add	$t2, $zero, $v0		# $t2 is the address of the new node
	# put data and next node into the new node
	sw	$t0, 0($t2)		# store data
	sw	$t1, 4($t2)		# store next node location
	add 	$v0, $zero, $t2		# set return value
	jr	$ra			# return to caller
	
	
# _newBag
#
# Construct an empty bag.
#
# Arguments: None
# Return Value:
#  $v0 - the location of the new bag	
_newBag:
	addi 	$a0, $zero, 8
	addi 	$v0, $zero, 9		# Syscall 9: allocate memory
	syscall
	sw 	$zero, 0($v0)		# set first node to 0
	sw	$zero, 4($v0)		# set number of entries to 0
	jr	$ra			# return the address of the new bag
	
	
# _add
#
# Add new data into a given bag
#
# Arguments:
#  $a0 - the location of a bag
#  $a1 - the new data to add
# Return Value: None
_add:
	# back up $s registers and $ra
	addi	$sp, $sp, -20		#allocate memory on top of the stack
	sw	$s3, 16($sp)
	sw	$s2, 12($sp)
	sw	$s1, 8($sp)
	sw	$s0, 4($sp)
	sw	$ra, 0($sp)
	add	$s0, $zero, $a0		# $s0 is the location of the bag
	add	$s1, $zero, $a1		# $s1 is the data
	# _newNode(data, fisrt node)
	add	$a0, $zero, $s1		# set the data argument
	lw	$a1, 0($s0)		# set next node to first node
	jal	_newNode
	add	$s2, $zero, $v0		# location of the new node
	sw	$s2, 0($s0)		# set the first node to newNode
	lw	$s3, 4($s0)		# $s3 is the number of entries
	addi	$s3, $s3, 1		# entries ++
	sw	$s3, 4($s0)		# update number of entries
	# restore $s registers and $ra
	lw	$s3, 16($sp)
	lw	$s2, 12($sp)
	lw	$s1, 8($sp)
	lw	$s0, 4($sp)
	lw	$ra, 0($sp)
	addi	$sp, $sp, 20		#allocate memory on top of the stack
	jr	$ra
	
# _isEmpty
#		
# check if a given bag is empty
#
# Arguments:
#  $a0 - the location of the bag
# Return values:
#  $v0 - 1 if the bag is empty, 0 if the bag is not empty
_isEmpty:
	lw	$t0, 4($a0)		# $t0 is the number of entries
	beq	$t0, 0, isEmptyReturn1
	add	$v0, $zero, $zero
	j	isEmptyDone
isEmptyReturn1:
	addi	$v0, $zero, 1
isEmptyDone:
	jr	$ra
	
	
# _remove
#
# removes an item from the bag
#
# Arguments:
#  $a0 - the bag location from which to remove
# Return Value:
#  $v0 - the data that was removed
#	0 is returned if the bag is empty
_remove:
	addi	$sp, $sp, -24
	sw	$s4, 20($sp)
	sw	$s3, 16($sp)
	sw	$s2, 12($sp)
	sw	$s1, 8($sp)
	sw	$s0, 4($sp)
	sw	$ra, 0($sp)
	add	$s0, $zero, $a0		#location of the bag
	jal 	_isEmpty
	bne	$v0, $zero, removeReturnZero
	# the bag is not empty
	# get the data into a register
	lw	$s1, 0($s0)		# location of the first node
	lw	$s2, 0($s1)		# $s2 is the data to be removed
	lw	$s3, 4($s1)		# $s3 is the next node
	sw	$s3, 0($s0)		# firstNode = nextNote
	lw	$s4, 4($s0)		# s4 is the number of entries
	addi	$s4, $s4, -1		# no. entries--
	sw	$s4, 4($s0)		# update no. entries
	add	$v0, $zero, $s2		# set return value
	j	removeDone
	
removeReturnZero:
	add	$v0, $zero, $zero
removeDone:
	lw	$s4, 20($sp)
	lw	$s3, 16($sp)
	lw	$s2, 12($sp)
	lw	$s1, 8($sp)
	lw	$s0, 4($sp)
	lw	$ra, 0($sp)
	addi	$sp, $sp, 24
	jr	$ra
	

	


	

	
	
	