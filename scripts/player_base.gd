extends "res://scripts/EntityBase.gd"
@onready var animation = $AnimationPlayer
var counter : int = 1
var time : float = 0
var can_move : bool = true:
	set(value):
		can_move = value
		if value == false:
			SPEED = 0 
		else:
			SPEED = 300
var can_hit : bool = true
func _ready():
	print("HEllo")
		
func _physics_process(delta):
	if time > 0:
		time -= delta
	#Movement
	var direction = Input.get_vector("left","right","up","down")
	velocity = direction * SPEED
	
	if velocity.x < 0:
		sprite.flipped = true
	if velocity.x > 0: 
		sprite.flipped = false
	if can_move:
		if velocity.is_zero_approx():
			animation.play("Idle")
		else:
			animation.play("Walk")		
	move_and_slide()
	#Exit game for ease
	if Input.is_action_just_pressed("escape"):
		get_tree().quit()

	
func _input(event):
	if event.is_action_pressed("action_attack") and can_hit == true:
		play_animation("action_attack")
	if event.is_action_pressed("special_attack") and can_hit == true:
		play_animation("special_attack")
	
func play_animation(attack_type):
	can_move = false
	can_hit = false
	if attack_type == "action_attack":
		
		animation.play("Attack" + "0" + str(counter))
		counter += 1
		if counter > 2:
			counter = 1 
	elif attack_type == "special_attack":
		animation.play("Attack03")
		print("Special Attack")
	
func _on_animation_finished(anim_name):
	can_move = true
	can_hit = true
