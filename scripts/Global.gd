extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var playerpos = Vector2()
var savepos = Vector2(5952,400) #default 512 216 level 2 boss 5952 400
var level = "res://scenes/Level2.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().change_scene(level)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
