extends Node2D

var tile

var levelLight := 1
var neededEnergy := 1
var castle

var level = 0
var levelMax = 3
var upgradeCost = [3,5,6]

var lightPower = 1


func _ready():
	EventBus.set_light.connect(func(): modulate = Color.DIM_GRAY)
	castle = EventBus.castle
	castle.add_consumer(self)
	$LevelLabel.text = str(level + 1)


func destroy():
	castle.return_energy(self)
	queue_free()


func light_around():
	tile.change_light(lightPower)
	for neigh in tile.connectedTiles:
		neigh.change_light(lightPower)


func upgrade():
	if level >= levelMax: return
	if castle.take_materials(upgradeCost[level]):
		level += 1
		neededEnergy += 1
		lightPower += 1
		$LevelLabel.text = str(level + 1)
		EventBus.end_turn.emit()


func work():
	light_around()
	modulate = Color.WHITE


func _on_mouse_entered():
	$LevelLabel.show()
	$Button.show()


func _on_mouse_exited():
	$LevelLabel.hide()
	$Button.hide()


func _on_button_pressed():
	upgrade()
