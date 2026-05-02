extends CharacterBody2D

signal healthChanged(current_health)
@onready var playerSprite = $PlayerSprite
@export var max_health =  4

var health:int
var screen_size : Vector2
var lanes : Array[float]
var current_lane := 1

# Puts the player in the initial position
func to_initial_position() -> void:
	position.x = lanes[current_lane]

func move_left() -> void:
	current_lane -= 1
	current_lane = max(current_lane, 0)
	
	position.x = lanes[current_lane]

func move_right() -> void:
	current_lane += 1
	current_lane = min(current_lane, lanes.size() - 1)

	position.x = lanes[current_lane]

func _ready() -> void:
	health = max_health
	screen_size = get_viewport_rect().size
	var quarter = screen_size.x / 4.0

	lanes = [
		quarter * 1,
		quarter * 2,
		quarter * 3
	]
	

	to_initial_position()

func _input(event):
	if event.is_action_pressed("move_left"):
		move_left()
	if event.is_action_pressed("move_right"):
		move_right()
		
func die():
	get_tree().change_scene_to_file("res://game_over.tscn")

	
func take_damage():
	health = health - 1
	healthChanged.emit(health)
	if health <= 0:
		die()
		return

	for i in range(3):
		playerSprite.modulate = Color(1,0,0)
		await get_tree().create_timer(0.1).timeout
		
		playerSprite.modulate = Color(1,1,1)
		await get_tree().create_timer(0.1).timeout
		
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:		
	pass
