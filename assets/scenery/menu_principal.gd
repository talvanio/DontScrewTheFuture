extends CanvasLayer

@onready var contenedor_menu = $ContenedorMenu

func _ready() -> void:
	# Nos aseguramos de que el tiempo corra normalmente al entrar al menú
	get_tree().paused = false
	contenedor_menu.visible = true

# --- CONEXIÓN DE SEÑALES DE LOS BOTONES ---

func _on_button_jugar_pressed() -> void:
	# Carga la partida real del juego
	get_tree().change_scene_to_file("res://main.tscn")

func _on_button_tutorial_pressed() -> void:
	# Carga el nivel del tutorial jugable que armamos recién
	get_tree().change_scene_to_file("res://tutorial.tscn")

func _on_button_salir_pressed() -> void:
	# Cierra la aplicación (ideal para cuando lo pases a PC o Android)
	get_tree().quit()
