extends Node2D


var TILE_SIZE = 32
var TILE_SPACING = 5
var TILE_X_OFFSET: float = TILE_SIZE*2
var TILE_Y_OFFSET: float = 52
var TILE_XY_OFFSET: float = TILE_SIZE

var sizeField = 9

var chanceGenerate = 0.6
var chanceSkip = 0.5
var chanceGenerateStep = 0.0

# Map Size: [Min  Diameter, Max Diameter, Min Number of Tiles, Max Number of Tiles]
var genSizeSettings: Dictionary = {
	0: [1, 4, 32, 40],
	1: [2, 6, 45, 80],
	2: [3, 10, 90, 120],
	3: [4, 15, 200, 350]
}
var numberGenerated: int = 0
var choosedSize: int = 3


@onready var tileScene: PackedScene = load("res://map/tile.tscn")

var tiles: Dictionary




func _ready():
	random_generator()
	set_z_index_in_tiles()
	connect_neighbors()
	tiles[Vector3(0,0,0)].set_build(0)
	EventBus.calculate_edges.emit(find_edges())



func set_z_index_in_tiles():
	for tile in tiles.values():
		tile.z_index = tile.tilePosition.y - tile.tilePosition.z

func random_generator():
	create_tiles_around(set_tile(Vector3.ZERO))
	while tiles.keys().size() < genSizeSettings[choosedSize][2]:
		connect_neighbors()
		var arr = find_low_neighbor_tile()
		create_tiles_around(arr[randi_range(0,arr.size()-1)])

func find_low_neighbor_tile():
	var minTile: Array
	minTile.append(tiles[Vector3.ZERO])
	for tile in tiles.values():
		if tile.connectedTiles.size() == minTile[0].connectedTiles.size():
			minTile.append(tile)
		if tile.connectedTiles.size() < minTile[0].connectedTiles.size():
			minTile.clear()
			minTile.append(tile)
	return minTile

#func find_tile_lowest_coord(): # Не трогать, это проклятая часть кода
	#var maxX = tiles[Vector3.ZERO]
	#var maxY = tiles[Vector3.ZERO]
	#var maxZ = tiles[Vector3.ZERO]
	#var min
	#for tile in tiles.values():
		#if tile.tilePosition.x > maxX.tilePosition.x: maxX = tile
		#if tile.tilePosition.y > maxY.tilePosition.y: maxY = tile
		#if tile.tilePosition.z > maxZ.tilePosition.z: maxZ = tile
	#if maxX.tilePosition.x < maxY.tilePosition.y and maxX.tilePosition.x < maxZ.tilePosition.z:
		#min = maxX
	#elif maxY.tilePosition.y < maxZ.tilePosition.z:
		#min = maxY
	#else: min = maxZ
	#return min

func create_tiles_around(tile):
	if numberGenerated > genSizeSettings[choosedSize][3]: return
	var n = 0
	for neigTile in generate_neighbor_positions(tile.tilePosition):
		n += 1
		if genSizeSettings[choosedSize][1] <= find_max_coord(neigTile):
			continue
		if find_max_coord(neigTile) <= genSizeSettings[choosedSize][0]:
			if tiles.has(neigTile):
				continue
			create_tiles_around(set_tile(neigTile))
			continue
		if randf() < chanceGenerate:
			if randf() > (chanceSkip + chanceGenerateStep * n * randi_range(0,2)): continue
			if tiles.has(neigTile):
				continue
			create_tiles_around(set_tile(neigTile))

func find_max_coord(vec: Vector3):
	return vec.x if vec.x > vec.y and vec.x > vec.z else vec.y if vec.y > vec.z else vec.z

func find_min_coord(vec: Vector3):
	return vec.x if vec.x < vec.y and vec.x < vec.z else vec.y if vec.y < vec.z else vec.z

func find_edges() -> Array:
	var posX = 0
	var negX = 0
	var posY = 0
	var negY = 0
	for tile in tiles.values():
		if tile.position.x > posX: posX = tile.position.x
		if tile.position.y > posY: posY = tile.position.y
		if tile.position.x < negX: negX = tile.position.x
		if tile.position.y < negY: negY = tile.position.y
	return [Vector2(posX, posY), Vector2(negX, negY)]

func connect_neighbors():
	for tile in tiles.values():
		tile.connectedTiles = find_neighbors(tile.tilePosition)
		#tile.draw_line_to_tile()


func generate_neighbor_positions(pos: Vector3) -> Array:
	var arr: Array
	for i in range(2):
		arr.append(change_x(pos, i))
		arr.append(change_y(pos, i))
		arr.append(change_z(pos, i))
	return arr

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

func set_tile(pos: Vector3):
	var newTile = tileScene.instantiate()
	add_child(newTile)
	tiles[pos] = newTile
	newTile.position = hex2world(pos)
	newTile.set_pos_label(pos)
	newTile.tilePosition = pos
	newTile.name = "Tile" + str(pos)
	numberGenerated += 1
	return newTile



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

