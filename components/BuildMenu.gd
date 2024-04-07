extends Node2D


var choosedTile
var price = [5,7,10]
var castle

func _ready():
	EventBus.end_turn.connect(func(): hide())
	EventBus.open_buid_menu.connect(open_build_menu)
	castle = EventBus.castle


func open_build_menu(tile):
	if tile.building != null:
		return
	choosedTile = tile
	self.show()
	position = tile.position


func _on_create_factory_pressed():
	if !castle.take_materials(price[0]):
		self.hide()
		EventBus.show_info.emit("Not enough material")
		return
	choosedTile.set_build(1)
	self.hide()


func _on_create_light_pressed():
	if !castle.take_materials(price[1]):
		self.hide()
		EventBus.show_info.emit("Not enough material")
		return
	choosedTile.set_build(2)
	self.hide()


func _on_create_generator_pressed():
	if !castle.take_materials(price[2]):
		self.hide()
		EventBus.show_info.emit("Not enough material")
		return
	choosedTile.set_build(3)
	self.hide()
