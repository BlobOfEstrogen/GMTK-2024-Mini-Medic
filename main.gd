extends Node2D

@export var player: Player

# Called when the node enters the scene tree for the first time.
func _ready():
	var timer: Timer = Timer.new()
	timer.autostart = true
	timer.wait_time = 30.0
	timer.timeout.connect(scale_increase)
	add_child(timer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func scale_increase():
	player.scale_up()
