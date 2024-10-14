extends Node2D


#game variable
const PLAYER_START_POS:=Vector2i(83,587)
const CAM_START_POS:=Vector2i(579,332)

var speed : float
const START_SPEED:float =10.0
const MAX_SPEED: int =25
var screen_size : Vector2i

func _ready():
	screen_size=get_window().size
	pass
	
func new_game():
	#reset the nodes
	$player.position=PLAYER_START_POS
	$player.velocity=Vector2i(0,0)
	$Camera2D.position=CAM_START_POS
	$Platform.position=Vector2i(0,0)

func _process(delta):
	speed=START_SPEED
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
	
