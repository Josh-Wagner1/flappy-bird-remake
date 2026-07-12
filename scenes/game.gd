extends Node2D

# Constants
const PIPE = preload("uid://cpu88kec1ggg4")
const PIPE_GREEN_TOP = preload("uid://dfn8bndf861kg")
const PIPE_GREEN_BOTTOM = preload("uid://cbup833d453o1")
const PIPE_BROWN_TOP = preload("uid://d4ckejjc1paiu")
const PIPE_BROWN_BOTTOM = preload("uid://dpqpn2fifr0o8")

# Variables
var playing := false
var bg_speed := 0.2
var bg_time := 0.0

# Onready imports
@onready var ui: CanvasLayer = $UI
@onready var menu: Node2D = $UI/MainMenu
@onready var ground: TextureRect = $UI/Ground
@onready var background: TextureRect = $UI/Background
@onready var pipe_cooldown: Timer = $PipeCooldown
@onready var bird: CharacterBody2D = $Bird

# Startup actions
func _ready() -> void:
	pass

# Recurring actions
func _process(delta: float) -> void:
	_set_speed()
	
	if pipe_cooldown.is_stopped() and playing:
		
		# TODO add noise to randomise pipe positions
		
		_spawn_pipe(Vector2(800, 100), PIPE_GREEN_TOP)
		_spawn_pipe(Vector2(800, 900), PIPE_GREEN_BOTTOM)
		
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
	
	add_child(pipe)

# Kills player
func kill_player():
	bg_speed = 0.0
	bird.alive = false
	bird.sprite.play("yellow_dead")
