extends Line2D
class_name Wall

@export var shape: CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	shape.shape.size.x = points[0].distance_to(points[1])
	shape.shape.size.y = width
	shape.rotation = points[0].angle_to_point(points[1])
	shape.position = (points[0] + points[1])/2.0
	
