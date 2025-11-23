---

## Descripción de los módulos

En la carpeta se encuentran 4 carpetas para cada periferico, en su interior, cada carpeta posee los modulos necesarios para su correcto funcionamiento, un modulo TOP 
y un testbench para su simulacion. Ademas se encuentran 4 archivos adicionales necesarios para el funcionamiento de la calculadora.

---

### Multiplicador

hay 9 archivos dentro de esta carpeta:

- Multiplicador.S — Archivo en Assembler con el objetivo de realizar la comunicacion entre el periferico y el procesador 

- Periferico_multiplicador.v — Archivo que instancia el modulo multiplicador como un periferico de un procesasdor RISC-V

- multiplicador.v — módulo TOP del multiplicador, el cual declara las variables de entrada y salida del modulo, ademas de llamar el resto de modulos necesarios.

- acc.v —

- comp.v —

- control_mult.v —

- lsr.v —

- rsr.v —

- TB_multiplicador.v —
  
---

### Divisor

---

### Raiz

---

### Binario a BCD

---
