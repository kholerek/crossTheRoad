extends Control

export(Script) var gameSaveClass

#timeAndPoint
onready var timeAndPointsControl = $timeAndPoints
onready var secondsLabel = $timeAndPoints/seconds
onready var pointsLabel = $timeAndPoints/points

#startMenu
onready var startMenuControl = $startMenu
onready var startButton = $startMenu/startButton
onready var highscoreButton = $startMenu/highscoreButton
onready var fullscreenButton = $startMenu/fullscreenButton

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
var saveVars = ["name", "points"]
var highscoreName= "NOBODY"
var highscorePoints = 0
var newHighscore
var gameOver

func _ready():
	#prepare screen
	hideAllMenus()
	showStartMenu()
	
	#load highscore values
	if loadHighscore():
		highscoreLabel.text = highscoreName + " " + String(highscorePoints)
	else:
		highscoreLabel.text = "ERROR"

#keys (spacebar and enter)
func _input(event):
	#press spacebar to start
	if event.is_action_pressed("ui_accept") and gameReadyToStart:
		hideAllMenus()
		showTimeAndPointsControl()
		gameReadyToStart = false
		gameNotStarted = false
	#press enter after enter your name (new highscore)
	elif event.is_action_pressed("ui_enter") and newHighscore:
		saveHighscore()
		get_tree().reload_current_scene()
	#when game is over and player press spacebar to restart game
	elif Input.is_action_just_pressed("ui_accept") and gameOver and not newHighscore:
		get_tree().reload_current_scene()
	#escape anytime
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

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
	newHighscore = true
	yourNameEdit.visible = true
	yourNameEdit.grab_focus()
	waitingForName = true
	
func verifySaveHighscore(save):
	for v in saveVars:
		if save.get(v) == null:
			return false
		
	return true

func saveHighscore():
	var newSave = gameSaveClass.new()
	newSave.name = yourNameEdit.text
	newSave.points = int(pointsLabel.text)
	
	ResourceSaver.save("user://save.res", newSave)
	
func loadHighscore():
	var dir = Directory.new()
	if not dir.file_exists("user://save.res"):
		return false
	
	var highscoreSave = load("user://save.res")
	if not verifySaveHighscore(highscoreSave):
		return false
	
	highscoreName = highscoreSave.name
	highscorePoints = highscoreSave.points
	
	return true
	
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
	
func _on_fullscreenButton_pressed():
	OS.window_fullscreen = !OS.window_fullscreen

func _on_backButton_pressed():
	hideAllMenus()
	showStartMenu()
	
func setPoints(points):
	pointsLabel.text = String(points)
	
func setTimeInMiliseconds(miliseconds):
	var timeToDisplay = String(stepify((miliseconds/1000.0),0.1))
	#I haven't found a better way
	if timeToDisplay.find(".") == -1:
		timeToDisplay += ".0"
	secondsLabel.text = timeToDisplay +" s"
	secondsAnimation(timeToDisplay)

#change color of seconds font
func secondsAnimation(time):
	if float(time) >= 10.0:
		secondsLabel.add_color_override("font_color", Color(0, 0, 0, 1)) # black
	else:
		secondsLabel.add_color_override("font_color", Color(0.92, 0.22, 0.3, 1)) #red
	
