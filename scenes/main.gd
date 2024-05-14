extends Node
@onready var idle_music = $"idleMusic"
@onready var run_music = $runMusic
@onready var global_singleton = $"/root/GlobalSingleton"

# obstacle dan bandit
var stump_scene = preload("res://scenes/stump.tscn")
var rock_scene = preload("res://scenes/rock.tscn")
var barrel_scene = preload("res://scenes/barrel.tscn")
var fbandit_scene = preload("res://scenes/fbandit.tscn")
var obstacle_types := [stump_scene, rock_scene, barrel_scene]
var obstacles : Array
var fbandit_position : = [200, 485]

#variabel
const PLAYER_START_POS := Vector2i(150, 485)
const CAM_START_POS := Vector2i(576, 324)
var difficulty
const MAX_DIFFICULTY : int = 1
var score : int
const SCORE_MODIFIER : int = 10
var speed : float
const START_SPEED : float = 10.0
const MAX_SPEED : int = 25
const SPEED_MODIFIER : int = 5000
var screen_size : Vector2i
var ground_height : int
var game_running : bool = false
var last_obs

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_window().size
	ground_height = $Ground.get_node("Sprite2D").texture.get_height()
	new_game()

func new_game():
	#reset variabel
	score = 0
	#munculkan skor 0 pada saat belum memulai game
	show_score()
	
	play_idle_music()
	game_running = false
	difficulty = 0
	#reset node
	$Player.position = PLAYER_START_POS
	$Player.velocity = Vector2i(0, 0)
	$Camera2D.position = CAM_START_POS
	$Ground.position = Vector2i(0, 0)
	#reset/munculkan HUD
	$HUD.get_node("StartLabel").show()

func play_idle_music():
	run_music.stop()
	idle_music.play()

func play_run_music():
	run_music.play()
	idle_music.stop()

func handle_gameover():
	if global_singleton.game_over == true:
		$HUD.get_node("GameOverLabel").visible = true
		get_tree().paused = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if game_running:
		#speed up n adjust difficulty
		speed = START_SPEED + score / SPEED_MODIFIER
		if speed > MAX_SPEED:
			speed = MAX_SPEED
		adjust_difficulty()
		
		#generate obstacle only of not reaching 20000
		if score < 200000:
			generate_obs()
			
		#mevement player dan camera2d
		$Player.position.x += speed
		$Camera2D.position.x += speed
		
		#skor update
		score += speed
		show_score()

		#update posisi ground
		if $Camera2D.position.x - $Ground.position.x > screen_size.x * 1.5:
			$Ground.position.x += screen_size.x
		
		handle_gameover()
		handle_escape()
	else:
		
		if Input.is_action_pressed("ui_accept"):
			play_run_music()
			game_running = true
			#sembunyikan HUD saat bermain
			$HUD.get_node("StartLabel").hide()
			$HUD.get_node("W-key").hide()
			$HUD.get_node("S-key").hide()

func generate_obs():
	#generate obstacle di ground
	if obstacles.is_empty() or last_obs.position.x < score + randi_range(300, 500):
		var obs_type = obstacle_types[randi() % obstacle_types.size()]
		var obs
		var max_obs = difficulty + 1
		for i in range(randi() % max_obs + 1):
			obs = obs_type.instantiate()
			var obs_height = obs.get_node("Sprite2D").texture.get_height()
			var obs_scale = obs.get_node("Sprite2D").scale
			var obs_x : int = screen_size.x + score + 100 + (i * 100)
			var obs_y : int = screen_size.y - ground_height - (obs_height * obs_scale.y / 2) + 5
			last_obs = obs
			add_obs(obs, obs_x, obs_y)
			
			
		#random spawn bandit
		if difficulty == 0:
			if (randi() % 2) == 0:
				#spawn bandit
				obs = fbandit_scene.instantiate()
				var obs_x : int = screen_size.x + score +100
				#fbandit positioning melayang
				#var obs_y : int = fbandit_position[randi() % fbandit_position.size()]
				
				#fbandit positioning ground
				var obs_y : int = 485
				add_obs(obs, obs_x, obs_y)

func add_obs(obs, x, y):
	obs.position = Vector2i(x, y)
	add_child(obs)
	obstacles.append(obs)

func show_score():
	$HUD.get_node("ScoreLabel").text = "SCORE : " + str(score / SCORE_MODIFIER)

func adjust_difficulty():
	difficulty = score / SPEED_MODIFIER
	if difficulty > MAX_DIFFICULTY:
		difficulty = MAX_DIFFICULTY

func handle_escape():
	if score >= 200000:
		$HUD.get_node("GameWinLabel").visible = true
