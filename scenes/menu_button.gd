extends TextureButton

signal btn_pressed

func _on_pressed() -> void:
	btn_pressed.emit()
