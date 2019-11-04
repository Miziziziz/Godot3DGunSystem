extends Spatial

onready var particles = $Particles

export var emit_time = 0.3
var cur_emit_time = 0.0

func emit_smoke():
	particles.emitting = true
	cur_emit_time = 0.0

func _process(delta):
	cur_emit_time += delta
	if cur_emit_time > emit_time:
		particles.emitting = false