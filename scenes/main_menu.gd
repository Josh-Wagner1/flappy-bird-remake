extends Node2D

# Constants
const SPEED = 1300
const HIDDEN_LOGO_Y = -100
const HIDDEN_CONTROLS_Y = 1600

# Public variables
var is_visible := true
var logo_pos: float
var controls_pos: float
var target1: float
var target2: float

# Onready variables
@onready var logo: Sprite2D = $Logo
@onready var controls: Sprite2D = $Controls

# Startup actions
func _ready() -> void:
	logo_pos = logo.global_position.y
	controls_pos = controls.global_position.y
	set_process(false)

# Recurring actions
func _process(delta: float) -> void:
	var y1 = logo.global_position.y
	var y2 = controls.global_position.y

	logo.global_position.y = move_toward(y1, target1, delta * SPEED)
	controls.global_position.y = move_toward(y2, target2, delta * SPEED)
	
	if y1 - target1 < 0.5 and y2 + target2 < 0.5:
		print(y2)
		set_process(false)

# Triggers show and hide animations
func toggle_menu(b : bool):
	set_process(true)
	is_visible = b
	
	if is_visible:
		target1 = logo_pos
		target2 = controls_pos
	else:
		target1 = HIDDEN_LOGO_Y
		target2 = HIDDEN_CONTROLS_Y
