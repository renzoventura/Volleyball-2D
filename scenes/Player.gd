extends "res://scenes/TemplatePlayer.gd"

const SPEED : int = 200;
const MAX_SPEED : int = 50;
const JUMP : int = 30;
const MAX_FALL_SPEED : int = 200;
const GRAVITY : float = 40.0;
var motion : Vector2 = Vector2(0,0)
var motion_up : Vector2 = Vector2(0,-1)


func _ready():
	pass # Replace with function body.

func _process(delta):
	move()
	jump()
	apply_gravity()
	move_and_slide(motion, motion_up)

func move() -> void:
	if (Input.is_action_pressed("left")):
		print("Moving left");
		motion.x = -SPEED
	elif (Input.is_action_pressed("right")):
		print("Moving right");
		motion.x = SPEED
	else:
		motion.x = 0

func apply_gravity() -> void:
	if is_on_floor() and motion_up.y > 0: 
		motion_up.y = 0
	elif is_on_ceiling():
		motion_up.y = 1
	else:
		if(motion_up.y < MAX_FALL_SPEED):
			motion_up.y += GRAVITY
	
func jump() -> void:
	if (Input.is_action_just_pressed("jump")):
		print("jump!")
		motion.y = -JUMP
