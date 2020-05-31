.text 
	lui $t0, 0x1001
	ori $t0, $t0, 0x0000
	addi $s0, $zero, 9		# $s0 = 9
	sb $s0, 0($t0)
	lb $s1, 0($t0)
	sb $s1, 4($t0)
	
	addi $t0, $t0, 4
	sb $s1, 4($t0)
	
	li $s0, 0x1234ABCD
	sw $s0, 0($t0)
	lb $s1, 0($t0)
	