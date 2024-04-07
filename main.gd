extends Node2D

@onready var dark = $Dark
var castle


func _ready():
	EventBus.win.connect(win)
	EventBus.end_turn.connect(end_turn)
	castle = EventBus.castle


func win():
	pass


func end_turn():
	dark.infect()
	castle.end_turn()
	start_turn()


func start_turn():
	EventBus.set_light.emit()
	EventBus.light.emit()
	castle.start_turn()

