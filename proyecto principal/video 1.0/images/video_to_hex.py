import os
from PIL import Image
import numpy as np

CARPETA = "pattern"
## CARPETA = "arbol-de-navidad"
SALIDA = "video.hex"

def procesar_frame(img, f):
    for y in range(32):
        for x in range(64):
            r1 = (img[y, x, 2] >> 4)
            g1 = (img[y, x, 1] >> 4)
            b1 = (img[y, x, 0] >> 4)

            r2 = (img[y+32, x, 2] >> 4)
            g2 = (img[y+32, x, 1] >> 4)
            b2 = (img[y+32, x, 0] >> 4)

            byte1 = (r1 << 4) | g1
            byte2 = (b1 << 4) | r2
            byte3 = (g2 << 4) | b2

            f.write("%02X%02X%02X\n" % (byte1, byte2, byte3))

frames = sorted(os.listdir(CARPETA))

with open(SALIDA, "w") as f:
    for frame in frames:
        if frame.lower().endswith((".png", ".jpg", ".jpeg")):
            im = Image.open(os.path.join(CARPETA, frame))
            if im.mode == 'P':
                im = im.convert('RGB')
            img = np.array(im)
            print("Agregando frame:", frame)
            procesar_frame(img, f)

print("Listo. Archivo único generado:", SALIDA)
