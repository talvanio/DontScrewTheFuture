#extends Node2D
#@onready var heartsContainer = $CanvasLayer/HeartsContainer
#@onready var player = $Player
#
#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#heartsContainer.set_max_hearts(player.max_health)
	#heartsContainer.update_hearts(player.max_health)
	#player.healthChanged.connect(heartsContainer.update_hearts)	
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

##NUEVO
extends Node2D
@onready var heartsContainer = $CanvasLayer/HeartsContainer
@onready var player = $Player
@onready var tiempo_label = $CanvasLayer/TiempoLabel

# Victoria
var tiempo_para_ganar: float = 20.0  # Cambia este valor según necesites
var timer_victoria: Timer
var juego_activo: bool = false
var ha_ganado: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	heartsContainer.set_max_hearts(player.max_health)
	heartsContainer.update_hearts(player.max_health)
	player.healthChanged.connect(heartsContainer.update_hearts)
	
	# Conectar señal de muerte del jugador
	if player.has_signal("player_died"):
		player.player_died.connect(_on_player_died)
	
	# Crear y configurar el timer de victoria
	timer_victoria = Timer.new()
	timer_victoria.one_shot = true
	timer_victoria.wait_time = tiempo_para_ganar
	timer_victoria.timeout.connect(_on_victoria_alcanzada)
	add_child(timer_victoria)
	
	# Iniciar el timer automáticamente cuando empieza el juego
	iniciar_timer_victoria()

func iniciar_timer_victoria():
	"""Inicia el contador para ganar el juego"""
	juego_activo = true
	ha_ganado = false
	timer_victoria.start()
	print("Timer de victoria iniciado: ", tiempo_para_ganar, " segundos")

func _on_player_died():
	"""Se llama cuando el jugador muere"""
	if juego_activo and not ha_ganado:
		timer_victoria.stop()
		juego_activo = false
		print("Timer detenido - jugador murió")

func _on_victoria_alcanzada():
	"""Se llama cuando el jugador sobrevive el tiempo necesario"""
	if juego_activo:
		ha_ganado = true
		juego_activo = false
		print("¡Victoria alcanzada!")
		# Cambiar a la escena de victoria
		get_tree().change_scene_to_file("res://victory.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if juego_activo and timer_victoria:
		var tiempo_restante = int(timer_victoria.time_left)
		tiempo_label.text = "Time: " + str(tiempo_restante) + "s"
