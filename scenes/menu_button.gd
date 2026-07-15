extends TextureButton

@onready var parent = get_parent().get_parent()

func _on_pressed() -> void:
	parent.reset_to_main_menu()
