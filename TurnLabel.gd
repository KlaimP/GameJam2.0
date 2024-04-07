extends Label

func _ready():
	EventBus.change_turn_label.connect(change_label)

func change_label(value):
	text = "Trun " + str(value)
