extends Control

var profile_service : ProfileService

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	profile_service = ServiceLocator.profile_service
	redraw()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func calculate_dice_set_cost() -> int:
	return 0

func redraw() -> void:
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
	redraw()


func _on_buy_button_pressed() -> void:
	buy_dice_set()
