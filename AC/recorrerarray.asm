.data
	valor: .word 1,2,3,4 #Defino array 4 palabras
	str: .ascii "Introduce un numero: " #Defino valor de variable suma
.text

main:
	la $a0,str
	li $v0,4
	syscall
	li $v0,5
	syscall
	move $t5,$v0
	
	move $t0,$zero # $t0&lt;-- "índice" con valor inicial 0
	li $t2,4 # numero de indices
	li $t1,3
	jal print
	li $v0,10
	syscall

print:
	mul $t3,$t0,$t2 # Multiplicamos el índice por 4
	#sw $t5,valor($t3) # sustityo por el string leido
	lw $t4,valor($t3)
	move $a0,$t4
	li $v0,1
	syscall #imprimimos
	add $t0,$t0,1 # índice=índice+1	
	ble $t0,$t1,print # Repite BUCLE si índice < 4
	jr $ra 
