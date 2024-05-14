extends CharacterBody2D

@onready var jump_music = $"JumpMusic"
@onready var attack_music = $"AttackMusic"
@onready var global_singleton = $"/root/GlobalSingleton"

const GRAVITY : int = 4200
const JUMP_SPEED : int = -1250
var is_attacking : bool = false

func _physics_process(delta):
	velocity.y += GRAVITY * delta
	if is_on_floor():
		if not get_parent().game_running:
			$AnimatedSprite2D.play("idle")
		else:
			$RunCol.disabled = false
			if Input.is_action_just_pressed("ui_accept"):
				velocity.y = JUMP_SPEED
				if not jump_music.playing:
					jump_music.play()
			elif Input.is_action_pressed("ui_down"):
				$AnimatedSprite2D.play("attack")
				is_attacking = true
				if not attack_music.playing:
					attack_music.play()
			else:
				if not is_attacking:
					$AnimatedSprite2D.play("run")
	else:
		if not is_attacking:
			$AnimatedSprite2D.play("jump")
	
	move_and_slide()
	
	send_position_to_global_singleton()
	
	handle_attack_detect()

func send_position_to_global_singleton():
	global_singleton.player_x_position = global_position.x

func _on_animated_sprite_2d_animation_looped():
	if $AnimatedSprite2D.animation == "attack":
		is_attacking = false
		$AnimatedSprite2D.play("run")

func _on_attack_area_area_entered(area):
	if area.name == "fbandit":
		area.queue_free()

func handle_attack_detect():
	if is_attacking:
		$AttackArea.monitoring = true
	else:
		$AttackArea.monitoring = false
