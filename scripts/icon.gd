extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -700.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta*1.4

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY


	move_and_slide()
