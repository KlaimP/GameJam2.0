extends Node
class_name Build

enum Type {CASTLE, FACTORY, LUMINAIRE, GENERATOR}

@export var type : Type

@onready var castle: PackedScene = load("res://components/Castle.tscn")
@onready var factory: PackedScene = load("res://components/Factory.tscn")
@onready var light: PackedScene = load("res://components/Light.tscn")
@onready var generator: PackedScene = load("res://components/LightGenerator.tscn")

func set_build(value):
	type = value
	match value:
		Type.CASTLE:
			add_child(castle.instantiate())
			EventBus.start_turn.emit()
		Type.FACTORY:
			add_child(factory.instantiate())
		Type.LUMINAIRE:
			add_child(light.instantiate())
		Type.GENERATOR:
			add_child(generator.instantiate())
