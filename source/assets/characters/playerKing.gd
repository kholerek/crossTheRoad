extends KinematicBody2D

export var leftPosition = 40
export var rightPosition = 1240
export var moveDuration = 3
export var showDebugContainer = false

enum playerState { IDLE=0, RUN_LEFT=-1, RUN_RIGHT=1, DEAD=2 }

var time = 0
var timeDirection
var playerDirection = playerState.IDLE
var lastDirection = playerState.IDLE
var gameNotStarted = true
var points = 0

onready var stateLabel = $debugContainer/stateLabel
onready var positionLabel = $debugContainer/positionLabel
onready var debug1 = $debugContainer/debug1
onready var debug2 = $debugContainer/debug2
onready var debug3 = $debugContainer/debug3

func _ready():
	position.x = leftPosition
	
	if showDebugContainer:
		$debugContainer.visible = 1
	else:
		$debugContainer.visible = 0

func _process(delta):
	
	match playerDirection:
		
		playerState.IDLE:
			#actions
			timeDirection = playerState.IDLE
			#conditions for transitions
			if gameNotStarted == false:
				if Input.is_action_just_pressed("ui_accept") and (lastDirection == playerState.RUN_LEFT or lastDirection == playerState.IDLE):
					playerDirection = playerState.RUN_RIGHT
				if Input.is_action_just_pressed("ui_accept") and lastDirection == playerState.RUN_RIGHT:
					playerDirection = playerState.RUN_LEFT
				
		playerState.RUN_RIGHT:
			#actions
			timeDirection = playerState.RUN_RIGHT
			lastDirection = playerState.RUN_RIGHT
			#conditions for transitions
			if position.x>=rightPosition:
				timeDirection = playerState.IDLE
				time = moveDuration
				position.x = rightPosition
				playerDirection = playerState.IDLE
				points = points+1
				
		playerState.RUN_LEFT: 
			#actions
			timeDirection = playerState.RUN_LEFT
			lastDirection = playerState.RUN_LEFT
			#conditions for transitions
			if position.x<=leftPosition:
				timeDirection = playerState.IDLE
				time = 0
				position.x = leftPosition
				playerDirection = playerState.IDLE
				points = points+1
		
		playerState.DEAD:
			#actions
			timeDirection = playerState.IDLE
			#conditions for transitions

	# delta is how long it takes to complete a frame.
	time += delta * timeDirection
	var t = time / moveDuration

	position.x = lerp(leftPosition,rightPosition, t)
	
	#Change animationSprite properties
	match timeDirection:
		0:
			if playerDirection != playerState.DEAD:
				$animatedSprite.play("idle")
				stateLabel.text = "idle"
				if lastDirection == playerState.RUN_RIGHT:
					$animatedSprite.flip_h = true;
				else :
					$animatedSprite.flip_h = false;
			else:
				$animatedSprite.flip_h = false;
				$animatedSprite.play("dead")
				stateLabel.text = "dead"
		1:
			$animatedSprite.flip_h = false;
			$animatedSprite.play("run")
			stateLabel.text = "run right"
		-1:
			$animatedSprite.flip_h = true;
			$animatedSprite.play("run")
			stateLabel.text = "run left"
	
	#Printing debugContainer
	positionLabel.text = "X: " + String(round(position.x)) + " Y: " + String(round(position.y))
	debug1.text = String(time)
	
	match timeDirection:
		0:
			stateLabel.text = "idle"
		1:
			stateLabel.text = "run right"
		-1:
			stateLabel.text = "run left"

func _gameOver():
	print("player dead")
	playerDirection = playerState.DEAD
