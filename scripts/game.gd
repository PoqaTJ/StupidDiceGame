extends Control

@onready var profile_service = ServiceLocator.profile_service

func _ready() -> void:
	pass

func get_points_for_max_roll(value:int, first_try:bool) -> int:
	if first_try:
		return value
	return value / 4

func get_chips_for_max_reached() -> int:
	return 1

func on_dice_set_menu_dice_set_completed() -> void:
	profile_service.add_chips(get_chips_for_max_reached())
	profile_service.save_to_file()

func on_dice_set_menu_max_value_rolled(index: int, completed: int, max: int, first_try: bool) -> void:
	profile_service.add_points(get_points_for_max_roll(max, first_try))
	profile_service.set_dice_set_progress(index, completed)
	profile_service.save_to_file()

func on_dice_set_reset(id: int) -> void:
	profile_service.set_dice_set_progress(id, 0)
	profile_service.save_to_file()

func roll(method: Constants.RollerMethod) -> void:
	if method == Constants.RollerMethod.Max:
		roll_max()
	elif method == Constants.RollerMethod.Min:
		roll_min()
	elif method == Constants.RollerMethod.Only20:
		roll_only20()
	elif method == Constants.RollerMethod.Random:
		roll_random()
	elif method == Constants.RollerMethod.First:
		roll_first()

func roll_random() -> void:
	var sets = get_eligible_dice_sets()
	if sets.size() == 0:
		return
	var i = randi_range(0, sets.size() - 1)
	var dice_set = sets[i] as DiceSet
	dice_set.roll()

func roll_max() -> void:
	var sets = get_eligible_dice_sets()
	if sets.size() == 0:
		return
	var chosen_dice_set : DiceSet
	for i in range(sets.size()):
		var dice_set = sets[i] as DiceSet
		if chosen_dice_set == null or dice_set.current_index > chosen_dice_set.current_index:
			chosen_dice_set = dice_set
	chosen_dice_set.roll()


func roll_min() -> void:
	var sets = get_eligible_dice_sets()
	if sets.size() == 0:
		return
	var chosen_dice_set : DiceSet
	for i in range(sets.size()):
		var dice_set = sets[i] as DiceSet
		if chosen_dice_set == null or dice_set.current_index < chosen_dice_set.current_index:
			chosen_dice_set = dice_set
	chosen_dice_set.roll()
	
func roll_only20() -> void:
	var sets = get_eligible_dice_sets()
	if sets.size() == 0:
		return
	var possible_sets : Array
	for i in range(sets.size()):
		var dice_set = sets[i] as DiceSet
		if dice_set.current_index == 5:
			possible_sets.append(dice_set)
	if possible_sets.size() == 0:
		return
	var chosen_dice_set = possible_sets[randi_range(0, possible_sets.size() - 1)]
	chosen_dice_set.roll()
	
func roll_first() -> void:
	var sets = get_eligible_dice_sets()
	if sets.size() == 0:
		return
	var possible_sets : Array
	for i in range(sets.size()):
		var dice_set = sets[i] as DiceSet
		if dice_set.dice[dice_set.current_index].first_try:
			possible_sets.append(dice_set)
	if possible_sets.size() == 0:
		return
	var chosen_dice_set = possible_sets[randi_range(0, possible_sets.size() - 1)]
	chosen_dice_set.roll()

func get_eligible_dice_sets() -> Array:
	var ret = []
	var dice_set_menu = $"HBoxContainer/Dice Set Menu" as DiceSetMenu
	for i in range(dice_set_menu.dice_sets.size()):
		var d = dice_set_menu.get_dice_set(i) as DiceSet
		if d.can_be_rolled():
			ret.append(d)
	return ret

func reset() -> void:
	$ConfirmationDialog.visible = true

func really_reset() -> void:
	profile_service.profile = Profile.new()
	profile_service.save_to_file()
	get_tree().reload_current_scene()	


func cancel_reset() -> void:
	$ConfirmationDialog.visible = false
