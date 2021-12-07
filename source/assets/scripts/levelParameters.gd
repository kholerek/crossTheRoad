extends Node

var maxCarsOnTheRoad = 2
var minimumTravelTime = 4

func setLevelNumber(points):
	if points in range(0,6):
		maxCarsOnTheRoad = 2
		minimumTravelTime = 4
	elif points in range(7,10):
		maxCarsOnTheRoad = 3
		minimumTravelTime = 3.5
	elif points in range(11,15):
		maxCarsOnTheRoad = 3
		minimumTravelTime = 3.0
	elif points in range(16,20):
		maxCarsOnTheRoad = 4
		minimumTravelTime = 3.0
	elif points in range(21,25):
		maxCarsOnTheRoad = 5
		minimumTravelTime = 3.0
	elif points in range(26,30):
		maxCarsOnTheRoad = 5
		minimumTravelTime = 2.5
	elif points in range(30,40):
		maxCarsOnTheRoad = 6
		minimumTravelTime = 2.5
	elif points in range(50,999):
		maxCarsOnTheRoad = 7
		minimumTravelTime = 2.5

func getMaxCarsOnTheRoad():
	return maxCarsOnTheRoad

func getMinimumTravelTime():
	return minimumTravelTime
