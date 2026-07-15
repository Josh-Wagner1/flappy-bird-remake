extends CharacterBody2D

# Signals
signal start
signal dead

# Constants
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const IDLE_SPEED = 3
const IDLE_AMPLITUDE = -90

# Variables
var idle := true
var alive := true
var time_elapsed := 0.0

# Onready variables
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var parent = get_parent()

func _ready() -> void:
	reset()

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
	
	if sprite_rotation <= PI/2 and velocity.y != 0 and alive:
		sprite.rotation = 0 + velocity.y/600
	else:
		sprite.rotation = PI/2
	
	move_and_slide()
	
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider is AnimatableBody2D and alive:
			parent.kill_player()

# resets bird to idle position in main menu
func reset():
	global_position = Vector2(360, 550)
	alive = true
	sprite.play("yellow_fly")
	idle = true
