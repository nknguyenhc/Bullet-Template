extends Area2D


const SPEED = 12
var target
var homing = true
var direction

const DAMAGE = 5


func _physics_process(delta):
	if homing:
		direction = (target.position - position).normalized()
		rotation = Vector2.RIGHT.angle_to(direction)
	position += direction * SPEED


func _on_detachment_body_entered(body):
	homing = false


func _on_body_entered(body):
	body.take_damage(DAMAGE)
	queue_free()


func _on_exist_timer_timeout():
	queue_free()
