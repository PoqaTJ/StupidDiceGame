extends Node2D

var dice:Array
var current_index:int = 0

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
	die.on_max_rolled.connect(increment_max)

func update_current_die() -> void:
	for i in range(dice.size()):
		dice[i].toggle(i == current_index)
		
func increment_max() -> void:
	current_index += 1
	update_current_die()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass