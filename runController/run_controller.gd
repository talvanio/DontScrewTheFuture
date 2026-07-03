extends Node2D

@export var level_sizes : Array = [1500, 2500, 3500]
var level_roofs : Array

@export var background_speed : int = 500

# --- VARIABLE EXPORTADA (Ahora sí te va a salir en el Inspector) ---
@export var corazon_scene : PackedScene

var current_level: int = 0
var last_level: int

var current_level_roof: int = 0
var distance : float = 0.0

var has_beaten_last_level: bool = false

# --- VARIABLES PARA EL SPAWN DE BONOS ---
var tiempo_ultimo_spawn : float = 0.0
@export var tiempo_entre_spawns : float = 6.0 # Segundos entre cada intento de spawn


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	last_level = level_sizes.size()
	level_roofs = get_accumulated(level_sizes)
	
	# Inicializamos el techo del nivel 0 para que no arranque en 0
	if level_roofs.size() > 0:
		current_level_roof = level_roofs[0]
		
	print("current level: %s" % current_level)
	print("max level: %s" % last_level)


func _process(delta: float) -> void:
	if has_beaten_last_level:
		# Here goes the you won logic 
		return
		
	distance += delta * background_speed
	control_level()
	
	# --- LÓGICA DE SPAWN ---
	tiempo_ultimo_spawn += delta
	if tiempo_ultimo_spawn >= tiempo_entre_spawns:
		tiempo_ultimo_spawn = 0.0
		spawn_corazon()


# Increase current level by 1 and returns it. If this is already the last level, sets "has_beaten_last_level" to true
func next_level() -> int:
	if current_level == last_level:
		print("YOU WON.")
		has_beaten_last_level = true
	else:
		current_level = min(current_level+1,last_level)
		current_level_roof = level_roofs[current_level-1]
		print("---- LEVEL %s ----" %current_level)
		print("current distance: ", int(distance))
		print("current level roof: ", current_level_roof)

	return current_level


func control_level() -> void:
	if distance >= current_level_roof:
		next_level()
	return


# --- FUNCIÓN PARA INSTANCIAR EL CORAZÓN ---
func spawn_corazon() -> void:
	# Si no arrastraste la escena al Inspector, te avisa en consola y no rompe el juego
	if not corazon_scene:
		print("AVISO: No asignaste la escena del corazón en el Inspector de RunController.")
		return
		
	var nuevo_corazon = corazon_scene.instantiate()
	
	# Lo spawneamos justo arriba del viewport (Y = -50)
	# Y en una posición X aleatoria entre los márgenes de la pantalla móvil (ej: entre 60 y 1020)
	var x_aleatoria = randf_range(60.0, 1020.0)
	nuevo_corazon.position = Vector2(x_aleatoria, -50.0)
	
	# Lo metemos a la escena
	add_child(nuevo_corazon)
	print("Spawned corazón en X: ", int(x_aleatoria))


func get_accumulated(array : Array) -> Array:
	var new = []
	var x = 0
	for item in array:
		x += item
		new.append(x)
	return new
