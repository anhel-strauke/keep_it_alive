extends Node2D
class_name KidDeathEffect


var total_time := 0.3
var time := 0.0
var coat_color := 0 setget set_coat_color
var global_target_point := Vector2.ZERO
var global_start_point := Vector2.INF setget set_global_start_point
var scores: int = 100
onready var sprite = $sprite


signal finished(scores)


func set_coat_color(color: int) -> void:
	coat_color = color
	if sprite:
		sprite.frame = color


func _ready() -> void:
	set_process(false)


func _process(delta: float) -> void:
	if global_start_point == Vector2.INF:
		return
	sprite.frame = coat_color
	time += delta
	global_position = global_start_point.linear_interpolate(global_target_point, time / total_time)
	if time >= total_time:
		emit_signal("finished", scores)
		queue_free()


func set_global_start_point(point: Vector2) -> void:
	global_start_point = point
	global_position = point
	set_process(true)
