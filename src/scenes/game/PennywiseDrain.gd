extends Node2D
class_name PennywiseDrain


onready var area = $ShipCaptureArea
onready var kid_pos = $kid_position
onready var kid_effect_pos = $kid_effect_target

signal kid_captured(kid)
signal need_kid_death_effect(glob_from, glob_to, kid_type)


func pause_eyes_animation():
	$eyes_animation.stop(false)


func resume_eyes_animation():
	$eyes_animation.play("eyes")


func has_ship(ship: Ship) -> bool:
	return area.overlaps_area(ship.area)


func kid_position() -> Vector2:
	return kid_pos.global_position


func _on_KidCaptureArea_area_entered(area):
	var area_parent = area.get_parent()
	if area_parent is Kid:
		var kid := area_parent as Kid
		emit_signal("kid_captured", kid)
		emit_signal("need_kid_death_effect", kid.global_position, 
			kid_effect_pos.global_position, kid.coat_color)
		
