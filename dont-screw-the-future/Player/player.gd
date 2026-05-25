extends Node2D

@export var horizontal_speed := 600.0
@onready var sprite = $PlayerSprite
@export var max_health: int = 4
@onready var current_health: int = max_health
var blinking := false
var viewport_size: Vector2
signal health_changed(current_health)



func _process(delta: float) -> void:
	var dir = get_input_dir()

	position.x = move_player_x(position.x + dir * horizontal_speed * delta)
	
	play_directed_animation(dir)

func move_player_x(new_x: float) -> float:
	var viewport_size = get_viewport_rect().size
	var extents = $CollisionShape2D.shape.size.x * 0.5

	return clamp(new_x, extents, viewport_size.x - extents)	

func get_input_dir() -> int:
	var dir := 0
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		dir -= 1
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		dir += 1
	return dir

func play_directed_animation(dir):
	if dir < 0:
		sprite.play("walk_left")
	elif dir > 0:
		sprite.play("walk_right")
	else:
		sprite.play("walk_up")


	
func take_damage(damage: int) -> void:
	current_health -= damage
	current_health = max(current_health, 0)
	emit_signal("health_changed", current_health)
	blink_red()
	
func blink_red():
	if blinking:
		return

	blinking = true

	for i in range(2):
		sprite.modulate = Color(1, 0.3, 0.3) # vermelho
		await get_tree().create_timer(0.08).timeout

		sprite.modulate = Color(1, 1, 1) # normal
		await get_tree().create_timer(0.1).timeout

		
	blinking = false
