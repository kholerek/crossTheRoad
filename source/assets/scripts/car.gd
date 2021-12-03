extends Area2D

#constants
const mapTop = 0
const mapBottom = 1500

#variables
var time = 0
var travelTime = 3

func _ready():
	pass

func _process(delta):
	time += delta
	var t = time / travelTime

	position.y = lerp(mapTop, mapBottom, t)
	
	if position.y >= mapBottom:
		time = 0
		position.y = mapTop
		
func _on_car_body_entered(_body, name):
	print("collision with " + name)
