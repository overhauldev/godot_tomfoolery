extends Area2D

@export var damage : int = 10
@export var flippable_sprite: FlippableSprite

func _ready():
	if flippable_sprite != null:
		for child in get_children():
			flippable_sprite.sprite_flipped.connect(child._on_sprite_flipped)
			child.disabled = true 
			
func _on_body_entered(body):
	if body.has_method("receive_damage"):
		body.receive_damage(damage)
		
