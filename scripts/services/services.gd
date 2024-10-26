extends Node
class_name Services

var profile_service = ProfileService.new()

func _ready() -> void:
	profile_service.load_from_save()
