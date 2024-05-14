extends Area2D

@onready var global_singleton = $"/root/GlobalSingleton"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x -= get_parent().speed / 2
	
	#if not $AttackMusic.playing:
	#	$AttackMusic.play()
	
	if (global_position.x - global_singleton.player_x_position) <= -400:
		queue_free()
	
	detect_if_near_player()

func detect_if_near_player():
	if global_position.x - global_singleton.player_x_position <= 400:
		if $AttackMusic.playing != true:
			$AttackMusic.play(0.0)
		$AnimatedSprite2D.play("attack")
		$AttackCol.disabled = false

func _on_body_entered(body):
	if body.name == "Player":
		global_singleton.game_over = true
