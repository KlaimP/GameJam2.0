extends Area2D

@onready var buildScene: PackedScene = load("res://components/Build.tscn")
@onready var lineToTile: Line2D = $LineToTile

var lightPower: int = 0
var building: Build
var dark
var futureDark
var tilePosition: Vector3

var darkNode

var connectedTiles: Array

var isYourTurn: bool = true




func _ready():
	EventBus.take_dark.connect(func(node): darkNode = node)
	EventBus.end_turn.connect(end_turn)
	EventBus.set_light.connect(light_around)
	EventBus.start_turn.connect(func(): isYourTurn = true)
	$Sprite2D.texture = load("res://assets/tile_"+str(randi_range(1,3))+".png")
	set_light(0)


func end_turn():
	isYourTurn = false

func light_around():
	if dark == null: set_light(0)
	else: set_light(-1)


func set_light(value):
	lightPower = -1 if value < -1 else value
	change_color()

func change_light(value):
	lightPower += value
	lightPower = -1 if lightPower < -1 else lightPower
	check_dark()
	change_color()


func check_dark():
	if dark != null:
		if lightPower >= darkNode.calculate_dark(self):
			darkNode.destroy_infection(self)
	if futureDark != null:
		if lightPower >= darkNode.calculate_dark(self):
			darkNode.destroy_infection(self)


func change_color():
	if dark != null: lightPower = -1
	match lightPower:
		-1: $Sprite2D.modulate = Color(0.1, 0.1, 0.1, 1.0); return
		0: $Sprite2D.modulate = Color(0.3, 0.3, 0.3, 1.0); return
		1: $Sprite2D.modulate = Color(0.6, 0.6, 0.6, 1.0); return
		2: $Sprite2D.modulate = Color(0.8, 0.8, 0.8, 1.0); return
	$Sprite2D.modulate = Color(1.0, 1.0, 1.0, 1.0)


func draw_line_to_tile():
	lineToTile.points.clear()
	var arr: Array = []
	for tile in connectedTiles:
		arr.append(Vector2.ZERO)
		arr.append((tile.position - position)/2)
	lineToTile.points = arr


func set_pos_label(pos: Vector3):
	$Label.text = str(pos)


func _on_input_event(_viewport, event: InputEvent, _shape_idx):
	if event.is_action_pressed("lmb"):
		if !isYourTurn:
			return
		if lightPower > 0:
			EventBus.open_buid_menu.emit(self)


func set_build(type: int):
	if type < 0 or type > 4:
		return
	var newBuild = buildScene.instantiate()
	add_child(newBuild)
	building = newBuild
	newBuild.position = Vector2.ZERO
	newBuild.set_build(type)
	EventBus.end_turn.emit()
	
