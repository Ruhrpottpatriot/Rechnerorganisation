main: 
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    # read fib(n)
    li          $v0, 4
    la          $a0, FibIdx
    syscall
    li          $v0, 5
    syscall

    move $a0, $v0
    #addi $a0, $zero, 5
    jal fib
    
    move    $t0, $v0

    li		$v0, 4
    la		$a0, result
    syscall

    move    $a0, $t0
    li      $v0, 1
    syscall

    lw $ra, 0($sp)
    addi $sp, $sp, 4

    jr $ra

fib:
    # Save registers
    addi $sp, $sp, -12
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $ra, 8($sp)


    slti $t0, $a0, 2
    beq $t0, $zero, isZero

    addi $v0, $zero, 1
    j return

isZero: 
    addi $s0, $a0, 0
    addi $a0, $a0, -1
    jal fib

    addi $s1, $v0, 0
    addi $a0, $s0, -2
    jal fib

    add $v0, $s1, $v0

return:
    # Restore registers
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $ra, 8($sp)
    addi $sp, $sp, 12

    jr $ra

.data
FibIdx: .asciiz "Fibonacci Index: "
result: .asciiz "The Fibonacci value is: "