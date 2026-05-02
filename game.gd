extends Node2D
@onready var heartsContainer = $CanvasLayer/HeartsContainer
@onready var player = $Player

@export var win_time = 30.0

var elapsed_time = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	heartsContainer.set_max_hearts(player.max_health)
	heartsContainer.update_hearts(player.max_health)
	player.healthChanged.connect(heartsContainer.update_hearts)	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	elapsed_time += delta

	if elapsed_time >= win_time:
		win_game()

func win_game():
	get_tree().change_scene_to_file("res://victory.tscn")
