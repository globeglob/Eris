extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var hit = 0
var hp = 100
var time = 0
var time2 = 0
var active = false
var target = Vector2(8128, 64)
var explosion = preload("res://scenes/Explosion.tscn")
var beam = preload("res://scenes/Beam.tscn")
var hpDisplay = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	$VisibilityNotifier2D.connect("screen_entered", self, "_screen_entered")
	pass # Replace with function body.

func _screen_entered():
	$ParallaxBackground/ParallaxLayer.visible = true
	active = true
	get_parent().boss_start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active:
		hpDisplay = lerp(hpDisplay, hp, 0.05)
		$ParallaxBackground/ParallaxLayer/ColorRect.rect_size.x = hpDisplay * 2
		$ParallaxBackground/ParallaxLayer/ColorRect.rect_position.x = -(hpDisplay) / 1
		position.x = lerp(position.x, target.x, 0.01)
		position.y = lerp(position.y, target.y, 0.01)
		time += delta
		time2 += delta * (100/(hp+2))
		if time > 2:
			target.x = rand_range(7424, 8832)
			target.y = rand_range(-128, 128)
			time = 0
		if time2 > 10:
			var i = beam.instance()
			i.position.y = 0
			i.position.x = rand_range(7424, 8832)
			get_parent().add_child(i)
			time2 = 0
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
			#get_parent().next_level()
			queue_free()
	pass
