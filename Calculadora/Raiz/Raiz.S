.equ SQRT_BASE,   0x00420000
.equ SQRT_OP,     0x04
.equ SQRT_INIT,   0x08
.equ SQRT_RESULT, 0x0C
.equ SQRT_DONE,   0x10

.section .text
.globl sqrt_hw

## li a0, 25

sqrt_hw:
  li   gp, SQRT_BASE
  sw   a0, SQRT_OP(gp)     # número de entrada
  li   a0, 1
  sw   a0, SQRT_INIT(gp)
  sw   zero, SQRT_INIT(gp)
.L0:
  li   t0, 1
  lw   t1, SQRT_DONE(gp)
  and  t1, t1, t0
  beqz t1, .L0
  lw   a0, SQRT_RESULT(gp)
  ret
