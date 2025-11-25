
## 📘 Descripción de los módulos

En esta carpeta se encuentran 4 carpetas, una para cada periférico.
Dentro de cada una se incluyen:

- Los módulos necesarios para su funcionamiento
- Un módulo TOP
- Un testbench para simulación
- Archivo en assembler adicional utilizado por la calculadora completa

Además, se encuentran 4 archivos adicionales necesarios para el funcionamiento de la calculadora.

---

### ✖️ Multiplicador 

El módulo multiplicador implementa un multiplicador secuencial basado en corrimientos y sumas parciales.
La mayoría de los archivos fueron suministrados como ejemplo por el docente, pero están totalmente integrados como un periférico funcional para un procesador RISC-V.

Este módulo toma dos operandos de 16 bits y produce un resultado de 32 bits utilizando un proceso iterativo controlado por una máquina de estados.

Se describe con mas detalle el funcionamiento del modulo mediante el uso de 3 diagramas, Diagrama de flujo, Datapath y diagrama de estados; a continuacion se anexan estos 3 diagramas.

<p align="center">
  <img src="./Diagramas%20de%20bloques/Diagrama%20de%20flujo%20MULT.jpeg" width="350">
  <img src="./Diagramas%20de%20bloques/D_ESTADOS%20MULT.jpeg" width="350"> 
  <img src="./Diagramas%20de%20bloques/Camino%20de%20datos%20MULT.jpeg" width="350">
</p>


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


<p align="center">
  <img src="./Diagramas%20de%20bloques/Diagrama%20de%20flujo%20Div.jpeg" width="350">
  <img src="./Diagramas%20de%20bloques/D_ESTADOS%20DIV.jpeg" width="350">
  <img src="./Diagramas%20de%20bloques/Camino%20de%20datos%20DV.jpeg" width="350">

</p>

A modo de resumen, se especifica en la siguiente tabla las diferentes variables presentes en el diseño.

| Señal    | I/O    | Bits | Descripción                     |
| -------- | ------ | ---- | ------------------------------- |
| `DV`     | Input  | 16   | Dividendo                       |
| `DR`     | Input  | 16   | Divisor                         |
| `START`  | Input  | 1    | Inicia la operación             |
| `CLK`    | Input  | 1    | Señal de reloj                  |
| `DONE`   | Output | 1    | Indica que la operación terminó |
| `R`      | Output | 16   | Resultado final                 |



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

### ✔️ Raiz

Este módulo implementa la Raiz cuadrada binaria mediante un procedimiento similar a una division larga, utiliza corrimientos, comparador con el uso de un sumador en complemento a dos y una máquina de control que coordina las etapas.

Se describe con mas detalle el funcionamiento del modulo mediante el uso de 3 diagramas, Diagrama de flujo, Datapath y diagrama de estados; a continuacion se anexan estos 3 diagramas.

<p align="center">
  <img src="./Diagramas%20de%20bloques/Diagrama%20de%20flujo%20Raiz.jpeg" width="350">
  <img src="./Diagramas%20de%20bloques/D_ESTADOS%20RAIZ.jpeg" width="350"> 
  <img src="./Diagramas%20de%20bloques/Camino%20de%20datos%20Raiz.jpeg" width="350">
</p>




A modo de resumen, se especifica en la siguiente tabla las diferentes variables presentes en el diseño.

| Señal      | I/O    | Bits | Descripción                     |
| --------   | ------ | ---- | ------------------------------- |
| `Op_A`     | Input  | 16   | Numero del cual obtener su raiz |
| `INIT`     | Input  | 1    | Inicia la operación             |
| `CLK`      | Input  | 1    | Señal de reloj                  |
| `DONE`     | Output | 1    | Indica que la operación terminó |
| `Resultado`| Output | 16   | Resultado final                 |



Hay 10 archivos dentro de esta carpeta:

- `Raiz.S` — Archivo en Assembler con el objetivo de realizar la comunicación entre el periférico y el procesador.

- `Periferico_raiz.v` — Archivo que instancia el módulo Raiz como un periférico de un procesador RISC-V.

- `RAIZ.v` — Módulo TOP de la Raiz cuadrada, el cual declara las variables de entrada y salida del módulo, además de llamar el resto de módulos necesarios.

- `CONTROL_RAIZ.v` —   Máquina de control del periférico. Genera señales de control para el correcto funcionamiento del periférico (basado en el diagrama de estados).

- `COUNT_RAIZ.v` — Contador descendente para llevar un registro de ciclos de ejecución realizados.

- `LSR_A_RAIZ.v` — toma el valor original y realiza un desplazamiento de dos bits para realizar la comparacion del numero con el resultado parcial.

- `LSR_R_RAIZ.v` — se va construyendo el resultado mediante un corrimento bit a bit y una señal de control R0.
 
- `LSR_TMP_RAIZ.v` — Registro de almacenamiento temporal del resultado parcial para su posterior uso en el sumador en complemento a dos. 

- `SUM_C2_RAIZ.v` — Sumador en complemento a dos que realiza la comparación directa de la pareja de bits en LSR_A_RAIZ y LSR_TMP_RAIZ concatenado con un uno para validar la operacion.
 
- `tb_Periferico_DIVISOR.v` — Módulo TESTBENCH para probar el funcionamiento del periférico. Crea un archivo .vcd que puede ser visualizado en GTKWave.

Si se quiere simular, basta con abrir una terminal en la carpeta Raiz y ejecutar el siguiente código:

```
 iverilog -o sim CONTROL_RAIZ.v COUNT_RAIZ.v LSR_A_RAIZ.v LSR_R_RAIZ.v LSR_TMP_RAIZ.v Periferico_raiz.v RAIZ.v SUM_C2_RAIZ.v tb_Periferico_raiz.v
 vvp sim
```
Para visualizar en GTKWave, ejecutar en la terminal:

```
gtkwave raiz.vcd &
```

El testbench posee un numero predeterminado de prueba que puede ser cambiado; se encuentra en la línea 106 de este mismo archivo.




---

### 🔢 Binario a BCD

Este módulo convierte un número binario de 16 bits a su representación en BCD (Binary-Coded Decimal) empleando el algoritmo Double Dabble (Shift-and-Add-3). funciona principalmente con el uso de corrimientos concatenados, comparador mediante el uso de un sumador en complemento a dos y una máquina de control que coordina las etapas.

Se describe con mas detalle el funcionamiento del modulo mediante el uso de 3 diagramas, Diagrama de flujo, Datapath y diagrama de estados; a continuacion se anexan estos 3 diagramas.

<p align="center">
  <img src="./Diagramas%20de%20bloques/Diagrama%20de%20flujo%20BBCD.jpeg" width="350">
  <img src="./Diagramas%20de%20bloques/D_ESTADOS%20BBCD.jpeg" width="350"> 
  <img src="./Diagramas%20de%20bloques/Camino%20de%20datos%20BBCD.jpeg" width="350">
</p>




A modo de resumen, se especifica en la siguiente tabla las diferentes variables presentes en el diseño.

| Señal      | I/O    | Bits | Descripción                     |
| --------   | ------ | ---- | ------------------------------- |
| `Op_A`     | Input  | 16   | binario al cual pasar a bcd     |
| `INIT`     | Input  | 1    | Inicia la operación             |
| `CLK`      | Input  | 1    | Señal de reloj                  |
| `DONE`     | Output | 1    | Indica que la operación terminó |
| `UNIT`     | Output | 4    | UNIDADES                        |
| `DEC`      | Output | 4    | DECENAS                         |
| `CENT`     | Output | 4    | CENTENAS                        |
| `MIL`      | Output | 4    | MILES                           |


Hay 8 archivos dentro de esta carpeta:

- `B_BCD.S` — Archivo en Assembler con el objetivo de realizar la comunicación entre el periférico y el procesador.

- `Periferico_BBCD.v` — Archivo que instancia el módulo Binario-BCD como un periférico de un procesador RISC-V.

- `Binario-BCD.v` — Módulo TOP del Binario-BCD, el cual declara las variables de entrada y salida del módulo, además de llamar el resto de módulos necesarios.

- `CONTADOR_BBCD.v` — Contador descendente para llevar un registro de ciclos de ejecución realizados.

- `CONTROL_BBCD.v` — Máquina de control del periférico. Genera señales de control para el correcto funcionamiento del periférico (basado en el diagrama de estados).

- `LSR_BBCD.v` — modulo donde se va contruyendo el nuevo nuemero en BCD, se realizan corrimientos bit a bit y luego se compara el valor con un sumador en complemento a dos.

- `SUM_C2_BBCD.v` —modulo donde se compara el valor de cada secccion del numero con 5 para saber si es mayor, menor o igual, si es mayor o igual en este mismo modulo se le suma 3 al numero actual.
  
- `testbench.v` — Módulo TESTBENCH para probar el funcionamiento del periférico. Crea un archivo .vcd que puede ser visualizado en GTKWave.

Si se quiere simular, basta con abrir una terminal en la carpeta Divisor y ejecutar el siguiente código:

```
 iverilog -o sim Binario-BCD.v CONTADOR_BBCD.v CONTROL_BBCD.v LSR_BBCD.v Periferico_BBCD.v SUM_C2_BBCD.v testbench.v
 vvp sim
```
Para visualizar en GTKWave, ejecutar en la terminal:

```
gtkwave tb_Periferico_BinarioABCD.vcd &
```

El testbench posee un numero predeterminado de prueba que puede ser cambiado; se encuentra en la línea 107 de este mismo archivo.

---
### ARCHIVOS ADICIONALES PARA FUNCIONAMIENTO CALCULADORA 

Los siguientes archivos son necesarios para el correcto funcionamiento de una calculadora por hardware implementada mediante el uso de periféricos de un procesador RISC-V. 
- `Calculadora.S` — Archivo principal de la calculadora en Assembler, este se encarga de pedir el primer número por consola, lo lee en formato BCD, lo convierte a binario y lo almacena en uno de los registros del procesador, dependiendo del operador si es multiplicación o división pide el segundo número y nuevamente lo convierte a binario y lo almacena en un registro diferente, en el caso de la raiz no pide un segundo nùmero sino que simplemente llama a la unidad de hardware del operador, finalmente cuando ya se realizó la operación convierte el número de binario a BCD e imprime el resultado.
- `Makefile` — Este archivo se encarga de compilar todos los archivos .S y .c a .o para luego unir todos los archivos .o en un único archivo ejecutable RISC-V (firmware.elf),genera versiones del firmware en formatos adecuados para la simulación en Verilog y para la memoria BRAM de la FPGA, genera un linker script (bram.ld) para una memoria de 16 KB, copia el firmware generado a la carpeta del hardware, garantiza que el archivo Calculadora.o se ubique al inicio de la memoria y permite borrar todo con make clean.
- `Makefile(rtl)` — Este archivo se encarga de unir todos los archivos .v en un archivo .SOC el cual va a la FPGA, el Makefile de hadward compila, sintetiza y simula el hardware en Verilog del SOC y genera un bitstream para cargar en la FPGA.
- `SOC.v` — El SOC ejecuta el programa RISC-V y conecta el CPU con los periféricos hardware que realizan las operaciones, este ejecuta el programa del ensamblador, proporciona el BUS que conecta el RAM con los periféricos, convierte direcciones del CPU en un chip-select al periférico, controla los periféricos, selecciona que periférico envia datos al CPU, proporciona una interfaz UART para hablar con la PC y finalmente integra en  un único sistema funcional lo que permite correr la calculadora totalmente en hardware.
