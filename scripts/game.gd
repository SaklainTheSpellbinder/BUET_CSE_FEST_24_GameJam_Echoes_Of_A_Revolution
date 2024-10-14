extends Node2D

var score:int
var speed:float
const START_SPEED:=10.0
const MAX_SPEED:=25.0
var screenSize :Vector2i
const SCORE_MODIFIER = 10
var gameRunning:bool
func _ready() -> void:
	screenSize=get_window().size
	newGame()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if gameRunning:
		speed=START_SPEED
		
		#move icon and camera
		$icon.position.x+=speed
		$Camera2D.position.x+=speed
		#updating platform
		if $Camera2D.position.x-$Platform.position.x > screenSize.x*1.5:
			$Platform.position.x+=screenSize.x
		
		#update score
		score+=speed
		showScore()
	
	else:
		if Input.is_action_pressed("ui_accept"):
			gameRunning=true
			$HUD.get_node("StartLabel").hide()

func newGame():
	#resetting
	score=0
	$icon.position=Vector2i(0,600)
	$icon.velocity=Vector2i(0,0)
	$Camera2D.position=Vector2i(0,330)
	$Platform.position=Vector2i(0,0)
	$HUD.get_node("StartLabel").show()


func showScore():
	$HUD.get_node("Score").text = "SCORE: " +str(score/SCORE_MODIFIER)

	
