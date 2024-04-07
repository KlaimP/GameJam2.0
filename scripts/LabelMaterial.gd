extends Label

var castle

func _ready():
	EventBus.change_materials_label.connect(change_materials)

func change_materials(materials):
	text =  str(materials) + " materials"
