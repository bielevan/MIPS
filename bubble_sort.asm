# Autor: Gabriel Ribeiro Evangelista
# NUSP: 9771334
# Descrição: Algoritmo que realiza um bubble-sort em um vetor com valores dado pelo usuario

.data
	str1:	.asciiz "  ------   Digite todos os valores  ------- "
	str2:	.asciiz "Valor ->  "
	str3:	.asciiz " "
	new:	.asciiz "\n"

.text

main:
	# Imprime texto
	la $a0, str1
	li $v0, 4
	syscall
	
	la $a0, new
	li $v0, 4
	syscall
	
	la $a0, new
	li $v0, 4
	syscall
	
	# Vetores
	addi $s0, $s0, 0
	addi $s3, $s3, 0
	
	# Quantidade de elementos no vetor
	li $s1, 0
	li $s2, 0
		
# Obter todos os elementos
get_values:
	# Imprime texto
	la $a0, str2
	li $v0, 4
	syscall
	
	# Obter valor
	li $v0, 5
	syscall
	
	# Verifica se o valor obtido é zero
	beq $v0, $zero, control
	
	# Abre espaço no vetor $s0 e salva valor obtido
	addi $s0, $s0, -4
	sw $v0, 0($s0)
	
	# Aumenta a quantidade de elementos 
	addi $s1, $s1, 1
	addi $s2, $s2, 1
	
	j get_values


# Control
control:
	# Registrador $s1 controla o numero de interações
	add $s1, $s1, -1
	
	# Total de elementos atual
	add $a0, $zero, $s1
	
	# Se não tiver mais nenhuma interação para fazer mostra vetor
	ble $s1, $zero, show_vector
	
	# Reinicia t0
	add $t0, $zero, 0
	
	# Ordena na interação atual
	jal order
	
	j control

# Ordenar elementos da interacao $s1
order:
	# Verifica se ainda existe elementos para serem comparados nessa interação
	beq $a0, $zero, control
	
	# Controla endereço
	add $t0, $t0, -4
	
	# Obtem dois elementos para comparar
	addi $s0, $t0, 0
	lw $a1, 0($s0)
	lw $a2, -4($s0)
	
	# Compara valores
	slt $t1, $a2, $a1
	beq $t1, $zero, aux_order
	jal swap
	
	aux_order:
		# Diminui a quantidade de elementos
		add $a0, $a0, -1
		j order
	
# Troca elementos no vetor
swap:
	sw $a2, 0($s0)
	sw $a1, -4($s0)
	jr $ra
 	
# Imprime todos os elementos
show_vector:
	# Se não tiver elementos para mostrar
	beq $s2, $zero, end
	
	# Diminui a quantidade de elementos
	add $s2, $s2, -1
				
	# Controla endereço
	add $t2, $t2, -4
	addi $s0, $t2, 0
	
	# Obtem primeiro elemento
	lw $t0, 0($s0)
	
	# Imprime
	la $a0, ($t0)
	li $v0, 1
	syscall
	
	la $a0, str3
	li $v0, 4
	syscall
	
	j show_vector

# Fim do programa
end:
	add $s0, $zero, -4
	addi $s0, $s0, 4
	
	li $v0, 10
	syscall
