extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var time = 0
var startpos = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	startpos = position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	position.y = startpos.y + sin(time) * 10 
	pass
