extends Node2D



func _input(event):
	if event.is_action_pressed("esc"):
		if visible: hide()
		else: show()


func _on_exit_button_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")


func _on_resume_button_pressed():
	self.hide()
