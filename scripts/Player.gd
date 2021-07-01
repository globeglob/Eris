extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector2()
var recoil = Vector2()
var speed = 200
var jump_speed = -400
var gravity = 800
var aim = true
var firedelay = 0
var shaderAbberation = 0
var hp = 3
var hit = false
var hitVector = Vector2()
var camera_shake = 1
var charge_time = 0
var charge = false
var required_charge = 0.75
var invincible = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.level == "res://scenes/Level3.tscn":
		$Camera2D/CPUParticles2D.visible = false
	shaderAbberation = 0
	$ParallaxBackground/ParallaxLayer/ColorRect.material.set_shader_param("aberration_amount", shaderAbberation * 10 + 2)
	$ParallaxBackground/ParallaxLayer/ColorRect.material.set_shader_param("boost", shaderAbberation * 2 + 1.2)
	position = Global.savepos
	pass # Replace with function body.

func get_input():
	if not Global.pause and not Global.button:
		velocity.x = 0
		charge = Input.is_action_pressed("fire")
		if Input.is_action_pressed("ui_cancel"):
			get_tree().quit()
		if Input.is_action_pressed("right"):
			$AnimatedSprite.flip_h = false
			velocity.x += speed
		if Input.is_action_pressed("left"):
			$AnimatedSprite.flip_h = true
			velocity.x -= speed
		if Input.is_action_just_released("fire"):
			$Charge.playing = false
		if Input.is_action_just_released("fire") and aim and firedelay <= 0:
			shoot()

func shoot():
	if charge_time > required_charge:
		$Gunfire.playing = true
		shaderAbberation = 2
		firedelay = 0.2
		for i in $Smoke/Area2D.get_overlapping_bodies():
			if "hit" in i:
				i.hit = 10
		if get_global_mouse_position() > global_position:
			recoil = Vector2(-800, 0)
		else:
			recoil = Vector2(800, 0)
		$Smoke.emitting = true
		yield(get_tree().create_timer(0.2), "timeout")
		$Smoke.emitting = false
	else:
		$Gunfire2.playing = true
		shaderAbberation = 0.2
		for i in $Smoke/Area2D.get_overlapping_bodies():
			if "hit" in i:
				i.hit = 1
		$Smoke.emitting = true
		yield(get_tree().create_timer(0.001), "timeout")
		$Smoke.emitting = false

func set_health(hp):
	$ParallaxBackground/ParallaxLayer/Hearts.animation = "flash"
	yield(get_tree().create_timer(0.2), "timeout")
	$ParallaxBackground/ParallaxLayer/Hearts.animation = str(hp)


func _physics_process(delta):
	if invincible > 0:
		invincible -= delta
	if charge and aim:
		speed = 100
		$Smoke2.emitting = true
		if charge_time < required_charge + 0.1:
			charge_time += delta
		if charge_time > 0.2 and not $Charge.playing:
			$Charge.playing = true
		$Charge.pitch_scale = charge_time * 6
	else:
		speed = 200
		charge_time = 0
		$Smoke2.emitting = false
		$Charge.pitch_scale = 1
	if hit and not invincible > 0:
		invincible = 1
		hit = false
		hp -= 1
		set_health(hp)
		recoil = hitVector
		hitVector = Vector2()
		if hp <= 0:
			get_tree().change_scene(Global.level)
	elif hit:
		hit = false
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
		$Smoke2.position.x = 16
	elif aim:
		$AnimatedSprite.flip_h = true
		$Smoke.position.x = -529
		$Smoke2.position.x = -16
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
		if is_on_floor() and not charge:
			velocity.y = jump_speed
