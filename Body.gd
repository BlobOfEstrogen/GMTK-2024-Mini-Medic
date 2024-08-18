extends RigidBody2D
class_name Body
@export var sprite: AnimatedSprite2D
@export var health = 5.0
@export var ai_component: AiComponent
@export var damage_component: DamageComponent
@export var damaged_by: Array[String] = ["Projectile"]
@export var despawn_threshold: float = 2.0

const DRAG = 1.0

var has_collided = false
# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.play()
	set_contact_monitor(true)
	set_max_contacts_reported(1)
	body_entered.connect(attack)

func _integrate_forces(_state):
	if Global.global_scale > despawn_threshold: despawn()
	if ai_component is AiComponent: ai_component.move(self)
	else:
		var rand_vec = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))
		apply_force(rand_vec * randf_range(0.0, 500.0))
	#Drag acceleratiion
	apply_force(linear_velocity * -DRAG)
	has_collided = false

func attack(body):
	if damage_component:
		if body is Body or body is Player:
			damage_component.deal_damage(body)

func damage(dmg: float, type: String, origin)->bool:
	if damaged_by.has(type):
		if origin is Body or origin is Player and ai_component:
			ai_component.last_damage = origin
		health -= dmg
		if health <= 0: 
			queue_free()
			return true
	return false

func despawn():
	queue_free()
