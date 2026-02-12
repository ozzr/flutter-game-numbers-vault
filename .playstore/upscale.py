import os
from PIL import Image

# Carpeta de entrada con imágenes
input_folder = "images"
# Archivo de salida
output_file = "feature_graphic.png"

# Dimensiones finales requeridas
target_width, target_height = 1024, 500

# Crear lienzo vacío (blanco)
canvas = Image.new("RGB", (target_width, target_height), (255, 255, 255))

# Obtener lista de imágenes
files = [f for f in os.listdir(input_folder) if f.lower().endswith((".png", ".jpg", ".jpeg"))]

n = len(files)
if n == 0:
    raise ValueError("No se encontraron imágenes en la carpeta.")

# Dividir ancho disponible entre número de imágenes
slot_width = target_width // n
x_offset = 0

for f in files:
    img = Image.open(os.path.join(input_folder, f))
    
    # Escalar proporcionalmente para que encaje en el espacio asignado
    img.thumbnail((slot_width, target_height), Image.LANCZOS)
    
    # Crear fondo blanco del tamaño del slot
    slot = Image.new("RGB", (slot_width, target_height), (255, 255, 255))
    
    # Calcular posición centrada dentro del slot
    x_center = (slot_width - img.width) // 2
    y_center = (target_height - img.height) // 2
    
    # Pegar imagen en el slot
    slot.paste(img, (x_center, y_center))
    
    # Pegar slot en el lienzo final
    canvas.paste(slot, (x_offset, 0))
    x_offset += slot_width

# Guardar resultado
canvas.save(output_file, format="PNG", optimize=True)
print(f"Feature graphic generado: {output_file}")