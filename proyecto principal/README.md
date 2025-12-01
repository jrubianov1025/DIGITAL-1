## 📘 Descripción de los módulos

En esta carpeta se encuentran 2 carpetas principales, una contiene el ejemplo suministrado por el docente la cual contiene los módulos necesarios para proyectar una imagen estática de 12 bits por pixel en una pantalla led 64x64, y la otra carpeta corresponde a nuestro proyecto en donde en vez de proyectar una imágen estática proyectamos un video.

Cada unas de las carpetas contiene los siguientes módulos: 

###  12 bits por pixel 

- `led_panel_4k.v` — Este es el módulo principal el cuál declara las variables de entrada y salida del módulo, además de llamar el resto de módulos necesarios.
  
- `ctrl_lp4k.v` — Máquina de control del periférico. Genera señales de control para el correcto funcionamiento del periférico 

###  Video

Para está para del proyecto se utiliza fundamentalmente los módulos de la otra carpeta pero adaptada para video. Contiene un archivo en python y por otro lado se modifica el módulo de memory para reproducir el video en la pantalla.

- `gif_to_hex.py` — Este código de python se encarga de tomar el archivo .gif y pasarlo en formato .hex para que el módulo memory.v pueda trabajar con el mismo.

- `memory.v` — Este módulo implementa una memoria para almacenar imágenes estáticas o animaciones en formato .hex, permite manejar múltiples frames, calculando el tiempo entre ellos según la frecuencia del reloj y un delay configurable.
  

