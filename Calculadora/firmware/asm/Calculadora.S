.section .text
.globl start 
.globl blinker
.globl put_hello

calculator:

loopM:	
   li   sp,0x2000

	la   a0, number
	call putstring
	call get_number      # first number
	call bcd2bin
    add  t1, a0, zero    # mv instructions doesn't works fine

	la   a0, operator
	call putstring 
	call getchar         # Operator
	add  s2, a0, zero
	
	add  a0, s2, zero
	call putchar 
	
	li   t4, 64	# @
	beq  s2, t4, OP_SQRT

	la   a0, number
	call putstring
	call get_number      # second number
	call bcd2bin
    add  t3, a0, zero    # mv instructions doesn't works fine

    li   t4, 42      # *
    beq  s2, t4, OP_MUL
	

    li   t4, 47       #  /
    beq  s2, t4, OP_DIV


    li   t4, 43       #  +
    beq  s2, t4, OP_ADD

	j OP_SQRT

OP_MUL:
	
	add  a0, t1, zero
	add  a1, t3, zero
	call mult_hw
	add  s1, a0, zero
	j    print_result

OP_DIV:

	add  a0, t1, zero
	add  a1, t3, zero
	call div_hw
	add  s1, a0, zero	
	j    print_result

OP_ADD:
 
	add  a0, t1, t3
	add  s1, a0, zero
	j    print_result

OP_SQRT:

	add  a0, t1, zero
    	call sqrt_hw
    	add  s1, a0, zero


print_result:

    la   a0, result
	call putstring
	
	add  a0, s1, zero	
	call bin2bcd_hw
	add  s1, a0, zero
	
	   li   t3, 4 
	   
print_loop:

    srli t0, s1, 12     # mover el dígito más significativo al nibble bajo
    andi t0, t0, 0x0F   # t0 = dígito
    addi t0, t0, 0x30   # convertir a ASCII
    add   a0, t0, zero
    call putchar        # imprime un dígito

    slli s1, s1, 4      # bajar al siguiente dígito
    addi t3, t3, -1
    bnez t3, print_loop

    j loopM             # volver al inicio


.section .data
number:
	.asciz "\n\rNumber: "
operator:
	.asciz "\n\rOperator "
result:
	.asciz "\n\rResult = "

