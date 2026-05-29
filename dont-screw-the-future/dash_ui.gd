extends TextureProgressBar

func _ready():
	value = max_value

func start_cooldown(cooldown):
	max_value = cooldown
	value = 0
	
	create_tween().tween_property(
		self,
		"value",
		cooldown,
		cooldown
	)
