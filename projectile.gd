extends Node2D
class_name Projectile

var speed = 500.0
var damage = 1.0
var lifetime = 30.0

func _ready():
	var timer = Timer.new()
	timer.autostart = true
	timer.wait_time = lifetime
	timer.one_shot = true
	add_child(timer)
	timer.timeout.connect(queue_free)

func _physics_process(delta):
	var move_dist = speed*delta
	var direction = Vector2(0.0,0.0).from_angle(global_rotation-PI/2)
	var move_vect = direction*move_dist
	global_position = global_position + move_vect

func _hit(body):
	if body is Body: body.damage(damage, "Projectile", Global.player)
	queue_free()

