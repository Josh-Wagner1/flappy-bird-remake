extends TextureButton

var num := 3

@onready var countdown: Label = $"../Countdown"
@onready var countdown_timer: Timer = $"../CountdownTimer"
@onready var paused: Label = $"../Paused"
@onready var press_1: AudioStreamPlayer = $"../Press1"
@onready var timer_sfx: AudioStreamPlayer = $"../TimerSfx"

# Pauses/Unpauses game
func _on_pressed() -> void:
	press_1.play()
	
	if get_tree().paused:
		paused.hide()
		countdown.show()
		
		while num > 0:
			countdown.text = str(num)
			timer_sfx.play()
			countdown_timer.start()
			
			await countdown_timer.timeout
			num -= 1
		
		countdown.hide()
		num = 3
	else:
		paused.show()
	
	get_tree().paused = !get_tree().paused
	get_tree().root.set_input_as_handled()
