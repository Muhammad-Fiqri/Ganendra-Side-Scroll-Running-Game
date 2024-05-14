extends Area2D

@onready var global_singleton = $"/root/GlobalSingleton"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if (global_position.x - global_singleton.player_x_position) <= -400:
		queue_free()


func _on_body_entered(body):
	if body.name == "Player":
		global_singleton.game_over = true
