.data 
	msg1:	.asciiz	"abcdefghijklmnopqrstuvwxyz"
	msg2:	.asciiz	"abcdefghijklmnopprstuvwxyz"
	
.text
	addi	$a0, $zero, 0
	la	$t1, msg1
	la	$t2, msg2
loop:	
	lb 	$t3, 0($t1)
	lb	$t4, 0($t2)
	bne	$t3, $t4, notEqual
	beq	$t3, 0, done
	addi	$t1, $t1, 1
	addi	$t2, $t2, 1
	j 	loop
	
notEqual:
	addi	$a0, $zero, -1
	
done:	li	$v0, 1
	syscall
