extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var active = false
var boot = false
var bootTime = 0

var speed = 100
var defaultSpeed = 30
var velocity = Vector2(speed,0)

var hit = 0
var hp = 100
var hpDisplay = 0

var explosion = preload("res://scenes/Explosion.tscn")
var projectile = preload("res://scenes/Projectile1.tscn")

var time = 0
var firedelay = 0



# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.animation = "inactive"
	$VisibilityNotifier2D.connect("screen_entered", self, "_screen_entered")
	$Hurtbox.connect("body_entered", self, "_body_entered")
	pass # Replace with function body.

func _screen_entered():
	boot = true

func _body_entered(body):
	if body.filename == "res://scenes/Player.tscn" and active:
		body.hit = true
		if body.position.x < position.x:
			body.hitVector = Vector2(-600,-100)
		else:
			body.hitVector = Vector2(600, -100)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	hpDisplay = lerp(hpDisplay, hp, 0.05)
	$ParallaxBackground/ParallaxLayer/ColorRect.rect_size.x = hpDisplay * 5
	$ParallaxBackground/ParallaxLayer/ColorRect.rect_position.x = -(hpDisplay * 5) / 2
	if not hit == 0 and active:
		hp -= hit
		hit = 0
		$CPUParticles2D.emitting = true
		velocity.x = -300
		yield(get_tree().create_timer(0.1), "timeout")
		velocity.x = 30
		$CPUParticles2D.emitting = false
		if hp <= 0:
			get_parent().show_key()
			var i = explosion.instance()
			i.position = global_position
			i.emitting = true
			get_parent().add_child(i)
			queue_free()
	if active:
		time += delta * 3
		if time < 20:
			$AnimatedSprite.animation = "active"
			velocity = Vector2(speed, 0)
			$Pathfinder.look_at(Global.playerpos)
			if Global.playerpos > position:
				$AnimatedSprite.flip_h = true
			else:
				$AnimatedSprite.flip_h = false
			move_and_slide(velocity.rotated($Pathfinder.rotation))
		if time > 20 and time < 22:
			velocity = Vector2(speed * 2, 0)
			$Pathfinder.look_at(Vector2(9984, 640))
			if Global.playerpos > position:
				$AnimatedSprite.flip_h = true
			else:
				$AnimatedSprite.flip_h = false
			move_and_slide(velocity.rotated($Pathfinder.rotation))
		if time > 22 and time < 25:
			$AnimatedSprite.animation = "charge"
		if time > 25 and time < 40:
			if firedelay <= 0:
				firedelay = 1
				$AnimatedSprite.animation = "fire"
				var i = projectile.instance()
				i.global_position = global_position
				i.look_at(Global.playerpos)
				get_parent().add_child(i)
			else:
				firedelay -= delta
		if time > 40:
			time = 0
	if boot:
		bootTime += delta
		if bootTime > 5:
			$AnimatedSprite.animation = "boot"
		if bootTime > 10:
			get_parent().boss_start()
			active = true
			boot = false
			$AnimatedSprite.animation = "active" 
			$ParallaxBackground/ParallaxLayer.visible = true
	pass
