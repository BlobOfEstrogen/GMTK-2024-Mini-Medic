extends AiComponent



func move(body: Body):
	if last_damage and (last_damage is Body or last_damage is Player):
		body.apply_force(body.position.direction_to(last_damage.position) * speed)
