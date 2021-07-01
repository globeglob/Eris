extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var time = 5
var target = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	$Hurtbox.connect("body_entered", self, "_body_entered")
	pass # Replace with function body.

func _body_entered(body):
	if body.filename == "res://scenes/Player.tscn" and time < 4:
		body.hit = true
		if body.position.x < position.x:
			body.hitVector = Vector2(-600,-100)
		else:
			body.hitVector = Vector2(600, -100)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	look_at(target)
	time -= delta
	if time < 4:
		$Sprite/ColorRect.visible = true
	if time < 0:
		queue_free()
	$Sprite.position.y = rand_range(-2,2)
	pass
