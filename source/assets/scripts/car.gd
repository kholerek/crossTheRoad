extends Area2D

#signals
signal collision

#preloads
const tireMarks = preload("res://assets/cars/tireMarks.tscn") 

#constants
const mapTop = 0 #in px 
const mapBottom = 1500 #in px
const collisionTravelTime = 0.5 #in sec
const collisionLenght = 15 #in px

#variables
var time = 0
var travelTime = 3
var collision = false
var t
var positionWhenCollision
var carStopped = false
var newTireMarks

func _ready():
	newTireMarks = tireMarks.instance()
	pass

func _process(delta):
	if not collision:
		#car movement when everything ok
		time += delta
		t = time / travelTime
		#car movement
		position.y = lerp(mapTop, mapBottom, t)
	elif collision and not carStopped:
		#car when braking
		time += delta
		t = time / collisionTravelTime
		#car braking
		position.y = lerp(positionWhenCollision, positionWhenCollision + collisionLenght, t)
		#tiremarks animation
		newTireMarks.position.y = lerp(-$TextureRect.rect_size.y+20, -$TextureRect.rect_size.y+5,t)
		
	#car stopped when collision
	if collision and time >= collisionTravelTime:
		carStopped = true
	
	#car bellow screen area
	if position.y >= mapBottom:
		time = 0
		position.y = mapTop
		queue_free()
		
#when player entered colision shape of the car
func _on_car_body_entered(_body, name):
	#signal to engine script
	emit_signal("collision", name)
	collision = true
	
	#position when collision
	positionWhenCollision = position.y
	time = 0
	
	#create tiremarks
	self.add_child(newTireMarks)
