extends Node2D
#
var difficulty_timer := 0.0
@export var difficulty_interval := 4
@export var difficulty_multiplier := 0.9
#
@onready var player = $Player
@onready var hearts_container = $HeartsContainer
@onready var run_controller = $RunController
@onready var game_over_screen = $GameOver
@export var player_max_health = 4
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_over_screen.visible = false
	player.max_health = player_max_health
	player.health_changed.connect(hearts_container.update_hearts)
	hearts_container.set_max_hearts(player_max_health)
	game_over_screen.restart_pressed.connect(_on_restart)

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player.current_health > 0:
		difficulty_timer += delta

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
	game_over_screen.visible = true


func increase_difficulty() -> void:
	var gen = $ProjectileGenerator

	gen.spawn_interval *= difficulty_multiplier
	gen.speed_variability += (1-difficulty_multiplier)/2
	# opcional: limitar pra não virar impossível cedo demais
	gen.spawn_interval = max(gen.spawn_interval, 0.1)
