extends Node2D


var TILE_SIZE = 32
var TILE_SPACING = 15
var TILE_X_OFFSET: float = TILE_SIZE*2
var TILE_Y_OFFSET: float = 52
var TILE_XY_OFFSET: float = TILE_SIZE

var sizeField = 7

@onready var tile: PackedScene = load("res://map/tile.tscn")

var tiles: Dictionary




func _ready():
	create_tile_field()
	connect_neighbors()



func connect_neighbors():
	for tile in tiles.values():
		tile.connectedTiles = find_neighbors(tile.tilePosition)
		tile.draw_line_to_tile()



func find_neighbors(pos: Vector3) -> Array:
	var arr: Array
	for i in range(2):
		if(tiles.has(change_x(pos, i))): arr.append(tiles[change_x(pos, i)])
		if(tiles.has(change_y(pos, i))): arr.append(tiles[change_y(pos, i)])
		if(tiles.has(change_z(pos, i))): arr.append(tiles[change_z(pos, i)])
	return arr

func change_x(pos: Vector3, positiv: bool) -> Vector3:
	var vec: Vector3
	if positiv:
		if pos.x > 0 or (pos.y == 0 or pos.z == 0): vec = Vector3(pos.x+1, pos.y, pos.z)
		else: vec = Vector3(pos.x, pos.y-1, pos.z-1)
	else:
		if pos.x > 0: vec = Vector3(pos.x-1, pos.y, pos.z)
		else: vec = Vector3(pos.x, pos.y+1, pos.z+1)
	return vec

func change_y(pos: Vector3, positiv: bool) -> Vector3:
	var vec: Vector3
	if positiv:
		if pos.y > 0 or (pos.x == 0 or pos.z == 0): vec = Vector3(pos.x, pos.y+1, pos.z)
		else: vec = Vector3(pos.x-1, pos.y, pos.z-1)
	else:
		if pos.y > 0: vec = Vector3(pos.x, pos.y-1, pos.z)
		else: vec = Vector3(pos.x+1, pos.y, pos.z+1)
	return vec

func change_z(pos: Vector3, positiv: bool) -> Vector3:
	var vec: Vector3
	if positiv:
		if pos.z > 0 or (pos.x == 0 or pos.y == 0): vec = Vector3(pos.x, pos.y, pos.z+1)
		else: vec = Vector3(pos.x-1, pos.y-1, pos.z)
	else:
		if pos.z > 0: vec = Vector3(pos.x, pos.y, pos.z-1)
		else: vec = Vector3(pos.x+1, pos.y+1, pos.z)
	return vec


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
	tiles[Vector3(0,0,0)].set_build(0)

func set_tile(pos: Vector3):
	var newTile = tile.instantiate()
	add_child(newTile)
	tiles[pos] = newTile
	newTile.position = hex2world(pos)
	newTile.set_pos_label(pos)
	newTile.tilePosition = pos
	newTile.name = "Tile" + str(pos)



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

