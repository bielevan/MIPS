.data
	# Buffer 1
	str1:		.space 200
	
	# Buffer 2
	str2:		.space 200
	
	str_text1:	.asciiz	"Informe a primeira palavra: "
	str_text2:	.asciiz "Informe a segunda  palavra: "
	str_eq:		.asciiz "Palavras iguais\n"
	str_ne:		.asciiz	"Palavras nao iguais\n"
	str_next:	.asciiz "\n"
.text

main:
	# Maximo numero de caracteres
	la $a1, 200
	
	# Obter buffer 1
	la $a0, str_text1
	li $v0, 4
	syscall
	
	la $a0, str1
	li $v0, 8
	syscall
	
	# Obter buffer 2
	la $a0, str_text1
	li $v0, 4
	syscall
	
	la $a0, str2
	li $v0, 8
	syscall
		
	# Aponta para a primeira string
	la $s1, str1
	
	# Aponta para a segunda string
	la $s2, str2
									
	# Controle
	li $t0, 1
	
compare:
	beq $t0, $a1, eq
	
	lb $t1, ($s1)
	lb $t2, ($s2)
	
	add $s1, $s1, $t0
	add $s2, $s2, $t0
	
	bne $t1, $t2, nq
	
	beq $t1, $zero, eq
	
	j compare
	
eq:
	la $a0, str_eq
	li $v0, 4
	syscall
	
	j close
	
nq:
	la $a0, str_ne
	li $v0, 4
	syscall

close:
	li $v0, 10
	syscall