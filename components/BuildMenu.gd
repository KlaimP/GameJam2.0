extends Node2D


var choosedTile
var price = [2,2,3]
var castle

func _ready():
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
		print("Not have material")
		return
	choosedTile.set_build(1)
	self.hide()


func _on_create_light_pressed():
	if !castle.take_materials(price[1]):
		self.hide()
		print("Not have material")
		return
	choosedTile.set_build(2)
	self.hide()


func _on_create_generator_pressed():
	if !castle.take_materials(price[2]):
		self.hide()
		print("Not have material")
		return
	choosedTile.set_build(3)
	self.hide()
