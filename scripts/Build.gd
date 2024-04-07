extends Node
class_name Build

enum Type {CASTLE, FACTORY, LUMINAIRE, GENERATOR}

@export var type : Type

var build

@onready var castle: PackedScene = load("res://components/Castle.tscn")
@onready var factory: PackedScene = load("res://components/Factory.tscn")
@onready var light: PackedScene = load("res://components/Light.tscn")
@onready var generator: PackedScene = load("res://components/LightGenerator.tscn")

func destroy():
	build.destroy()
	queue_free()

func set_build(value):
	type = value
	match value:
		Type.CASTLE:
			var newBuild = castle.instantiate()
			build = newBuild
			add_child(newBuild)
			newBuild.tile = get_parent()
			newBuild.light_around(1)
		Type.FACTORY:
			var newBuild = factory.instantiate()
			build = newBuild
			add_child(newBuild)
		Type.LUMINAIRE:
			var newBuild = light.instantiate()
			build = newBuild
			add_child(newBuild)
			newBuild.tile = get_parent()
			newBuild.light_around(1)
		Type.GENERATOR:
			var newBuild = generator.instantiate()
			build = newBuild
			add_child(newBuild)
