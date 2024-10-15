extends Node

var value: int = 1
var max_value: int = 4
var rolling: bool = false
var roll_duration: float = 1.0
var roll_time: float = 1.0
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
signal on_max_rolled

var numberText: Label

func set_die(max: int) -> void:
	max_value = max

func _ready() -> void:
	numberText = $Label

func toggle(active:bool) -> void:
	$Area2D/CollisionShape2D.disabled = !active
	$Label.visible = active || value != 1

func _process(delta: float) -> void:
	if rolling:
		value = rng.randi_range(1, max_value)
		update_visuals()
		roll_time = max(0, roll_time - delta)
		if roll_time == 0:
			rolling = false
			check_for_max()
	
func roll() -> void:
	if !rolling:
		rolling = true
		roll_time = roll_duration

func check_for_max():
	if value == max_value:
		on_max_rolled.emit()
		numberText.add_theme_color_override("font_color", Color("00ff00"))

func update_visuals():
	numberText.text = str(value)

func _on_Box_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		roll()
