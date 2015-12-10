.data
	msg: .asciiz "calcular fibonacci de : "
.text	
	la $a0 , msg
	li $v0,4
	syscall
	li $v0,5
	syscall
	
	move $a0, $v0
	jal fibo
	
	move $a0, $v0
	li $v0,1
	syscall
	
	li $v0, 10
	syscall
	
fibo:
	subu $sp, $sp, 32
	sw $ra, 20($sp)
	sw $fp, 16($sp)
	addiu $fp, $sp, 28
	sw $a0, 0($fp)
	
	lw $v0, 0($fp)
	bgtz  $v0 fibo_recur
	li $v0,1
	j return
	
fibo_recur:
	lw $a0, 0($fp) #tengo un 2(por ejemplo porque han llamado a fibo de 2)
	subi $a0,$a0,1 #resto 1
	jal fibo #llamo a fibo de 1
	sw $v0, 4($fp) #almaceno el resultado de fibo1
	lw $a0, 0($fp) #cargo el 2 de nuevo
	subi $a0, $a0, 2 #le resto 2
	bltz $a0, return #si es menor que 0, fibo de -1 pues es que me habian llamado con fibo de 1 asique return y devuelvo en v0=1, y continuare por linea 37
	jal fibo #llamo a fibo de 0
	sw $v0, 8($fp) #almaceno el resultado de fibo 0
	lw $t1, 4($fp) #cargo el fibo 1
	lw $t2, 8($fp) #cargo el fibo 0
	add $v0, $t1, $t2 #sumo el resultado
	

return:
	lw $ra, 20($sp)
	lw $fp, 16($sp)
	addiu $sp, $sp, 32
	jr $ra