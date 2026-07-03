extends Node2D

@onready var run_controller = get_parent()
@onready var speed : float = run_controller.background_speed
@onready var a = $BackgroundDetails
@onready var b = $BackgroundDetails2

var height := 1920

func _ready():
	a.position.y = 0
	b.position.y = -height

func _process(delta):
	var move = speed * delta

	a.position.y += move
	b.position.y += move

	if a.position.y >= height:
		a.position.y = b.position.y - height

	if b.position.y >= height:
		b.position.y = a.position.y - height
