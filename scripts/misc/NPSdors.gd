extends Control

# ПЕРЕМЕННЫЕ КНОПОК:
@onready var door1 = $ColorRect/Door1
@onready var door2 = $ColorRect/Door2
@onready var door3 = $ColorRect/Door3
@onready var village = $ColorRect/Village
@onready var animation_arena = $"../../AnimationPlayer"

# СПИСОК ДВЕРЕЙ:
var doors = []
# Локация, где мы находимся
var location = Global.location

# ФУНКЦИЯ ПЕРЕД ЗАПУСКОМ СЦЕНЫ:
func _ready():
	location_check()
	generate_doors()
	update_doors_text()

# Скрываем кнопку в город, если мы уже в городе
func location_check():
	if Global.location == "village":
		village.visible = false

# Возвращаем случайную дверь из списка по ключу глобальной локации
func get_random_door():
	var locations = {
		"village": ["arena_1", "arena_2", "arena_3"],
		"arena_1": ["arena_1", "arena_3", "arena_4"],
		"arena_2": ["arena_1", "arena_4", "arena_5"],
		"arena_3": ["arena_1", "arena_5", "arena_6"],
		"arena_4": ["arena_1", "arena_6", "arena_1"],
		"arena_5": ["arena_1", "arena_2", "arena_3"],
		"arena_6": ["arena_1", "arena_2", "arena_3"]
	}
	return locations[location].pick_random()

# Создаем список из 3 уникальных дверей
func generate_doors():
	while len(doors) < 3:
		var door = get_random_door()
		if door not in doors:
			doors.append(door)

# Обновляем текст на кнопках дверей
func update_doors_text():
	door1.text = doors[0]
	door2.text = doors[1]
	door3.text = doors[2]

# Действие кнопки 1 по нажатию
func _on_door1_pressed():
	change_scene(doors[0])

# Действие кнопки 2 по нажатию
func _on_door2_pressed():
	change_scene(doors[1])

# Действие кнопки 3 по нажатию
func _on_door3_pressed():
	change_scene(doors[2])

# Действие кнопки "В ГОРОД" по нажатию
func _on_village_pressed():
	change_scene("village", true)

# Функция для смены сцены
func change_scene(new_location, reset_stage=false):
	async_change_scene(new_location, reset_stage)

# Асинхронная функция для смены сцены
func async_change_scene(new_location, reset_stage):
	animation_arena.play("new_animation_2")
	await animation_arena.animation_finished()
	if reset_stage:
		Global.stage_game = 1
	else:
		Global.stage_game += 1
	Global.location = new_location
	get_tree().change_scene_to_file("res://scene/location/" + new_location + ".tscn")
