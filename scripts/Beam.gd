extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var time = 5


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
	time -= delta
	if time < 4:
		$AnimatedSprite.visible = false
		$ColorRect.visible = true
	if time < 0:
		queue_free()
	$ColorRect.rect_position.x = rand_range(-2,2) - 16
	pass
