extends Node2D

#constants
const blueCar = preload("res://assets/cars/blueCar.tscn")
const busCar = preload("res://assets/cars/busCar.tscn")
const greyCar = preload("res://assets/cars/greyCar.tscn")
const policeCar = preload("res://assets/cars/policeCar.tscn")
const redCar = preload("res://assets/cars/redCar.tscn")
const schoolCar = preload("res://assets/cars/schoolCar.tscn")
const taxiCar = preload("res://assets/cars/taxiCar.tscn")
const truckCar = preload("res://assets/cars/truckCar.tscn")
const yellowCar = preload("res://assets/cars/yellowCar.tscn")
const maximumTravelTime = 5.5 #in seconds
const arrayOfLines = [125, 260, 460, 605, 832, 954, 1154]
const arrayOfCars = [blueCar, busCar, greyCar, policeCar, redCar, schoolCar, taxiCar, truckCar, yellowCar]

signal collision

#variables
var maxCarsOnTheRoad = 2
var minumumTravelTime = 4

var randomNumber = RandomNumberGenerator.new()
var gameNotStarted = true
var trafficOn = false

func _ready():
	pass

func _process(_delta):
	if get_child_count() < maxCarsOnTheRoad and not gameNotStarted:
		randomCarRandomLine(minumumTravelTime, maximumTravelTime)
		trafficOn = true

func generateCar(type, line, travelTime):
	var newCar = type.instance()
	newCar.position.x = arrayOfLines[line]
	newCar.travelTime = travelTime
	self.add_child(newCar)
	newCar.connect("collision", self, "_on_car_collision")

func randomCarRandomLine(slowestTravelTime, theFastestTravelTime):
	randomNumber.randomize()
	
	var randomLine = randomNumber.randi_range(0,arrayOfLines.size()-1)
	if isLineFree(randomLine) == false:
		while isLineFree(randomLine) == false:
			randomLine = randomNumber.randi_range(0,arrayOfLines.size()-1)
	
	var randomCar = randomNumber.randi_range(0,arrayOfCars.size()-1)
	var randomTravelTime = randomNumber.randf_range(slowestTravelTime,theFastestTravelTime)
	generateCar(arrayOfCars[randomCar],randomLine,randomTravelTime)

func isLineFree(line):
	var isFree = true
	
	for i in get_child_count():
		var myNode = get_child(i).name
		var thisXPos = get_node(myNode).position.x
		if thisXPos == arrayOfLines[line]:
				isFree = false
	
	if isFree:
		return true
	else:
		return false

func debugIsLinesFree():
	for n in arrayOfLines.size():
		if isLineFree(n):
			print("line "+ String(n) + " is: free")
			pass
		else:
			print("line "+ String(n) + " is: occupied")
	print()
	
func _on_car_collision(name):
	emit_signal("collision", name)
