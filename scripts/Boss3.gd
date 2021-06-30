extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var hit = 0
var hp = 400
var time = 0
var active = true
var target = Vector2(8128, 64)


# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().boss_start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active:
		position.x = lerp(position.x, target.x, 0.01)
		position.y = lerp(position.y, target.y, 0.01)
		time += delta
		if time > 2:
			target.x = rand_range(7424, 8832)
			target.y = rand_range(-128, 128)
			time = 0
	pass
