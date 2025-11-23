---

## Descripción de los módulos

En la carpeta se encuentran 4 carpetas para cada periférico. En su interior, cada carpeta posee los módulos necesarios para su correcto funcionamiento, un módulo TOP y un testbench para su simulación. Además, se encuentran los diagramas de bloques utilizados para el diseño de cada uno de los módulos y 4 archivos adicionales necesarios para el funcionamiento de la calculadora.

---

### Multiplicador 

Este módulo, en su mayoría, corresponde a códigos suministrados por el docente a modo de ejemplo.

Hay 9 archivos dentro de esta carpeta:

- `Multiplicador.S` — Archivo en Assembler con el objetivo de realizar la comunicación entre el periférico y el procesador.

- `Periferico_multiplicador.v` — Archivo que instancia el módulo multiplicador como un periférico de un procesador RISC-V.

- `multiplicador.v` — Módulo TOP del multiplicador, el cual declara las variables de entrada y salida del módulo, además de llamar el resto de módulos necesarios.

- `acc.v` — Acumulador del producto parcial para la creación del resultado final.

- `comp.v` — omparador para verificar cuántos ciclos restantes quedan de ejecución. 

- `control_mult.v` — Máquina de control del periférico. Genera señales de control para el correcto funcionamiento del periférico (basado en el diagrama de estados).

- `lsr.v` — Corrimiento del registro hacia la izquierda, empleado en el multiplicando.
  
- `rsr.v` — Corrimiento del registro hacia la derecha, empleado en el multiplicador.

- `TB_multiplicador.v` — Módulo TESTBENCH para probar el funcionamiento del periférico. Crea un archivo .vcd que puede ser visualizado en GTKWave.

Si se quiere simular, basta con abrir una terminal en la carpeta Multiplicador y ejecutar el siguiente código:

```
iverilog -o sim testbench.v Periferico_multiplicador.v multiplicador.v acc.v comp.v control_mult.v lsr.v rsr.v
vvp sim
```
Para visualizar en GTKWave, ejecutar en la terminal:

```
gtkwave TB_mult.vcd &
```

El testbench posee dos números predeterminados de prueba que pueden ser cambiados; se encuentran en las líneas 47 y 50 de este mismo archivo.

---

### Divisor

Hay 9 archivos dentro de esta carpeta:

- `Divisor.S` — Archivo en Assembler con el objetivo de realizar la comunicación entre el periférico y el procesador.

- `Periferico_DIVISOR.v` — AArchivo que instancia el módulo divisor como un periférico de un procesador RISC-V.

- `DIVISOR.v` — Módulo TOP del divisor, el cual declara las variables de entrada y salida del módulo, además de llamar el resto de módulos necesarios.

- `COMPARADOR_DIVISOR.v` —  Comparador para verificar cuántos ciclos restantes quedan de ejecución.

- `CONTADOR_DIVISOR.v` — Contador descendente para llevar un registro de ciclos de ejecución realizados.

- `CONTROL_DIVISOR.v` — Máquina de control del periférico. Genera señales de control para el correcto funcionamiento del periférico (basado en el diagrama de estados).

- `SHIFT_DEC_DIVISOR.v` — Módulo que realiza un corrimiento concatenado para el divisor, con la finalidad de comparar bit a bit con respecto al dividendo y realizar un proceso de división larga.

- `SUMADOR_DIVISOR.v` — Sumador en complemento a dos que realiza la comparación directa de los bits del divisor con el dividendo para validar la operación.
  
- `tb_Periferico_DIVISOR.v` — Módulo TESTBENCH para probar el funcionamiento del periférico. Crea un archivo .vcd que puede ser visualizado en GTKWave.

Si se quiere simular, basta con abrir una terminal en la carpeta Divisor y ejecutar el siguiente código:

```
iverilog -o sim tb_divisor.v SUMADOR_DIVISOR.v SHIFT_DEC_DIVISOR.v Periferico_divisor.v DIVISOR.v CONTROL_DIVISOR.v CONTADOR_DIVISOR.v COMPARADOR_DIVISOR.v 
vvp sim
```
Para visualizar en GTKWave, ejecutar en la terminal:

```
gtkwave tb_Periferico_DIVISOR.vcd &
```

El testbench posee dos números predeterminados de prueba que pueden ser cambiados; se encuentran en las líneas 101 y 102 de este mismo archivo.

---

### Raiz

---

### Binario a BCD

---
