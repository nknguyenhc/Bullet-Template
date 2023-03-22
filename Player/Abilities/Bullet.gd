extends Area2D


const SPEED = 20 
var direction
var velocity

const DAMAGE = 5


func _ready():
	velocity = direction * SPEED
	$AnimatedSprite2D.play()


func _physics_process(delta):
	position += velocity


func _on_body_entered(body):
	body.take_damage(DAMAGE)
	queue_free()


func _on_exist_timer_timeout():
	queue_free()
