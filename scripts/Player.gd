extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector2()
var recoil = Vector2()
var speed = 200
var jump_speed = -400
var gravity = 800
var aim = false
var firedelay = 0
var shaderAbberation = 0

var hp = 3
var hit = false
var hitVector = Vector2()

var camera_shake = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	position = Global.savepos
	pass # Replace with function body.

func get_input():
	velocity.x = 0
	aim = Input.is_action_pressed("aim")
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	if Input.is_action_pressed("right"):
		$AnimatedSprite.flip_h = false
		velocity.x += speed
	if Input.is_action_pressed("left"):
		$AnimatedSprite.flip_h = true
		velocity.x -= speed
	if Input.is_action_just_pressed("fire") and aim and firedelay <= 0:
		shoot()

func shoot():
	$Gunfire.playing = true
	shaderAbberation = 2
	firedelay = 2
	for i in $Smoke/Area2D.get_overlapping_bodies():
		if "hit" in i:
			i.hit = true
	if get_global_mouse_position() > global_position:
		recoil = Vector2(-800, 0)
	else:
		recoil = Vector2(800, 0)
	$Smoke.emitting = true
	$Camera2D/ColorRect.visible = true
	yield(get_tree().create_timer(0.1), "timeout")
	$Camera2D/ColorRect.visible = false
	$Smoke.emitting = false

func set_health(hp):
	$ParallaxBackground/ParallaxLayer/Hearts.animation = "flash"
	yield(get_tree().create_timer(0.2), "timeout")
	$ParallaxBackground/ParallaxLayer/Hearts.animation = str(hp)


func _physics_process(delta):
	if hit:
		hit = false
		hp -= 1
		set_health(hp)
		recoil = hitVector
		hitVector = Vector2()
		if hp <= 0:
			get_tree().change_scene(Global.level)
	recoil.x = lerp(recoil.x, 0, 0.05)
	recoil.y = lerp(recoil.y, 0, 0.5)
	
	if shaderAbberation > 0:
		shaderAbberation -= delta
		$ParallaxBackground/ParallaxLayer/ColorRect.material.set_shader_param("aberration_amount", shaderAbberation * 10 + 2)
		$ParallaxBackground/ParallaxLayer/ColorRect.material.set_shader_param("boost", shaderAbberation * 2 + 1.2)
	
	if firedelay > 0:
		$Camera2D.offset_h = rand_range(-int(firedelay * camera_shake),int(firedelay * camera_shake))
		$Camera2D.offset_v = rand_range(-int(firedelay * camera_shake/2),int(firedelay * camera_shake/2))
		firedelay -= delta
	
	get_input()
	if aim and get_global_mouse_position() > global_position:
		$AnimatedSprite.flip_h = false
		$Smoke.position.x = 529
	elif aim:
		$AnimatedSprite.flip_h = true
		$Smoke.position.x = -529
	if is_on_floor() and not velocity.x == 0:
		if aim:
			$AnimatedSprite.animation = "walk_aim"
		else:
			$AnimatedSprite.animation = "walk"
	elif not is_on_floor():
		if aim:
			$AnimatedSprite.animation = "jump_aim"
		else:
			$AnimatedSprite.animation = "jump"
	else:
		if aim:
			$AnimatedSprite.animation = "aim"
		else:
			$AnimatedSprite.animation = "idle"
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity + recoil, Vector2.UP)
	if not velocity.x == 0:
		Global.playerpos = position
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_speed