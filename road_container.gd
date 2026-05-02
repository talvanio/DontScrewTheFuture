extends Node2D

@export var speed: float = 600.0

@onready var road_1: TileMapLayer = $road_1
@onready var road_2: TileMapLayer = $road_2

var height: float

func _ready() -> void:
	# 🔥 Altura REAL basada en tiles
	var used_rect = road_1.get_used_rect()
	var tile_size = road_1.tile_set.tile_size

	height = used_rect.size.y * tile_size.y

	# Colocar correctamente el segundo TileMap encima
	road_1.position.y = 0
	road_2.position.y = -height


func _process(delta: float) -> void:
	# Movimiento hacia abajo
	road_1.position.y += speed * delta
	road_2.position.y += speed * delta

	# 🔁 Reciclaje infinito
	if road_1.position.y >= height:
		road_1.position.y = road_2.position.y - height

	if road_2.position.y >= height:
		road_2.position.y = road_1.position.y - height
