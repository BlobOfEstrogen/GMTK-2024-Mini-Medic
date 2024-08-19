extends Node2D
class_name Main

@export var player: Player
@export var scale_timer: Timer
@export var spawn_timer: Timer
@export var spawn_area: Area2D
@export var spawn_attemptes: int = 25
@export var despawn_range: float = 1.7
@export var spawn_range_max: float = 1.5
@export var spawn_range_min: float = 1.2
@export var max_enemies: int = 100
var spawn_list = [
	{"Weight": 500.0, "Scene": "res://blood_cell.tscn", "Threshold": 3.0},
	{"Weight": 100.0, "Scene": "res://virus.tscn", "Threshold": 2.0},
	{"Weight": 20.0, "Scene": "res://white_blood_cell.tscn", "Threshold": 8.0},
	{"Weight": 1.0, "Scene": "res://bacteria.tscn", "Threshold": 24.0},
	#{"Weight": 2, "Scene": ""},
	#{"Weight": 1, "Scene": ""},
]
var enemies = []
# Called when the node enters the scene tree for the first time.
func _ready():
	scale_timer.timeout.connect(scale_increase)
	spawn_timer.timeout.connect(spawn_enemies)

func _physics_process(delta):
	enemies = enemies.reduce(remove_invalid,[])

func scale_increase():
	player.scale_up()
	for scene in spawn_list:
		if player.target_scale >= scene["Threshold"]:
			spawn_list.erase(scene)

func spawn_enemies():
	var weight_max = 0.0
	for scene in spawn_list:
		weight_max += scene["Weight"]
	var center = player.camera.get_screen_center_position()
	var center_scale = 1.0/player.camera.zoom.x
	for i in spawn_attemptes:
		if enemies.size() >= max_enemies: break
		var spawn_direction = randf_range(0.0,2*PI)
		var spawn_distance = get_viewport_rect().size / 2.0  * center_scale * randf_range(spawn_range_min,spawn_range_max)
		var spawn_point = center + spawn_distance.rotated(spawn_direction)
		var spawn_float = randf_range(0.0,weight_max)
		for scene in spawn_list:
			var weight = scene["Weight"]
			if spawn_float <= weight:
				var new_enemy = load(scene["Scene"]).instantiate()
				new_enemy.position = spawn_point
				enemies.append(new_enemy)
				add_child(new_enemy)
			else: spawn_float -= weight
	print(enemies.size())

func remove_invalid(accum: Array, a):
	if is_instance_valid(a): 
		if a is Body:
			if spawn_area.overlaps_body(a):
				var center: Vector2 = player.camera.get_screen_center_position()
				var center_scale = 1.0/player.camera.zoom.x
				if center.distance_to((get_viewport_rect().size / 2.0) * center_scale * despawn_range) < center.distance_to(a.global_position):
					accum.append(a)
			else: a.queue_free()
	return accum
