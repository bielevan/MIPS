#################################################################################################
#												#
# Cria uma árvore de busca binária, ou seja, os filhos de um nó n são iguais a 2n+1 e 2n+2 	#
#												#
# Realiza busca:									   	#
#												#
#		Pre-Ordem								   	#			
#												#
#		Em ordem								   	#
#												#
#		Pos-ordem									#
#												#
# Autor: Gabriel Ribeiro Evangelista NUSP: 9771334						#
#												#
# Autor: Alysson Rogerio de Oliveira NUSP: 						#
#												#
#################################################################################################

# OBS: Não pode ser inserido o elemento 0

.data
	list:	.space 1000 	#reserva 1000 bytes da memória
	listsz: .word 250 	#declara um vetor de 250 inteiros

	str_menu:	.asciiz "\n------------------------------ Escolha uma opção abaixo ------------------------------\n"
	
	str_inserir:	.asciiz "Digite um elemento para inserir(0-sair) : "

	str_insert:	.asciiz "Inserir elemento		(1) :\n"
	str_pos_ordem:	.asciiz	"Percorrer arvore em pos-ordem	(4) :\n"
	str_pre_ordem:	.asciiz "Percorrer arvore em pre-ordem	(2) :\n"
	str_in_ordem:	.asciiz "Percorrer arvore em ordem	(3) :\n"
	str_close:	.asciiz "Sair				(5) :\n"
	str_invalid:	.asciiz "Opção inválida\n"
	str_next:	.asciiz "\n"
	str_space:	.asciiz	" "
	
.text

main:

	lw $s0, listsz		# $s0 recebe o tamanho do vetor
	la $s1, list		# $s1 recebe o endereço do vetor
	li $s2, 1		# Utilizado apenas para operações matemáticas
	li $t0, 0		# Inicializa $t0 como zero - contador de elementos do array
	li $t1, 0		# Inicializa $t1 como zero - utilizado para declarar o valor dos elementos
	li $t3, 0		# Inicializa $t3 como zero - para fazer $t3 = 2*t + 1 e 2*t + 2
	li $t4, 0		# Inicializa $t4 como zero - para receber o valor do nó pai do nó a ser implementado
	
	move $sp, $s1
	sw $t1, ($s1)		#salva o valor de #t1 no endereço de $s1
	j menu

#################################################################################
#################################################################################

menu:
	# Menu de opções
	la $a0, str_menu
	li $v0, 4
	syscall
	
	la $a0, str_insert
	li $v0, 4
	syscall
	
	la $a0, str_pre_ordem
	li $v0, 4
	syscall
	
	la $a0, str_in_ordem
	li $v0, 4
	syscall
	
	la $a0, str_pos_ordem
	li $v0, 4
	syscall
	
	la $a0, str_close
	li $v0, 4
	syscall

	li $v0, 5
	syscall
	
	beq $v0, 1, insercao
	beq $v0, 2, pre_ordem
	beq $v0, 3, in_ordem
	beq $v0, 4, pos_ordem
	beq $v0, 5, close
	
	# Opção invalida
	la $a0, str_invalid
	li $v0, 4
	syscall
	
	j menu

#################################################################################
#################################################################################

insercao:
	# Recebe endereço da lista
	move $sp, $s1
	
	# Função para printar a string
	li $v0, 4
	la $a0, str_inserir
	syscall				
	
	li $v0, 5
	syscall
	
	# Verifica se é zero
	beq $v0, $zero, menu
	
	# Verifica se a inserção é na raiz
	lw $a0, 0($sp)
	beq $a0, $zero, raiz
	
	# $t1 recebe o valor do usuário
	move $t1, $v0			
		
	# Recebe o valor do nó atual
	lw $t4, 0($sp)	
	slt $s2, $t1, $t4		# if (valor digitado < nó atual) $s2 = 1	    else $s2 = 0
	beq $s2, 1, esquerda
	beq $s2, 0, direita
	b insercao
	
#################################################################################
#################################################################################

raiz:
	sw $v0, 0($sp)
	j insercao

#################################################################################

esquerda:	
	mul $t3, $t3, 2			#$t3 = 2 * $t3
	addi $t3, $t3, 1		#$t3 = 2 * $t3 + 1
	mul $s2, $t3, 4			#$s2 = (2n+1) * 4 (pula n inteiros)

	move $sp, $s1			#retorna para o no raiz
	add $sp, $sp, $s2		#$sp pula para o filho da esquerda
	lw $t4, ($sp)			#recebe o valor do nó atual
	beq $t4, 0, armazena
	
	slt $s2, $t1, $t4		#if (valor digitado < nó atual) $s2 = 1	    else $s2 = 0
	beq $s2, 1, esquerda
	beq $s2, 0, direita

#################################################################################
#################################################################################

direita:
	mul $t3, $t3, 2			#$t3 = 2 * $t2
	addi $t3, $t3, 2		#$t3 = 2 * $t2 + 2
	mul $s2, $t3, 4			#$s2 = (2n+2) * 4 (pula n int)

	move $sp, $s1			#retorna para o no raiz
	add $sp, $sp, $s2		#pula para a poscao do vetor que recebera o novo valor
	lw $t4, ($sp)			#recebe o valor do nó atual
	beq $t4, 0, armazena
	
	slt $s2, $t1, $t4		#if (valor digitado < nó atual) $s2 = 1	    else $s2 = 0
	beq $s2, 1, esquerda
	beq $s2, 0, direita

#################################################################################
#################################################################################

armazena:
	move $sp, $s1			#retorna para o no raiz
	add $sp, $sp, $s2		#pula para a posicao do vetor que recebera o novo valor
	sw $t1, ($sp)			#salva o valor de $t1 no endereço de $s1
	li $t3, 0			#zera o contador
	j insercao

#################################################################################
#################################################################################

in_ordem:
	# Se nao houver elementos retorna para menu
	move $sp, $s1
	lw $a0, 0($sp)
	beq $a0, $zero, menu
	
	# Registrador $t3 controla a posicao da arvore
	li $t3, 0
	
	# Registrador $s4 é uma pilha para auxiliar a busca
	li $s4, 0
	
	# Controla as posições da pilha
	li $t6, 0

	in_ordem_search_left:
		# Busca o elemento mais a esquerda
		# Volta para a origem
		move $sp, $s1
		
		# Salva a posicao atual na pilha
		addi $s4, $s4, -4
		sw $t3, 0($s4)
		
		# Incrementa pilha
		add $t6, $t6, 1
		
		# Obtem proxima posicao a esquerda
		mul $t3, $t3, 2
		add $t3, $t3, 1
		mul $s2, $t3, 4		# Posicao em bytes
	
		# Obtem elemento
		add $sp, $sp, $s2
		lw $t2, 0($sp)
	
		# Verifica se ainda existe elementos a esq de $t3
		bne $t2, $zero, in_ordem_search_left
	
		
	in_ordem_search_right:
		# Ultimo elemento na pilha
		lw $t3, 0($s4)
		
		# Retorna uma posicao na pilha
		add $t6, $t6, -1
		addi $s4, $s4, 4
		
		# Imprime elemento
		move $sp, $s1			# Volta a origem
		mul $s2, $t3, 4			# Endereço em bytes
		add $sp, $sp, $s2
			
		lw $a0, ($sp)			# Obtem valor de $t3
		li $v0, 1
		syscall
	
		la $a0, str_space
		li $v0, 4
		syscall
		
		# Verifica se existe elemento a direita
		mul $t3, $t3, 2
		add $t3, $t3, 2
		mul $s2, $t3, 4		# Posicao em bytes
		
		# Obtem elemento
		move $sp, $s1
		add $sp, $sp, $s2
		lw $t2, ($sp)
		
		# Se tiver elemento a esquerda faça busca nele
		bne $t2, $zero, in_ordem_search_left
		
		# Se nao tiver elemento na pilha entao volta para o menu
		bgt $t6, $zero, in_ordem_search_right
		
		# Retorna para o menu
		j menu	

#################################################################################
#################################################################################

pre_ordem:
	# Se nao houver elementos retorna para menu
	move $sp, $s1
	lw $a0, 0($sp)
	beq $a0, $zero, menu
	
	# Registrador $t3 controla a posicao da arvore
	li $t3, 0
	
	# Registrador $s4 é uma pilha para auxiliar a busca
	li $s4, 0
	
	# Controla as posições da pilha
	li $t6, 0
	
	in_pre_ordem_search_left:
		# Busca o elemento mais a esquerda
		# Volta para a origem
		move $sp, $s1
		
		# Imprime elemento
		mul $s2, $t3, 4			# Endereço em bytes
		add $sp, $sp, $s2
			
		lw $a0, ($sp)			# Obtem valor de $t3
		li $v0, 1
		syscall
	
		la $a0, str_space
		li $v0, 4
		syscall
		
		# Salva a posicao atual na pilha
		addi $s4, $s4, -4
		sw $t3, 0($s4)
		
		# Incrementa pilha
		add $t6, $t6, 1
		
		# Obtem proxima posicao a esquerda
		mul $t3, $t3, 2
		add $t3, $t3, 1
		mul $s2, $t3, 4		# Posicao em bytes
	
		# Obtem elemento a esquerda
		move $sp, $s1
		add $sp, $sp, $s2
		lw $t2, 0($sp)
	
		# Verifica se ainda existe elementos a esq de $t3
		bne $t2, $zero, in_pre_ordem_search_left
	
	in_pre_ordem_search_right:
		# Ultimo elemento na pilha
		lw $t3, 0($s4)
		
		# Retorna uma posicao na pilha
		add $t6, $t6, -1
		addi $s4, $s4, 4
		
		# Verifica se existe elemento a direita
		mul $t3, $t3, 2
		add $t3, $t3, 2
		mul $s2, $t3, 4		# Posicao em bytes
		
		# Obtem elemento
		move $sp, $s1
		add $sp, $sp, $s2
		lw $t2, ($sp)
		
		# Se tiver elemento a direita faça busca nele
		bne $t2, $zero, in_pre_ordem_search_left
		
		# Se nao tiver elemento na pilha entao volta para o menu
		bgt $t6, $zero, in_pre_ordem_search_right
		
		# Retorna para o menu
		j menu
		
#################################################################################
#################################################################################

pos_ordem:
	# Se nao houver elementos retorna para menu
	move $sp, $s1
	lw $a0, 0($sp)
	beq $a0, $zero, menu
	
	# Registrador $t3 controla a posicao da arvore
	li $t3, 0
	
	# Registrador $s4 é uma pilha para auxiliar a busca
	li $s4, 0
	
	# Controla as posições da pilha
	li $t6, 0
	
	# Controle
	li $t7, 0
							
	in_pos_ordem_search_left:
		# Busca o elemento mais a esquerda
		
		# Salva a posicao atual na pilha
		addi $s4, $s4, -4
		sw $t3, 0($s4)
		
		# Incrementa pilha
		add $t6, $t6, 1
		
		# Obtem proxima posicao a esquerda
		mul $t3, $t3, 2
		add $t3, $t3, 1
		mul $s2, $t3, 4		# Posicao em bytes
	
		# Obtem elemento a esquerda
		move $sp, $s1
		add $sp, $sp, $s2
		lw $t2, 0($sp)
	
		# Verifica se ainda existe elementos a esq de $t3
		bne $t2, $zero, in_pos_ordem_search_left
	
	in_pos_ordem_search_right:
		# Ultimo elemento na pilha
		lw $t3, 0($s4)
		
		# Salva a posicao de $t3
		add $t2, $t3, $zero
		
		# Verifica se existe elemento a direita
		mul $t3, $t3, 2
		add $t3, $t3, 2
		mul $s2, $t2, 4		# Posicao em bytes
		
		# Obtem elemento
		move $sp, $s1
		add $sp, $sp, $s2
		lw $t5, ($sp)
		
		# Verifica se foi o elemento a direita foi o
		# elemento que acabou de visitar
		beq $t5, $t7, in_pos_ordem_left
		
		# Se tiver elemento a direita faça busca nele
		bne $t5, $zero, in_pos_ordem_search_left
		
		in_pos_ordem_left:
			
			# Recebe sua posica anterior
			add $t3, $t2, $zero
			
			# Retorna uma posicao na pilha
			add $t6, $t6, -1
			addi $s4, $s4, 4
		
			# Imprime elemento
			move $sp, $s1
			mul $s2, $t3, 4			# Endereço em bytes
			add $sp, $sp, $s2
			
			lw $a0, ($sp)			# Obtem valor de $t3
			li $v0, 1
			syscall
	
			# Salva elemento que esta sendo visitado
			add $t7, $a0, $zero
			
			la $a0, str_space
			li $v0, 4
			syscall	
			
			# Se nao tiver elemento na pilha entao volta para o menu
			bgt $t6, $zero, in_pos_ordem_search_right
			
			# Retorna para o menu
			j menu

#################################################################################
#################################################################################

close:
	li $v0, 10
	syscall
