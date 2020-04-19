extends Node2D
class_name WaterSwitch

enum {
	CLICKED,
	IDLE
}

export var auto_switch_time: float = 4.0

var was_pressed := false
var time := 0.0
var base_tile: int = 0
var state = IDLE

onready var particles = $Particles2D

signal clicked_at(global_pos)
signal need_set_tile(global_pos, tile_type)

var busy: bool = false

func _ready() -> void:
	time = randf() * auto_switch_time


func _do_splash():
	if particles.emitting:
		particles.restart()
	else:
		particles.emitting = true


func _switch():
	emit_signal("clicked_at", global_position)
	_do_splash()
	time = 0.0


func _restore():
	emit_signal("need_set_tile", global_position, base_tile)
	_do_splash()


func _process(delta: float) -> void:
	if not busy and state == CLICKED:
		time += delta
		if time > auto_switch_time:
			_restore()
			state = IDLE


func _on_Area2D_input_event(_viewport, event, _shape_idx) -> void:
	if not event:
		return
	if not event is InputEventMouseButton:
		return
	if event.button_index != BUTTON_LEFT:
		return
	if event.pressed and not was_pressed:
		_switch()
		state = CLICKED
		was_pressed = true
	else:
		was_pressed = false
		


func _on_ShipCollisionDetector_area_entered(area):
	busy = true


func _on_ShipCollisionDetector_area_exited(area):
	busy = false
