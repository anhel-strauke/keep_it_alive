extends Node2D
class_name RootScene

onready var music_animator = $main_music/music_fader

var current_scene: Node = null



func _ready():
	load_scene("res://scenes/gui/MainMenu.tscn")


func play_music() -> void:
	music_animator.play("play")


func stop_music() -> void:
	music_animator.play("stop")


func load_scene(scene: String) -> void:
	if current_scene:
		current_scene.queue_free()
	current_scene = load(scene).instance()
	add_child(current_scene)
