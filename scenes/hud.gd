extends CanvasLayer

@onready var global_singleton = $"/root/GlobalSingleton"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $GameOverLabel.visible == true:
		if Input.is_action_just_pressed("R"):
			get_tree().paused = false
			global_singleton.game_over = false
			get_tree().reload_current_scene()
