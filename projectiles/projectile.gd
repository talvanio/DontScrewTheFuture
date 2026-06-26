extends Node2D

@onready var projectile_sprite = $ProjectileSprite
@onready var projectile_hitbox = $ProjectileShape
@onready var explosion_player = $Explosion

@export var rotation_step := 15.0
@export var rotation_interval := 0.15
@export var vertical_speed : float = 40.0

var rotation_timer := 0.0

func _ready():
	var initial_rotation = randi_range(0, 7) * rotation_step
	projectile_sprite.rotation_degrees = initial_rotation
	projectile_hitbox.rotation_degrees = initial_rotation
	explosion_player.visible = false

func _process(delta):
	position.y += delta * vertical_speed
	rotation_timer += delta

	if rotation_timer >= rotation_interval:
		rotation_timer = 0.0
		
		projectile_sprite.rotation_degrees += rotation_step
		projectile_hitbox.rotation_degrees += rotation_step

func explode() -> void:
	set_deferred("monitoring", false)
	projectile_sprite.visible = false
	explosion_player.visible = true
	explosion_player.play("explosion")
	await explosion_player.animation_finished
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(1)
		explode()
