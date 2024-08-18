extends "res://AiComponent.gd"

var leap_cooldown: float = 1.0
var timer: Timer
var jump_strength: float = 5000.0 

func _ready():
	timer = Timer.new()
	timer.wait_time = leap_cooldown
	timer.timeout.connect(cooldown)
	add_child(timer)

func move(body: Body):
	if search_area and search_area.has_overlapping_bodies() and timer.is_stopped():
		var closest_target
		for target in search_area.get_overlapping_bodies():
			if target is Body or target is Player:
				if closest_target:
					if body.position.distance_to(target.position) < body.position.distance_to(closest_target.position):
						closest_target = target
				else: closest_target = target
		if closest_target: body.apply_force(body.position.direction_to(closest_target.position) * jump_strength)
		timer.start()

func cooldown():
	timer.stop()
