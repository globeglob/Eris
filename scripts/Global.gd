extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var playerpos = Vector2()
var savepos = Vector2(6896, -176) #default 512 216 level 2 boss 5952 400 level 3 boss 6896 -176
var level = "res://scenes/Level3.tscn"
var pause = false
var button = false

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().change_scene(level)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
