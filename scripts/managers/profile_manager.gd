extends Node

var points:int = 0

func _ready() -> void:
	pass

func get_points() -> int:
	return points

func add_points(value:int) -> void:
	if value <= 0:
		print("ERROR: profile_manager.add_points() with non-positive value " + str(value))
	points += value
	points = max(0, points)

func has_points(value:int) -> bool:
	return points >= value

func spend_points(value:int) -> bool:
	if !has_points(value):
		return false
	points -= value
	return true
