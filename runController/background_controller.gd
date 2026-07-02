extends Node2D

# Le clavamos una velocidad fija de 500 solo para el tutorial sin depender del padre
var speed : float = 500.0
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
