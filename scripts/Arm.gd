extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var firedelay = 0
var projectile = preload("res://scenes/Projectile1.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_parent().active:
		look_at(Global.playerpos)
		if firedelay <= 0:
			firedelay = 16
			var i = projectile.instance()
			i.global_position = global_position
			i.position += Vector2(64,0).rotated(rotation)
			i.look_at(Global.playerpos)
			get_parent().get_parent().add_child(i)
		else:
			firedelay -= delta
	pass
