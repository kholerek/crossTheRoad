extends Node

const startTime = 15 #in seconds
const amountTimeForPoint = 5 #in seconds

onready var gui = $gui
onready var player = $playerKing
onready var traffic = $cars
onready var levelParameters = load("res://assets/scripts/levelParameters.gd").new()
onready var timerGameOver = Timer.new()

signal gameOver

var gameOver = false
var lastAmountOfPoints = 0

func _ready():
	#timerGameOver
	timerGameOver.connect("timeout",self,"_on_timerGameOver_timeout")
	timerGameOver.set_wait_time(startTime)
	add_child(timerGameOver)
	#signal from car when collision
	traffic.connect("collision", self, "_on_car_collision")
	
func _process(_delta):
	#turning on the game
	if gui.gameNotStarted == false:
		traffic.gameNotStarted = false
		if traffic.trafficOn and timerGameOver.is_stopped() and not gameOver:
			timerGameOver.start()
			player.gameNotStarted = false
	
	#update amount of points and time
	gui.setPoints(player.points)
	gui.setTimeInMiliseconds(timerGameOver.time_left*1000)
	
	#process functions
	ifGotPoint()

func _on_timerGameOver_timeout():
	gameIsOver(1, null)
	print("timeout")

func addTimeToTimer(seconds):
	var timeLeft = timerGameOver.time_left
	timerGameOver.stop()
	timerGameOver.set_wait_time(timeLeft+seconds)
	timerGameOver.start()
	
func ifGotPoint():
	if player.points != lastAmountOfPoints:
		addTimeToTimer(amountTimeForPoint)
		lastAmountOfPoints = player.points
		updateLevelParameters(player.points)

func updateLevelParameters(points):
	levelParameters.setLevelNumber(points)
	traffic.minumumTravelTime = levelParameters.getMinimumTravelTime()
	traffic.maxCarsOnTheRoad = levelParameters.getMaxCarsOnTheRoad()
	gui.debug1Label.text = "minTravTime: " + String(traffic.minumumTravelTime)
	gui.debug2Label.text = "maxCarsOTRoad: " + String(traffic.maxCarsOnTheRoad)

func _on_car_collision(name):
	gameIsOver(2, name)
	print("collision with " + name)
	
func gameIsOver(type, car):
	gameOver = true
	gui.gameOver = true
	var newHighscore = false
	
	if player.points > gui.highscorePoints:
		newHighscore = true

	match type:
		1: #timeout
			timerGameOver.stop()
			#show notification if not new highscore
			if not newHighscore:
				gui.showGameOver("GAME OVER! Time is out")
			else:
				gui.showNewHighscore()
		2: #killed by car
			timerGameOver.set_paused(true)
			#signal to player
			emit_signal("gameOver")
			#show notification if not new highscore
			if not newHighscore:
				gui.showGameOver("GAME OVER! You're killed by " + car)
			else:
				gui.showNewHighscore()
