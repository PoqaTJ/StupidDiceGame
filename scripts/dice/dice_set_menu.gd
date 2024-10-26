extends Control
class_name DiceSetMenu

@onready var profile_service:ProfileService = ServiceLocator.profile_service
var dice_scene = preload("res://dice_set.tscn")

signal max_value_rolled(id: int, index:int, max:int, first_try:bool)
signal dice_set_completed()
signal dice_set_reset(id: int)

func _ready() -> void:
	for i in range(profile_service.count_dice_sets()):
		add_dice_set(i, profile_service.profile.dice_sets[i])
	profile_service.on_dice_set_bought.connect(on_dice_set_add)

func get_next_dice_set_id() -> int:
	return profile_service.count_dice_sets()

func on_dice_set_add(count:int) -> void:
	add_dice_set(get_next_dice_set_id(), 0)

func add_dice_set(id:int, completed:int) -> void:
	var dice_set = dice_scene.instantiate()
	dice_set.id = id
	dice_set.current_index = completed
	dice_set.die_maxxed.connect(on_dice_set_max_value_rolled)
	dice_set.dice_set_completed.connect(on_dice_set_completed)
	dice_set.dice_set_reset.connect(on_dice_set_reset)
	dice_set.update_current_die()
	$VBoxContainer.add_child(dice_set)

func on_dice_set_max_value_rolled(id: int, index:int, max:int, first_try:bool) -> void:
	max_value_rolled.emit(id, index, max, first_try)
	
func on_dice_set_completed() -> void:
	dice_set_completed.emit()
	
func on_dice_set_reset(id:int) -> void:
	dice_set_reset.emit(id)
