extends Label

var castle

func _ready():
	castle = EventBus.castle
	

func _process(delta):
	text =  str(castle.curMaterials) +" materials"
