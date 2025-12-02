.equ BCD_BASE,   0x00410000
.equ BCD_OP,     0x04
.equ BCD_INIT,   0x08
.equ BCD_RESULT, 0x0C
.equ BCD_DONE,   0x10

.section .text
.globl bin2bcd_hw

 ## li a0, 4567

bin2bcd_hw:
  li   gp, BCD_BASE
  sw   a0, BCD_OP(gp)       # número binario
  li   a0, 1
  sw   a0, BCD_INIT(gp)
  sw   zero, BCD_INIT(gp)
.L0:
  li   t0, 1
  lw   t1, BCD_DONE(gp)
  and  t1, t1, t0
  beqz t1, .L0
  lw   a0, BCD_RESULT(gp)
  ret

