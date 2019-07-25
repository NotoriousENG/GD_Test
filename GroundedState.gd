extends "res://Char.gd"

const JUMP_FORCE = 400


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Input.is_action_pressed("ui_up"):
		velocity.y += delta * JUMP_FORCE

