## 📘 Descripción de los módulos

En esta carpeta se encuentran 2 carpetas principales, una contiene el ejemplo suministrado por el docente la cual contiene los módulos necesarios para proyectar una imagen estática de 12 bits por pixel en una pantalla led 64x64, y la otra carpeta corresponde a nuestro proyecto en donde en vez de proyectar una imágen estática proyectamos un video.

Cada unas de las carpetas contiene los siguientes módulos: 


### 🖼️🔴🟢🔵 12 bits por pixel 

Se describe con mas detalle el funcionamiento del modulo mediante el uso de 3 diagramas, Diagrama de flujo, Datapath y Diagrama de estados; a continuación se anexan estos 3 diagramas.

<p align="center">
  <img src="./diagrama de flujo" width="350">
  <img src="./diagrama de estados" width="350"> 
  <img src="./data path" width="350">
</p>

A modo de resumen, se específica en la siguiente tabla las diferentes variables presentes en el diseño.

| Señal          | I/O    | Descripción                       |
| -------------- | ------ | --------------------------------- |
| `clk`          | Input  | Señal de reloj                    |
| `rst`          | Input  | Reset síncrono para inicializar   |
| `init`         | Input  | Señal de inicio                   |
| `LP_CLK`       | Output | Desplaza datos a los registros    |
| `LATCH`        | Output | Transfiere los datos              |
| `NOE`          | Output | Habilita la visualización         |
| `ROW`          | Output | Selección de la fila del panel    |              
| `RGB0`         | Output | Canales del semipanel superior    |
| `RGB1`         | Output | Canales del semipanel inferior    |         
| `mem_w_data`   | Input  | Dirección a escribir en la memoria|
| `mem_w_address`| Input  | Dato de 24 bits para almacenar    |
| `we_a`         | Input  | Señal de habilitación de escritura|

- `led_panel_4k.v` — Este es el módulo principal el cuál declara las variables de entrada y salida del módulo, además de llamar el resto de módulos necesarios.
  
- `ctrl_lp4k.v` — Máquina de control del periférico. Genera señales de control para el correcto funcionamiento del periférico.

- `comp.v` — Es un comparador de dos números binarios del mismo ancho (in1 e in2) y activa la señal out = 1 cuando son iguales, se usa en el control del panel para detectar cuando se cumplen ciertos tiempos o límites.
  
- `count.v` — Es un contador ascendente, el cuál permite recorrer las filas y columnas, controlar cuánto tiempo se enciende el bit actual y manejar los niveles de brillo (bitplanes).

- `lsr_led.v` — Este módulo genera el valor delay que se compara con el contador count_delay para controlar cuanto tiempo debe estar encendida la fila para cada bit de brillo.

- `memory.v` — El módulo memory es el que almacena la imagen que se mostrará en el panel LED.
  
- `mux_led.v` — Este módulo selecciona qué bit de cada color (R,G,B) se va a enviar al panel LED, dependiendo del bitplane actual.

- ### ARCHIVOS ADICIONALES PARA FUNCIONAMIENTO PANTALLA LED

Los siguientes archivos son necesarios para el correcto funcionamiento de la pantalla LED.

- `Makefile` — Este archivo gestiona la compilación y simulación de los módulos necesarios para el funcionamiento de la pantalla.


###  📽️🔴🟢🔵 Video

- `Comparador.v` — Este módulo compara dos buses de entrada del mismo ancho y genera un 1 cuando ambos valores son iguales y 0 en caso contrario.
  
- `Contador.v` —  Contador descendente para llevar un registro de ciclos de ejecución realizados.
  
- `Control_video.v` — Este módulo se encarga de controlar el flujo completo de video hacia el panel LED. 

- `Led_panel_video.v` — Módulo que funciona como el controlador principal para panel RGB basado en multiplexación y reproducción de video por frames.
Este módulo sincroniza la lectura de memoria, la generación de clocks, el escaneo de filas/columnas y el envío de datos RGB hacia un panel LED.

- `Lsr_led.v` — Este módulo, funciona como el registro de desplazamiento parametrizable para control de LEDs. Carga un valor inicial predefinido y luego lo desplaza hacia la izquierda en cada pulso negativo del reloj cuando la señal shift está habilitada.

- `Multiplexor.v` — Este módulo implementa un multiplexor de 4 a 1 que selecciona, según el índice sel, un bit específico de cada uno de los seis canales de color provenientes de dos píxeles (RGB0 y RGB1).

- `led_panel_video.lpf` — Este archivo define las restricciones físicas y temporales del diseño para la FPGA, asignando cada señal del módulo led_panel_video a un pin específico del dispositivo utilizado (Intel Cyclone IV E: 5E-75A), configurando sus características eléctricas.

- `led_panel_video_pnr.log` — Este archivo muestra el uso de recursos de la FPGA cuando se está reproduciendo el video.

- `memory_doble.v` — Este módulo implementa un sistema de doble buffer para almacenar los datos necesarios para reproducir el video. Está diseñado para permitir escritura y lectura simultánea en dos memorias separadas, evitando tearing y asegurando actualización fluida de cuadros en aplicaciones como paneles LED.

- `memory_principal.v` — Este módulo implementa una memoria ROM cargada desde archivo, diseñada para almacenar una secuencia completa de imágenes o frames que serán reproducidos por el sistema de video del panel LED.

- `video.hex` — Este archivo contiene un ejemplo de como queda la información de un video .gif en formato hexadecimal.

- `tb_led_panel_video.v` — Módulo TESTBENCH para probar el funcionamiento del periférico. Crea un archivo .vcd que puede ser visualizado en GTKWave.

Si se quiere simular, basta con abrir una terminal en la carpeta Video y ejecutar el siguiente código:

```
iverilog -o sim testbench.v Comparador.v Contador.v Control_video.v Led_panel_video.v Lsr_led.v Multiplexor.v memory_doble.v memory_principal.v
vvp sim
```

Para visualizar en GTKWave, ejecutar en la terminal:

```
gtkwave tb_led_panel_video.vcd &
```

Adicionalmente, dentro de la carpeta Video, se encuentra la carpeta image, en la cual hay dos archivos y dos carpetas más. Las carpetas contienen las frames que componen cada video, en formato .png. Por otro lado, se encuentran:

- `video_to_hex.py` — Este código se encarga de convertir cada imagen en un arreglo RGB y genera un archivo video.hex donde cada línea contiene tres bytes obtenidos al empaquetar dos píxeles verticalmente alineados con sus canales reducidos a 4 bits.
  
- `video.hex` —  Este archivo contiene la información necesaria para la reproducción del video en formato hexadecimal.
  





