extends Node
class_name Roller

@export var config: RollerConfig
@export var id: int
var profile_service = ServiceLocator.profile_service
var enabled: bool = false
var current_wait_time:float

signal on_roll(method:Constants.RollerMethod)

func _ready() -> void:
	profile_service.on_chips_changed.connect(chips_changed)
	current_wait_time = calc_wait_time()
	$Timer.wait_time = current_wait_time
	$Timer.timeout.connect(roll)
	redraw()

func _process(delta) -> void:
	if enabled:
		var time_left = $Timer.time_left
		$ProgressBar.value = time_left / current_wait_time

func calc_wait_time() -> float:
	var time: float = config.time
	time = max(0.1, time - (0.05 * profile_service.get_roller_level(id)))
	return time

func press_buy() -> void:
	if profile_service.spend_chips(chips_to_upgrade()):
		profile_service.increment_roller_level(id)
		redraw()

func roll() -> void:
	on_roll.emit(config.method)
	current_wait_time = calc_wait_time()
	$Timer.wait_time = current_wait_time

func redraw():
	var level: int = profile_service.get_roller_level(id)
	enabled  = level > 0
	$Name.text = config.name + ": "
	$Desc.text = "Rolls " + describe_method()
	$Level.text = "Lvl: " + str(profile_service.get_roller_level(id))
	$Button.disabled = !profile_service.has_chips(chips_to_upgrade())
	
	if enabled:
		$Button.text = "Upgrade"
		$ProgressBar.visible = true
		if $Timer.is_stopped():
			$Timer.start()
	else:
		$Button.text = "Buy"
		$ProgressBar.visible = false

func chips_to_upgrade() -> int:
	return max(1, profile_service.get_roller_level(id) * 2)

func chips_changed(old:int, new:int) -> void:
	redraw()
	
func describe_method() -> String:
	if config.method == Constants.RollerMethod.Random:
		return "random"
	elif config.method == Constants.RollerMethod.Max:
		return "largest"
	elif config.method == Constants.RollerMethod.Min:
		return "smallest"
	elif config.method == Constants.RollerMethod.Only20:
		return "d20's"
	elif config.method == Constants.RollerMethod.First:
		return "frist tries"
	else:
		return "Not found."
