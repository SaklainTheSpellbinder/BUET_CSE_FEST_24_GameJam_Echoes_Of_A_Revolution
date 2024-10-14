extends Node2D


#game variable
const PLAYER_START_POS:=Vector2i(83,587)
const CAM_START_POS:=Vector2i(579,332)

var speed : float
var score: int
const START_SPEED:float =10.0
const SCORE_MODIFIER: int =10
const MAX_SPEED: int =25
var screen_size : Vector2i
var game_running: bool
const SPEED_MODIFIER: int =5000

func _ready():
	screen_size=get_window().size
	pass
	
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
		show_score()
		if Input.is_action_pressed("ui_right"):
			$player.position.x +=speed
			$Camera2D.position.x +=speed
			score+=speed
			if $Camera2D.position.x - $Platform.position.x > screen_size.x*1.5:
				$Platform.position.x +=screen_size.x
		elif Input.is_action_pressed("ui_left"):
			$player.position.x -=speed
			$Camera2D.position.x -=speed
			score-=speed
			if $Platform.position.x-$Camera2D.position.x> screen_size.x*1.5:
				$Platform.position.x -=screen_size.x
	else:
		if Input.is_action_just_pressed("ui_accept"):
			game_running=true
			$HUD.get_node("StartLabel").hide()
	
func show_score():
	$HUD.get_node("Score").text="SCORE:"+str(score/SCORE_MODIFIER)
	
