extends Button


func _on_pressed():
	EventBus.end_turn.emit()
