extends CharacterBody2D

# Signals
signal start
signal dead

# Constants
const SPEED = 300.0
const JUMP_VELOCITY = -600.0
const IDLE_SPEED = 3
const IDLE_AMPLITUDE = -90

# Variables
var idle := true
var alive := true
var time_elapsed := 0.0

# Onready variables
@onready var sprite: AnimatedSprite2D = $Sprite

func _ready() -> void:
	global_position = Vector2(360, 550)
	sprite.play("fly")

func _physics_process(delta: float) -> void:
	# gather time for use in idle animation
	time_elapsed += delta
	
	# Apply gravity
	if not is_on_floor() and !idle:
		velocity += get_gravity() * delta
	elif idle:
		velocity.y = sin(time_elapsed * IDLE_SPEED) * IDLE_AMPLITUDE

	# Handle jump
	if Input.is_action_just_pressed("jump") and alive:
		if idle:
			idle = false
			start.emit()
		
		velocity.y = JUMP_VELOCITY
	
	# Adjust rotation
	var sprite_rotation = 0 + velocity.y/600
	
	if sprite_rotation < PI/2:
		sprite.rotation = 0 + velocity.y/600
	else:
		sprite.rotation = PI/2
	
	move_and_slide()
