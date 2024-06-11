extends Node2D

# Загрузка сцен
@export var enemy_scenes: Array[PackedScene] = []
@onready var player := $Players/Player
@onready var laser_container := $Laser_Container
@onready var mobs_Container := $Mobs_Container
@onready var hud := $UILayer/HUD
@onready var timer_loc = $TimerLokation
@onready var timer_spawn_mobs = $Timer_spawn_Mobs
@onready var dors = preload("res://scenes/npcs/NPSdors1.tscn")
@onready var nps := $NPS
@onready var animation_arena = $AnimationPlayer
@onready var game_over = $UILayer/Game_Over

# Переменные:
# Обратный отсчет:
var time = 5
# Количество монстров
var mobs_quantity = 0

# Функция старта
func _ready():
	if Global != null:
		hud.score = Global.score
	animation_arena.play("new_animation")
	player.laser_shot.connect(_on_player_laser_shot)
	player.HP_change.connect(_on_player_HP)

# Функция процесса
func _process(_delta):
	pass

# Создание пули
func _on_player_laser_shot(laser_scene, location, target, damage):
	var laser = laser_scene.instantiate()
	laser.global_position = location
	laser.target = target
	laser.damage = damage
	laser_container.add_child(laser)

# Спавн мобов
func _on_timer_timeout():
	if time > 0:
		mobs_quantity += 1
		var mobs = enemy_scenes.pick_random().instantiate()
		var random_x = randi_range(50, 1250)
		var random_y = randi_range(50, 900)
		mobs.global_position = Vector2(random_x, random_y)
		mobs.killed.connect(_on_enemy_killed, Object.ConnectFlags.CONNECT_ONE_SHOT)
		mobs_Container.add_child(mobs)
		timer_spawn_mobs_quantity()

# Смерть моба
func _on_enemy_killed(points):
	if hud != null and Global != null:
		Global.score += points
		hud.score = Global.score
	mobs_quantity -= 1

# Обратный отсчет
func _on_timer_lokation_timeout():
	if time > 0:
		time -= 1
		hud.time = time
	else:
		hud.time = mobs_quantity
		if mobs_quantity <= 0:
			dors_open()
			hud.time = ""
			timer_loc.stop()

# Создание двери
func dors_open():
	var dor = dors.instantiate()
	dor.global_position = Vector2(get_viewport_rect().size / 2)
	nps.add_child(dor)

# Спавн мобов в зависимости от их количества
func timer_spawn_mobs_quantity():
	if mobs_quantity < 9:
		timer_spawn_mobs.wait_time = 0.3
	elif mobs_quantity < 19:
		timer_spawn_mobs.wait_time = 0.5
	elif mobs_quantity < 29:
		timer_spawn_mobs.wait_time = 0.7

# Обновление показателя хп
func _on_player_HP(HP):
	if HP <= 0:
		game_over.visible = true
	hud.hp = HP
