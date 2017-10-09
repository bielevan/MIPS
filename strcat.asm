.data
	str1:	.space	200
	str2:	.space	200
	str3:	.space	400
	str_text1:	.asciiz	"Informe a primeira palavra: "
	str_text2:	.asciiz "Informe a segunda  palavra: "
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
	
	# String final 
	la $s3, str3
	
concat_1:
	# Obtem byte
	lb $t1, 0($s1)
	add $s1, $s1, $t0
	
	beq $t1, $zero, concat_2
	
	# Salva byte
	addi $s3, $s3, -1
	sb $t1, 0($s3)
	
	j concat_1

concat_2:
	# Obtem byte
	lb $t1, 0($s2)
	add $s2, $s2, $t0
	
	beq $t1, $zero, close
	
	# Salva byte
	addi $s3, $s3, -1
	sb $t1, 0($s3)
	
	j concat_2
	
close:	
	li $v0, 10
	syscall