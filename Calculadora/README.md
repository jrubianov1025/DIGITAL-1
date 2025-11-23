---

## Descripción de los módulos

En la carpeta se encuentran 4 carpetas para cada periferico, en su interior, cada carpeta posee los modulos necesarios para su correcto funcionamiento, un modulo TOP 
y un testbench para su simulacion. Ademas se encuentran 4 archivos adicionales necesarios para el funcionamiento de la calculadora.

---

### Multiplicador 


hay 9 archivos dentro de esta carpeta:

- `Multiplicador.S` — Archivo en Assembler con el objetivo de realizar la comunicacion entre el periferico y el procesador 

- `Periferico_multiplicador.v` — Archivo que instancia el modulo multiplicador como un periferico de un procesasdor RISC-V

- `multiplicador.v` — módulo TOP del multiplicador, el cual declara las variables de entrada y salida del modulo, ademas de llamar el resto de modulos necesarios.

- `acc.v` — Acumulador del produccto parcial para la creaccion del resultado final 

- `comp.v` — Comparador para verificar cuantos ciclos restantes quedan de ejecucion 

- `control_mult.v` — Maquina de control del periferico, genera señales de control para el correcto funcionamiento del periferico (basado en el diagrama de estados)

- `lsr.v` — Corrimiento del registro hacia la izquierda, empleado en el multiplicando

- `rsr.v` — Corrimiento del registro hacia la derecha, empleado en el multiplicador

- `TB_multiplicador.v` — Modulo TESTBENCH para probar el funcionamiento de el periferico, crea un archivo .vcd que puede ser visualizado en GTKWAVE.

Si se quiere simular basta con abrir una terminal en la carpeta Multiplicador y ejecutar el siguiente codigo:

```
iverilog -o sim testbench.v Periferico_multiplicador.v multiplicador.v acc.v comp.v control_mult.v lsr.v rsr.v
vvp sim
```

El testbench posee dos numero predeterminados de prueba que pueden ser cambiados, se encuentra en las lineas 42 y 45 de este mismo.

---

### Divisor

---

### Raiz

---

### Binario a BCD

---
