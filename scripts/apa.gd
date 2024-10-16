extends Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var speed = 200
var animation_state = "Run"  # Default animation when villain spawns

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Start playing the default animation when the villain is spawned
	animated_sprite_2d.flip_h= true
	animated_sprite_2d.play("Run")


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta):
	# Villain moves left toward the player
	position.x -= speed * delta

	# Check if villain goes off-screen
	if position.x < -100:
		queue_free()  # Remove villain when off-screen

	# Update animation based on current state (for example, you might switch to attack or idle)
	if position.x <= 400:  # You can replace this with your actual logic
		animated_sprite_2d.flip_h=false
		change_animation("Attack")
	else:
		change_animation("Run")

# Function to change the animation
func change_animation(animation_name: String):
	if $AnimatedSprite2D.animation != animation_name:
		$AnimatedSprite2D.play(animation_name)
