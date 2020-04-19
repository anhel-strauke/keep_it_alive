extends Node2D
class_name PennywiseDrain


onready var area = $ShipCaptureArea
onready var kid_pos = $kid_position

signal kid_captured(kid)


func has_ship(ship: Ship) -> bool:
	return area.overlaps_area(ship.area)


func kid_position() -> Vector2:
	return kid_pos.global_position


func _on_KidCaptureArea_area_entered(area):
	var area_parent = area.get_parent()
	if area_parent is Kid:
		var kid := area_parent as Kid
		emit_signal("kid_captured", kid)
