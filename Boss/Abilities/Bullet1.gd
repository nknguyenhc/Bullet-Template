extends Area2D


const SPEED = 20 
var direction
var velocity

const DAMAGE = 3


func _ready():
	velocity = direction * SPEED
	rotation = Vector2.RIGHT.angle_to(direction)
	$AnimatedSprite2D.play()


func _physics_process(delta):
	position += velocity


func _on_body_entered(body):
	body.take_damage(DAMAGE)
	queue_free()


func _on_exist_timer_timeout():
	queue_free()
