extends Panel

@onready var texture_rect = $HeartTexture

@export var full_heart: Texture2D
@export var empty_heart: Texture2D

func set_enabled(enabled: bool):
	if enabled:
		texture_rect.texture = full_heart
	else:
		texture_rect.texture = empty_heart

func _ready():
	print(texture_rect)
	set_enabled(1)
