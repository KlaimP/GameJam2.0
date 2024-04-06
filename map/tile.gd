extends Area2D

@onready var buildScene: PackedScene = load("res://components/Build.tscn")
@onready var lineToTile: Line2D = $LineToTile

var lightPower: int = 1
var building: Build
var dark
var tilePosition: Vector3

var connectedTiles: Array

var isYourTurn: bool = false




func _ready():
	EventBus.end_turn.connect(func(): isYourTurn = false)

func draw_line_to_tile():
	lineToTile.points.clear()
	var arr: Array
	for tile in connectedTiles:
		arr.append(Vector2.ZERO)
		arr.append((tile.position - position)/2)
	lineToTile.points = arr


func set_pos_label(pos: Vector3):
	$Label.text = str(pos)


func _on_input_event(viewport, event: InputEvent, shape_idx):
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
