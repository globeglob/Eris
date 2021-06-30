extends TextureButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("mouse_entered", self, "_mouse_entered")
	connect("mouse_exited", self, "_mouse_exited")
	pass # Replace with function body.

func _mouse_entered():
	Global.button = true

func _mouse_exited():
	Global.button = false

func _pressed():
	$Panel.visible = true
	Global.pause = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
