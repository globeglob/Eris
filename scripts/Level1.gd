extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer.playing = true
	pass # Replace with function body.

func show_key():
	$Key.visible = true
	yield(get_tree().create_timer(5), "timeout")
	get_tree().change_scene("res://scenes/Level2.tscn")
	Global.savepos = Vector2(904,496)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
