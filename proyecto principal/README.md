## 📘 Descripción de los módulos

En esta carpeta se encuentran 2 carpetas principales, una contiene el ejemplo suministrado por el docente la cual contiene los módulos necesarios para proyectar una imagen estática de 12 bits por pixel en una pantalla led 64x64, y la otra carpeta corresponde a nuestro proyecto en donde en vez de proyectar una imágen estática proyectamos un video.

Cada unas de las carpetas contiene los siguientes módulos: 


### 🖼️🔴🟢🔵 12 bits por pixel 

- `led_panel_4k.v` — Este es el módulo principal el cuál declara las variables de entrada y salida del módulo, además de llamar el resto de módulos necesarios.
  
- `ctrl_lp4k.v` — Máquina de control del periférico. Genera señales de control para el correcto funcionamiento del periférico.

- `comp.v` — Es un comparador de dos números binarios del mismo ancho (in1 e in2) y activa la señal out = 1 cuando son iguales, se usa en el control del panel para detectar cuando se cumplen ciertos tiempos o límites.
  
- `count.v` — Es un contador ascendente, el cuál permite recorrer las filas y columnas, controlar cuánto tiempo se enciende el bit actual y manejar los niveles de brillo (bitplanes).

- `lsr_led.v` — Este módulo genera el valor delay que se compara con el contador count_delay para controlar cuanto tiempo debe estar encendida la fila para cada bit de brillo.

- `memory.v` — El módulo memory es el que almacena la imagen que se mostrará en el panel LED.
  
- `mux_led.v` — Este módulo selecciona qué bit de cada color (R,G,B) se va a enviar al panel LED, dependiendo del bitplane actual.
  

###  📽️🔴🟢🔵 Video

- `Comparador.v` — Este módulo compara dos buses de entrada del mismo ancho y genera un 1 cuando ambos valores son iguales y 0 en caso contrario.
  
- `Contador.v` —  Contador descendente para llevar un registro de ciclos de ejecución realizados.
  
- `Control_video.v` — Este módulo es la máquina de estados, que se encarga de controlar el flujo completo de video hacia el panel LED. 

- `Led_panel_video.v` — Módulo que funciona como el controlador principal para panel RGB basado en multiplexación y reproducción de video por frames.
Este módulo sincroniza la lectura de memoria, la generación de clocks, el escaneo de filas/columnas y el envío de datos RGB hacia un panel LED.

- `Lsr_led.v` —

- `Multiplexor.v` —

- `led_panel_video.lpf` —

- `led_panel_video_pnr.log` —

- `memory_doble.v` —

- `memory_principal.v` —

- `sim` —

- `synth.log` —

- `tb_led_panel_video.v` —
 
- `video.hex` —



