extends KinematicBody2D

class_name Player


const TILE = 32

const V_X_MAX = 6 * TILE
const X_ACCEL = 24 * TILE
const X_DECEL = 24 * TILE
const V_X_CUTOFF = 0.25 * TILE

const V_Y_MAX = 32 * TILE
const V_Y_MIN = -32 * TILE

const JUMP_HEIGHT = 3.2 * TILE
const JUMP_GRAV_REDUCTION = 1.5 #increases gravity when not jumping
const JUMP_SPEED_REDUCTION = 0.8 #decreses speen when you let go of jump
const GRAVITY = -21 * TILE
const JUMP_SPEED = sqrt(-2 * GRAVITY * JUMP_HEIGHT)

const MAX_COYOTE_TIME = 8

var v = Vector2()
var jumping = false
var coyote_time = 0

var paused = true
var doors_enabled = false


func _ready():
	v = Vector2(0,0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _check_grounded():
	if move_and_collide(Vector2(0, 0.5), true, true, true):
		coyote_time = 5
	elif coyote_time > 0:
		coyote_time -= 1


func _get_input_x(delta):
	var dir = Input.is_action_pressed("right") as int
	dir -= Input.is_action_pressed("left") as int
	if dir == 0:
		if abs(v.x) < V_X_CUTOFF:
			v.x = 0
		else:
			var new_vx = v.x - sign(v.x) * X_DECEL * delta
			if sign(v.x) != sign(new_vx):
				v.x = 0
			else:
				v.x = new_vx
	else:
		v.x += dir * X_ACCEL * delta


func _get_input_y(delta):
	if coyote_time > 0:
		if Input.is_action_just_pressed("jump"):
			v.y = JUMP_SPEED
			coyote_time = 0
			jumping = true
		else:
			v.y = clamp(v.y, 0, v.y);
	else:
		if v.y < 0:
			jumping = false
		elif Input.is_action_just_released("jump"):
			jumping = false
			v.y *= JUMP_SPEED_REDUCTION
		var y_accel = GRAVITY * delta
		if not jumping:
			y_accel = y_accel * JUMP_GRAV_REDUCTION
		v.y += y_accel
		


func _do_animation():
	if coyote_time <= 0:
		$AnimatedSprite.play("jump")
	elif v.x == 0:
		$AnimatedSprite.play("stand")
	else:
		$AnimatedSprite.play("move")
	if v.x > 0:
		$AnimatedSprite.set_flip_h(false)
	if v.x < 0:
		$AnimatedSprite.set_flip_h(true)


func _physics_process(delta):
	if paused:
		return
	_check_grounded()
	_get_input_x(delta)
	v.x = clamp(v.x, -V_X_MAX, V_X_MAX)
	_get_input_y(delta)
	_do_animation()
	v.y = clamp(v.y, V_Y_MIN, V_Y_MAX)
	
	# flip the velocity vector vertically at the last second
	var flipped = v.reflect(Vector2(1, 0))
	
	#move_and_slide(flipped, Vector2(0, -1))
	#for i in get_slide_count():
		#var collision = get_slide_collision(i)
		#if collision.remainder.y > 0 and is_on_ceiling():
			#v.y = 0
		#if collision.remainder.x > 0 and is_on_wall():
			#v.x = 0
		#if collision.remainder.x > 0 and is_on_wall():
			#v.x = 0
	
	var collision = move_and_collide(flipped*delta)
	if collision != null:
		var whatever = Vector2(0,0); #bad practice
		var flag = false
		if collision.normal.y == 0:
			whatever = Vector2(0, collision.remainder.y)
			v.x = 0
			flag = true
		elif collision.normal.x == 0:
			whatever = Vector2(collision.remainder.x, 0)
			v.y = 0
			flag = true
		if flag:
			move_and_collide(whatever)
#	if collision:
#		v = v.slide(collision.normal)


func get_v():
	return v / TILE

func set_doors_enabled(b: bool):
	doors_enabled = b
