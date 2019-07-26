extends KinematicBody2D

const GRAVITY = 1200
const WALK_ACCEL = 2000
const JUMP_VELOCITY = -600
const FRICTION = 10000
const WALK_INITIAL_VELOCITY = 80
const WALK_MAX_VELOCITY = 500
const fallMultiplier = 2

var velocity = Vector2()

enum State{
	IDLE,
	WALKING,
	JUMPING,
	FALLING
}

var state_ = State.IDLE

func Get_Left_Right_Movement(delta):
	if (Input.is_action_pressed("ui_left")):
		velocity.x = min(velocity.x, -WALK_INITIAL_VELOCITY)
		velocity.x = max(velocity.x + delta * -WALK_ACCEL, -WALK_MAX_VELOCITY)
	elif (Input.is_action_pressed("ui_right")):
		velocity.x = max(velocity.x, WALK_INITIAL_VELOCITY)
		velocity.x = min(velocity.x + delta * WALK_ACCEL, WALK_MAX_VELOCITY)

func Use_Friction(delta, fraction):
	if (velocity.x > 0):
			velocity.x = max(0, velocity.x - delta * fraction * FRICTION)
	elif (velocity.x < 0):
		velocity.x = min(0, velocity.x + delta * fraction * FRICTION)

func _physics_process(delta):
	print(State.keys()[state_])
	match [state_]:
		[State.IDLE]:
			Use_Friction(delta, 1)
			if (Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right")):
				state_ = State.WALKING
			elif (Input.is_action_pressed("ui_up")):
				state_ = State.JUMPING
			elif (not is_on_floor()):
				state_ = State.FALLING
		[State.WALKING]:
			if (Input.is_action_pressed("ui_up")):
				state_ = State.JUMPING
			if (Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right")):
				Get_Left_Right_Movement(delta)
			else:
				state_ = State.IDLE
		[State.JUMPING]:
			velocity.y = JUMP_VELOCITY
			state_ = State.FALLING
		[State.FALLING]:
			Use_Friction(delta, 0.1)
			if velocity.y > 0:
				velocity.y += 9.81 * fallMultiplier # fall faster than jump
			else:
				velocity.y += delta * GRAVITY
			Get_Left_Right_Movement(delta)
			if (is_on_floor() and velocity.y > 0 ):
				velocity.y = 0
				state_ = State.IDLE
	# We don't need to multiply velocity by delta because "move_and_slide" already takes delta time into account.
	#
	#   The second parameter of "move_and_slide" is the normal pointing up.
	#   In the case of a 2D platformer, in Godot, upward is negative y, which translates to -1 as a normal.
	move_and_slide(velocity, Vector2(0,-1))