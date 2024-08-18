extends Node2D
class_name DamageComponent
@export var damage: float = 1.0
@export var type: String
@export var origin: Body

func deal_damage(body):
	if body is Body or body is Player:
		hit_effect(body)
		if body.damage(damage, type, origin):
			kill_effect(body)

func hit_effect(body):
	pass

func kill_effect(body):
	pass
