extends Control
class_name DiceSetMenu

@onready var profile_service:ProfileService = ServiceLocator.profile_service
var dice_scene = preload("res://dice_set.tscn")

signal max_value_rolled(max:int, first_try:bool)
signal dice_set_completed()

func _ready() -> void:
	profile_service.on_dice_set_bought.connect(on_dice_set_add)

func on_dice_set_add(count:int) -> void:
	var dice_set = dice_scene.instantiate()
	dice_set.die_maxxed.connect(on_dice_set_max_value_rolled)
	dice_set.dice_set_completed.connect(on_dice_set_completed)
	$VBoxContainer.add_child(dice_set)

func on_dice_set_max_value_rolled(max:int, first_try:bool) -> void:
	max_value_rolled.emit(max, first_try)
	
func on_dice_set_completed() -> void:
	dice_set_completed.emit()
