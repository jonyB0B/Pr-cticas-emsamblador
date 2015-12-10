	.data
buff1:	.space 1024
buff2:	.space 1024
orig:	.asciiz "Introduzca cadena origen: "
dest:	.asciiz "Introduzca cadena destino: "

	.text
main:	li $v0,4
	la $a0,orig
	syscall
	la $a0, buff1
	li $a1, 1024
	jal read_string
	li $v0,4
	la $a0,dest
	syscall
	la $a0, buff2
	li $a1, 1024
	jal read_string
	la $a0, buff2
	la $a1, buff1
	jal strcpy
	la $a0, buff2
	li $v0, 4
	syscall
	li $v0, 10
	syscall

read_string:	
	li $v0, 8
	syscall
	jr $ra

strlen:		
	move $s0, $a0
strlen_loop:	
	lb $t0, 0($s0)
	beq $t0, '\0', exit_strlen
	addi $s0, $s0, 1
	j strlen_loop
exit_strlen:
	subu $v0, $s0, $a0
	jr $ra

strcpy:	
	subu $sp, $sp, 32
	sw $ra, 8($sp)
	sw $fp, 4($sp)
	addiu $fp, $sp, 28
	move $s3, $a0
	move $s4, $a1
	move $a0, $s4
	jal strlen
	move $t0, $v0
strcpy_loop:
	beq $v0, 0, exit_strcpy
	lb $t1, 0($s4)
	sb $t1, 0($s3)
	addi $s3, $s3, 1
	addi $s4, $s4, 1
	addi $v0, $v0, -1
	j strcpy_loop
exit_strcpy:
	subu $v0, $s3, $t0
	lw $ra, 8($sp)
	lw $fp, 4($sp)
	addiu $sp, $sp, 32
	jr $ra