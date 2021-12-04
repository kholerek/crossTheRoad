extends Control

#timeAndPoint
onready var timeAndPointsControl = $timeAndPoints
onready var secondsLabel = $timeAndPoints/seconds
onready var pointsLabel = $timeAndPoints/points

#startMenu
onready var startMenuControl = $startMenu
onready var startButton = $startMenu/startButton
onready var highscoreButton = $startMenu/highscoreButton

#highscoreMenu
onready var highscoreMenuControl = $highscoreMenu
onready var highscoreLabel = $highscoreMenu/highscoreLabel
onready var backButton = $highscoreMenu/backButton

#pressSpacebar
onready var pressSpacebarMenuControl = $pressSpacebarMenu

#other variables
var gameNotStarted = true
var gameReadyToStart = false

func _ready():
	#prepare screen
	hideAllMenus()
	showStartMenu()
#	setPoints(0)
#	setTimeInMiliseconds(1100)

	
func _input(event):
	if event.is_action_pressed("ui_accept") and gameReadyToStart:
		hideAllMenus()
		showTimeAndPointsControl()
		gameReadyToStart = false
		gameNotStarted = false

func showStartMenu():
	startMenuControl.visible = true
	startButton.grab_focus()
	
func showHighscoreMenu():
	highscoreMenuControl.visible = true
	backButton.grab_focus()
	
func showPressSpacebarMenu():
	pressSpacebarMenuControl.visible = true
	gameReadyToStart = true
	
func showTimeAndPointsControl():
	timeAndPointsControl.visible = true
	
func hideAllMenus():
	startMenuControl.visible = false
	highscoreMenuControl.visible = false
	pressSpacebarMenuControl.visible = false
	timeAndPointsControl.visible = false
	
#signals from buttons
func _on_startButton_pressed():
	hideAllMenus()
	showPressSpacebarMenu()

func _on_highscoreButton_pressed():
	hideAllMenus()
	showHighscoreMenu()

func _on_backButton_pressed():
	hideAllMenus()
	showStartMenu()
	
func setPoints(points):
	pointsLabel.text = String(points)
	
func setTimeInMiliseconds(miliseconds):
	var timeToDisplay = miliseconds/1000.0
	secondsLabel.text = String(stepify(timeToDisplay,0.1))+" s"
	
