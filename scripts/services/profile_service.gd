extends Node
class_name ProfileService

var profile: Profile

signal on_dice_set_bought(count)
signal on_points_changed(old, new)

func load_from_save():
	print("Loading!")
	var p = load("user://profile.tres") as Profile
	if p == null:
		print("No saved profile found. Creating a new one.")
		p = Profile.new()
		save_to_file()
	init(p)
	
func save_to_file():
	print("Saving!")
	ResourceSaver.save(profile, "user://profile.tres")

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
	save_to_file()

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

func set_dice_set_progress(index:int, completed:int) -> void:
	profile.dice_sets[index] = completed	

func add_dice_set() -> void:
	profile.dice_sets.append(0)
	on_dice_set_bought.emit(count_dice_sets())
	save_to_file()
