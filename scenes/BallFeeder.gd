extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var TIMER : Timer = $"Timer"
onready var BALL = preload("res://scenes/TemplateBall.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func shoot_ball() -> void:
	var ball_instance = BALL.instance()
	add_child(ball_instance)
	TIMER.start()

func _on_Timer_timeout():
	shoot_ball()
