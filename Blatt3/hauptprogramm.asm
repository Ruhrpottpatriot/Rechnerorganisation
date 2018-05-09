    .text
    .globl main
main:
    addiu $sp,  $sp, -4      # reserve stack space for 1 register
    sw    $ra,  0($sp)       # save return address on stack
    move  $fp,  $sp          # set $fp = $sp
    li    $a0,  62           # set $a0 = '>' (ASCII char)
    li    $v0,  11           # set $v0 = index of system call "print_char"
    syscall                  # print on console: '>'
    li    $v0,  5            # set $v0 = index of system call "read_int"
    syscall                  # read integer value n from console
    bgtz  $v0,  validn       # goto validn if n > 0
    li    $v0,  1            # enforce n > 0
validn:
    li    $t1,  4            # set $t1 = 4
    mul   $t1,  $t1, $v0     # set $t1 = 4 * n
    subu  $sp,  $sp, $t1     # reserve stack space for vector V
    move  $a0,  $v0          # set $a0 = n
    move  $a1,  $sp          # set $a1 = address of vector V
    jal   algorithm          # call algorithm(n, V)
    move  $t0,  $sp          # set $t0 = address of vector V
output:
    lw    $a0,  0($t0)       # set $a0 = value of current vector element
    li    $v0,  1            # set $v0 = index of system call "print_int"
    syscall                  # print on console: value of current vector element
    addiu $t0, $t0, 4        # set $t0 = $t0 + 4
    beq   $t0, $fp, endln    # goto "endln" if end of vector reached
    li    $a0,  44           # set $a0 = ',' (ASCII char)
    li    $v0,  11           # set $v0 = index of system call "print_char"
    syscall                  # print on console: ','
    j output                 # continue output
endln:
    li    $a0,  13           # set $a0 = CR (ASCII char)
    li    $v0,  11           # set $v0 = index of system call "print_char"
    syscall                  # print on console: CR
finish:                      # program execution finished
    lw    $ra,  0($fp)       # restore return address from stack
    addiu $sp,  $fp, 4       # release reserved stack space
    jr    $ra                # return to operating system
algorithm:
    ###############################################################################
    # Insert your code here!                                                      #
    ###############################################################################

    li		$t0, 0		    # $t0 = 0    
loop:
    bge		$t0, $a0, end	# Break condition (i >= n)
    
    sll     $t1, $t0, 2     # Calculate address offset with left-logocal shift
    add		$t1, $t1, $a1	# Calculate array element address

    addi	$t2, $t0, 1		# Add 1 to element value, since we mustn't start at 0 :((((((   
    sw		$t2, 0($t1)		# Write element

    addi	$t0, $t0, 1		# $t0 = $t0 + 1
    j		loop			# jump to loop
end:
    jr    $ra               # return to main program