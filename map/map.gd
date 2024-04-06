extends Node2D


var TILE_SIZE = 32
var TILE_SPACING = 15
var TILE_X_OFFSET: float = TILE_SIZE*2
var TILE_Y_OFFSET: float = 52
var TILE_XY_OFFSET: float = TILE_SIZE

var sizeField = 7

@onready var tile: PackedScene = load("res://map/tile.tscn")

var tiles: Dictionary = {
	
}




func _ready():
	create_tile_field()






func create_tile_field():
	set_tile(Vector3(0,0,0))
	for i in range(1,sizeField):
		set_tile(Vector3(i,0,0))
		set_tile(Vector3(0,i,0))
		set_tile(Vector3(0,0,i))
		for k in range(1,sizeField):
			set_tile(Vector3(i,k,0))
			set_tile(Vector3(i,0,k))
			set_tile(Vector3(0,i,k))

func set_tile(pos: Vector3):
	var newTile = tile.instantiate()
	add_child(newTile)
	tiles[pos] = newTile
	newTile.position = hex2world(pos)
	newTile.set_pos_label(pos)



func hex2world(hexPos: Vector3) -> Vector2:
	var worldPos: Vector2 = Vector2.ZERO
	worldPos.x = (hexPos.x * (TILE_X_OFFSET + TILE_SPACING) - (hexPos.y + hexPos.z) * (TILE_XY_OFFSET + TILE_SPACING/2))
	worldPos.y = (TILE_Y_OFFSET + TILE_SPACING) * (hexPos.y - hexPos.z)
	return worldPos

# НЕ ТРОГАТЬ, ПОКА НЕ РАБОТАЕТ
#func world2hex(worldPos: Vector2) -> Vector3:
	#var hexPos: Vector3
	#hexPos.x = worldPos.x
	#hexPos.y = (hexPos.y - hexPos.z) / (TILE_Y_OFFSET + TILE_SPACING)
	#return snapped(hexPos, Vector3(1,1,1))

