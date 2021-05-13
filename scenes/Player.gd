extends "res://scenes/TemplatePlayer.gd"

# negative x = left, positive y = right
const SPEED : int = 200;
const MAX_SPEED : int = 50;
# negative y = up, positive y = down
const JUMP_SPEED : int = -550
const MAX_JUMP : int = 200;
const MAX_FALL_SPEED : int = 500;
const gravity_test : int = 1500
var motion : Vector2 = Vector2(0,0)
var motion_up : Vector2 = Vector2.UP

var is_jumping : bool = false

func _process(delta):
	move()
	jump(delta)
	apply_gravity(delta)
	motion = move_and_slide(motion, motion_up)
	check_if_jumping()

func move() -> void:
	if (Input.is_action_pressed("left")):
		motion.x = -SPEED
	elif (Input.is_action_pressed("right")):
		motion.x = SPEED
	else:
		motion.x = 0

func apply_gravity(delta):
	if is_on_floor() and motion.y > 0: 
		motion.y = 0
	elif is_on_ceiling():
		motion.y = 1
	else:
		if(motion.y < MAX_FALL_SPEED):
			#Push down motion
			motion.y += gravity_test *  delta

func jump(delta) -> void:
	if Input.is_action_just_pressed('jump') and is_on_floor():
		is_jumping = true
		#Set amount of jump level
		motion.y = JUMP_SPEED
	if is_jumping and Input.is_action_just_released("jump"):
		print("Released and is jumping")
		if motion.y < -MAX_JUMP:
			print("short: " + str(motion.y))
			print()
			motion.y = 0
		else:
			print("long: " + str(motion.y))
		

func check_if_jumping():
	if is_jumping and is_on_floor():
		is_jumping = false
