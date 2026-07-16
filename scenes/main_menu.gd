extends Node2D

# Constants
const SPEED = 1300
const HIDDEN_LOGO_Y = -100
const HIDDEN_CONTROLS_Y = 1600
const HIDDEN_LEFT_Y = 1600
const HIDDEN_RIGHT_Y = 1600

# Public variables
var is_visible := true
var logo_pos: float
var controls_pos: float
var left_pos: float
var right_pos: float
var target1: float
var target2: float
var target3: float
var target4: float

# Onready variables
@onready var logo: Sprite2D = $Logo
@onready var controls: Sprite2D = $Controls
@onready var left_arrow: TextureButton = $Arrows/LeftArrow
@onready var right_arrow: TextureButton = $Arrows/RightArrow
@onready var background: TextureButton = $Arrows/Background
@onready var press_1: AudioStreamPlayer = $Arrows/Press1
@onready var press_2: AudioStreamPlayer = $Arrows/Press2
@onready var parent = get_parent().get_parent()

# Startup actions
func _ready() -> void:
	logo_pos = logo.global_position.y
	controls_pos = controls.global_position.y
	left_pos = left_arrow.global_position.y
	right_pos = right_arrow.global_position.y
	set_process(false)
	print(background.disabled)

# Recurring actions
func _process(delta: float) -> void:
	var y1 = logo.global_position.y
	var y2 = controls.global_position.y
	var y3 = left_arrow.global_position.y
	var y4 = right_arrow.global_position.y

	logo.global_position.y = move_toward(y1, target1, delta * SPEED)
	controls.global_position.y = move_toward(y2, target2, delta * SPEED * 3)
	left_arrow.global_position.y = move_toward(y3, target3, delta * SPEED * 3.1)
	right_arrow.global_position.y = move_toward(y4, target4, delta * SPEED * 3.1)
	
	if y1 - target1 < 0.5 and y2 + target2 < 0.5:
		set_process(false)

# Triggers show and hide animations
func toggle_menu(b : bool):
	set_process(true)
	is_visible = b
	
	if is_visible:
		target1 = logo_pos
		target2 = controls_pos
		target3 = left_pos
		target4 = right_pos
		background.show()
	else:
		target1 = HIDDEN_LOGO_Y
		target2 = HIDDEN_CONTROLS_Y
		target3 = HIDDEN_LEFT_Y
		target4 = HIDDEN_RIGHT_Y
		background.hide()

func toggle_arrows(temp: int):
	if temp <= 0:
		left_arrow.disabled = true
		right_arrow.disabled = false
	elif temp >= 2:
		left_arrow.disabled = false
		right_arrow.disabled = true
	else:
		left_arrow.disabled = false
		right_arrow.disabled = false

func _on_left_arrow_pressed() -> void:
	var temp: int = parent.set_skin(-1)
	toggle_arrows(temp)
	press_1.play()

func _on_right_arrow_pressed() -> void:
	var temp: int = parent.set_skin(1)
	toggle_arrows(temp)
	parent.toggle_background()
	press_1.play()

func _on_background_pressed() -> void:
	parent.toggle_background()
	press_2.play()
