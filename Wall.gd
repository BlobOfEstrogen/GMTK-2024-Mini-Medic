extends Line2D
class_name Wall

# Called when the node enters the scene tree for the first time.
func _ready():
	var static_body = StaticBody2D.new()
	var col = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size.x = points[0].distance_to(points[1])
	shape.size.y = width
	col.rotation = points[0].angle_to_point(points[1])
	col.position = (points[0] + points[1])/2.0
	col.shape = shape
	static_body.set_collision_layer_value(1, true)
	add_child(static_body)
	static_body.add_child(col)
	var col2 = CollisionShape2D.new()
	var shape2 = CircleShape2D.new()
	shape2.radius = width/2.0
	col2.rotation = points[0].angle_to_point(points[1])
	col2.position = points[1] 
	col2.shape = shape2
	static_body.add_child(col2)
