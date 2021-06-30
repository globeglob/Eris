extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 40
var velocity = Vector2(speed, 0)
var explosion = preload("res://scenes/Explosion.tscn")
var projectile = preload("res://scenes/Projectile1.tscn")

var hit = 0
var hp = 12

var time = 0
var firedelay = 0
var active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$VisibilityNotifier2D.connect("screen_entered", self, "_screen_entered")
	pass # Replace with function body.

func _screen_entered():
	active = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active:
		if firedelay <= 0:
			firedelay = 2
			var i = projectile.instance()
			i.global_position = global_position
			i.look_at(Global.playerpos)
			get_parent().add_child(i)
		else:
			firedelay -= delta
	if not hit == 0:
		hp -= hit
		hit = 0
		$CPUParticles2D.emitting = true
		yield(get_tree().create_timer(0.1), "timeout")
		$CPUParticles2D.emitting = false
		if hp <= 0:
			var i = explosion.instance()
			i.position = global_position
			i.emitting = true
			get_parent().add_child(i)
			queue_free()
	time += delta
	if time > 10:
		time = 0
		velocity.x = speed
		$AnimatedSprite.flip_h = true
	else:
		if time > 5:
			velocity.x = -speed
			$AnimatedSprite.flip_h = false
	move_and_slide(velocity)
	pass
