extends Node2D


var time: float


func _ready() -> void:
	$CPUParticles2D.emitting = true
	time = $CPUParticles2D.lifetime


func _process(delta: float) -> void:
	if not $CPUParticles2D.emitting:
		time -= delta
		if time < 0.0:
			queue_free()

