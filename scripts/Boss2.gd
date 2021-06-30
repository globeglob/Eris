extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var hp = 200
var angry = false
var hit = 0
var explosion = preload("res://scenes/Explosion.tscn")
var projectile = preload("res://scenes/Projectile1.tscn")
var active = false
var target = Vector2(6784, 96)
var time = 0
var firedelay = 0
var hpDisplay = hp
var wake = false
var wakeTime = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	$VisibilityNotifier2D.connect("screen_entered", self, "_screen_entered")
	pass # Replace with function body.

func _screen_entered():
	if not active:
		wake = true

func _hit(amount):
	if active:
		hp -= amount
		if hp < 100:
			$Tentacles.visible = false
			$Body.visible = true
			angry = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if wake:
		wakeTime += delta
		if wakeTime > 5 and wakeTime < 10:
			$Eye.visible = true
			$Eye.animation = "opening"
		if wakeTime > 10:
			$Eye.animation = "default"
			$Tentacles.visible = true
			$ParallaxBackground/ParallaxLayer.visible = true
			wake = false
			active = true
	hpDisplay = lerp(hpDisplay, hp, 0.05)
	$ParallaxBackground/ParallaxLayer/ColorRect.rect_size.x = hpDisplay
	$ParallaxBackground/ParallaxLayer/ColorRect.rect_position.x = -(hpDisplay) / 2
	if angry:
		time += delta * 4
		if time > 10:
			$Eye.animation = "fire"
			if firedelay <= 0:
				firedelay = 0.8 * (hp/100)
				var i = projectile.instance()
				i.global_position = global_position
				i.position.y += 30
				i.look_at(Global.playerpos)
				i.rotation_degrees += rand_range(-60, 60)
				get_parent().add_child(i)
			else:
				firedelay -= delta
		if time > 20:
			time = 0
			$Eye.animation = "default"
			target.x = rand_range(6336,7168)
			target.y = rand_range(0,320)
		position.x = lerp(position.x, target.x, 0.01)
		position.y = lerp(position.y, target.y, 0.01)
		if not hit == 0 and active:
			hp -= hit
			hit = 0
			modulate = Color(0,0,0)
			yield(get_tree().create_timer(0.1), "timeout")
			modulate = Color(1,1,1)
			if hp <= 0:
				var i = explosion.instance()
				i.position = global_position
				i.emitting = true
				get_parent().add_child(i)
				get_parent().next_level()
				queue_free()
		
	pass
