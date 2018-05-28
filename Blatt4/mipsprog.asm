    .text
    .globl main
main:
    # Allocate stack space for $ra, $fp and $v0
    # Save those registers on stack
    addi 	$sp, $sp, -12    
    sw    	$ra, 8($sp)      
	sw      $fp, 4($sp)		 
	sw    	$v0, 0($sp)

    # set the frame pointer to stack pointer + 8 (i.e. two elements)
    addi 	$fp, $sp, 8

    # Print "Rechnerorg aufgabe"
    la		$a0, text_1		 
	jal 	routine_1

    # Print "Geben sie..."
    la		$a0, text_3    
    jal 	routine_1	

    # Read input intp $s0
	jal 	routine_3	
	move	$s0, $v0

    # Do algorithm	 
	jal     algorithm

    # Print "Ergebnis..."
	la		$a0, text_4    
	jal 	routine_1	

    # Move $s1 to $a0 and print it
	move	$a0, $s1 		 
	jal		routine_2

    # Prints "Ende..."
    la		$a0, text_2
	jal 	routine_1 

    # Restore important pointers and return
    lw    	$ra, 8($sp)     
	lw      $fp, 4($sp)	    
	lw      $v0, 0($sp)     
    addi 	$sp, $sp, 12    
    jr   	$ra             

# Prints a string stored in $a0
routine_1:
    li    $v0, 4             
    syscall
    jr    $ra                

# Prints an integer stored in $a0
routine_2:
    li    $v0, 1             
    syscall
    jr    $ra                

# Reads an integer and stores it into $v0
routine_3:
    li    $v0, 5             
    syscall
    jr    $ra  

# Checks if 0 < input <= 10 if so aborts
# Then subtracts 10 from the input
algorithm:
	li		$s1, 0	
	blez	$s0, jump_2
	addi  	$t0, $s0, -10
	bgtz    $t0, jump_2
    jr		$ra					# jump to $ra
    
	
# Adds $s0 to $s1, decrements $s0 by one and jumps to the end if $s0 <= 0
jump_1:
	add 	$s1, $s0, $s1
	addi    $s0, $s0, -1
	bgtz	$s0, jump_1
	j		jump_3	

# Loads text "falsche eingabe, prints it
# and then subtracts 1 from $s1
jump_2:  
    la		$a0, text_5
	jal 	routine_1
    #li		$s0, -1
	
# The End
jump_3:
    jr		$ra					# jump to $ra

	
	.data
text_1: .asciiz "Rechnerorganisation Aufgabe:\n"
text_2: .asciiz "\nEnde!\n"
text_3: .asciiz "Geben Sie eine natuerliche Zahl zwischen 1 und 10 ein: "

text_4: .asciiz "Ergebnis = "
text_5: .asciiz "falsche Eingabe!\n"
