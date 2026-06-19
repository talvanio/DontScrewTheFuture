extends Node

@export var tilemap: TileMapLayer 

# Tamaño de la pantalla en tiles (1080x1920 con bloques de 16x16)
const MAP_WIDTH := 68
const MAP_HEIGHT := 120

# Diccionario de zonas configurado con coordenadas de vectores exactas Vector2i(Columna, Fila)
# Nota: En programación empezamos a contar desde 0.
# Diccionario con las coordenadas exactas de los bloques de arena del nuevo Atlas 16x16
@export var zones: Dictionary = {
	0: Vector2i(0, 4),     # Distancia 0: Arena limpia tipo 1 (Columna 0, Fila 4)
	1500: Vector2i(1, 4),  # Distancia 1500: Arena limpia tipo 2 (Columna 1, Fila 4)
	3000: Vector2i(2, 4)   # Distancia 3000: Arena limpia tipo 3 (Columna 2, Fila 4)
}

var current_zone_threshold := 0

func _ready() -> void:
	if not tilemap:
		push_error("¡ERROR! No has asignado el nodo TileMap al BackgroundController.")
	else:
		# Forzamos el dibujado del primer fondo apenas arranca el juego
		_redraw_floor(zones[0])

func check_background_change(current_distance: float) -> void:
	var thresholds = zones.keys()
	thresholds.sort()
	
	var target_threshold = current_zone_threshold
	for t in thresholds:
		if current_distance >= t:
			target_threshold = t
		else:
			break
			
	if target_threshold != current_zone_threshold:
		current_zone_threshold = target_threshold
		_redraw_floor(zones[current_zone_threshold])

# Dibuja la pantalla usando las coordenadas exactas del Atlas
func _redraw_floor(tile_coords: Vector2i) -> void:
	if not tilemap:
		return
		
	print("Cambiando fondo a coordenadas de Atlas: ", tile_coords)
	
	# Limpiamos todo el mapa para evitar texturas fantasma
	tilemap.clear()
	
	# Llenamos la cuadrícula bloque por bloque con el tile seleccionado
	for x in range(MAP_WIDTH):
		for y in range(MAP_HEIGHT):
			# Parámetros: posición en pantalla, ID de la fuente (usualmente 0), coordenadas en el archivo PNG
			tilemap.set_cell(Vector2i(x, y), 0, tile_coords)
