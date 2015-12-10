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
	
	move $s0, $v0 #apunta al primer nodo de la lista
	move $s1, $v0 #s1 apunta al ultimo nodo de la lista
	li $t0,1
bucle:
	bne $t0,3,insertar #cuando es 3 imprimo, valor centinela
	move $a0,$s0
	jal print
	li $v0, 10
	syscall
insertar:
	la $a0, str
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	move $a0, $s1
	move $a1, $v0
	jal insert
	move $s1, $v0 #ultimo nodo en s1
	addi $t0, $t0,1
	b   bucle

create:
	subu $sp, $sp, 32
	sw $ra, 20($sp)
	sw $fp, 16($sp)
	addiu $fp, $sp, 28
	sw $a0, 0($fp)
	
	li $a0, 8  #numero de bytes
	li $v0,9  #guardo los bytes anteriores
	syscall
	
	lw $a0, 0($fp)
	sw $a0, 0($v0)
	sw $a1, 4($v0) #aqui si hago sw $a1, -4($v0) apunto al anterior
	
	lw $ra, 20($sp)
	lw $fp, 16($sp)
	addiu $sp, $sp,32
	jr $ra
	
insert:
	subu $sp, $sp, 32
	sw $ra, 20($sp)
	sw $fp, 16($sp)
	addiu $fp, $sp, 28
	sw $a0, 0($fp)
	sw $a1, -4($fp)
	
	lw $a0, -4($fp)
	li $a1, 0
	jal create
	
	lw $a0, 0($fp) #cima
	sw $v0, 4($a0) #siguiente
	
	lw $ra, 20($sp)
	lw $fp, 16($sp)
	addiu $sp, $sp, 32
	jr $ra
	
print:	
	subu $sp, $sp, 32
	sw $ra, 20($sp)
	sw $fp, 16($sp)
	addiu $fp, $sp, 28
	sw $a0, 0($fp)
	

	beqz $a0,fin
	lw $a0, 0($fp)
	lw $a0, 0($a0)
	li $v0, 1
	syscall
	
	la $a0, espacio
	li $v0,4
	syscall
	
	lw $a0, 0($fp)
	lw $a0, 4($a0)
	jal print
fin:
	lw $ra, 20($sp)
	lw $fp, 16($sp)
	addiu $sp, $sp, 32
	jr $ra
