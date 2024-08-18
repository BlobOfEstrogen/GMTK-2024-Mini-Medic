extends Node2D
class_name AiComponent

@export var search_area: Area2D
@export var speed: float = 100.0

var last_damage: PhysicsBody2D

func move(body: Body):
	if search_area and search_area.has_overlapping_bodies():
		var closest_target
		for target in search_area.get_overlapping_bodies():
			if target is Body or target is Player:
				if closest_target:
					if body.position.distance_to(target.position) < body.position.distance_to(closest_target.position):
						closest_target = target
				else: closest_target = target
		if closest_target: body.apply_force(body.position.direction_to(closest_target.position) * speed)
