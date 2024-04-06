extends Node
class_name Build
@onready var energyConsumer: PackedScene = load("res://components/EnergyConsumer.tscn")
@onready var light: PackedScene = load("res://components/Light.tscn")

enum Type {HOUSE, FACTORY, LUMINAIRE, POWER_GRID}

@export var type : Type

func _ready():
	add_child(energyConsumer.instantiate())
	add_child(light.instantiate())

func set_build(value):
	type = value
