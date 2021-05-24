extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var TIMER : Timer = $"Timer"
onready var NORMAL_BALL = preload("res://scenes/TemplateBall.tscn")
onready var FLOATER_BALL = preload("res://scenes/FloaterBall.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func shoot_ball() -> void:
#	var ball_instance = NORMAL_BALL.instance()
	var ball_instance = FLOATER_BALL.instance()
	add_child(ball_instance)
	TIMER.start()

func _on_Timer_timeout():
	shoot_ball()
