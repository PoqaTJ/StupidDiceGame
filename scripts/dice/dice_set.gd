extends Control

var dice:Array
var current_index:int = 0

signal die_maxxed(max:int, first_try:bool)
signal dice_set_completed()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initDie(4)
	initDie(6)
	initDie(8)
	initDie(10)
	initDie(12)
	initDie(20)
	update_current_die()

func initDie(num:int) -> void:
	var die = get_node("HBoxContainer/d" + str(num))
	dice.append(die)
	die.set_die(num)
	die.on_max_rolled.connect(on_die_max_roll)

func update_current_die() -> void:
	for i in range(dice.size()):
		dice[i].toggle(i == current_index)

func on_die_max_roll(max:int, first_try:bool) -> void:
	die_maxxed.emit(max, first_try)
	increment_max()
	if current_index > dice.size():
		dice_set_completed.emit();
		
func increment_max() -> void:
	current_index += 1
	update_current_die()
