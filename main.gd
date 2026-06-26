extends Node2D
#
var difficulty_timer := 0.0
@export var difficulty_interval := 6
@export var difficulty_multiplier := 0.95
@onready var player = $Player
@onready var hearts_container = $Interface/HeartsContainer
@onready var run_controller = $RunController
@onready var game_over_screen = $Interface/GameOver
@onready var dash_ui = $Interface/DashUI
@export var player_max_health = 4
@onready var distance_label = $Interface/DistanceLabel
@onready var game_over_distance = $Interface/GameOver/DistanceLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_over_screen.visible = false
	player.max_health = player_max_health
	player.health_changed.connect(hearts_container.update_hearts)
	hearts_container.set_max_hearts(player_max_health)
	game_over_screen.restart_pressed.connect(_on_restart)
	player.dash_used.connect(dash_ui.start_cooldown)

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player.current_health > 0:
		difficulty_timer += delta
		distance_label.text = "Puntaje: %d" % (int(run_controller.distance / 400) * 50)

		if difficulty_timer >= difficulty_interval:
			difficulty_timer = 0.0
			increase_difficulty()
	else:
		run_game_over()

		
func _on_restart():
	get_tree().paused = false
	get_tree().reload_current_scene()

func run_game_over() -> void:
	get_tree().paused = true
	game_over_distance.text = "Distância percorrida: %dm" % int(run_controller.distance)
	game_over_screen.visible = true


func increase_difficulty() -> void:
	var gen = $ProjectileGenerator

	gen.spawn_interval *= difficulty_multiplier
	gen.speed_variability += (1-difficulty_multiplier)/2
	# opcional: limitar pra não virar impossível cedo demais
	gen.spawn_interval = max(gen.spawn_interval, 0.1)
