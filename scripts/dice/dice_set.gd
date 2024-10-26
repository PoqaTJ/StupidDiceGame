extends Control

var id:int
var dice:Array
var current_index:int = 0
var reset_time:float = 2
var resetting:bool = false

signal die_maxxed(index:int, completed: int, max:int, first_try:bool)
signal dice_set_completed()
signal dice_set_reset()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initDie(4)
	initDie(6)
	initDie(8)
	initDie(10)
	initDie(12)
	initDie(20)
	update_current_die()

func _process(delta: float) -> void:
	if current_index >= dice.size():
		reset_after_wait()

func initDie(num:int) -> void:
	var die = get_node("HBoxContainer/d" + str(num))
	dice.append(die)
	die.set_die(num)
	die.on_max_rolled.connect(on_die_max_roll)

func update_current_die() -> void:
	for i in range(dice.size()):
		if i < current_index:
			dice[i].value = dice[i].max_value
		dice[i].toggle(i == current_index)
		dice[i].update_visuals()

func on_die_max_roll(max:int, first_try:bool) -> void:
	die_maxxed.emit(id, current_index + 1, max, first_try)
	increment_max()
	if current_index > dice.size():
		dice_set_completed.emit();

func reset_after_wait():
	if resetting == false and get_tree() != null:
		resetting = true
		await get_tree().create_timer(reset_time).timeout
		resetting = false
		reset()

func reset() -> void:
	current_index = 0
	for i in range(dice.size()):
		dice[i].reset()
	dice_set_reset.emit(id)
	update_current_die()
		
func increment_max() -> void:
	current_index += 1
	update_current_die()
