extends Node2D
class_name Ship

export var speed: float = 25.0
var path: PoolVector2Array = PoolVector2Array()

signal dead_end_reached(ship)

func _ready():
	pass

func _process(delta) -> void:
	if path.size() > 0:
		var distance = speed * delta
		move_along_path(distance)
		
		
# Method taken from https://www.youtube.com/watch?v=0fPOt0Jw52s
func move_along_path(distance: float) -> void:
	var start_point := global_position
	for i in range(path.size()):
		var dist_to_next = start_point.distance_to(path[0])
		if distance <= dist_to_next and distance >= 0.0:
			#var old_glob = global_position
			global_position = start_point.linear_interpolate(path[0], distance / dist_to_next)
			#if old_glob.y > global_position.y:
			#	set_process(false)
			break
		elif distance < 0.0:
			global_position = path[0]
			path.remove(0)
			emit_signal("dead_end_reached", self)
			break
		distance -= dist_to_next
		start_point = path[0]
		path.remove(0)
	if path.size() == 0:
		emit_signal("dead_end_reached", self)
