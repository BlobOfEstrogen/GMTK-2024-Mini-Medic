extends Area2D
class_name ForceZone


@export var timer: Timer
@export var direction: Vector2 = Vector2(0,0)
@export var strength: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_instance_valid(timer): timer.timeout.connect(apply_force)

func _physics_process(delta):
	if not is_instance_valid(timer):
		apply_force(delta)

func apply_force(delta = 1.0):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body is Body:
			print(body)
			body.linear_velocity += direction.normalized() * strength * delta
		if body is Player:
			body.velocity += direction.normalized() * strength * delta
