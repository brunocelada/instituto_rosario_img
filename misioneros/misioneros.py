import pandas as pd
import os

# Cargar el archivo Excel
file_path = "C:/Users/brunocelada/OneDrive - Church of Jesus Christ/SEI/Misioneros Región Rosario/Misioneros Región Rosario.xlsx"

# Obtener la ruta del script actual (donde está este archivo .py)
script_directory = os.path.dirname(os.path.realpath(__file__))

# Convertir cada hoja a un archivo JSON separado en el directorio actual
sheets = pd.read_excel(file_path, sheet_name=None)

for sheet_name, data in sheets.items():
    # Generar el nombre del archivo JSON en el directorio actual
    json_filename = f"{sheet_name.replace(' ', '_')}.json"
    json_path = os.path.join(script_directory, json_filename)
    
    # Guardar el archivo JSON
    data.to_json(json_path, orient='records', force_ascii=False)

print("Conversión a JSON completada en:", script_directory)