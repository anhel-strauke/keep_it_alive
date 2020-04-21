extends Node2D


export var value: int = 3 setget set_value
export var max_value: int = 5

var icons = []

signal game_over()


func _ready() -> void:
	var base_name = "baloon_"
	var i = 1
	while true:
		var node = get_node(base_name + str(i))
		if not node:
			break
		icons.append(node)
		node.visible = false
		i += 1
	set_value(value)	


func set_value(v: int) -> void:
	value = v
	if value < 0:
		value = 0
	elif value > max_value:
		value = max_value
	for i in range(icons.size()):
		icons[i].visible = i < value
	if value == 0:
		emit_signal("game_over")


func loose_life():
	set_value(value - 1)


func gain_life():
	set_value(value + 1)
