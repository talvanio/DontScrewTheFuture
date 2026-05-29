extends Area2D

@export var speed := 450.0
@export var collision_radius := 30.0 # El tamaño (en píxeles) del radio de golpe del proyectil
var direction := Vector2.DOWN
var player_node: Node2D = null

func _ready() -> void:
	# Buscamos al jugador directamente en el árbol de escenas al aparecer
	player_node = get_tree().current_scene.get_node_or_null("Player") as Node2D

func _process(delta: float) -> void:
	# 1. Movimiento limpio del proyectil
	position += direction * speed * delta

	# 2. Sistema de colisión matemático manual (por distancia)
	if player_node and is_instance_valid(player_node):
		# Calculamos la distancia exacta en píxeles entre este proyectil y el jugador
		var distance = global_position.distance_to(player_node.global_position)
		
		# Si la distancia es menor al radio de colisión, es un impacto
		if distance <= collision_radius:
			impact_player()

func impact_player() -> void:
	# Desactivamos el proceso para que no aplique daño más de una vez
	set_process(false)
	
	if player_node.has_method("take_damage"):
		player_node.take_damage(1) # Le quita un corazón
		
	queue_free() # Destruye el proyectil

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
