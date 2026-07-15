extends Node2D

# Constants
const PIPE = preload("uid://cpu88kec1ggg4")
const PIPE_GREEN_TOP = preload("uid://dfn8bndf861kg")
const PIPE_GREEN_BOTTOM = preload("uid://cbup833d453o1")
const PIPE_BROWN_TOP = preload("uid://d4ckejjc1paiu")
const PIPE_BROWN_BOTTOM = preload("uid://dpqpn2fifr0o8")
const SCOREZONE = preload("uid://byex7xpm4tev1")
const COIN = preload("uid://vj5enqcg5fvp")
const PAUSE_MENU = preload("uid://br35mj14l3w3j")

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
	pass

# Recurring actions
func _process(delta: float) -> void:
	_set_speed()
	
	if pipe_cooldown.is_stopped() and playing:
		# Pipes
		var dif := rng.randi_range(-225, 225)
		_spawn_pipe(Vector2(800, 90 + dif), PIPE_GREEN_TOP)
		_spawn_pipe(Vector2(800, 910 + dif), PIPE_GREEN_BOTTOM)
		
		# Coin if successful
		var c := rng.randi_range(1, 10)
		if c == 5:
			var coin = COIN.instantiate()
			coin.global_position = (Vector2(800, 495 + dif))
			$Pipes.add_child(coin)
		
		var score_zone = SCOREZONE.instantiate()
		$Pipes.add_child(score_zone)
		
		pipe_cooldown.start()

func _on_start() -> void:
	playing = true
	pipe_cooldown.start()
	bird.set_collision_mask_value(8, true)
	
	# hide the menu and add pause
	menu.toggle_menu(false)
	$UI/PauseMenu/Pause.show()

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

# Adds a point
func add_score(num: int = 1):
	score += num
	score_label.text = str(score)

# Resets to main menu
func reset_to_main_menu():
	game_over.play("RESET")
	$Scoreboard/AnimationPlayer.play("RESET")
	
	score = 0
	score_label.text = str(score)
	
	for child in $Pipes.get_children():
		child.queue_free()
	
	bg_speed = 0.2
	bird.reset()
	menu.toggle_menu(true)

# Kills player
func kill_player():
	playing = false
	bg_speed = 0.0
	bird.set_collision_mask_value(8, false)
	bird.alive = false
	bird.sprite.play("yellow_dead")
	game_over.play("appear")
	
	$UI/PauseMenu/Pause.hide()
	$Scoreboard/AnimationPlayer.play("appear")
	$Scoreboard/Score.set_score(score)
	
	if score < 20:
		$Scoreboard/SilverMedal.show()
		$Scoreboard/GoldMedal.hide()
	else:
		$Scoreboard/SilverMedal.hide()
		$Scoreboard/GoldMedal.show()
