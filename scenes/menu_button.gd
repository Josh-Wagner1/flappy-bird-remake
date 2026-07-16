extends TextureButton

@onready var press_1: AudioStreamPlayer = $"../Press1"
@onready var parent = get_parent().get_parent()

func _on_pressed() -> void:
	press_1.play()
	parent.reset_to_main_menu()
