extends AnimatedSprite2D
class_name Gun

@export var cooldown: float = 0.25
@export var projectile_spawn: Node2D

var can_fire = false
var projectile_scene = "res://projectile.tscn"
var damage = 1.0
var bullet_scale = 1.0

func _ready():
	speed_scale = 1.0/cooldown

func _physics_process(delta):
	if frame == 3 and !can_fire: pause()
	can_fire = !is_playing()

func fire():
	stop()
	play()
	var projectile: Projectile = load(projectile_scene).instantiate()
	projectile.global_position = projectile_spawn.global_position
	projectile.global_rotation = global_rotation
	projectile.scale = Vector2(bullet_scale,bullet_scale)
	projectile.speed *= bullet_scale
	projectile.damage = damage
	get_tree().root.add_child(projectile)
	print(damage)
