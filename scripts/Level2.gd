extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func next_level():
	yield(get_tree().create_timer(5), "timeout")
	Global.savepos = Vector2(512,216)
	Global.level = "res://scenes/Level3.tscn"
	get_tree().change_scene("res://scenes/Level3.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
