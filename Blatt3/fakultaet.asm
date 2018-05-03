  .text
  .globl main
main:
  addi    $sp, $sp, -16  # save space of stack for reg.
  sw      $v0, 0($sp)    # save $v0 on stack
  sw      $s0, 4($sp)    # save $s0 on stack
  sw      $s1, 8($sp)    # save $s1 on stack
  sw      $ra, 12($sp)   # save return address
  li      $v0, 4         # system call no. 4: print asciiz
  la      $a0, text1     # load address of text1
  syscall
  li      $v0, 4         # system call no. 4: print asciiz
  la      $a0, intxt     # load address of inptxt
  syscall
  li      $v0, 5         # system call no. 5: console input
  syscall
  move    $s0, $v0       # move value N into $s0 register

  ########
  ## Begin user  code
  ########

  # Load upper and lower bounds into registers
  li		$t1, 0		        # Lower bound
  li		$t2, 12		        # Upper bound
  
  # Clamp input to [0..12]
  blt		$s0, $t1, error	  # Lower bound
  bgt		$s0, $t2, error	  # Upper bound

  # Load counter variable and initial result
  move 	$t0, $s0		      # Counter variable
  li		$s1, 1		        # Initial result (:= 1)

loop: # Calculate n!
  ble		$t0, $t1, end	    # End check (<= 0)
  mult	$s1, $t0			    
  mflo	$s1
  sub		$t0, $t0, 1		    # Decrement counter
  j		loop				        # jump to loop start
     
error:
  li		$s1, -1		        # Error result (:= -1)
end:
########
## End user programmed code
########

  li      $v0, 4         # system call no. 4: print asciiz
  la      $a0, end1      # load address of end1
  syscall
  li      $v0, 1         # system call no. 1: print integer
  move    $a0, $s0       # register $s0 has value N
  syscall	
  li      $v0, 4         # system call no. 4: print asciiz
  la      $a0, nline
  syscall
  li      $v0, 4         # system call no. 4: print asciiz
  la      $a0, end2      # load address of end1
  syscall
  li      $v0, 1         # system call no. 1: print integer
  move    $a0, $s1       # register $s1 has value N!
  syscall	
  li      $v0, 4         # system call no. 4: print asciiz
  la      $a0, nline
  syscall
  lw      $ra, 12($sp)   # restore return address
  lw      $s1, 8($sp)    # restore $s1 from stack
  lw      $s0, 4($sp)    # restore $s0 from stack
  lw      $v0, 0($sp)    # restore $v0 from stack
  addiu   $sp, $sp, 16   # restore stack pointer
  jr      $ra            # return to main program

       .data
text1: .asciiz "\nFakultaetsberechnung\n"
intxt: .asciiz "Geben Sie eine natuerliche Zahl zwischen 1 und 12 ein: "
end1:  .asciiz "\nN  = "
end2:  .asciiz "N! = "
nline: .asciiz "\n"
