extends KinematicBody

export var move_accel = 20
export var drag = 0.8
export var jump_force = 40
export var gravity = 60
export var mouse_sens = 0.5

var velocity = Vector3()
var snap_vec = Vector3()

onready var camera = $Camera

signal shoot
signal shoot_auto

onready var weapon1 = $Camera/Smg
onready var weapon2 = $Camera/Shotgun
var cur_weapon_is_1 = true


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	cur_weapon_is_1 = false
	switch_weapons()

func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= mouse_sens * event.relative.x
		camera.rotation_degrees.x -= mouse_sens * event.relative.y
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90, 90)

func _process(delta):
	if Input.is_action_pressed("exit"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("shoot"):
		emit_signal("shoot")
	if Input.is_action_pressed("shoot"):
		emit_signal("shoot_auto")
	if Input.is_action_just_pressed("switch_weapons"):
		switch_weapons()

func switch_weapons():
	cur_weapon_is_1 = !cur_weapon_is_1
	if cur_weapon_is_1:
		if weapon2.is_auto:
			disconnect("shoot_auto", weapon2, "shoot_auto")
		disconnect("shoot", weapon2, "shoot")
		weapon1.show()
		weapon2.hide()
		if weapon1.is_auto:
			connect("shoot_auto", weapon1, "shoot_auto")
		connect("shoot", weapon1, "shoot")
	else:
		if weapon1.is_auto:
			disconnect("shoot_auto", weapon1, "shoot_auto")
		disconnect("shoot", weapon1, "shoot")
		weapon2.show()
		weapon1.hide()
		if weapon2.is_auto:
			connect("shoot_auto", weapon2, "shoot_auto")
		connect("shoot", weapon2, "shoot")

func _physics_process(delta):
	var move_vec = Vector3()
	if Input.is_action_pressed("move_forwards"):
		move_vec += Vector3.FORWARD
	if Input.is_action_pressed("move_backwards"):
		move_vec += Vector3.BACK
	if Input.is_action_pressed("move_left"):
		move_vec += Vector3.LEFT
	if Input.is_action_pressed("move_right"):
		move_vec += Vector3.RIGHT
	move_vec = move_vec.normalized()
	move_vec = move_vec.rotated(Vector3.UP, rotation.y)
	
	velocity += move_accel * move_vec - velocity * Vector3(drag,0,drag) + gravity * Vector3.DOWN * delta
	velocity = move_and_slide_with_snap(velocity + get_floor_velocity() , snap_vec, Vector3.UP, false, 4, PI, false)
	#velocity = move_and_slide(velocity + get_floor_velocity(), Vector3.UP, false, 4, PI, false)
	#move_and_collide(velocity * delta,false)
	var grounded = is_on_floor()
	if grounded:
		velocity.y = -0.01
	if grounded and Input.is_action_just_pressed("jump"):
		velocity.y = jump_force
		snap_vec = Vector3.ZERO
	else:
		snap_vec = Vector3.DOWN