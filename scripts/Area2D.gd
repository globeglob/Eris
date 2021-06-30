extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "_body_entered")
	pass # Replace with function body.

func _body_entered(body):
	get_tree().change_scene(Global.level)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
