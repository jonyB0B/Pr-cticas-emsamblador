.data
	str: .asciiz "introduce nodo : "
	espacio: .asciiz "\n"
.text
main:
	la $a0, str
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	move $a0, $v0
	li $a1, 0
	jal create
	
	move $s0, $v0 #apunta al primer nodo de la pila mi cima esta en v0 del create
	#move $s1, $v0
	li $t0,1
bucle:
	bne $t0,3,insertar #cuando es 3 continuo
	move $a0,$s0 #cima $s0 -> a0
	jal print
	li $v0, 10
	syscall
	
insertar:
	la $a0, str
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	move $a0, $s0 #cima
	move $a1, $v0 #nuevo nodo 
	jal push
	move $s0, $v0 #ultimo nodo en $s0 cima
	addi $t0, $t0,1
	b   bucle
create:
	subu $sp, $sp, 32
	sw $ra, 20($sp)
	sw $fp, 16($sp)
	addiu $fp, $sp, 28
	sw $a0, 0($fp)
	sw $a1, -4($fp)
	
	li $a0, 8
	li $v0,9
	syscall
	
	lw $a0, 0($fp)
	lw $a1, -4($fp)
	sw $a0, 0($v0) #valor
	sw $a1, 4($v0) #puntero
	
	lw $ra, 20($sp)
	lw $fp, 16($sp)
	addiu $sp, $sp,32
	jr $ra
push:
	subu $sp, $sp, 32
	sw $ra, 20($sp)
	sw $fp, 16($sp)
	addiu $fp, $sp, 28
	sw $a0, 0($fp)
	sw $a1, -4($fp) #guardo el nuevo en la pila
	
	lw $a0, -4($fp)#nuevo a a0
	li $a1, 0 #inicializo a cero para llamar a create
	jal create
	
	lw $a0, 0($fp) 
	sw $a0, 4($v0) #anterior
	
	lw $ra, 20($sp)
	lw $fp, 16($sp)
	addiu $sp, $sp, 32
	jr $ra

print:	
	subu $sp, $sp, 32
	sw $ra, 20($sp)
	sw $fp, 16($sp)
	addiu $fp, $sp, 28
	sw $a0, 0($fp) #cima
	
	lw $a0, 0($fp)
	lw $a0, 4($a0)
	beqz $a0, pintar
	jal print
	
pintar:
	lw $a0, 0($fp)
	lw $a0, 0($a0)
	li $v0,1
	syscall
	
	la $a0, espacio
	li $v0,4
	syscall
	
	lw $ra, 20($sp)
	lw $fp, 16($sp)
	addiu $sp, $sp, 32
	jr $ra
