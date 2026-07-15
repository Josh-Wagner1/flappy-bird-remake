extends Area2D

@onready var parent = get_parent().get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = Vector2(815, 0)

# Move until off screen
func _physics_process(delta: float) -> void:
	var speed = parent.bg_speed * 1000
	global_position.x -= delta * speed
	
	if global_position.x < -50:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	parent.add_score()
