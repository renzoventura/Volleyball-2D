extends RigidBody2D
const LIST_OF_INITIAL_SPEEDS : Dictionary = {180:200}
#topspin
#const LIST_OF_INITIAL_SPINS : Array = [5, 10 ,15]
#const LIST_OF_GRAVITY_SCALES : Array = [1, 1.5, 2]

#float
#const LIST_OF_WOBBLE_LEVELS : Array = [2, 2 , 3, 5, 5, 6, 9]
#const LIST_OF_GRAVITY_SCALES : Array = [1, 1.5, 2]


const LIST_OF_GRAVITY_SCALES : Array = [1, 1.2]

const LIST_OF_WOBBLE_LEVELS : Array = [0]
const LIST_OF_INITIAL_SPINS : Array = [3, 5, 8]
const RECEIVE_BOUNCE_UP : int = 150;
const RECEIVE_BOUNCE_HORIZONTAL : int = -150;
const RECEIVE_MOTION : Vector2 = Vector2(RECEIVE_BOUNCE_HORIZONTAL,RECEIVE_BOUNCE_UP)
const RECIEVE_SPIN : int = 5;
const motion : Vector2 = Vector2(0,0)
var INITIAL_SPEED : Vector2 = Vector2(-300,-180)
#const WOBBLE_LEVEL = 0
export var MAX_SPEED = 800.0

onready var TIMER : Timer = $"Timer"

var wobble_up_wards : bool = true;
var is_wobbling = true

func _ready():
	update_gravity_scale()
	apply_central_impulse(get_random(LIST_OF_INITIAL_SPEEDS))

func _process(delta):
	integrate_forces()
	apply_wobble()
	apply_spin()
	
func update_gravity_scale():
	set_gravity_scale(LIST_OF_GRAVITY_SCALES[randi() % LIST_OF_GRAVITY_SCALES.size()]) 
	
func integrate_forces():
	if linear_velocity.length() > MAX_SPEED:
		linear_velocity = linear_velocity.normalized() * MAX_SPEED

func apply_spin():
	var INITIAL_SPIN : int = LIST_OF_INITIAL_SPINS[randi() % LIST_OF_INITIAL_SPINS.size()]
	angular_velocity = -INITIAL_SPIN

func _on_StaticBody2D_body_entered(body):
	pass
	if(body.name != "TemplateBall"):
		is_wobbling = false
	if (body.name == "Player"):
		TIMER.start()
		var direction_away_from_node : Vector2 = get_direction_away_from_body(body)
		#Negative Y to make it always jump up
		direction_away_from_node.y = -abs(direction_away_from_node.y)
		#Update Vector with Speed
		var direction_away_from_body_with_speed : Vector2 = direction_away_from_node * RECEIVE_MOTION;
		apply_central_impulse(direction_away_from_body_with_speed)
		angular_velocity = direction_away_from_body_with_speed.normalized().x * RECIEVE_SPIN
	elif (body.name == "Floor"):
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
	var WOBBLE_LEVEL : int = LIST_OF_WOBBLE_LEVELS[randi() % LIST_OF_WOBBLE_LEVELS.size()]
	if(is_wobbling):
		if(wobble_up_wards):
			motion.y = -WOBBLE_LEVEL
			apply_central_impulse(motion)
		else: 
			motion.y = WOBBLE_LEVEL
			apply_central_impulse(motion)

func _on_WoobleTimer_timeout():
	wobble_up_wards = !wobble_up_wards

func get_random(dict) -> Vector2:
	var a = dict.keys()
	a = a[randi() % a.size()]
	return Vector2(-a, -dict[a])
