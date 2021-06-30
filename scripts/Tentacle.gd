extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var time = 0
var time2 = 0

var hit = 0
var start_pos = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	start_pos = position
	$Hurtbox.connect("body_entered", self, "_body_entered")
	pass # Replace with function body.

func _body_entered(body):
	if body.filename == "res://scenes/Player.tscn" and get_parent().visible:
		body.hit = true
		if body.position.x < position.x:
			body.hitVector = Vector2(-600,-100)
		else:
			body.hitVector = Vector2(600, -100)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not hit == 0 and get_parent().visible:
		$AnimatedSprite.modulate = Color(0,0,0)
		yield(get_tree().create_timer(0.1), "timeout")
		$AnimatedSprite.modulate = Color(1,1,1)
		get_parent().get_parent()._hit(hit)
		hit = 0
	if get_parent().visible:
		time += delta * rand_range(0,2)
		if time > 2:
			time2 += delta
			position.y = start_pos.y + sin(time2) * 200
			position.x = start_pos.x + sin(time2 * 2) * 50
		if time > 15:
			position = start_pos
			time = 0
	pass
