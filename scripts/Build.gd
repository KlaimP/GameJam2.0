extends Node
class_name Build

enum Type {CASTLE, FACTORY, LUMINAIRE}

@export var type : Type

@onready var castle: PackedScene = load("res://components/Castle.tscn")
@onready var factory: PackedScene = load("res://components/LightGenerator.tscn")
@onready var light: PackedScene = load("res://components/Light.tscn")



func set_build(value):
	type = value
	match value:
		Type.CASTLE:
			add_child(castle.instantiate())
		Type.FACTORY:
			pass
		Type.LUMINAIRE:
			add_child(light.instantiate())
