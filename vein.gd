extends Node2D
class_name Vein

@export var vein_width: float = 1.0
@export var wall_width: float = 1.0
@export var force: float = 100.0
@export var wall_texture: Texture2D
@export var background_texture: Texture2D
@export var spawn_area: Area2D
@export var segments: int = 100
@export var segment_length: float = 250.0
@export var angle_deviation: float = PI/4
@export var angle_max: float = PI/2
@export var timer: Timer
@export var player: Player
var points: Array[Vector2] = []
var wall_scene = "res://wall.tscn"
var zone_scene = "res://force_zone.tscn"
var spawn_shape_points: PackedVector2Array = []
# Called when the node enters the scene tree for the first time.
func _ready():
	points.append(Vector2(0.0,0.0))
	var point = Vector2(0.0,0.0)
	var direction = 0.0
	
	for i in segments:
		point += Vector2.from_angle(direction) * segment_length
		points.append(point)
		var direction_change = randf_range(-angle_deviation,angle_deviation)
		while direction_change + direction > angle_max or direction_change + direction < -angle_max:
			direction_change = randf_range(-angle_deviation,angle_deviation)
		direction += direction_change
		
		if i == segments/2: player.global_position = point
	
	var previous_pointA 
	var previous_pointB
	var previous_angleA
	var previous_angleB
	
	for i in points.size():
		var angleA: Vector2
		var angleB: Vector2
		if i == 0: 
			angleA = points[i].direction_to(points[i+1]).orthogonal()
		elif i == points.size()-1:
			angleA = -points[i].direction_to(points[i-1]).orthogonal()
		else:
			var angle1 = (points[i].direction_to(points[i+1]).angle_to(points[i].direction_to(points[i-1]))/2.0)
			var angle2 = points[i].direction_to(points[i+1]).angle()
			var angle = angle1 + angle2
			if angle < 0.0: angleA = Vector2.from_angle(angle)
			else: angleA = -Vector2.from_angle(angle)
			
		angleB = -angleA
		var pointA = points[i] + angleA * (vein_width + wall_width/2.0)
		var pointB = points[i] + angleB * (vein_width + wall_width/2.0)
		
		if i != 0:
			var point_array: PackedVector2Array = []
			point_array.append(previous_pointA - previous_angleA * wall_width/2.1)
			point_array.append(previous_pointB - previous_angleB * wall_width/2.1)
			point_array.append(pointB - angleB * wall_width/2.1)
			point_array.append(pointA - angleA * wall_width/2.1)
			var spawn_array: PackedVector2Array = []
			spawn_array.append(previous_pointA - previous_angleA * wall_width)
			spawn_array.append(previous_pointB - previous_angleB * wall_width)
			spawn_array.append(pointB - angleB * wall_width)
			spawn_array.append(pointA - angleA * wall_width)
			var col = CollisionPolygon2D.new()
			col.polygon = spawn_array
			spawn_area.add_child(col)
			var new_zone: ForceZone = load(zone_scene).instantiate()
			new_zone.polygon = point_array
			new_zone.direction = points[i-1].direction_to(points[i])
			new_zone.strength = force
			new_zone.timer = timer
			add_child(new_zone)
			var background: Polygon2D = Polygon2D.new()
			background.polygon = point_array
			background.texture = background_texture
			background.texture_repeat = CanvasItem.TEXTURE_REPEAT_MIRROR
			background.texture_scale = Vector2(0.05,0.05)
			background.texture_rotation = points[i-1].direction_to(points[i]).angle()
			add_child(background)
			var wallA: Wall = load(wall_scene).instantiate()
			wallA.points[0] = previous_pointA
			wallA.points[1] = pointA
			wallA.width = wall_width
			wallA.texture = wall_texture
			wallA.texture_mode = Line2D.LINE_TEXTURE_TILE
			add_child(wallA)
			var wallB: Wall = load(wall_scene).instantiate()
			wallB.points[0] = previous_pointB
			wallB.points[1] = pointB
			wallB.width = wall_width
			wallB.texture = wall_texture
			wallB.texture_mode = Line2D.LINE_TEXTURE_TILE
			add_child(wallB)
		
		previous_pointA = pointA
		previous_pointB = pointB
		previous_angleA = angleA
		previous_angleB = angleB
