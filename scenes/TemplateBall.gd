extends RigidBody2D

const RECEIVE_BOUNCE_UP : int = 150;
const RECEIVE_BOUNCE_HORIZONTAL : int = -150;
const RECEIVE_MOTION : Vector2 = Vector2(RECEIVE_BOUNCE_HORIZONTAL,RECEIVE_BOUNCE_UP)
const RECIEVE_SPIN : int = 5;
const motion : Vector2 = Vector2(0,0)
const INITIAL_SPEED : Vector2 = Vector2(-250,-140)
export var MAX_SPEED = 400.0

const INITIAL_SPIN : int = 0#-30

onready var TIMER : Timer = $"Timer"

var wobble_up_wards : bool = true;
var is_wobbling = true

func _ready():
	apply_central_impulse(INITIAL_SPEED)
	angular_velocity = INITIAL_SPIN

func _process(delta):
#	angular_velocity = INITIAL_SPIN
	integrate_forces()
	apply_wobble()
	pass
#	angular_velocity = INITIAL_SPIN

func integrate_forces():
	if linear_velocity.length() > MAX_SPEED:
		linear_velocity = linear_velocity.normalized() * MAX_SPEED

func _on_StaticBody2D_body_entered(body):
	pass
	if (body.name == "Player"):
		is_wobbling = false
		TIMER.start()
		var direction_away_from_node : Vector2 = get_direction_away_from_body(body)
		#Negative Y to make it always jump up
		direction_away_from_node.y = -abs(direction_away_from_node.y)
		#Update Vector with Speed
		var direction_away_from_body_with_speed : Vector2 = direction_away_from_node * RECEIVE_MOTION;
		apply_central_impulse(direction_away_from_body_with_speed)
		angular_velocity = direction_away_from_body_with_speed.normalized().x * RECIEVE_SPIN
	elif (body.name == "Floor"):
		is_wobbling = false
		TIMER.start()
		var direction_away_from_node : Vector2 = get_direction_away_from_body(body)
		direction_away_from_node.y = -abs(direction_away_from_node.y)
		var direction_away_from_body_with_speed : Vector2 = direction_away_from_node * RECEIVE_MOTION;
		#TODO If hit floor should continue with previous speed
		direction_away_from_body_with_speed.x = 0
		apply_central_impulse(direction_away_from_body_with_speed)
		pass

func move():
	if Input.is_action_just_pressed("jump"):
		pass

#Get Global Position of Body 
func get_target(body)->Vector2:
	#Using get_tree().get_root().find_node
	var collided_body = get_tree().get_root().find_node(body.name, true, false)
	var collided_body_global_position = (collided_body.global_position)
	return collided_body_global_position
	
#Get Vector pointing away from passed node
func get_direction_away_from_body(body)->Vector2:
	var direction_away_from_body : Vector2 = (get_target(body) - global_position).normalized();
	return direction_away_from_body;


func _on_Timer_timeout():
	queue_free()
	
func apply_wobble(): 
	if(is_wobbling):
		if(wobble_up_wards):
			motion.y = -3
			apply_central_impulse(motion)
		else: 
			motion.y = 3
			apply_central_impulse(motion)

func _on_WoobleTimer_timeout():
	wobble_up_wards = !wobble_up_wards
