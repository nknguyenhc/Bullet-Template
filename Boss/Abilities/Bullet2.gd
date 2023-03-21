extends Area2D


const SPEED = 12
var target
var homing = true


func _physics_process(delta):
	if homing:
		position += (target.position - position).normalized() * SPEED


func _on_detachment_body_entered(body):
	homing = false
