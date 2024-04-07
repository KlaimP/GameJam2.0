extends Node2D

func _on_button_pressed():
	get_tree().change_scene_to_file("res://main.tscn")


func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")
