extends CharacterBody2D

signal hp_max_changed(new_hp_max)
signal hp_changed(new_hp)
signal died

const INDICATOR_DAMAGE = preload("res://UI/damage_indicator.tscn")

@export var hp_max: int = 10: set = set_hp_max
@export var hp: int = hp_max: set = set_hp, get = get_hp

@export var receives_knockback: bool = true
@export var knockback_modifier: float = 0.1

@export var receives_dmgIndicator: bool = true
@export var SPEED: int = 300

@onready var sprite = $FlippableSprite2D
@onready var collShape = $CollisionShape2D
@onready var animPlayer = $AnimationPlayer
@onready var hurtBox = $Hurtbox
func get_hp():
	return hp
func set_hp(value):
	if value != hp:
		hp = clamp(value, 0, hp_max)
		emit_signal("hp_changed", hp)
		if hp == 0:
			emit_signal("died")
		
func set_hp_max(value):
	if value != hp_max:
		hp_max = max(0, value)
		emit_signal("hp_max_changed",hp_max)
		self.hp = hp
func _physics_process(delta):
	move()

func move():
	move_and_slide()

func die():
	queue_free()

func receive_damage(base_damage: int):
	self.hp -= base_damage
	return base_damage
	
func receive_knockback(damage_source_pos: Vector2, received_damage: int):
	if receives_knockback:
		var knockback_direction = damage_source_pos.direction_to(self.global_position)
		var knockback_strength = received_damage * knockback_modifier
		var knockback = knockback_direction * knockback_strength
		global_position += knockback

func _on_hurtbox_area_entered(Hitbox):
	var base_damage = receive_damage(Hitbox.damage)
	if Hitbox.is_in_group("Projectile"):
		Hitbox.destroy()
	print(Hitbox.get_parent().name + " dealt ", base_damage )
	print("HP: ", hp)
	receive_knockback(Hitbox.global_position, base_damage)
	spawn_dmgIndicator(base_damage)

func _on_died():
	die()

func spawn_effect(EFFECT: PackedScene, effect_position: Vector2 = global_position):
	if EFFECT:
		var effect = EFFECT.instantiate()
		get_tree().current_scene.add_child(effect)		
		effect.global_position = effect_position
		return effect

func spawn_dmgIndicator(damage: int):
	if receives_dmgIndicator:
		var indicator = spawn_effect(INDICATOR_DAMAGE)
		if indicator:
			indicator.label.text = str(damage)
		
