.data
    nums: .word 510, 247, -107, 858, 465, 777, -728, -15, 165, 717, 323, 968, 636, 906, -555, -300, -580, -264, 189, -739, 996, -867, 400, -334, 969, 786, -655, -630, -461, 255, -221, 510, 391, 745, 306, -444, 661, -564, -804, -99, -885, 444, 28, 763, -878, 682, 418, -558, -719, 55, -78, 977, -885, -666, -467, -151, -831, 720, 31, -796, -285, -573, 211, 517, -587, -519, -296, -499, 974, 85, -645, 129, 823, 740, -667, 286, -652, -856, -186, 83, 600, 132, -117, -905, -683, 81, -368, 738, 498, -257, 54, 796, 142, -519, -348, -485, 16, -989, -58, -770
    # Lista.txt onde os numeros aparecem desordenados
    nums_count: .word 100 # Quantidade total de números na lista
    comma: .asciiz ","   # O uso da Vírgula

.text
.globl main

main:
    # Carrega o endereço da lista de números
    la $t0, nums          # $t0 -> início da lista de números
    lw $t1, nums_count    # $t1 -> quantidade de números (100)
    
    # Ordenação Bubble Sort
    li $t2, 0             # i = 0
outer_loop:
    bge $t2, $t1, end_outer_loop  # Se i >= 100, sai do loop

    li $t3, 0             # j = 0
inner_loop:
    addi $t4, $t3, 1      # j + 1
    mul $t5, $t3, 4       # j * 4 (offset em bytes)
    add $t6, $t0, $t5     # Endereço de nums[j]
    lw $t7, 0($t6)        # $t7 = nums[j]
    lw $t8, 4($t6)        # $t8 = nums[j + 1]

    # Se nums[j] > nums[j + 1], troca
    bgt $t7, $t8, swap
    j skip_swap

swap:
    sw $t8, 0($t6)        # nums[j] = nums[j + 1]
    sw $t7, 4($t6)        # nums[j + 1] = nums[j]

skip_swap:
    addi $t3, $t3, 1      # j++
    blt $t3, $t1, inner_loop  # Continua o loop interno

    addi $t2, $t2, 1      # i++
    j outer_loop          # Continua o loop externo

end_outer_loop:
    # Exibe os números ordenados
    li $t2, 0             # i = 0
print_loop:
    bge $t2, $t1, end_print_loop  # Se i >= 100, sai do loop
    lw $a0, 0($t0)        # Carrega o número

    # Exibe o número
    li $v0, 1             # Código de serviço para print integer
    syscall                # Exibe o número

    # Se não for o último número, imprime uma vírgula
    addi $t2, $t2, 1      # i++
    bge $t2, $t1, end_print_loop  # Se for o último número, sai
    li $v0, 4             # Código para print string
    la $a0, comma         # Carrega o endereço da vírgula
    syscall                # Exibe a vírgula

    addi $t0, $t0, 4      # Avança para o próximo número
    j print_loop

end_print_loop:
    # Finaliza o programa
    li $v0, 10
    syscall

# Rotina para calcular o tamanho da string
# Entrada: $a0 = endereço da string
# Saída: $v0 = tamanho da string
string_length:
    li $v0, 0             # Tamanho = 0
length_loop:
    lb $t0, 0($a0)        # Carrega byte da string
    beqz $t0, length_done # Se o byte for nulo, termina
    addi $v0, $v0, 1      # Tamanho++
    addi $a0, $a0, 1      # Próximo byte
    j length_loop
length_done:
    jr $ra                # Retorna

# Rotina para converter string para inteiro
# Entrada: $a0 = endereço da string
# Saída: $v0 = valor inteiro
string_to_int:
    li $v0, 0             # Inicializa o resultado
convert_loop:
    lb $t0, 0($a0)        # Carrega byte da string
    beqz $t0, convert_done # Se o byte for nulo, termina
    sub $t0, $t0, '0'     # Converte caractere para número
    mul $v0, $v0, 10      # Multiplica o resultado por 10
    add $v0, $v0, $t0     # Adiciona o dígito
    addi $a0, $a0, 1      # Próximo byte
    j convert_loop
convert_done:
    jr $ra                # Retorna para chamada