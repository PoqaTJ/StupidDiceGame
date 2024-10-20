extends Control

@onready var profile_service = ServiceLocator.profile_service

func _ready() -> void:
	pass

func get_points_for_max_roll(value:int, first_try:bool) -> int:
	if first_try:
		return value
	return value / 4

func get_points_for_max_reached() -> int:
	return 25

func _on_dice_set_menu_dice_set_completed() -> void:
	profile_service.add_points(get_points_for_max_reached())

func _on_dice_set_menu_max_value_rolled(max: int, first_try: bool) -> void:
	profile_service.add_points(get_points_for_max_roll(max, first_try))
