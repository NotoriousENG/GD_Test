extends KinematicBody2D

const GRAVITY = 200.0
const WALK_SPEED = 200
const JUMP_FORCE = 400

var velocity = Vector2()

enum State{
	IDLE,
	WALKING,
	JUMPING,
	FALLING
}

var state_ = State.IDLE


func _physics_process(delta):
	match [state_]:
		[State.IDLE]:
			if (Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right")):
				state_ = State.WALKING
			elif (Input.is_action_pressed("ui_up")):
				state_ = State.JUMPING
			elif (not is_on_floor()):
				state_ = State.FALLING
		[State.WALKING]:
			if (not is_on_floor()):
				state_ = State.FALLING
			elif (Input.is_action_pressed("ui_left")):
				velocity.x += -WALK_SPEED
			elif (Input.is_action_pressed("ui_right")):
				velocity.x += WALK_SPEED
			elif (Input.is_action_pressed("ui_up")):
				state_ = State.JUMPING
			else:
				state_ = State.IDLE
		[State.JUMPING]:
			velocity.y += JUMP_FORCE
			state_ = State.FALLING
		[State.FALLING]:
			velocity.y += delta * GRAVITY
			if (Input.is_action_pressed("ui_left")):
				velocity.x += -WALK_SPEED
			elif (Input.is_action_pressed("ui_right")):
				velocity.x += WALK_SPEED
			if (is_on_floor()):
				velocity.y = 0
				state_ = State.IDLE
	# We don't need to multiply velocity by delta because "move_and_slide" already takes delta time into account.
	#
	#   The second parameter of "move_and_slide" is the normal pointing up.
	#   In the case of a 2D platformer, in Godot, upward is negative y, which translates to -1 as a normal.
	move_and_slide(velocity, Vector2(0,-1))