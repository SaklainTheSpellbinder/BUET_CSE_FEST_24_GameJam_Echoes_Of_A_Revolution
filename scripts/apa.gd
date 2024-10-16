extends Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: Node2D = get_parent().get_node("player")  
@onready var animated_sprite_2d_2: AnimatedSprite2D = $AnimatedSprite2D2
@onready var animated_sprite_2d_3: AnimatedSprite2D = $AnimatedSprite2D3

var speed = 50
var animation_state = "Run"  # Default animation when villain spawns

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Start playing the default animation when the villain is spawned
	animated_sprite_2d.flip_h= true
	animated_sprite_2d_2.flip_h=true
	animated_sprite_2d_3.flip_h=true
	animated_sprite_2d.play("Run")
	animated_sprite_2d_2.play("Run")
	animated_sprite_2d_3.play("Run")

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta):
	# Villain moves left toward the player
	position.x -= speed * delta

	# Check if villain goes off-screen
	if position.x < -100:
		queue_free()  # Remove villain when off-screen
		
	

	# Update animation based on current state (for example, you might switch to attack or idle)
	# Check distance between villain and player
	var distance_to_player = animated_sprite_2d.global_position.distance_to(player.position)

	# If the distance is less than or equal to 200, switch to Attack animation
	if distance_to_player <= 200:
		animated_sprite_2d.flip_h = false
		change_animation("Attack")
	else:
		change_animation("Run")
	
	if Input.is_action_pressed("Archer") and distance_to_player <= 180 :
		get_parent().apa_spawned=false
		get_parent().apa_instance.queue_free()
		get_parent().apa_instance = null
		get_parent().game_win()

# Function to change the animation
func change_animation(animation_name: String):
	if $AnimatedSprite2D.animation != animation_name:
		$AnimatedSprite2D.play(animation_name)
