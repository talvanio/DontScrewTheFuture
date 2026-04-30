extends Sprite2D

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:		
	pass
