extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var fade = false
var opacity = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	#$VisibilityNotifier2D.connect("screen_entered", self, "_screen_entered")
	pass # Replace with function body.

#func _screen_entered():
#	fade = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#if fade:
	#	opacity -= 0.125 * delta
	#	modulate = Color(1, 1, 1, opacity)
	#	if opacity < 0:
	#		queue_free()
	#pass
