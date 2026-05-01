extends Node2D
@onready var heartsContainer = $CanvasLayer/HeartsContainer
@onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	heartsContainer.set_max_hearts(player.max_health)
	heartsContainer.update_hearts(player.max_health)
	player.healthChanged.connect(heartsContainer.update_hearts)	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
