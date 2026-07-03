extends Node2D

@export var horizontal_speed := 800.0
@onready var sprite = $PlayerSprite
@onready var damage_sound = $DamageSound
@onready var heal_sound = $HealSound
@onready var dash_sound = $DashSound
@export var max_health: int = 4

# Corregido: Se inicializa normal y se asegura el valor máximo
var current_health: int = max_health

@export var dash_cooldown: float = 2.5
@export var dash_on_cooldown: bool = false
var blinking := false
var viewport_size: Vector2

var is_dashing := false
signal dash_used(cooldown)
signal health_changed(current_health)

const DASH_DISTANCE = 350


func _ready() -> void:
	# Nos aseguramos de que arranque con la vida máxima seteada
	current_health = max_health
	emit_signal("health_changed", current_health)


func _process(delta: float) -> void:
	var player_input = get_player_input()
	
	if player_input.dash:
		dash_if_disponible(player_input.dir)

	move_player_x_within_boundaries(position.x + player_input.dir * horizontal_speed * delta)
	if !is_dashing:
		play_directed_animation(player_input.dir)


func get_player_input() -> Dictionary:
	return {
		"dir": Input.get_axis("move_left", "move_right"),
		"dash": Input.is_action_just_pressed("dash")
	}


func play_directed_animation(dir):
	var animation := "walk_up"

	if dir < 0:
		animation = "walk_left"
	elif dir > 0:
		animation = "walk_right"
	# Don't restart the animation each process()
	if sprite.animation != animation:
		sprite.play(animation)


func dash_if_disponible(dir):
	if !can_dash(dir):
		return

	set_dash_on_cooldown()
	await start_dash(dir)
	move_player_x_within_boundaries(position.x + DASH_DISTANCE * dir)
	await dash_end()


func start_dash(dir):
	is_dashing = true
	$CollisionShape2D.disabled = true
	dash_sound.play()
	sprite.play("blink")
	await sprite.animation_finished


func can_dash(dir) -> bool:
	return (
		dir != 0
		and !is_dashing
		and !dash_on_cooldown
	)


func dash_end():
	sprite.play("blink_reverse")
	await sprite.animation_finished
	is_dashing = false
	$CollisionShape2D.disabled = false


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


func set_dash_on_cooldown():
	dash_on_cooldown = true
	emit_signal("dash_used", dash_cooldown)
	await get_tree().create_timer(dash_cooldown).timeout
	dash_on_cooldown = false


func take_damage(damage: int) -> void:
	current_health -= damage
	current_health = max(current_health, 0)
	damage_sound.play()
	
	emit_signal("health_changed", current_health)
	blink_red()


# --- NUEVA FUNCIÓN PARA RECOGER CORAZONES ---
func add_health(amount: int) -> bool:
	# Si ya tiene las vidas al palo (4 o más), rechaza la curación
	if current_health >= max_health:
		print("Vidas llenas (", current_health, "/", max_health, "). No se puede recoger.")
		return false
		

	# Sumamos la vida sin pasarnos del máximo
	heal_sound.play()
	current_health = min(current_health + amount, max_health)
	emit_signal("health_changed", current_health)
	print("¡Vida recogida! Vida actual: ", current_health)
	
	# Opcional: Podés meter un destello verde acá para feedback visual
	return true
