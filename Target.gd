extends StaticBody

export var health = 20

func damage(amnt):
	health -= amnt
	if health <= 0:
		queue_free()