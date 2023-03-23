extends CharacterBody2D


const LOWER_SPEED = 10
const UPPER_SPEED = 30
var speed = LOWER_SPEED
var dashing = false
var dash_enabled = true
var direction

const Bullet = preload("res://Player/Abilities/Bullet.tscn")

const MAX_HEALTH = 100
var health = MAX_HEALTH

var bullet_enabled = true


func _physics_process(delta):
	if not dashing:
		direction = Vector2(Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")).normalized()
	velocity = direction * speed
	position += velocity
	if Input.is_action_just_pressed("dash"):
		dash()
	
	if Input.is_action_pressed("attack"):
		shoot_in_mouse_direction()


func take_damage(damage):
	health = max(health - damage, 0)


func shoot_in_mouse_direction():
	if bullet_enabled:
		bullet_enabled = false
		$BulletTimer.start()
		var bullet = Bullet.instantiate()
		bullet.direction = (get_global_mouse_position() - position).normalized()
		bullet.position = position
		get_parent().add_child(bullet)


func dash():
	if not dashing and dash_enabled:
		dashing = true
		dash_enabled = false
		speed = UPPER_SPEED
		$DashTimer.start()
		$DashCooldown.start()


func _on_bullet_timer_timeout():
	bullet_enabled = true


func _on_dash_timer_timeout():
	dashing = false
	speed = LOWER_SPEED


func _on_dash_cooldown_timeout():
	dash_enabled = true
