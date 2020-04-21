extends Node2D


onready var score_label = $background/score
onready var hi_score_label = $background/hi_score


func _ready():
	score_label.text = str(Global.last_score)
	hi_score_label.text = str(Global.hi_score)
	Global.get_root_scene().stop_music()

func run_main_menu():
	Global.get_root_scene().load_scene("res://scenes/gui/MainMenu.tscn")
