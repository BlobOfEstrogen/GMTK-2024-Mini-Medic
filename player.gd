extends CharacterBody2D
class_name Player

@export var gun_1: Gun
@export var gun_2: Gun
@export var camera: Camera2D
@export var damaged_by: Array[String]

var speed = 500.0
var drag = 1.0
var mass = 100.0
var target_scale = 1.0

var health = 100.0

func _ready():
	Global.player = self

func _physics_process(delta):
	if scale.x < target_scale: 
		scale = scale * 1.007
		Global.global_scale = scale.x
		print(Global.global_scale)
	if camera.zoom.x > 1.0/target_scale: camera.zoom = camera.zoom / 1.02
	
	#Rotate to mouse position
	rotation = get_viewport_rect().get_center().angle_to_point(get_viewport().get_mouse_position())
	
	#Acceleration via arrow keys
	var accelerate_vec: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if accelerate_vec:
		velocity += (accelerate_vec * speed) * delta
	
	#drag acceleratiion
	var drag_vec = velocity * drag * delta
	velocity -= drag_vec
	
	if move_and_slide():
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			if collider is Body and !collider.has_collided:
				collider.has_collided = true
				var force = (collider.mass * collider.linear_velocity.length()) + (mass * velocity.length())
				collider.apply_force(collision.get_normal() * -force / collider.mass)
				velocity += collision.get_normal() * force / mass
				
				#if collider.damage_component: damage(collider.damage_component.damage, "Projectile")
	
	if Input.is_action_pressed("ui_accept"):
		if gun_1.can_fire: gun_1.fire()
		if gun_2.can_fire: gun_2.fire()

func damage(dmg: float, type: String)->bool:
	if damaged_by.has(type):
		health -= dmg
		print(health)
		if health <= 0: 
			queue_free()
			return true
	return false

func scale_up():
	target_scale = target_scale * 1.2
	gun_1.damage += 1
	gun_2.damage += 1
	gun_1.bullet_scale *= 1.2
	gun_2.bullet_scale *= 1.2
	speed = speed * 1.4
	drag = drag * 1.2
	mass = mass * 1.2
