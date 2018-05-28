# Hauptprogramm
	.text
    .globl main
main:
    addi  $sp,  $sp, -4      # save stack space for registers
    sw    $ra,  0($sp)       # save return address
    jal   readValues         # from console
    #jal   sortValues
    jal   printValues        # to screen
    lw    $ra,  0($sp)       # restore return address
    addi  $sp,  $sp, 4       # restore stack pointer
    jr    $ra

readValues: 
    addiu   $sp,  $sp, -8      # reserve stack space for 2 register
	sw      $fp, 4($sp)	
    sw      $ra,  0($sp)   

    li		$v0, 4		# system call #4 - print string
    la		$a0, elemNum
    syscall				# execute

    li		$v0, 5		# $v0 = 5
    syscall
    move 	$s0, $v0		# $0 = $v0

    # Check if in range
    blez    $s0, inputError
    li		$t0, 10
    bge		$s0, $t0, inputError

    # Allocate array space on stack and save start of array in $s1
    li	    $t0, 4
    mul     $t0,  $s0, $t0
    subu    $sp, $sp, $t0
    move    $s1, $sp

    # Read values into array
    li		$v0, 4		# system call #4 - print string
    la		$a0, elemIn
    syscall				# execute
    
    li		$t0, 0		# $t0 = 0
inputLoop:
    bge		$t0, $s0, endInput	# Break condition

    # Calculate element address
    sll     $t1, $t0, 2
    add		$t1, $t1, $s1
    
    # Read int and store in array
    li    $v0, 5
    syscall
    #sw		$v0, 0($t1)

    # i++ and jump to start
    addi	$t0, $t0, 1	    # $t0 = $tp -1
    j		inputLoop		# jump to inputLoop

inputError:
    li		$v0, 4		# system call #4 - print string
    la		$a0, inErr
    syscall				# execute

endInput:
    li		$v0, 4		# system call #4 - print string
    la		$a0, finish
    syscall   

    # move stack pointer upwards n times
    li		$t0, 4		# $t0 = 4
    mul     $t0,  $s0, $t0
    add		$sp, $sp, $t0		# $sp = $sp + $t0
    
    # Restore registers
    lw	    $fp,  4($s1)		#     
    lw      $ra,  0($sp)       # restore return address
    addi    $sp,  $sp, 8       # restore stack pointer
    jr   	$ra    


sortValues:
    addi    $sp,  $sp, -8   # save stack space for 2 registers
    sw		$fp, 4($sp)		# Save frame pointer
    sw      $ra,  0($sp)    # save return address

    li		$t0, 0		# $t0 = 0
sortLoopOuter:
    bge		$t0, $s0, endSortOuter	# if $t0 >= $s0 then endSortOuter
    
    li		$t1, 0		# $t1 = 0
sortLoopInner:
    bge		$t1, $s0, endSortInner	# if $t1 >= $s0 then endSortInner


    # Get elem i and i+1
    # compare them
    # if i > i+1 swap


    addi	$t1, $t1, 1			# $t1 = $t1 + 1
    j sortLoopInner

endSortInner:
    addi	$t0, $t0, 1			# $t0 = $t0 + 1
    j		sortLoopOuter				# jump to target
    

endSortOuter:

    lw      $fp 4($sp)      # restore frame pointer
    lw      $ra,  0($sp)    # restore return address
    addi    $sp,  $sp, 8    # restore stack pointer
    jr      $ra


printValues:
    addi    $sp,  $sp, -8   # save stack space for 2 registers
    sw		$fp, 4($sp)		# Save frame pointer
    sw      $ra,  0($sp)    # save return address

    li		$v0, 4		# system call #4 - print string
    la		$a0, printElems
    syscall

    li		$v0, 1		    # $v0 = 1
    move 	$a0, $s0		# $a0 = $s0
    syscall   

    li		$t0, 0		    # $t0 = 0
printLoop:
    bge		$t0, $s0, printEnd	# Break condition (i >= n)
    
    # Calculdate addresses
    sll     $t1, $t0, 2
    add		$t1, $t1, $s1

    # Print value
    li		$v0, 1		# system call #1 - print int
    la		$a0, 0($t1)
    syscall

    addi	$t0, $t0, 1		# $t0 = $t0 + 1
    j		printLoop		# jump to loop

printEnd:   
    lw      $fp 4($sp)      # restore frame pointer
    lw      $ra,  0($sp)    # restore return address
    addi    $sp,  $sp, 8    # restore stack pointer
    jr      $ra



swapElements:
    # Array start address save in $a0
    # Index saved in $a1

    # Calculare index address
    sll     $t1, $a1, 2     # Calculate address offset with left-logical shift
    add		$t1, $t1, $a0	# Calculate array element address

    # Calculate index+1 address
    addi	$t2, $a1, 1
    sll     $t2, $t2, 2
    add     $t2, $t2, $a0

    # Load index into register
    lw		$t3, 0($t1)

    # Save index+1 to index
    sw		$t2, 0($t1)

    # Save index from register to index+1
    sw		$t3, 0($t2)

    # return
    jr		$ra



.data
elemNum: .asciiz "Anzahl der Elemente ([1 und 10]): "
elemIn: .asciiz "Geben sie die Elemente ein:\n"
inErr: .asciiz "Nur Nummern zwischen 1 und 10 akzeptiert\n"
finish: .asciiz "Finished reading elements into array.\n"
printElems: .asciiz "Gebe sortiertes array aus:\n"
nline: .asciiz "\n"