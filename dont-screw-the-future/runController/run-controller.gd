extends Node2D

@export var level_sizes : Array = [1500, 2500, 3500]
var level_roofs : Array

@export var background_speed : int = 500

var current_level: int = 0
var last_level: int

var current_level_roof: int = 0
var distance : float = 0.0

var has_beaten_last_level: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	last_level = level_sizes.size()
	level_roofs = get_accumulated(level_sizes)
	print("current level: %s" % current_level)
	print("max level: %s" % last_level)

func _process(delta: float) -> void:
	if has_beaten_last_level:
		# Here goes the you won logic 
		return
	distance += delta * background_speed
	control_level()

# Increase current level by 1 and returns it. If this is already the last level, sets "has_beaten_last_level" to true
func next_level() -> int:
	if current_level == last_level:
		print("YOU WON.")
		has_beaten_last_level = true
	else:
		current_level = min(current_level+1,last_level)
		current_level_roof = level_roofs[current_level-1]
		print("---- LEVEL %s ----" %current_level)
		print("current distance: ", int(distance))
		print("current level roof: ", current_level_roof)

	return current_level

func control_level() -> void:
	if distance >= current_level_roof:
		next_level()
	return




func get_accumulated(array : Array) -> Array:
	var new = []
	var x = 0
	for item in array:
		x += item
		new.append(x)
	return new
