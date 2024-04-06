extends Node2D


var choosedTile

func _ready():
	EventBus.open_buid_menu.connect(open_build_menu)


func open_build_menu(tile):
	if tile.building != null:
		return
	choosedTile = tile
	self.show()
	position = tile.position


func _on_create_factory_pressed():
	choosedTile.set_build(1)
	self.hide()


func _on_create_light_pressed():
	choosedTile.set_build(2)
	self.hide()


func _on_create_generator_pressed():
	choosedTile.set_build(3)
	self.hide()
