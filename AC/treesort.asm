.data
	msg: .asciiz "nuevo nodo: "
	insertdere: .asciiz "voy insertar der"
	insertizqu: .asciiz "voy insertar izq"
	espacio: .asciiz "\n"
.text
	la $a0, msg
	li $v0 , 4
	syscall
	
	li $v0, 5
	syscall
	
	move $a0, $v0
	la $a1,($zero)
	la $a2,($zero)
	jal tree_node_create
	
	move $s0,$v0 #en s0 tengo el nodo raiz
	
in_loop:
	la $a0, msg
	li $v0 , 4
	syscall
	
	li $v0, 5
	syscall
	
	#move $s1, $v0#pongo en $s1 el nuevo numero a introducir(nose si es necesario)
	move $s2, $v0
	move $a0,$s0 #muevo a a0 el nodo raiz por si hay que pintarlo
	bnez $s2,  prueba2
	jal tree_print
	jal fin
prueba2:
	move $a0, $v0 #paso a insert el numero a insertar(val)
	move $a1, $s0 #paso a insert el primer nodo(root)
	jal tree_insert
	
	
	j in_loop
		
	
tree_insert:
	subu $sp, $sp, 32
	sw $ra, 16($sp)
	sw $fp, 20($sp)
	addiu $fp,$sp,28
	sw $a1, 0($fp) #guardo el nodo raiz para luego usarlo en el bucle
	
	la $a1,($zero)
	la $a2,($zero)
	jal tree_node_create
	
	sw $v0, -4($fp)
	lw $a1, 0($fp)#cargo en $a1 el nodo raiz
	
	#lw $a0, 0($a1) para comprobar que el nodo raiz que le paso es el correcto
	#li $v0,1
	#syscall
	
	move $t1, $a1 #nodo raiz en t1
	lw $t0, -4($fp)#nodo a insertar en t0
	bucle:
		lw $t2, 0($t1)#t2 es root_val(valor del nodo)
		lw $t3, 0($t0)#cargo en t3 el valor del nodo a introducir para compararlo
		bge $t3, $t2, subarbolder #si root_val < val
		ble $t3, $t2, subarbolizq  #si root_val > val
		subarbolder:
			lw $t4, 8($t1) #$t4 ahora es el subnodo derecho
			beqz $t4, insertder #si el nodo derecho es null, inserto
			#la $t4, 4($t1)
			move $t1, $t4 #si nodo derecho no esta vacio, ago que nodo derecho sea el root ahora para mirar sus subnodos
			j bucle
			
		subarbolizq:
			lw $t4, 4($t1)#$t4 ahora es el subnodo izquiero
			beqz $t4, insertizq #si el nodo derecho es null, inserto
			#la $t4, 8($t1)
			move $t1, $t4 #si nodo derecho no esta vacio, ago que nodo derecho sea el root ahora para mirar sus subnodos
			j bucle
			
		insertder:
			la $a0, insertdere
			li $v0,4
			syscall 
			lw $t3, -4($fp)
			sw $t3, 8($t1)
			
			lw $a0, 0($t1)
			li $v0, 1
			syscall
			
			lw $a0, 8($t1)
			lw $a0, 0($a0)
			li $v0, 1
			syscall
			
			lw $fp, 20($sp)
			lw $ra, 16($sp)
			addiu $sp, $sp, 32
			jr $ra
		
		insertizq:
			la $a0, insertizqu
			li $v0,4
			syscall 
			lw $t3, -4($fp)
			sw $t3, 4($t1)
			
			lw $a0, 0($t1)
			li $v0, 1
			syscall
			
			lw $a0, 4($t1)
			lw $a0, 0($a0)
			li $v0, 1
			syscall
			
			lw $fp, 20($sp)
			lw $ra, 16($sp)
			addiu $sp, $sp, 32
			jr $ra
		
	
tree_node_create:
	subu $sp, $sp, 32
	sw $ra, 16($sp)
	sw $fp, 20($sp)
	addiu $fp,$sp,28
	sw $a0, 0($fp)
	
	#li $v0, 1 pinto el numero del nodo que voy a crear para ver si lo hago bien
	#syscall
	
	li $a0,12
	li $v0,9
	syscall
	
	#falta comprobar si queda memoria
	lw $a0, 0($fp)

	sw $a0, 0($v0)
	sw $a1, 4($v0)
	sw $a2, 8($v0) 
	
	lw $fp, 20($sp)
	lw $ra, 16($sp)
	addiu $sp, $sp, 32
	jr $ra
	

tree_print:
	subu $sp, $sp, 32
	sw $ra, 16($sp)
	sw $fp, 20($sp)
	addiu $fp,$sp,28
	sw $a0, 0($fp)
	
	#lw $a0,0($fp)#aqui tengo la direccion de memoria del nodo raiz
	#lw $a0,0($fp)
	#lw $t1, 4($a0)#voy a mirar si el nodo por la izquierda esta a null
	#move $a0, $t1
	#li $v0, 1
	#syscall
	
	#la $a0, espacio
	#li $v0 , 4
	#syscall
	
	#lw $a0,0($fp)
	#lw $t2, 8($a0)#voy a mirar si el nodo por la derecha esta a null
	#move $a0, $t2
	#li $v0,1
	#syscall 
	
	lw $a0, 0($fp)
	lw $t1, 4($a0)#voy a mirar si el nodo por la izquierda esta a null
	
	beqz $t1, izqescero
	move $a0, $t1
	jal tree_print
izqescero:
	lw $a0,0($fp)
	lw $t2, 8($a0)#voy a mirar si el nodo por la derecha esta a null
	move $a0, $t2
	#li $v0,1
	#syscall 
	beqz $t2, derechaescero	
	jal tree_print
derechaescero:
	lw $a0, 0($fp)
	lw $a0, 0($a0)
	li $v0,1
	syscall 
	
	la $a0, espacio
	li $v0 , 4
	syscall
	
	lw $fp, 20($sp)
	lw $ra, 16($sp)
	addiu $sp, $sp, 32
	jr $ra
	
fin:
		li $v0,10
		syscall
