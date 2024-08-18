extends AiComponent

var bacteria_scene = "res://bacteria.tscn"

func _ready():
	var timer = Timer.new()
	timer.autostart = true
	timer.wait_time = 30.0
	timer.timeout.connect(mitosis)
	add_child(timer)

func move(body: Body):
	if is_instance_valid(last_damage):
		if last_damage.is_queued_for_deletion(): last_damage = null
		if last_damage is Body or last_damage is Player:
			body.apply_force(body.position.direction_to(last_damage.position) * speed)

func mitosis():
	var new_bacteria = load(bacteria_scene).instantiate()
	new_bacteria.global_position = global_position
	get_tree().root.add_child(new_bacteria)
