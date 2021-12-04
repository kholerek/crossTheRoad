extends Node

const startTime = 15 #in seconds
const amountTimeForPoint = 5 #in seconds

onready var gui = $gui
onready var player = $playerKing
onready var traffic = $cars
onready var timerGameOver = Timer.new()
var gameOver
var lastAmountOfPoints = 0

func _ready():
	timerGameOver.connect("timeout",self,"_on_timerGameOver_timeout")
#	timerGameOver.set_one_shot(true)
	timerGameOver.set_wait_time(startTime)
	add_child(timerGameOver)
	pass
	
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
	addTimeForPoint()

func _on_timerGameOver_timeout():
	timerGameOver.stop()
	gameOver = true
	print("timeout")

func addTimeToTimer(seconds):
	var timeLeft = timerGameOver.time_left
	timerGameOver.stop()
	timerGameOver.set_wait_time(timeLeft+seconds)
	timerGameOver.start()
	
func addTimeForPoint():
	if player.points != lastAmountOfPoints:
		addTimeToTimer(amountTimeForPoint)
		lastAmountOfPoints = player.points
		
