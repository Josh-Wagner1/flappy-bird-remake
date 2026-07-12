extends Area2D

@onready var parent = get_parent().get_parent()

# Kills player on impact
func _on_body_entered(body: Node2D) -> void:
	parent.kill_player()
