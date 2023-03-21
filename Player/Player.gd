extends CharacterBody2D


const SPEED = 10 

const Bullet = preload("res://Player/Abilities/Bullet.tscn")


func _physics_process(delta):
	velocity = Vector2(Input.get_action_strength("right") - Input.get_action_strength("left"),
	Input.get_action_strength("down") - Input.get_action_strength("up")).normalized() * SPEED
	position += velocity


func shoot_in_mouse_direction():
	var bullet = Bullet.instantiate()
	bullet.direction = (get_global_mouse_position() - position).normalized()
	get_parent().add_child(bullet)
