extends AiComponent

var bacteria_scene = "res://bacteria.tscn"

func _ready():
	var timer = Timer.new()
	timer.autostart = true
	timer.wait_time = 90.0
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
	var root = get_tree().root
	if root is Main:
		if root.enemies.size() < root.max_enemies:
			root.enemies.append(new_bacteria)
			root.add_child(new_bacteria)
