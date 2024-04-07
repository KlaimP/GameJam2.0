extends Node2D

var tile

var levelLight := 1
var neededEnergy := 1
var castle

var level = 0
var levelMax = 2
var upgradeCost = [8,10]

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
		lightPower += level
		$LevelLabel.text = str(level + 1)
		EventBus.end_turn.emit()
		tile.change_light(0)
		for neigh in tile.connectedTiles:
			neigh.change_light(0)
		if level >= levelMax: $Button.hide()
	else:
		EventBus.show_info.emit("Not enough material")


func work():
	light_around()
	modulate = Color.WHITE


func _on_mouse_entered():
	$LevelLabel.show()
	if level >= levelMax: return
	$Button.show()


func _on_mouse_exited():
	$LevelLabel.hide()
	$Button.hide()


func _on_button_pressed():
	upgrade()
