extends Node2D

#preload obstacles
var heli_scene = preload("res://scenes/heli.tscn")
var army_scene = preload("res://scenes/army.tscn")
var obstacle_type := [army_scene]
var obstacles:Array
var heli_heights :=[200,390]

#game variable
const PLAYER_START_POS:=Vector2i(83,587)
const CAM_START_POS:=Vector2i(579,332)
const START_SPEED:float =10.0
const SCORE_MODIFIER: int =10
const MAX_SPEED: int =25
const SPEED_MODIFIER: int =5000

var speed : float
var score: int
var screen_size : Vector2i
var game_running: bool
var ground_height:int
var last_obs

func _ready():
	screen_size=get_window().size
	#ground_height=$Platform.texture.get_height()
	new_game()
	
func new_game():
	#reset the nodes
	score=0
	show_score()
	$player.position=PLAYER_START_POS
	$player.velocity=Vector2i(0,0)
	$Camera2D.position=CAM_START_POS
	$Platform.position=Vector2i(0,0)
	$HUD.get_node("StartLabel").show()

func _process(delta):
	if game_running:
		speed=START_SPEED+  score/SPEED_MODIFIER
		if speed> MAX_SPEED:
			speed=MAX_SPEED
		
		#generate obstacles
		generate_obs()
		show_score()
		if Input.is_action_pressed("ui_right"):
			$player.position.x +=speed
			$Camera2D.position.x +=speed
			score+=speed
			if $Camera2D.position.x - $Platform.position.x > screen_size.x*1.5:
				$Platform.position.x +=screen_size.x
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
	
	
func generate_obs():
	#generate ground obstacles
	if obstacles.is_empty() or last_obs.position.x<score+randi_range(90,100):
		var obs_type = obstacle_type[randi() % obstacle_type.size()]
		var obs
		var max_obs = 3
		for i in range(randi() % max_obs +1):
			obs = obs_type.instantiate()
			var obs_height = obs.get_node("Sprite2D").texture.get_height()
			var obs_scale = obs.get_node("Sprite2D").scale
			var obs_x:int = screen_size.x + score + 100
			var obs_y:int = screen_size.y -ground_height - (obs_height*obs_scale.y/2)-5
			last_obs = obs
			add_obs(obs,obs_x,obs_y)
func add_obs(obs,x,y):
	obs.position = Vector2i(x,y)
	add_child(obs)
	obstacles.append(obs)
