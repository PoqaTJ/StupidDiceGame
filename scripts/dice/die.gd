extends Node

var value: int = 1
var max_value: int = 4
var rolling: bool = false
var roll_duration: float = 1.0
var roll_time: float = 1.0
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var first_try: bool = true
signal on_max_rolled(max:int, first_try:bool)

func set_die(max: int) -> void:
	max_value = max

func toggle(active:bool) -> void:
	$Button.visible = active || value != 1

func _process(delta: float) -> void:
	if rolling:
		value = rng.randi_range(1, max_value)
		roll_time = max(0, roll_time - delta)
		if roll_time == 0:
			rolling = false
			check_for_max()
		update_visuals()

	
func roll() -> void:
	if !rolling and value != max_value:
		rolling = true
		roll_time = roll_duration

func check_for_max():
	if value == max_value:
		on_max_rolled.emit(max_value, first_try)
	else:
		first_try = false

func update_visuals():
	if value == max_value and !rolling:
		$Button.add_theme_color_override("font_color", Color("00ff00"))
	else:
		$Button.add_theme_color_override("font_color", Color("ffffff"))
	$Button.text = str(value)

func reset():
	value = 1
	rolling = false
	first_try = true

func _on_Box_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		roll()

func _on_button_pressed() -> void:
	roll()
