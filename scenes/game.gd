extends Node2D

# Constants

# Variables

# Onready imports
@onready var ui: CanvasLayer = $UI
@onready var menu: Node2D = $UI/MainMenu
@onready var bird: CharacterBody2D = $Bird

# Startup actions
func _ready() -> void:
	pass

# Recurring actions
func _process(delta: float) -> void:
	pass

func _on_start() -> void:
	menu.toggle_menu(false)
