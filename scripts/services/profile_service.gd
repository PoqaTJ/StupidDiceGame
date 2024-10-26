extends Node
class_name ProfileService

var profile: Profile

signal on_dice_set_bought(count)
signal on_points_changed(old, new)
signal on_profile_load(profile)

func _ready() -> void:
	pass

func init(p: Profile):
	profile = p

func get_points() -> int:
	return profile.points

func add_points(value:int) -> void:
	var current_points = profile.points
	if value <= 0:
		print("ERROR: profile_service.add_points() with non-positive value " + str(value))
	profile.points += value
	profile.points = max(0, profile.points)
	on_points_changed.emit(current_points, profile.points)

func has_points(value:int) -> bool:
	return profile.points >= value

func spend_points(value:int) -> bool:
	var current_points = profile.points
	if !has_points(value):
		return false
	profile.points -= value
	on_points_changed.emit(current_points, profile.points)
	return true

func count_dice_sets() -> int:
	return profile.dice_sets.size()
	
func add_dice_set() -> void:
	profile.dice_sets.append(0)
	on_dice_set_bought.emit(count_dice_sets())
