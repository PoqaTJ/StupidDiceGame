extends Control

var profile_service : ProfileService

signal roll(method:Constants.RollerMethod)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	profile_service = ServiceLocator.profile_service
	profile_service.on_points_changed.connect(on_points_updated)
	profile_service.on_dice_set_bought.connect(on_dicesets_updated)
	profile_service.on_chips_changed.connect(on_chips_updated)
	redraw()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func calculate_dice_set_cost() -> int:
	var current = profile_service.count_dice_sets()
	if current == 0:
		return 0
	return current + (current / 2)

func redraw() -> void:
	update_points()
	update_chips()
	update_dice_sets()

func on_points_updated(old:int, new:int) -> void:
	update_points()
	update_dice_sets()
	
func on_chips_updated(old:int, new:int) -> void:
	update_chips()

func on_dicesets_updated(count:int) -> void:
	update_dice_sets()

func update_points() -> void:
	$Menu/BodyPanel/PointsLabel.text = "Points: " + str(profile_service.get_points())

func update_chips() -> void:
	$Menu/BodyPanel/ChipsLabel.text = "Chips: " + str(profile_service.get_chips())

func update_dice_sets() -> void:
	var next_dice_set_cost = calculate_dice_set_cost()
	$Menu/BodyPanel/HBoxContainer/BuyButton.disabled = !profile_service.has_points(next_dice_set_cost)
	$Menu/BodyPanel/HBoxContainer/CostLabel.text = "Price: " + str(next_dice_set_cost)
	$Menu/BodyPanel/HBoxContainer/CountLabel.text = "Dice Sets: " + str(profile_service.count_dice_sets())

func buy_dice_set() -> void:
	var next_dice_set_cost = calculate_dice_set_cost()
	if !profile_service.has_points(next_dice_set_cost):
		return
	profile_service.spend_points(next_dice_set_cost)
	profile_service.add_dice_set()

func on_buy_button_pressed() -> void:
	buy_dice_set()
	
func on_roll(method:Constants.RollerMethod) -> void:
	roll.emit(method)
