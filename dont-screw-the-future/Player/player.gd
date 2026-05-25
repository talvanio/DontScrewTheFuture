extends Node2D

@export var horizontal_speed := 600.0
@onready var sprite = $PlayerSprite
@export var max_health: int = 4
@onready var current_health: int = max_health

@export var dash_cooldown: float = 1.5
@export var is_dash_disponible: bool = true
var blinking := false
var viewport_size: Vector2

signal dash_used(cooldown)
signal health_changed(current_health)

const DASH_DISTANCE = 250


func _process(delta: float) -> void:
	var dir = get_input_dir()
	if Input.is_key_pressed(KEY_SHIFT) or Input.is_key_pressed(KEY_SPACE) and is_dash_disponible:
		dash(dir)
	move_player_x_within_boundaries(position.x + dir * horizontal_speed * delta)
	play_directed_animation(dir)

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

func set_dash_disponibility(value: bool):
	is_dash_disponible = value
	emit_signal("dash_disponibility_changed", value)

func dash(dir):
	if !is_dash_disponible or dir == 0:
		return
	set_dash_disponibility(false)
	emit_signal("dash_used", dash_cooldown)
	var target_x = position.x + DASH_DISTANCE * dir
	var tween = create_tween()
	tween.tween_property(self, "position:x", target_x, 0.1)
	await tween.finished
	await get_tree().create_timer(dash_cooldown).timeout
	set_dash_disponibility(true)



func move_player_x_within_boundaries(new_x: float) -> void:
	var viewport_size = get_viewport_rect().size
	var extents = $CollisionShape2D.shape.size.x * 0.5
	position.x = clamp(new_x, extents, viewport_size.x - extents)	

	
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
