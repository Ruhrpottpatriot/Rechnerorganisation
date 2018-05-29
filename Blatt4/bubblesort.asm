	.text
    .globl main
main:
    addi  $sp,  $sp, -4      # save stack space for registers
    sw    $ra,  0($sp)       # save return address
    jal   readValues         # from console
    jal   sortValues
    jal   printValues        # to screen

    # Free array stack space
    li		$t0, 4		    # Word size
    mul     $t0, $t0, $s0   # Total space for n elements
    add	$sp, $sp, $t0	# $sp = $t0 + $sp
    
    lw    $ra,  0($sp)       # restore return address
    addi  $sp,  $sp, 4       # restore stack pointer
    jr    $ra

readValues:
    li		$v0, 4		# system call #4 - print string
    la		$a0, elemNum
    syscall				# execute

    li		$v0, 5		# $v0 = 5
    syscall
    move 	$s0, $v0		# $s0 = $v0

    # Check if in range
    blez    $s0, inputError
    li		$t0, 10
    bge		$s0, $t0, inputError

    # Allocate array space on stack and save start of array in $s1
    li		$t0, 4		    # Word size
    mul     $t0, $t0, $s0  # Total space for n elements
    subu    $sp, $sp, $t0   # Move $sp down array size
    move    $s1, $sp        # Store array start in $s1

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
    sw		$v0, 0($t1)

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
    
    jr   	$ra    


sortValues:
    li		$v0, 4		# system call #4 - print string 
    la		$a0, sortStart
    syscall				# execute

    # Outer loop
    # for (n= A.size; n>1; n=n-1)
    li		$t0, 1		        # $t0 = 1
    move 	$t1, $s0		    # $t1 = $s0    
outer:
    bge		$t0, $t1, endOuter	# if $t0 >= $t1 then endOuter

    # Print sort index
    li		$v0, 4
    la		$a0, sortIndex
    syscall
    li		$v0, 1		# system call #1 - print int
    move 	$a0, $t1		# $a0 = $t1
    syscall				# execute
    li		$v0, 4		# system call #4 - print string 
    la		$a0, nline
    syscall				# execute

    # Inner Loop
    # for (i=0; i<n-1; i=i+1)
    li		$t2, 0		        #  i = 0
    addi	$t3, $t1, -1		#  n -  1
inner:
    bge		$t2, $t3, endInner	# if $t3 >= $t2 then endInner

    # Print inner index
    li		$v0, 4
    la		$a0, innerIndex
    syscall
    li		$v0, 1
    move    $a0, $t2
    syscall
    li		$v0, 4
    la		$a0, nline
    syscall

    # Get A[i] and A[i]
    sll     $t4, $t2, 2
    add		$t4, $t4, $s1
    lw		$t5, 0($t4)

    addi	$t6, $t2, 1
    sll     $t6, $t6, 2
    add		$t6, $t6, $s1
    lw		$t7, 0($t6)

    # Print comparison tuple
    li		$v0, 4		# system call #4 - print string
    la		$a0, compareTuple
    syscall				# execute
    li    $a0,  28           # set $a0 = ',' (ASCII char)
    li    $v0,  11           # set $v0 = index of system call "print_char"
    syscall                  # print on console: ','
    li		$v0, 1		# system call #1 - print int
    move 	$a0, $t5		# $a0 = $t5
    syscall				# execute
    li    $a0,  44           # set $a0 = ',' (ASCII char)
    li    $v0,  11           # set $v0 = index of system call "print_char"
    syscall                  # print on console: ','
    li		$v0, 1		# system call #1 - print int
    move 	$a0, $t7		# $a0 = $t7
    syscall				# execute
    li    $a0,  29           # set $a0 = ',' (ASCII char)
    li    $v0,  11           # set $v0 = index of system call "print_char"
    syscall                  # print on console: ','
    li		$v0, 4		# system call #4 - print string 
    la		$a0, nline
    syscall				# execute


    
    # Compare and swap
    # if (A[i] <= A[i+1])
    #   continue;
    ble		$t5, $t7, lessOrEq
    sw		$t5, 0($t6)		    # Store i at i+1 
    sw		$t7, 0($t4)		    # Store i+1 at is
lessOrEq:

    addi	$t2, $t2, 1			# $t3 = $t3 + 1
    j       inner
endInner:
    addi   $t1,$t1, -1
    j		outer				# jump to outer
endOuter:

    li		$v0, 4		# system call #4 - print string 
    la		$a0, sortEnd
    syscall				# execute

    jr      $ra


printValues:
    li		$v0, 4		# system call #4 - print string
    la		$a0, printElems
    syscall

    # li		$v0, 1		    # $v0 = 1
    # move 	$a0, $s0		# $a0 = $s0
    # syscall   

    li		$t0, 0		    # $t0 = 0

    # Print first element of array
    # Calculdate element address
    sll     $t1, $t0, 2
    add		$t1, $t1, $s1

    # Print element
    li		$v0, 1		# system call #1 - print int
    lw		$a0, 0($t1)
    syscall 
    addi	$t0, $t0, 1			# $t0 = $t0 + 1

printLoop:
    bge		$t0, $s0, printEnd	# Break condition (i >= n)
    
    # Print delimiter
    li    $a0,  44           # set $a0 = ',' (ASCII char)
    li    $v0,  11           # set $v0 = index of system call "print_char"
    syscall                  # print on console: ','

    # Calculdate element address
    sll     $t1, $t0, 2
    add		$t1, $t1, $s1

    # Print element
    li		$v0, 1		# system call #1 - print int
    lw		$a0, 0($t1)
    syscall

    # Increment and jump to start
    addi	$t0, $t0, 1		# $t0 = $t0 + 1
    j		printLoop		# jump to loop

printEnd:
    jr      $ra




# Not used, only for reference
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
sortStart: .asciiz "Starte Sortierung\n"
sortEnd: .asciiz "Sortierung beendet\n"
sortIndex: .asciiz "Durchgang: "
innerIndex: .asciiz "Element: "
compareTuple: .asciiz "Vergleichstupel: "
nline: .asciiz "\n"