extends Node2D


#game variable
const PLAYER_START_POS:=Vector2i(83,587)
const CAM_START_POS:=Vector2i(579,332)
var speed : float
const START_SPEED:float =10.0
const MAX_SPEED:=50.0
var screen_size : Vector2i
var isGameRunning:bool
var score :=0

func _ready():
	screen_size=get_window().size
	pass
	
func new_game():
	#reset the nodes
	$player.position=PLAYER_START_POS
	$player.velocity=Vector2i(0,0)
	$Camera2D.position=CAM_START_POS
	$Platform.position=Vector2i(0,0)
	score=0
	$HUD.get_node("StartLabel").show()

func _process(delta):
	if isGameRunning:
		speed=move_toward(START_SPEED,MAX_SPEED,0.1)
		if Input.is_action_pressed("ui_right"):
			$player.position.x +=speed
			$Camera2D.position.x +=speed
			if $Camera2D.position.x - $Platform.position.x > screen_size.x*1.5:
				$Platform.position.x +=screen_size.x
		elif Input.is_action_pressed("ui_left"):
			$player.position.x -=speed
			$Camera2D.position.x -=speed
			if $Platform.position.x-$Camera2D.position.x> screen_size.x*1.5:
				$Platform.position.x -=screen_size.x
			
		
		#show score
		showScore()
	else:
		if Input.is_action_pressed("ui_accept"):
			isGameRunning=true
			$HUD.get_node("StartLabel").hide()
	
func showScore():
	$HUD.get_node("Score").text = "SCORE:" +str(score)
