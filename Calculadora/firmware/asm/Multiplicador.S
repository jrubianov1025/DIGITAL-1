.equ MULT_BASE,   0x00440000  
.equ MULT_OP_A,   0x04
.equ MULT_OP_B,   0x08
.equ MULT_INIT,   0x0C
.equ MULT_RESULT, 0x10
.equ MULT_DONE,   0x14

.section .text
.globl mult_hw

## li a0, 122
## li a1, 4

mult_hw:
  li   gp, MULT_BASE 
  sw   a0, MULT_OP_A(gp)  
  sw   a1, MULT_OP_B(gp)
  li   a0, 1
  sw   a0, MULT_INIT(gp) 
  sw   zero, MULT_INIT(gp)  
.L0:
   li   t0, 1  
   lw   t1, MULT_DONE(gp)
   and  t1, t1, t0
   beqz t1, .L0  
   lw   a0, MULT_RESULT(gp)
  ret
#a4        a5     a3       a0    
#000111   0101   0000     0000
#000111   0101   0001     0000
#000111   0101   0001     0111
#001110   0010   0001     0111
#001110   0010   0000     0111
#011100   0001   0000     0111
#011100   0001   0001     0111
#011100   0001   0001   100011
#111000   0000   0001   100011  


