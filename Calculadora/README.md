
## 📘 Descripción de los módulos

En esta carpeta se encuentran 4 carpetas, una para cada periférico.
Dentro de cada una se incluyen:

- Los módulos necesarios para su funcionamiento
- Un módulo TOP
- Un testbench para simulación
- Archivo en assembler adicional utilizado por la calculadora completa

Además, se encuentran 4 archivos adicionales necesarios para el funcionamiento de la calculadora.

---

### 🔢 Multiplicador 

El módulo multiplicador implementa un multiplicador secuencial basado en corrimientos y sumas parciales.
La mayoría de los archivos fueron suministrados como ejemplo por el docente, pero están totalmente integrados como un periférico funcional para un procesador RISC-V.

Este módulo toma dos operandos de 16 bits y produce un resultado de 32 bits utilizando un proceso iterativo controlado por una máquina de estados.

Se describe con mas detalle el funcionamiento del modulo mediante el uso de 3 diagramas, Diagrama de flujo, Datapath y diagrama de estados; a continuacion se anexan estos 3 diagramas.






A modo de resumen, se especifica en la siguiente tabla las diferentes variables presentes en el diseño.

| Señal    | I/O    | Bits | Descripción                     |
| -------- | ------ | ---- | ------------------------------- |
| `a`      | Input  | 16   | Multiplicando                   |
| `b`      | Input  | 16   | Multiplicador                   |
| `init`   | Input  | 1    | Inicia la operación             |
| `clk`    | Input  | 1    | Señal de reloj                  |
| `done`   | Output | 1    | Indica que la operación terminó |
| `PP`     | Output | 32   | Resultado final                 |


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

### ➗ Divisor

Este módulo implementa una división larga binaria mediante corrimientos concatenados, comparador con el uso de un sumador en complemento a dos y una máquina de control que coordina las etapas.

Se describe con mas detalle el funcionamiento del modulo mediante el uso de 3 diagramas, Diagrama de flujo, Datapath y diagrama de estados; a continuacion se anexan estos 3 diagramas.






A modo de resumen, se especifica en la siguiente tabla las diferentes variables presentes en el diseño.

| Señal    | I/O    | Bits | Descripción                     |
| -------- | ------ | ---- | ------------------------------- |
| `DV`     | Input  | 16   | Dividendo                       |
| `DR`     | Input  | 16   | Divisor                         |
| `START`  | Input  | 1    | Inicia la operación             |
| `CLK`    | Input  | 1    | Señal de reloj                  |
| `DONE`   | Output | 1    | Indica que la operación terminó |
| `R`      | Output | 32   | Resultado final                 |



Hay 9 archivos dentro de esta carpeta:

- `Divisor.S` — Archivo en Assembler con el objetivo de realizar la comunicación entre el periférico y el procesador.

- `Periferico_DIVISOR.v` — Archivo que instancia el módulo divisor como un periférico de un procesador RISC-V.

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
