extends Area2D

# Declaramos la velocidad base por si no encuentra al controlador
var speed : float = 500.0

func _ready() -> void:
	# Buscamos al RunController subiendo en el árbol de nodos de forma segura
	var parent_node = get_parent()
	
	# Si el corazón es hijo directo del RunController, esto lo encuentra al toque
	if parent_node and "background_speed" in parent_node:
		speed = parent_node.background_speed
	else:
		# Si está metido en otra parte, buscamos al nodo por su nombre en la escena actual
		var run_ctrl = get_tree().current_scene.find_child("RunController", true, false)
		if run_ctrl:
			speed = run_ctrl.background_speed

func _process(delta: float) -> void:
	# El bonus baja usando la velocidad detectada
	position.y += speed * delta
	
	# Si pasa el límite inferior de la pantalla vertical (1920), se borra solo
	if position.y > 1920:
		queue_free()

# Señal de colisión con el jugador
func _on_body_entered(body: Node2D) -> void:
	if body.has_method("add_health"):
		var pudo_curar = body.add_health(1)
		if pudo_curar:
			queue_free()
