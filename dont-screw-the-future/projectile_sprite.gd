extends Sprite2D

@export var rotation_speed := 100
@export var vertical_speed : float = 40


func _process(delta):
	rotation_degrees += rotation_speed * delta
	position.y = position.y + delta * vertical_speed
