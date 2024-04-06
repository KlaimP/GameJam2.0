extends Node2D

var dark := 0.5
@onready var map = $"../Map"
@onready var art = load("res://dark_2.tscn")

var arr: Array

func _ready():
	EventBus.end_turn.connect(future_infect)
	infect(map.tiles[Vector3(0, 0, 6)])

func infect(tile):
	var infectedTile = art.instantiate()
	tile.add_child(infectedTile)
	tile.dark = infectedTile
	arr.append(tile)

func future_infect():
	pass
