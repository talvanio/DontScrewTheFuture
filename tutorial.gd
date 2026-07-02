extends Node2D

@onready var texto_instrucciones = $InterfaceTutorial/TextoInstrucciones
@onready var timer = $InterfaceTutorial/TutorialTimer

# Traete las escenas que ya tenés creadas
@export var pancho_scene : PackedScene 

var paso_actual : int = 1

func _ready() -> void:
	get_tree().paused = false
	texto_instrucciones.text = "¡ALERTA! El tiempo se rompió.\n USA A Y D PARA MOVERTE."
	timer.start()

func _on_tutorial_timer_timeout() -> void:
	paso_actual += 1
	
	match paso_actual:
		2:
			texto_instrucciones.text = "¡CUIDADO!\n¡Ahí viene un pancho explosivo!"
			spawn_pancho_tutorial()
			# Damos 4 segundos para que lo esquive
			timer.wait_time = 4.0
			timer.start()
		3:
			texto_instrucciones.text = "¡Bien esquivado!\nTu futuro está a salvo por ahora."
			timer.wait_time = 3.0
			timer.start()
		4:
			# Terminó el tutorial, volvemos al menú principal
			get_tree().change_scene_to_file("res://menu_principal.tscn")

func spawn_pancho_tutorial() -> void:
	if not pancho_scene:
		return
	var pancho = pancho_scene.instantiate()
	# Lo spawneamos justo en el medio arriba para que lo vea venir fácil
	pancho.position = Vector2(540, -100) 
	
	# Si tu script de pancho tiene velocidad, la podés bajar acá para que sea lento
	if "speed" in pancho:
		pancho.speed = 500
		
	add_child(pancho)
