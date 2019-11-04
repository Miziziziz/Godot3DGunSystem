extends Spatial

onready var graphics = $MeshInstance

export var flash_time = 0.02
var time_since_flashed = 0.0

func _ready():
	graphics.hide()

func emit_flash():
	time_since_flashed = 0.0
	graphics.show()
	graphics.rotate_z(rand_range(0.0, 2 * PI))

func _process(delta):
	time_since_flashed += delta
	if time_since_flashed > flash_time:
		graphics.hide()