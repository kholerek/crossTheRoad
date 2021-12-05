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

#fullScreenNotification
onready var fullScreenNotification = $fullScreenNotification
onready var notificationLabel = $fullScreenNotification/notificationLabel

#new highscore - yourName
onready var yourNameEdit = $yourNameEdit

#debugContainer
onready var debug1Label = $debugContainer/debug1Label
onready var debug2Label = $debugContainer/debug2Label

#other variables
var gameNotStarted = true
var gameReadyToStart = false
var waitingForName = false

func _ready():
	#prepare screen
	hideAllMenus()
	showStartMenu()
	
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
	notificationLabel.text = "press spacebar to go"
	notificationLabel.add_color_override("font_color", Color(0.89, 0.69, 0.13, 1))
	fullScreenNotification.visible = true
	gameReadyToStart = true
	
func showNewHighscore():
	yourNameEdit.visible = true
	yourNameEdit.grab_focus()
	waitingForName = true
	
func showGameOver(notification):
	notificationLabel.text = notification
	notificationLabel.add_color_override("font_color", Color(0.92, 0.22, 0.3, 1))
	fullScreenNotification.visible = true
	
func showTimeAndPointsControl():
	timeAndPointsControl.visible = true
	
func hideAllMenus():
	startMenuControl.visible = false
	highscoreMenuControl.visible = false
	fullScreenNotification.visible = false
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
	
