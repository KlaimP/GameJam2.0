extends Label

var timer: Timer

func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(func(): hide())
	EventBus.show_info.connect(show_info)

func show_info(info: String):
	show()
	text = info
	timer.start(4)
