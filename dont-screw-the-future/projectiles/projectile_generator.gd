extends Node2D

@export var projectile_scene: PackedScene
@export var average_projectile_speed: int = 500
@export var speed_variability := 0.25
@export var spawn_interval := 1.0
@onready var run_controller = $"../RunController"

var timer := 0.0

func _process(delta):
	timer += delta

	if timer >= spawn_interval:
		timer = 0.0
		spawn_projectile()

func spawn_projectile():
	var projectile = projectile_scene.instantiate()
	add_child(projectile)
	
	var screen_width = get_viewport_rect().size.x

	var sprite_width = 32
	var x = randf_range(0, screen_width - sprite_width)

	projectile.position = Vector2(x, position.y)
	# média
	var mean_speed = run_controller.background_speed * 1.3

	# desvio padrão = 25% da média
	var deviation = average_projectile_speed * speed_variability

	# distribuição normal
	var randomized_speed = mean_speed * randf_range(1.0, 1+speed_variability)
	
	# evita valores absurdos ou negativos
	randomized_speed = clamp(randomized_speed, mean_speed * 0.5, mean_speed * 1.5)

	projectile.vertical_speed = randomized_speed
