extends Control


var player
var boss


func _ready():
	player = get_parent().get_node("Player")
	boss = get_parent().get_node("Boss")


func _physics_process(delta):
	$PlayerHealthBar.value = player.health
	$BossHealthBar.value = boss.health
	
	var transform = get_viewport_transform()
	position = get_parent().get_node("Player").position - get_viewport_rect().size
	scale = Vector2(1, 1) / get_parent().get_node("Player/Camera2D").zoom
