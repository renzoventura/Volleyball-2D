extends RigidBody2D


const RECEIVE_BOUNCE_UP : int = 300;
const RECEIVE_BOUNCE_HORIZONTAL : int = -200;
var RECEIVE_MOTION : Vector2 = Vector2(RECEIVE_BOUNCE_HORIZONTAL,RECEIVE_BOUNCE_UP)
var motion : Vector2 = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_StaticBody2D_body_entered(body):
	if (body.name == "Player"):
		var direction_away_from_node : Vector2 = get_direction_away_from_body(body)
		#Negative Y to make it always jump up
		direction_away_from_node.y = -abs(direction_away_from_node.y)
		#Update Vector with Speed
		var direction_away_from_body_with_speed : Vector2 = direction_away_from_node * RECEIVE_MOTION;
		apply_central_impulse(direction_away_from_body_with_speed)
#		angular_velocity = direction_away_from_body_with_speed.normalized().x * 50
	elif (body.name == "Floor"):
		var direction_away_from_node : Vector2 = get_direction_away_from_body(body)
		direction_away_from_node.y = -abs(direction_away_from_node.y)
		var direction_away_from_body_with_speed : Vector2 = direction_away_from_node * RECEIVE_MOTION;
		#TODO If hit floor should continue with previous speed
		direction_away_from_body_with_speed.x = 0
		apply_central_impulse(direction_away_from_body_with_speed)
		pass
		
func _physics_process(delta):
	move()

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
