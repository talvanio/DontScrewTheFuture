extends CharacterBody2D

@export var projectile_scene: PackedScene 
@export var target_y_position := 150.0    
@export var entrance_duration := 2.0      

var spawn_point: Marker2D
var attack_timer: Timer

func _ready() -> void:
	# Buscamos los nodos hijos dinámicamente por su tipo para evitar errores de nombres
	for child in get_children():
		if child is Marker2D:
			spawn_point = child
		elif child is Timer:
			attack_timer = child

	# Validación de seguridad por si olvidaste crearlos en la escena
	if not attack_timer:
		push_error("ERROR: No se encontró ningún nodo tipo Timer asignado al Miniboss.")
		return
	if not spawn_point:
		push_error("ERROR: No se encontró ningún nodo tipo Marker2D asignado al Miniboss.")
		return

	# Detener el timer hasta que termine la animación de entrada
	attack_timer.stop()
	
	# Asegurar que las señales se conecten automáticamente por código
	if not attack_timer.timeout.is_connected(_on_attack_timer_timeout):
		attack_timer.timeout.connect(_on_attack_timer_timeout)

	position.y = -100.0
	
	var tween = create_tween()
	tween.tween_property(self, "position:y", target_y_position, entrance_duration)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
	
	tween.finished.connect(_on_entrance_finished)

func _on_entrance_finished() -> void:
	if attack_timer:
		attack_timer.start()

func _physics_process(_delta: float) -> void:
	velocity = Vector2.ZERO
	move_and_slide()

func _on_attack_timer_timeout() -> void:
	shoot()

func shoot() -> void:
	if projectile_scene and spawn_point:
		var bullet = projectile_scene.instantiate()
		bullet.global_position = spawn_point.global_position
		
		var player = get_tree().current_scene.get_node_or_null("Player")
		if player:
			bullet.direction = (player.global_position - spawn_point.global_position).normalized()
		else:
			bullet.direction = Vector2.DOWN
			
		get_tree().current_scene.add_child(bullet)
