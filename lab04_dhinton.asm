# David Hinton (dah172)
# CS 447 6/5/19
.data
	numString:	.asciiz	"How many strings do you have?: "
	enterString:	.asciiz	"Please enter a string: "
	theString1:	.asciiz	"The string at index "
	theString2:	.asciiz	" is \""
	theString3:	.asciiz "\"\n"
	result1:	.asciiz "The index of the string \""
	result2:	.asciiz "\" is "
	result3:	.asciiz	".\n"
	notFound1:	.asciiz	"Could not find the string \""
	notFound2:	.asciiz "\".\n"
	nullTerminator:	.asciiz	"\0"
	buffer:		.space	100
.text
	# Ask for the number of strings
	addi $v0, $zero, 4		# Syscall 4: Print string
	la   $a0, numString		# Set the string to print to numString
	syscall				# Print "How many..."
	addi $v0, $zero, 5		# Syscall 5: Read integer
	syscall				# Read integer
	add  $s0, $zero, $v0		# $s0 is the number of strings
	# Allocate memory for an array of strings
	addi $v0, $zero, 9		# Syscall 9: Allocate memory
	sll  $a0, $s0, 2		# number of bytes = number of strings * 4
	syscall				# Allocate memeory
	add  $s1, $zero, $v0		# $s1 is the address of the array of strings
	# Loop n times reading strings
	add  $s2, $zero, $zero		# $s2 counter (0)
	add  $s3, $zero, $s1		# $s3 is the temporary address of the array of strings
	
readStringLoop:
	beq  $s2, $s0, readStringDone	# Check whether $s2 == number of strings
	add  $v0, $zero, 4		# Syscall 4: Print string
	la   $a0, enterString		# Set the string to print to enterString
	syscall				# Print "Please enter..."
	jal  _readString		# Call _readString function
	sw   $v0, 0($s3)		# Store the address of a string into the array of strings
	addi $s3, $s3, 4		# Increase the address of the array of strings by 4 (next element)
	addi $s2, $s2, 1		# Increase the counter by 1
	j    readStringLoop		# Go back to readStringLoop
readStringDone:
	# Print all strings
	add  $s2, $zero, $zero		# $s2 - counter (0)
	add  $s3, $zero, $s1		# $s3 is the temporary address of the array of strings
printStringLoop:
	beq  $s2, $s0, printStringDone	# Check whether $s2 == number of strings
	addi $v0, $zero, 4		# Syscall 4: Print string
	la   $a0, theString1		# Set the string to print to theString1
	syscall				# Print "The string..."
	addi $v0, $zero, 1		# Syscall 1: Print integer
	add  $a0, $zero, $s2		# Set the integer to print to counter (index)
	syscall				# Print the current index
	addi $v0, $zero, 4		# Syscall 4: Print string
	la   $a0, theString2		# Set the address of the string to print to theString2
	syscall				# Print " is ""
	lw   $a0, 0($s3)		# Set the address by loading the address from the array of string
	syscall				# Print the string
	la   $a0, theString3		# Set the address of the string to print to theString3
	syscall				# Print ""\n"
	addi $s3, $s3, 4		# Increase the address of the array of string by 4 (next element)
	addi $s2, $s2, 1		# Increase the counter by 1
	j    printStringLoop		# Go back to printStringLoop
printStringDone:
	addi $v0, $zero, 4		# Syscall 4: Print string
	la   $a0, enterString		# Set the address of the string to print to enterString
	syscall				# Print "Please enter..."
	jal  _readString			# Call the _readString function
	add  $s4, $zero, $v0		# $s4 is the address of a new string
	# Search for the index of a given string
	add  $s2 $zero, $zero		# $s2 - counter (0)
	add  $s3, $zero, $s1		# $s3 is the temporary address of the array of strings
	addi $s5, $zero, -1		# Set the initial result to -1
searchStringLoop:
	beq  $s2, $s0, searchStringDone	# Check whether $s2 == number of strings
	lw   $a0, 0($s3)		# $a0 is a string in the array of strings
	add  $a1, $zero, $s4		# $s1 is a string the a user just entered
	jal  _strCompare		# Call the _strCompare function
	beq  $v0, $zero, found		# Check whether the result is 0 (found)
	addi $s3, $s3, 4		# Increase the address by 4 (next element)
	addi $s2, $s2, 1		# Increase the counter by 1
	j    searchStringLoop		# Go back to searchStringLoop
found:
	add  $s5, $zero, $s2		# Set the result to counter
	# Print result
	addi $v0, $zero, 4		# Syscall 4: Print string
	la   $a0, result1		# Set the address of the string to print to result1
	syscall				# Print "The index ..."
	add  $a0, $zero, $s4		# Set the address of the string to print to the string that a user jsut entered
	syscall				# Print the string that a user just entered
	la   $a0, result2		# Set the address of the string to print to result2
	syscall				# Print " is "
	addi $v0, $zero, 1		# Syscall 1: Print integer
	add  $a0, $zero, $s5		# Set the integer to print
	syscall				# Print index
	addi $v0, $zero, 4		# Syscall 4: Print string
	la   $a0, result3		# Set the address of the string to print to result3
	syscall				# Print ".\n"
	j    terminate
searchStringDone:
	# Not found
	addi $v0, $zero, 4		# Syscall 4: Print string
	la   $a0, notFound1		# Set the address of the string to print to notFound1
	syscall				# Print "Could not..."
	add  $a0, $zero, $s4		# Set the address of the string to print to a new string
	syscall				# Print the new string
	la   $a0, notFound2		# Set the address of the string to print to notFound2
	syscall
terminate:
	addi $v0, $zero, 10		# Syscall 10: Terminate Program
	syscall				# Terminate Program
	
###############################################################################################################################		

# _readString
#
# Read a string from keyboard input using syscall # 5 where '\n' at
# the end will be eliminated. The input string will be stored in
# heap where a small region of memory has been allocated. The address
# of that memory is returned.
#
# Argument:
#   - None
# Return Value
#   - $v0: An address (in heap) of an input string
_readString:
	sub $sp, $sp, 4 		#pushing $ra onto the stack
	sw $ra, 0($sp)			#still pushing onto the stack
	la	$a0, buffer		#load bytespace address into argument $a0
	addi	$a1, $zero,  100	#load the input limit into argument $a1
	li	$v0, 8			#collect input
	syscall
	
	jal	_strLength		#get the length of the input ($a0 = buffer)
	la	$a1, buffer		#load string source address (buffer address) into $a1
	addi	$a0, $v0, 1		#number of bytes to allocate in the heap space (strLength + 1 for null terminator)
	li	$v0, 9			#allocate that space ($v0 = heap address)
	syscall
	
	add	$a0, $zero, $v0		#load destination space (from heap) into $a0
	jal	_strCopy		#copy string from buffer to allocated heap space
	lw $ra, 0($sp) 			#popping $ra off the stack
	addi $sp, $sp, 4
	jr   $ra
	
###############################################################################################################################		
		
# _strCompare
#
# Compare two null-terminated strings. If both strings are idendical,
# 0 will be returned. Otherwise, -1 will be returned.
#
# Arguments:
#   - $a0: an address of the first null-terminated string
#   - $a1: an address of the second null-terminated string
# Return Value
#   - $v0: 0 if both string are identical. Otherwise, -1
_strCompare:
	addi	$v0, $zero, 0
	loop_strCompare:	
		lb 	$t0, 0($a0)			#loading a letter of the first string
		lb	$t1, 0($a1)			#loading a letter of the second string
		bne	$t0, $t1, notEqual_strCompare	#if they're not equal then change return value to -1
		beq	$t0, 0, done_strCompare		#if we reach the null character (and they are equal) then we are done
		addi	$a0, $a0, 1			#move to the next byte (letter of first string)
		addi	$a1, $a1, 1			#move to the next byte (letter of second string)
		j 	loop_strCompare
	
	notEqual_strCompare:
		addi	$v0, $zero, -1			#change return value to -1 if the strings are not equal
	
	done_strCompare:	
		jr   	$ra
		
###############################################################################################################################			

# _strCopy
#
# Copy from a source string to a destination.
#
# Arguments:
#   - $a0: An address of a destination
#   - $a1: An address of a source
# Return Value:
#   None
_strCopy:
	loop_strCopy:
		lb	$t0, 0($a1)			#loading a letter of the string
		beq	$t0, 0x0000000A, done_strCopy	#branch if the letter ($t0) is the line feed character
		sb	$t0, 0($a0)			#stores the letter ($t0) in the destination location ($a0)
		addi	$a1, $a1, 1			#move to the next byte (the next letter to be copied)
		addi	$a0, $a0, 1			#move to the next byte (the address to store the next letter)
		j	loop_strCopy
		
	done_strCopy:
		lb	$t0, nullTerminator		#add the null character to the end of the destination string
		sb	$t0, 0($a0)
	jr   $ra
	
###############################################################################################################################	

# _strLength
#
# Measure the length of a null-terminated input string (number of characters).
#
# Argument:
#   - $a0: An address of a null-terminated string
# Return Value:
#   - $v0: An integer represents the length of the given string
_strLength:
		add	$t0, $zero, $zero		#$t0 is the count of the string length
	loop_strLength:	
		lb 	$t1, 0($a0)			#loading in a letter of the string
		beq	$t1, 0x0000000A, done_strLength	#branch if the letter ($t1) is the line feed character
		addi	$t0, $t0, 1			#increment the strLength counter
		addi	$a0, $a0, 1			#move to the next byte (the next letter)
		j 	loop_strLength
	
	done_strLength:
		add	$v0, $zero, $t0			#return the count ($t0)
	jr   $ra
