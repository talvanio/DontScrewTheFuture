extends CanvasLayer

# Modificadas las referencias para que coincidan EXACTAMENTE con las mayúsculas, minúsculas y espacios de tu árbol
@onready var fondo_oscuro = $Fondo
@onready var contenedor_principal = $"Contenedor principal"
@onready var panel_controles = $PanelControles
@onready var texto_mapeo = $PanelControles/Historia

func _ready() -> void:
	# El menú arranca totalmente oculto al empezar la partida
	ocultar_menu()

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		toggle_pausa()

func toggle_pausa() -> void:
	get_tree().paused = !get_tree().paused
	
	if get_tree().paused:
		mostrar_menu()
	else:
		ocultar_menu()

func mostrar_menu() -> void:
	visible = true
	fondo_oscuro.visible = true
	contenedor_principal.visible = true
	panel_controles.visible = false 

func ocultar_menu() -> void:
	visible = false
	get_tree().paused = false

# --- CONEXIÓN DE SEÑALES DE LOS BOTONES ---

func _on_button_continuar_pressed() -> void:
	toggle_pausa()

func _on_button_controles_pressed() -> void:
	contenedor_principal.visible = false
	panel_controles.visible = true

func _on_button_volver_pressed() -> void:
	panel_controles.visible = false
	contenedor_principal.visible = true

func _on_button_salir_pressed() -> void:
	get_tree().paused = false
	
	visible = false
	
	get_tree().change_scene_to_file("res://assets/scenery/menu_principal.tscn")
