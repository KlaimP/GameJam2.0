extends Label

var castle

func _ready():
	EventBus.change_energy_label.connect(change_energy)

func change_energy(energy_arr):
	text = str(energy_arr[0]) + "/" + str(energy_arr[1]) + " energy"
