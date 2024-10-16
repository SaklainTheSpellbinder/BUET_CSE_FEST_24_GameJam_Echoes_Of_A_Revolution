extends CharacterBody2D


const SPEED = 50.0
const JUMP_VELOCITY = -700.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta*1.4
	
#basicMovements
	var direction := Input.get_axis("ui_left", "ui_right")
	

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() :
			velocity.y = JUMP_VELOCITY
	
	
	if is_on_floor():
		if not get_parent().game_running:
			animated_sprite_2d.animation="idle"
		elif Input.is_action_pressed("kill"):
			animated_sprite_2d.play("kill")
		else:
			$NormalCol.disabled=false
			if Input.is_action_pressed("ui_down") :
				$NormalCol.disabled=true
				animated_sprite_2d.play("duck")
			elif get_parent().score>6000:
				if direction==0:
					animated_sprite_2d.play("idle")
				else:
					animated_sprite_2d.animation="run"
			else:
				animated_sprite_2d.animation="run"
	else:
		animated_sprite_2d.play("jump")		
		
	#directionFlip
	if direction==1:
		animated_sprite_2d.flip_h=false
	elif direction==-1:
		animated_sprite_2d.flip_h=true

		


	move_and_slide()
	print(position.x)
