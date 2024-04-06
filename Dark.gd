extends Node2D

var dark := 0.5
@onready var map = $"../Map"
var dict: Dictionary = {
	
}


func infect():
	pass
	#if get_parent().lightPower < dark:
		#get_parent().dark = self
