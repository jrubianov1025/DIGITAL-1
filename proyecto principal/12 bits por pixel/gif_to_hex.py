from PIL import Image
import numpy as np
import sys
import os

def image_to_fpga_hex_lines(img_array):
    """
    Convierte una imagen numpy array a lista de líneas HEX
    EXACTAMENTE como el código del profesor
    Retorna lista de 2048 líneas (cada línea = 6 caracteres hex)
    """
    if img_array.shape[0] != 64 or img_array.shape[1] != 64:
        img_pil = Image.fromarray(img_array)
        img_pil = img_pil.resize((64, 64), Image.Resampling.LANCZOS)
        img_array = np.array(img_pil)
    
    hex_lines = []
    
    for y in range(32):  # Filas 0-31 (mitad superior)
        for x in range(64):  # Todas las columnas
            # Pixel en posición (x, y) - mitad superior
            # INVERTIDO: usar canal azul como rojo y viceversa
            r1 = (img_array[y, x, 2] >> 4)  # Tomar canal AZUL como rojo
            g1 = (img_array[y, x, 1] >> 4)  # Verde sin cambios
            b1 = (img_array[y, x, 0] >> 4)  # Tomar canal ROJO como azul
            
            # Pixel en posición (x, y+32) - mitad inferior
            r2 = (img_array[y+32, x, 2] >> 4)  # Tomar canal AZUL como rojo
            g2 = (img_array[y+32, x, 1] >> 4)  # Verde sin cambios
            b2 = (img_array[y+32, x, 0] >> 4)  # Tomar canal ROJO como azul
            
            # Byte 1: R1[3:0]G1[3:0]
            byte1 = (r1 << 4) | g1
            
            # Byte 2: B1[3:0]R2[3:0]
            byte2 = (b1 << 4) | r2
            
            # Byte 3: G2[3:0]B2[3:0]
            byte3 = (g2 << 4) | b2
            
            # Formato: R1G1B1R2G2B2 como 3 bytes en una línea
            hex_lines.append("%02X%02X%02X" % (byte1, byte2, byte3))
    
    return hex_lines


def gif_to_fpga_with_markers(gif_path, output_hex="../animation.hex", max_fps=None):
    """
    Convierte un GIF a archivo HEX con MARCADORES entre frames
    Mantiene el formato original pero agrega comentarios separadores
    """
    
    print(f"Procesando GIF: {gif_path}")
    print("=" * 60)
    
    try:
        gif = Image.open(gif_path)
    except FileNotFoundError:
        print(f"❌ Error: No se encontró el archivo '{gif_path}'")
        sys.exit(1)
    
    # Obtener información del GIF
    total_frames = gif.n_frames
    try:
        duration_ms = gif.info.get('duration', 100)
        original_fps = 1000 / duration_ms
    except:
        original_fps = 10
        duration_ms = 100
    
    print(f"📊 Información del GIF:")
    print(f"   ├─ Fotogramas totales: {total_frames}")
    print(f"   ├─ FPS original: {original_fps:.2f}")
    print(f"   └─ Duración por frame: {duration_ms}ms")
    
    # Calcular step para reducir FPS si es necesario
    frame_step = 1
    if max_fps and max_fps < original_fps:
        frame_step = int(original_fps / max_fps)
        final_fps = original_fps / frame_step
        print(f"\n⚙️  Optimización:")
        print(f"   ├─ FPS objetivo: {max_fps}")
        print(f"   ├─ Tomando 1 de cada {frame_step} frames")
        print(f"   └─ FPS resultante: {final_fps:.2f}")
    else:
        final_fps = original_fps
    
    final_frame_count = total_frames // frame_step
    
    print(f"\n📦 Procesamiento:")
    print(f"   ├─ Frames a exportar: {final_frame_count}")
    print(f"   ├─ Líneas por frame: 2048")
    print(f"   └─ Total de líneas: {final_frame_count * 2048}")
    
    # Procesar y guardar archivo
    print(f"\n🔄 Convirtiendo frames:")
    
    with open(output_hex, 'w') as f:
        for idx, frame_idx in enumerate(range(0, total_frames, frame_step)):
            gif.seek(frame_idx)
            frame = gif.copy()
            
            # Convertir a RGB si es necesario
            if frame.mode == 'P':
                frame = frame.convert('RGB')
            elif frame.mode != 'RGB':
                frame = frame.convert('RGB')
            
            # Convertir a numpy array
            img_array = np.array(frame)
            
            # Convertir frame a líneas hex
            frame_hex_lines = image_to_fpga_hex_lines(img_array)
            
            # NO escribir comentarios dentro del archivo para evitar problemas
            # Solo escribir las líneas hex puras
            
            # Escribir todas las líneas del frame
            for line in frame_hex_lines:
                f.write(line + '\n')
            
            progress = ((idx + 1) / final_frame_count) * 100
            print(f"   ├─ Frame {idx:3d}: Líneas {idx*2048:5d}-{(idx+1)*2048-1:5d} ({progress:5.1f}%)")
    
    print(f"   └─ ✓ Todos los frames procesados")
    print(f"\n💾 Archivo guardado: {output_hex}")
    
    # Generar archivo de información
    info_file = output_hex.replace('.hex', '_info.txt')
    with open(info_file, 'w') as f:
        f.write(f"Información de Animación\n")
        f.write(f"========================\n\n")
        f.write(f"Archivo: {os.path.basename(gif_path)}\n")
        f.write(f"Frames: {final_frame_count}\n")
        f.write(f"FPS: {final_fps:.2f}\n")
        f.write(f"Delay por frame: {int(1000/final_fps)} ms\n")
        f.write(f"Líneas por frame: 2048\n")
        f.write(f"Líneas totales: {final_frame_count * 2048}\n\n")
        f.write(f"Estructura del archivo:\n")
        f.write(f"  Frame 0: líneas 0-2047\n")
        for i in range(1, min(5, final_frame_count)):
            start = i * 2048
            end = (i + 1) * 2048 - 1
            f.write(f"  // FRAME_{i} (comentario)\n")
            f.write(f"  Frame {i}: líneas {start}-{end}\n")
        if final_frame_count > 5:
            f.write(f"  ...\n")
    
    print(f"📋 Información guardada: {info_file}")
    
    print(f"\n" + "="*60)
    print(f"✅ CONVERSIÓN COMPLETADA")
    print(f"="*60)
    print(f"📁 Archivo: {output_hex}")
    print(f"📊 Frames: {final_frame_count}")
    print(f"⏱️  FPS: {final_fps:.2f}")
    print(f"\n💡 Nota sobre el archivo:")
    print(f"   • SIN comentarios para evitar problemas de indexación")
    print(f"   • Cada frame ocupa EXACTAMENTE 2048 líneas consecutivas")
    print(f"   • Frame N empieza en línea: N * 2048")
    print(f"   • Frame N termina en línea: (N+1) * 2048 - 1")
    print(f"="*60)
    
    return final_frame_count, final_fps


def single_image_to_fpga(image_path, output_hex="../image.hex"):
    """
    Convierte una sola imagen a formato HEX
    EXACTAMENTE como el código del profesor
    """
    print(f"Procesando imagen: {image_path}")
    
    try:
        im = Image.open(image_path)
    except FileNotFoundError:
        print(f"Error: No se encontró el archivo '{image_path}'")
        sys.exit(1)
    
    # Convertir a RGB si está en modo paleta
    if im.mode == 'P':
        im = im.convert('RGB')
    elif im.mode != 'RGB':
        im = im.convert('RGB')
    
    img = np.array(im)
    
    # Verificar dimensiones
    if img.shape[0] != 64 or img.shape[1] != 64:
        print(f"Advertencia: La imagen debe ser 64x64. Dimensiones actuales: {img.shape[1]}x{img.shape[0]}")
        print(f"Redimensionando a 64x64...")
        im = im.resize((64, 64), Image.Resampling.LANCZOS)
        img = np.array(im)
    
    # Generar líneas hex
    hex_lines = image_to_fpga_hex_lines(img)
    
    # Guardar archivo
    with open(output_hex, "w") as f:
        for line in hex_lines:
            f.write(line + '\n')
    
    print(f"✓ Archivo generado: {output_hex}")
    print(f"✓ Líneas escritas: {len(hex_lines)}")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("="*60)
        print("  Conversor de Imágenes/GIF a HEX para FPGA")
        print("  (Compatible con formato del profesor)")
        print("="*60)
        print("\nUso:")
        print("  python3 image_to_hex.py <archivo.png>           # Imagen estática")
        print("  python3 image_to_hex.py <archivo.gif>           # GIF completo")
        print("  python3 image_to_hex.py <archivo.gif> [fps]     # GIF con FPS límite")
        print("\nEjemplos:")
        print("  python3 image_to_hex.py lufy_64x64.png")
        print("  python3 image_to_hex.py animation.gif")
        print("  python3 image_to_hex.py animation.gif 15")
        print("="*60)
        sys.exit(1)
    
    input_file = sys.argv[1]
    
    if not os.path.exists(input_file):
        print(f"❌ Error: No se encuentra el archivo '{input_file}'")
        sys.exit(1)
    
    # Detectar tipo de archivo
    file_ext = os.path.splitext(input_file)[1].lower()
    
    if file_ext == '.gif':
        # Procesar GIF con marcadores
        max_fps = int(sys.argv[2]) if len(sys.argv) > 2 else None
        gif_to_fpga_with_markers(input_file, output_hex="../animation.hex", max_fps=max_fps)
    else:
        # Procesar imagen estática (mantiene formato original del profesor)
        single_image_to_fpga(input_file, output_hex="../image.hex")