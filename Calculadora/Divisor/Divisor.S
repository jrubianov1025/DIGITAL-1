.equ DIV_BASE,   0x00430000
.equ DIV_OP_A,   0x04
.equ DIV_OP_B,   0x08
.equ DIV_INIT,   0x0C
.equ DIV_RESULT, 0x10
.equ DIV_DONE,   0x14

.section .text
.globl div_hw

 # li a0, 2000 se comenta despues de probar el archivo en gtkwave
 # li a1, 16   se comenta despues de probar el archivo en gtkwave

div_hw:
  li   gp, DIV_BASE
  sw   a0, DIV_OP_A(gp)     # dividendo
  sw   a1, DIV_OP_B(gp)     # divisor
  li   a0, 1
  sw   a0, DIV_INIT(gp)
  sw   zero, DIV_INIT(gp)
.L0:
  li   t0, 1
  lw   t1, DIV_DONE(gp)
  and  t1, t1, t0
  beqz t1, .L0
  lw   a0, DIV_RESULT(gp)
  ret
