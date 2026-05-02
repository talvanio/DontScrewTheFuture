extends Node2D
@onready var heartsContainer = $CanvasLayer/HeartsContainer
@onready var player = $Player
@onready var progress_bar = $CanvasLayer/WinProgressBar

@export var win_time = 10.0

var elapsed_time = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	heartsContainer.set_max_hearts(player.max_health)
	heartsContainer.update_hearts(player.max_health)
	player.healthChanged.connect(heartsContainer.update_hearts)	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	elapsed_time += delta
	update_progress_bar()

	if elapsed_time >= win_time:
		win_game()
		
func update_progress_bar():
	var progress = elapsed_time / win_time

	progress_bar.value = progress * 100

func win_game():
	get_tree().change_scene_to_file("res://victory.tscn")
