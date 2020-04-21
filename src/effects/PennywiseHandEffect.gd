extends Node2D


onready var anim_player = $effect_animation

func _ready():
	anim_player.play("reset")
	

func effect(_whatever):
	anim_player.play("hand")
