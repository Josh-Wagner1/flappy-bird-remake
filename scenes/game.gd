extends Node2D

# Constants
const SCOREZONE = preload("uid://byex7xpm4tev1")
const PIPE = preload("uid://cpu88kec1ggg4")
const PIPE_GREEN_TOP = preload("uid://dfn8bndf861kg")
const PIPE_GREEN_BOTTOM = preload("uid://cbup833d453o1")
const PIPE_BROWN_TOP = preload("uid://d4ckejjc1paiu")
const PIPE_BROWN_BOTTOM = preload("uid://dpqpn2fifr0o8")

# Variables
var rng := RandomNumberGenerator.new()
var playing := false
var bg_speed := 0.2
var bg_time := 0.0
var score := 0

# Onready imports
@onready var background: TextureRect = $Background/Background
@onready var scoreboard: CanvasLayer = $Scoreboard
@onready var game_over: AnimationPlayer = $GameOver/AnimationPlayer
@onready var ui: CanvasLayer = $UI
@onready var menu: Node2D = $UI/MainMenu
@onready var ground: TextureRect = $UI/Ground
@onready var score_label: Label = $Score
@onready var pipe_cooldown: Timer = $PipeCooldown
@onready var bird: CharacterBody2D = $Bird

# Startup actions
func _ready() -> void:
	$Scoreboard/MenuButton.pressed.connect(_on_menu_button_pressed)

# Recurring actions
func _process(delta: float) -> void:
	_set_speed()
	
	if pipe_cooldown.is_stopped() and playing:
		var dif = rng.randi_range(-225, 225)
		
		_spawn_pipe(Vector2(800, 90 + dif), PIPE_GREEN_TOP)
		_spawn_pipe(Vector2(800, 910 + dif), PIPE_GREEN_BOTTOM)
		
		var score_zone = SCOREZONE.instantiate()
		$Pipes.add_child(score_zone)
		
		pipe_cooldown.start()

func _on_start() -> void:
	playing = true
	pipe_cooldown.start()
	# hide the menu
	menu.toggle_menu(false)

# sets speed of background
func _set_speed() -> void:
	bg_time += bg_speed * get_process_delta_time()
	ground.material.set_shader_parameter("speed", bg_time)
	background.material.set_shader_parameter("speed", bg_time)

# Spawns a pipe at the specified position
func _spawn_pipe(pos: Vector2, type) -> void:
	var pipe = PIPE.instantiate()
	pipe.image = type
	pipe.position = pos
	
	$Pipes.add_child(pipe)

func _on_menu_button_pressed():
	game_over.play("RESET")
	$Scoreboard/AnimationPlayer.play("RESET")
	
	score = 0
	score_label.text = str(score)
	
	for child in $Pipes.get_children():
		child.queue_free()
	
	bg_speed = 0.2
	bird.reset()
	menu.toggle_menu(true)

# Adds a point
func add_score():
	score += 1
	score_label.text = str(score)

# Kills player
func kill_player():
	playing = false
	bg_speed = 0.0
	bird.set_collision_mask_value(8, false)
	bird.alive = false
	bird.sprite.play("yellow_dead")
	game_over.play("appear")

	$Scoreboard/AnimationPlayer.play("appear")
	$Scoreboard/Score.set_score(score)
	
	if score < 20:
		$Scoreboard/SilverMedal.show()
		$Scoreboard/GoldMedal.hide()
	else:
		$Scoreboard/SilverMedal.hide()
		$Scoreboard/GoldMedal.show()
