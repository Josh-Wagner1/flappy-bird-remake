extends AnimatableBody2D

# Variables
var image
var start_position: Vector2

# Onready variables
@onready var sprite: Sprite2D = $Sprite
@onready var parent = get_parent().get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = position
	sprite.texture = image

# Move until off screen
func _physics_process(delta: float) -> void:
	var speed = parent.bg_speed * 1000
	global_position.x -= delta * speed
	
	if global_position.x < -50:
		queue_free()
