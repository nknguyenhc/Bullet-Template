extends CharacterBody2D


const Bullet1 = preload("res://Boss/Abilities/Bullet1.tscn")
const Bullet2 = preload("res://Boss/Abilities/Bullet2.tscn")
var player

const MAX_HEALTH = 100
var health = MAX_HEALTH


func _ready():
	player = get_parent().get_node("Player")


func _physics_process(delta):
	pass


func take_damage(damage):
	health = max(health - damage, 0)


func shoot_at_player():
	var bullet = Bullet1.instantiate()
	bullet.direction = (player.position - position).normalized()
	bullet.position = position
	get_parent().add_child(bullet)


# only used for calculation, not to be used direclty in _physics_process
func perpendicular_image(vector, parallel):
	var parallel_image = vector.length() * cos(parallel.angle_to(vector)) * parallel.normalized()
	return vector - parallel_image


func shoot_preemptive():
	if player.velocity == Vector2.ZERO:
		shoot_at_player()
		return
	var bullet = Bullet1.instantiate()
	var bullet_speed = bullet.SPEED
	var perpendicular_image = perpendicular_image(player.velocity, position - player.position)
	var parallel_length = sqrt(pow(bullet_speed, 2) - pow(perpendicular_image.length(), 2))
	var parallel_image = parallel_length * (player.position - position).normalized()
	bullet.direction = (parallel_image + perpendicular_image).normalized()
	bullet.position = position
	get_parent().add_child(bullet)


func shoot_homing():
	var bullet = Bullet2.instantiate()
	bullet.target = player
	bullet.position = position
	get_parent().add_child(bullet)
