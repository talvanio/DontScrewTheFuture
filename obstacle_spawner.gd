extends Node2D
@export var projectile_scene: PackedScene
@onready var timer = $Timer

@onready var lanes = [
	$Lane1Marker,
	$Lane2Marker,
	$Lane3Marker
]

func _ready():
	timer.timeout.connect(_on_timer_timeout)

func shoot():
	var projectile = projectile_scene.instantiate()
	var lane = lanes.pick_random()
	projectile.global_position = lane.global_position
	get_tree().current_scene.add_child(projectile)

func _on_timer_timeout():
	shoot()
