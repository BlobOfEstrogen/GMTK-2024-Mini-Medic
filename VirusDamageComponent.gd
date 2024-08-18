extends "res://DamageComponent.gd"
var virus_scene = "res://virus.tscn"

func kill_effect(body):
	for i in 3:
		var virus = load(virus_scene).instantiate()
		virus.global_position = body.global_position
		get_tree().root.add_child(virus)
