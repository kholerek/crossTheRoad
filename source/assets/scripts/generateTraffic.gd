extends Node2D

#cars list
const redCar = preload("res://assets/cars/redCar.tscn")
const blueCar = preload("res://assets/cars/blueCar.tscn")
const bus = preload("res://assets/cars/schoolCar.tscn")

#lines array
var arrayOfLines = [125, 260, 460, 605, 832, 954, 1154]
var a = true

func _ready():
	pass

func _process(_delta):
	if a:
		var nextRedCar = redCar.instance()
		nextRedCar.position.x = arrayOfLines[0]
		nextRedCar.travelTime = 5
		self.add_child(nextRedCar)
		
		var nextBlueCar = bus.instance()
		nextBlueCar.position.x = arrayOfLines[5]
		nextBlueCar.travelTime = 4
		self.add_child(nextBlueCar)
		
		a = false
		
		
