extends Area2D


const SPEED = 20 
var direction
var velocity


func _ready():
	velocity = direction * SPEED


func _physics_process(delta):
	position += velocity
