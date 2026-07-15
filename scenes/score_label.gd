extends Label

var curr_score: int = 0
var target_score: int = 0

@onready var delay: Timer = $Delay

func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	while curr_score < target_score and delay.is_stopped():
		curr_score += 1
		self.text = str(curr_score)
		delay.start()

func set_score(target: int):
	delay.start()
	await delay.timeout
	
	target_score = target
	delay.wait_time = 0.4 / float(target)
