extends CharacterBody2D
class_name Player

# ЗАГРУЗКА СЦЕН:
# Узел для отображения метки взаимодействия
@onready var InteractLabel = $Interaction/InteractLabel
# Загрузка сцены с лазером
@onready var laser_scene = preload("res://scenes/shot.tscn")

# СИГНАЛЫ:
# Сигнал для выстрела лазером
signal laser_shot(laser_scene, location, target, damage)
# Сигнал для изменения HP
signal HP_change(HP)

# ПЕРЕМЕННЫЕ:
# Константы для ускорения и трения
const accel = 1200
const friction = 1400
# Вектор для движения
var movement_vector = Vector2.ZERO
# Список всех объектов для взаимодействия
var all_interaction = []
# Список всех целей для атаки
var all_target_attack = []
# Текущая цель для атаки
var target = null
# Флаг перезарядки
var shoot_cd = false
# Скорость стрельбы
var rate_of_fire = 0.25
# Урон
var damage = 10
# Очки здоровья
var HP = 100

# ФУНКЦИИ:
# Функция, выполняемая при готовности узла
func _ready():
	pass

# Основная функция процесса
func _process(_delta):
	# Если есть цели для атаки, сортируем их по расстоянию и выбираем ближайшую
	if all_target_attack:
		all_target_attack.sort_custom(_sort_distance)
		target = all_target_attack[0]
		# Проверяем, можно ли стрелять
		if not shoot_cd:
			shoot_cd = true
			shoot()
			# Ждем таймера перед следующим выстрелом
			await get_tree().create_timer(rate_of_fire).timeout
			shoot_cd = false
	# Если здоровье меньше или равно 0, удаляем узел
	if HP <= 0:
		queue_free()

# Функция для физического процесса
func _physics_process(_delta):
	player_movement(_delta)
	# Проверка нажатия кнопки взаимодействия
	if Input.is_action_just_pressed("interact"):
		execute_interaction()
	# Передвижение узла
	move_and_slide()
	# Ограничение передвижения игрока в пределах видимой области
	global_position = global_position.clamp(Vector2.ZERO, get_viewport_rect().size)

# Функция для получения ввода от пользователя
func get_input():
	movement_vector.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	movement_vector.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	return movement_vector.normalized()

# Функция для движения игрока с учетом ускорения и трения
func player_movement(delta):
	movement_vector = get_input()
	if movement_vector == Vector2.ZERO:
		# Если нет ввода, применяем трение для остановки
		if velocity.length() > (friction * delta):
			velocity -= velocity.normalized() * (friction * delta)
		else:
			velocity = Vector2.ZERO
	else:
		# Применяем ускорение для движения
		velocity += (movement_vector * accel * delta)
		velocity = velocity.limit_length(Global.speed_player)

# Функция при входе в область взаимодействия
func _on_interaction_area_area_entered(area):
	all_interaction.insert(0, area)
	update_interaction()

# Функция при выходе из области взаимодействия
func _on_interaction_area_area_exited(area):
	all_interaction.erase(area)
	update_interaction()

# Функция для обновления метки взаимодействия
func update_interaction():
	if all_interaction:
		InteractLabel.text = 'E'
	else:
		InteractLabel.text = ''

# Функция для выполнения взаимодействия
func execute_interaction():
	if all_interaction:
		if all_interaction[0].is_in_group("portal"):
			# Здесь была логика с переменной Controle, теперь просто удаляем её
			pass

# Функция для выстрела
func shoot():
	laser_shot.emit(laser_scene, global_position, target, damage)

# Функция при входе в радиус атаки
func _on_attack_radius_area_entered(area):
	all_target_attack.insert(0, area)

# Функция при выходе из радиуса атаки
func _on_attack_radius_area_exited(area):
	all_target_attack.erase(area)

# Функция для сортировки целей по расстоянию до игрока
func _sort_distance(area1, area2):
	var area1_to_player = global_position.distance_to(area1.global_position)
	var area2_to_player = global_position.distance_to(area2.global_position)
	return area1_to_player < area2_to_player

# Функция для получения урона
func hit(damage_mobs):
	HP -= damage_mobs
	HP_change.emit(HP)
