extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 100
var velocity = Vector2(speed, 0)
var explosion = preload("res://scenes/Explosion.tscn")

var hit = false

var time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Hurtbox.connect("body_entered", self, "_body_entered")
	pass # Replace with function body.

func _body_entered(body):
	if body.filename == "res://scenes/Player.tscn":
		body.hit = true
		if body.position.x < position.x:
			body.hitVector = Vector2(-600,-100)
		else:
			body.hitVector = Vector2(600, -100)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hit:
		var i = explosion.instance()
		i.position = global_position
		i.emitting = true
		get_parent().add_child(i)
		queue_free()
	time += delta
	if time > 10:
		time = 0
		velocity.x = speed
		$AnimatedSprite.flip_h = false
	else:
		if time > 5:
			velocity.x = -speed
			$AnimatedSprite.flip_h = true
	move_and_slide(velocity)
	pass
