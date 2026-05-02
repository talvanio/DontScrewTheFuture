extends Node2D
@export var projectile_scene: PackedScene
@onready var timer = $Timer
@export var projectile_frequency: float = 1.0

@onready var lanes = [
	$Lane1Marker,
	$Lane2Marker,
	$Lane3Marker
]

func _ready():
	timer.wait_time = projectile_frequency
	timer.timeout.connect(_on_timer_timeout)

func shoot():
	var projectile = projectile_scene.instantiate()
	var lane = lanes.pick_random()
	projectile.global_position = lane.global_position
	get_tree().current_scene.add_child(projectile)

func _on_timer_timeout():
	shoot()
