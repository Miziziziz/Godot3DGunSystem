extends Spatial

signal fire

export var fire_rate = 0.2
var last_fire_time = 0.0
export var is_auto = false

func shoot_auto():
	if !is_auto:
		return
	shoot()

func shoot():
	if last_fire_time + fire_rate > get_time():
		return
	last_fire_time = get_time()
	emit_signal("fire")

func get_time():
	return OS.get_ticks_msec() / 1000.0
