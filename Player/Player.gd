extends CharacterBody2D


const SPEED = 10 

const Bullet = preload("res://Player/Abilities/Bullet.tscn")

const MAX_HEALTH = 100
var health = MAX_HEALTH


func _physics_process(delta):
	velocity = Vector2(Input.get_action_strength("right") - Input.get_action_strength("left"),
	Input.get_action_strength("down") - Input.get_action_strength("up")).normalized() * SPEED
	position += velocity


func take_damage(damage):
	health = max(health - damage, 0)


func shoot_in_mouse_direction():
	var bullet = Bullet.instantiate()
	bullet.direction = (get_global_mouse_position() - position).normalized()
	bullet.position = position
	get_parent().add_child(bullet)
