extends Node2D

var dark := 0.5
var dict: Dictionary = {
	
}


func infect():
	if get_parent().lightPower < dark:
		get_parent().dark = self
