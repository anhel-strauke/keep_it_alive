extends Node2D
class_name GameWorld


var score: int = 0 setget set_score
var hi_score: int = 0 setget set_hiscore
var game_is_over = false

onready var scores_label = $Scores
onready var black_screen_animator = $black_screen/black_anim_player
onready var spawn_lords = [$TutorialSpawnLord, $MainSpawnLord]

func set_score(s: int) -> void:
	score = s
	scores_label.value = s


func add_scores(s: int) -> void:
	self.score = score + s


func _ready():
	for lord in spawn_lords:
		lord.collect_spawners(self)
	$TutorialSpawnLord.enabled = true
	$TutorialSpawnLord.connect("finished", self, "_begin_game")
	set_hiscore(Global.hi_score)


func _begin_game():
	$TutorialSpawnLord.enabled = false
	$MainSpawnLord.enabled = true
	$MainSpawnLord.start()


func _on_game_over():
	$ShipMaster.set_switches_enabled(false)
	Global.last_score = scores_label.value
	black_screen_animator.play("disappear")
	game_is_over = true


func _show_game_over():
	Global.last_score = score
	if score > Global.hi_score:
		Global.hi_score = score
		Global.save_hiscore()
		Global.get_root_scene().load_scene("res://scenes/gui/GoodGameOver.tscn")
	else:
		Global.get_root_scene().load_scene("res://scenes/gui/BadGameOver.tscn")


func set_hiscore(v: int) -> void:
	hi_score = v
	$HiScore.text = str(v)


func transit_to_other_scene():
	if game_is_over:
		_show_game_over()
	else:
		Global.get_root_scene().load_scene("res://scenes/gui/MainMenu.tscn")


func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		game_is_over = false
		black_screen_animator.play("disappear")	
