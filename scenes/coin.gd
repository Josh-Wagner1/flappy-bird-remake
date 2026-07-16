extends Area2D

@onready var pickup: AudioStreamPlayer = $Pickup
@onready var parent = get_parent().get_parent()

# Move until off screen
func _physics_process(delta: float) -> void:
	var speed = parent.bg_speed * 1000
	global_position.x -= delta * speed
	
	if global_position.x < -50:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	parent.add_score(5)
	pickup.play()
	hide()
	
	await pickup.finished
	queue_free()
