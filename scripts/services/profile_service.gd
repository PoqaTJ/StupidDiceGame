extends Node
class_name ProfileService

var points:int = 0

var dice_sets:Array = [] # array of ints, which is index of dice set's current max roll, default 0

signal on_dice_set_bought(count)
signal on_points_changed(old, new)

func _ready() -> void:
	pass

func get_points() -> int:
	return points

func add_points(value:int) -> void:
	var current_points = points
	if value <= 0:
		print("ERROR: profile_service.add_points() with non-positive value " + str(value))
	points += value
	points = max(0, points)
	on_points_changed.emit(current_points, points)

func has_points(value:int) -> bool:
	return points >= value

func spend_points(value:int) -> bool:
	var current_points = points
	if !has_points(value):
		return false
	points -= value
	on_points_changed.emit(current_points, points)
	return true

func count_dice_sets() -> int:
	return dice_sets.size()
	
func add_dice_set() -> void:
	dice_sets.append(0)
	on_dice_set_bought.emit(count_dice_sets())
