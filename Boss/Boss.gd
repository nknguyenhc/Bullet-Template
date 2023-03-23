extends CharacterBody2D


const Bullet1 = preload("res://Boss/Abilities/Bullet1.tscn")
const Bullet2 = preload("res://Boss/Abilities/Bullet2.tscn")
var player

const MAX_HEALTH = 100
var health = MAX_HEALTH

var damage_count = 0
const DAMAGE_MAX_COUNT = 5

var invincible = false

const MAX_DISTANCE = 1000
var chasing_player = false
const SPEED = 2


func _ready():
	player = get_parent().get_node("Player")
	$AnimatedSprite2D.play()


func _physics_process(delta):
	if player.position.x > position.x:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
	
	if chasing_player:
		velocity = SPEED * (player.position - position).normalized()
		position += velocity
	else:
		velocity = Vector2.ZERO
	
	if (player.position - position).length() > MAX_DISTANCE:
		chasing_player = true
	else:
		chasing_player = false


func take_damage(damage):
	if not invincible:
		health = max(health - damage, 0)
		damage_count += 1 
		if damage_count == DAMAGE_MAX_COUNT:
			damage_count = 0
			$InvincibilityTimer.start()
			$AnimationPlayer.play("taking_damage")
			invincible = true


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


func shoot_all_directions():
	var angle = 0 
	while angle < 2 * PI:
		var bullet = Bullet1.instantiate()
		bullet.direction = Vector2(cos(angle), sin(angle))
		bullet.position = position
		get_parent().add_child(bullet)
		angle += PI / 4


func _on_start_timer_timeout():
	$HomingBulletTimer.start()


func _on_homing_bullet_timer_timeout():
	shoot_homing()
	$AnimatedSprite2D.animation = "shoot"
	$AnimatedSprite2D.play()


func _on_straight_bullet_timer_timeout():
	shoot_at_player()
	shoot_preemptive()
	$AnimatedSprite2D.animation = "shoot"
	$AnimatedSprite2D.play()


func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "shoot":
		$AnimatedSprite2D.animation = "idle"
		$AnimatedSprite2D.play()


func _on_invincibility_timer_timeout():
	$AnimationPlayer.stop()
	invincible = false


func _on_all_direction_timer_timeout():
	shoot_all_directions()
