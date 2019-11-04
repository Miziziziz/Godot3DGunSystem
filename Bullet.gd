extends KinematicBody

# set by emitter
var speed = 0
var damage = 0

const LIFESPAN = 10.0
var time_alive = 0.0

var sparks = preload("res://Sparks.tscn")

func _physics_process(delta):
	var collision = move_and_collide(global_transform.basis.z * speed * delta)
	if collision:
		if collision.collider.has_method("damage"):
			collision.collider.damage(damage)
		queue_free()
		create_hit_effects()
	
	time_alive += delta
	if time_alive > LIFESPAN:
		queue_free()

func create_hit_effects():
	var new_sparks = sparks.instance()
	get_tree().get_root().add_child(new_sparks)
	new_sparks.global_transform = global_transform
	new_sparks.emitting = true