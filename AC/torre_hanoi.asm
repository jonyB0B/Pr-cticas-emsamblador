.data
	msg: .asciiz "calcular torre de hanoi de : "
	move1: .asciiz "Move disk "
	from: .asciiz " de torre "
 	to: .asciiz " a torre "
 	espacio: .asciiz "\n"
.text	
	la $a0 , msg
	li $v0,4
	syscall
	li $v0,5
	syscall
	
	move $a0, $v0
	li $a1,1 #torre de incio
	li $a2,2 #torre de fin
	li $a3,3 #torre extra
	jal hanoi
	
	li $v0,10
	syscall
	
hanoi:
	beqz $a0 ,return
	
	subu $sp, $sp, 32
	sw $ra, 20($sp)
	sw $fp, 16($sp)
	addiu $fp, $sp, 28 
	sw $a0, 0($fp)
	sw $a1, -4($fp)
	sw $a2,-16($fp)
	sw $a3, -20($fp)
	
	subi $a0,$a0,1
	lw $a2, -20($fp)
	lw $a3, -16($fp)
	jal hanoi
	
	
	lw $a1, -4($fp)#cargo los valores que tenia antes del jal hanoi start = start
	lw $a2, -16($fp)#cargo los valores que tenia antes del jal hanoi fin = fin 
	lw $a3, -20($fp)#cargo los valores que tenia antes del jal hanoi extra = extra
	
	la $a0 , move1
	li $v0,4
	syscall
	lw $a0, 0($fp)
	li $v0,1
	syscall
	
	la $a0 , from
	li $v0,4
	syscall
	lw $a0 ,-4($fp)
	li $v0,1
	syscall
	
	la $a0 , to
	li $v0,4
	syscall
	lw $a0 ,-16($fp)
	li $v0,1
	syscall
	
	la $a0 , espacio
	li $v0,4
	syscall
	
	lw $a0, 0($fp)
	subi $a0,$a0,1
	
	lw $a1, -20($fp) #cambias los valores start(a1) = extra 
	lw $a2,-16($fp)#finish(a2) = finish
	lw $a3, -4($fp)#extra(a3) = start
	jal hanoi
	
	lw $ra, 20($sp)
	lw $fp, 16($sp)
	addiu $sp, $sp, 32
	
return:
	jr $ra
	
	

	
	
