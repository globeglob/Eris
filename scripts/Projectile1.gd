extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 200

var explosion = preload("res://scenes/Explosion2.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "_body_entered")
	pass # Replace with function body.

func _body_entered(body):
	if body.filename == "res://scenes/Player.tscn":
		body.hit = true
		if body.position.x < position.x:
			body.hitVector = Vector2(-600,-100)
		else:
			body.hitVector = Vector2(600, -100)
	var i = explosion.instance()
	i.position = global_position
	i.emitting = true
	get_parent().add_child(i)
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += Vector2(speed, 0).rotated(rotation) * delta
	pass
