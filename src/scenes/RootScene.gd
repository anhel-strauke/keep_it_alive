extends Node2D
class_name RootScene

onready var music_animator = $main_music/music_fader

var current_scene: Node = null

var SCENES = {
	"res://scenes/gui/MainMenu.tscn": preload("res://scenes/gui/MainMenu.tscn"),
	"res://scenes/gui/GoodGameOver.tscn": preload("res://scenes/gui/GoodGameOver.tscn"),
	"res://scenes/gui/BadGameOver.tscn": preload("res://scenes/gui/BadGameOver.tscn"),
	"res://scenes/gui/Credits.tscn": preload("res://scenes/gui/Credits.tscn"),
	"res://scenes/game/GameWorld.tscn": preload("res://scenes/game/GameWorld.tscn"),
}


func _ready():
	load_scene("res://scenes/gui/MainMenu.tscn")


func play_music() -> void:
	music_animator.play("play")


func stop_music() -> void:
	music_animator.play("stop")


func load_scene(scene: String) -> void:
	if current_scene:
		current_scene.queue_free()
	if not SCENES.has(scene):
		SCENES[scene] = load(scene)
		print("Warning: scene ", scene, " was not in scene cache!" )
	current_scene = SCENES[scene].instance()
	add_child(current_scene)
