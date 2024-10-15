extends Node2D 

#preload obstacles
var heli_scene = preload("res://scenes/heli.tscn")
var army_scene = preload("res://scenes/army.tscn")
var obstacle_type := [army_scene]
var obstacles:Array
var heli_heights :=[200,480]

#game variable
const PLAYER_START_POS:=Vector2i(83,587)
const CAM_START_POS:=Vector2i(579,332)
const START_SPEED:float =10.0
const SCORE_MODIFIER: int =10
const MAX_SPEED: int =25
const SPEED_MODIFIER: int =5000
const MAX_DIFFICULTY : int = 2

var speed : float
var score: int
var screen_size : Vector2i
var game_running: bool
var ground_height:int
var last_obs
var difficulty
var high_score : int
@onready var player: CharacterBody2D = $player


func _ready():
	screen_size=get_window().size
	#ground_height=$Platform.texture.get_height()
	$GameOver.get_node("Button").pressed.connect(new_game)
	new_game()
	
func new_game():
	#reset the nodes
	score=0
	show_score()
	get_tree().paused = false
	difficulty = 0
	
	#delete all obstacles
	for obs in obstacles:
		obs.queue_free()
	obstacles.clear()
	
	$player.position=PLAYER_START_POS
	$player.velocity=Vector2i(0,0)
	$Camera2D.position=CAM_START_POS
	$Platform.position=Vector2i(0,0)
	$HUD.get_node("StartLabel").show()
	$GameOver.hide()

func _process(delta):
	if game_running:
		speed=START_SPEED+  score/SPEED_MODIFIER
		if speed> MAX_SPEED:
			speed=MAX_SPEED
		adjust_difficulty()
			
		
		#generate obstacles
		generate_obs()
		show_score()
		if score>40000 :
			if Input.is_action_pressed("ui_right"):
				$player.position.x +=speed
				$Camera2D.position.x +=speed
				score+=speed
				if $Camera2D.position.x - $Platform.position.x > screen_size.x*1.5:
					$Platform.position.x +=screen_size.x
		else:
			$player.position.x +=speed
			$Camera2D.position.x +=speed
			score+=speed
			if $Camera2D.position.x - $Platform.position.x > screen_size.x*1.5:
				$Platform.position.x +=screen_size.x
					
					
		#remove off-screen helicopters
		for  obs in obstacles:
			if obs.position.x < ($Camera2D.position.x - screen_size.x):
				remove_obs(obs)
			
			
		#elif Input.is_action_pressed("ui_left"):
		#	$player.position.x -=speed
		#	$Camera2D.position.x -=speed
		#	score-=speed
		#	if $Platform.position.x-$Camera2D.position.x> screen_size.x*1.5:
		#		$Platform.position.x -=screen_size.x
	else:
		if Input.is_action_just_pressed("ui_accept"):
			game_running=true
			$HUD.get_node("StartLabel").hide()
	
func show_score():
	$HUD.get_node("Score").text="SCORE:"+str(score/SCORE_MODIFIER)

func check_high_score():
	if score> high_score:
		high_score = score
		$HUD.get_node("HighScore").text="HIGH SCORE: "+str(high_score/SCORE_MODIFIER)
	
func generate_obs():
	#generate ground obstacles
	if obstacles.is_empty() or last_obs.position.x<score+randi_range(90,100):
		var obs_type = obstacle_type[randi() % obstacle_type.size()]
		var obs
		var max_obs = difficulty+1
		for i in range(randi() % max_obs +1):
			obs = obs_type.instantiate()
			var obs_height = obs.get_node("Sprite2D").texture.get_height()
			var obs_scale = obs.get_node("Sprite2D").scale
			var obs_x:int = screen_size.x + score + 100
			var obs_y:int = screen_size.y -ground_height - (obs_height*obs_scale.y/2)-5
			last_obs = obs
			add_obs(obs,obs_x,obs_y)
		#additionally random opportunity to spawn a helicopter
		if difficulty ==MAX_DIFFICULTY:
			if(randi()%2)==0:
				obs= heli_scene.instantiate()
				var obs_x : int =screen_size.x + score + 100
				var obs_y : int =heli_heights[randi() % heli_heights.size()]
				add_obs(obs, obs_x, obs_y)
			
			
				
func add_obs(obs,x,y):
	obs.position = Vector2i(x,y)
	obs.body_entered.connect(hit_obs)
	add_child(obs)
	obstacles.append(obs)
	
func remove_obs(obs):
	obs.queue_free()
	obstacles.erase(obs)
	
func hit_obs(body):
	if body.name == "player" :
		print("Collision")
		game_over()
	
	
func adjust_difficulty():
	difficulty = score / SPEED_MODIFIER
	if difficulty > MAX_DIFFICULTY:
		difficulty=MAX_DIFFICULTY


func game_over():
	check_high_score()
	var animated_sprite=player.get_node("AnimatedSprite2D")
	animated_sprite.play("die")
	get_tree().paused= true
	game_running= false
	$GameOver.show()
