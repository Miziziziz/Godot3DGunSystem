extends Spatial

export var damage = 5
export var speed = 50

var bullet_scn = preload("res://Bullet.tscn")

func emit_bullet():
	var new_bullet = bullet_scn.instance()
	get_tree().get_root().add_child(new_bullet)
	new_bullet.global_transform = global_transform
	new_bullet.speed = speed
	new_bullet.damage = damage