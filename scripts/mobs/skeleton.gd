extends CharacterBody2D
class_name Mobs

# Переменные
@onready var anim = $AnimatedSprite2D
var speed = 50 + Global.stage_game
var damage_mobs = 1 + Global.stage_game
var hp = 20 + Global.stage_game
var shoot_cd = false
var rate_of_fire = 0.25
var all_target_player = []
var life = true
var players = []

# Сигналы
signal killed

# Основная функция
func _ready():
	# Ищем всех игроков в группе "players"
	players = get_tree().get_nodes_in_group("players")
	if players.size() == 0:
		print("No players found")
	else:
		print("Players found: ", players.size())

# Основная функция физического процесса
func _physics_process(_delta):
	if life:
		walking()
		attack()
	move_and_slide()

# Передвижение моба
func walking():
	if players.size() > 0:
		# Ищем ближайшего игрока
		var nearest_player = null
		var nearest_distance = INF
		for player in players:
			var distance = global_position.distance_to(player.global_position)
			if distance < nearest_distance:
				nearest_distance = distance
				nearest_player = player

		if nearest_player != null:
			var direction = (nearest_player.global_position - global_position).normalized()
			velocity = direction * speed
			anim.flip_h = direction.x < 0
			anim.play("Walk")

# Атака
func attack():
	if all_target_player:
		if not shoot_cd:
			shoot_cd = true
			all_target_player[0].hit(damage_mobs)
			await get_tree().create_timer(rate_of_fire).timeout
			shoot_cd = false

# Обработка получения урона
func hit(damage):
	if life:
		hp -= damage
		if hp <= 0:
			life = false
			anim.play("Death")
			await anim.animation_finished
			emit_signal("killed")
			queue_free()
		else:
			anim.play("Hit")
			await anim.animation_finished

# Обработка входа в зону атаки
func _on_Area2D_body_entered(body):
	if body is Player:
		all_target_player.append(body)

# Обработка выхода из зоны атаки
func _on_Area2D_body_exited(body):
	if body is Player:
		all_target_player.erase(body)
ц
