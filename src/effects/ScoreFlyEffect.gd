extends Node2D


var value: int = 0 setget set_value


func set_value(v: int):
	value = v
	$label/Label.text = str(v)
